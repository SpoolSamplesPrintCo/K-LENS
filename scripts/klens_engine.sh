#!/bin/bash
# KLENS ENGINE v0.11.4.10
CONFIG_PATH="/home/biqu/printer_data/config/klens/klens_config.ini"

# --- Hardware Unlocker ---
unlock_camera() {
    # Force manual mode to allow register writes
    v4l2-ctl -c auto_exposure=1 > /dev/null 2>&1
    v4l2-ctl -c white_balance_temperature_auto=0 > /dev/null 2>&1
}

get_val() {
    local val=$(v4l2-ctl -C $1 | awk '{print $2}')
    [[ -z "$val" ]] && echo "0" || echo "$val"
}

# --- Action Switcher ---
case "$1" in
    bias)
        unlock_camera
        v4l2-ctl -c exposure_dynamic_framerate=0
        v4l2-ctl -c exposure_time_absolute=$(($((170 + $2))))
        sed -i "s/^bias = .*/bias = $2/" $CONFIG_PATH
        ;;
    brightness|contrast|saturation|hue|sharpness|gain|white_balance_temperature)
        unlock_camera
        v4l2-ctl -c $1=$2
        ;;
    auto_exp)
        # 1 = Manual (K-Lens Control), 3 = Aperture Priority (Full Auto)
        [[ "$2" == "1" ]] && v4l2-ctl -c auto_exposure=3 || v4l2-ctl -c auto_exposure=1
        ;;
    auto_color)
        v4l2-ctl -c white_balance_temperature_auto=$2
        ;;
    status)
        bias=$(grep "bias" $CONFIG_PATH | cut -d' ' -f3)
        echo "--- K-LENS CALIBRATION REPORT ---"
        echo "Exp: Total=$((170 + bias)) (Bias:$bias) | Mode=$(get_val "auto_exposure")"
        echo "Color: WB=$(get_val "white_balance_temperature") | Sat=$(get_val "saturation")"
        echo "Quality: Gain=$(get_val "gain") | Bright=$(get_val "brightness") | Contrast=$(get_val "contrast")"
        echo "---------------------------------"
        ;;
    save)
        # Current logic for writing all current v4l values to ini
        ;;
esac
