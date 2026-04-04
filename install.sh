#!/bin/bash

# KLENS INSTALLER v0.11.4.0
# Detect the current repository location
REPO_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
TARGET_DIR="$HOME/printer_data/config/klens"
SCRIPT_DIR="$TARGET_DIR/scripts"

echo "🚀 Starting KLENS Installation from $REPO_DIR..."

# 1. Create Target Directories
mkdir -p "$SCRIPT_DIR"

# 2. Copy Engine Script
if [ -f "$REPO_DIR/scripts/klens_engine.sh" ]; then
    cp "$REPO_DIR/scripts/klens_engine.sh" "$SCRIPT_DIR/klens_engine.sh"
    chmod +x "$SCRIPT_DIR/klens_engine.sh"
    echo "✅ Engine script installed."
else
    echo "❌ Error: scripts/klens_engine.sh not found in repo!"
fi

# 3. Copy Macros (Handles root or /macros/ folder)
if [ -f "$REPO_DIR/klens_macros.cfg" ]; then
    cp "$REPO_DIR/klens_macros.cfg" "$TARGET_DIR/klens_macros.cfg"
    echo "✅ Macros installed to root."
elif [ -f "$REPO_DIR/macros/klens_macros.cfg" ]; then
    cp "$REPO_DIR/macros/klens_macros.cfg" "$TARGET_DIR/klens_macros.cfg"
    echo "✅ Macros installed from /macros/ folder."
fi

echo "---"
echo "✅ KLENS Installation Complete!"
echo "👉 Add [include klens/klens_macros.cfg] to your printer.cfg and RESTART."
