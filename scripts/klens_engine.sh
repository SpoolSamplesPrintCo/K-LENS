#!/bin/bash
# KLENS ENGINE v0.11.4.24 - HARDWARE FORCE RESET
CONFIG_PATH="/home/biqu/printer_data/config/klens/klens_config.ini"

# Aggressive unlock to force the driver to listen
unlock() {
    v4l2-ctl -c exposure_auto=1 > /dev/null 2>&1
    v4l2-ctl -c auto_exposure=1 > /dev/null 2>&1
    v4l2-ctl -c exposure_dynamic_framerate=0 > /dev/null 2>&1
    v4l2-ctl -c white_balance_temperature_auto=0 > /dev/null 2>&1
}

case "$1" in
    bias)
        unlock
        # Baseline 500. Bias -400 = 100 Exp. Bias -280 = 220 Exp.
        new_val=$((500 + $2))
        [[ $new_val -lt 1 ]] && new_val=1
        # Double-tap: force to 1 then to new_val to trigger driver update
        v4l2-ctl -c exposure_time_absolute=1 > /dev/null 2>&1
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
        sync && echo "Hardware Sync Complete"
        ;;
esac
