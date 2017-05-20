#!/bin/bash
set -e

echo "Building all SLEPc with"
echo "Compiler ${COMPILER:?undefined} version ${COMPILER_VERSION:?undefined}"
echo "MPI implementation ${MPI_IMPLEMENTATION:?undefined} version ${MPI_VERSION:?undefined}"

mkdir -p ${MODULES_TOP_DIR:?undefined}/sourcesdir/slepc

slepc_versions="3.7.4"

(cd ${MODULES_TOP_DIR:?undefined}/sourcesdir/slepc

for version in $slepc_versions; do
  if [ ! -f slepc-$version.tar.gz ]; then
    wget http://slepc.upv.es/download/download.php?filename=slepc-$version.tar.gz -O slepc-$version.tar.gz
  fi
done
)

for version in $slepc_versions; do
  $MODULES_TOP_DIR/build_scripts/slepc/buildslepc.sh $version;
done
