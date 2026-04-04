#!/bin/bash
# K-LENS Dependency & Initial Setup v0.1.5
# Path: /home/biqu/printer_data/config/klens/scripts/install_deps.sh

CURRENT_USER=$(whoami)
KLENS_DIR="/home/biqu/printer_data/config/klens"

echo "🔎 K-LENS: Installing System Dependencies..."
sudo apt-get update && sudo apt-get install -y v4l-utils bc jq curl ffmpeg

echo "🔎 K-LENS: Setting up sudoers bridge for camera control..."
echo "$CURRENT_USER ALL=(ALL) NOPASSWD: /usr/bin/v4l2-ctl" | sudo tee /etc/sudoers.d/klens
sudo chmod 0440 /etc/sudoers.d/klens

echo "🔎 K-LENS: Securing script executables..."
chmod +x $KLENS_DIR/scripts/*.sh

echo "🔎 K-LENS: Isolating local config from Git tracking (Prevention of 'Dirty' status)..."
cd $KLENS_DIR
git update-index --assume-unchanged klens_config.ini

echo "✅ K-LENS: Installation Complete! Your local klens_config.ini is now protected."
