#pragma once
#include <cuda_profiler_api.h>

#include "comm/comm.h"
#include "graph/gpu_graph.h"

namespace tc {
namespace approach {
namespace Polak {

__global__ void calculate_triangles(uint edge_count, vertex_t *src_list, vertex_t *adj_list, index_t *beg_pos, unsigned long long *results,
                                    int deviceCount = 1, int deviceIdx = 0);

void gpu_run(INIReader &config, GPUGraph &gpu_graph, std::string key_space = "Polak");

void start_up(INIReader &config, GPUGraph &gpu_graph, int argc, char **argv);

}  // namespace Polak
}  // namespace approach
}  // namespace tc
