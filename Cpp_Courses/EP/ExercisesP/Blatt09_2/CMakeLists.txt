cmake_minimum_required(VERSION 3.10)

# set the project name and version
project(Blatt09_2 VERSION 1.0)

# specify the C++ standard
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED True)

# Set project binary folder: Full path to build directory for project.
set(PROJECT_BINARY_DIR ${CMAKE_SOURCE_DIR}/build)

# set sources
set(SOURCES
    eidpliste_test.cpp
    src/eidpliste.cpp
    )

# add libraries
add_library(eidpliste STATIC src/eidpliste.cpp include/eidpliste.h)

# add libraries
# -> auskommentieren, um src/eidpliste.cpp zu verwenden.
# add_library(stack INTERFACE)
# target_include_directories(stack INTERFACE ${CMAKE_SOURCE_DIR}/include/)


# build main
add_executable(eidpliste_test eidpliste_test.cpp)



# tell the linker to bind these objects together
target_link_libraries(eidpliste_test PUBLIC eidpliste)


# tell cmake where to look for *.hpp , *.h files
target_include_directories(eidpliste PUBLIC
                          "${PROJECT_BINARY_DIR}"
                          "${CMAKE_SOURCE_DIR}/include/"
                          )


target_include_directories(eidpliste_test PUBLIC
                          "${PROJECT_BINARY_DIR}"
                          "${CMAKE_SOURCE_DIR}/include/"
                          )
