#!/bin/bash
set -e # Fail on first error

export OPENBLAS_VERSION=$1

if [ ! -f ${MODULES_TOP_DIR:?undefined}/sourcesdir/openblas/OpenBLAS-$OPENBLAS_VERSION.tar.gz ]; then
  echo "Missing source file!"
  exit
fi

TOPDIR=${MODULES_TOP_DIR:?undefined}/libraries/openblas
export OPENBLAS_DIR=$TOPDIR/openblas-$OPENBLAS_VERSION/${COMPILER:?undefined}-${COMPILER_VERSION:?undefined}

rm -rf $OPENBLAS_DIR

mkdir -p $MODULES_TOP_DIR/builddir
BUILDDIR=`mktemp -d $MODULES_TOP_DIR/builddir/openblas-XXXXXX`
cd $BUILDDIR
tar xzf $MODULES_TOP_DIR/sourcesdir/openblas/OpenBLAS-$OPENBLAS_VERSION.tar.gz
cd OpenBLAS-$OPENBLAS_VERSION

(make -j ${NPROC:-1} TARGET=NEHALEM 2>&1 && touch build_cmd_success) | tee make.log
rm build_cmd_success
make PREFIX=$OPENBLAS_DIR install
mv make.log $OPENBLAS_DIR
rm -rf $BUILDDIR || true

cd $MODULES_TOP_DIR
MODULEDIR=derived_modulefiles/${COMPILER}/${COMPILER_VERSION}/modulefiles/openblas
mkdir -p $MODULEDIR

echo "local version = \"$OPENBLAS_VERSION\"" > $MODULEDIR/$OPENBLAS_VERSION.lua
echo "local modules_top_dir = \"$MODULES_TOP_DIR\"" >> $MODULEDIR/$OPENBLAS_VERSION.lua
echo "local compiler = \"$COMPILER\"" >> $MODULEDIR/$OPENBLAS_VERSION.lua
echo "local compiler_version = \"$COMPILER_VERSION\"" >> $MODULEDIR/$OPENBLAS_VERSION.lua
cat all_modulefiles/openblas/template.lua >> $MODULEDIR/$OPENBLAS_VERSION.lua
