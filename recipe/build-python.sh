#!/bin/bash
#
# Configure, built, test, and install the Python language bindings
# for a LALSuite subpackage.
#

set -e

_make="make -j ${CPU_COUNT}"

# build python in a sub-directory using a copy of the C build
_builddir="_build${PY_VER}"
cp -r _build ${_builddir}
cd ${_builddir}

# only link libraries we actually use
export GSL_LIBS="-L${PREFIX}/lib -lgsl"

# libSIStr is only available for Linux
if [[ "$(uname)" = "Linux" ]]; then
	ENABLE_SISTR="--enable-sistr"
else
	ENABLE_SISTR=""
fi

# configure only python bindings and pure-python extras
${SRC_DIR}/configure \
	--disable-doxygen \
	--disable-gcc-flags \
	--disable-swig-iface \
	--enable-cfitsio \
	--enable-help2man \
	--enable-python \
	--enable-swig-python \
	--prefix=$PREFIX \
	${ENABLE_SISTR} \
;

# patch out dependency_libs from libtool archive to prevent overlinking
sed -i.tmp '/^dependency_libs/d' lib/lib${PKG_NAME##*-}.la

# build
${_make} -C swig LIBS=""
${_make} -C python LIBS=""

# install
${_make} -C swig install-exec  # swig bindings
${_make} -C python install  # pure-python extras
