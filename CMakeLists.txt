cmake_minimum_required(VERSION 3.11)

set(CMAKE_CUDA_COMPILER "/usr/local/cuda-11.4/bin/nvcc")
set(CMAKE_CUDA_ARCHITECTURES  70)
set(CUDA_INCLUDE_DIRS "/usr/local/cuda-11.4/include")
set(CUDA_LIBRARIES "/usr/local/cuda-11.4/lib64")

message(STATUS "CMAKE_CUDA_ARCHITECTURES: " ${CMAKE_CUDA_ARCHITECTURES})
message(STATUS "PROJECT_DIRS: " ${CMAKE_CURRENT_SOURCE_DIR})
message(STATUS "CUDA_INCLUDE_DIRS: " ${CUDA_INCLUDE_DIRS})
message(STATUS "CUDA_LIBRARIES: " ${CUDA_LIBRARIES})

set(CMAKE_CXX_STANDARD 14)
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -O3")
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS}-std=c++14 -O3")
set(CUDA_NVCC_FLAGS "${CUDA_NVCC_FLAGS} -std=c++14 -O3 --extended-lambda")

message(STATUS "CUDA_NVCC_FLAGS: " ${CUDA_NVCC_FLAGS})
# set(CMAKE_C_COMPILER "/usr/bin/gcc-11")
# set(CMAKE_CXX_COMPILER "/usr/bin/g++-11")
# set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY  "${CMAKE_SOURCE_DIR}/libs/")


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

file(GLOB_RECURSE CPP_SOURCES "src/*.cpp")
file(GLOB_RECURSE CUDA_SOURCES "src/*.cu")

# add_library(proprecessing STATIC  
#     ${CPP_SOURCES}  
#     ${CUDA_SOURCES}
# )

# ---------------------------------------------------------------------------------------
# Example of using pre-compiled library
# ---------------------------------------------------------------------------------------
add_executable(main 
    ${CPP_SOURCES}  
    ${CUDA_SOURCES}
)

# target_link_libraries(main PRIVATE spdlog::spdlog $<$<BOOL:${MINGW}>:ws2_32>)

# ---------------------------------------------------------------------------------------
# 测试目录下的CUDA代码
# ---------------------------------------------------------------------------------------
file(GLOB_RECURSE TEST_CPP_SOURCES "test/*.cpp")
file(GLOB_RECURSE TEST_CUDA_SOURCES "test/*.cu")

# 添加基于前n位排序的测试程序
add_executable(sort_by_bits 
    ${TEST_CUDA_SOURCES}
)

target_link_libraries(sort_by_bits PRIVATE 
    ${CUDA_LIBRARIES}
)

# 添加不带索引的排序程序
add_executable(sort_no_index 
    test/main_no_index.cu
)

target_link_libraries(sort_no_index PRIVATE 
    ${CUDA_LIBRARIES}
)

target_compile_options(sort_no_index PRIVATE 
    $<$<COMPILE_LANGUAGE:CUDA>:--extended-lambda>)

# 增加相应的CUDA编译器标志
target_compile_options(sort_by_bits PRIVATE 
    $<$<COMPILE_LANGUAGE:CUDA>:--extended-lambda>)

# ---------------------------------------------------------------------------------------
# Example of using header-only library
# ---------------------------------------------------------------------------------------
# if(SPDLOG_BUILD_EXAMPLE_HO)
#     add_executable(example_header_only example.cpp)
#     target_link_libraries(example_header_only PRIVATE spdlog::spdlog_header_only)
# endif()
