# CMAKE generated file: DO NOT EDIT!
# Generated by "Unix Makefiles" Generator, CMake Version 3.22

# Delete rule output on recipe failure.
.DELETE_ON_ERROR:

#=============================================================================
# Special targets provided by cmake.

# Disable implicit rules so canonical targets will work.
.SUFFIXES:

# Disable VCS-based implicit rules.
% : %,v

# Disable VCS-based implicit rules.
% : RCS/%

# Disable VCS-based implicit rules.
% : RCS/%,v

# Disable VCS-based implicit rules.
% : SCCS/s.%

# Disable VCS-based implicit rules.
% : s.%

.SUFFIXES: .hpux_make_needs_suffix_list

# Command-line flag to silence nested $(MAKE).
$(VERBOSE)MAKESILENT = -s

#Suppress display of executed commands.
$(VERBOSE).SILENT:

# A target that is always out of date.
cmake_force:
.PHONY : cmake_force

#=============================================================================
# Set environment variables for the build.

# The shell in which to execute make rules.
SHELL = /bin/sh

# The CMake executable.
CMAKE_COMMAND = /usr/bin/cmake

# The command to remove a file.
RM = /usr/bin/cmake -E rm -f

# Escaping for special characters.
EQUALS = =

# The top-level source directory on which CMake was run.
CMAKE_SOURCE_DIR = /app/ZJ/gitlocal/GroupTC-HS-BS

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = /app/ZJ/gitlocal/GroupTC-HS-BS/build

# Include any dependencies generated for this target.
include CMakeFiles/sort_no_index.dir/depend.make
# Include any dependencies generated by the compiler for this target.
include CMakeFiles/sort_no_index.dir/compiler_depend.make

# Include the progress variables for this target.
include CMakeFiles/sort_no_index.dir/progress.make

# Include the compile flags for this target's objects.
include CMakeFiles/sort_no_index.dir/flags.make

CMakeFiles/sort_no_index.dir/test/main_no_index.cu.o: CMakeFiles/sort_no_index.dir/flags.make
CMakeFiles/sort_no_index.dir/test/main_no_index.cu.o: ../test/main_no_index.cu
CMakeFiles/sort_no_index.dir/test/main_no_index.cu.o: CMakeFiles/sort_no_index.dir/compiler_depend.ts
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/app/ZJ/gitlocal/GroupTC-HS-BS/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building CUDA object CMakeFiles/sort_no_index.dir/test/main_no_index.cu.o"
	/usr/local/cuda-11.4/bin/nvcc -forward-unknown-to-host-compiler $(CUDA_DEFINES) $(CUDA_INCLUDES) $(CUDA_FLAGS) -MD -MT CMakeFiles/sort_no_index.dir/test/main_no_index.cu.o -MF CMakeFiles/sort_no_index.dir/test/main_no_index.cu.o.d -x cu -c /app/ZJ/gitlocal/GroupTC-HS-BS/test/main_no_index.cu -o CMakeFiles/sort_no_index.dir/test/main_no_index.cu.o

CMakeFiles/sort_no_index.dir/test/main_no_index.cu.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CUDA source to CMakeFiles/sort_no_index.dir/test/main_no_index.cu.i"
	$(CMAKE_COMMAND) -E cmake_unimplemented_variable CMAKE_CUDA_CREATE_PREPROCESSED_SOURCE

CMakeFiles/sort_no_index.dir/test/main_no_index.cu.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CUDA source to assembly CMakeFiles/sort_no_index.dir/test/main_no_index.cu.s"
	$(CMAKE_COMMAND) -E cmake_unimplemented_variable CMAKE_CUDA_CREATE_ASSEMBLY_SOURCE

# Object files for target sort_no_index
sort_no_index_OBJECTS = \
"CMakeFiles/sort_no_index.dir/test/main_no_index.cu.o"

# External object files for target sort_no_index
sort_no_index_EXTERNAL_OBJECTS =

sort_no_index: CMakeFiles/sort_no_index.dir/test/main_no_index.cu.o
sort_no_index: CMakeFiles/sort_no_index.dir/build.make
sort_no_index: CMakeFiles/sort_no_index.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --bold --progress-dir=/app/ZJ/gitlocal/GroupTC-HS-BS/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Linking CUDA executable sort_no_index"
	$(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/sort_no_index.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
CMakeFiles/sort_no_index.dir/build: sort_no_index
.PHONY : CMakeFiles/sort_no_index.dir/build

CMakeFiles/sort_no_index.dir/clean:
	$(CMAKE_COMMAND) -P CMakeFiles/sort_no_index.dir/cmake_clean.cmake
.PHONY : CMakeFiles/sort_no_index.dir/clean

CMakeFiles/sort_no_index.dir/depend:
	cd /app/ZJ/gitlocal/GroupTC-HS-BS/build && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /app/ZJ/gitlocal/GroupTC-HS-BS /app/ZJ/gitlocal/GroupTC-HS-BS /app/ZJ/gitlocal/GroupTC-HS-BS/build /app/ZJ/gitlocal/GroupTC-HS-BS/build /app/ZJ/gitlocal/GroupTC-HS-BS/build/CMakeFiles/sort_no_index.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : CMakeFiles/sort_no_index.dir/depend

