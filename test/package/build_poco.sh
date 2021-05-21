#!/bin/bash

set -ex

POCO_FOLDER=/home/conan/conan-center-index/recipes/poco/all
POCO_VERSION=1.9.4

conan create ${POCO_FOLDER} boost/${POCO_VERSION}@ --build -s compiler.libcxx=libstdc++ -s build_type=Release -o boost:shared=False
conan create ${POCO_FOLDER} boost/${POCO_VERSION}@ --build -s compiler.libcxx=libstdc++ -s build_type=Debug   -o boost:shared=False
conan create ${POCO_FOLDER} boost/${POCO_VERSION}@ --build -s compiler.libcxx=libstdc++ -s build_type=Release -o boost:shared=True
conan create ${POCO_FOLDER} boost/${POCO_VERSION}@ --build -s compiler.libcxx=libstdc++ -s build_type=Debug   -o boost:shared=True

conan create ${POCO_FOLDER} boost/${POCO_VERSION}@ --build -s compiler.libcxx=libstdc++11 -s build_type=Release -o boost:shared=False
conan create ${POCO_FOLDER} boost/${POCO_VERSION}@ --build -s compiler.libcxx=libstdc++11 -s build_type=Debug   -o boost:shared=False
conan create ${POCO_FOLDER} boost/${POCO_VERSION}@ --build -s compiler.libcxx=libstdc++11 -s build_type=Release -o boost:shared=True
conan create ${POCO_FOLDER} boost/${POCO_VERSION}@ --build -s compiler.libcxx=libstdc++11 -s build_type=Debug   -o boost:shared=True

if grep clang /home/conan/.conan/conan.conf ; then

conan create ${POCO_FOLDER} boost/${POCO_VERSION}@ --build -s compiler.libcxx=libc++ -s build_type=Release -o boost:shared=False
conan create ${POCO_FOLDER} boost/${POCO_VERSION}@ --build -s compiler.libcxx=libc++ -s build_type=Debug   -o boost:shared=False
conan create ${POCO_FOLDER} boost/${POCO_VERSION}@ --build -s compiler.libcxx=libc++ -s build_type=Release -o boost:shared=True
conan create ${POCO_FOLDER} boost/${POCO_VERSION}@ --build -s compiler.libcxx=libc++ -s build_type=Debug   -o boost:shared=True

fi