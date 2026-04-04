#!/bin/bash
# K-LENS: Multiplier Engine v0.8.7.7 (Hybrid Master)
CONF_FILE="/home/biqu/printer_data/config/klens/klens_config.ini"
BASE_EXP=450

clamp() {
  local val=$1; local min=$2; local max=$3
  if [ "$val" -lt "$min" ]; then echo "$min"
  elif [ "$val" -gt "$max" ]; then echo "$max"
  else echo "$val"; fi
}

# --- 1. PARAMETER PROCESSING ---
if [ ! -z "$1" ] && [ ! -z "$2" ]; then
    CURRENT_VAL=$(grep "^$1 =" $CONF_FILE | cut -d'=' -f2 | tr -d '[:space:]')
    if [[ "$1" == "mode" ]]; then NEW_VAL=$2
    elif [[ "$2" == "ADD" ]]; then NEW_VAL=$(expr ${CURRENT_VAL:-0} + ${3:-0}); sed -i "s/^mode = .*/mode = MANUAL/" $CONF_FILE
    elif [[ "$2" == "SUB" ]]; then NEW_VAL=$(expr ${CURRENT_VAL:-0} - ${3:-0}); sed -i "s/^mode = .*/mode = MANUAL/" $CONF_FILE
    else NEW_VAL=$2; fi

    case "$1" in
        bias) NEW_VAL=$(clamp "$NEW_VAL" -449 5000) ;;
        gain|brightness|saturation|contrast) NEW_VAL=$(clamp "$NEW_VAL" 0 255) ;;
        wb) NEW_VAL=$(clamp "$NEW_VAL" 2000 7500) ;;
        sharpness) NEW_VAL=$(clamp "$NEW_VAL" 0 15) ;;
        hue) NEW_VAL=$(clamp "$NEW_VAL" -180 180) ;;
    esac
    sed -i "s/^$1 = .*/$1 = $NEW_VAL/" $CONF_FILE
fi

# --- 2. EXECUTION LOGIC ---
get_v() { grep "^$1 =" $CONF_FILE | cut -d'=' -f2 | tr -d '[:space:]'; }
MODE=$(get_v mode)

if [ "$MODE" == "FULL_AUTO" ]; then
    v4l2-ctl -d /dev/video0 --set-ctrl=auto_exposure=3 --set-ctrl=white_balance_automatic=1
    echo "--- K-LENS SYSTEM REPORT: FULL_AUTO ENABLED ---"; exit 0
fi

BIAS=$(get_v bias); GAIN=$(get_v gain); WB=$(get_v wb); HUE=$(get_v hue)
SAT=$(get_v saturation); CON=$(get_v contrast); SHP=$(get_v sharpness)
BRT=$(get_v brightness); A_WB=$(get_v auto_wb); A_HUE=$(get_v auto_hue); A_SAT=$(get_v auto_sat)

TARGET_EXP=$(expr $BASE_EXP + ${BIAS:-0})
[ "$TARGET_EXP" -lt 1 ] && TARGET_EXP=1

# Apply Manual Exposure/Gain/Bright/Contrast/Sharp (The "Hybrid" Core)
v4l2-ctl -d /dev/video0 \
  --set-ctrl=auto_exposure=1 \
  --set-ctrl=exposure_time_absolute=$TARGET_EXP \
  --set-ctrl=gain=$GAIN \
  --set-ctrl=brightness=$BRT \
  --set-ctrl=contrast=$CON \
  --set-ctrl=sharpness=$SHP

# Apply Color Controls (Manual only if Auto is OFF)
v4l2-ctl -d /dev/video0 --set-ctrl=white_balance_automatic=$A_WB
[ "$A_WB" -eq 0 ] && v4l2-ctl -d /dev/video0 --set-ctrl=white_balance_temperature=$WB 2>/dev/null

# Note: Many UVC cameras don't have separate auto_hue/auto_sat toggles,
# so we apply them manually only if the user hasn't flagged them as 'Auto' in the config.
[ "$A_SAT" -eq 0 ] && v4l2-ctl -d /dev/video0 --set-ctrl=saturation=$SAT
[ "$A_HUE" -eq 0 ] && v4l2-ctl -d /dev/video0 --set-ctrl=hue=$HUE

echo "--- K-LENS CALIBRATION REPORT ---"
echo "Exp: Total=$TARGET_EXP (Bias:$BIAS) | Mode=$MODE"
echo "Auto-Color: WB=$A_WB | Hue=$A_HUE | Sat=$A_SAT"
echo "Quality: Gain=$GAIN | Bright=$BRT | Contrast=$CON | Sharp=$SHP"
echo "---------------------------------"
