#ifndef PARAM
#define PARAM
#include <iostream>
#include <vector>
#include <string>
#include <sstream>
#include <algorithm>
#define PAR_EXECNAME    0
#define PAR_FILENAME    1
#define PAR_DEVICE      2
#define PAR_ITER      3
#define PAR_BLOCKSIZE   4
#define PAR_THPERINTER  5
#define PAR_PARTITION   6
#define PAR_DEVICELIST  7

#define PAR_CPU_PARTITION 3

struct Param
{
  std::string fileName;
  int device;
  int64_t iter;
  int64_t threadCount;
  int64_t threadPerInt;
  int64_t partitionCount;
  bool doPartitionRun;
  bool testAll;
  bool valid;
  bool multiDevice;
  std::vector< uint> deviceMap;
  Param():fileName(""), device(-1), iter(-1), threadCount(-1),
  threadPerInt(-1), partitionCount(-1), doPartitionRun(false), testAll(false),
  valid(false), multiDevice(false){}
};

namespace globalParam
{
  extern const std::vector<int64_t> blockSizeParam;
  extern const std::vector<int64_t> threadPerIntersectionParam;
}

std::string paramRead(std::vector<int64_t>& paramVec, int argc,
    char *argv[]);
Param paramProcess(int argc, char *argv[]);
#endif
