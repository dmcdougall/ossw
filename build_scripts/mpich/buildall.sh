#!/bin/sh
set -e

echo "Building all mpich with"
echo "Compiler ${COMPILER:?undefined} version ${COMPILER_VERSION:?undefined}"
echo

mkdir -p ${MODULES_TOP_DIR:?undefined}/sourcesdir/mpich

mpich_versions="3.0.4 3.2"

(cd ${MODULES_TOP_DIR:?undefined}/sourcesdir/mpich

for version in $mpich_versions; do
  if [ ! -f mpich-$version.tar.gz ]; then
    curl -O http://www.mpich.org/static/downloads/$version/mpich-$version.tar.gz
  fi
done
)

for version in $mpich_versions; do
  $MODULES_TOP_DIR/build_scripts/mpich/buildmpich.sh $version;
done
