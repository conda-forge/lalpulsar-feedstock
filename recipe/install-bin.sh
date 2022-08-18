#!/bin/bash

set -ex

_make="make -j ${CPU_COUNT}"

# install from python build directory
_pybuilddir="_build${PY_VER}"
cd ${_pybuilddir}

# test binaries
if [[ "${CONDA_BUILD_CROSS_COMPILATION:-}" != "1" || "${CROSSCOMPILING_EMULATOR}" != "" ]]; then
	${_make} -C bin check V=1 VERBOSE=1
fi

# install binaries
${_make} -C bin install

# install system configuration files
${_make} install-sysconfDATA
