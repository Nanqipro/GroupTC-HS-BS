#include <cuda_profiler_api.h>
#include <thrust/device_ptr.h>
#include <thrust/functional.h>
#include <thrust/reduce.h>
#include <thrust/sort.h>

#include <string>

#include "approach/GroupTC-HASH-V2/tc.h"
#include "comm/comm.h"
#include "comm/constant_comm.h"
#include "comm/cuda_comm.h"
#include "spdlog/spdlog.h"

typedef struct longint2 {
    long long int x, y;  // 两个 long 类型的成员
} longint2;

__device__ int tc::approach::GroupTC_HASH_V2::linear_search_block(int neighbor, int *partition, int len, int bin, int BIN_START) {
    for (;;) {
        len -= GroupTC_HASH_V2_shared_BLOCK_BUCKET_SIZE;
        int i = bin + BIN_START;
        int step = 0;
        while (step < len) {
            if (partition[i] == neighbor) {
                return 1;
            }
            i += GroupTC_HASH_V2_block_bucketnum;
            step += 1;
        }
        if (len + GroupTC_HASH_V2_shared_BLOCK_BUCKET_SIZE < 99) break;
        bin++;
    }
    return 0;
}

__device__ int tc::approach::GroupTC_HASH_V2::linear_search_group(int neighbor, int *partition, int len, int bin, int BIN_START) {
    len -= GroupTC_HASH_V2_shared_GROUP_BUCKET_SIZE;
    int i = bin + BIN_START;
    int step = 0;
    while (step < len) {
        if (partition[i] == neighbor) {
            return 1;
        }
        i += GroupTC_HASH_V2_group_bucketnum;
        step += 1;
    }

    return 0;
}

int tc::approach::GroupTC_HASH_V2::my_binary_search(int len, int val, index_t *beg) {
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

template <const int GroupTC_HASH_V2_Group_SUBWARP_SIZE, const int GroupTC_HASH_V2_Group_WARP_STEP, const int CHUNK_SIZE>
__global__ void tc::approach::GroupTC_HASH_V2::grouptc_hash_v2(vertex_t *src_list, vertex_t *adj_list, index_t *beg_pos, uint edge_count,
                                                               uint vertex_count, int *partition, unsigned long long *GLOBAL_COUNT, int T_Group,
                                                               int *G_INDEX, int warpfirstvertex, int warpfirstedge, int nocomputefirstvertex,
                                                               int nocomputefirstedge) {
    // hashTable bucket 计数器
    __shared__ int bin_count[GroupTC_HASH_V2_block_bucketnum];
    // 共享内存中的 hashTable
    __shared__ int shared_partition[GroupTC_HASH_V2_block_bucketnum * GroupTC_HASH_V2_shared_BLOCK_BUCKET_SIZE];

    //__shared__ unsigned int bloom_filter[GroupTC_HASH_V2_block_bucketnum];

    int BIN_START = blockIdx.x * GroupTC_HASH_V2_block_bucketnum * GroupTC_HASH_V2_BLOCK_BUCKET_SIZE;
    unsigned long long P_counter = 0;

    int __shared__ vertex;

    if (threadIdx.x == 0) {
        vertex = blockIdx.x;
    }
    __syncthreads();

    // unsigned int* bloom_filter = reinterpret_cast<unsigned int*>(shared_partition +
    // GroupTC_HASH_V2_block_bucketnum*GroupTC_HASH_V2_shared_BLOCK_BUCKET_SIZE);

    while (vertex < warpfirstvertex) {
        // while (0) {
        // if (degree<=USE_CTA) break;
        int group_start = beg_pos[vertex];
        int end = beg_pos[vertex + 1];
        int now = threadIdx.x + group_start;
        // int MODULO = GroupTC_HASH_V2_block_bucketnum - 1;

        // clean bin_count
        // for (int i = threadIdx.x; i < GroupTC_HASH_V2_block_bucketnum; i += GroupTC_HASH_V2_BLOCK_SIZE){
        bin_count[threadIdx.x] = 0;
        // bloom_filter[threadIdx.x] = 0;
        // }
        __syncthreads();

        // count hash bin
        // 生成 hashTable
        while (now < end) {
            int temp = adj_list[now];

            // insert bloom filter
            // unsigned int index = temp & GroupTC_HASH_V2_BLOOM_FILTER_SIZE;
            // atomicOr(&bloom_filter[index / 32], 1 << (index % 32));

            // insert hash table
            int bin = temp & GroupTC_HASH_V2_BLOCK_MODULO;
            unsigned int index = atomicAdd(&bin_count[bin], 1);
            if (index < GroupTC_HASH_V2_shared_BLOCK_BUCKET_SIZE) {
                shared_partition[index * GroupTC_HASH_V2_block_bucketnum + bin] = temp;
            } else if (index < GroupTC_HASH_V2_BLOCK_BUCKET_SIZE) {
                index = index - GroupTC_HASH_V2_shared_BLOCK_BUCKET_SIZE;
                partition[index * GroupTC_HASH_V2_block_bucketnum + bin + BIN_START] = temp;
            }
            now += blockDim.x;
        }
        __syncthreads();

        if (1) {
            // list intersection
            now = beg_pos[vertex];
            end = beg_pos[vertex + 1];
            int superwarp_ID = threadIdx.x / GroupTC_HASH_V2_CTA_WARP_SIZE;
            int superwarp_TID = threadIdx.x % GroupTC_HASH_V2_CTA_WARP_SIZE;
            int workid = superwarp_TID;
            now = now + superwarp_ID;
            // 获取二跳邻居节点
            int neighbor = adj_list[now];
            int neighbor_start = beg_pos[neighbor];
            int neighbor_degree = beg_pos[neighbor + 1] - neighbor_start;
            while (now < end) {
                // 如果当前一阶邻居节点已被处理完，找下一个一阶邻居节点去处理
                while (now < end && workid >= neighbor_degree) {
                    now += GroupTC_HASH_V2_BLOCK_SIZE / GroupTC_HASH_V2_CTA_WARP_SIZE;
                    workid -= neighbor_degree;
                    neighbor = adj_list[now];
                    neighbor_start = beg_pos[neighbor];
                    neighbor_degree = beg_pos[neighbor + 1] - neighbor_start;
                }
                if (now < end) {
                    int temp_adj = adj_list[neighbor_start + workid];

                    // unsigned int index = temp_adj & GroupTC_HASH_V2_BLOOM_FILTER_SIZE;

                    // bloom filter check
                    // if ((bloom_filter[index / 32] & (1 << (index % 32))) != 0) {

                    int bin = temp_adj & GroupTC_HASH_V2_BLOCK_MODULO;

                    int len = bin_count[bin];

                    P_counter += len > 0 && shared_partition[bin + GroupTC_HASH_V2_block_bucketnum * 0] == temp_adj;
                    P_counter += len > 1 && shared_partition[bin + GroupTC_HASH_V2_block_bucketnum * 1] == temp_adj;
                    P_counter += len > 2 && shared_partition[bin + GroupTC_HASH_V2_block_bucketnum * 2] == temp_adj;
                    P_counter += len > 3 && shared_partition[bin + GroupTC_HASH_V2_block_bucketnum * 3] == temp_adj;
                    P_counter += len > 4 && shared_partition[bin + GroupTC_HASH_V2_block_bucketnum * 4] == temp_adj;
                    P_counter += len > 5 && shared_partition[bin + GroupTC_HASH_V2_block_bucketnum * 5] == temp_adj;

                    if (len > GroupTC_HASH_V2_shared_BLOCK_BUCKET_SIZE) {
                        P_counter += tc::approach::GroupTC_HASH_V2::linear_search_block(temp_adj, partition, len, bin, BIN_START);
                    }
                    // }
                }
                // __syncthreads();
                workid += GroupTC_HASH_V2_CTA_WARP_SIZE;
            }
        }

        __syncthreads();
        if (threadIdx.x == 0) {
            vertex = atomicAdd(&G_INDEX[1], CHUNK_SIZE);
        }
        __syncthreads();
    }

    // EDGE CHUNK for small degree vertex
    __shared__ int group_start;
    __shared__ int group_size;

    int *shared_src = shared_partition + GroupTC_HASH_V2_group_bucketnum * GroupTC_HASH_V2_shared_GROUP_BUCKET_SIZE;
    int *shared_adj_start = shared_src + GroupTC_HASH_V2_shared_CHUNK_CACHE_SIZE;
    int *shared_adj_degree = shared_adj_start + GroupTC_HASH_V2_shared_CHUNK_CACHE_SIZE;

    if (1) {
        for (int group_offset = warpfirstedge + blockIdx.x * GroupTC_HASH_V2_EDGE_CHUNK; group_offset < nocomputefirstedge;
             group_offset += gridDim.x * GroupTC_HASH_V2_EDGE_CHUNK) {
            // compute group start and end
            if (threadIdx.x == 0) {
                int src = src_list[group_offset];
                int src_start = beg_pos[src];
                int src_end = beg_pos[src + 1];
                group_start = ((src_start == group_offset) ? src_start : src_end);

                src = src_list[min(group_offset + GroupTC_HASH_V2_EDGE_CHUNK, nocomputefirstedge) - 1];
                group_size = min(beg_pos[src + 1], (index_t)nocomputefirstedge) - group_start;
            }

            // cache start
            for (int i = threadIdx.x; i < GroupTC_HASH_V2_group_bucketnum; i += blockDim.x) bin_count[i] = 0;

            __syncthreads();

            for (int i = threadIdx.x; i < group_size; i += GroupTC_HASH_V2_BLOCK_SIZE) {
                int temp_src = src_list[i + group_start];
                int temp_adj = adj_list[i + group_start];

                longint2 *point_int2 = reinterpret_cast<longint2 *>(beg_pos + temp_adj);
                longint2 pos2 = *point_int2;
                shared_src[i] = temp_src;
                shared_adj_start[i] = pos2.x;
                shared_adj_degree[i] = pos2.y - pos2.x;

                // if (shared_adj_start[i] != beg_pos[temp_adj]) {
                //     printf("shared_adj_start[%d] = %d, beg_pos[%d] = %d\n", i, shared_adj_start[i], temp_adj, beg_pos[temp_adj]);
                // }
                // if(shared_adj_degree[i] != beg_pos[temp_adj + 1] - shared_adj_start[i]) {
                //     printf("shared_adj_degree[%d] = %d, beg_pos[%d + 1] - shared_adj_start[%d] = %d\n", i, shared_adj_degree[i], temp_adj,
                //     temp_adj, beg_pos[temp_adj + 1] - shared_adj_start[i]);
                // }

                // shared_src[i] = temp_src;
                // shared_adj_start[i] = beg_pos[temp_adj];
                // shared_adj_degree[i] = beg_pos[temp_adj + 1] - shared_adj_start[i];

                int bin = (temp_src + temp_adj) & GroupTC_HASH_V2_GROUP_MODULO;
                int index = atomicAdd(&bin_count[bin], 1);

                if (index < GroupTC_HASH_V2_shared_GROUP_BUCKET_SIZE) {
                    shared_partition[index * GroupTC_HASH_V2_group_bucketnum + bin] = temp_adj;
                } else if (index < GroupTC_HASH_V2_GROUP_BUCKET_SIZE) {
                    index = index - GroupTC_HASH_V2_shared_GROUP_BUCKET_SIZE;
                    partition[index * GroupTC_HASH_V2_group_bucketnum + bin + BIN_START] = temp_adj;
                }
            }
            __syncthreads();

            if (1) {
                // compute 2 hop neighbors
                int now = threadIdx.x / GroupTC_HASH_V2_Group_SUBWARP_SIZE;
                int workid = threadIdx.x % GroupTC_HASH_V2_Group_SUBWARP_SIZE;

                while (now < group_size) {
                    int neighbor_degree = shared_adj_degree[now];
                    while (now < group_size && workid >= neighbor_degree) {
                        now += GroupTC_HASH_V2_BLOCK_SIZE / GroupTC_HASH_V2_Group_SUBWARP_SIZE;
                        workid -= neighbor_degree;
                        neighbor_degree = shared_adj_degree[now];
                    }

                    if (now < group_size) {
                        int temp_src = shared_src[now];
                        int temp_adj = adj_list[shared_adj_start[now] + workid];
                        int bin = (temp_src + temp_adj) & GroupTC_HASH_V2_GROUP_MODULO;
                        int len = bin_count[bin];

                        P_counter += len > 0 && shared_partition[bin + GroupTC_HASH_V2_group_bucketnum * 0] == temp_adj;
                        P_counter += len > 1 && shared_partition[bin + GroupTC_HASH_V2_group_bucketnum * 1] == temp_adj;
                        P_counter += len > 2 && shared_partition[bin + GroupTC_HASH_V2_group_bucketnum * 2] == temp_adj;
                        P_counter += len > 3 && shared_partition[bin + GroupTC_HASH_V2_group_bucketnum * 3] == temp_adj;

                        if (len > GroupTC_HASH_V2_shared_GROUP_BUCKET_SIZE) {
                            P_counter += tc::approach::GroupTC_HASH_V2::linear_search_group(temp_adj, partition, len, bin, BIN_START);
                        }
                    }
                    workid += GroupTC_HASH_V2_Group_SUBWARP_SIZE;
                }
            }

            __syncthreads();
        }
    }

    GLOBAL_COUNT[blockIdx.x * blockDim.x + threadIdx.x] = P_counter;
}

void tc::approach::GroupTC_HASH_V2::gpu_run(INIReader &config, GPUGraph &gpu_graph, std::string key_space) {
    std::string file = gpu_graph.input_dir;
    int iteration_count = config.GetInteger(key_space, "iteration_count", 1);
    spdlog::info("Run algorithm {}", key_space);
    spdlog::info("Dataset {}", file);
    spdlog::info("Number of nodes: {0}, number of edges: {1}", gpu_graph.vertex_count, gpu_graph.edge_count);
    int device = config.GetInteger(key_space, "device", 1);
    HRR(cudaSetDevice(device));

    int grid_size = 2048;
    int block_size = 1024;
    int chunk_size = 1;

    uint vertex_count = gpu_graph.vertex_count;
    uint edge_count = gpu_graph.edge_count;
    index_t *d_beg_pos = gpu_graph.beg_pos;
    vertex_t *d_src_list = gpu_graph.src_list;
    vertex_t *d_adj_list = gpu_graph.adj_list;

    index_t *h_beg_pos = (index_t *)malloc(sizeof(index_t) * (vertex_count + 1));
    HRR(cudaMemcpy(h_beg_pos, gpu_graph.beg_pos, sizeof(index_t) * (vertex_count + 1), cudaMemcpyDeviceToHost));

    int warpfirstvertex = my_binary_search(vertex_count, GroupTC_HASH_V2_USE_CTA, h_beg_pos) + 1;
    int warpfirstedge = h_beg_pos[warpfirstvertex];
    int nocomputefirstvertex = my_binary_search(vertex_count, GroupTC_HASH_V2_USE_WARP, h_beg_pos) + 1;
    int nocomputefirstedge = h_beg_pos[nocomputefirstvertex];

    int T_Group = 32;
    int nowindex[3];
    nowindex[0] = chunk_size * grid_size * block_size / T_Group;
    nowindex[1] = chunk_size * grid_size;
    nowindex[2] = warpfirstvertex + chunk_size * (grid_size * block_size / T_Group);

    int *BIN_MEM;
    int *G_INDEX;
    unsigned long long *GLOBAL_COUNT;

    HRR(cudaMalloc((void **)&BIN_MEM, sizeof(int) * grid_size * GroupTC_HASH_V2_block_bucketnum * GroupTC_HASH_V2_BLOCK_BUCKET_SIZE));
    HRR(cudaMalloc((void **)&G_INDEX, sizeof(int) * 3));

    HRR(cudaMemcpy(G_INDEX, &nowindex, sizeof(int) * 3, cudaMemcpyHostToDevice));

    double total_kernel_use = 0;
    double startKernel, ee = 0;
    int block_kernel_grid_size = min(max(warpfirstvertex, 1), grid_size);
    int group_kernel_grid_size = min((nocomputefirstedge - warpfirstedge) / (GroupTC_HASH_V2_EDGE_CHUNK * 10), grid_size);
    int kernel_grid_size = max(max(block_kernel_grid_size, group_kernel_grid_size), 320);

    uint64_t count;
    HRR(cudaMalloc((void **)&GLOBAL_COUNT, sizeof(unsigned long long) * kernel_grid_size * GroupTC_HASH_V2_BLOCK_SIZE));
    spdlog::info("kernel_grid_size {:d}", kernel_grid_size);

    for (int i = 0; i < iteration_count; i++) {
        HRR(cudaMemcpy(G_INDEX, &nowindex, sizeof(int) * 3, cudaMemcpyHostToDevice));
        HRR(cudaMemset(GLOBAL_COUNT, 0, sizeof(unsigned long long) * kernel_grid_size * GroupTC_HASH_V2_BLOCK_SIZE));

        startKernel = wtime();
        tc::approach::GroupTC_HASH_V2::grouptc_hash_v2<64, GroupTC_HASH_V2_BLOCK_SIZE / 64, 1><<<kernel_grid_size, GroupTC_HASH_V2_BLOCK_SIZE>>>(
            d_src_list, d_adj_list, d_beg_pos, edge_count, vertex_count, BIN_MEM, GLOBAL_COUNT, T_Group, G_INDEX, warpfirstvertex, warpfirstedge,
            nocomputefirstvertex, nocomputefirstedge);
        HRR(cudaDeviceSynchronize());
        thrust::device_ptr<unsigned long long> ptr(GLOBAL_COUNT);
        count = thrust::reduce(ptr, ptr + (kernel_grid_size * GroupTC_HASH_V2_BLOCK_SIZE));
        ee = wtime();

        total_kernel_use += ee - startKernel;
        if (i == 0) {
            spdlog::info("Iter 0, kernel use {:.6f} s", total_kernel_use);
            if (ee - startKernel > 0.1 && iteration_count != 1) {
                iteration_count = 10;
            }
        }
    }

    // algorithm, dataset, iteration_count, avg compute time/s,
    auto logger = spdlog::get("GroupTC-HASH-V2_file_logger");
    if (logger) {
        logger->info("{0}\t{1}\t{2}\t{3}\t{4:.6f}", "GroupTC-HASH-V2", gpu_graph.input_dir, count, iteration_count, total_kernel_use / iteration_count);
    } else {
        spdlog::warn("Logger 'GroupTC-HASH-V2_file_logger' is not initialized.");
    }

    spdlog::info("Iter {0}, avg kernel use {1:.6f} s", iteration_count, total_kernel_use / iteration_count);
    spdlog::info("Triangle count {:d}", count);

    free(h_beg_pos);
    HRR(cudaFree(BIN_MEM));
    HRR(cudaFree(GLOBAL_COUNT));
    HRR(cudaFree(G_INDEX));
}

void tc::approach::GroupTC_HASH_V2::start_up(INIReader &config, GPUGraph &gpu_graph, int argc, char **argv) {
    bool run = config.GetBoolean("comm", "GroupTC-HASH-V2", false);
    if (run) {
        size_t free_byte, total_byte, available_byte;
        HRR(cudaMemGetInfo(&free_byte, &total_byte));
        available_byte = total_byte - free_byte;
        spdlog::debug("GroupTC_HASH_V2 before compute, used memory {:.2f} GB", float(total_byte - free_byte) / MEMORY_G);

        tc::approach::GroupTC_HASH_V2::gpu_run(config, gpu_graph);

        HRR(cudaMemGetInfo(&free_byte, &total_byte));
        spdlog::debug("GroupTC_HASH_V2 after compute, used memory {:.2f} GB", float(total_byte - free_byte) / MEMORY_G);
        if (available_byte != total_byte - free_byte) {
            spdlog::warn("There is GPU memory that is not freed after GroupTC_HASH_V2 runs.");
        }
    }
}
