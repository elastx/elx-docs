#!/usr/bin/env sh

echo "Building and serving web content on http://localhost:1313/docs (Ctrl + C to exit)"
git submodule update --init --recursive
docker run --rm -v $(pwd):/root/project/ -p 1313:1313 -e HUGO_ENV=production quay.io/elastx/ci-hugo:0.87.0 hugo server --bind 0.0.0.0
