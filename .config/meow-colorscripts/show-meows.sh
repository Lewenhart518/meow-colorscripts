#!/bin/bash
CONFIG_FILE="$HOME/.config/meow-colorscripts/config"
LANG_FILE="$HOME/.config/meow-colorscripts/lang"

if [ -f "$CONFIG_FILE" ]; then
    source "$CONFIG_FILE"
else
    MEOW_PATH="$HOME/.config/meow-colorscripts/colorscripts/normal"
fi

if [ -f "$LANG_FILE" ]; then
    source "$LANG_FILE"
else
    LANGUAGE="en"
fi

MEOW_ARRAY=("$MEOW_PATH"/*.txt)
RANDOM_MEOW="${MEOW_ARRAY[RANDOM % ${#MEOW_ARRAY[@]}]}"

bash "$RANDOM_MEOW"

