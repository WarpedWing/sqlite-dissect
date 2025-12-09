#!/bin/bash
# Build script for creating standalone executables of sqlite_dissect
# This script builds standalone binaries using PyInstaller

set -e  # Exit on error

echo "Building standalone executables for sqlite_dissect..."
echo ""

# Determine the platform
if [[ "$OSTYPE" == "darwin"* ]]; then
    PLATFORM="macos"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    PLATFORM="linux-x64"
elif [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "cygwin" ]]; then
    PLATFORM="win-x86_64"
else
    echo "Unknown platform: $OSTYPE"
    exit 1
fi

# Default to onefile build
BUILD_TYPE="${1:-onefile}"

if [[ "$BUILD_TYPE" != "onefile" ]] && [[ "$BUILD_TYPE" != "onedir" ]]; then
    echo "Invalid build type: $BUILD_TYPE"
    echo "Usage: $0 [onefile|onedir]"
    exit 1
fi

SPEC_FILE="pyinstaller/sqlite_dissect_${PLATFORM}_${BUILD_TYPE}.spec"

if [[ ! -f "$SPEC_FILE" ]]; then
    echo "Error: Spec file not found: $SPEC_FILE"
    echo "Available spec files:"
    ls -1 pyinstaller/*.spec
    exit 1
fi

echo "Platform: $PLATFORM"
echo "Build type: $BUILD_TYPE"
echo "Spec file: $SPEC_FILE"
echo ""

# Clean previous builds
echo "Cleaning previous builds..."
rm -rf build/sqlite_dissect_${PLATFORM}_${BUILD_TYPE}

# Build the executable
echo "Building executable..."
uv run pyinstaller "$SPEC_FILE"

echo ""
echo "Build complete!"
echo ""

# Show the results
if [[ "$BUILD_TYPE" == "onefile" ]]; then
    EXECUTABLE="dist/${PLATFORM}/bin/sqlite_dissect"
else
    EXECUTABLE="dist/${PLATFORM}/sqlite_dissect/sqlite_dissect"
fi

if [[ -f "$EXECUTABLE" ]] || [[ -f "${EXECUTABLE}.exe" ]]; then
    echo "Executable created at: $EXECUTABLE"
    ls -lh "$EXECUTABLE" 2>/dev/null || ls -lh "${EXECUTABLE}.exe"
    echo ""
    echo "Test the executable with:"
    echo "  $EXECUTABLE --version"
else
    echo "Warning: Executable not found at expected location"
fi
