#pragma once
#include <cuda_runtime_api.h>
#include "comm.h"
#include "cuda_comm.h"
#include "spdlog/spdlog.h"

namespace cuda_graph_comm
{
    __global__ void cal_degree_and_zip_edge(int edge_count, int vertex_count, int *d_degree_arr, int *d_edge_arr, int *d_src_arr, int *d_adj_arr);

    __global__ void redirect_edge(int edge_count, int vertex_count, int *d_degree_arr, int *d_edge_arr);

    __global__ void redirect_edge(int edge_count, int vertex_count, int *d_degree_arr, int *d_src_arr, int *d_adj_arr);

    __global__ void unzip_edge(int edge_count, int vertex_count, int *d_edge_arr, int *d_src_arr, int *d_adj_arr);

    __global__ void recal_offset(int edge_count, int vertex_count, int *d_src_arr, index_t *d_offset_arr);

    __global__ void record_id(int edge_count, int vertex_count, int *d_id_arr);

    __global__ void map_id(int edge_count, int vertex_count, int *d_id_arr, int *d_id_map_arr);

    __global__ void redirect_edge_and_reassign_id(int edge_count, int vertex_count, int *d_id_map_arr, int *d_edge_arr);

    __global__ void cal_degree(int edge_count, int vertex_count, int *d_degree_arr, int *d_src_arr, int *d_adj_arr);

    __global__ void cal_src_out_degree(int edge_count, int vertex_count, int *d_degree_arr, int *d_src_arr);

    __global__ void record_id_and_part_graph_by_degree(int edge_count, int vertex_count, int *d_id_arr, int *d_degree_arr);

    __global__ void reassign_id(int edge_count, int vertex_count, int *d_id_map_arr, int *d_src_arr, int *d_adj_arr);

    template <typename T>
    void check_array(std::string arr_name, T *d_arr, int len, int start, int end);

} // namespace cuda_graph_comm

template <typename T>
void cuda_graph_comm::check_array(std::string arr_name, T *d_arr, int len, int start, int end)
{
    T *h_arr = (T *)malloc(sizeof(T) * len);
    HRR(cudaMemcpy(h_arr, d_arr, sizeof(T) * len, cudaMemcpyDeviceToHost));
    for (int i = start; i < end; i++)
    {
        spdlog::debug("{0}[{1}]: {2}", arr_name, i, h_arr[i]);
    }
    free(h_arr);
}
