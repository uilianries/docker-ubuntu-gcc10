#!/bin/bash

set -ex

compiler=$1

docker pull uilianries/${compiler}
docker run -t -d -v ${PWD}:/tmp/project --name ${compiler} uilianries/test
docker exec ${compiler} /tmp/project/test/run_test.sh

docker stop ${compiler}
docker rm ${compiler}

# Mount Vanilla Ubuntu Xenial and run executables built with libstdc++.so.0.6.28
docker run -t -d -v ${PWD}:/tmp/project --name ubuntu ubuntu:xenial
# Default Xenial libstdc++ is too old, foobar requires GLIBCXX_3.4.22
docker exec -w /tmp/project/test/conan/build ubuntu cp libstdc++.so.6.0.28 /usr/lib/x86_64-linux-gnu/libstdc++.so.6.0.21
docker exec -w /tmp/project/test/conan/build ubuntu bin/foobar
# No big deal with C app. It requires only libc
docker exec -w /tmp/project/test/conan/build ubuntu bin/foobar_c

docker stop ubuntu
docker rm ubuntu
