#pragma once
#include <cuda_profiler_api.h>
#include <thrust/device_ptr.h>
#include <thrust/functional.h>
#include <thrust/reduce.h>
#include <thrust/sort.h>

#include "comm/comm.h"
#include "graph/gpu_graph.h"

#define GroupTC_OPT_BLOCK_BUCKETNUM 256
// #define GroupTC_OPT_ATOMIC_SUBWARP_SIZE 32
// #define GroupTC_OPT_REDUCE_SUBWARP_SIZE 64
// #define GroupTC_OPT_ATOMIC_WARP_STEP (GroupTC_OPT_BLOCK_BUCKETNUM / GroupTC_OPT_ATOMIC_SUBWARP_SIZE)
// #define GroupTC_OPT_REDUCE_WARP_STEP (GroupTC_OPT_BLOCK_BUCKETNUM / GroupTC_OPT_REDUCE_SUBWARP_SIZE)

namespace tc {
namespace approach {
namespace GroupTC_OPT {

__device__ int bin_search(vertex_t *arr, int len, int val);

__device__ int bin_search_less_branch(vertex_t *arr, int len, int val);

__device__ int bin_search_with_offset_and_less_branch(vertex_t *arr, int len, int val, int &offset);

template<const int GroupTC_OPT_SUBWARP_SIZE, const int GroupTC_OPT_WARP_STEP>
__global__ void grouptc_with_reduce(vertex_t *src_list, vertex_t *adj_list, index_t *beg_pos, uint edge_count, uint vertex_count,
                                    unsigned long long *result);

template<const int GroupTC_OPT_SUBWARP_SIZE, const int GroupTC_OPT_WARP_STEP>
__global__ void grouptc_with_atomic(vertex_t *src_list, vertex_t *adj_list, index_t *beg_pos, uint edge_count, uint vertex_count,
                                    unsigned long long *result);

void gpu_run_with_reduce(INIReader &config, GPUGraph &gpu_graph, std::string key_space = "GroupTC-OPT");

void gpu_run_with_atomic(INIReader &config, GPUGraph &gpu_graph, std::string key_space = "GroupTC-OPT");

void start_up(INIReader &config, GPUGraph &gpu_graph, int argc, char **argv);

}  // namespace GroupTC_OPT
}  // namespace approach
}  // namespace tc
