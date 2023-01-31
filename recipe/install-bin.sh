#!/bin/bash

set -ex

# load common options
. ${RECIPE_DIR}/common.sh

# install from python build directory
_pybuilddir="_build${PY_VER}"
cd ${_pybuilddir}

# test binaries
if [[ "${CONDA_BUILD_CROSS_COMPILATION:-}" != "1" ]]; then
  ${_make} -C bin check
fi

# install binaries
${_make} -C bin install

# install system configuration files
${_make} install-sysconfDATA
