#!/bin/sh
set -e

echo "Building all hdf5 with"
echo "Compiler ${COMPILER:?undefined} version ${COMPILER_VERSION:?undefined}"
echo

mkdir -p ${MODULES_TOP_DIR:?undefined}/sourcesdir/hdf5

hdf5_versions="1.10.1"


(cd ${MODULES_TOP_DIR:?undefined}/sourcesdir/hdf5

for version in $hdf5_versions; do
  hdf5_version_split=`echo $hdf5_versions | sed -e "s/\./\ /2"`
  for hdf5_major_version in $hdf5_version_split; do
    if [ ! -f hdf5-$version.tar.gz ]; then
      wget http://www.hdfgroup.org/ftp/HDF5/releases/hdf5-$hdf5_major_version/hdf5-$version/src/hdf5-$version.tar.gz
    fi
    break
  done
done
)

for version in $hdf5_versions; do
  $MODULES_TOP_DIR/build_scripts/hdf5/buildhdf5.sh $version;
done
