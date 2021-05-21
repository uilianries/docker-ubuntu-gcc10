#!/bin/bash

set -ex

LIBSOLACE_FOLDER=/home/conan/conan-center-index/recipes/libsolace/all
LIBSOLACE_VERSION=0.3.9

echo "Building libsolace ${LIBSOLACE_VERSION} - Requires C++17"

conan create ${LIBSOLACE_FOLDER} ${LIBSOLACE_FOLDER}@ --build -s compiler.libcxx=libstdc++ -s build_type=Release
conan create ${LIBSOLACE_FOLDER} ${LIBSOLACE_FOLDER}@ --build -s compiler.libcxx=libstdc++11 -s build_type=Release

if grep clang /home/conan/.conan/profiles/default ; then

conan create ${LIBSOLACE_FOLDER} ${LIBSOLACE_FOLDER}@ --build -s compiler.libcxx=libc++ -s build_type=Release

fi