#!/bin/bash

set -ex

# load common options
. ${RECIPE_DIR}/common.sh

# install from python build directory
_pybuilddir="_build${PY_VER}"
cd ${_pybuilddir}

# test binaries
# - only when natively compiling
# - not for Python 3.9 (no astropy compatible with numpy 2)
if [[ "${CONDA_BUILD_CROSS_COMPILATION:-}" != "1" ]] && [[ "${PY_VER}" != "3.9" ]]; then
  ${_make} -C bin check
fi

# install binaries
${_make} -C bin install

# install system configuration files
${_make} install-sysconfDATA
