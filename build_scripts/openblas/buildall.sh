#!/bin/sh
set -e

echo "Building all openblas with"
echo "Compiler ${COMPILER:?undefined} version ${COMPILER_VERSION:?undefined}"
echo

mkdir -p ${MODULES_TOP_DIR:?undefined}/sourcesdir/openblas

openblas_versions="0.2.8 0.2.19"

(cd ${MODULES_TOP_DIR:?undefined}/sourcesdir/openblas

for version in $openblas_versions; do
  if [ ! -f OpenBLAS-$version.tar.gz ]; then
    wget https://github.com/xianyi/OpenBLAS/archive/v$version.tar.gz
    mv v$version.tar.gz OpenBLAS-$version.tar.gz
  fi
done
)

for version in $openblas_versions; do
  $MODULES_TOP_DIR/build_scripts/openblas/buildopenblas.sh $version;
done
