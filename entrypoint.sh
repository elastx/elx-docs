#!/bin/sh
set -e

./npm-deps.sh
exec hugo server --baseURL http://localhost:1313 --bind 0.0.0.0