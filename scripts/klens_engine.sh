#!/bin/bash
# KLENS ENGINE v0.11.4.19 - DRIVER STRIKE TEAM
CONFIG_PATH="/home/biqu/printer_data/config/klens/klens_config.ini"

unlock() {
    # Force Manual Mode across all common driver names
    v4l2-ctl -c exposure_auto=1 > /dev/null 2>&1
    v4l2-ctl -c auto_exposure=1 > /dev/null 2>&1
    v4l2-ctl -c exposure_dynamic_framerate=0 > /dev/null 2>&1
    v4l2-ctl -c white_balance_temperature_auto=0 > /dev/null 2>&1
}

case "$1" in
    bias)
        unlock
        # This is the "Magic Number" for your BTT-CB1 setup
        new_val=$((166 + $2))
        # Hammer every exposure parameter name known to Linux
        v4l2-ctl -c exposure_time_absolute=$new_val > /dev/null 2>&1
        v4l2-ctl -c exposure_absolute=$new_val > /dev/null 2>&1
        v4l2-ctl -c exposure=$new_val > /dev/null 2>&1
        sed -i "s/^bias = .*/bias = $2/" $CONFIG_PATH
        ;;
    gain|brightness|contrast|saturation|hue|sharpness|white_balance_temperature)
        unlock
        v4l2-ctl -c $1=$2
        ;;
    auto_exp)
        # Force switch between 3 (Auto) and 1 (Manual)
        v4l2-ctl -c exposure_auto=$(( $2 == 1 ? 3 : 1 )) > /dev/null 2>&1
        ;;
    status)
        echo "--- K-LENS CALIBRATION REPORT ---"
        v4l2-ctl -l | grep -E "exposure|gain|bright|contrast"
        echo "---------------------------------"
        ;;
    save)
        sync
        ;;
esac
