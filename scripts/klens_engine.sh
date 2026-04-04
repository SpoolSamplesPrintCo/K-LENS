#!/bin/bash
# KLENS ENGINE v0.11.4.20 - THE EXPOSURE CLAMP
CONFIG_PATH="/home/biqu/printer_data/config/klens/klens_config.ini"

unlock() {
    v4l2-ctl -c auto_exposure=1 > /dev/null 2>&1
    v4l2-ctl -c exposure_auto=1 > /dev/null 2>&1
    v4l2-ctl -c exposure_dynamic_framerate=0 > /dev/null 2>&1
}

case "$1" in
    bias)
        unlock
        # Base is 156 (your driver default). 
        # If bias is -280, 156-280 = -124. DRIVERS HATE NEGATIVES.
        # This new math ensures we stay between 1 and 5000.
        calc=$((156 + $2))
        [[ $calc -lt 1 ]] && new_val=1 || new_val=$calc
        
        v4l2-ctl -c exposure_time_absolute=$new_val > /dev/null 2>&1
        v4l2-ctl -c gain=0 > /dev/null 2>&1 # Force Gain to 0 to kill the noise
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
        echo "---------------------------------"
        ;;
esac
