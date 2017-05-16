#!/bin/sh
set -e # Fail on first error

GMP_VERSION=$3
MPFR_VERSION=$2
MPC_VERSION=$1

if [ ! -f ${MODULES_TOP_DIR:?undefined}/sourcesdir/gcc/mpc-$MPC_VERSION.tar.gz ]; then
  echo "Missing MPC tar ball!"
  exit
fi

TOPDIR=${MODULES_TOP_DIR:?undefined}/libraries/mpc
export MPC_DIR=$TOPDIR/mpc-$MPC_VERSION
rm -rf $MPC_DIR

mkdir -p $MODULES_TOP_DIR/builddir
BUILDDIR=`mktemp -d $MODULES_TOP_DIR/builddir/mpc-XXXXXX`
mkdir -p $BUILDDIR
cd $BUILDDIR

export GMP_DIR=$MODULES_TOP_DIR/libraries/gmp/gmp-$GMP_VERSION
export MPFR_DIR=$MODULES_TOP_DIR/libraries/mpfr/mpfr-$MPFR_VERSION

tar xzf $MODULES_TOP_DIR/sourcesdir/gcc/mpc-$MPC_VERSION.tar.gz
cd mpc-$MPC_VERSION || exit 1
./configure --prefix=$MPC_DIR --with-gmp=$GMP_DIR --with-mpfr=$MPFR_DIR
make -j ${NPROC:-1}
make -j ${NPROC:-1} check
make install
cd $MODULES_TOP_DIR
rm -rf $BUILDDIR || true
