#ifndef RESULTS
#define RESULTS

struct Runresult {
    int64_t deviceId;
    int64_t partitionId;
    int64_t totalPartitionCount;
    int64_t blockSize;
    int64_t threadPerInt;
    int64_t vertexCount;
    int64_t edgeCount;

    int64_t allocTime;
    int64_t relabelTime;
    int64_t tCountTime;
    int64_t localVertexCount;
    int64_t localShadowVertexCount;
    int64_t localEdgeCount;
    int64_t localShadowEdgeCount;
    int64_t localTriangleCount;
};

struct Result {
     uint deviceId;
     uint partitionId;
     uint partitionSize;
     uint indexArraySize;
    float triangleCountTime;
    float dataCreationTime;
     uint triangleCount;
    int64_t oldOffsetSize;
    int64_t newOffsetSize;
    int64_t oldIndexSize;
    int64_t newIndexSize;
    Result( uint _partitionSize,  uint _indexArraySize,  uint _triangleCount, float _runTime)
        : partitionSize(_partitionSize), indexArraySize(_indexArraySize), triangleCount(_triangleCount), triangleCountTime(_runTime) {}

    Result( uint _partitionId,  uint _partitionSize,  uint _indexArraySize,  uint _triangleCount, float _runTime)
        : partitionId(_partitionId),
          partitionSize(_partitionSize),
          indexArraySize(_indexArraySize),
          triangleCount(_triangleCount),
          triangleCountTime(_runTime) {}

    Result( uint _deviceId,  uint _partitionId,  uint _partitionSize,  uint _indexArraySize, float _dataCreationTime,
            uint _triangleCount, float _runTime)
        : deviceId(_deviceId),
          partitionId(_partitionId),
          partitionSize(_partitionSize),
          indexArraySize(_indexArraySize),
          dataCreationTime(_dataCreationTime),
          triangleCount(_triangleCount),
          triangleCountTime(_runTime) {}

    Result( uint _deviceId,  uint _partitionId,  uint _partitionSize,  uint _indexArraySize, float _dataCreationTime,
            uint _triangleCount, float _runTime, int64_t _oldOffsetSize, int64_t _newOffsetSize, int64_t _oldIndexSize, int64_t _newIndexSize)
        : deviceId(_deviceId),
          partitionId(_partitionId),
          partitionSize(_partitionSize),
          indexArraySize(_indexArraySize),
          dataCreationTime(_dataCreationTime),
          triangleCount(_triangleCount),
          triangleCountTime(_runTime),
          oldOffsetSize(_oldOffsetSize),
          newOffsetSize(_newOffsetSize),
          oldIndexSize(_oldIndexSize),
          newIndexSize(_newIndexSize) {}

    Result( uint _partitionSize,  uint _indexArraySize,  uint _triangleCount, float _dataCreationTime, float _runTime,
           int64_t _oldOffsetSize, int64_t _newOffsetSize, int64_t _oldIndexSize, int64_t _newIndexSize)
        : partitionSize(_partitionSize),
          indexArraySize(_indexArraySize),
          triangleCount(_triangleCount),
          dataCreationTime(_dataCreationTime),
          triangleCountTime(_runTime),
          oldOffsetSize(_oldOffsetSize),
          newOffsetSize(_newOffsetSize),
          oldIndexSize(_oldIndexSize),
          newIndexSize(_newIndexSize) {}

    void display() {
        std::cout << partitionSize << "\t\t\t" << indexArraySize << "\t\t\t" << triangleCount << "\t\t\t\t" << triangleCountTime << "\n";
    }
};
#endif
