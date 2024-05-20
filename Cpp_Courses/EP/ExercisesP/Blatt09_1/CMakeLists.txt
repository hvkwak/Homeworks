cmake_minimum_required(VERSION 3.10)

# set the project name and version
project(Blatt09_1 VERSION 1.0)

# specify the C++ standard
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED True)

# Set project binary folder: Full path to build directory for project.
set(PROJECT_BINARY_DIR ${CMAKE_SOURCE_DIR}/build)

# set sources
set(SOURCES
    stack_test.cpp
    src/stack.cpp
    )

# add libraries
add_library(stack STATIC src/stack.cpp include/stack.h)


# add libraries
# -> auskommentieren, um src/stack.cpp zu verwenden.
# add_library(stack INTERFACE)
# target_include_directories(stack INTERFACE ${CMAKE_SOURCE_DIR}/include/)


# build main
add_executable(stack_test stack_test.cpp)



# tell the linker to bind these objects together
target_link_libraries(stack_test PUBLIC stack)


# tell cmake where to look for *.hpp , *.h files
target_include_directories(stack PUBLIC
                          "${PROJECT_BINARY_DIR}"
                          "${CMAKE_SOURCE_DIR}/include/"
                          )


target_include_directories(stack_test PUBLIC
                          "${PROJECT_BINARY_DIR}"
                          "${CMAKE_SOURCE_DIR}/include/"
                          )
