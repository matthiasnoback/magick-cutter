#!/usr/bin/env bash

set -eu

function extract {
    source_file="$1"
    horizontal_tiles="$2"
    vertical_tiles="$3"
    target_file_name="$4"

    echo "Extract tiles from image file ${source_file}"
    echo "Number of horizontal tiles: ${horizontal_tiles}"
    echo "Number of vertical tiles: ${vertical_tiles}"
    echo "Target file name: ${target_file_name}"

    image_width=$(convert ${source_file} -format "%w" info:)
    echo "Image width: ${image_width} pixels"

    image_height=$(convert ${source_file} -format "%h" info:)
    echo "Image height: ${image_height} pixels"

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
}

function process_file {
    source_file="${1}"

    if [[ ${source_file} =~ ([a-zA-Z0-9]+)_([0-9]{1,})x([0-9]{1,}) ]]; then
        target_file_name=${BASH_REMATCH[1]}
        horizontal_tiles=${BASH_REMATCH[2]}
        vertical_tiles=${BASH_REMATCH[3]}
    else
        horizontal_tiles="${2}"
        vertical_tiles="${3}"
        target_file_name="${4}"
    fi

    extract $source_file $horizontal_tiles $vertical_tiles $target_file_name
}

# Read the provided source file, or assume the source will be the current directory
source="${1-.}"
echo "Source file: ${source}"

if [ -d "${source}" ]; then
    # The source file is a directory
    echo "Extract tiles from all jpg images in ${source}"
    all_jpg_files="${source}/*.jpg"
    image_counter=0
    for source_file in $all_jpg_files
    do
        echo "${source_file}"

        process_file "${source_file}" "${2-1}" "${3-1}" "${4-target}"
        image_counter=$((image_counter++))
    done
    echo "Extracted tiles from ${image_counter} image(s)"
else
    # The source file is a single file
    process_file "${source}" "${2-1}" "${3-1}" "${4-target}"
    echo "Extracted tiles from 1 image"
fi
