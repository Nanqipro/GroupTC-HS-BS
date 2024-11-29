#include <cuda_profiler_api.h>
#include <thrust/device_ptr.h>
#include <thrust/functional.h>
#include <thrust/reduce.h>
#include <thrust/sort.h>

#include <string>

#include "approach/GroupTC/tc.h"
#include "comm/comm.h"
#include "comm/constant_comm.h"
#include "comm/cuda_comm.h"
#include "spdlog/spdlog.h"

// 实现一个二分查找，成功返回1，否则返回0
__device__ int tc::approach::GroupTC::bin_search(vertex_t* arr, int len, int val) {
    uint32_t Y;
    int32_t bot = 0;
    int32_t top = len - 1;
    // 中点
    int32_t r;
    while (top >= bot) {

        r = (top + bot) / 2;
        Y = arr[r];

        if (val == Y) {
            return 1;
        }

        if (val < Y) {
            top = r - 1;
        } else {
            bot = r + 1;
        }
    }
    return 0;
}

// 优化后的二分搜索算法--目的是减少分支预测失误以提高性能
__device__ int tc::approach::GroupTC::bin_search_less_branch(vertex_t* arr, int len, int val) {
    // 用于跟踪当前位置
    int ret = 0;

    int halfsize;

    int candidate;
    int temp = len;

    while (temp > 1) {
        halfsize = temp / 2;
        candidate = arr[ret + halfsize];
        ret += (candidate < val) ? halfsize : 0;
        temp -= halfsize;
    }

    ret += (arr[ret] < val);

    return ret < len && arr[ret] == val;
}

__device__ int tc::approach::GroupTC::bin_search_with_offset_and_less_branch(vertex_t* arr, int len, int val, int& offset) {
    int ret = 0;
    int halfsize;
    int candidate;
    int temp = len;
    while (temp > 1) {

        halfsize = temp / 2;

        candidate = arr[ret + halfsize];

        ret += (candidate < val) ? halfsize : 0;
        temp -= halfsize;
    }
    ret += (arr[ret] < val);

    // offset 的作用是用来存储二分查找过程中得到的结果位置，即查找到的元素的索引，或者如果没有找到该元素时，表示它应当插入的位置。
    offset = ret;

    return ret < len && arr[ret] == val;
}

/**
 * @brief 计算GROUP_TC（Triangle Count）的GPU内核函数
 * 
 * 该函数通过遍历边列表，利用共享内存中的哈希表来加速查找二跳邻居节点的过程，从而计算出团的数量
 * 
 * @param src_list 边的源节点数组
 * @param adj_list 邻接表，存储边的目标节点
 * @param beg_pos 每个节点在邻接表中开始位置的索引数组
 * @param edge_count 边的数量
 * @param vertex_count 节点的数量
 * @param GLOBAL_COUNT 用于存储每个线程块计算结果的全局计数器数组
 */
__global__ void tc::approach::GroupTC::grouptc(vertex_t* src_list, vertex_t* adj_list, index_t* beg_pos, uint edge_count, uint vertex_count,
                                               unsigned long long* GLOBAL_COUNT) {
    // 定义共享内存，用于存储块内的哈希表数据
    __shared__ int sh_tb_start[GroupTC_BLOCK_BUCKETNUM]; // 块中存储每个线程的邻接表起点
    __shared__ int sh_tb_len[GroupTC_BLOCK_BUCKETNUM]; // 块中存储每个线程邻接表的长度
    __shared__ int sh_ele_start[GroupTC_BLOCK_BUCKETNUM]; // 块中存储每个线程的二跳邻居的起点
    __shared__ int sh_ele_len[GroupTC_BLOCK_BUCKETNUM]; // 块中存储每个线程的二跳邻居列表长度
    // 定义一个局部变量计数器，用于存储当前块的结果 （每个线程块的计算结果） 
    unsigned long long P_counter = 0;
    // 获取当前线程块的索引 (bid) 和当前线程的索引 (tid)
    int bid = blockIdx.x;
    int tid = threadIdx.x;

    // 以线程块为单位进行处理
    for (int i = bid * GroupTC_BLOCK_BUCKETNUM; i < edge_count; i += gridDim.x * GroupTC_BLOCK_BUCKETNUM) {
        // 检查是否超出边界范围
        if (i + tid < edge_count) {
            // 获取当前边的源节点和目的节点
            vertex_t src = src_list[i + tid];
            vertex_t dst = adj_list[i + tid];

            int temp;

            // 初始化起点和长度，用于一阶邻居和二阶邻居
            int tb_start, tb_len, ele_start, ele_len;

            // i + tid + 1 结合了当前线程块（block）和线程（thread）的索引，保证每个线程都能处理一条唯一的边，并且 +1 的操作避免了自查找。
            // 这个方式的核心在于，每个线程块处理不同的边，并且在块内由每个线程处理不同的边起点，确保每个线程有各自的起始位置，不会发生重复。

            tb_start = i + tid + 1; // 当前线程处理的邻居起点（可通过邻接表偏移调整）
            // tb_start = beg_pos[src];
            tb_len = beg_pos[src + 1] - tb_start;// 当前源节点邻接表的长度
            ele_start = beg_pos[dst]; // 当前目的节点的邻接表起点
            ele_len = beg_pos[dst + 1] - ele_start; // 当前目的节点邻接表的长度

            // 优化处理：如果源节点邻居较少，将源和目的节点的邻接表交换
            if (tb_len * 2 < ele_len) {
                temp = tb_start;
                tb_start = ele_start;
                ele_start = temp;

                temp = tb_len;
                tb_len = ele_len;
                ele_len = temp;
            }


            // 将当前线程的邻接表数据存储到共享内存中
            sh_tb_start[tid] = tb_start;
            sh_tb_len[tid] = tb_len;
            sh_ele_start[tid] = ele_start;
            sh_ele_len[tid] = ele_len;
        }
        __syncthreads();

        // 计算当前线程属于哪个子组（sub-warp），即现在处理哪一块数据
        int now = tid / GroupTC_SUBWARP_SIZE;
        int end = min(edge_count - i, GroupTC_BLOCK_BUCKETNUM);
        int workid = tid % GroupTC_SUBWARP_SIZE;
        int offset = 0;
        int last_now = -1;

        // 获取二跳邻居节点
        int neighbor_degree = sh_ele_len[now];
        while (now < end) {
            // 如果当前一阶邻居节点已被处理完，找下一个一阶邻居节点去处理
            while (now < end && workid >= neighbor_degree) {
                now += GroupTC_WARP_STEP;
                if (now < end) {
                    workid -= neighbor_degree;
                    neighbor_degree = sh_ele_len[now];
                }
            }

            if (now < end) {
                offset = last_now == now ? offset : 0;
                P_counter += tc::approach::GroupTC::bin_search_with_offset_and_less_branch(
                    adj_list + (sh_tb_start[now] + offset), sh_tb_len[now] - offset, adj_list[sh_ele_start[now] + workid], offset);
                last_now = now;
            }
            workid += GroupTC_SUBWARP_SIZE;
        }
        __syncthreads();
    }

    GLOBAL_COUNT[bid * GroupTC_BLOCK_BUCKETNUM + tid] = P_counter;
}

void tc::approach::GroupTC::gpu_run(INIReader& config, GPUGraph& gpu_graph, std::string key_space) {
    std::string file = gpu_graph.input_dir;
    int iteration_count = config.GetInteger(key_space, "iteration_count", 1);
    spdlog::info("Run algorithm {}", key_space);
    spdlog::info("Dataset {}", file);
    spdlog::info("Number of nodes: {0}, number of edges: {1}", gpu_graph.vertex_count, gpu_graph.edge_count);
    int device = config.GetInteger(key_space, "device", 1);
    HRR(cudaSetDevice(device));

    vertex_t* d_src = gpu_graph.src_list;
    vertex_t* d_adj = gpu_graph.adj_list;
    index_t* d_beg_pos = gpu_graph.beg_pos;
    vertex_t vertex_count = gpu_graph.vertex_count;
    vertex_t edge_count = gpu_graph.edge_count;
    int grid_size = NumberOfMPs() * 8;

    double t_start, total_kernel_use = 0;
    uint64_t count;

    unsigned long long* d_results;
    HRR(cudaMalloc(&d_results, grid_size * GroupTC_BLOCK_BUCKETNUM * sizeof(unsigned long long)));

    for (int i = 0; i < iteration_count; i++) {
        HRR(cudaMemset(d_results, 0, grid_size * GroupTC_BLOCK_BUCKETNUM * sizeof(unsigned long long)));

        t_start = wtime();

        tc::approach::GroupTC::grouptc<<<grid_size, GroupTC_BLOCK_BUCKETNUM>>>(d_src, d_adj, d_beg_pos, edge_count, vertex_count, d_results);
        HRR(cudaDeviceSynchronize());

        thrust::device_ptr<unsigned long long> ptr(d_results);
        count = thrust::reduce(ptr, ptr + (grid_size * GroupTC_BLOCK_BUCKETNUM));

        double ee = wtime();
        total_kernel_use += ee - t_start;
        if (i == 0) {
            spdlog::info("Iter 0, kernel use {:.6f} s", total_kernel_use);
            if (ee - t_start > 0.1 && iteration_count != 1) {
                iteration_count = 10;
            }
        }
    }

    // algorithm, dataset, iteration_count, avg compute time/s,
    spdlog::get("GroupTC_file_logger")
        ->info("{0}\t{1}\t{2}\t{3}\t{4:.6f}", "GroupTC", gpu_graph.input_dir, count, iteration_count, total_kernel_use / iteration_count);

    spdlog::info("Iter {0}, avg kernel use {1:.6f} s", iteration_count, total_kernel_use / iteration_count);
    spdlog::info("Triangle count {:d}", count);

    HRR(cudaFree(d_results));
}

void tc::approach::GroupTC::start_up(INIReader& config, GPUGraph& gpu_graph, int argc, char** argv) {
    bool run = config.GetBoolean("comm", "GroupTC", false);
    if (run) {
        size_t free_byte, total_byte, available_byte;
        HRR(cudaMemGetInfo(&free_byte, &total_byte));
        available_byte = total_byte - free_byte;
        spdlog::debug("GroupTC before compute, used memory {:.2f} GB", float(total_byte - free_byte) / MEMORY_G);

        tc::approach::GroupTC::gpu_run(config, gpu_graph);

        HRR(cudaMemGetInfo(&free_byte, &total_byte));
        spdlog::debug("GroupTC after compute, used memory {:.2f} GB", float(total_byte - free_byte) / MEMORY_G);
        if (available_byte != total_byte - free_byte) {
            spdlog::warn("There is GPU memory that is not freed after GroupTC runs.");
        }
    }
}
