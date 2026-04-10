#!/bin/bash
# Build and package MakerStats CYD firmware for web flasher
#
# Usage:
#   ./build-firmware.sh [version]
#   ./build-firmware.sh 2.1.0
#
# Builds the LVGL firmware, merges binaries, copies to web-flasher/bin/,
# and updates manifest.json with the version.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
BUILD_DIR="$PROJECT_DIR/.pio/build/esp32-2432S028-lvgl"
OUTPUT_DIR="$SCRIPT_DIR/bin"
MANIFEST="$SCRIPT_DIR/manifest.json"
ENV="esp32-2432S028-lvgl"
BOOT_APP0="$HOME/.platformio/packages/framework-arduinoespressif32/tools/partitions/boot_app0.bin"
ESPTOOL_PY="$HOME/.platformio/packages/tool-esptoolpy/esptool.py"
PIO_PYTHON="$HOME/.local/pipx/venvs/platformio/bin/python"

VERSION="${1:-}"

# Auto-detect version from git if not provided
if [ -z "$VERSION" ]; then
    VERSION=$(cd "$PROJECT_DIR" && git describe --tags --always 2>/dev/null || echo "dev")
    echo "Auto-detected version: $VERSION"
fi

OUTPUT_FILE="$OUTPUT_DIR/makerstats-cyd-firmware.bin"

echo "=== MakerStats CYD Firmware Builder ==="
echo "Version:  $VERSION"
echo "Env:      $ENV"
echo ""

# Step 1: Build firmware
echo "[1/4] Building firmware..."
cd "$PROJECT_DIR"
pio run -e "$ENV" --silent

# Step 2: Verify build artifacts
echo "[2/4] Verifying build artifacts..."
for f in bootloader.bin partitions.bin firmware.bin; do
    if [ ! -f "$BUILD_DIR/$f" ]; then
        echo "ERROR: Missing $BUILD_DIR/$f"
        exit 1
    fi
done

if [ ! -f "$BOOT_APP0" ]; then
    echo "ERROR: Missing boot_app0.bin at $BOOT_APP0"
    exit 1
fi

# Step 3: Merge binaries
echo "[3/4] Merging firmware binaries..."
mkdir -p "$OUTPUT_DIR"

"$PIO_PYTHON" "$ESPTOOL_PY" --chip esp32 merge_bin \
    -o "$OUTPUT_FILE" \
    --flash_mode dio \
    --flash_freq 40m \
    --flash_size 4MB \
    0x1000  "$BUILD_DIR/bootloader.bin" \
    0x8000  "$BUILD_DIR/partitions.bin" \
    0xe000  "$BOOT_APP0" \
    0x10000 "$BUILD_DIR/firmware.bin"

# Step 4: Update manifest.json
echo "[4/4] Updating manifest.json..."
# Use python for reliable JSON update
"$PIO_PYTHON" -c "
import json, sys
with open('$MANIFEST', 'r') as f:
    m = json.load(f)
m['version'] = '$VERSION'
with open('$MANIFEST', 'w') as f:
    json.dump(m, f, indent=2)
    f.write('\n')
"

# Summary
SIZE=$(ls -lh "$OUTPUT_FILE" | awk '{print $5}')
echo ""
echo "=== Done ==="
echo "Firmware: $OUTPUT_FILE ($SIZE)"
echo "Manifest: $MANIFEST (version: $VERSION)"
echo ""
echo "To test locally:"
echo "  cd $SCRIPT_DIR && python3 -m http.server 8080"
echo "  Open http://localhost:8080 in Chrome"
echo ""
echo "To deploy:"
echo "  git add web-flasher/"
echo "  git commit -m 'CYD: web flasher firmware v$VERSION'"
echo "  git push"
