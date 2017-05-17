#!/bin/sh
set -e

echo "Building all gsl with"
echo "Compiler ${COMPILER:?undefined} version ${COMPILER_VERSION:?undefined}"
echo

mkdir -p ${MODULES_TOP_DIR:?undefined}/sourcesdir/gsl

versions="1.16 2.0 2.3"

(cd ${MODULES_TOP_DIR:?undefined}/sourcesdir/gsl

for version in $versions; do
  if [ ! -f gsl-$version.tar.gz ]; then
    wget ftp://ftp.gnu.org/gnu/gsl/gsl-$version.tar.gz
  fi
done
)

for version in $versions; do
  $MODULES_TOP_DIR/build_scripts/gsl/buildgsl.sh $version;
done
