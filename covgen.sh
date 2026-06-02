#!/usr/bin/env sh

set -ex

mkdir -p ./coverage
lcov -c -d ./src -o coverage/lcov.info
