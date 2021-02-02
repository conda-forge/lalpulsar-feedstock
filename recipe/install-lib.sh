#!/bin/bash

set -ex

cd _build

# install library and headers
make -j ${CPU_COUNT} V=1 VERBOSE=1 -C lib install

# install SWIG binding definitions and headers
make -j ${CPU_COUNT} V=1 VERBOSE=1 -C swig install-data

# install pkg-config
make -j ${CPU_COUNT} V=1 VERBOSE=1 install-pkgconfigDATA

# -- create activate/deactivate scripts

# activate.sh
ACTIVATE_SH="${PREFIX}/etc/conda/activate.d/activate_lalpulsar.sh"
mkdir -p $(dirname ${ACTIVATE_SH})
cat > ${ACTIVATE_SH} << EOF
#!/bin/bash
export CONDA_BACKUP_LALPULSAR_DATADIR="\${LALPULSAR_DATADIR:-empty}"
export LALPULSAR_DATADIR="/opt/anaconda1anaconda2anaconda3/share/lalpulsar"
EOF
# deactivate.sh
DEACTIVATE_SH="${PREFIX}/etc/conda/deactivate.d/deactivate_lalpulsar.sh"
mkdir -p $(dirname ${DEACTIVATE_SH})
cat > ${DEACTIVATE_SH} << EOF
#!/bin/bash
if [ "\${CONDA_BACKUP_LALPULSAR_DATADIR}" = "empty" ]; then
	unset LALPULSAR_DATADIR
else
	export LALPULSAR_DATADIR="\${CONDA_BACKUP_LALPULSAR_DATADIR}"
fi
unset CONDA_BACKUP_LALPULSAR_DATADIR
EOF
