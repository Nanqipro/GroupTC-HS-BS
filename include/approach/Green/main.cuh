#include "comm/comm.h"
#include "cpurun.hpp"
#include "gpurun.cuh"
#include "graph/gpu_graph.h"
#include "results.cuh"

namespace tc {
namespace approach {
namespace Green {

void gpu_run(INIReader &config, GPUGraph &gpu_graph, std::string key_space = "Green");

void start_up(INIReader &config, GPUGraph &gpu_graph, int argc, char **argv);

}  // namespace Green
}  // namespace approach
}  // namespace tc
