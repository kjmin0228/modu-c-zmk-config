#!/usr/bin/env bash

west build -p always \
  -s zmk/app \
  -d build/modu_left \
  -b ms88sf3/nrf52840 \
  -S studio-rpc-usb-uart \
  -- \
  -DZMK_CONFIG="$PWD/config" \
  -DSHIELD=modu_left \
  "-DZMK_EXTRA_MODULES=$PWD/modu-c-firmware/modu-module;$PWD/modu-c-firmware/zmk-pmw3610-driver" \
  -DCONFIG_ZMK_STUDIO=y

west build -p always \
  -s zmk/app \
  -d build/modu_right \
  -b ms88sf3/nrf52840 \
  -- \
  -DZMK_CONFIG="$PWD/config" \
  -DSHIELD=modu_right \
  "-DZMK_EXTRA_MODULES=$PWD/modu-c-firmware/modu-module;$PWD/modu-c-firmware/zmk-pmw3610-driver"


# ------------------------------------------------------------
# Copy final UF2 files
# ------------------------------------------------------------

RESULT_DIR="$(pwd)/results"

mkdir -p "$RESULT_DIR"

cp build/modu_left/zephyr/zmk.uf2 \
   "$RESULT_DIR/modu_left.uf2"

cp build/modu_right/zephyr/zmk.uf2 \
   "$RESULT_DIR/modu_right.uf2"

echo ""
echo "======================================"
echo "Build complete"
echo "======================================"
echo "Left : $RESULT_DIR/modu_left.uf2"
echo "Right: $RESULT_DIR/modu_right.uf2"
