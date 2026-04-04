#!/bin/bash

# KLENS INSTALLER v0.11.4.3
# Source: SpoolSamplesPrintCo/klens (Development)
REPO_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
KLENS_DIR="$HOME/printer_data/config/klens"
CONFIG_FILE="$KLENS_DIR/klens_config.ini"

echo "🚀 Starting KLENS Automated Installation..."

# 1. Ensure internal directories exist
mkdir -p "$KLENS_DIR/scripts"

# 2. Seed the Config File (Beauty-First Defaults)
# This prevents the "No such file or directory" errors in the console.
if [ ! -f "$CONFIG_FILE" ]; then
    echo "📄 Seeding default klens_config.ini..."
    cat <<EOF > "$CONFIG_FILE"
[camera]
bias = -280
contrast = 54
brightness = 124
white_balance = 4000
gain = 0
saturation = 50
tint = 50
sharpness = 3
auto_exposure = 0
auto_color = 1
EOF
    echo "✅ Config seeded with Beauty-First defaults (-280 Bias)."
else
    echo "ℹ️ Existing klens_config.ini found. Skipping seed to preserve user settings."
fi

# 3. Set Execution Permissions on critical scripts
if [ -f "$KLENS_DIR/scripts/klens_engine.sh" ]; then
    chmod +x "$KLENS_DIR/scripts/klens_engine.sh"
    echo "✅ Engine permissions set."
fi

# Ensure the installer itself is executable for future Moonraker updates
chmod +x "$KLENS_DIR/install.sh"

echo "---"
echo "✅ KLENS Installation Successful!"
echo "👉 Add [include klens/klens_macros.cfg] to your printer.cfg and RESTART."
