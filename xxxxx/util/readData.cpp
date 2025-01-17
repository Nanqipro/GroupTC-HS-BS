#include <iostream>
#include <algorithm>
#include <fstream>
#include <cstdio>
#include <vector>
#include <sstream>
#include <cmath>
#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>

using namespace std;

typedef long int index_t;
typedef int vertex_t;

typedef struct edge
{
    int u, v;
} edge;

inline off_t fsize(const char *filename)
{
    struct stat st;
    if (stat(filename, &st) == 0)
    {
        return st.st_size;
    }
    return -1;
}
void readEdgeList(string filename)
{
    ifstream binFile(filename.c_str(), ios::in | ios::binary);
    int m = 0;
    binFile.read((char *)&m, sizeof(int));
    int size = 100 * sizeof(edge);
    edge edgeList[100];
    binFile.read((char *)&edgeList[0], size);
    binFile.close();

    for (int i = 0; i < 100; i++)
    {
        cout << i << "  " << edgeList[i].u << "  " << edgeList[i].v << endl;
    }
}

void readBin(string filename)
{
    ifstream binFile(filename.c_str(), ios::in | ios::binary);
    char *bin_file = const_cast<char *>(filename.c_str());
    int size = fsize(bin_file);
    long int arr[size / sizeof(long int)];
    binFile.read((char *)&arr[0], size);
    binFile.close();

    for (int i = 0; i < 100; i++)
    {
        cout << i << "  " << arr[i] << endl;
    }
}

void readCSR(string prefix)
{
    string s_begin = prefix + "/begin.bin";
    string s_source = prefix + "/source.bin";
    string s_adj = prefix + "/adjacent.bin";

    char *begin_file = const_cast<char *>(s_begin.c_str());
    char *source_file = const_cast<char *>(s_source.c_str());
    char *adj_file = const_cast<char *>(s_adj.c_str());

    ifstream beginFile(begin_file, ios::in | ios::binary);
    ifstream sourceFile(source_file, ios::in | ios::binary);
    ifstream adjFile(adj_file, ios::in | ios::binary);

    int vertex_count = fsize(begin_file) / sizeof(index_t) - 1;
    int edge_count = fsize(adj_file) / sizeof(vertex_t);

    cout << "vertex：" << vertex_count << "   edge：" << edge_count << endl;
    int sizeEdgeList = sizeof(vertex_t) * edge_count;
    int sizeAdjList = sizeof(index_t) * (vertex_count + 1);

    index_t *beginArr = (index_t *)malloc(sizeAdjList);
    vertex_t *sourceArr = (vertex_t *)malloc(sizeEdgeList);
    vertex_t *adjArr = (vertex_t *)malloc(sizeEdgeList);

    beginFile.read((char *)&beginArr[0], sizeAdjList);
    sourceFile.read((char *)&sourceArr[0], sizeEdgeList);
    adjFile.read((char *)&adjArr[0], sizeEdgeList);

    beginFile.close();
    sourceFile.close();
    adjFile.close();

    int prevU = -1, prevV = -1, u, v;
    for (int i = 0; i < 100; i++)
    {
        u = sourceArr[i];
        v = adjArr[i];
        if (u >= v || (u <= prevU && v <= prevV))
        {
            cout << u << " " << v << endl;
        }
        prevU = u;
        prevV = v;
    cout << sourceArr[i] << "  " << adjArr[i] << endl;
    }

    // for (int i = 0; i < 100; i++)
    // {
    //     cout << beginArr[i] << "  " << endl;
    // }

    cout << endl;
    free(sourceArr);
    free(adjArr);
    free(beginArr);
}
int main(int argc, char *argv[])
{
    int type = atoi(argv[1]);
    string str = argv[2];
    if (type == 1)
    {
        readEdgeList(str);
    }
    else if (type == 2)
    {
        readBin(str);
    }
    else
    {
        readCSR(str);
    }
}