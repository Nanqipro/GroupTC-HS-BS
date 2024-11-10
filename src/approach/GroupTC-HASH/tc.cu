#include <cuda_profiler_api.h>
#include <thrust/device_ptr.h>
#include <thrust/functional.h>
#include <thrust/reduce.h>
#include <thrust/sort.h>

#include <string>

#include "approach/GroupTC-HASH/tc.h"
#include "comm/comm.h"
#include "comm/constant_comm.h"
#include "comm/cuda_comm.h"
#include "spdlog/spdlog.h"

__device__ int tc::approach::GroupTC_HASH::linear_search_block(int neighbor, int *partition, int len, int bin, int BIN_START) {
    for (;;) {
        len -= GroupTC_HASH_shared_BLOCK_BUCKET_SIZE;
        int i = bin + BIN_START;
        int step = 0;
        while (step < len) {
            if (partition[i] == neighbor) {
                return 1;
            }
            i += GroupTC_HASH_block_bucketnum;
            step += 1;
        }
        if (len + GroupTC_HASH_shared_BLOCK_BUCKET_SIZE < 99) break;
        bin++;
    }
    return 0;
}

__device__ int tc::approach::GroupTC_HASH::linear_search_group(int neighbor, int *partition, int len, int bin, int BIN_START) {
    len -= GroupTC_HASH_shared_GROUP_BUCKET_SIZE;
    int i = bin + BIN_START;
    int step = 0;
    while (step < len) {
        if (partition[i] == neighbor) {
            return 1;
        }
        i += GroupTC_HASH_group_bucketnum;
        step += 1;
    }

    return 0;
}

int tc::approach::GroupTC_HASH::my_binary_search(int len, int val, index_t *beg) {
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

__global__ void tc::approach::GroupTC_HASH::grouptc_hash(vertex_t *src_list, vertex_t *adj_list, index_t *beg_pos, uint edge_count, uint vertex_count,
                                                         int *partition, unsigned long long *GLOBAL_COUNT, int T_Group, int *G_INDEX, int CHUNK_SIZE,
                                                         int warpfirstvertex, int warpfirstedge, int nocomputefirstvertex, int nocomputefirstedge) {
    // hashTable bucket 计数器
    __shared__ int bin_count[GroupTC_HASH_block_bucketnum];
    // 共享内存中的 hashTable
    __shared__ int shared_partition[GroupTC_HASH_block_bucketnum * GroupTC_HASH_shared_BLOCK_BUCKET_SIZE];
    unsigned long long __shared__ G_counter;

    if (threadIdx.x == 0) {
        G_counter = 0;
    }

    int BIN_START = blockIdx.x * GroupTC_HASH_block_bucketnum * GroupTC_HASH_BLOCK_BUCKET_SIZE;
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
        // int MODULO = GroupTC_HASH_block_bucketnum - 1;
        // clean bin_count
        // 初始化 hashTable bucket 计数器
        for (int i = threadIdx.x; i < GroupTC_HASH_block_bucketnum; i += GroupTC_HASH_BLOCK_SIZE) bin_count[i] = 0;
        __syncthreads();

        // count hash bin
        // 生成 hashTable
        while (now < end) {
            int temp = adj_list[now];
            int bin = temp & GroupTC_HASH_BLOCK_MODULO;
            int index;
            index = atomicAdd(&bin_count[bin], 1);
            if (index < GroupTC_HASH_shared_BLOCK_BUCKET_SIZE) {
                shared_partition[index * GroupTC_HASH_block_bucketnum + bin] = temp;
            } else if (index < GroupTC_HASH_BLOCK_BUCKET_SIZE) {
                index = index - GroupTC_HASH_shared_BLOCK_BUCKET_SIZE;
                partition[index * GroupTC_HASH_block_bucketnum + bin + BIN_START] = temp;
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
                int bin = temp_adj & GroupTC_HASH_BLOCK_MODULO;

                int len = bin_count[bin];

                P_counter += len > 0 ? shared_partition[bin + GroupTC_HASH_block_bucketnum * 0] == temp_adj : 0;
                P_counter += len > 1 ? shared_partition[bin + GroupTC_HASH_block_bucketnum * 1] == temp_adj : 0;
                P_counter += len > 2 ? shared_partition[bin + GroupTC_HASH_block_bucketnum * 2] == temp_adj : 0;
                P_counter += len > 3 ? shared_partition[bin + GroupTC_HASH_block_bucketnum * 3] == temp_adj : 0;
                P_counter += len > 4 ? shared_partition[bin + GroupTC_HASH_block_bucketnum * 4] == temp_adj : 0;
                P_counter += len > 5 ? shared_partition[bin + GroupTC_HASH_block_bucketnum * 5] == temp_adj : 0;

                if (len > GroupTC_HASH_shared_BLOCK_BUCKET_SIZE) {
                    P_counter += tc::approach::GroupTC_HASH::linear_search_block(temp_adj, partition, len, bin, BIN_START);
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

    int *shared_src = shared_partition + GroupTC_HASH_group_bucketnum * GroupTC_HASH_shared_GROUP_BUCKET_SIZE;
    int *shared_adj_start = shared_src + GroupTC_HASH_shared_CHUNK_CACHE_SIZE;
    int *shared_adj_degree = shared_adj_start + GroupTC_HASH_shared_CHUNK_CACHE_SIZE;

    for (int group_offset = warpfirstedge + blockIdx.x * GroupTC_HASH_EDGE_CHUNK; group_offset < nocomputefirstedge;
         group_offset += gridDim.x * GroupTC_HASH_EDGE_CHUNK) {
        // compute group start and end
        if (threadIdx.x == 0) {
            int src = src_list[group_offset];
            int src_start = beg_pos[src];
            int src_end = beg_pos[src + 1];
            group_start = ((src_start == group_offset) ? src_start : src_end);

            src = src_list[min(group_offset + GroupTC_HASH_EDGE_CHUNK, nocomputefirstedge) - 1];
            group_size = min(beg_pos[src + 1], (index_t)nocomputefirstedge) - group_start;
        }

        // cache start
        for (int i = threadIdx.x; i < GroupTC_HASH_group_bucketnum; i += blockDim.x) bin_count[i] = 0;

        __syncthreads();

        for (int i = threadIdx.x; i < group_size; i += GroupTC_HASH_BLOCK_SIZE) {
            int temp_src = src_list[i + group_start];
            int temp_adj = adj_list[i + group_start];

            shared_src[i] = temp_src;
            shared_adj_start[i] = beg_pos[temp_adj];
            shared_adj_degree[i] = beg_pos[temp_adj + 1] - shared_adj_start[i];

            int bin = (temp_src + temp_adj) & GroupTC_HASH_GROUP_MODULO;
            int index = atomicAdd(&bin_count[bin], 1);

            if (index < GroupTC_HASH_shared_GROUP_BUCKET_SIZE) {
                shared_partition[index * GroupTC_HASH_group_bucketnum + bin] = temp_adj;
            } else if (index < GroupTC_HASH_GROUP_BUCKET_SIZE) {
                index = index - GroupTC_HASH_shared_GROUP_BUCKET_SIZE;
                partition[index * GroupTC_HASH_group_bucketnum + bin + BIN_START] = temp_adj;
            }
        }
        __syncthreads();

        // compute 2 hop neighbors
        int now = threadIdx.x / GroupTC_HASH_WARP_SIZE;
        int workid = threadIdx.x % GroupTC_HASH_WARP_SIZE;

        while (now < group_size) {
            int neighbor_degree = shared_adj_degree[now];
            while (now < group_size && workid >= neighbor_degree) {
                now += GroupTC_HASH_BLOCK_SIZE / GroupTC_HASH_WARP_SIZE;
                workid -= neighbor_degree;
                neighbor_degree = shared_adj_degree[now];
            }

            if (now < group_size) {
                int temp_src = shared_src[now];
                int temp_adj = adj_list[shared_adj_start[now] + workid];
                int bin = (temp_src + temp_adj) & GroupTC_HASH_GROUP_MODULO;
                int len = bin_count[bin];

                P_counter += len > 0 ? shared_partition[bin + GroupTC_HASH_group_bucketnum * 0] == temp_adj : 0;
                P_counter += len > 1 ? shared_partition[bin + GroupTC_HASH_group_bucketnum * 1] == temp_adj : 0;
                P_counter += len > 2 ? shared_partition[bin + GroupTC_HASH_group_bucketnum * 2] == temp_adj : 0;
                P_counter += len > 3 ? shared_partition[bin + GroupTC_HASH_group_bucketnum * 3] == temp_adj : 0;

                if (len > GroupTC_HASH_shared_GROUP_BUCKET_SIZE) {
                    P_counter += tc::approach::GroupTC_HASH::linear_search_group(temp_adj, partition, len, bin, BIN_START);
                }
            }
            workid += GroupTC_HASH_WARP_SIZE;
        }
        __syncthreads();
    }

    atomicAdd(&G_counter, P_counter);

    __syncthreads();
    if (threadIdx.x == 0) {
        atomicAdd(&GLOBAL_COUNT[0], G_counter);
    }
}

void tc::approach::GroupTC_HASH::gpu_run(INIReader &config, GPUGraph &gpu_graph, std::string key_space) {
    std::string file = gpu_graph.input_dir;
    int iteration_count = config.GetInteger(key_space, "iteration_count", 1);
    spdlog::info("Run algorithm {}", key_space);
    spdlog::info("Dataset {}", file);
    spdlog::info("Number of nodes: {0}, number of edges: {1}", gpu_graph.vertex_count, gpu_graph.edge_count);
    int device = config.GetInteger(key_space, "device", 1);
    HRR(cudaSetDevice(device));

    int grid_size = 1024;
    int block_size = 1024;
    int chunk_size = 1;

    uint vertex_count = gpu_graph.vertex_count;
    uint edge_count = gpu_graph.edge_count;
    index_t *d_beg_pos = gpu_graph.beg_pos;
    vertex_t *d_src_list = gpu_graph.src_list;
    vertex_t *d_adj_list = gpu_graph.adj_list;

    index_t *h_beg_pos = (index_t *)malloc(sizeof(index_t) * (vertex_count + 1));
    HRR(cudaMemcpy(h_beg_pos, gpu_graph.beg_pos, sizeof(index_t) * (vertex_count + 1), cudaMemcpyDeviceToHost));

    int warpfirstvertex = my_binary_search(vertex_count, GroupTC_HASH_USE_CTA, h_beg_pos) + 1;
    int warpfirstedge = h_beg_pos[warpfirstvertex];
    int nocomputefirstvertex = my_binary_search(vertex_count, GroupTC_HASH_USE_WARP, h_beg_pos) + 1;
    int nocomputefirstedge = h_beg_pos[nocomputefirstvertex];

    int T_Group = 32;
    int nowindex[3];
    nowindex[0] = chunk_size * grid_size * block_size / T_Group;
    nowindex[1] = chunk_size * grid_size;
    nowindex[2] = warpfirstvertex + chunk_size * (grid_size * block_size / T_Group);

    int *BIN_MEM;
    unsigned long long *GLOBAL_COUNT;
    int *G_INDEX;

    HRR(cudaMalloc((void **)&BIN_MEM, sizeof(int) * grid_size * GroupTC_HASH_block_bucketnum * GroupTC_HASH_BLOCK_BUCKET_SIZE));
    HRR(cudaMalloc((void **)&GLOBAL_COUNT, sizeof(unsigned long long) * 10));
    HRR(cudaMalloc((void **)&G_INDEX, sizeof(int) * 3));

    HRR(cudaMemcpy(G_INDEX, &nowindex, sizeof(int) * 3, cudaMemcpyHostToDevice));

    unsigned long long *counter = (unsigned long long *)malloc(sizeof(unsigned long long) * 10);

    double total_kernel_use = 0;
    double startKernel, ee = 0;
    int block_kernel_grid_size = min(max(warpfirstvertex, 1), grid_size);
    int group_kernel_grid_size = min((nocomputefirstedge - warpfirstedge) / (GroupTC_HASH_EDGE_CHUNK * 10), grid_size);
    int kernel_grid_size = max(max(block_kernel_grid_size, group_kernel_grid_size), 320);

    spdlog::info("kernel_grid_size {:d}", kernel_grid_size);

    for (int i = 0; i < iteration_count; i++) {
        HRR(cudaMemcpy(G_INDEX, &nowindex, sizeof(int) * 3, cudaMemcpyHostToDevice));
        startKernel = wtime();
        cudaMemset(GLOBAL_COUNT, 0, sizeof(unsigned long long) * 10);
        tc::approach::GroupTC_HASH::grouptc_hash<<<kernel_grid_size, GroupTC_HASH_BLOCK_SIZE>>>(
            d_src_list, d_adj_list, d_beg_pos, edge_count, vertex_count, BIN_MEM, GLOBAL_COUNT, T_Group, G_INDEX, chunk_size, warpfirstvertex,
            warpfirstedge, nocomputefirstvertex, nocomputefirstedge);
        HRR(cudaDeviceSynchronize());

        ee = wtime();
        total_kernel_use += ee - startKernel;
    }

    HRR(cudaMemcpy(counter, GLOBAL_COUNT, sizeof(unsigned long long) * 10, cudaMemcpyDeviceToHost));

    // algorithm, dataset, iteration_count, avg compute time/s,
    spdlog::get("GroupTC-HASH_file_logger")
        ->info("{0}\t{1}\t{2}\t{3}\t{4:.6f}", "GroupTC", gpu_graph.input_dir, counter[0], iteration_count, total_kernel_use / iteration_count);

    spdlog::info("Iter {0}, avg kernel use {1:.6f} s", iteration_count, total_kernel_use / iteration_count);
    spdlog::info("Triangle count {:d}", counter[0]);

    free(counter);
    free(h_beg_pos);
    HRR(cudaFree(BIN_MEM));
    HRR(cudaFree(GLOBAL_COUNT));
    HRR(cudaFree(G_INDEX));
}

void tc::approach::GroupTC_HASH::start_up(INIReader &config, GPUGraph &gpu_graph, int argc, char **argv) {
    bool run = config.GetBoolean("comm", "GroupTC-HASH", false);
    if (run) {
        size_t free_byte, total_byte, available_byte;
        HRR(cudaMemGetInfo(&free_byte, &total_byte));
        available_byte = total_byte - free_byte;
        spdlog::debug("GroupTC_HASH before compute, used memory {:.2f} GB", float(total_byte - free_byte) / MEMORY_G);

        tc::approach::GroupTC_HASH::gpu_run(config, gpu_graph);

        HRR(cudaMemGetInfo(&free_byte, &total_byte));
        spdlog::debug("GroupTC_HASH after compute, used memory {:.2f} GB", float(total_byte - free_byte) / MEMORY_G);
        if (available_byte != total_byte - free_byte) {
            spdlog::warn("There is GPU memory that is not freed after GroupTC_HASH runs.");
        }
    }
}


// // 就是trust和groupTc-hash都按顶点度数把数据集分成了两部分，你可以测一测，他们分别在这两部分上的运行时间
// #include <cuda_profiler_api.h>
// #include <thrust/device_ptr.h>
// #include <thrust/functional.h>
// #include <thrust/reduce.h>
// #include <thrust/sort.h>

// #include <string>

// #include "approach/GroupTC-HASH/tc.h"
// #include "comm/comm.h"
// #include "comm/constant_comm.h"
// #include "comm/cuda_comm.h"
// #include "spdlog/spdlog.h"


// __device__ int tc::approach::GroupTC_HASH::linear_search_block(int neighbor, int *partition, int len, int bin, int BIN_START) {
//     for (;;) {
//         len -= GroupTC_HASH_shared_BLOCK_BUCKET_SIZE;
//         int i = bin + BIN_START;
//         int step = 0;
//         while (step < len) {
//             if (partition[i] == neighbor) {
//                 return 1;
//             }
//             i += GroupTC_HASH_block_bucketnum;
//             step += 1;
//         }
//         if (len + GroupTC_HASH_shared_BLOCK_BUCKET_SIZE < 99) break;
//         bin++;
//     }
//     return 0;
// }

// __device__ int tc::approach::GroupTC_HASH::linear_search_group(int neighbor, int *partition, int len, int bin, int BIN_START) {
//     len -= GroupTC_HASH_shared_GROUP_BUCKET_SIZE;
//     int i = bin + BIN_START;
//     int step = 0;
//     while (step < len) {
//         if (partition[i] == neighbor) {
//             return 1;
//         }
//         i += GroupTC_HASH_group_bucketnum;
//         step += 1;
//     }

//     return 0;
// }

// int tc::approach::GroupTC_HASH::my_binary_search(int len, int val, index_t *beg) {
//     int l = 0, r = len;
//     while (l < r - 1) {
//         int mid = (l + r) / 2;
//         if (beg[mid + 1] - beg[mid] > val)
//             l = mid;
//         else
//             r = mid;
//     }
//     if (beg[l + 1] - beg[l] <= val) return -1;
//     return l;
// }

// // 新的内核函数：处理高度数顶点
// // 加了边界检查的代码
// __global__ void tc::approach::GroupTC_HASH::grouptc_hash_high_degree(
//     vertex_t *src_list, vertex_t *adj_list, index_t *beg_pos, uint edge_count,
//     uint vertex_count, int *partition, unsigned long long *GLOBAL_COUNT, int T_Group,
//     int *G_INDEX, int CHUNK_SIZE, int warpfirstvertex) {

//     // hashTable bucket 计数器
//     __shared__ int bin_count[GroupTC_HASH_block_bucketnum];
//     // 共享内存中的 hashTable
//     __shared__ int shared_partition[GroupTC_HASH_block_bucketnum * GroupTC_HASH_shared_BLOCK_BUCKET_SIZE];

//     unsigned long long __shared__ G_counter;

//     if (threadIdx.x == 0) {
//         G_counter = 0;
//     }

//     int BIN_START = blockIdx.x * GroupTC_HASH_block_bucketnum * GroupTC_HASH_BLOCK_BUCKET_SIZE;
//     unsigned long long P_counter = 0;

//     // CTA for large degree vertex
//     int vertex = blockIdx.x * CHUNK_SIZE;
//     int vertex_end = vertex + CHUNK_SIZE;
//     __shared__ int ver;

//     while (vertex < warpfirstvertex) {
//         int group_start = beg_pos[vertex];
//         int end = beg_pos[vertex + 1];
//         int now = threadIdx.x + group_start;

//         // 初始化 hashTable bucket 计数器
//         for (int i = threadIdx.x; i < GroupTC_HASH_block_bucketnum; i += GroupTC_HASH_BLOCK_SIZE)
//             bin_count[i] = 0;
//         __syncthreads();

//         // 生成 hashTable
//         while (now < end) {
//             int temp = adj_list[now];
//             int bin = temp & GroupTC_HASH_BLOCK_MODULO;
//             int index;
//             index = atomicAdd(&bin_count[bin], 1);

//             if (index < GroupTC_HASH_shared_BLOCK_BUCKET_SIZE) {
//                 int idx = index * GroupTC_HASH_block_bucketnum + bin;
//                 if (idx < GroupTC_HASH_block_bucketnum * GroupTC_HASH_shared_BLOCK_BUCKET_SIZE) {
//                     shared_partition[idx] = temp;
//                 } else {
//                     // 超出 shared_partition 数组范围，处理错误或丢弃数据
//                     // 可以选择记录错误或进行其他处理
//                 }
//             } else if (index < GroupTC_HASH_BLOCK_BUCKET_SIZE) {
//                 index = index - GroupTC_HASH_shared_BLOCK_BUCKET_SIZE;
//                 int idx = index * GroupTC_HASH_block_bucketnum + bin + BIN_START;
//                 int partition_size_per_block = GroupTC_HASH_block_bucketnum * (GroupTC_HASH_BLOCK_BUCKET_SIZE - GroupTC_HASH_shared_BLOCK_BUCKET_SIZE);
//                 if (idx - BIN_START < partition_size_per_block) {
//                     partition[idx] = temp;
//                 } else {
//                     // 超出 partition 数组范围，处理错误或丢弃数据
//                     // 可以选择记录错误或进行其他处理
//                 }
//             }
//             now += blockDim.x;
//         }
//         __syncthreads();

//         // 列表交集计算
//         now = beg_pos[vertex];
//         end = beg_pos[vertex + 1];
//         int superwarp_ID = threadIdx.x / 64;
//         int superwarp_TID = threadIdx.x % 64;
//         int workid = superwarp_TID;
//         now = now + superwarp_ID;

//         while (now < end) {
//             // 获取二跳邻居节点
//             int neighbor = adj_list[now];
//             int neighbor_start = beg_pos[neighbor];
//             int neighbor_degree = beg_pos[neighbor + 1] - neighbor_start;

//             // 如果当前一阶邻居节点已被处理完，找下一个一阶邻居节点
//             while (now < end && workid >= neighbor_degree) {
//                 now += 16;
//                 workid -= neighbor_degree;
//                 if (now < end) {
//                     neighbor = adj_list[now];
//                     neighbor_start = beg_pos[neighbor];
//                     neighbor_degree = beg_pos[neighbor + 1] - neighbor_start;
//                 }
//             }

//             if (now < end && workid < neighbor_degree) {
//                 int temp_adj = adj_list[neighbor_start + workid];
//                 int bin = temp_adj & GroupTC_HASH_BLOCK_MODULO;

//                 int len = bin_count[bin];

//                 // 检查 len 是否大于 0，避免访问越界
//                 if (len > 0) {
//                     int idx0 = bin + GroupTC_HASH_block_bucketnum * 0;
//                     if (idx0 < GroupTC_HASH_block_bucketnum * GroupTC_HASH_shared_BLOCK_BUCKET_SIZE) {
//                         P_counter += shared_partition[idx0] == temp_adj;
//                     }
//                 }
//                 if (len > 1) {
//                     int idx1 = bin + GroupTC_HASH_block_bucketnum * 1;
//                     if (idx1 < GroupTC_HASH_block_bucketnum * GroupTC_HASH_shared_BLOCK_BUCKET_SIZE) {
//                         P_counter += shared_partition[idx1] == temp_adj;
//                     }
//                 }
//                 if (len > 2) {
//                     int idx2 = bin + GroupTC_HASH_block_bucketnum * 2;
//                     if (idx2 < GroupTC_HASH_block_bucketnum * GroupTC_HASH_shared_BLOCK_BUCKET_SIZE) {
//                         P_counter += shared_partition[idx2] == temp_adj;
//                     }
//                 }
//                 if (len > 3) {
//                     int idx3 = bin + GroupTC_HASH_block_bucketnum * 3;
//                     if (idx3 < GroupTC_HASH_block_bucketnum * GroupTC_HASH_shared_BLOCK_BUCKET_SIZE) {
//                         P_counter += shared_partition[idx3] == temp_adj;
//                     }
//                 }
//                 if (len > 4) {
//                     int idx4 = bin + GroupTC_HASH_block_bucketnum * 4;
//                     if (idx4 < GroupTC_HASH_block_bucketnum * GroupTC_HASH_shared_BLOCK_BUCKET_SIZE) {
//                         P_counter += shared_partition[idx4] == temp_adj;
//                     }
//                 }
//                 if (len > 5) {
//                     int idx5 = bin + GroupTC_HASH_block_bucketnum * 5;
//                     if (idx5 < GroupTC_HASH_block_bucketnum * GroupTC_HASH_shared_BLOCK_BUCKET_SIZE) {
//                         P_counter += shared_partition[idx5] == temp_adj;
//                     }
//                 }

//                 if (len > GroupTC_HASH_shared_BLOCK_BUCKET_SIZE) {
//                     P_counter += tc::approach::GroupTC_HASH::linear_search_block(temp_adj, partition, len, bin, BIN_START);
//                 }
//             }
//             workid += 64;
//         }

//         __syncthreads();
//         vertex++;
//         if (vertex == vertex_end) {
//             if (threadIdx.x == 0) {
//                 ver = atomicAdd(&G_INDEX[1], CHUNK_SIZE);
//             }
//             __syncthreads();
//             vertex = ver;
//             vertex_end = vertex + CHUNK_SIZE;
//         }
//     }

//     atomicAdd(&G_counter, P_counter);

//     __syncthreads();
//     if (threadIdx.x == 0) {
//         atomicAdd(&GLOBAL_COUNT[0], G_counter);
//     }
// }


// // 新的内核函数：处理低度数顶点
// // 加了边界检查的代码
// __global__ void tc::approach::GroupTC_HASH::grouptc_hash_low_degree(
//     vertex_t *src_list, vertex_t *adj_list, index_t *beg_pos, uint edge_count,
//     uint vertex_count, int *partition, unsigned long long *GLOBAL_COUNT, int T_Group,
//     int *G_INDEX, int warpfirstedge, int nocomputefirstedge) {

//     extern __shared__ int shared_mem[];

//     int *bin_count = shared_mem;
//     int *shared_partition = bin_count + GroupTC_HASH_group_bucketnum;
//     int *shared_src = shared_partition + GroupTC_HASH_group_bucketnum * GroupTC_HASH_shared_GROUP_BUCKET_SIZE;
//     int *shared_adj_start = shared_src + GroupTC_HASH_shared_CHUNK_CACHE_SIZE;
//     int *shared_adj_degree = shared_adj_start + GroupTC_HASH_shared_CHUNK_CACHE_SIZE;

//     unsigned long long __shared__ G_counter;

//     if (threadIdx.x == 0) {
//         G_counter = 0;
//     }

//     int BIN_START = blockIdx.x * GroupTC_HASH_group_bucketnum * GroupTC_HASH_GROUP_BUCKET_SIZE;
//     unsigned long long P_counter = 0;

//     // EDGE CHUNK for small degree vertex
//     __shared__ int group_start;
//     __shared__ int group_size;

//     for (int group_offset = warpfirstedge + blockIdx.x * GroupTC_HASH_EDGE_CHUNK;
//          group_offset < nocomputefirstedge;
//          group_offset += gridDim.x * GroupTC_HASH_EDGE_CHUNK) {

//         // compute group start and end
//         if (threadIdx.x == 0) {
//             int src = src_list[group_offset];
//             int src_start = beg_pos[src];
//             int src_end = beg_pos[src + 1];
//             group_start = ((src_start == group_offset) ? src_start : src_end);

//             src = src_list[min(group_offset + GroupTC_HASH_EDGE_CHUNK, nocomputefirstedge) - 1];
//             group_size = min(beg_pos[src + 1], (index_t)nocomputefirstedge) - group_start;
//         }

//         // cache start
//         for (int i = threadIdx.x; i < GroupTC_HASH_group_bucketnum; i += blockDim.x)
//             bin_count[i] = 0;

//         __syncthreads();

//         for (int i = threadIdx.x; i < group_size; i += GroupTC_HASH_BLOCK_SIZE) {
//             int temp_src = src_list[i + group_start];
//             int temp_adj = adj_list[i + group_start];

//             shared_src[i] = temp_src;
//             shared_adj_start[i] = beg_pos[temp_adj];
//             shared_adj_degree[i] = beg_pos[temp_adj + 1] - shared_adj_start[i];

//             int bin = (temp_src + temp_adj) & GroupTC_HASH_GROUP_MODULO;
//             int index = atomicAdd(&bin_count[bin], 1);

//             if (index < GroupTC_HASH_shared_GROUP_BUCKET_SIZE) {
//                 int idx = index * GroupTC_HASH_group_bucketnum + bin;
//                 if (idx < GroupTC_HASH_group_bucketnum * GroupTC_HASH_shared_GROUP_BUCKET_SIZE) {
//                     shared_partition[idx] = temp_adj;
//                 } else {
//                     // 超出 shared_partition 数组范围，处理错误或丢弃数据
//                 }
//             } else if (index < GroupTC_HASH_GROUP_BUCKET_SIZE) {
//                 index = index - GroupTC_HASH_shared_GROUP_BUCKET_SIZE;
//                 int idx = index * GroupTC_HASH_group_bucketnum + bin + BIN_START;
//                 int partition_size_per_block = GroupTC_HASH_group_bucketnum * (GroupTC_HASH_GROUP_BUCKET_SIZE - GroupTC_HASH_shared_GROUP_BUCKET_SIZE);
//                 if (idx - BIN_START < partition_size_per_block) {
//                     partition[idx] = temp_adj;
//                 } else {
//                     // 超出 partition 数组范围，处理错误或丢弃数据
//                 }
//             }
//         }
//         __syncthreads();

//         // compute 2 hop neighbors
//         int now = threadIdx.x / GroupTC_HASH_WARP_SIZE;
//         int workid = threadIdx.x % GroupTC_HASH_WARP_SIZE;

//         while (now < group_size) {
//             int neighbor_degree = shared_adj_degree[now];
//             while (now < group_size && workid >= neighbor_degree) {
//                 now += GroupTC_HASH_BLOCK_SIZE / GroupTC_HASH_WARP_SIZE;
//                 workid -= neighbor_degree;
//                 if (now < group_size) {
//                     neighbor_degree = shared_adj_degree[now];
//                 }
//             }

//             if (now < group_size && workid < neighbor_degree) {
//                 int temp_src = shared_src[now];
//                 int temp_adj = adj_list[shared_adj_start[now] + workid];
//                 int bin = (temp_src + temp_adj) & GroupTC_HASH_GROUP_MODULO;
//                 int len = bin_count[bin];

//                 if (len > 0) {
//                     int idx0 = bin + GroupTC_HASH_group_bucketnum * 0;
//                     if (idx0 < GroupTC_HASH_group_bucketnum * GroupTC_HASH_shared_GROUP_BUCKET_SIZE) {
//                         P_counter += shared_partition[idx0] == temp_adj;
//                     }
//                 }
//                 if (len > 1) {
//                     int idx1 = bin + GroupTC_HASH_group_bucketnum * 1;
//                     if (idx1 < GroupTC_HASH_group_bucketnum * GroupTC_HASH_shared_GROUP_BUCKET_SIZE) {
//                         P_counter += shared_partition[idx1] == temp_adj;
//                     }
//                 }
//                 if (len > 2) {
//                     int idx2 = bin + GroupTC_HASH_group_bucketnum * 2;
//                     if (idx2 < GroupTC_HASH_group_bucketnum * GroupTC_HASH_shared_GROUP_BUCKET_SIZE) {
//                         P_counter += shared_partition[idx2] == temp_adj;
//                     }
//                 }
//                 if (len > 3) {
//                     int idx3 = bin + GroupTC_HASH_group_bucketnum * 3;
//                     if (idx3 < GroupTC_HASH_group_bucketnum * GroupTC_HASH_shared_GROUP_BUCKET_SIZE) {
//                         P_counter += shared_partition[idx3] == temp_adj;
//                     }
//                 }

//                 if (len > GroupTC_HASH_shared_GROUP_BUCKET_SIZE) {
//                     P_counter += tc::approach::GroupTC_HASH::linear_search_group(temp_adj, partition, len, bin, BIN_START);
//                 }
//             }
//             workid += GroupTC_HASH_WARP_SIZE;
//         }
//         __syncthreads();
//     }

//     atomicAdd(&G_counter, P_counter);

//     __syncthreads();
//     if (threadIdx.x == 0) {
//         atomicAdd(&GLOBAL_COUNT[0], G_counter);
//     }
// }



// void tc::approach::GroupTC_HASH::gpu_run(INIReader &config, GPUGraph &gpu_graph, std::string key_space) {
//     std::string file = gpu_graph.input_dir;
//     int iteration_count = config.GetInteger(key_space, "iteration_count", 1);
//     spdlog::info("Run algorithm {}", key_space);
//     spdlog::info("Dataset {}", file);
//     spdlog::info("Number of nodes: {0}, number of edges: {1}", gpu_graph.vertex_count, gpu_graph.edge_count);
//     int device = config.GetInteger(key_space, "device", 1);
//     HRR(cudaSetDevice(device));

//     int grid_size = 1024;
//     int block_size = 1024;
//     int chunk_size = 1;

//     uint vertex_count = gpu_graph.vertex_count;
//     uint edge_count = gpu_graph.edge_count;
//     index_t *d_beg_pos = gpu_graph.beg_pos;
//     vertex_t *d_src_list = gpu_graph.src_list;
//     vertex_t *d_adj_list = gpu_graph.adj_list;

//     index_t *h_beg_pos = (index_t *)malloc(sizeof(index_t) * (vertex_count + 1));
//     HRR(cudaMemcpy(h_beg_pos, gpu_graph.beg_pos, sizeof(index_t) * (vertex_count + 1), cudaMemcpyDeviceToHost));

//     int warpfirstvertex = my_binary_search(vertex_count, GroupTC_HASH_USE_CTA, h_beg_pos) + 1;
//     int warpfirstedge = h_beg_pos[warpfirstvertex];
//     int nocomputefirstvertex = my_binary_search(vertex_count, GroupTC_HASH_USE_WARP, h_beg_pos) + 1;
//     int nocomputefirstedge = h_beg_pos[nocomputefirstvertex];

//     int T_Group = 32;
//     int nowindex[3];
//     nowindex[0] = chunk_size * grid_size * block_size / T_Group;
//     nowindex[1] = chunk_size * grid_size;
//     nowindex[2] = warpfirstvertex + chunk_size * (grid_size * block_size / T_Group);

//     int *BIN_MEM;
//     unsigned long long *GLOBAL_COUNT;
//     int *G_INDEX;

//     HRR(cudaMalloc((void **)&BIN_MEM, sizeof(int) * grid_size * GroupTC_HASH_block_bucketnum * GroupTC_HASH_BLOCK_BUCKET_SIZE));
//     HRR(cudaMalloc((void **)&GLOBAL_COUNT, sizeof(unsigned long long) * 10));
//     HRR(cudaMalloc((void **)&G_INDEX, sizeof(int) * 3));

//     HRR(cudaMemcpy(G_INDEX, &nowindex, sizeof(int) * 3, cudaMemcpyHostToDevice));

//     unsigned long long *counter = (unsigned long long *)malloc(sizeof(unsigned long long) * 10);

//     // double total_kernel_use = 0;
//     // double startKernel, ee = 0;
//     int block_kernel_grid_size = min(max(warpfirstvertex, 1), grid_size);
//     int group_kernel_grid_size = min((nocomputefirstedge - warpfirstedge) / (GroupTC_HASH_EDGE_CHUNK * 10), grid_size);
//     int kernel_grid_size = max(max(block_kernel_grid_size, group_kernel_grid_size), 320);

//     spdlog::info("kernel_grid_size {:d}", kernel_grid_size);

//     // 定义 CUDA 事件
//     cudaEvent_t start_high, stop_high;
//     cudaEvent_t start_low, stop_low;
//     cudaEventCreate(&start_high);
//     cudaEventCreate(&stop_high);
//     cudaEventCreate(&start_low);
//     cudaEventCreate(&stop_low);

//     // 计时变量
//     float time_high_degree = 0.0f;
//     float time_low_degree = 0.0f;

//     for (int i = 0; i < iteration_count; i++) {
//         HRR(cudaMemcpy(G_INDEX, &nowindex, sizeof(int) * 3, cudaMemcpyHostToDevice));
//         cudaMemset(GLOBAL_COUNT, 0, sizeof(unsigned long long) * 10);


//          // 如果需要，计算高度数顶点处理内核的共享内存大小
//         size_t shared_memory_size_high = sizeof(int) * (
//             GroupTC_HASH_block_bucketnum +  // bin_count
//             GroupTC_HASH_block_bucketnum * GroupTC_HASH_shared_BLOCK_BUCKET_SIZE  // shared_partition
//             // 如果还有其他共享内存数组，继续累加
//         );
//         // 调用高度数顶点处理内核并计时
//         // cudaEventRecord(start_high, 0);
//         // tc::approach::GroupTC_HASH::grouptc_hash_high_degree<<<block_kernel_grid_size, GroupTC_HASH_BLOCK_SIZE>>>(
//         //     d_src_list, d_adj_list, d_beg_pos, edge_count, vertex_count, BIN_MEM, GLOBAL_COUNT, T_Group, G_INDEX, chunk_size, warpfirstvertex);
//         // cudaEventRecord(stop_high, 0);
//         // cudaEventSynchronize(stop_high);
//         // float time_temp_high = 0.0f;
//         // cudaEventElapsedTime(&time_temp_high, start_high, stop_high);
//         // time_high_degree += time_temp_high;
//         cudaEventRecord(start_high, 0);
//         tc::approach::GroupTC_HASH::grouptc_hash_high_degree<<<block_kernel_grid_size, GroupTC_HASH_BLOCK_SIZE, shared_memory_size_high>>>(
//             d_src_list, d_adj_list, d_beg_pos, edge_count, vertex_count, BIN_MEM, GLOBAL_COUNT, T_Group, G_INDEX, chunk_size, warpfirstvertex);
//         cudaEventRecord(stop_high, 0);
//         cudaEventSynchronize(stop_high);
//         float time_temp_high = 0.0f;
//         cudaEventElapsedTime(&time_temp_high, start_high, stop_high);
//         time_high_degree += time_temp_high;

//         // 调用低度数顶点处理内核并计时
//         // cudaEventRecord(start_low, 0);
//         // tc::approach::GroupTC_HASH::grouptc_hash_low_degree<<<group_kernel_grid_size, GroupTC_HASH_BLOCK_SIZE>>>(
//         //     d_src_list, d_adj_list, d_beg_pos, edge_count, vertex_count, BIN_MEM, GLOBAL_COUNT, T_Group, G_INDEX, warpfirstedge, nocomputefirstedge);
//         // cudaEventRecord(stop_low, 0);
//         // cudaEventSynchronize(stop_low);
//         // float time_temp_low = 0.0f;
//         // cudaEventElapsedTime(&time_temp_low, start_low, stop_low);
//         // time_low_degree += time_temp_low;
//         // 计算共享内存大小
//         size_t shared_memory_size_low = sizeof(int) * (
//             GroupTC_HASH_group_bucketnum +  // bin_count
//             GroupTC_HASH_group_bucketnum * GroupTC_HASH_shared_GROUP_BUCKET_SIZE +  // shared_partition
//             GroupTC_HASH_shared_CHUNK_CACHE_SIZE * 3  // shared_src, shared_adj_start, shared_adj_degree
//         );
//         cudaEventRecord(start_low, 0);
//         tc::approach::GroupTC_HASH::grouptc_hash_low_degree<<<group_kernel_grid_size, GroupTC_HASH_BLOCK_SIZE, shared_memory_size_low>>>(
//             d_src_list, d_adj_list, d_beg_pos, edge_count, vertex_count, BIN_MEM, GLOBAL_COUNT, T_Group, G_INDEX, warpfirstedge, nocomputefirstedge);
//         cudaEventRecord(stop_low, 0);
//         cudaEventSynchronize(stop_low);
//         float time_temp_low = 0.0f;
//         cudaEventElapsedTime(&time_temp_low, start_low, stop_low);
//         time_low_degree += time_temp_low;


//     }

//     // 计算平均时间
//     time_high_degree /= iteration_count;
//     time_low_degree /= iteration_count;

//     // 输出时间
//     spdlog::info("High degree vertices processing time: {:.6f} ms", time_high_degree);
//     spdlog::info("Low degree vertices processing time: {:.6f} ms", time_low_degree);

//     HRR(cudaMemcpy(counter, GLOBAL_COUNT, sizeof(unsigned long long) * 10, cudaMemcpyDeviceToHost));

//     // 记录日志
//     spdlog::get("GroupTC-HASH_file_logger")
//         ->info("{0}\t{1}\t{2}\t{3}\t{4:.6f}\t{5:.6f}\t{6:.6f}", "GroupTC-HASH", gpu_graph.input_dir, counter[0], iteration_count,
//                (time_high_degree + time_low_degree) / 1000.0, time_high_degree / 1000.0, time_low_degree / 1000.0);

//     spdlog::info("Iter {0}, total kernel time {1:.6f} s", iteration_count, (time_high_degree + time_low_degree) / 1000.0);
//     spdlog::info("Triangle count {:d}", counter[0]);

//     free(counter);
//     free(h_beg_pos);
//     HRR(cudaFree(BIN_MEM));
//     HRR(cudaFree(GLOBAL_COUNT));
//     HRR(cudaFree(G_INDEX));

//     // 销毁 CUDA 事件
//     cudaEventDestroy(start_high);
//     cudaEventDestroy(stop_high);
//     cudaEventDestroy(start_low);
//     cudaEventDestroy(stop_low);
// }

// void tc::approach::GroupTC_HASH::start_up(INIReader &config, GPUGraph &gpu_graph, int argc, char **argv) {
//     bool run = config.GetBoolean("comm", "GroupTC-HASH", false);
//     if (run) {
//         size_t free_byte, total_byte, available_byte;
//         HRR(cudaMemGetInfo(&free_byte, &total_byte));
//         available_byte = total_byte - free_byte;
//         spdlog::debug("GroupTC_HASH before compute, used memory {:.2f} GB", float(total_byte - free_byte) / MEMORY_G);

//         tc::approach::GroupTC_HASH::gpu_run(config, gpu_graph);

//         HRR(cudaMemGetInfo(&free_byte, &total_byte));
//         spdlog::debug("GroupTC_HASH after compute, used memory {:.2f} GB", float(total_byte - free_byte) / MEMORY_G);
//         if (available_byte != total_byte - free_byte) {
//             spdlog::warn("There is GPU memory that is not freed after GroupTC_HASH runs.");
//         }
//     }
// }
