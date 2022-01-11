#!/usr/bin/env bash

# Copyright (c) 2022 Battelle Energy Alliance, LLC.  All rights reserved.

set -uo pipefail
shopt -s nocasematch
ENCODING="utf-8"

ZEEK_DIR=${ZEEK_DIR:-"/opt/zeek"}
INTEL_DIR="${ZEEK_DIR}/share/zeek/site/intel"

# create directive to @load every subdirectory in /opt/zeek/share/zeek/site/intel
if [[ -d "${INTEL_DIR}" ]] && (( $(find "${INTEL_DIR}" -mindepth 1 -maxdepth 1 -type d 2>/dev/null | wc -l) > 0 )); then
    pushd "${INTEL_DIR}" >/dev/null 2>&1

    cat > __load__.zeek << EOF
# WARNING: This file is automatically generated.
# Do not make direct modifications here.
@load policy/integration/collective-intel
@load policy/frameworks/intel/seen
@load policy/frameworks/intel/do_notice

EOF
    for DIR in $(find . -mindepth 1 -maxdepth 1 -type d 2>/dev/null); do
        echo "@load $DIR" >> __load__.zeek
    done
    popd >/dev/null 2>&1
fi

# start supervisor to spawn the other process(es) or whatever the default command is
exec "$@"