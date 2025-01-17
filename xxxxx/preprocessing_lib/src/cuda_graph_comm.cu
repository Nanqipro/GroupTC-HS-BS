#include "cuda_graph_comm.h"

__global__ void cuda_graph_comm::cal_degree_and_zip_edge(int edge_count, int vertex_count, int *d_degree_arr, int *d_edge_arr, int *d_src_arr, int *d_adj_arr)
{
    int i = blockIdx.x * blockDim.x + threadIdx.x;
    if (i >= edge_count)
    {
        return;
    }
    int src = d_src_arr[i];
    int adj = d_adj_arr[i];
    d_edge_arr[i * 2] = src;
    d_edge_arr[i * 2 + 1] = adj;

    atomicAdd(d_degree_arr + src, 1);
    atomicAdd(d_degree_arr + adj, 1);
}

__global__ void cuda_graph_comm::redirect_edge(int edge_count, int vertex_count, int *d_degree_arr, int *d_edge_arr)
{
    int i = blockIdx.x * blockDim.x + threadIdx.x;
    if (i >= edge_count)
    {
        return;
    }
    int adj = d_edge_arr[i * 2];
    int src = d_edge_arr[i * 2 + 1];
    // redirect edge
    if (d_degree_arr[src] > d_degree_arr[adj] || (d_degree_arr[src] == d_degree_arr[adj] && src > adj))
    {
        d_edge_arr[i * 2] = src;
        d_edge_arr[i * 2 + 1] = adj;
    }
}

__global__ void cuda_graph_comm::redirect_edge(int edge_count, int vertex_count, int *d_degree_arr, int *d_src_arr, int *d_adj_arr)
{
    int i = blockIdx.x * blockDim.x + threadIdx.x;
    if (i >= edge_count)
    {
        return;
    }
    int src = d_src_arr[i];
    int dst = d_adj_arr[i];
    // redirect edge
    if (d_degree_arr[src] > d_degree_arr[dst] || (d_degree_arr[src] == d_degree_arr[dst] && src > dst))
    {
        d_adj_arr[i] = src;
        d_src_arr[i] = dst;
    }
}

__global__ void cuda_graph_comm::unzip_edge(int edge_count, int vertex_count, int *d_edge_arr, int *d_src_arr, int *d_adj_arr)
{
    int i = blockIdx.x * blockDim.x + threadIdx.x;
    if (i >= edge_count)
    {
        return;
    }
    d_src_arr[i] = d_edge_arr[i * 2 + 1];
    d_adj_arr[i] = d_edge_arr[i * 2];
}

__global__ void cuda_graph_comm::recal_offset(int edge_count, int vertex_count, int *d_src_arr, index_t *d_offset_arr)
{
    int from = blockDim.x * blockIdx.x + threadIdx.x;
    int step = gridDim.x * blockDim.x;
    for (int i = from; i <= edge_count; i += step)
    {
        int prev = i > 0 ? d_src_arr[i - 1] : -1;
        int next = i < edge_count ? d_src_arr[i] : vertex_count;
        // 前一个元素小于后一个元素，才有可能出现 offset 的计算
        for (int j = prev + 1; j <= next; ++j)
            d_offset_arr[j] = i;
    }
}

__global__ void cuda_graph_comm::record_id(int edge_count, int vertex_count, int *d_id_arr)
{
    int i = blockIdx.x * blockDim.x + threadIdx.x;
    if (i >= vertex_count)
    {
        return;
    }
    d_id_arr[i] = i;
}

__global__ void cuda_graph_comm::map_id(int edge_count, int vertex_count, int *d_id_arr, int *d_id_map_arr)
{
    int i = blockIdx.x * blockDim.x + threadIdx.x;
    if (i >= vertex_count)
    {
        return;
    }
    d_id_map_arr[d_id_arr[i]] = i;
}

__global__ void cuda_graph_comm::redirect_edge_and_reassign_id(int edge_count, int vertex_count, int *d_id_map_arr, int *d_edge_arr)
{
    int i = blockIdx.x * blockDim.x + threadIdx.x;
    if (i >= edge_count)
    {
        return;
    }
    int src = d_id_map_arr[d_edge_arr[i * 2]];
    int adj = d_id_map_arr[d_edge_arr[i * 2 + 1]];
    if (src > adj)
    {
        int temp = src;
        src = adj;
        adj = temp;
    }
    d_edge_arr[i * 2] = adj;
    d_edge_arr[i * 2 + 1] = src;
}

__global__ void cuda_graph_comm::cal_degree(int edge_count, int vertex_count, int *d_degree_arr, int *d_src_arr, int *d_adj_arr)
{
    int i = blockIdx.x * blockDim.x + threadIdx.x;
    if (i >= edge_count)
    {
        return;
    }
    int src = d_src_arr[i];
    int adj = d_adj_arr[i];

    atomicAdd(d_degree_arr + src, 1);
    atomicAdd(d_degree_arr + adj, 1);
}

__global__ void cuda_graph_comm::cal_src_out_degree(int edge_count, int vertex_count, int *d_degree_arr, int *d_src_arr)
{
    int i = blockIdx.x * blockDim.x + threadIdx.x;
    if (i >= edge_count)
    {
        return;
    }
    atomicAdd(d_degree_arr + d_src_arr[i], 1);
}

__global__ void cuda_graph_comm::record_id_and_part_graph_by_degree(int edge_count, int vertex_count, int *d_id_arr, int *d_degree_arr)
{
    int i = blockIdx.x * blockDim.x + threadIdx.x;
    if (i >= vertex_count)
    {
        return;
    }
    d_id_arr[i] = i;
    int degree = d_degree_arr[i];
    if (degree < 2)
    {
        degree = 2;
    }
    else if (degree <= 100)
    {
        degree = 1;
    }
    else
    {
        degree = 0;
    }
    d_degree_arr[i] = degree;
}

__global__ void cuda_graph_comm::reassign_id(int edge_count, int vertex_count, int *d_id_map_arr, int *d_src_arr, int *d_adj_arr)
{
    int i = blockIdx.x * blockDim.x + threadIdx.x;
    if (i >= edge_count)
    {
        return;
    }
    d_src_arr[i] = d_id_map_arr[d_src_arr[i]];
    d_adj_arr[i] = d_id_map_arr[d_adj_arr[i]];
}