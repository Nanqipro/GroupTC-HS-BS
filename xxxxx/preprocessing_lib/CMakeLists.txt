cmake_minimum_required(VERSION 3.11)

project(TC-Compare LANGUAGES CXX CUDA)


if(CUDA_ENABLE)
    enable_language(CUDA)
endif()


set(CMAKE_CUDA_ARCHITECTURES  70)
set(CUDA_INCLUDE_DIRS "/usr/local/cuda/include")
set(CUDA_LIBRARIES "/usr/local/cuda/lib64")
message(STATUS "CMAKE_CUDA_ARCHITECTURES: " ${CMAKE_CUDA_ARCHITECTURES})
message(STATUS "PROJECT_DIRS: " ${CMAKE_CURRENT_SOURCE_DIR})
message(STATUS "CUDA_INCLUDE_DIRS: " ${CUDA_INCLUDE_DIRS})
message(STATUS "CUDA_LIBRARIES: " ${CUDA_LIBRARIES})

set(CUDA_NVCC_FLAGS -std=c++14)
set(CMAKE_CXX_STANDARD 14)

set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY  "${CMAKE_SOURCE_DIR}/libs/")


set(spdlog_DIR "/home/LiJB/cuda_project/spdlog/build")

if(NOT TARGET spdlog)
    # Stand-alone build
    find_package(spdlog REQUIRED)
endif()

include_directories(
    "/usr/local/cuda/include/"
    "include/"
)

file(GLOB_RECURSE CPP_SOURCES "src/*.cpp")
file(GLOB_RECURSE CUDA_SOURCES "src/*.cu")


add_library(proprecessing STATIC  
    ${CPP_SOURCES}  
    ${CUDA_SOURCES}
)

# ---------------------------------------------------------------------------------------
# Example of using pre-compiled library
# ---------------------------------------------------------------------------------------
# add_executable(main 
#     ${CPP_SOURCES}  
#     ${CUDA_SOURCES}
# )

# target_link_libraries(main PRIVATE spdlog::spdlog $<$<BOOL:${MINGW}>:ws2_32>)

# ---------------------------------------------------------------------------------------
# Example of using header-only library
# ---------------------------------------------------------------------------------------
# if(SPDLOG_BUILD_EXAMPLE_HO)
#     add_executable(example_header_only example.cpp)
#     target_link_libraries(example_header_only PRIVATE spdlog::spdlog_header_only)
# endif()