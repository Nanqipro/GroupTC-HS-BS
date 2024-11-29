cmake_minimum_required(VERSION 3.11)

# 指定 CUDA 编译器和主机编译器版本
set(CMAKE_CUDA_COMPILER "/usr/local/cuda-11.4/bin/nvcc")
set(CMAKE_CUDA_HOST_COMPILER "/usr/bin/gcc-9")  # 添加此行指定主机编译器

# 设置 CUDA 架构
set(CMAKE_CUDA_ARCHITECTURES 70)
set(CUDA_INCLUDE_DIRS "/usr/local/cuda-11.4/include")
set(CUDA_LIBRARIES "/usr/local/cuda-11.4/lib64")

message(STATUS "CMAKE_CUDA_ARCHITECTURES: " ${CMAKE_CUDA_ARCHITECTURES})
message(STATUS "PROJECT_DIRS: " ${CMAKE_CURRENT_SOURCE_DIR})
message(STATUS "CUDA_INCLUDE_DIRS: " ${CUDA_INCLUDE_DIRS})
message(STATUS "CUDA_LIBRARIES: " ${CUDA_LIBRARIES})

# 设置 C++ 标准
set(CMAKE_CXX_STANDARD 14)

# 设置编译标志
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -O3")
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++14 -O3")
set(CMAKE_CUDA_FLAGS "${CMAKE_CUDA_FLAGS} -std=c++14 -O3 -allow-unsupported-compiler")  # 修改此行，添加 -allow-unsupported-compiler

message(STATUS "CUDA_NVCC_FLAGS: " ${CMAKE_CUDA_FLAGS})

project(TC-Compare LANGUAGES CXX CUDA)

set(spdlog_DIR "/home/LiJB/cuda_project/spdlog/build")

if(NOT TARGET spdlog)
    # Stand-alone build
    find_package(spdlog REQUIRED)
endif()

include_directories(
    "/usr/local/cuda-11.4/include/"
    "include/"
    "3rdparty/"
)

# 查找源文件
file(GLOB_RECURSE CPP_SOURCES "src/*.cpp")
file(GLOB_RECURSE CUDA_SOURCES "src/*.cu")

# 添加可执行文件
add_executable(main 
    ${CPP_SOURCES}  
    ${CUDA_SOURCES}
)

# 链接 spdlog 库
# target_link_libraries(main PRIVATE spdlog::spdlog $<$<BOOL:${MINGW}>:ws2_32>)
