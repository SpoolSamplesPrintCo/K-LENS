#!/bin/bash

# K-LENS INSTALLER v0.11.4.0
KLENS_DIR="$HOME/printer_data/config/klens"
SCRIPT_DIR="$KLENS_DIR/scripts"

echo "🚀 Starting K-LENS Installation..."

# 1. Create Directories
mkdir -p "$SCRIPT_DIR"

# 2. Copy Files (Assuming user is in the repo folder)
cp ./scripts/klens_engine.sh "$SCRIPT_DIR/klens_engine.sh"
cp ./macros/klens_macros.cfg "$KLENS_DIR/klens_macros.cfg"

# 3. Set Permissions
chmod +x "$SCRIPT_DIR/klens_engine.sh"

echo "✅ Files installed to $KLENS_DIR"
echo "👉 Add [include klens/klens_macros.cfg] to your printer.cfg and RESTART."
