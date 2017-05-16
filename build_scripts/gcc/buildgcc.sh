#!/bin/sh
set -e # Fail on first error

export GCC_VERSION=$1
export GMP_VERSION=$2
export MPFR_VERSION=$3
export MPC_VERSION=$4

if [ ! -f ${MODULES_TOP_DIR:?undefined}/sourcesdir/gcc/gcc-$GCC_VERSION.tar.gz ]; then
  echo "Missing GCC source tree!"
  exit
fi

GMP_DIR=$MODULES_TOP_DIR/libraries/gmp/gmp-$GMP_VERSION
MPFR_DIR=$MODULES_TOP_DIR/libraries/mpfr/mpfr-$MPFR_VERSION
MPC_DIR=$MODULES_TOP_DIR/libraries/mpc/mpc-$MPC_VERSION

if [ ! -d $GMP_DIR ]; then
  echo "Missing GMP install!"
  echo $GMP_DIR
  exit
fi

if [ ! -d $MPFR_DIR ]; then
  echo "Missing MPFR install!"
  echo $MPFR_DIR
  exit
fi

if [ ! -d $MPC_DIR ]; then
  echo "Missing MPC install!"
  echo $MPC_DIR
  exit
fi

export GCC_MAJOR=`echo $GCC_VERSION | cut -d . -f 1`
export GCC_MINOR=`echo $GCC_VERSION | cut -d . -f 2`

export GCC_INSTALL_VERSION=$GCC_MAJOR.$GCC_MINOR

enablelangs=c,c++,fortran

TOPDIR=${MODULES_TOP_DIR:?undefined}/applications/gcc
export GCC_DIR=$TOPDIR/gcc-$GCC_VERSION
rm -rf $GCC_DIR

mkdir -p $MODULES_TOP_DIR/builddir
BUILDDIR=`mktemp -d $MODULES_TOP_DIR/builddir/gcc-XXXXXX`
mkdir -p $BUILDDIR
cd $BUILDDIR

#PB: Need for the build $GCC_INSTALL_VERSION. Specifying the directory not enough apparently...
#PB: This doesn't seem to stick for some reason. To get a successful build, I had to
#    do this within my shell. =/
export DYLD_LIBRARY_PATH=$MPC_DIR/lib:$MPFR_DIR/lib:$GMP_DIR/lib:$DYLD_LIBRARY_PATH

tar xzvf $MODULES_TOP_DIR/sourcesdir/gcc/gcc-$GCC_VERSION.tar.gz
cd gcc-$GCC_VERSION || exit 1

# This patch is for 4.8.3 (at time of writing) and is a fix for gcc builds on
# OS X Yosemite
# cp $MODULES_TOP_DIR/build_scripts/gcc/gcc-$GCC_VERSION.patch .

# Fixes build on El Capitan
# https://trac.macports.org/ticket/48471://raw.githubusercontent.com/Homebrew/formula-patches/dcfc5a2e6/gcc48/define_non_standard_clang_macros.patch
# cp $MODULES_TOP_DIR/build_scripts/gcc/define_non_standard_clang_macros.patch .
# patch -p0 < define_non_standard_clang_macros.patch

# Get OS X SDK path
sdk_path=`xcrun --show-sdk-path`

./configure \
--prefix=$GCC_DIR \
--with-build-config=bootstrap-debug \
--with-gmp=$GMP_DIR \
--with-mpfr=$MPFR_DIR \
--with-mpc=$MPC_DIR \
--disable-multilib \
--enable-languages=$enablelangs \
--enable-lto \
--with-native-system-header-dir=/usr/include \
--with-sysroot=$sdk_path \
--enable-stage1-checking \
--enable-checking=release \
--enable-plugin \
--with-system-zlib \
--enable-libstdcxx-time \
--disable-werror \
--disable-nls

make -j ${NPROC:-1}
make install
cd $MODULES_TOP_DIR
rm -rf $BUILDDIR || true

MODULEDIR=$MODULES_TOP_DIR/modulefiles/gcc
mkdir -p $MODULEDIR

# Build up gcc module
echo "local version = \"$GCC_INSTALL_VERSION\"" > $MODULEDIR/$GCC_INSTALL_VERSION.lua
echo "local gmp_version = \"$GMP_VERSION\"" >> $MODULEDIR/$GCC_INSTALL_VERSION.lua
echo "local mpfr_version = \"$MPFR_VERSION\"" >> $MODULEDIR/$GCC_INSTALL_VERSION.lua
echo "local mpc_version = \"$MPC_VERSION\"" >> $MODULEDIR/$GCC_INSTALL_VERSION.lua
echo "local modules_top_dir = \"$MODULES_TOP_DIR\"" >> $MODULEDIR/$GCC_INSTALL_VERSION.lua
cat $MODULES_TOP_DIR/all_modulefiles/gcc/template.lua >> $MODULEDIR/$GCC_INSTALL_VERSION.lua
