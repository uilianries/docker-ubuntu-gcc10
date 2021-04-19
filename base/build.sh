#!/bin/bash

set -ex

DOCKER_IMAGE=uilianries/base

docker build -t $DOCKER_IMAGE
docker inspect $DOCKER_IMAGE
