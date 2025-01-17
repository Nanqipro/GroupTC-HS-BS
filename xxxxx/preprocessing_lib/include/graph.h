#pragma once
#include <fstream>
#include <string>
#include <iostream>
#include <sstream>
#include <queue>
#include "comm.h"

class Graph
{

public:
	std::string input_dir;
	vertex_t vertex_count;
	vertex_t edge_count;
	vertex_t max_degree;
	index_t *beg_pos;
	vertex_t *src_list;
	vertex_t *adj_list;
	bool has_edge_list;
	vertex_t *edge_list;

public:
	Graph(){};
	Graph(std::string filename);
	~Graph();
};
