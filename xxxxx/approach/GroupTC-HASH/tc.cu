#include <arpa/inet.h>
#include <assert.h>
#include <errno.h>
#include <math.h>
#include <netdb.h>
#include <netinet/in.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/socket.h>
#include <sys/types.h>
#include <unistd.h>

#include <iostream>
#include <iterator>
#include <queue>
#include <set>

#include "../comm/cuda_comm.h"
using namespace std;

struct arguments {
    int edge_count;
    long long count;
    double time;
    int degree;
    int vertices;
};

struct arguments Triangle_count(char input[100], struct arguments args, int threads, int blocks, int chunk_size);

int iterator_count = 100;

int main(int argc, char *argv[]) {
    char *name = argv[1];
    int device = atoi(argv[2]);
    iterator_count = atoi(argv[3]);
    // int N_THREADS = atoi(argv[2]);
    // int N_BLOCKS = atoi(argv[3]);
    // int chunk_size = atoi(argv[4]);
    int N_THREADS = 1024;
    int N_BLOCKS = 1024;
    int chunk_size = 1;
    struct arguments args = {};
    //  call the function
    // long long sum = 0;
    // double time = 0;
    cudaSetDevice(device);
    args = Triangle_count(name, args, N_THREADS, N_BLOCKS, chunk_size);
    // time = args.time;
    // sum = args.count;
    // printf("%s,%d,%d,%lld,%f,%f \n", argv[1], args.vertices, args.edge_count, sum, time, (args.edge_count / time / 1000000000));
    return 0;
}

// #define dynamic
#define static
#define without_combination 0
#define use_static 0

#define BLOCK_SIZE 1024
#define GROUP_SIZE 1024
#define WARP_SIZE 64

#define shared_BLOCK_BUCKET_SIZE 6
#define shared_GROUP_BUCKET_SIZE 4
#define SUM_SIZE 1
#define USE_CTA 100
#define USE_WARP 1

#define block_bucketnum 1024
#define group_bucketnum 1024
#define BLOCK_MODULO 1023
#define GROUP_MODULO 1023

#define EDGE_CHUNK 512
#define shared_CHUNK_CACHE_SIZE 640
#define BLOCK_BUCKET_SIZE 100
#define GROUP_BUCKET_SIZE 100

using namespace std;

__device__ int linear_search_block(int neighbor, int *shared_partition, int *partition, int len, int bin, int BIN_START) {
    for (;;) {
        // int i = bin;
        // int len = bin_count[i];
        // int step = 0;
        // int nowlen;
        // if (len < shared_BLOCK_BUCKET_SIZE)
        //    nowlen = len;
        // else
        //    nowlen = shared_BLOCK_BUCKET_SIZE;
        // while (step < nowlen)
        // {
        //    if (shared_partition[i] == neighbor)
        //    {
        //       return 1;
        //    }
        //    i += block_bucketnum;
        //    step += 1;
        // }

        len -= shared_BLOCK_BUCKET_SIZE;
        int i = bin + BIN_START;
        int step = 0;
        while (step < len) {
            if (partition[i] == neighbor) {
                return 1;
            }
            i += block_bucketnum;
            step += 1;
        }
        if (len + shared_BLOCK_BUCKET_SIZE < 99) break;
        bin++;
    }
    return 0;
}

__device__ int linear_search_group(int neighbor, int *shared_partition, int *partition, int len, int bin, int BIN_START) {
    // int i = bin;
    // int len = bin_count[i];

    // int step = 0;
    // int nowlen = len < shared_GROUP_BUCKET_SIZE ? len : shared_GROUP_BUCKET_SIZE;
    // while (step < nowlen)
    // {
    //    if (shared_partition[i] == neighbor)
    //    {
    //       return 1;
    //    }
    //    i += group_bucketnum;
    //    step += 1;
    // }

    len -= shared_GROUP_BUCKET_SIZE;
    int i = bin + BIN_START;
    int step = 0;
    while (step < len) {
        if (partition[i] == neighbor) {
            return 1;
        }
        i += group_bucketnum;
        step += 1;
    }

    return 0;
}

int my_binary_search(int len, int val, index_t *beg) {
    int l = 0, r = len;
    while (l < r - 1) {
        int mid = (l + r) / 2;
        if (beg[mid + 1] - beg[mid] > val)
            l = mid;
        else
            r = mid;
    }
    if (beg[l + 1] - beg[l] <= val) return -1;
    return l;
}

__global__ void trust_block(vertex_t *src_list, vertex_t *adj_list, index_t *beg_pos, int edge_count, int vertex_count, int *partition,
                            unsigned long long *GLOBAL_COUNT, int T_Group, int *G_INDEX, int CHUNK_SIZE, int warpfirstvertex, int warpfirstedge,
                            int nocomputefirstvertex, int nocomputefirstedge) {
    // hashTable bucket 计数器
    __shared__ int bin_count[block_bucketnum];
    // 共享内存中的 hashTable
    __shared__ int shared_partition[block_bucketnum * shared_BLOCK_BUCKET_SIZE];
    unsigned long long __shared__ G_counter;

    if (threadIdx.x == 0) {
        G_counter = 0;
    }

    int BIN_START = blockIdx.x * block_bucketnum * BLOCK_BUCKET_SIZE;
    unsigned long long P_counter = 0;

    // CTA for large degree vertex
    int vertex = blockIdx.x * CHUNK_SIZE;
    int vertex_end = vertex + CHUNK_SIZE;
    __shared__ int ver;

    while (vertex < warpfirstvertex)
    // while (0)
    {
        // if (degree<=USE_CTA) break;
        int group_start = beg_pos[vertex];
        int end = beg_pos[vertex + 1];
        int now = threadIdx.x + group_start;
        // int MODULO = block_bucketnum - 1;
        // clean bin_count
        // 初始化 hashTable bucket 计数器
        for (int i = threadIdx.x; i < block_bucketnum; i += BLOCK_SIZE) bin_count[i] = 0;
        __syncthreads();

        // count hash bin
        // 生成 hashTable
        while (now < end) {
            int temp = adj_list[now];
            int bin = temp & BLOCK_MODULO;
            int index;
            index = atomicAdd(&bin_count[bin], 1);
            if (index < shared_BLOCK_BUCKET_SIZE) {
                shared_partition[index * block_bucketnum + bin] = temp;
            } else if (index < BLOCK_BUCKET_SIZE) {
                index = index - shared_BLOCK_BUCKET_SIZE;
                partition[index * block_bucketnum + bin + BIN_START] = temp;
            }
            now += blockDim.x;
        }
        __syncthreads();

        // list intersection
        now = beg_pos[vertex];
        end = beg_pos[vertex + 1];
        int superwarp_ID = threadIdx.x / 64;
        int superwarp_TID = threadIdx.x % 64;
        int workid = superwarp_TID;
        now = now + superwarp_ID;
        // 获取二跳邻居节点
        int neighbor = adj_list[now];
        int neighbor_start = beg_pos[neighbor];
        int neighbor_degree = beg_pos[neighbor + 1] - neighbor_start;
        while (now < end) {
            // 如果当前一阶邻居节点已被处理完，找下一个一阶邻居节点去处理
            while (now < end && workid >= neighbor_degree) {
                now += 16;
                workid -= neighbor_degree;
                neighbor = adj_list[now];
                neighbor_start = beg_pos[neighbor];
                neighbor_degree = beg_pos[neighbor + 1] - neighbor_start;
            }
            if (now < end) {
                int temp_adj = adj_list[neighbor_start + workid];
                int bin = temp_adj & BLOCK_MODULO;

                int len = bin_count[bin];

                P_counter += len > 0 ? shared_partition[bin + block_bucketnum * 0] == temp_adj : 0;
                P_counter += len > 1 ? shared_partition[bin + block_bucketnum * 1] == temp_adj : 0;
                P_counter += len > 2 ? shared_partition[bin + block_bucketnum * 2] == temp_adj : 0;
                P_counter += len > 3 ? shared_partition[bin + block_bucketnum * 3] == temp_adj : 0;
                P_counter += len > 4 ? shared_partition[bin + block_bucketnum * 4] == temp_adj : 0;
                P_counter += len > 5 ? shared_partition[bin + block_bucketnum * 5] == temp_adj : 0;

                if (len > shared_BLOCK_BUCKET_SIZE) {
                    P_counter += linear_search_block(temp_adj, shared_partition, partition, len, bin, BIN_START);
                }
            }
            // __syncthreads();
            workid += 64;
        }

        __syncthreads();
        // if (vertex>1) break;
        vertex++;
        if (vertex == vertex_end) {
            if (threadIdx.x == 0) {
                ver = atomicAdd(&G_INDEX[1], CHUNK_SIZE);
            }
            __syncthreads();
            vertex = ver;
            vertex_end = vertex + CHUNK_SIZE;
        }
    }

    // EDGE CHUNK for small degree vertex
    __shared__ int group_start;
    __shared__ int group_size;

    int *shared_src = shared_partition + group_bucketnum * shared_GROUP_BUCKET_SIZE;
    int *shared_adj_start = shared_src + shared_CHUNK_CACHE_SIZE;
    int *shared_adj_degree = shared_adj_start + shared_CHUNK_CACHE_SIZE;

    for (int group_offset = warpfirstedge + blockIdx.x * EDGE_CHUNK; group_offset < nocomputefirstedge; group_offset += gridDim.x * EDGE_CHUNK) {
        // compute group start and end
        if (threadIdx.x == 0) {
            int src = src_list[group_offset];
            int src_start = beg_pos[src];
            int src_end = beg_pos[src + 1];
            group_start = ((src_start == group_offset) ? src_start : src_end);

            src = src_list[min(group_offset + EDGE_CHUNK, nocomputefirstedge) - 1];
            group_size = min(beg_pos[src + 1], (index_t)nocomputefirstedge) - group_start;
        }

        // cache start
        for (int i = threadIdx.x; i < group_bucketnum; i += blockDim.x) bin_count[i] = 0;

        __syncthreads();

        for (int i = threadIdx.x; i < group_size; i += BLOCK_SIZE) {
            int temp_src = src_list[i + group_start];
            int temp_adj = adj_list[i + group_start];

            shared_src[i] = temp_src;
            shared_adj_start[i] = beg_pos[temp_adj];
            shared_adj_degree[i] = beg_pos[temp_adj + 1] - shared_adj_start[i];

            int bin = (temp_src + temp_adj) & GROUP_MODULO;
            int index = atomicAdd(&bin_count[bin], 1);

            if (index < shared_GROUP_BUCKET_SIZE) {
                shared_partition[index * group_bucketnum + bin] = temp_adj;
            } else if (index < GROUP_BUCKET_SIZE) {
                index = index - shared_GROUP_BUCKET_SIZE;
                partition[index * group_bucketnum + bin + BIN_START] = temp_adj;
            }
        }
        __syncthreads();

        // compute 2 hop neighbors
        int now = threadIdx.x / WARP_SIZE;
        int workid = threadIdx.x % WARP_SIZE;

        while (now < group_size) {
            int neighbor_degree = shared_adj_degree[now];
            while (now < group_size && workid >= neighbor_degree) {
                now += BLOCK_SIZE / WARP_SIZE;
                workid -= neighbor_degree;
                neighbor_degree = shared_adj_degree[now];
            }

            if (now < group_size) {
                int temp_src = shared_src[now];
                int temp_adj = adj_list[shared_adj_start[now] + workid];
                int bin = (temp_src + temp_adj) & GROUP_MODULO;
                int len = bin_count[bin];

                P_counter += len > 0 ? shared_partition[bin + group_bucketnum * 0] == temp_adj : 0;
                P_counter += len > 1 ? shared_partition[bin + group_bucketnum * 1] == temp_adj : 0;
                P_counter += len > 2 ? shared_partition[bin + group_bucketnum * 2] == temp_adj : 0;
                P_counter += len > 3 ? shared_partition[bin + group_bucketnum * 3] == temp_adj : 0;

                if (len > shared_GROUP_BUCKET_SIZE) {
                    P_counter += linear_search_group(temp_adj, shared_partition, partition, len, bin, BIN_START);
                }
            }
            workid += WARP_SIZE;
        }
        __syncthreads();
    }

    atomicAdd(&G_counter, P_counter);

    __syncthreads();
    if (threadIdx.x == 0) {
        atomicAdd(&GLOBAL_COUNT[0], G_counter);
    }
}

__global__ void trust_group(vertex_t *src_list, vertex_t *adj_list, index_t *beg_pos, int edge_count, int vertex_count, int *partition,
                            unsigned long long *GLOBAL_COUNT, int T_Group, int *G_INDEX, int CHUNK_SIZE, int warpfirstvertex, int warpfirstedge,
                            int nocomputefirstvertex, int nocomputefirstedge) {
    // hashTable bucket 计数器
    __shared__ int bin_count[group_bucketnum];
    // 共享内存中的 hashTable
    __shared__ int shared_partition[group_bucketnum * shared_BLOCK_BUCKET_SIZE];
    unsigned long long __shared__ G_counter;

    if (threadIdx.x == 0) {
        G_counter = 0;
    }

    int BIN_START = blockIdx.x * group_bucketnum * BLOCK_BUCKET_SIZE;
    unsigned long long P_counter = 0;

    __shared__ int group_start;
    __shared__ int group_size;

    int *shared_src = shared_partition + group_bucketnum * shared_GROUP_BUCKET_SIZE;
    int *shared_adj_start = shared_src + shared_CHUNK_CACHE_SIZE;
    int *shared_adj_degree = shared_adj_start + shared_CHUNK_CACHE_SIZE;

    for (int group_offset = warpfirstedge + blockIdx.x * EDGE_CHUNK; group_offset < nocomputefirstedge; group_offset += gridDim.x * EDGE_CHUNK) {
        // compute group start and end
        if (threadIdx.x == 0) {
            int src = src_list[group_offset];
            int src_start = beg_pos[src];
            int src_end = beg_pos[src + 1];
            group_start = ((src_start == group_offset) ? src_start : src_end);

            src = src_list[min(group_offset + EDGE_CHUNK, nocomputefirstedge) - 1];
            group_size = min(beg_pos[src + 1], (index_t)nocomputefirstedge) - group_start;
        }

        // cache start
        for (int i = threadIdx.x; i < group_bucketnum; i += blockDim.x) bin_count[i] = 0;

        __syncthreads();

        for (int i = threadIdx.x; i < group_size; i += BLOCK_SIZE) {
            int temp_src = src_list[i + group_start];
            int temp_adj = adj_list[i + group_start];

            shared_src[i] = temp_src;
            shared_adj_start[i] = beg_pos[temp_adj];
            shared_adj_degree[i] = beg_pos[temp_adj + 1] - shared_adj_start[i];

            int bin = (temp_src + temp_adj) & GROUP_MODULO;
            int index = atomicAdd(&bin_count[bin], 1);

            if (index < shared_GROUP_BUCKET_SIZE) {
                shared_partition[index * group_bucketnum + bin] = temp_adj;
            } else if (index < GROUP_BUCKET_SIZE) {
                index = index - shared_GROUP_BUCKET_SIZE;
                partition[index * group_bucketnum + bin + BIN_START] = temp_adj;
            }
        }
        __syncthreads();

        // for (int i = threadIdx.x; i < group_bucketnum; i += BLOCK_SIZE)
        // {
        //    if (bin_count[i] == 2)
        //    {
        //       P_counter++;
        //    }
        // }

        // __syncthreads();

        // 获取二跳邻居节点
        int now = threadIdx.x / WARP_SIZE;
        int workid = threadIdx.x % WARP_SIZE;

        while (now < group_size) {
            int neighbor_degree = shared_adj_degree[now];
            while (now < group_size && workid >= neighbor_degree) {
                now += GROUP_SIZE / WARP_SIZE;
                workid -= neighbor_degree;
                neighbor_degree = shared_adj_degree[now];
            }

            if (now < group_size) {
                int temp_src = shared_src[now];
                int temp_adj = adj_list[shared_adj_start[now] + workid];
                int bin = (temp_src + temp_adj) & GROUP_MODULO;
                int len = bin_count[bin];

                P_counter += len > 0 ? shared_partition[bin + group_bucketnum * 0] == temp_adj : 0;
                P_counter += len > 1 ? shared_partition[bin + group_bucketnum * 1] == temp_adj : 0;
                P_counter += len > 2 ? shared_partition[bin + group_bucketnum * 2] == temp_adj : 0;
                P_counter += len > 3 ? shared_partition[bin + group_bucketnum * 3] == temp_adj : 0;

                if (len > shared_GROUP_BUCKET_SIZE) {
                    P_counter += linear_search_group(temp_adj, shared_partition, partition, len, bin, BIN_START);
                }
            }
            workid += WARP_SIZE;
        }
        __syncthreads();
    }

    atomicAdd(&G_counter, P_counter);

    __syncthreads();
    if (threadIdx.x == 0) {
        atomicAdd(&GLOBAL_COUNT[0], G_counter);
    }
}

struct arguments Triangle_count(char name[100], struct arguments args, int n_threads, int n_blocks, int chunk_size) {
    int T_Group = 32;
    int BUCKET_SIZE = 100;
    int total = n_blocks * block_bucketnum * BUCKET_SIZE;
    unsigned long long *counter = (unsigned long long *)malloc(sizeof(unsigned long long) * 10);
    string json_file = name;
    graph *graph_d = new graph(json_file);
    index_t vertex_count = graph_d->vertex_count;
    index_t edge_count = graph_d->edge_count;
    index_t edges = graph_d->edge_count;
    int maxDegree = 0;
    for (int i = 1; i <= graph_d->vertex_count; i++) {
        int degree = graph_d->beg_pos[i] - graph_d->beg_pos[i - 1];
        if (degree > maxDegree) {
            maxDegree = degree;
        }
    }

    cout << "dataset\t" << json_file << endl;
    cout << "Number of nodes: " << vertex_count << ", number of edges: " << edge_count << endl;
    // cout << "load graph file:" << name << "  vCount:" << graph_d->vertex_count << "  eCount:" << graph_d->edge_count << "  maxDegree:" << maxDegree
    // << endl;

    // ofstream outFile("/home/LiJB/cuda_project/TRUST/output/adj_list.txt", ios::out);
    // for (int i = 0; i < vertex_count; i++)
    // {
    //    int start = graph_d->beg_pos[i];
    //    int end = graph_d->beg_pos[i + 1];
    //    for (int j = start; j < end; j++)
    //    {
    //       outFile << i << "  " << graph_d->adj_list[j] << endl;
    //    }
    // }

    /* Preprocessing Step to calculate the ratio */
    int *prefix = (int *)malloc(sizeof(int) * vertex_count);

    int warpfirstvertex = my_binary_search(vertex_count, USE_CTA, graph_d->beg_pos) + 1;
    int warpfirstedge = graph_d->beg_pos[warpfirstvertex];
    int nocomputefirstvertex = my_binary_search(vertex_count, USE_WARP, graph_d->beg_pos) + 1;
    int nocomputefirstedge = graph_d->beg_pos[nocomputefirstvertex];

    printf("warpfirstvertex %d  warpfirstedge %d\n", warpfirstvertex, warpfirstedge);
    printf("nocomputefirstvertex %d  nocomputefirstedge %d\n", nocomputefirstvertex, nocomputefirstedge);

    int *BIN_MEM;
    unsigned long long *GLOBAL_COUNT;
    int *G_INDEX;
    index_t *d_beg_pos;
    vertex_t *d_src_list;
    vertex_t *d_adj_list;
    HRR(cudaMalloc((void **)&GLOBAL_COUNT, sizeof(unsigned long long) * 10));
    HRR(cudaMalloc((void **)&G_INDEX, sizeof(int) * 3));
    HRR(cudaMalloc((void **)&d_beg_pos, sizeof(index_t) * (vertex_count + 1)));
    HRR(cudaMalloc((void **)&d_src_list, sizeof(vertex_t) * (edge_count)));
    HRR(cudaMalloc((void **)&d_adj_list, sizeof(vertex_t) * (edge_count)));
    // Swap edge list count with Eend - estart; --> gives error; may add some more

    int nowindex[3];
    nowindex[0] = chunk_size * n_blocks * n_threads / T_Group;
    nowindex[1] = chunk_size * n_blocks;
    nowindex[2] = warpfirstvertex + chunk_size * (n_blocks * n_threads / T_Group);
    // unsigned long long cou=0;
    // int nowindex=0;

    HRR(cudaMemcpy(G_INDEX, &nowindex, sizeof(int) * 3, cudaMemcpyHostToDevice));
    HRR(cudaMemcpy(d_beg_pos, graph_d->beg_pos, sizeof(index_t) * (vertex_count + 1), cudaMemcpyHostToDevice));
    HRR(cudaMemcpy(d_src_list, graph_d->source_list, sizeof(vertex_t) * edge_count, cudaMemcpyHostToDevice));
    HRR(cudaMemcpy(d_adj_list, graph_d->adj_list, sizeof(vertex_t) * edge_count, cudaMemcpyHostToDevice));
    double t1 = wtime();
    double cmp_time;
    HRR(cudaMalloc((void **)&BIN_MEM, sizeof(int) * total));

    double total_kernel_use = 0;
    double startKernel, ee = 0;
    int block_kernel_grid_size = min(max(warpfirstvertex, 1), n_blocks);
    int group_kernel_grid_size = min((nocomputefirstedge - warpfirstedge) / (EDGE_CHUNK * 10), n_blocks);
    // int block_kernel_grid_size =  n_blocks;
    // int group_kernel_grid_size = n_blocks;

    for (int i = 0; i < iterator_count; i++) {
        HRR(cudaMemcpy(G_INDEX, &nowindex, sizeof(int) * 3, cudaMemcpyHostToDevice));
        double time_start = clock();
        startKernel = wtime();
        cudaMemset(GLOBAL_COUNT, 0, sizeof(unsigned long long) * 10);
        // trust<<<n_blocks, n_threads>>>(d_src_list, d_adj_list, d_beg_pos, edge_count, vertex_count, BIN_MEM, GLOBAL_COUNT, BUCKET_SIZE, T_Group,
        // G_INDEX, chunk_size, warpfirstvertex, warpfirstedge, nocomputefirstvertex, nocomputefirstedge);
        trust_block<<<group_kernel_grid_size, BLOCK_SIZE>>>(d_src_list, d_adj_list, d_beg_pos, edge_count, vertex_count, BIN_MEM, GLOBAL_COUNT,
                                                            T_Group, G_INDEX, chunk_size, warpfirstvertex, warpfirstedge, nocomputefirstvertex,
                                                            nocomputefirstedge);
        // HRR(cudaDeviceSynchronize());
        // trust_group<<<group_kernel_grid_size, GROUP_SIZE>>>(d_src_list, d_adj_list, d_beg_pos, edge_count, vertex_count, BIN_MEM, GLOBAL_COUNT,
        // T_Group, G_INDEX, chunk_size, warpfirstvertex, warpfirstedge, nocomputefirstvertex, nocomputefirstedge);
        HRR(cudaDeviceSynchronize());
        HRR(cudaGetLastError());
        ee = wtime();
        total_kernel_use += ee - startKernel;
        if (i == 0) {
            if (ee - startKernel > 0.1 && iterator_count != 1) {
                iterator_count = 10;
            }
        }
        // cout << "kernel use " << ee - startKernel << endl;
        cmp_time = clock() - time_start;
    }

    // HRR(cudaFree(BIN_MEM));
    cmp_time = cmp_time / CLOCKS_PER_SEC;
    HRR(cudaFree(BIN_MEM));

    HRR(cudaMemcpy(counter, GLOBAL_COUNT, sizeof(unsigned long long) * 10, cudaMemcpyDeviceToHost));
    printf("iter %d, avg kernel use %lf s\n", iterator_count, total_kernel_use / iterator_count);
    printf("triangle count %lld \n\n", counter[0]);
    // printf("xxx %lld \n\n", counter[1]);
    // cout << "total triangle count: " << counter[0] << endl
    //      << endl;
    // printf("avg kernel use %lf s\n\n", total_kernel_use / iterator_count);
    HRR(cudaFree(GLOBAL_COUNT));
    HRR(cudaFree(G_INDEX));
    HRR(cudaFree(d_beg_pos));
    HRR(cudaFree(d_src_list));
    HRR(cudaFree(d_adj_list));
    free(prefix);
    delete graph_d;
    args.time = cmp_time;
    args.count = counter[0];

    args.edge_count = edges;
    args.degree = edges / vertex_count;
    args.vertices = vertex_count;
    return args;
}
