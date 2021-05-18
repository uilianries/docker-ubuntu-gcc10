cmake_minimum_required(VERSION 3.1)
project(foobar C CXX)

set(CMAKE_VERBOSE_MAKEFILE ON)

# include_directories(/usr/local/include/c++/10.3.0)
#include_directories(/usr/local/include/c++/v1/)
#set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -stdlib=libc++ -lc++abi --rtlib=compiler-rt")

add_executable(example-c main.c)
set_target_properties(example-c PROPERTIES C_STANDARD 99)
target_compile_options(example-c PRIVATE -v)

add_executable(example-cpp main.cpp)
set_target_properties(example-cpp PROPERTIES CXX_STANDARD 11)
target_compile_options(example-cpp PRIVATE -v)
#target_link_libraries(example-cpp PRIVATE unwind)
