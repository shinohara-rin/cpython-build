#!/bin/sh

set -x

CPYTHON_VERSION=$1
ARCH=$2

curl https://codeload.github.com/python/cpython/tar.gz/refs/tags/v${CPYTHON_VERSION}

./configure --enable-optimizations

BUILD_VERSION=echo "${CPYTHON_VERSION}" | cut -d '.' -f 1-2

make -j$(nproc) libpython${BUILD_VERSION}.a libpython${BUILD_VERSION}.so

tar -czf "/work/libpython${CYTHON_VERSION}-${ARCH}-linux-gnu.tar.gz" libpython*