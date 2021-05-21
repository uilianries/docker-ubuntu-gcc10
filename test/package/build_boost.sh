#!/bin/bash

set -ex

BOOST_FOLDER=/home/conan/conan-center-index/recipes/boost/all
BOOST_VERSION=1.76.0

conan create ${BOOST_FOLDER} boost/${BOOST_VERSION}@ --build -s compiler.libcxx=libstdc++ -s build_type=Release -o boost:shared=False
conan create ${BOOST_FOLDER} boost/${BOOST_VERSION}@ --build -s compiler.libcxx=libstdc++ -s build_type=Debug   -o boost:shared=False
conan create ${BOOST_FOLDER} boost/${BOOST_VERSION}@ --build -s compiler.libcxx=libstdc++ -s build_type=Release -o boost:shared=True
conan create ${BOOST_FOLDER} boost/${BOOST_VERSION}@ --build -s compiler.libcxx=libstdc++ -s build_type=Debug   -o boost:shared=True

conan create ${BOOST_FOLDER} boost/${BOOST_VERSION}@ --build -s compiler.libcxx=libstdc++11 -s build_type=Release -o boost:shared=False
conan create ${BOOST_FOLDER} boost/${BOOST_VERSION}@ --build -s compiler.libcxx=libstdc++11 -s build_type=Debug   -o boost:shared=False
conan create ${BOOST_FOLDER} boost/${BOOST_VERSION}@ --build -s compiler.libcxx=libstdc++11 -s build_type=Release -o boost:shared=True
conan create ${BOOST_FOLDER} boost/${BOOST_VERSION}@ --build -s compiler.libcxx=libstdc++11 -s build_type=Debug   -o boost:shared=True

if grep clang /home/conan/.conan/conan.conf ; then

conan create ${BOOST_FOLDER} boost/${BOOST_VERSION}@ --build -s compiler.libcxx=libc++ -s build_type=Release -o boost:shared=False
conan create ${BOOST_FOLDER} boost/${BOOST_VERSION}@ --build -s compiler.libcxx=libc++ -s build_type=Debug   -o boost:shared=False
conan create ${BOOST_FOLDER} boost/${BOOST_VERSION}@ --build -s compiler.libcxx=libc++ -s build_type=Release -o boost:shared=True
conan create ${BOOST_FOLDER} boost/${BOOST_VERSION}@ --build -s compiler.libcxx=libc++ -s build_type=Debug   -o boost:shared=True

fi