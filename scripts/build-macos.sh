#!/usr/bin/env bash
set -e

# MidiFlux macOS One-Click Build Script
# Builds Universal Binary (Apple Silicon arm64 + Intel x86_64)
# Formats generated: VST3, CLAP, AU (AudioUnit), and Standalone App

echo "=========================================================="
echo "  Building MidiFlux for macOS (Universal Binary)          "
echo "=========================================================="

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
PROJECT_ROOT="$SCRIPT_DIR/.."
cd "$PROJECT_ROOT"

BUILD_DIR="build-mac"

# 1. Configure CMake for Universal Binary
echo ">> Configuring CMake for macOS (arm64 + x86_64)..."
cmake -B "$BUILD_DIR" \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_OSX_ARCHITECTURES="arm64;x86_64"

# 2. Compile in Parallel
echo ">> Compiling plugins & standalone app..."
cmake --build "$BUILD_DIR" --config Release --target MidiFlux_All MidiFlux_CLAP MidiFluxTests --parallel

# 3. Run Automated Tests
echo ">> Running unit verification tests..."
"$BUILD_DIR/MidiFluxTests"

# 4. Display Outputs
echo "=========================================================="
echo "  macOS Build Complete! Output files:                    "
echo "=========================================================="
echo "VST3:       $BUILD_DIR/MidiFlux_artefacts/Release/VST3/MidiFlux.vst3"
echo "CLAP:       $BUILD_DIR/MidiFlux_artefacts/Release/CLAP/MidiFlux.clap"
echo "AudioUnit:  $BUILD_DIR/MidiFlux_artefacts/Release/AU/MidiFlux.component"
echo "Standalone: $BUILD_DIR/MidiFlux_artefacts/Release/Standalone/MidiFlux.app"
echo "=========================================================="
