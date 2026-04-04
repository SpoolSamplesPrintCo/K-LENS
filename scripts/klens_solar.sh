#!/bin/bash
# K-LENS: Gradient Solar Engine v0.3.4.0
# Path: /home/biqu/printer_data/config/klens/scripts/klens_solar.sh

CONF_FILE="/home/biqu/printer_data/config/klens/klens_config.ini"
SAVE_SCRIPT="/home/biqu/printer_data/config/klens/scripts/klens_save.sh"

# 1. Parse Coordinates (with extra cleaning to remove hidden spaces)
LAT=$(grep "lat =" $CONF_FILE | awk '{print $3}' | tr -d '\r' | tr -d ' ')
LON=$(grep "long =" $CONF_FILE | awk '{print $3}' | tr -d '\r' | tr -d ' ')

# 2. Construct the URL
URL="https://api.sunrisesunset.io/json?lat=${LAT}&lng=${LON}"

# 3. Fetch Solar Data
API_DATA=$(curl -s --connect-timeout 5 "$URL")

# 4. Extract times
RAW_RISE=$(echo "$API_DATA" | grep -o '"sunrise":"[^"]*"' | cut -d'"' -f4)
RAW_SET=$(echo "$API_DATA" | grep -o '"sunset":"[^"]*"' | cut -d'"' -f4)

# 5. Fallback Logic
if [ -z "$RAW_RISE" ] || [ -z "$RAW_SET" ]; then
    # ONLY print this if it fails
    echo "K-LENS: API Error using URL: $URL"
    SUNRISE=$(date -d "06:00:00" +%s)
    SUNSET=$(date -d "20:00:00" +%s)
else
    SUNRISE=$(date -d "$RAW_RISE" +%s)
    SUNSET=$(date -d "$RAW_SET" +%s)
fi

NOW=$(date +%s)
FADE_TIME=3600 

# 6. Logic for Scale
if [ $NOW -lt $SUNRISE ]; then
    SCALE="1.0"
    MSG="🌗 Night (Pre-Dawn)"
elif [ $NOW -lt $((SUNRISE + FADE_TIME)) ]; then
    DIFF=$((NOW - SUNRISE))
    SCALE=$(echo "scale=2; 1 - ($DIFF / $FADE_TIME)" | bc -l)
    MSG="🌅 Dawn Fade"
elif [ $NOW -lt $((SUNSET - FADE_TIME)) ]; then
    SCALE="0.0"
    MSG="☀️ Full Day"
elif [ $NOW -lt $SUNSET ]; then
    DIFF=$((NOW - (SUNSET - FADE_TIME)))
    SCALE=$(echo "scale=2; $DIFF / $FADE_TIME" | bc -l)
    MSG="🌇 Sunset Fade"
else
    SCALE="1.0"
    MSG="🌗 Night"
fi

[[ $SCALE == .* ]] && SCALE="0$SCALE"
[ -z "$SCALE" ] && SCALE="0.0"

echo "K-LENS: $MSG (Scale: $SCALE)"
bash "$SAVE_SCRIPT" solar_scale "$SCALE"
