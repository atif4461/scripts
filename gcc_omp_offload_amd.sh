#!/bin/bash

#
# Build GCC with support for offloading to AMD GPUs.
# Works for gcc-12.2.0, not for gcc-11.2.0 (?)
#

set -o nounset -o errexit

# Location of the installed LLVM Clang
clang=/work/software/wc/llvm-14

# Setup newlib
# https://sourceware.org/ftp/newlib/index.html
newlib_dir=/work/atif/packages/newlib-4.1.0

# directory of this script
work_dir="$( cd -P "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

install_dir=$work_dir/install
build_dir=$work_dir/build_amdgcn
amdgcn="usr/local/amdgcn-amdhsa"

rm -rf $build_dir $install_dir
mkdir -p $build_dir
mkdir -p $install_dir/$amdgcn/bin

# Instead of GNU Binutils, you will need to install LLVM 13.0.1, or later, and copy
# https://gcc.gnu.org/install/specific.html#amdgcn-x-amdhsa
# https://gcc.gnu.org/wiki/Offloading
cp -a $clang/bin/llvm-ar $install_dir/$amdgcn/bin/ar
cp -a $clang/bin/llvm-ar $install_dir/$amdgcn/bin/ranlib
cp -a $clang/bin/llvm-mc $install_dir/$amdgcn/bin/as
cp -a $clang/bin/llvm-nm $install_dir/$amdgcn/bin/nm
cp -a $clang/bin/lld $install_dir/$amdgcn/bin/ld
cp -a $clang/bin/llvm-ar $install_dir/$amdgcn/bin/amdgcn-amdhsa-ar
cp -a $clang/bin/llvm-ar $install_dir/$amdgcn/bin/amdgcn-amdhsa-ranlib

# Set up the GCC source tree and newlib symlink
wget -c http://mirrors.concertpass.com/gcc/releases/gcc-12.2.0/gcc-12.2.0.tar.gz
tar xf gcc-12.2.0.tar.gz
cd gcc-12.2.0

ln -s $newlib_dir/newlib newlib
contrib/download_prerequisites
host=$(./config.guess)

cd $build_dir

../gcc-12.2.0/configure \
	--target=amdgcn-amdhsa \
	--enable-languages="c,c++,lto,fortran" \
	--disable-sjlj-exceptions \
	--with-newlib \
	--enable-as-accelerator-for=$host \
	--with-build-time-tools=$install_dir/$amdgcn/bin \
	--disable-libquadmath
make -j16
make install DESTDIR=$install_dir/

# Build host GCC
cd ..
rm ./gcc-12.2.0/newlib
mkdir build-host-gcc
cd build-host-gcc

../gcc-12.2.0/configure \
	--build=x86_64-pc-linux-gnu \
	--host=x86_64-pc-linux-gnu \
	--target=x86_64-pc-linux-gnu \
	--enable-offload-targets=amdgcn-amdhsa=$install_dir/$amdgcn
make -j16
make install DESTDIR=$install_dir/

