#!/usr/bin/env bash
# run this script to setup cpp development environment
# this includes installation of LLVM, Clang

CLANG_VERSION=16

# install llvm
sudo bash -c "$(wget -O - https://apt.llvm.org/llvm.sh)"
wget https://apt.llvm.org/llvm.sh
chmod +x llvm.sh
sudo ./llvm.sh $CLANG_VERSION all

# Clang and co
sudo apt-get install clang-${CLANG_VERSION} clang-tools-${CLANG_VERSION} clang-${CLANG_VERSION}-doc libclang-common-${CLANG_VERSION}-dev libclang-${CLANG_VERSION}-dev libclang1-${CLANG_VERSION} clang-format-${CLANG_VERSION} python3-clang-${CLANG_VERSION} clangd-${CLANG_VERSION} clang-tidy-${CLANG_VERSION}

# lldb
sudo apt-get install lldb-16
# lld (linker)
sudo apt-get install lld-16
# libc++
sudo apt-get install libc++-16-dev libc++abi-16-dev
# OpenMP
sudo apt-get install libomp-16-dev
