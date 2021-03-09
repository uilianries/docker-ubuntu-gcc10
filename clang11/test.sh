#!/bin/bash

set -ex

DOCKER_CONTAINER=compiler_container_clang11
DOCKER_IMAGE=uilianries/clang11

docker run -t -d --name ${DOCKER_CONTAINER} -v ${PWD}:/home/conan/project ${DOCKER_IMAGE}

# Validate VERSIONS
docker exec ${DOCKER_CONTAINER} clang --version
docker exec ${DOCKER_CONTAINER} clang++ --version
docker exec ${DOCKER_CONTAINER} pip install -U conan
docker exec ${DOCKER_CONTAINER} conan --version
docker exec ${DOCKER_CONTAINER} conan profile new default --detect

# Building an App using Clang 11, and Fmt (clang 3.9)
docker exec ${DOCKER_CONTAINER} conan install fmt/7.1.3@ -r conan-center -s compiler.version=3.9
docker exec ${DOCKER_CONTAINER} conan create project/test user/testing -s fmt:compiler.version=3.9

# Building an App using Clang 11, and Fmt (clang 3.9)
docker exec ${DOCKER_CONTAINER} conan install fmt/7.1.3@ -r conan-center -s compiler.version=5
docker exec ${DOCKER_CONTAINER} conan create project/test user/testing -s fmt:compiler.version=5
docker exec ${DOCKER_CONTAINER} conan install fmt/7.1.3@ -r conan-center -s compiler.version=5 -s compiler.libcxx=libstdc++11
docker exec ${DOCKER_CONTAINER} conan create project/test user/testing -s fmt:compiler.version=5 -s compiler.libcxx=libstdc++11

docker stop ${DOCKER_CONTAINER}
docker rm -f ${DOCKER_CONTAINER}
