#pragma once

#include "comm/comm.h"
#include "graph/gpu_graph.h"

#define GroupTC_Cuckoo_COMBINE 1

#define GroupTC_Cuckoo_BLOCK_SIZE 1024
#define GroupTC_Cuckoo_GROUP_SIZE 1024
#define GroupTC_Cuckoo_Cuckoo_WARP_SIZE 64

#define GroupTC_Cuckoo_shared_BLOCK_BUCKET_SIZE 6
#define GroupTC_Cuckoo_shared_GROUP_BUCKET_SIZE 4

#define GroupTC_Cuckoo_shared_Cuckoo_BUCKET_SIZE 4
#define GroupTC_Cuckoo_shared_Basic_BUCKET_SIZE (GroupTC_Cuckoo_shared_BLOCK_BUCKET_SIZE - GroupTC_Cuckoo_shared_Cuckoo_BUCKET_SIZE)

#define GroupTC_Cuckoo_USE_CTA 100
#define GroupTC_Cuckoo_USE_WARP 1

#define GroupTC_Cuckoo_block_bucketnum 1024
#define GroupTC_Cuckoo_group_bucketnum 1024
#define GroupTC_Cuckoo_BLOCK_MODULO 1023
#define GroupTC_Cuckoo_GROUP_MODULO 1023

#define GroupTC_Cuckoo_EDGE_CHUNK 512
#define GroupTC_Cuckoo_shared_CHUNK_CACHE_SIZE 640
#define GroupTC_Cuckoo_BLOCK_BUCKET_SIZE 25
#define GroupTC_Cuckoo_GROUP_BUCKET_SIZE 25

#define GroupTC_Cuckoo_H0 1
#define GroupTC_Cuckoo_H1 31
#define GroupTC_Cuckoo_H2 37
#define GroupTC_Cuckoo_H3 43
#define GroupTC_Cuckoo_H4 53
#define GroupTC_Cuckoo_H5 61
#define GroupTC_Cuckoo_H6 83
#define GroupTC_Cuckoo_H7 97
// #define GroupTC_Cuckoo_H0 0.6180339887
// #define GroupTC_Cuckoo_H1 0.123456789
#define GroupTC_Cuckoo_Max_Conflict 3
#define GroupTC_Cuckoo_BUCKET_NUM (GroupTC_Cuckoo_shared_Cuckoo_BUCKET_SIZE * GroupTC_Cuckoo_BLOCK_SIZE - 1)
// #define GroupTC_Cuckoo_BUCKET_NUM 4093

namespace tc {
namespace approach {
namespace GroupTC_Cuckoo {

__device__ int linear_search_block(int neighbor, int *partition, int len, int bin, int BIN_START);

__device__ int linear_search_group(int neighbor, int *partition, int len, int bin, int BIN_START);

int my_binary_search(int len, int val, index_t *beg);

__device__ unsigned fmix32(unsigned int h);


template <const int GroupTC_Cuckoo_Group_SUBWARP_SIZE, const int GroupTC_Cuckoo_Group_WARP_STEP, const int CHUNK_SIZE>
__global__ void grouptc_cuckoo(vertex_t *src_list, vertex_t *adj_list, index_t *beg_pos, uint edge_count, uint vertex_count, int *partition,
                               unsigned long long *GLOBAL_COUNT, int T_Group, int *G_INDEX, int warpfirstvertex, int warpfirstedge,
                               int nocomputefirstvertex, int nocomputefirstedge);

void gpu_run(INIReader &config, GPUGraph &gpu_graph, std::string key_space = "GroupTC-Cuckoo");

void start_up(INIReader &config, GPUGraph &gpu_graph, int argc = 0, char **argv = nullptr);

}  // namespace GroupTC_Cuckoo
}  // namespace approach
}  // namespace tc
