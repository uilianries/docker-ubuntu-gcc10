#!/bin/bash

set -ex

python --version
pip --version
cmake --version
conan --version
cpp --version
cc --version

export CONAN_USER_HOME=/tmp/project/test/clang/conan/build

conan config init --force
conan profile update settings.compiler.libcxx=libc++ default
conan install -r conan-center zlib/1.2.11@ --build
conan install -r conan-center spdlog/1.8.5@ --build

pushd /tmp/project/test/clang/conan/build

conan create .. foo/0.1@user/testing
conan install foo/0.1@user/testing -g deploy

ldd bin/foobar | grep 'libstdc++.so.6 => /usr/local/lib64/libstdc++.so.6'
ldd bin/foobar | grep 'libgcc_s.so.1 => /usr/local/lib64/libgcc_s.so.1'

cp /usr/local/lib64/libstdc++.so.6.0.28 .
