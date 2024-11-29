#pragma once

#include "comm/comm.h"
#include "graph/gpu_graph.h"

#define GroupTC_HASH_BLOCK_SIZE 1024
#define GroupTC_HASH_GROUP_SIZE 1024
#define GroupTC_HASH_WARP_SIZE 64

#define GroupTC_HASH_shared_BLOCK_BUCKET_SIZE 6
#define GroupTC_HASH_shared_GROUP_BUCKET_SIZE 4
#define GroupTC_HASH_USE_CTA 100
#define GroupTC_HASH_USE_WARP 1

#define GroupTC_HASH_block_bucketnum 1024
#define GroupTC_HASH_group_bucketnum 1024
#define GroupTC_HASH_BLOCK_MODULO 1023
#define GroupTC_HASH_GROUP_MODULO 1023

#define GroupTC_HASH_EDGE_CHUNK 512
#define GroupTC_HASH_shared_CHUNK_CACHE_SIZE 640
#define GroupTC_HASH_BLOCK_BUCKET_SIZE 100
#define GroupTC_HASH_GROUP_BUCKET_SIZE 100

namespace tc {
namespace approach {
namespace GroupTC_HASH {

__device__ int linear_search_block(int neighbor, int *partition, int len, int bin, int BIN_START);

__device__ int linear_search_group(int neighbor, int *partition, int len, int bin, int BIN_START);

int my_binary_search(int len, int val, index_t *beg);

__global__ void grouptc_hash(vertex_t *src_list, vertex_t *adj_list, index_t *beg_pos, uint edge_count, uint vertex_count, int *partition,
                             unsigned long long *GLOBAL_COUNT, int T_Group, int *G_INDEX, int CHUNK_SIZE, int warpfirstvertex, int warpfirstedge,
                             int nocomputefirstvertex, int nocomputefirstedge);

void gpu_run(INIReader &config, GPUGraph &gpu_graph, std::string key_space = "GroupTC-HASH");

void start_up(INIReader &config, GPUGraph &gpu_graph, int argc, char **argv);

}  // namespace GroupTC_HASH
}  // namespace approach
}  // namespace tc


