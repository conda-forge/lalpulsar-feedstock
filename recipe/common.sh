# common build options for LALSimulation

# macros
_make="make -j ${CPU_COUNT} V=1 VERBOSE=1"

# -- compile customisations

# replace package name in debug-prefix-map with source name
export CFLAGS=$(
   echo ${CFLAGS:-} |
   sed -E 's|\/usr\/local\/src\/conda\/'${PKG_NAME}'|/usr/local/src/conda/lalpulsar|g'
)

# link options
export GSL_LIBS="-L${PREFIX}/lib -lgsl"

# -- configure arguments

CONFIGURE_ARGS="
  --disable-doxygen
  --disable-gcc-flags
  --disable-static
  --disable-swig-octave
  --enable-cfitsio
  --enable-openmp
  --prefix=${PREFIX}
"

# disable help2man when cross-compiling
if [[ "${CONDA_BUILD_CROSS_COMPILATION:-}" = "1" && "${CROSSCOMPILING_EMULATOR}" = "" ]]; then
  CONFIGURE_ARGS="${CONFIGURE_ARGS} --disable-help2man"
fi
