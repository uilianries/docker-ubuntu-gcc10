#!/bin/bash

set -ex

POCO_FOLDER=/home/conan/conan-center-index/recipes/poco/all
POCO_VERSION=1.9.4

conan create ${POCO_FOLDER} poco/${POCO_VERSION}@ --build -s compiler.libcxx=libstdc++ -s build_type=Release -o poco:shared=False
conan create ${POCO_FOLDER} poco/${POCO_VERSION}@ --build -s compiler.libcxx=libstdc++ -s build_type=Debug   -o poco:shared=False
conan create ${POCO_FOLDER} poco/${POCO_VERSION}@ --build -s compiler.libcxx=libstdc++ -s build_type=Release -o poco:shared=True
conan create ${POCO_FOLDER} poco/${POCO_VERSION}@ --build -s compiler.libcxx=libstdc++ -s build_type=Debug   -o poco:shared=True

conan create ${POCO_FOLDER} poco/${POCO_VERSION}@ --build -s compiler.libcxx=libstdc++11 -s build_type=Release -o poco:shared=False
conan create ${POCO_FOLDER} poco/${POCO_VERSION}@ --build -s compiler.libcxx=libstdc++11 -s build_type=Debug   -o poco:shared=False
conan create ${POCO_FOLDER} poco/${POCO_VERSION}@ --build -s compiler.libcxx=libstdc++11 -s build_type=Release -o poco:shared=True
conan create ${POCO_FOLDER} poco/${POCO_VERSION}@ --build -s compiler.libcxx=libstdc++11 -s build_type=Debug   -o poco:shared=True

if grep clang if grep clang /home/conan/.conan/profiles/default ; then

conan create ${POCO_FOLDER} poco/${POCO_VERSION}@ --build -s compiler.libcxx=libc++ -s build_type=Release -o poco:shared=False
conan create ${POCO_FOLDER} poco/${POCO_VERSION}@ --build -s compiler.libcxx=libc++ -s build_type=Debug   -o poco:shared=False
conan create ${POCO_FOLDER} poco/${POCO_VERSION}@ --build -s compiler.libcxx=libc++ -s build_type=Release -o poco:shared=True
conan create ${POCO_FOLDER} poco/${POCO_VERSION}@ --build -s compiler.libcxx=libc++ -s build_type=Debug   -o poco:shared=True

fi