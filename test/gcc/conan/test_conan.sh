#!/bin/bash

set -ex

python --version
pip --version
cmake --version
conan --version
cpp --version
cc --version

export CONAN_USER_HOME=/tmp/project/conan

mkdir -p /tmp/build
rm -rf /tmp/build/*

pushd /tmp/build

conan config init --force
conan install -r conan-center zlib/1.2.11@ --build
conan install -r conan-center spdlog/1.8.5@ --build

conan create ../project/test/gcc/conan foo/0.1@user/testing
conan install foo/0.1@user/testing -g deploy

ldd bin/foobar | grep 'libstdc++.so.6 => /usr/local/lib64/libstdc++.so.6'
ldd bin/foobar | grep 'libgcc_s.so.1 => /usr/local/lib64/libgcc_s.so.1'

cp /usr/local/lib64/libstdc++.so.6.0.28 /tmp/project/
cp bin/foobar /tmp/project/foobar