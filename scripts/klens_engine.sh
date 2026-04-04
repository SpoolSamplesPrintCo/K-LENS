#!/bin/bash
# KLENS ENGINE v0.11.4.12 - HARD OVERRIDE
CONFIG_PATH="/home/biqu/printer_data/config/klens/klens_config.ini"

# --- Heavy-Duty Hardware Unlocker ---
unlock_camera() {
    # 1. Force Manual Exposure (1=Manual)
    v4l2-ctl -c auto_exposure=1 > /dev/null 2>&1
    # 2. Disable Dynamic Framerate (Crucial for BTT/CB1 images)
    v4l2-ctl -c exposure_dynamic_framerate=0 > /dev/null 2>&1
    # 3. Disable Auto WB
    v4l2-ctl -c white_balance_temperature_auto=0 > /dev/null 2>&1
}

get_val() {
    local val=$(v4l2-ctl -C $1 | awk '{print $2}')
    [[ -z "$val" ]] && echo "0" || echo "$val"
}

case "$1" in
    bias)
        unlock_camera
        # We use exposure_time_absolute for the actual shift
        # Math: 170 is the baseline "neutral" for this driver
        new_total=$((170 + $2))
        v4l2-ctl -c exposure_time_absolute=$new_total
        sed -i "s/^bias = .*/bias = $2/" $CONFIG_PATH
        ;;
    brightness|contrast|saturation|hue|sharpness|gain|white_balance_temperature)
        unlock_camera
        v4l2-ctl -c $1=$2
        ;;
    auto_exp)
        # Force switch: 3 is Auto, 1 is Manual
        [[ "$2" == "1" ]] && v4l2-ctl -c auto_exposure=3 || v4l2-ctl -c auto_exposure=1
        ;;
    status)
        bias=$(grep "bias" $CONFIG_PATH | cut -d' ' -f3)
        echo "--- K-LENS CALIBRATION REPORT ---"
        echo "Exp: Total=$(get_val "exposure_time_absolute") (Bias:$bias) | Mode=$(get_val "auto_exposure")"
        echo "Color: WB=$(get_val "white_balance_temperature") | Sat=$(get_val "saturation")"
        echo "Quality: Gain=$(get_val "gain") | Bright=$(get_val "brightness") | Con=$(get_val "contrast")"
        echo "---------------------------------"
        ;;
    # ... rest of cases (restart/save)
esac
