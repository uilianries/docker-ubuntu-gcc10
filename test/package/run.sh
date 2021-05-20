#!/bin/bash

set -ex

compiler=$1

docker run -t -d --name ${compiler} uilianries/${compiler}
docker exec ${compiler} git clone https://github.com/conan-io/conan-center-index.git
docker exec ${compiler} conan create conan-center-index/recipes/boost/all boost/1.76.0@user/testing --build

docker stop ${compiler}
docker rm -f ${compiler}
