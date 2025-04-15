#include <iostream>
#include <cuda_runtime.h>
#include <thrust/device_vector.h>
#include <thrust/sort.h>
#include <thrust/copy.h>
#include <thrust/execution_policy.h>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <functional>  // 用于 std::function

// 自定义比较器，只比较整数的前n位
struct MostSignificantBitsComparator {
    int numBits;  // 要比较的位数
    
    __host__ __device__ __forceinline__
    MostSignificantBitsComparator(int numBits) : numBits(numBits) {}
    
    __host__ __device__ __forceinline__
    bool operator()(const unsigned long long int &a, const unsigned long long int &b) const {
        // 创建掩码，只保留前numBits位
        unsigned long long int mask = 0xFFFFFFFFFFFFFFFFULL;
        if (numBits < 64) {
            mask = mask << (64 - numBits);
        }
        
        // 应用掩码并比较
        unsigned long long int maskedA = a & mask;
        unsigned long long int maskedB = b & mask;
        
        return maskedA < maskedB;
    }
};

// 对整数数组仅考虑前n位进行排序
void sortByMostSignificantBits(unsigned long long int* d_in, unsigned long long int* d_out, int n, int numBits) {
    // 使用thrust::device_ptr包装原始指针
    thrust::device_ptr<unsigned long long int> dev_ptr_in(d_in);
    thrust::device_ptr<unsigned long long int> dev_ptr_out(d_out);
    
    // 自定义比较器
    MostSignificantBitsComparator comp(numBits);
    
    // 复制数据到输出数组
    thrust::copy(dev_ptr_in, dev_ptr_in + n, dev_ptr_out);
    
    // 使用自定义比较器排序
    thrust::sort(
        thrust::device,
        dev_ptr_out, dev_ptr_out + n,
        comp);
}

// 检查CUDA错误
#define CHECK_CUDA_ERROR(call) \
{ \
    cudaError_t err = call; \
    if (err != cudaSuccess) { \
        fprintf(stderr, "CUDA error in %s:%d: %s\n", __FILE__, __LINE__, cudaGetErrorString(err)); \
        exit(EXIT_FAILURE); \
    } \
}

// 测量 GPU 排序函数执行时间的帮助函数
void measureSortingTime(const char* sortName, std::function<void()> sortFunc) {
    // 创建CUDA事件
    cudaEvent_t start, stop;
    CHECK_CUDA_ERROR(cudaEventCreate(&start));
    CHECK_CUDA_ERROR(cudaEventCreate(&stop));
    
    // 记录开始时间
    CHECK_CUDA_ERROR(cudaEventRecord(start));
    
    // 执行排序函数
    sortFunc();
    
    // 记录结束时间
    CHECK_CUDA_ERROR(cudaEventRecord(stop));
    CHECK_CUDA_ERROR(cudaEventSynchronize(stop));
    
    // 计算执行时间（毫秒）
    float milliseconds = 0;
    CHECK_CUDA_ERROR(cudaEventElapsedTime(&milliseconds, start, stop));
    
    // 输出排序函数名称和执行时间
    std::cout << "【" << sortName << "】执行时间: " << milliseconds << " ms" << std::endl;
    
    // 销毁CUDA事件
    CHECK_CUDA_ERROR(cudaEventDestroy(start));
    CHECK_CUDA_ERROR(cudaEventDestroy(stop));
}

int main() {
    int n = 10000;            // 数组大小
    int numBits = 8;          // 只考虑前8位进行排序，使结果更明显
    
    // 主机内存分配
    unsigned long long int* h_data = new unsigned long long int[n];
    unsigned long long int* h_result = new unsigned long long int[n];
    
    // 初始化数据
    srand(time(NULL));
    std::cout << "原始数据（十进制和二进制）：" << std::endl;
    for (int i = 0; i < n; i++) {
        // 生成64位随机数，创建更大范围的数据
        h_data[i] = ((unsigned long long int)rand() << 48) | ((unsigned long long int)rand() << 32) | 
                    ((unsigned long long int)rand() << 16) | (unsigned long long int)rand();
        
        // 输出十进制值和二进制表示（只显示前10个元素）
        if (i < 10) {
            std::cout << "[" << i << "] " << h_data[i] << " (";
            for (int bit = 63; bit >= 0; bit--) {
                std::cout << ((h_data[i] >> bit) & 1);
                if (bit == 64 - numBits) std::cout << "|"; // 标记前numBits位的分隔
            }
            std::cout << ")" << std::endl;
        }
    }
    if (n > 10) {
        std::cout << "... (只显示前10个数据)" << std::endl;
    }
    
    // 设备内存分配
    unsigned long long int *d_data, *d_result;
    CHECK_CUDA_ERROR(cudaMalloc(&d_data, n * sizeof(unsigned long long int)));
    CHECK_CUDA_ERROR(cudaMalloc(&d_result, n * sizeof(unsigned long long int)));
    
    // 复制数据到设备
    CHECK_CUDA_ERROR(cudaMemcpy(d_data, h_data, n * sizeof(unsigned long long int), cudaMemcpyHostToDevice));
    
    std::cout << "\n执行基于前" << numBits << "位的排序..." << std::endl;
    
    // 执行排序并测量时间
    measureSortingTime("基于前n位排序", [&]() {
        sortByMostSignificantBits(d_data, d_result, n, numBits);
    });
    
    // 将结果复制回主机
    CHECK_CUDA_ERROR(cudaMemcpy(h_result, d_result, n * sizeof(unsigned long long int), cudaMemcpyDeviceToHost));
    
    // 输出结果（只显示前10个结果，避免输出太多）
    std::cout << "\n排序后的结果（只考虑前" << numBits << "位）：" << std::endl;
    int display_count = std::min(n, 10);
    for (int i = 0; i < display_count; i++) {
        std::cout << "[" << i << "] " << h_result[i] << " (";
        for (int bit = 63; bit >= 0; bit--) {
            std::cout << ((h_result[i] >> bit) & 1);
            if (bit == 64 - numBits) std::cout << "|"; // 标记前numBits位的分隔
        }
        std::cout << ")" << std::endl;
    }
    if (n > 10) {
        std::cout << "... (只显示前10个结果)" << std::endl;
    }
    
    // 清理内存
    delete[] h_data;
    delete[] h_result;
    
    cudaFree(d_data);
    cudaFree(d_result);
    
    return 0;
}
