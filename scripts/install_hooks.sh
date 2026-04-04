#!/bin/bash
# K-LENS Update Hook v.0.1.0 -  Runs after every Git Pull/Update
# Path: /home/biqu/printer_data/config/klens/scripts/install_hooks.sh

echo "🔎 K-LENS: Re-applying script permissions after update..."
chmod +x /home/biqu/printer_data/config/klens/scripts/*.sh

# Ensure the config remains ignored by Git after pulls
cd /home/biqu/printer_data/config/klens
git update-index --assume-unchanged klens_config.ini

echo "✅ K-LENS: Update hooks completed successfully."
