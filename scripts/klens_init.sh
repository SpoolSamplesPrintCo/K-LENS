#!/bin/bash
CONF_FILE="/home/biqu/printer_data/config/klens/klens_config.ini"

# Function to parse and send to Klipper via moonraker/console
# We use 'mainsail' or 'fluidd' console redirection
kset() {
    KEY=$1
    VALUE=$(grep "$KEY =" $CONF_FILE | awk '{print $3}')
    # This sends the SET_GCODE_VARIABLE command back to Klipper
    echo "SET_GCODE_VARIABLE MACRO=_KLENS_VARIABLES VARIABLE=$KEY VALUE=$VALUE" > ~/printer_data/comms/klippy.serial
}

kset "bias"
kset "gain"
kset "wb"
kset "brightness"

echo "🔎 K-LENS: Persistence variables loaded from config.ini"
