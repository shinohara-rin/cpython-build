#!/bin/sh

set -x

CPYTHON_VERSION=$1
ARCH=$2
BUILD_VERSION=$(echo "${CPYTHON_VERSION}" | cut -d '.' -f 1-2)

case "${ARCH}" in
    riscv64 )
        apt-get update && apt-get install -y gcc g++ curl make automake autoconf perl
    ;;
    * )
        yum install -y curl automake autoconf perl-IPC-Cmd
    ;;
esac

mkdir build && cd build

curl https://codeload.github.com/python/cpython/tar.gz/refs/tags/v${CPYTHON_VERSION} -o cpython.tar.gz
tar --strip-components=1 -zxf cpython.tar.gz

./configure --enable-optimizations

make -j$(nproc) libpython${BUILD_VERSION}.a libpython${BUILD_VERSION}.so
make DESTDIR=${ARCH}-linux-gnu -j$(nproc) install

tar -czf "/work/libpython-${ARCH}-linux-gnu.tar.gz" -C ${ARCH}-linux-gnu .
