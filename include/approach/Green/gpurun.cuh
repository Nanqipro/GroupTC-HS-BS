#ifndef GPURUN
#define GPURUN
#include <nvToolsExt.h>
#include <omp.h>

#include "approach/Green/clusteringCount.cuh"
#include "approach/Green/graphRead.hpp"
#include "approach/Green/param.cuh"
#include "graph/gpu_graph.h"
#include "spdlog/spdlog.h"

template <typename T>
void singleParamTestGPURun(Param param, T *offsetVector, T *indexVector, T vertexCount, T edgeCount, int iteration_count);

template <typename T>
void singleParamTestGPURun(Param param, T *dOffset, T *dIndex, T vertexCount, T edgeCount, int iteration_count) {
    thrust::device_vector<T> dTriangleOutputVector(vertexCount, 0);
    T *const dTriangle = thrust::raw_pointer_cast(dTriangleOutputVector.data());

    cudaDeviceSynchronize();

     uint blocks = 1000000;
    if (edgeCount / 10 < blocks) {
        blocks = edgeCount / 10;
    }
     uint blockSize = param.threadCount;
    T threadsPerIntsctn = param.threadPerInt;
    T intsctnPerBlock = param.threadCount / param.threadPerInt;
    T threadShift = std::log2(param.threadPerInt);
    T triangleCount;

    double total_kernel_use = 0;
    double startKernel, ee;
    for (int i = 0; i < iteration_count; i++) {
        startKernel = wtime();
        kernelCall(blocks, blockSize, vertexCount, dOffset, dIndex, dTriangle, threadsPerIntsctn, intsctnPerBlock, threadShift);
        cudaDeviceSynchronize();
        triangleCount = thrust::reduce(dTriangleOutputVector.begin(), dTriangleOutputVector.end());
        ee = wtime();
        total_kernel_use += ee - startKernel;
        if (i == 0) {
            if (ee - startKernel > 0.1 && iteration_count != 1) {
                iteration_count = 10;
            }
        }
    }

    spdlog::info("iter {0}, avg kernel use {1:.6f} s", iteration_count, total_kernel_use / iteration_count);
    spdlog::info("triangle count {:d}", triangleCount);
}

#endif