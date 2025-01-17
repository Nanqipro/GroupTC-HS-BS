#ifndef CPURUN
#define CPURUN
#include "approach/Green/graphRead.hpp"
#include "approach/Green/param.cuh"
// #include "graphOperations.hpp"
#include <nvToolsExt.h>

#include "approach/Green/clusteringCount.hpp"

template <typename T>
void CPURun(Param param);
template <typename T>
void partitionedCPURun(Param param);
#endif
