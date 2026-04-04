#!/bin/bash

# KLENS ENGINE v0.11.4.9
# Handle camera parameters and ini storage
CONFIG_PATH="/home/biqu/printer_data/config/klens/klens_config.ini"

# --- Helper: Get/Set Camera Values via v4l2-ctl ---
# (Existing v4l2 logic remains the same...)

# --- The Fix: Logic for lines 58, 62, 63 ---
get_val() {
    local val=$(v4l2-ctl -C $1 | awk '{print $2}')
    # If val is empty, default to 0 to prevent integer errors
    if [[ -z "$val" ]]; then echo "0"; else echo "$val"; fi
}

# (Existing logic for setting parameters...)

# --- The Calibration Report Logic ---
# Ensure all variables are treated as integers for the report
bias=$(grep "bias" $CONFIG_PATH | cut -d' ' -f3 || echo "-280")
gain=$(get_val "gain")
bright=$(get_val "brightness")
contrast=$(get_val "contrast")
sharp=$(get_val "sharpness")
wb=$(get_val "white_balance_temperature")
mode=$(v4l2-ctl -C auto_exposure | awk '{print $2}')

echo "--- K-LENS CALIBRATION REPORT ---"
echo "Exp: Total=$((170 + bias)) (Bias:$bias) | Mode=$mode"
echo "Auto-Color: WB=$wb | Hue=$(get_val "hue") | Sat=$(get_val "saturation")"
echo "Quality: Gain=$gain | Bright=$bright | Contrast=$contrast | Sharp=$sharp"
echo "---------------------------------"
