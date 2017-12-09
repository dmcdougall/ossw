#!/bin/bash
set -e

echo "Building all PETSc with"
echo "Compiler ${COMPILER:?undefined} version ${COMPILER_VERSION:?undefined}"
echo "MPI implementation ${MPI_IMPLEMENTATION:?undefined} version ${MPI_VERSION:?undefined}"

mkdir -p ${MODULES_TOP_DIR:?undefined}/sourcesdir/petsc

petsc_versions="3.8.2"

(cd ${MODULES_TOP_DIR:?undefined}/sourcesdir/petsc

for version in $petsc_versions; do
  if [ ! -f petsc-lite-$version.tar.gz ]; then
    wget http://ftp.mcs.anl.gov/pub/petsc/release-snapshots/petsc-lite-$version.tar.gz
  fi
done
)

for version in $petsc_versions; do
  $MODULES_TOP_DIR/build_scripts/petsc/buildpetsc.sh $version;
done
