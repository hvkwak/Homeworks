cmake_minimum_required(VERSION 3.10)
project(eidp-sequence VERSION 1.0)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED True)

# tell cmake where to look for *.hpp , *.h files
include_directories(include/)

# create library
add_library(eAutomobile src/eAutomobile.cpp)

# add executable main
add_executable(main main.cpp)

# tell the linker to bind these objects together
target_link_libraries(main PUBLIC eAutomobile)
