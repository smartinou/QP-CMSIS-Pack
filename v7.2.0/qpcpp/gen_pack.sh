#!/bin/bash
# Version: 2.4
# Date: 2022-11-21
# This bash script generates a CMSIS Software Pack:
#

set -o pipefail

# Set version of gen pack library
REQUIRED_GEN_PACK_LIB="0.6.0"

# Set default command line arguments
DEFAULT_ARGS=(--preprocess)

# Pack warehouse directory - destination
PACK_OUTPUT=./output

# Temporary pack build directory
PACK_BUILD=./build

# Specify directory names to be added to pack base directory
PACK_DIRS="
    qp/qpcpp/3rd_party/embOS-gnu/
    qp/qpcpp/3rd_party/embOS-iar/
    qp/qpcpp/3rd_party/threadx/
    qp/qpcpp/3rd_party/uC-OS2/
    qp/qpcpp/include/
    qp/qpcpp/LICENSES/
    qp/qpcpp/ports/arm-cm/qk/
    qp/qpcpp/ports/arm-cm/qv/
    qp/qpcpp/ports/arm-cm/qxk/
    qp/qpcpp/ports/embos/
    qp/qpcpp/ports/freertos/
    qp/qpcpp/ports/lint-plus/
    qp/qpcpp/ports/threadx/
    qp/qpcpp/ports/uc-os2/
    qp/qpcpp/src/
    qp/qpcpp/test/
"

# Specify file names to be added to pack base directory
PACK_BASE_FILES="
    qp/qpcpp/qpcpp.qm
    qp/qpcpp/README.md
"

# Specify file names to be deleted from pack build directory
PACK_DELETE_FILES="
"

# Specify patches to be applied
PACK_PATCH_FILES="
"

# Specify addition argument to packchk
# SEGGER.CMSIS-embOS pack can be obtained from this link:
# https://www.segger.com/downloads/embos/SEGGER.CMSIS-embOS
# It is not listed in https://www.keil.com.com/pack/index.pidx and cannot be
# automatically downloaded to ${CMSIS_PACK_ROOT}/.Web if listed as PACKCHK_DEPS.
# Instal it with cpackget and refer to is as extra arg.
# If not installed, there will be warnings, but they can be overlooked.
PACKCHK_ARGS=(-i ${CMSIS_PACK_ROOT}/.Local/SEGGER.CMSIS-embOS.pdsc)

# Specify additional dependencies for packchk
PACKCHK_DEPS="
    ARM.CMSIS-FreeRTOS.pdsc
"

# Optional: restrict fallback modes for changelog generation
# Default: full
# Values:
# - full      Tag annotations, release descriptions, or commit messages (in order)
# - release   Tag annotations, or release descriptions (in order)
# - tag       Tag annotations only
PACK_CHANGELOG_MODE=""

QP_VERSION="v7.2.0"

# custom pre-processing steps
function preprocess() {
  # add custom steps here to be executed
  # before populating the pack build folder

  # Create a clean folder.
  QP_DIR=qp
  if [ -d "$QP_DIR" ]; then
    rm -rf $QP_DIR
  fi
  mkdir $QP_DIR
  cd $QP_DIR

  # Acquire sources from repos.
  git clone https://github.com/QuantumLeaps/qpcpp.git --recurse-submodules --depth 1 --branch ${QP_VERSION}

  # Silent warnings for GCC .s files.
  mv qpcpp/3rd_party/uC-OS2/Ports/ARM-Cortex-M/ARMv6-M/GNU/os_cpu_a.s qpcpp/3rd_party/uC-OS2/Ports/ARM-Cortex-M/ARMv6-M/GNU/os_cpu_a.S
  mv qpcpp/3rd_party/uC-OS2/Ports/ARM-Cortex-M/ARMv7-M/GNU/os_cpu_a.s qpcpp/3rd_party/uC-OS2/Ports/ARM-Cortex-M/ARMv7-M/GNU/os_cpu_a.S
  cd .. # Back to script calling point.

  return 0
}

# custom post-processing steps
function postprocess() {
  # add custom steps here to be executed
  # after populating the pack build folder
  # but before archiving the pack into output folder
  return 0
}

############ DO NOT EDIT BELOW ###########

function install_lib() {
  local URL="https://github.com/Open-CMSIS-Pack/gen-pack/archive/refs/tags/v$1.tar.gz"
  echo "Downloading gen-pack lib to '$2'"
  mkdir -p "$2"
  curl -L "${URL}" -s | tar -xzf - --strip-components 1 -C "$2" || exit 1
}

function load_lib() {
  if [[ -d ${GEN_PACK_LIB} ]]; then
    . "${GEN_PACK_LIB}/gen-pack"
    return 0
  fi
  local GLOBAL_LIB="/usr/local/share/gen-pack/${REQUIRED_GEN_PACK_LIB}"
  local USER_LIB="${HOME}/.local/share/gen-pack/${REQUIRED_GEN_PACK_LIB}"
  if [[ ! -d "${GLOBAL_LIB}" && ! -d "${USER_LIB}" ]]; then
    echo "Required gen_pack lib not found!" >&2
    install_lib "${REQUIRED_GEN_PACK_LIB}" "${USER_LIB}"
  fi

  if [[ -d "${GLOBAL_LIB}" ]]; then
    . "${GLOBAL_LIB}/gen-pack"
  elif [[ -d "${USER_LIB}" ]]; then
    . "${USER_LIB}/gen-pack"
  else
    echo "Required gen-pack lib is not installed!" >&2
    exit 1
  fi
}

load_lib
gen_pack "${DEFAULT_ARGS[@]}" "$@"

exit 0
