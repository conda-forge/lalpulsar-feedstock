#!/bin/bash
#
# Configure, build, test, and install the LALPulsar C libraries.
#
# This is run once for the staging output, the results of which are
# then split into the lalpulsar-data and liblalpulsar packages; the
# python-lalpulsar and lalpulsar packages reuse the _build directory to
# avoid rebuilding the C libraries.
#

set -ex

# load common options
. ${RECIPE_DIR}/common.sh

# use out-of-tree build
mkdir -pv _build
cd _build

# configure needs a Python interpreter (even with --disable-python),
# so use the one from the build environment
export PYTHON=${BUILD_PREFIX}/bin/python

# configure
${SRC_DIR}/configure \
  ${CONFIGURE_ARGS} \
  --disable-python \
  --disable-swig-python \
  --enable-swig-iface \
;

# build
${_make}

# test (the test requirements are only installed when building natively)
if [[ "${CONDA_BUILD_CROSS_COMPILATION:-}" != "1" ]]; then
  ${_make} check
fi

# install library, headers, and data files
${_make} -C lib install

# install SWIG binding definitions and headers
${_make} -C swig install-data

# install pkg-config
${_make} install-pkgconfigDATA

# install activate/deactivate scripts for lalpulsar-data
for action in activate deactivate; do
  mkdir -p ${PREFIX}/etc/conda/${action}.d
  for ext in sh csh; do
    cp -v \
      "${RECIPE_DIR}/${action}-lalpulsar-data.${ext}" \
      "${PREFIX}/etc/conda/${action}.d/${action}-lalpulsar-data.${ext}"
  done
done
