#!/bin/sh
set -e # Fail on first error

GMP_VERSION=$1

if [ ! -f ${MODULES_TOP_DIR:?undefined}/sourcesdir/gcc/gmp-$GMP_VERSION.tar.bz2 ]; then
  echo "Missing GMP tar ball!"
  echo "${MODULES_TOP_DIR:?undefined}/sourcesdir/gcc/gmp-$GMP_VERSION.tar.bz2"
  exit
fi

TOPDIR=${MODULES_TOP_DIR:?undefined}/libraries/gmp
export GMP_DIR=$TOPDIR/gmp-$GMP_VERSION
rm -rf $GMP_DIR

mkdir -p $MODULES_TOP_DIR/builddir
BUILDDIR=`mktemp -d $MODULES_TOP_DIR/builddir/gmp-XXXXXX`
mkdir -p $BUILDDIR
cd $BUILDDIR

tar xjf $MODULES_TOP_DIR/sourcesdir/gcc/gmp-$GMP_VERSION.tar.bz2
cd gmp-$GMP_VERSION || exit 1
./configure --prefix=$GMP_DIR
make -j ${NPROC:-1}
make -j ${NPROC:-1} check
make install
cd $MODULES_TOP_DIR
rm -rf $BUILDDIR || true
