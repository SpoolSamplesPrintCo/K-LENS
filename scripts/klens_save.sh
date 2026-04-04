#!/bin/bash
# K-LENS: Persistence Script v0.2.2.0
# Path: /home/biqu/printer_data/config/klens/scripts/klens_save.sh

CONF_FILE="/home/biqu/printer_data/config/klens/klens_config.ini"
VAR_NAME=$1
VAR_VALUE=$2

# 1. Create file if it doesn't exist
if [ ! -f "$CONF_FILE" ]; then
    echo "[globals]" > "$CONF_FILE"
fi

# 2. Update value: Delete old line (if exists) and append new one
# We use 'tr -d' to ensure no hidden Windows characters or spaces sneak in
CLEAN_VAL=$(echo "$VAR_VALUE" | tr -d '\r' | tr -d ' ')

grep -v "$VAR_NAME =" "$CONF_FILE" > "${CONF_FILE}.tmp"
echo "$VAR_NAME = $CLEAN_VAL" >> "${CONF_FILE}.tmp"
mv "${CONF_FILE}.tmp" "$CONF_FILE"

echo "K-LENS: Saved $VAR_NAME=$CLEAN_VAL to config.ini"
