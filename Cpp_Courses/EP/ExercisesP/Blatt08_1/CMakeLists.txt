cmake_minimum_required(VERSION 3.10)
project(eidp-sequence VERSION 1.0)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED True)
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/build)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/build)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)

# tell cmake where to look for *.hpp , *.h files
include_directories(include/)

# create library
add_library(buch src/buch.cpp)

# add executable main
add_executable(main buchTest.cpp)

# tell the linker to bind these objects together
target_link_libraries(main PUBLIC buch)
