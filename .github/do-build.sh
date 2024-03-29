#!/bin/sh

set -x

GITHUB_REF_NAME=$1
ARCH=$2
BUILD_VERSION=$(echo "${GITHUB_REF_NAME}" | cut -d '.' -f 1-2)

case "${ARCH}" in
    riscv64 )
        apt-get update && apt-get install -y gcc g++ curl make automake autoconf perl openssl-dev
    ;;
    * )
        yum install -y curl automake autoconf perl-IPC-Cmd openssl-devel
    ;;
esac

mkdir build && cd build
tar --strip-components=1 -zxf /work/cpython-${GITHUB_REF_NAME}.tar.gz

./configure CFLAGS="-fPIC" --enable-optimizations --enable-shared
make -j$(nproc)
make DESTDIR=${ARCH}-linux-gnu -j$(nproc) install

tar -czf "/work/libpython-${ARCH}-linux-gnu.tar.gz" -C ${ARCH}-linux-gnu .
