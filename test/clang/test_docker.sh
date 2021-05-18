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

ldd bin/foobar | grep 'libc++.so.1 => /usr/local/lib/libc++.so.1'
ldd bin/foobar | grep 'libunwind.so.1 => /usr/local/lib/libunwind.so.1'
ldd bin/foobar | grep 'libc++abi.so.1 => /usr/local/lib/libc++abi.so.1'
ldd bin/foobar | grep -v 'libgcc'

mv bin/foobar bin/foobar_clang
mv bin/foobar_c bin/foobar_c_clang

cp /usr/local/lib64/libstdc++.so.6.0.28 bin/libstdc++.so.6.0.28
cp /usr/local/lib/libunwind.so.1.0 bin/libunwind.so.1.0

conan profile update settings.compiler.libcxx=libstdc++ default

conan install -r conan-center zlib/1.2.11@ --build
conan install -r conan-center spdlog/1.8.5@ --build

conan create .. foo/0.1@user/testing
conan install foo/0.1@user/testing -g deploy

ldd bin/foobar | grep -v 'libc++'
ldd bin/foobar | grep 'libunwind.so.1 => /usr/local/lib/libunwind.so.1'
ldd bin/foobar | grep -v 'libc++abi'
ldd bin/foobar | grep 'libgcc_s.so.1 => /usr/local/lib64/libgcc_s.so.1'
ldd bin/foobar | grep 'libstdc++.so.6 => /usr/local/lib64/libstdc++.so.6'
