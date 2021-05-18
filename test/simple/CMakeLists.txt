cmake_minimum_required(VERSION 3.1)
project(foobar C CXX)

set(CMAKE_VERBOSE_MAKEFILE ON)

add_executable(example-c main.c)
set_target_properties(example-c PROPERTIES C_STANDARD 99)

add_executable(example-cpp main.cpp)
set_target_properties(example-cpp PROPERTIES CXX_STANDARD 11)
if (CMAKE_CXX_COMPILER_ID STREQUAL "Clang")
    target_compile_options(example-cpp PRIVATE -stdlib=libc++ --rtlib=compiler-rt)

    add_executable(example-cpp-clang main.cpp)
    set_target_properties(example-cpp-clang PROPERTIES CXX_STANDARD 11)
    target_compile_options(example-cpp PRIVATE -stdlib=libstdc++ --rtlib=compiler-rt)
endif()
