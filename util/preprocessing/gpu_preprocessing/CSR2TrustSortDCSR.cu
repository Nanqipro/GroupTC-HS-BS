#include <algorithm>
#include <cmath>
#include <cstdio>
#include <fstream>
#include <iostream>
#include <sstream>
#include <vector>

#include "./common/comm.h"

using namespace std;

typedef struct edge {
    index_t u, v;
} edge;

typedef struct vertex {
    index_t old_id;
    int degree;
} vertex;

bool cmp1(vertex &a, vertex &b);
bool cmp2(vertex &a, vertex &b);
bool cmp3(edge &a, edge &b);
int printMaxDegree(string str);

/**
 * @brief 记录变换前的 id，用来生成 d_idMapArr
 */
__global__ void record_id(int edge_count, int vertex_count, int *d_idArr);

/**
 * @brief 计算顶点度数并压缩边
 */
__global__ void cal_degree(int edge_count, int vertex_count, int *d_degreeArr, int *d_srcArr, int *d_dstArr);

/**
 * @brief 记录 id 映射
 */
__global__ void map_id(int edge_count, int vertex_count, int *d_idArr, int *d_idMapArr);

/**
 * @brief 边变向
 */
__global__ void redirect_edge(int edge_count, int vertex_count, int *d_degreeArr, int *d_srcArr, int *d_dstArr);

/**
 * @brief 重新分配 id
 *
 */
__global__ void reassign_id(int edge_count, int vertex_count, int *d_idMapArr, int *d_srcArr, int *d_dstArr);

/**
 * @brief 计算 src 的出度
 */
__global__ void cal_src_out_degree(int edge_count, int vertex_count, int *d_degreeArr, int *d_srcArr);

/**
 * @brief 解压缩边
 */
__global__ void unzip_edge(int edge_count, int vertex_count, int *d_edgeArr, int *d_srcArr, int *d_dstArr);

/**
 * @brief 计算偏移数组
 */
__global__ void cal_offset(int edge_count, int vertex_count, int *d_srcArr, index_t *d_offsetArr);

__global__ void show_arr(int edge_count, int vertex_count, int *d_degreeArr);

void comparasion(vertex_t *d_degreeArr, vertex_t *d_srcArr, vertex_t *d_dstArr, vertex_t *d_edgeArr, index_t *d_offsetArr, vertex_t *degreeArr,
                 vertex_t *srcArr, vertex_t *dstArr, vertex_t *edgeArr, index_t *offsetArr);

int vertex_count;
long long int edge_count;

index_t *offsetArr;
vertex_t *srcArr;
vertex_t *dstArr;

long long sizeEdgeList;
long long sizeOffsetList;

void loadgraph(string prefix) {
    string s_begin = prefix + "begin.bin";
    string s_source = prefix + "source.bin";
    string s_adj = prefix + "adjacent.bin";

    char *begin_file = const_cast<char *>(s_begin.c_str());
    char *source_file = const_cast<char *>(s_source.c_str());
    char *adj_file = const_cast<char *>(s_adj.c_str());

    ifstream beginFile(begin_file, ios::in | ios::binary);
    ifstream sourceFile(source_file, ios::in | ios::binary);
    ifstream adjFile(adj_file, ios::in | ios::binary);

    vertex_count = fsize(begin_file) / sizeof(index_t) - 1;
    edge_count = fsize(adj_file) / sizeof(vertex_t);

    cout << "vertex: " << vertex_count << "   edge: " << edge_count << endl;
    sizeOffsetList = sizeof(index_t) * (vertex_count + 1);
    sizeEdgeList = sizeof(vertex_t) * edge_count;

    offsetArr = (index_t *)malloc(sizeOffsetList);
    srcArr = (vertex_t *)malloc(sizeEdgeList);
    dstArr = (vertex_t *)malloc(sizeEdgeList);

    beginFile.read((char *)&offsetArr[0], sizeOffsetList);
    sourceFile.read((char *)&srcArr[0], sizeEdgeList);
    adjFile.read((char *)&dstArr[0], sizeEdgeList);

    beginFile.close();
    sourceFile.close();
    adjFile.close();
}

void writeback(string prefix) {
    ofstream beginFile((prefix + "begin.bin").c_str(), ios::out | ios::binary);
    ofstream sourceFile((prefix + "source.bin").c_str(), ios::out | ios::binary);
    ofstream adjFile((prefix + "adjacent.bin").c_str(), ios::out | ios::binary);

    // ofstream outFile((prefix + "graph.txt").c_str(), ios::out);

    // for (int i = 0; i < edge_count; i++)
    // {
    //     if (srcArr[i] >= dstArr[i])
    //     {
    //         cout << i << " " << srcArr[i] << " " << dstArr[i] << endl;
    //     }
    //     // outFile << i << " " << srcArr[i] << endl;
    // }

    // for (int i = 1; i < vertex_count; i++)
    // {
    //     // if (offsetArr[i + 1] - offsetArr[i] > offsetArr[i] - offsetArr[i - 1])
    //     // {
    //     //     cout << i << " " << offsetArr[i + 1] - offsetArr[i] << " " << offsetArr[i] - offsetArr[i - 1] << endl;
    //     // }
    //     if (offsetArr[i + 1] - offsetArr[i] < offsetArr[i] - offsetArr[i - 1])
    //     {
    //         cout << i << " " << offsetArr[i + 1] - offsetArr[i] << " " << offsetArr[i] - offsetArr[i - 1] << endl;
    //     }
    //     // outFile << i << " " << srcArr[i] << endl;
    // }
    // for (int i = 0; i < 100; i++)
    // {
    //     cout << i << " " << offsetArr[i + 1] - offsetArr[i] << endl;
    // }

    // outFile << "===========================================" << endl;

    // for (int i = 0; i < 100; i++)
    // {
    //     outFile << i << " " << offsetArr[i] << endl;
    // }
    // outFile.close();

    beginFile.write((char *)&offsetArr[0], sizeOffsetList);
    sourceFile.write((char *)&srcArr[0], sizeEdgeList);
    adjFile.write((char *)&dstArr[0], sizeEdgeList);

    beginFile.close();
    sourceFile.close();
    adjFile.close();

    free(srcArr);
    free(dstArr);
    free(offsetArr);
}

void compute() {
    cudaSetDevice(3);

    vertex_t *d_degreeArr;
    vertex_t *d_idArr;
    vertex_t *d_idMapArr;
    vertex_t *d_srcArr;
    vertex_t *d_dstArr;
    index_t *d_offsetArr;

    size_t sizeVertexArr = sizeof(vertex_t) * vertex_count;
    size_t sizeEdgeArr = sizeof(vertex_t) * edge_count;

    HRR(cudaMalloc((void **)&d_degreeArr, sizeVertexArr));
    HRR(cudaMalloc((void **)&d_idArr, sizeVertexArr));
    HRR(cudaMalloc((void **)&d_idMapArr, sizeVertexArr));
    HRR(cudaMalloc((void **)&d_srcArr, sizeEdgeArr));
    HRR(cudaMalloc((void **)&d_dstArr, sizeEdgeArr));
    HRR(cudaMalloc((void **)&d_offsetArr, sizeOffsetList));

    HRR(cudaMemcpy(d_srcArr, srcArr, sizeEdgeArr, cudaMemcpyHostToDevice));
    HRR(cudaMemcpy(d_dstArr, dstArr, sizeEdgeArr, cudaMemcpyHostToDevice));
    HRR(cudaMemset(d_degreeArr, 0, sizeVertexArr));

    int block_size = 1024;
    int vertex_grid_size = (vertex_count - 1) / block_size + 1;
    int edge_grid_size = (edge_count - 1) / block_size + 1;

    printMaxDegree("before compute");

    double t_start = wtime();
    int iteration = 100;
    for (int k = 0; k < iteration; k++) {
        cal_degree<<<edge_grid_size, block_size>>>(edge_count, vertex_count, d_degreeArr, d_srcArr, d_dstArr);
        HRR(cudaDeviceSynchronize());

        redirect_edge<<<edge_grid_size, block_size>>>(edge_count, vertex_count, d_degreeArr, d_srcArr, d_dstArr);
        HRR(cudaDeviceSynchronize());

        HRR(cudaMemset(d_degreeArr, 0, sizeVertexArr));
        cal_src_out_degree<<<edge_grid_size, block_size>>>(edge_count, vertex_count, d_degreeArr, d_srcArr);
        HRR(cudaDeviceSynchronize());
        // cout << "xxxxxxxxxxxxxx" << endl;

        record_id<<<vertex_grid_size, block_size>>>(edge_count, vertex_count, d_idArr);
        HRR(cudaDeviceSynchronize());

        // show_arr<<<vertex_grid_size, block_size>>>(edge_count, vertex_count, d_degreeArr);
        // HRR(cudaDeviceSynchronize());

        thrust::device_ptr<vertex_t> d_id_ptr((vertex_t *)d_idArr);
        thrust::sort_by_key(d_degreeArr, d_degreeArr + vertex_count, d_id_ptr, thrust::greater<vertex_t>());

        map_id<<<vertex_grid_size, block_size>>>(edge_count, vertex_count, d_idArr, d_idMapArr);
        HRR(cudaDeviceSynchronize());

        reassign_id<<<edge_grid_size, block_size>>>(edge_count, vertex_count, d_idMapArr, d_srcArr, d_dstArr);
        HRR(cudaDeviceSynchronize());

        thrust::device_ptr<vertex_t> d_dst_ptr((vertex_t *)d_dstArr);
        thrust::device_ptr<vertex_t> d_src_ptr((vertex_t *)d_srcArr);
        thrust::sort_by_key(d_src_ptr, d_src_ptr + edge_count, d_dstArr);

        cal_offset<<<edge_grid_size, block_size>>>(edge_count, vertex_count, d_srcArr, d_offsetArr);
        HRR(cudaDeviceSynchronize());
    }
    double t_end = wtime();

    cout << "compute time spent " << (t_end - t_start) / iteration << " s, iterations " << iteration << endl;

    HRR(cudaMemcpy(offsetArr, d_offsetArr, sizeOffsetList, cudaMemcpyDeviceToHost));
    HRR(cudaMemcpy(srcArr, d_srcArr, sizeEdgeArr, cudaMemcpyDeviceToHost));
    HRR(cudaMemcpy(dstArr, d_dstArr, sizeEdgeArr, cudaMemcpyDeviceToHost));
    printMaxDegree("after compute");

    cudaFree(d_degreeArr);
    cudaFree(d_idArr);
    cudaFree(d_idMapArr);
    cudaFree(d_offsetArr);
    cudaFree(d_srcArr);
    cudaFree(d_dstArr);
}

__global__ void record_id(int edge_count, int vertex_count, int *d_idArr) {
    int i = blockIdx.x * blockDim.x + threadIdx.x;
    if (i >= vertex_count) {
        return;
    }
    d_idArr[i] = i;
}

__global__ void show_arr(int edge_count, int vertex_count, int *d_degreeArr) {
    int i = blockIdx.x * blockDim.x + threadIdx.x;
    if (i >= vertex_count) {
        return;
    }
    if (i < 10)
    // if (317079 - i <= 100)
    {
        // printf("%d\t%d\n", i, d_degreeArr[d_arr[i]]);
        // printf("%d\t%d\n", i, d_degreeArr[210749]);
        // printf("%d\t%d\n", i, d_degreeArr[210749]);
        // printf("%d\t%d\n", i, d_degreeArr[210752]);
        // printf("%d\t%d\n", i, d_degreeArr[2 * i + 1]);
        // printf("%d\t%d\t%d\n", i, d_arr[i], d_degreeArr[i]);
    }
}

__global__ void map_id(int edge_count, int vertex_count, int *d_idArr, int *d_idMapArr) {
    int i = blockIdx.x * blockDim.x + threadIdx.x;
    if (i >= vertex_count) {
        return;
    }
    d_idMapArr[d_idArr[i]] = i;
}

__global__ void cal_degree(int edge_count, int vertex_count, int *d_degreeArr, int *d_srcArr, int *d_dstArr) {
    int i = blockIdx.x * blockDim.x + threadIdx.x;
    if (i >= edge_count) {
        return;
    }
    int src = d_srcArr[i];
    int dst = d_dstArr[i];

    atomicAdd(d_degreeArr + src, 1);
    atomicAdd(d_degreeArr + dst, 1);
}

__global__ void cal_src_out_degree(int edge_count, int vertex_count, int *d_degreeArr, int *d_srcArr) {
    int i = blockIdx.x * blockDim.x + threadIdx.x;
    if (i >= edge_count) {
        return;
    }
    atomicAdd(d_degreeArr + d_srcArr[i], 1);
}

__global__ void redirect_edge(int edge_count, int vertex_count, int *d_degreeArr, int *d_srcArr, int *d_dstArr) {
    int i = blockIdx.x * blockDim.x + threadIdx.x;
    if (i >= edge_count) {
        return;
    }
    int src = d_srcArr[i];
    int dst = d_dstArr[i];
    // redirect edge
    if (d_degreeArr[src] > d_degreeArr[dst] || (d_degreeArr[src] == d_degreeArr[dst] && src > dst)) {
        d_dstArr[i] = src;
        d_srcArr[i] = dst;
    }
}

__global__ void reassign_id(int edge_count, int vertex_count, int *d_idMapArr, int *d_srcArr, int *d_dstArr) {
    int i = blockIdx.x * blockDim.x + threadIdx.x;
    if (i >= edge_count) {
        return;
    }
    d_srcArr[i] = d_idMapArr[d_srcArr[i]];
    d_dstArr[i] = d_idMapArr[d_dstArr[i]];
}

__global__ void unzip_edge(int edge_count, int vertex_count, int *d_edgeArr, int *d_srcArr, int *d_dstArr) {
    int i = blockIdx.x * blockDim.x + threadIdx.x;
    if (i >= edge_count) {
        return;
    }
    d_srcArr[i] = d_edgeArr[i * 2 + 1];
    d_dstArr[i] = d_edgeArr[i * 2];
}

__global__ void cal_offset(int edge_count, int vertex_count, int *d_srcArr, index_t *d_offsetArr) {
    int from = blockDim.x * blockIdx.x + threadIdx.x;
    int step = gridDim.x * blockDim.x;
    for (int i = from; i <= edge_count; i += step) {
        int prev = i > 0 ? d_srcArr[i - 1] : -1;
        int next = i < edge_count ? d_srcArr[i] : vertex_count;
        // 前一个元素小于后一个元素，才有可能出现 offset 的计算
        for (int j = prev + 1; j <= next; ++j) d_offsetArr[j] = i;
    }
}

void comparasion(vertex_t *d_degreeArr, vertex_t *d_srcArr, vertex_t *d_dstArr, vertex_t *d_edgeArr, index_t *d_offsetArr, vertex_t *degreeArr,
                 vertex_t *srcArr, vertex_t *dstArr, vertex_t *edgeArr, index_t *offsetArr) {
    vertex_t *degreeArr2 = (vertex_t *)malloc(sizeof(vertex_t) * vertex_count);
    vertex_t *srcArr2 = (vertex_t *)malloc(sizeof(vertex_t) * edge_count);
    vertex_t *dstArr2 = (vertex_t *)malloc(sizeof(vertex_t) * edge_count);
    vertex_t *edgeArr2 = (vertex_t *)malloc(sizeof(vertex_t) * edge_count * 2);
    vertex_t *offsetArr2 = (vertex_t *)malloc(sizeof(index_t) * (vertex_count + 1));

    HRR(cudaMemcpy(degreeArr2, d_degreeArr, sizeof(vertex_t) * vertex_count, cudaMemcpyDeviceToHost));
    HRR(cudaMemcpy(srcArr2, d_srcArr, sizeof(vertex_t) * edge_count, cudaMemcpyDeviceToHost));
    HRR(cudaMemcpy(dstArr2, d_dstArr, sizeof(vertex_t) * edge_count, cudaMemcpyDeviceToHost));
    HRR(cudaMemcpy(edgeArr2, d_edgeArr, sizeof(vertex_t) * edge_count * 2, cudaMemcpyDeviceToHost));
    HRR(cudaMemcpy(offsetArr2, d_offsetArr, sizeof(index_t) * (vertex_count + 1), cudaMemcpyDeviceToHost));

    for (int i = 0; i < edge_count * 2; i++) {
        if (i < vertex_count && degreeArr2[i] != degreeArr[i]) {
            cout << "degree " << i << "  " << degreeArr2[i] << "  " << degreeArr[i] << endl;
        }
        if (i < edge_count && srcArr2[i] != srcArr[i]) {
            cout << "src " << i << "  " << srcArr2[i] << "  " << srcArr[i] << endl;
        }
        if (i < edge_count && dstArr2[i] != dstArr[i]) {
            cout << "dst " << i << "  " << dstArr2[i] << "  " << dstArr[i] << endl;
        }
        if (edgeArr2[i] != edgeArr[i]) {
            cout << "edge " << i << "  " << edgeArr2[i] << "  " << edgeArr[i] << endl;
        }
        if (i < vertex_count + 1 && offsetArr2[i] != offsetArr[i]) {
            // cout << "offset " << i << "  " << offsetArr2[i] << "  " << offsetArr[i] << endl;
        }
    }

    free(degreeArr2);
    free(srcArr2);
    free(dstArr2);
    free(edgeArr2);
    free(offsetArr2);
}

void riddcsr(string inPrefix, string outPrefix) {
    // 将边加载到图中
    loadgraph(inPrefix);
    cout << "loadok" << endl;

    compute();

    writeback(outPrefix);
    cout << "writebackok" << endl;
}

int main(int argc, char *argv[]) {
    string inPrefix = argv[1];
    string outPrefix = argv[2];

    cout << "inPath: " << inPrefix << endl;
    cout << "outPath: " << outPrefix << endl;
    riddcsr(inPrefix, outPrefix);
    cout << endl;
}

bool cmp1(vertex &a, vertex &b) { return a.degree < b.degree; }

bool cmp2(vertex &a, vertex &b) { return a.degree > b.degree; }

bool cmp3(edge &a, edge &b) { return a.u < b.u || (a.u == b.u && a.v < b.v); }

int printMaxDegree(string str) {
    int maxDegre = 0;
    for (index_t i = 1; i <= vertex_count; i++) {
        if (offsetArr[i] - offsetArr[i - 1] > maxDegre) {
            maxDegre = offsetArr[i] - offsetArr[i - 1];
        }
    }
    cout << str << " max degree :" << maxDegre << endl;
    return maxDegre;
}