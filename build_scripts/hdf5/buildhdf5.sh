#!/bin/sh
set -e

export HDF5_VERSION=$1

if [ ! -f ${MODULES_TOP_DIR:?undefined}/sourcesdir/hdf5/hdf5-$HDF5_VERSION.tar.gz ]; then
  echo "Missing source file!"
  exit
fi

TOPDIR=${MODULES_TOP_DIR:?undefined}/libraries/hdf5
export HDF5_DIR=$TOPDIR/hdf5-$HDF5_VERSION/${COMPILER:?undefined}-${COMPILER_VERSION:?undefined}

mkdir -p $MODULES_TOP_DIR/builddir
BUILDDIR=`mktemp -d $MODULES_TOP_DIR/builddir/hdf5-XXXXXX`
cd $BUILDDIR
tar xvf $MODULES_TOP_DIR/sourcesdir/hdf5/hdf5-$HDF5_VERSION.tar.gz
cd hdf5-$HDF5_VERSION

(CFLAGS="-g -O2 -fPIC" FFLAGS="-g -O2 -fPIC" ./configure --prefix=$HDF5_DIR \
            --enable-shared --enable-fortran --enable-cxx 2>&1 && touch build_cmd_success) | tee configure.log
rm build_cmd_success

(make -j ${NPROC:-1} 2>&1 && touch build_cmd_success) | tee make.log
rm build_cmd_success

rm -rf $HDF5_DIR
make install
mv config.log configure.log make.log $HDF5_DIR
rm -rf $BUILDDIR || true

cd $MODULES_TOP_DIR
MODULEDIR=derived_modulefiles/${COMPILER}/${COMPILER_VERSION}/modulefiles/hdf5
mkdir -p $MODULEDIR

echo "local version = \"$HDF5_VERSION\"" > $MODULEDIR/$HDF5_VERSION.lua
echo "local modules_top_dir = \"$MODULES_TOP_DIR\"" >> $MODULEDIR/$HDF5_VERSION.lua
echo "local compiler = \"$COMPILER\"" >> $MODULEDIR/$HDF5_VERSION.lua
echo "local compiler_version = \"$COMPILER_VERSION\"" >> $MODULEDIR/$HDF5_VERSION.lua
cat all_modulefiles/hdf5/template.lua >> $MODULEDIR/$HDF5_VERSION.lua
