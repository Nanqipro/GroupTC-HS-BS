#pragma once

#include "comm/comm.h"
#include "graph/gpu_graph.h"

#define GroupTC_HASH_V2_BLOCK_SIZE 1024
#define GroupTC_HASH_V2_GROUP_SIZE 1024
#define GroupTC_HASH_V2_CTA_WARP_SIZE 64

#define GroupTC_HASH_V2_shared_BLOCK_BUCKET_SIZE 6
#define GroupTC_HASH_V2_shared_GROUP_BUCKET_SIZE 4
#define GroupTC_HASH_V2_USE_CTA 100
#define GroupTC_HASH_V2_USE_WARP 1

#define GroupTC_HASH_V2_block_bucketnum 1024
#define GroupTC_HASH_V2_group_bucketnum 1024
#define GroupTC_HASH_V2_BLOCK_MODULO 1023
#define GroupTC_HASH_V2_GROUP_MODULO 1023

#define GroupTC_HASH_V2_EDGE_CHUNK 512
#define GroupTC_HASH_V2_shared_CHUNK_CACHE_SIZE 640
#define GroupTC_HASH_V2_BLOCK_BUCKET_SIZE 25
#define GroupTC_HASH_V2_GROUP_BUCKET_SIZE 25

#define GroupTC_HASH_V2_BLOOM_FILTER_SIZE 16383

namespace tc {
namespace approach {
namespace GroupTC_HASH_V2 {

__device__ int linear_search_block(int neighbor, int *partition, int len, int bin, int BIN_START);

__device__ int linear_search_group(int neighbor, int *partition, int len, int bin, int BIN_START);

int my_binary_search(int len, int val, index_t *beg);

template <const int GroupTC_HASH_V2_Group_SUBWARP_SIZE, const int GroupTC_HASH_V2_Group_WARP_STEP, const int CHUNK_SIZE>
__global__ void grouptc_hash_v2(vertex_t *src_list, vertex_t *adj_list, index_t *beg_pos, uint edge_count, uint vertex_count, int *partition,
                                unsigned long long *GLOBAL_COUNT, int T_Group, int *G_INDEX, int warpfirstvertex, int warpfirstedge,
                                int nocomputefirstvertex, int nocomputefirstedge);

void gpu_run(INIReader &config, GPUGraph &gpu_graph, std::string key_space = "GroupTC-HASH-V2");

void start_up(INIReader &config, GPUGraph &gpu_graph, int argc, char **argv);

}  // namespace GroupTC_HASH_V2
}  // namespace approach
}  // namespace tc
