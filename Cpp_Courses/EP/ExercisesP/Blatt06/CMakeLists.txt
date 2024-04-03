cmake_minimum_required(VERSION 3.10)
project(eidp-sequence VERSION 1.0)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED True)

# tell cmake where to look for *.hpp , *.h files
include_directories(include/)

# create library "libtools"
add_library(rekEidp src/rekEidp.cpp)
add_library(itEidp src/itEidp.cpp)
add_library(moivreBinetEidP src/moivreBinetEidP.cpp)

# add executable main
add_executable(eidp-sequence eidp-sequence.cpp)

# tell the linker to bind these objects together
target_link_libraries(eidp-sequence PUBLIC rekEidp itEidp moivreBinetEidP)
