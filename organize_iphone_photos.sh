#!/bin/bash

# This script organizes iPhone photos in a specified directory.
# It performs the following tasks:
# 1. Moves hidden files to a separate directory.
# 2. Converts HEIC photos to PNG format using heif-convert.
# 3. Moves the original HEIC files to a separate directory.
# 4. Moves non-JPG/PNG files to a separate directory.

TARGET_EXTENSION="png"
WORK_DIR="/mnt/c/Users/Noah/Documents/Fotos_Test"

# Move hidden files to their own directory
hidden_files=$(find "$WORK_DIR" -maxdepth 1 -name ".*")

if [ -n "$hidden_files" ]; then
    mkdir -p "$WORK_DIR/hidden_files"

    echo "$hidden_files" | xargs -I{} mv {} "$WORK_DIR/hidden_files"

    echo -e "\n ✅ Hidden files moved \n"
fi

# Convert HEIC to PNG using heif-convert
if ls -A $WORK_DIR/*.HEIC 1>/dev/null 2>&1; then

    # Get the list of images with the HEIC extension
    heic_files=$(find $WORK_DIR -maxdepth 1 -type f \( -iname "*.HEIC" -o -iname "*.heic" \))

    # Count the number of HEIC files
    num_files=$(echo "$heic_files" | wc -l)

    # Go over each file and convert it to PNG showing the progress bar
    for file in $heic_files; do

        heif-convert --quiet "$file" "${file%.*}.${TARGET_EXTENSION}"

        # Output text for tqdm to update the progress bar with description
        echo "$file"

    done | tqdm --total "$num_files" --unit "files" --unit_scale --desc "Converting HEIC to PNG" --position 0 --leave False >>/dev/null

    echo -e "\n ✅ HEIC photos converted \n"
fi

# Move .HEIC and .heic files to their own directory
heic_files=$(find "$WORK_DIR" -maxdepth 1 -type f \( -iname "*.HEIC" -o -iname "*.heic" \))

if [ -n "$heic_files" ]; then
    mkdir -p "$WORK_DIR/HEIC_files"

    echo "$heic_files" | xargs -I{} mv {} "$WORK_DIR/HEIC_files"

    echo -e "\n ✅ HEIC files moved \n"
fi

# Move non-JPG/PNG files to their own directory
# Get the list of non-JPG/PNG files
non_image_files=$(find "$WORK_DIR" -maxdepth 1 -type f ! -iname "*.jpg" ! -iname "*.png")

if [ -n "$non_image_files" ]; then
    mkdir -p "$WORK_DIR/no_images_files"

    echo "$non_image_files" | xargs -I{} mv {} "$WORK_DIR/no_images_files"

    echo -e "\n ✅ Non-image files moved \n"
fi
