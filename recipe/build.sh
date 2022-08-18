#!/bin/bash

set -e

_make="make -j ${CPU_COUNT}"

# use out-of-tree build
mkdir -pv _build
cd _build

# only link libraries we actually use
export GSL_LIBS="-L${PREFIX}/lib -lgsl"
export CFITSIO_LIBS="-L${PREFIX}/lib -lcfitsio"

# configure
${SRC_DIR}/configure \
	--disable-doxygen \
	--disable-gcc-flags \
	--disable-python \
	--disable-swig-octave \
	--disable-swig-python \
	--enable-cfitsio \
	--enable-help2man \
	--enable-openmp \
	--enable-swig-iface \
	--prefix="${PREFIX}" \
;

# build
${_make}

# test
if [[ "${CONDA_BUILD_CROSS_COMPILATION:-}" != "1" ]]; then
	${_make} check V=1 VERBOSE=1
fi
