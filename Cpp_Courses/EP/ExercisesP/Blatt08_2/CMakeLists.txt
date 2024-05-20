cmake_minimum_required(VERSION 3.10)

# set the project name and version
project(Blatt08_2 VERSION 1.0)

# specify the C++ standard
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED True)

# Set project binary folder: Full path to build directory for project.
set(PROJECT_BINARY_DIR ${CMAKE_SOURCE_DIR}/build)

# set sources!
#set(SOURCES
#    testumgebung.cpp
#    src/benutzer.cpp
#    src/bibmanager.cpp
#    src/buch.cpp
#    src/bibliothek.cpp
#    )

# add libraries
add_library(benutzer STATIC src/benutzer.cpp include/benutzer.h)
add_library(bibmanager STATIC src/bibmanager.cpp include/bibmanager.h)
add_library(buch STATIC src/buch.cpp include/buch.h)

# add eidplist.h, note that there is no eidpliste.cpp, just a header. Use INTERFACE AND target_include_directories
add_library(eidpliste INTERFACE)
target_include_directories(eidpliste INTERFACE ${CMAKE_SOURCE_DIR}/include/)

# build bibliothek and link with others
add_library(bibliothek STATIC src/bibliothek.cpp include/bibliothek.h)
target_link_libraries(bibliothek PRIVATE buch benutzer eidpliste)

# build main
add_executable(main testumgebung.cpp)

# tell the linker to bind these objects together
target_link_libraries(main PUBLIC bibliothek bibmanager)

# add libaries: bibliothek.cpp
target_include_directories(bibliothek PUBLIC
                          "${PROJECT_BINARY_DIR}"
                          "${CMAKE_SOURCE_DIR}/include/"
                          )

# tell cmake where to look for *.hpp , *.h files
target_include_directories(main PUBLIC
                          "${PROJECT_BINARY_DIR}"
                          "${CMAKE_SOURCE_DIR}/include/"
                           )
