#!/bin/bash

set -ex

IMAGL_FOLDER=/home/conan/conan-center-index/recipes/imagl/all
IMAGL_VERSION=0.2.1

echo "Building Imagl ${IMAGL_VERSION} - Requires C++20"

conan create ${IMAGL_FOLDER} ${IMAGL_VERSION}@ --build -s compiler.libcxx=libstdc++ -s build_type=Release
conan create ${IMAGL_FOLDER} ${IMAGL_VERSION}@ --build -s compiler.libcxx=libstdc++11 -s build_type=Release

if grep clang /home/conan/.conan/profiles/default ; then

conan create ${IMAGL_FOLDER} ${IMAGL_VERSION}@ --build -s compiler.libcxx=libc++ -s build_type=Release

fi