#!/bin/bash

set -ex

compiler=$1

docker run -t -d -v ${PWD}:/tmp/project --name ${compiler} ${DOCKER_REPOSITORY}/${compiler}
docker exec ${compiler} git clone https://github.com/conan-io/conan-center-index.git
docker exec ${compiler} -w python /tmp/project/test/package/build_boost.sh
docker exec ${compiler} -w python /tmp/project/test/package/build_poco.sh

docker stop ${compiler}
docker rm -f ${compiler}
