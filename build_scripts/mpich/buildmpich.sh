#!/bin/sh
set -e

export MPICH_VERSION=$1

if [ ! -f ${MODULES_TOP_DIR:?undefined}/sourcesdir/mpich/mpich-$MPICH_VERSION.tar.gz ]; then
  echo "Missing source file!"
  exit
fi

TOPDIR=${MODULES_TOP_DIR:?undefined}/libraries/mpich
export MPICH_DIR=$TOPDIR/mpich-$MPICH_VERSION/${COMPILER:?undefined}-${COMPILER_VERSION:?undefined}

rm -rf $MPICH_DIR

mkdir -p $MODULES_TOP_DIR/builddir
BUILDDIR=`mktemp -d $MODULES_TOP_DIR/builddir/mpich-XXXXXX`
cd $BUILDDIR
tar xzf $MODULES_TOP_DIR/sourcesdir/mpich/mpich-$MPICH_VERSION.tar.gz
cd mpich-$MPICH_VERSION

# MPICH build system errors out if F90 is set (WEAK)
export F90bak=$F90
unset F90

# Workaround MPICH 1.4.1 configure bug
# sed -i -e "s/shared library support/shared library support using Roy's workaround\npac_c_check_compiler_option_prototest=no/" configure.in
# autoconf -I confdb

(./configure --prefix=$MPICH_DIR --enable-shared --enable-sharedlibs=gcc 2>&1 && touch build_cmd_success) | tee configure.log
rm build_cmd_success
export F90=$F90bak
unset F90bak
# Yes, MPICH really *can't* handle parallel builds (VERY WEAK)
(make 2>&1 && touch build_cmd_success) | tee make.log
rm build_cmd_success
make install
mv config.log configure.log $MPICH_DIR
mv make.log $MPICH_DIR
cd $MODULES_TOP_DIR 
rm -rf $BUILDDIR || true

cd $MODULES_TOP_DIR
MODULEDIR=$MODULES_TOP_DIR/derived_modulefiles/${COMPILER}/${COMPILER_VERSION}/modulefiles/mpich
mkdir -p $MODULEDIR

echo "local version = \"$MPICH_VERSION\"" > $MODULEDIR/$MPICH_VERSION.lua
echo "local system_type = \"$SYSTEMTYPE\"" >> $MODULEDIR/$MPICH_VERSION.lua
echo "local modules_top_dir = \"$MODULES_TOP_DIR\"" >> $MODULEDIR/$MPICH_VERSION.lua
echo "local compiler = \"$COMPILER\"" >> $MODULEDIR/$MPICH_VERSION.lua
echo "local compiler_version = \"$COMPILER_VERSION\"" >> $MODULEDIR/$MPICH_VERSION.lua
cat all_modulefiles/mpich/template.lua >> $MODULEDIR/$MPICH_VERSION.lua
