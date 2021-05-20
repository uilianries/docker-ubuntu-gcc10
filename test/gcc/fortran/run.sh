#!/bin/bash

set -ex

compiler=$1

docker rm -f ${compiler}

docker run -t -d -v ${PWD}:/tmp/project --name ${compiler} uilianries/${compiler}
docker exec ${compiler} /tmp/project/test/gcc/fortran/test_fortran.sh

docker stop ${compiler}
docker rm -f ${compiler}
