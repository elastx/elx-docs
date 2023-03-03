#!/usr/bin/env sh

echo "Building and serving web content on http://localhost:1313/docs (Ctrl + C to exit)"
docker run --rm -v $(pwd):/root/project/ -p 1313:1313 -e HUGO_ENV=production quay.io/elastx/ci-hugo:v0.110.0 hugo server --bind 0.0.0.0
