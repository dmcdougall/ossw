#!/bin/sh
set -e # Fail on first error

export GSL_VERSION=$1

if [ ! -f ${MODULES_TOP_DIR:?undefined}/sourcesdir/gsl/gsl-$GSL_VERSION.tar.gz ]; then
  echo "Missing source file!"
  exit
fi

TOPDIR=${MODULES_TOP_DIR:?undefined}/libraries/gsl
export GSL_DIR=$TOPDIR/gsl-$GSL_VERSION/${COMPILER:?undefined}-${COMPILER_VERSION:?undefined}

mkdir -p $MODULES_TOP_DIR/builddir
BUILDDIR=`mktemp -d $MODULES_TOP_DIR/builddir/gsl-XXXXXX`
cd $BUILDDIR
tar xzf $MODULES_TOP_DIR/sourcesdir/gsl/gsl-$GSL_VERSION.tar.gz
cd gsl-$GSL_VERSION

(CFLAGS="-g -O3" ./configure --prefix=$GSL_DIR 2>&1 && touch build_cmd_success) | tee configure.log
rm build_cmd_success
(make -j ${NPROC:-1} 2>&1 && touch build_cmd_success) | tee make.log
rm build_cmd_success
(make check 2>&1 && touch check_cmd_success) | tee check.log
rm check_cmd_success
rm -rf $GSL_DIR
make install
mv config.log configure.log make.log check.log $GSL_DIR
rm -rf $BUILDDIR || true

cd $MODULES_TOP_DIR
MODULEDIR=derived_modulefiles/${COMPILER}/${COMPILER_VERSION}/modulefiles/gsl
mkdir -p $MODULEDIR

echo "local version = \"$GSL_VERSION\"" > $MODULEDIR/$GSL_VERSION.lua
echo "local system_type = \"$SYSTEMTYPE\"" >> $MODULEDIR/$GSL_VERSION.lua
echo "local modules_top_dir = \"$MODULES_TOP_DIR\"" >> $MODULEDIR/$GSL_VERSION.lua
echo "local compiler = \"$COMPILER\"" >> $MODULEDIR/$GSL_VERSION.lua
echo "local compiler_version = \"$COMPILER_VERSION\"" >> $MODULEDIR/$GSL_VERSION.lua
cat all_modulefiles/gsl/template.lua >> $MODULEDIR/$GSL_VERSION.lua
