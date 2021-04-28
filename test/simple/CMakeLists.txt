cmake_minimum_required(VERSION 3.1)
project(foobar C CXX)

set(CMAKE_VERBOSE_MAKEFILE ON)

add_executable(example-c main.c)
set_target_properties(example-c PROPERTIES C_STANDARD 99)

add_executable(example-cpp main.cpp)
set_target_properties(example-cpp PROPERTIES CXX_STANDARD 11)
