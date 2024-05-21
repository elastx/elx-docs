#!/usr/bin/env sh

LOCAL_IMAGE="localhost/elx-docs:latest"

if command -v docker > /dev/null 2>&1; then
  if [ "$(docker image ls $LOCAL_IMAGE | wc -l)" = "1" ] || [ "$1" = "rebuild" ]; then
    DOCKER_BUILDKIT=1 docker build -t $LOCAL_IMAGE --build-arg LOCALTEST=yes --target builder .
  fi
  docker run --rm -v $(pwd):/project/ -p 1313:1313 $LOCAL_IMAGE
elif command -v podman > /dev/null 2>&1; then
  if [ "$(podman image ls $LOCAL_IMAGE | wc -l)" = "1" ] || [ "$1" = "rebuild" ]; then
    podman build -t $LOCAL_IMAGE --build-arg LOCALTEST=yes --target builder .
  fi
  podman run --rm --mount type=bind,source=$(pwd),destination=/project/ -p 1313:1313 $LOCAL_IMAGE
else
  echo "ERROR: No supported container engine found"
  exit 1
fi