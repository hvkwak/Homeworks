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
CMAKE_SOURCE_DIR = /home/hyobin/Documents/Blatt06

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = /home/hyobin/Documents/Blatt06/build

# Include any dependencies generated for this target.
include CMakeFiles/eidp-sequence.dir/depend.make
# Include any dependencies generated by the compiler for this target.
include CMakeFiles/eidp-sequence.dir/compiler_depend.make

# Include the progress variables for this target.
include CMakeFiles/eidp-sequence.dir/progress.make

# Include the compile flags for this target's objects.
include CMakeFiles/eidp-sequence.dir/flags.make

CMakeFiles/eidp-sequence.dir/eidp-sequence.cpp.o: CMakeFiles/eidp-sequence.dir/flags.make
CMakeFiles/eidp-sequence.dir/eidp-sequence.cpp.o: ../eidp-sequence.cpp
CMakeFiles/eidp-sequence.dir/eidp-sequence.cpp.o: CMakeFiles/eidp-sequence.dir/compiler_depend.ts
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/hyobin/Documents/Blatt06/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building CXX object CMakeFiles/eidp-sequence.dir/eidp-sequence.cpp.o"
	/usr/bin/clang++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -MD -MT CMakeFiles/eidp-sequence.dir/eidp-sequence.cpp.o -MF CMakeFiles/eidp-sequence.dir/eidp-sequence.cpp.o.d -o CMakeFiles/eidp-sequence.dir/eidp-sequence.cpp.o -c /home/hyobin/Documents/Blatt06/eidp-sequence.cpp

CMakeFiles/eidp-sequence.dir/eidp-sequence.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/eidp-sequence.dir/eidp-sequence.cpp.i"
	/usr/bin/clang++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /home/hyobin/Documents/Blatt06/eidp-sequence.cpp > CMakeFiles/eidp-sequence.dir/eidp-sequence.cpp.i

CMakeFiles/eidp-sequence.dir/eidp-sequence.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/eidp-sequence.dir/eidp-sequence.cpp.s"
	/usr/bin/clang++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /home/hyobin/Documents/Blatt06/eidp-sequence.cpp -o CMakeFiles/eidp-sequence.dir/eidp-sequence.cpp.s

# Object files for target eidp-sequence
eidp__sequence_OBJECTS = \
"CMakeFiles/eidp-sequence.dir/eidp-sequence.cpp.o"

# External object files for target eidp-sequence
eidp__sequence_EXTERNAL_OBJECTS =

eidp-sequence: CMakeFiles/eidp-sequence.dir/eidp-sequence.cpp.o
eidp-sequence: CMakeFiles/eidp-sequence.dir/build.make
eidp-sequence: librekEidp.a
eidp-sequence: libitEidp.a
eidp-sequence: libmoivreBinetEidP.a
eidp-sequence: CMakeFiles/eidp-sequence.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --bold --progress-dir=/home/hyobin/Documents/Blatt06/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Linking CXX executable eidp-sequence"
	$(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/eidp-sequence.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
CMakeFiles/eidp-sequence.dir/build: eidp-sequence
.PHONY : CMakeFiles/eidp-sequence.dir/build

CMakeFiles/eidp-sequence.dir/clean:
	$(CMAKE_COMMAND) -P CMakeFiles/eidp-sequence.dir/cmake_clean.cmake
.PHONY : CMakeFiles/eidp-sequence.dir/clean

CMakeFiles/eidp-sequence.dir/depend:
	cd /home/hyobin/Documents/Blatt06/build && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /home/hyobin/Documents/Blatt06 /home/hyobin/Documents/Blatt06 /home/hyobin/Documents/Blatt06/build /home/hyobin/Documents/Blatt06/build /home/hyobin/Documents/Blatt06/build/CMakeFiles/eidp-sequence.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : CMakeFiles/eidp-sequence.dir/depend

