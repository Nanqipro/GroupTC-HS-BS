#include "gpu_graph.h"
#include "spdlog/spdlog.h"
#include "constant_comm.h"

GPUGraph::GPUGraph(Graph *graph)
{
	vertex_count = graph->vertex_count;
	edge_count = graph->edge_count;
	max_degree = graph->max_degree;
	has_edge_list = graph->has_edge_list;

	size_t beg_sz = sizeof(index_t) * (vertex_count + 1);
	size_t adj_sz = sizeof(vertex_t) * edge_count;

	spdlog::info("Load graph from host to device, input dir is: {}", graph->input_dir);
	spdlog::info("Graph vertices: {0}, edges: {1}", vertex_count, edge_count);

	/* Alloc GPU space */
	HRR(cudaMalloc((void **)&src_list, adj_sz));
	HRR(cudaMalloc((void **)&adj_list, adj_sz));
	HRR(cudaMalloc((void **)&beg_pos, beg_sz));

	spdlog::debug("Load graph from host to device, alloc GPU space finished");

	/* copy it to GPU */
	HRR(cudaMemcpy(src_list, graph->src_list, adj_sz, cudaMemcpyHostToDevice));
	HRR(cudaMemcpy(adj_list, graph->adj_list, adj_sz, cudaMemcpyHostToDevice));
	HRR(cudaMemcpy(beg_pos, graph->beg_pos, beg_sz, cudaMemcpyHostToDevice));

	if (has_edge_list)
	{
		size_t edge_sz = sizeof(vertex_t) * edge_count * 2;
		HRR(cudaMalloc((void **)&edge_list, edge_sz));
		HRR(cudaMemcpy(edge_list, graph->edge_list, edge_sz, cudaMemcpyHostToDevice));
	}
	
	spdlog::debug("Load graph from host to device, copy finished");
	spdlog::info("Load graph from host to device finished");
}

GPUGraph::~GPUGraph()
{
	HRR(cudaFree(beg_pos));
	HRR(cudaFree(src_list));
	HRR(cudaFree(adj_list));

	if (has_edge_list)
	{
		HRR(cudaFree(edge_list));
	}
}