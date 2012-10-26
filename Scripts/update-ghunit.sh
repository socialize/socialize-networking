#!/bin/bash

THISDIR=$(dirname $0)
PROJECT_DIR="${THISDIR}/.."
GHUNIT="${PROJECT_DIR}/ThirdParty/GHUnit"
FRAMEWORK_DEST="${PROJECT_DIR}/ThirdParty/GHUnitIOS.framework"

cd "${GHUNIT}/Project-iOS"
make
rm -rf "${FRAMEWORK_DEST}"
cp -R "build/Framework/GHUnit.framework" "${FRAMEWORK_DEST}"
