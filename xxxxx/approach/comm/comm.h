#pragma once
#include <iostream>
#include <fstream>
#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <unistd.h>

typedef int count_t;
typedef long int index_t;
typedef int vertex_t;

inline off_t fsize(const char *filename)
{
	struct stat st;
	if (stat(filename, &st) == 0)
	{
		return st.st_size;
	}
	return -1;
}

typedef struct edge
{
	vertex_t u;
	vertex_t v;
} edge;

