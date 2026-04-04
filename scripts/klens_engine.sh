#!/bin/bash
# KLENS ENGINE v0.11.4.18 - DRIVER FIX
CONFIG_PATH="/home/biqu/printer_data/config/klens/klens_config.ini"

unlock() {
    # Try both common names for manual exposure mode
    v4l2-ctl -c exposure_auto=1 > /dev/null 2>&1
    v4l2-ctl -c auto_exposure=1 > /dev/null 2>&1
    v4l2-ctl -c exposure_dynamic_framerate=0 > /dev/null 2>&1
}

case "$1" in
    bias)
        unlock
        new_val=$((166 + $2))
        # Try both common exposure parameter names
        v4l2-ctl -c exposure_time_absolute=$new_val > /dev/null 2>&1
        v4l2-ctl -c exposure_absolute=$new_val > /dev/null 2>&1
        sed -i "s/^bias = .*/bias = $2/" $CONFIG_PATH
        ;;
    gain|brightness|contrast|saturation|hue|sharpness|white_balance_temperature)
        unlock
        v4l2-ctl -c $1=$2
        ;;
    auto_exp)
        v4l2-ctl -c exposure_auto=$(( $2 == 1 ? 3 : 1 )) > /dev/null 2>&1
        v4l2-ctl -c auto_exposure=$(( $2 == 1 ? 3 : 1 )) > /dev/null 2>&1
        ;;
    auto_color)
        v4l2-ctl -c white_balance_temperature_auto=$2
        ;;
    status)
        echo "--- K-LENS CALIBRATION REPORT ---"
        v4l2-ctl -l | grep -E "exposure_time_absolute|exposure_absolute|exposure_auto|gain|brightness|contrast"
        echo "---------------------------------"
        ;;
    save)
        sync
        echo "Settings Saved to Hardware"
        ;;
esac
