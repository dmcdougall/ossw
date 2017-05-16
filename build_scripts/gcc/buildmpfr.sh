#!/bin/sh
set -e # Fail on first error

GMP_VERSION=$2
MPFR_VERSION=$1

if [ ! -f ${MODULES_TOP_DIR:?undefined}/sourcesdir/gcc/mpfr-$MPFR_VERSION.tar.bz2 ]; then
  echo "Missing MPFR tar ball!"
  exit
fi

TOPDIR=${MODULES_TOP_DIR:?undefined}/libraries/mpfr
export MPFR_DIR=$TOPDIR/mpfr-$MPFR_VERSION
rm -rf $MPFR_DIR

mkdir -p $MODULES_TOP_DIR/builddir
BUILDDIR=`mktemp -d $MODULES_TOP_DIR/builddir/mpfr-XXXXXX`
mkdir -p $BUILDDIR
cd $BUILDDIR

export GMP_DIR=$MODULES_TOP_DIR/libraries/gmp/gmp-$GMP_VERSION

tar xjf $MODULES_TOP_DIR/sourcesdir/gcc/mpfr-$MPFR_VERSION.tar.bz2
cd mpfr-$MPFR_VERSION || exit 1
./configure --prefix=$MPFR_DIR --with-gmp=$GMP_DIR
make -j ${NPROC:-1}
make -j ${NPROC:-1} check
make install
cd $MODULES_TOP_DIR
rm -rf $BUILDDIR || true
