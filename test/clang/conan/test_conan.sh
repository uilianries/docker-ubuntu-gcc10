#!/bin/bash

set -ex

python --version
pip --version
cmake --version
conan --version
cpp --version
cc --version

export CONAN_USER_HOME=/tmp/conan

mkdir -p /tmp/build
rm -rf /tmp/build/*

conan config init --force

pushd /tmp/build

conan create ../project/test/clang/conan foo/0.1@user/testing --build -s compiler.libcxx=libc++
conan install foo/0.1@user/testing -g deploy -s compiler.libcxx=libc++

ldd bin/foobar | grep 'libc++.so.1 => /usr/local/lib/libc++.so.1'
ldd bin/foobar | grep 'libunwind.so.1 => /usr/local/lib/libunwind.so.1'
ldd bin/foobar | grep 'libc++abi.so.1 => /usr/local/lib/libc++abi.so.1'
ldd bin/foobar | grep -v 'libgcc'

mv bin/foobar ../project/foobar_cpp_libcpp
mv bin/foobar_c ../project/foobar_c_libcpp

cp /usr/local/lib64/libstdc++.so.6.0.28 ../project/libstdc++.so.6.0.28
cp /usr/local/lib/libunwind.so.1.0 ../project/libunwind.so.1.0

conan create .. foo/0.1@user/testing --build -s compiler.libcxx=libstdc++
conan install foo/0.1@user/testing -g deploy

ldd bin/foobar | grep -v 'libc++'
ldd bin/foobar | grep 'libunwind.so.1 => /usr/local/lib/libunwind.so.1'
ldd bin/foobar | grep -v 'libc++abi'
ldd bin/foobar | grep 'libgcc_s.so.1 => /usr/local/lib64/libgcc_s.so.1'
ldd bin/foobar | grep 'libstdc++.so.6 => /usr/local/lib64/libstdc++.so.6'

mv bin/foobar ../project/foobar_cpp_libstdcpp
mv bin/foobar_c ../project/foobar_c_libstdcpp

conan create .. foo/0.1@user/testing --build -s compiler.libcxx=libstdc++11
conan install foo/0.1@user/testing -g deploy

ldd bin/foobar | grep -v 'libc++'
ldd bin/foobar | grep 'libunwind.so.1 => /usr/local/lib/libunwind.so.1'
ldd bin/foobar | grep -v 'libc++abi'
ldd bin/foobar | grep 'libgcc_s.so.1 => /usr/local/lib64/libgcc_s.so.1'
ldd bin/foobar | grep 'libstdc++.so.6 => /usr/local/lib64/libstdc++.so.6'

mv bin/foobar ../project/foobar_cpp_libstdcpp11
mv bin/foobar_c ../project/foobar_c_libstdcpp11
