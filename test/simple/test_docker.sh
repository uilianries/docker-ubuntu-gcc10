#!/bin/bash

set -ex

compiler=$1

docker rm -f ${compiler}

docker pull uilianries/${compiler}
docker run -t -d -v ${PWD}:/tmp/project --name ${compiler} uilianries/${compiler}
docker exec ${compiler} /tmp/project/test/simple/test_simple.sh

docker stop ${compiler}
docker rm -f ${compiler}
