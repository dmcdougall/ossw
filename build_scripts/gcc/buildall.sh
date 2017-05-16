#!/bin/sh
set -e

echo "Building all GCC"

mkdir -p ${MODULES_TOP_DIR:?undefined}/sourcesdir/gcc

export gmp_version=6.1.0
export mpfr_version=3.1.5
export mpc_version=1.0.3

gcc_versions="6.3.0 7.1.0"

(cd $MODULES_TOP_DIR/sourcesdir/gcc
if [ ! -f gmp-$gmp_version.tar.bz2 ]; then
  wget http://ftpmirror.gnu.org/gmp/gmp-$gmp_version.tar.bz2
  mv gmp-$gmp_version.tar.bz2 gmp-$gmp_version.tar.bz2
fi

if [ ! -f mpfr-$mpfr_version.tar.bz2 ]; then
  wget http://www.mpfr.org/mpfr-current/mpfr-$mpfr_version.tar.bz2
fi

if [ ! -f mpc-$mpc_version.tar.gz ]; then
  wget http://www.multiprecision.org/mpc/download/mpc-$mpc_version.tar.gz
fi

for version in $gcc_versions; do
  if [ ! -f gcc-$version.tar.gz ]; then
    wget http://mirrors.concertpass.com/gcc/releases/gcc-$version/gcc-$version.tar.gz
  fi
done
)

# Build GCC dependencies
$MODULES_TOP_DIR/build_scripts/gcc/buildgmp.sh $gmp_version
$MODULES_TOP_DIR/build_scripts/gcc/buildmpfr.sh $mpfr_version $gmp_version
$MODULES_TOP_DIR/build_scripts/gcc/buildmpc.sh $mpc_version $mpfr_version $gmp_version

for version in $gcc_versions; do
  $MODULES_TOP_DIR/build_scripts/gcc/buildgcc.sh $version $gmp_version $mpfr_version $mpc_version;
done
