cmake_minimum_required(VERSION 3.10)

# set the project name and version
project(Blatt10 VERSION 1.0)

# specify the C++ standard
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED True)

# Set project binary folder: Full path to build directory for project.
set(PROJECT_BINARY_DIR ${CMAKE_SOURCE_DIR}/build)

# set sources
set(SOURCES
    bintree-test.cpp
    )

# add libraries
# add_library(eidpliste STATIC src/eidpliste.cpp include/eidpliste.h)

# add libraries, INTERFACE due to implementation in .h files.
add_library(eidpliste INTERFACE)
target_include_directories(eidpliste INTERFACE ${CMAKE_SOURCE_DIR}/include/)

add_library(bintree INTERFACE)
target_include_directories(bintree INTERFACE ${CMAKE_SOURCE_DIR}/include/)
target_link_libraries(bintree INTERFACE eidpliste)


# build main
add_executable(bintree-test bintree-test.cpp)
target_link_libraries(bintree-test PUBLIC bintree)


# tell cmake where to look for *.hpp , *.h files
target_include_directories(eidpliste INTERFACE
                          "${PROJECT_BINARY_DIR}"
                          "${CMAKE_SOURCE_DIR}/include/"
                          )


target_include_directories(bintree-test PUBLIC
                          "${PROJECT_BINARY_DIR}"
                          "${CMAKE_SOURCE_DIR}/include/"
                          )
