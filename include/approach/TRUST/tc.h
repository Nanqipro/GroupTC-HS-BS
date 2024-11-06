// #pragma once

// #include "comm/comm.h"
// #include "graph/gpu_graph.h"

// #define TRUST_SHARED_BUCKET_SIZE 6
// #define TRUST_BUCKET_SIZE 100
// #define TRUST_USE_CTA 100
// #define TRUST_USE_WARP 2
// #define TRUST_BLOCK_BUCKETNUM 1024
// #define TRUST_WARP_BUCKETNUM 32

// namespace tc {
// namespace approach {
// namespace TRUST {

// __device__ int linear_search(int neighbor, int* shared_partition, int* partition, int* bin_count, int bin, int BIN_START);

// int my_binary_search(int len, int val, index_t* beg);

// __global__ void trust(vertex_t* adj_list, index_t* beg_pos, uint edge_count, uint vertex_count, int* partition, unsigned long long* GLOBAL_COUNT,
//                       int* G_INDEX, int CHUNK_SIZE, int warpfirstvertex);

// void gpu_run(INIReader& config, GPUGraph& gpu_graph, std::string key_space = "TRUST");

// void start_up(INIReader& config, GPUGraph& gpu_graph, int argc, char** argv);

// }  // namespace TRUST
// }  // namespace approach
// }  // namespace tc

// // Trust 分两部分测时间   1构建索引时间   2总的运行时间
// #pragma once

// #include "comm/comm.h"
// #include "graph/gpu_graph.h"

// #define TRUST_SHARED_BUCKET_SIZE 6
// #define TRUST_BUCKET_SIZE 100
// #define TRUST_USE_CTA 100
// #define TRUST_USE_WARP 2
// #define TRUST_BLOCK_BUCKETNUM 1024
// #define TRUST_WARP_BUCKETNUM 32

// namespace tc {
// namespace approach {
// namespace TRUST {

// __device__ int linear_search(int neighbor, int* shared_partition, int* partition, int* bin_count, int bin, int BIN_START);

// int my_binary_search(int len, int val, index_t* beg);

// __global__ void trust(vertex_t* adj_list, index_t* beg_pos, uint edge_count, uint vertex_count, int* partition, unsigned long long* GLOBAL_COUNT,
//                       int* G_INDEX, int CHUNK_SIZE, int warpfirstvertex, unsigned int* index_time_array  // 新增参数
// );

// void gpu_run(INIReader& config, GPUGraph& gpu_graph, std::string key_space = "TRUST");

// void start_up(INIReader& config, GPUGraph& gpu_graph, int argc, char** argv);

// }  // namespace TRUST
// }  // namespace approach
// }  // namespace tc


// 就是trust和groupTc-hash都按顶点度数把数据集分成了两部分，你可以测一测，他们分别在这两部分上的运行时间
#pragma once

#include "comm/comm.h"
#include "graph/gpu_graph.h"

#define TRUST_SHARED_BUCKET_SIZE 6
#define TRUST_BUCKET_SIZE 100
#define TRUST_USE_CTA 100
#define TRUST_USE_WARP 2
#define TRUST_BLOCK_BUCKETNUM 1024
#define TRUST_WARP_BUCKETNUM 32

namespace tc {
namespace approach {
namespace TRUST {

__device__ int linear_search(int neighbor, int* shared_partition, int* partition, int* bin_count, int bin, int BIN_START);

int my_binary_search(int len, int val, index_t* beg);

// 新的内核函数声明：处理高度数顶点
__global__ void trust_high_degree(vertex_t* adj_list, index_t* beg_pos, uint edge_count, uint vertex_count, int* partition,
                                  unsigned long long* GLOBAL_COUNT, int* G_INDEX, int CHUNK_SIZE, int warpfirstvertex);

// 新的内核函数声明：处理低度数顶点
__global__ void trust_low_degree(vertex_t* adj_list, index_t* beg_pos, uint edge_count, uint vertex_count, int* partition,
                                 unsigned long long* GLOBAL_COUNT, int* G_INDEX, int CHUNK_SIZE, int warpfirstvertex);

void gpu_run(INIReader& config, GPUGraph& gpu_graph, std::string key_space = "TRUST");

void start_up(INIReader& config, GPUGraph& gpu_graph, int argc, char** argv);

}  // namespace TRUST
}  // namespace approach
}  // namespace tc

