#!/bin/bash
# KLENS ENGINE v0.11.4.22 - POSITIVE SCALING FIX
CONFIG_PATH="/home/biqu/printer_data/config/klens/klens_config.ini"

unlock() {
    v4l2-ctl -c auto_exposure=1 > /dev/null 2>&1
    v4l2-ctl -c exposure_auto=1 > /dev/null 2>&1
    v4l2-ctl -c exposure_dynamic_framerate=0 > /dev/null 2>&1
}

case "$1" in
    bias)
        unlock
        # Baseline 500. Bias -400 = 100 Exp. Bias -280 = 220 Exp.
        calc=$((500 + $2))
        [[ $calc -lt 1 ]] && new_val=1 || new_val=$calc
        v4l2-ctl -c exposure_time_absolute=$new_val > /dev/null 2>&1
        v4l2-ctl -c gain=5 > /dev/null 2>&1 
        sed -i "s/^bias = .*/bias = $2/" $CONFIG_PATH
        ;;
    gain|brightness|contrast|saturation|hue|sharpness|white_balance_temperature)
        unlock
        v4l2-ctl -c $1=$2
        ;;
    auto_exp)
        # 3 is Auto, 1 is Manual
        val=$(( $2 == 1 ? 3 : 1 ))
        v4l2-ctl -c auto_exposure=$val > /dev/null 2>&1
        v4l2-ctl -c exposure_auto=$val > /dev/null 2>&1
        ;;
    status)
        echo "--- K-LENS CALIBRATION REPORT ---"
        v4l2-ctl -C auto_exposure,exposure_time_absolute,gain,brightness,contrast
        ;;
    save)
        sync && echo "Hardware Sync Complete"
        ;;
esac
