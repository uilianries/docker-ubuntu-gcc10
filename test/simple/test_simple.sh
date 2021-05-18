#!/bin/bash

set -ex

mkdir -p /tmp/project/test/simple/build
rm -rf /tmp/project/test/simple/build*

pushd /tmp/project/test/simple/build

cmake .. -DCMAKE_BUILD_TYPE=Release
cmake --build

./example-c
./example-cpp

if [ -f example-cpp-clang ]
    ./example-cpp-clang
fi
