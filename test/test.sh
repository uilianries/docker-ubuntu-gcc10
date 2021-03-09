#!/bin/bash

set -ex

DOCKER_CONTAINER=compiler_container
DOCKER_IMAGE=uilianries/gcc10

docker run -t -d --name ${DOCKER_CONTAINER} -v ${PWD}:/home/conan/project ${DOCKER_IMAGE}

# Validate VERSIONS
docker exec ${DOCKER_CONTAINER} gcc --version
docker exec ${DOCKER_CONTAINER} g++ --version
docker exec ${DOCKER_CONTAINER} pip install -U conan
docker exec ${DOCKER_CONTAINER} conan --version
docker exec ${DOCKER_CONTAINER} conan profile new default --detect

# Building an App using GCC 10, and Fmt (GCC 4.9)
docker exec ${DOCKER_CONTAINER} conan install fmt/7.1.3@ -r conan-center -s compiler.version=4.9
docker exec ${DOCKER_CONTAINER} conan create project/test user/testing -s fmt:compiler.version=4.9
