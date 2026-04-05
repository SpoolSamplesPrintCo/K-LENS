#!/bin/bash
# KLENS ENGINE v0.11.4.23 - HARD RESET ON TOGGLE
CONFIG_PATH="/home/biqu/printer_data/config/klens/klens_config.ini"

unlock() {
    v4l2-ctl -c auto_exposure=1 > /dev/null 2>&1
    v4l2-ctl -c exposure_auto=1 > /dev/null 2>&1
    v4l2-ctl -c white_balance_temperature_auto=0 > /dev/null 2>&1
}

case "$1" in
    bias)
        unlock
        # If toggling, we slam gain to 0 first to ensure the image isn't blown out
        v4l2-ctl -c gain=0 > /dev/null 2>&1
        new_val=$((500 + $2))
        [[ $new_val -lt 1 ]] && new_val=1
        v4l2-ctl -c exposure_time_absolute=$new_val
        sed -i "s/^bias = .*/bias = $2/" $CONFIG_PATH
        ;;
    gain|brightness|contrast|saturation|hue|sharpness|white_balance_temperature)
        unlock
        v4l2-ctl -c $1=$2
        ;;
    status)
        echo "--- K-LENS CALIBRATION REPORT ---"
        v4l2-ctl -C auto_exposure,exposure_time_absolute,gain,brightness,contrast
        ;;
    save)
        sync
        ;;
esac
