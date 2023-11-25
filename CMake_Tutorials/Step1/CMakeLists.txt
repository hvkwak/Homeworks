# TODO 1: Set the minimum required version of CMake to be 3.10
cmake_minimum_required(VERSION 3.10)

# TODO 2: Create a project named Tutorial
# This is deactivated due to TODO 7
# project(Tutorial)

# TODO 7: Adding a Version Number and Configured Header File
# this generates Tutorial_VERSION_MINOR, Tutorial_VERSION_MAJOR
project(Tutorial VERSION 1.0)

# TODO 6: specify the C++ standard
set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED True)

# TODO 8: Variable that is defined in your CMakelists.txt file can also be available in your source code, use a configured header file!
# Use configure_file to configure and copy TutorialConfig.h.in to TutorialConfig.h.
configure_file(TutorialConfig.h.in TutorialConfig.h)

# TODO 3: Make it executable
# Add an executable called Tutorial to the project
# Hint: Be sure to specify the source file as tutorial.cxx
# https://stackoverflow.com/questions/72173334/unable-to-get-cmake-tutorial-example-to-compile-why
add_executable(Tutorial tutorial.cxx)

# TODO 9: Use target_include_directories to include ${PROJECT_BINARY_DIR}
# Since the configured file will be written into the project binary directory, 
# we must add that directory to the list of paths to search for include files.
# add directory to list of paths to search for include files
target_include_directories(Tutorial PUBLIC
                           "${PROJECT_BINARY_DIR}"
                           
