#!/bin/sh
set -e

export PETSC_VERSION=$1

if [ ! -f ${MODULES_TOP_DIR:?undefined}/sourcesdir/petsc/petsc-lite-$PETSC_VERSION.tar.gz ]; then
  echo "Missing source file!"
  exit
fi

TOPDIR=${MODULES_TOP_DIR:?undefined}/libraries/petsc
export PETSC_DIR=$TOPDIR/petsc-$PETSC_VERSION

mkdir -p $TOPDIR
cd $TOPDIR
tar xzf $MODULES_TOP_DIR/sourcesdir/petsc/petsc-lite-$PETSC_VERSION.tar.gz
cd petsc-$PETSC_VERSION

export PETSC_TYPE=cxx-opt
export PETSC_ARCH=${COMPILER:?undefined}-${COMPILER_VERSION:?undefined}-${MPI_IMPLEMENTATION:?undefined}-${MPI_VERSION:?undefined}-$PETSC_TYPE

./configure --with-debugging=false --COPTFLAGS='-O3' --CXXOPTFLAGS='-O3' --FOPTFLAGS='-O3' \
--with-clanguage=C++ \
--with-shared-libraries \
--with-mpi-dir=${MPI_DIR:?undefined} \
--with-mumps=true --download-mumps=1 \
--with-metis=true --download-metis=1 \
--with-parmetis=true --download-parmetis=1 \
--with-blacs=true --download-blacs=1 \
--with-scalapack=true --download-scalapack=1 \
--with-superlu=true --download-superlu=1 \
--with-x11=0 \
--with-x=0 \
--with-blas-lapack-lib=${OPENBLAS_LIB:?undefined}/libopenblas.dylib
(make all 2>&1 && touch build_cmd_success) | tee make.log
rm build_cmd_success

cd $MODULES_TOP_DIR
MODULEDIR=derived_modulefiles/$COMPILER/$COMPILER_VERSION/$MPI_IMPLEMENTATION/$MPI_VERSION/modulefiles/petsc
mkdir -p $MODULEDIR

export PETSC_MODULE_VERSION=$PETSC_VERSION-$PETSC_TYPE
echo "local version = \"$PETSC_VERSION\"" > $MODULEDIR/$PETSC_MODULE_VERSION.lua
echo "local petsc_type = \"$PETSC_TYPE\"" >> $MODULEDIR/$PETSC_MODULE_VERSION.lua
echo "local modules_top_dir = \"$MODULES_TOP_DIR\"" >> $MODULEDIR/$PETSC_MODULE_VERSION.lua
echo "local compiler = \"$COMPILER\"" >> $MODULEDIR/$PETSC_MODULE_VERSION.lua
echo "local compiler_version = \"$COMPILER_VERSION\"" >> $MODULEDIR/$PETSC_MODULE_VERSION.lua
echo "local mpi_implementation = \"$MPI_IMPLEMENTATION\"" >> $MODULEDIR/$PETSC_MODULE_VERSION.lua
echo "local mpi_version = \"$MPI_VERSION\"" >> $MODULEDIR/$PETSC_MODULE_VERSION.lua
cat all_modulefiles/petsc/template.lua >> $MODULEDIR/$PETSC_MODULE_VERSION.lua
