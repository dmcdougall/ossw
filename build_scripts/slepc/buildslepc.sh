#!/bin/sh
set -e

export SLEPC_VERSION="$1"

if [ ! -f ${MODULES_TOP_DIR:?undefined}/sourcesdir/slepc/slepc-$SLEPC_VERSION.tar.gz ]; then
  echo "Missing source file for version $SLEPC_VERSION!"
  exit
fi

TOPDIR=${MODULES_TOP_DIR:?undefined}/libraries/slepc
export SLEPC_DIR=${MODULES_TOP_DIR:?undefined}/libraries/slepc/slepc-$SLEPC_VERSION

mkdir -p $TOPDIR
cd $TOPDIR
tar xvzf $MODULES_TOP_DIR/sourcesdir/slepc/slepc-$SLEPC_VERSION.tar.gz
cd slepc-$SLEPC_VERSION

./configure && \
(make 2>&1 && touch build_cmd_success) | tee make.log
rm build_cmd_success

cd $MODULES_TOP_DIR
MODULEDIR=derived_modulefiles/$COMPILER/$COMPILER_VERSION/$MPI_IMPLEMENTATION/$MPI_VERSION/modulefiles/slepc
mkdir -p $MODULEDIR

echo "local version = \"$SLEPC_VERSION\"" > $MODULEDIR/$SLEPC_VERSION.lua
echo "local modules_top_dir = \"$MODULES_TOP_DIR\"" >> $MODULEDIR/$SLEPC_VERSION.lua
echo "local compiler = \"$COMPILER\"" >> $MODULEDIR/$SLEPC_VERSION.lua
echo "local compiler_version = \"$COMPILER_VERSION\"" >> $MODULEDIR/$SLEPC_VERSION.lua
echo "local mpi_implementation = \"$MPI_IMPLEMENTATION\"" >> $MODULEDIR/$SLEPC_VERSION.lua
echo "local mpi_version = \"$MPI_VERSION\"" >> $MODULEDIR/$SLEPC_VERSION.lua
echo "local petsc_arch = \"$PETSC_ARCH\"" >> $MODULEDIR/$SLEPC_VERSION.lua
echo "local petsc_version = \"$PETSC_VERSION\"" >> $MODULEDIR/$SLEPC_VERSION.lua
cat all_modulefiles/slepc/template.lua >> $MODULEDIR/$SLEPC_VERSION.lua
