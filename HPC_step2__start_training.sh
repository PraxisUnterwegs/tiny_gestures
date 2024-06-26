#!/bin/bash

# Determine the directory of the current script, that is, the tiny_gestures directory
TINY_GESTURES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "$TINY_GESTURES_DIR"

# generate target samples' path
python3 "$TINY_GESTURES_DIR/read_images_path.py"
if [ $? -ne 0 ]; then
    echo "Failed to run read_images_path.py"
    exit 1
fi

# Write a file to put classes' labels into it
echo -e "fist\nlike\nok\npalm\npeace\npeace_inv\nstop" > "$TINY_GESTURES_DIR/classes.txt"

if [ -f "$classes_file" ]; then
    num_categories=$(grep -v '^[[:space:]]*$' "$classes_file" | wc -l)
    {
    echo -e "classes = $num_categories"
    echo -e "train = $TINY_GESTURES_DIR/images_train.txt"
    echo -e "valid = $TINY_GESTURES_DIR/images_val.txt"
    echo -e "names = $TINY_GESTURES_DIR/classes.txt"
    echo -e "backup = $TINY_GESTURES_DIR/backup/"
    } > "$TINY_GESTURES_DIR/training_control_file.txt"
fi

# Get the necessary file path
OBJ_DATA_PATH="$TINY_GESTURES_DIR/training_control_file.txt"
CFG_PATH="$TINY_GESTURES_DIR/yolov4-tiny-custom.cfg"
WEIGHTS_PATH="$TINY_GESTURES_DIR/yolov4-tiny.conv.29"

echo "$WEIGHTS_PATH"

# Enter the darknet directory and run the training command
DARKNET_DIR="$TINY_GESTURES_DIR/darknet"
echo "$DARKNET_DIR"

cd "$DARKNET_DIR"

# Run training command with nohup and redirect output to a log file
nohup ./darknet detector train "$OBJ_DATA_PATH" "$CFG_PATH" "$WEIGHTS_PATH" -map

echo "Training has started. Check training.log for progress."
