#!/bin/sh
# vim:set tabstop=8 shiftwidth=4 expandtab:
# kate: space-indent on; indent-width 4;
#
# Copyright (c) 2018 Jakob Meng, <jakobmeng@web.de>
#
# {fmt}
# References:
#  https://github.com/fmtlib/fmt

set -e

if [ "$(id -u)" -ne 0 ]; then 
    echo "Please do run as root"
    exit 255
fi

PREFIX=/usr
export DEBIAN_FRONTEND=noninteractive

apt-get install -y \
    git dpkg-dev gcc make cmake ccache

apt-get clean
update-ccache-symlinks

export PATH="/usr/lib/ccache:$PATH"
export CC=gcc
export CXX=g++

cd /usr/local/src/
git clone --depth 1 https://github.com/fmtlib/fmt.git
cd fmt/

USERNAME=nobody

mkdir build
chown "$USERNAME" build
cd build/

sudo -u "$USERNAME" cmake \
    -DCMAKE_BUILD_TYPE=Debug \
    -DCMAKE_INSTALL_PREFIX="$PREFIX" \
    ..

sudo -u "$USERNAME" make -j$(nproc)

make install
