#!/bin/bash

set -o errexit

usage() {
  echo "Usage: $0 <intermediates> <pattern>"
  echo
  echo "* Intermediates is a build dir from CONFIGURATION_TEMP_DIR, .build suffix will be added"
  echo "*  Pattern is the filesystem match pattern for lcov coverage report inclusion, e.g. '*/MyLib/*'"
  echo "* This script is meant to run from an xcode run scripts build phase"
  echo "* You must set RUN_CLI=1 for this script to run"
  exit 1
}

[ -n "$1" ] || usage
INTERMEDIATES="${CONFIGURATION_TEMP_DIR}/${1}.build/Objects-normal/i386/"
shift

[ -n "$1" ] || usage
PATTERN="$1"
shift

if [ "$RUN_CLI" = "" ]; then
  exit 0
fi

INFO_DIR="${PROJECT_DIR}/build/test-coverage/"
OUTPUT_DIR="${PROJECT_DIR}/build/test-coverage/${PRODUCT_NAME}"

mkdir -p "$OUTPUT_DIR"
mkdir -p "$INFO_DIR"


TITLE="${PROJECT_NAME} - ${PRODUCT_NAME}"
SOCIALIZE_LIB_DIR="Socialize-profiling.build"
SOCIALIZE_NOARC_LIB_DIR="Socialize-noarc-profiling.build"
INFO_TMP_FILE="${INFO_DIR}/${PRODUCT_NAME}-Coverage_tmp.info"
INFO_FILE="${INFO_DIR}/${PRODUCT_NAME}-Coverage.info"

lcov --test-name "${TITLE}" --output-file "$INFO_TMP_FILE" --capture --directory "${INTERMEDIATES}"

lcov --extract "${INFO_TMP_FILE}" ${PATTERN} --output-file "${INFO_FILE}"

#rm -f "${INFO_TMP_FILE}"

genhtml --title "${TITLE}"  --output-directory "$OUTPUT_DIR" "$INFO_FILE" --legend

exit $RETVAL
