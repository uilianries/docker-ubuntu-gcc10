#!/bin/bash

set -ex

DOCKER_CONTAINER=compiler_container_clang11-xenial
DOCKER_IMAGE=uilianries/clang11-xenial

docker run -t -d --name ${DOCKER_CONTAINER} -v ${PWD}:/home/conan/project ${DOCKER_IMAGE}

# Validate VERSIONS
docker exec ${DOCKER_CONTAINER} clang --version
docker exec ${DOCKER_CONTAINER} clang++ --version
docker exec ${DOCKER_CONTAINER} pip install -U conan
docker exec ${DOCKER_CONTAINER} conan --version
docker exec ${DOCKER_CONTAINER} conan profile new default --detect
docker exec ${DOCKER_CONTAINER} conan profile update settings.compiler=clang default
docker exec ${DOCKER_CONTAINER} conan profile update settings.compiler.version=11 default

# Build Poco from source
docker exec ${DOCKER_CONTAINER}git clone https://github.com/conan-io/conan-center-index.git /tmp/cci
docker exec ${DOCKER_CONTAINER} conan create /tmp/cci/recipes/poco/all 1.9.4@ --build

# Building an App using Clang 11, and Fmt (clang 3.9)
docker exec ${DOCKER_CONTAINER} conan install poco/1.9.4@ -r conan-center -s compiler.version=3.9
docker exec ${DOCKER_CONTAINER} conan create project/test user/testing -s fmt:compiler.version=3.9

# Building an App using Clang 11, and Fmt (clang 3.9)
docker exec ${DOCKER_CONTAINER} conan install poco/1.9.4@ -r conan-center -s compiler.version=5
docker exec ${DOCKER_CONTAINER} conan create project/test user/testing -s fmt:compiler.version=5
docker exec ${DOCKER_CONTAINER} conan install poco/1.9.4@ -r conan-center -s compiler.version=5 -s compiler.libcxx=libstdc++11
docker exec ${DOCKER_CONTAINER} conan create project/test user/testing -s fmt:compiler.version=5 -s compiler.libcxx=libstdc++11

docker stop ${DOCKER_CONTAINER}
docker rm -f ${DOCKER_CONTAINER}
