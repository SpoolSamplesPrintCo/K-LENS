#!/bin/bash

# KLENS INSTALLER v0.11.4.8
KLENS_DIR="$HOME/printer_data/config/klens"
CONFIG_FILE="$KLENS_DIR/klens_config.ini"

echo "🚀 Starting KLENS Automated Installation..."

mkdir -p "$KLENS_DIR/scripts"

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
fi

chmod +x "$KLENS_DIR/scripts/klens_engine.sh"
chmod +x "$KLENS_DIR/install.sh"

echo "✅ KLENS Installation Successful!"
