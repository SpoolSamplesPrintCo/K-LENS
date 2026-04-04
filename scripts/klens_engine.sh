#!/bin/bash
# KLENS ENGINE v0.11.4.16 - HARD HARDWARE OVERRIDE
CONFIG_PATH="/home/biqu/printer_data/config/klens/klens_config.ini"

# Force the camera into Manual Mode so it stops ignoring us
unlock() {
    v4l2-ctl -c exposure_auto=1 > /dev/null 2>&1
    v4l2-ctl -c exposure_dynamic_framerate=0 > /dev/null 2>&1
    v4l2-ctl -c white_balance_temperature_auto=0 > /dev/null 2>&1
}

case "$1" in
    bias)
        unlock
        # Force a baseline and then apply the bias
        new_val=$((166 + $2))
        v4l2-ctl -c exposure_absolute=$new_val
        sed -i "s/^bias = .*/bias = $2/" $CONFIG_PATH
        ;;
    gain|brightness|contrast|saturation|hue|sharpness|white_balance_temperature)
        unlock
        v4l2-ctl -c $1=$2
        ;;
    auto_exp)
        # 3 is Auto, 1 is Manual
        [[ "$2" == "1" ]] && v4l2-ctl -c exposure_auto=3 || v4l2-ctl -c exposure_auto=1
        ;;
    auto_color)
        v4l2-ctl -c white_balance_temperature_auto=$2
        ;;
    status)
        echo "--- K-LENS CALIBRATION REPORT ---"
        v4l2-ctl -C exposure_absolute,exposure_auto,gain,brightness,contrast,white_balance_temperature,saturation | sed 's/ / /g'
        echo "---------------------------------"
        ;;
    save)
        # Simple save logic to ini
        ;;
esac
