#!/bin/bash

# Original Script by  Pete Goodliffe
# from http://accu.org/index.php/journals/1594

# Modified by Juan Batiz-Benet to fit GHUnit
# Modified by Gabriel Handford for GHUnit

set -e

THISDIR=$(dirname "$0")
[[ $THISDIR =~ ^/ ]] || THISDIR="$PWD/$THISDIR"

usage() {
  echo "Usage: $0 <framework_dir>"
  echo
  echo "Note: This script must be run from Xcode BUILD_FRAMEWORK=1 must be set in the environment"
  exit 1
}

env >/tmp/envdump
[ -n "$1" ] || usage
FRAMEWORK_DIR="$1"; shift
FRAMEWORK_FULL_NAME=$(basename ${FRAMEWORK_DIR})
FRAMEWORK_NAME="${FRAMEWORK_FULL_NAME%.*}"

[ -n "${BUILT_PRODUCTS_DIR}" ] || usage
[ "${BUILD_FRAMEWORK}" -eq 1 ] || { echo "BUILD_FRAMEWORK != 1, skipping framework build"; exit 0; }

# Define these to suit your nefarious purposes
                       LIB_NAME=${FULL_PRODUCT_NAME}
              FRAMEWORK_VERSION=A
                     BUILD_TYPE=Release

# Clean any existing framework that might be there
# already
echo "Framework: Cleaning framework..."
[ -d "$FRAMEWORK_DIR" ] && \
  rm -rf "$FRAMEWORK_DIR"

# Build the canonical Framework bundle directory
# structure
echo "Framework: Setting up directories..."
mkdir -p $FRAMEWORK_DIR
mkdir -p $FRAMEWORK_DIR/Versions
mkdir -p $FRAMEWORK_DIR/Versions/$FRAMEWORK_VERSION
mkdir -p $FRAMEWORK_DIR/Versions/$FRAMEWORK_VERSION/Resources
mkdir -p $FRAMEWORK_DIR/Versions/$FRAMEWORK_VERSION/Headers

echo "Framework: Creating symlinks..."
ln -s $FRAMEWORK_VERSION $FRAMEWORK_DIR/Versions/Current
ln -s Versions/Current/Headers $FRAMEWORK_DIR/Headers
ln -s Versions/Current/Resources $FRAMEWORK_DIR/Resources
ln -s Versions/Current/$FRAMEWORK_NAME $FRAMEWORK_DIR/$FRAMEWORK_NAME

# Check that this is what your static libraries
# are called

ARM_FILES="${BUILD_DIR}/${CONFIGURATION}-iphoneos/${LIB_NAME}"
I386_FILES="${BUILD_DIR}/${CONFIGURATION}-iphonesimulator/${LIB_NAME}"

echo "Framework: building all architectures"
BUILD_FRAMEWORK=0 xcodebuild -scheme "${TARGET_NAME}" -configuration ${CONFIGURATION} -sdk iphonesimulator
BUILD_FRAMEWORK=0 xcodebuild -scheme "${TARGET_NAME}" -configuration ${CONFIGURATION} -sdk iphoneos

# The trick for creating a fully usable library is
# to use lipo to glue the different library
# versions together into one file. When an
# application is linked to this library, the
# linker will extract the appropriate platform
# version and use that.
# The library file is given the same name as the
# framework with no .a extension.
echo "Framework: Creating library..."

lipo \
  -create \
  "$ARM_FILES" \
  "$I386_FILES" \
  -o "$FRAMEWORK_DIR/Versions/Current/$FRAMEWORK_NAME"

# Now copy the final assets over: your library
# header files and the plist file
echo "Framework: Copying assets into current version..."
find "$BUILT_PRODUCTS_DIR" -name '*.h' | xargs -I{} cp "{}" "${FRAMEWORK_DIR}/Headers"

#cp Framework.plist $FRAMEWORK_DIR/Resources/Info.plist

echo ""
echo "The framework was built at: $FRAMEWORK_DIR"
echo ""
