#!/usr/bin/env bash

set -eu

source_file="$1"
echo "Source file: ${source_file}"

image_width=$(convert ${source_file} -format "%w" info:)
echo "Image width: ${image_width} pixels"

image_height=$(convert ${source_file} -format "%h" info:)
echo "Image height: ${image_height} pixels"

if [[ ${source_file} =~ ([a-zA-Z0-9]+)_([0-9]{1,})x([0-9]{1,}) ]]; then
    target_file_name=${BASH_REMATCH[1]}
    horizontal_tiles=${BASH_REMATCH[2]}
    vertical_tiles=${BASH_REMATCH[3]}
else
    horizontal_tiles="${2}"
    vertical_tiles="${3}"
    target_file_name="${4}"
fi
echo "Number of horizontal tiles: ${horizontal_tiles}"
echo "Number of vertical tiles: ${vertical_tiles}"
echo "Target file name: ${target_file_name}"

((tile_width=image_width / horizontal_tiles))
((tile_height=image_height / vertical_tiles))

echo "Tiles will be: ${tile_width}x${tile_height} pixels"

tile_number=1;
offset_x=0;
offset_y=0;
for ((v = 0; v < ${vertical_tiles}; v++ ))
do
    for ((h = 0; h < ${horizontal_tiles}; h++ ))
    do
        offset_x=$((h * tile_width))
        offset_y=$((v * tile_height))

        echo "Extract tile ${tile_number} at position (${offset_x},${offset_y})"
        target_file="${target_file_name}_${tile_number}.jpg"
        echo "Save it to ${target_file}"

        convert -size ${image_width}x${image_height} \
          "${source_file}[${tile_width}x${tile_height}+${offset_x}+${offset_y}]" \
          ${target_file}

        ((tile_number++))
    done
done
