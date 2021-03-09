cmake_minimum_required(VERSION 3.1)
project(foobar CXX)

include(${CMAKE_BINARY_DIR}/conanbuildinfo.cmake)
conan_basic_setup()

find_package(fmt REQUIRED)

add_executable(${CMAKE_PROJECT_NAME} main.cpp)
target_link_libraries(${CMAKE_PROJECT_NAME} fmt::fmt)
set_target_properties(${CMAKE_PROJECT_NAME} PROPERTIES CXX_STANDARD 11)

enable_testing()
add_test(test_foobar ${CMAKE_BINARY_DIR}/bin/${CMAKE_PROJECT_NAME})
