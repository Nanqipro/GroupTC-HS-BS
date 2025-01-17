#pragma once
#include <iostream>
#include <fstream>
#include <stdio.h>
#include <assert.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <unistd.h>
#include <sys/time.h>
#include <stdlib.h>

typedef int count_t;

typedef long int index_t;

typedef int vertex_t;

typedef struct edge
{
	index_t u, v;
} edge;

typedef struct vertex
{
	index_t id;
	int degree;
} vertex;

inline off_t fsize(const char *filename)
{
	struct stat st;
	if (stat(filename, &st) == 0)
	{
		return st.st_size;
	}
	return -1;
}

inline double wtime()
{
	double time[2];
	struct timeval time1;
	gettimeofday(&time1, NULL);

	time[0] = time1.tv_sec;
	time[1] = time1.tv_usec;

	return time[0] + time[1] * 1.0e-6;
}