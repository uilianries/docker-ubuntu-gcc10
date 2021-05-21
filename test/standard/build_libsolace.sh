#!/bin/bash

set -ex

LIBSOLACE_FOLDER=/home/conan/conan-center-index/recipes/libsolace/all
LIBSOLACE_VERSION=0.3.9

export CONAN_PRINT_RUN_COMMANDS=1

conan config init --force

echo "Building libsolace ${LIBSOLACE_VERSION} - Requires C++17"

if grep gcc /home/conan/.conan/profiles/default ; then
    if egrep 'compiler\.version=(8,9|10|11|12)' /home/conan/.conan/profiles/default; then
        conan create ${LIBSOLACE_FOLDER} ${LIBSOLACE_VERSION}@ --build -s compiler.libcxx=libstdc++ -s build_type=Release
        conan create ${LIBSOLACE_FOLDER} ${LIBSOLACE_VERSION}@ --build -s compiler.libcxx=libstdc++11 -s build_type=Release
    fi
elif grep clang /home/conan/.conan/profiles/default ; then
    conan create ${LIBSOLACE_FOLDER} ${LIBSOLACE_VERSION}@ --build -s compiler.libcxx=libstdc++ -s build_type=Release
    conan create ${LIBSOLACE_FOLDER} ${LIBSOLACE_VERSION}@ --build -s compiler.libcxx=libstdc++11 -s build_type=Release
    conan create ${LIBSOLACE_FOLDER} ${LIBSOLACE_VERSION}@ --build -s compiler.libcxx=libc++ -s build_type=Release
fi