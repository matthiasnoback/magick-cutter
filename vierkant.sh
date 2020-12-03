#!/usr/bin/env bash

set -eu

# Overlay watermark image in the center:

function make_square {
  source_file="${1}"
  target_file="${2}"

  echo "Source file: ${source_file}"

  image_width=$(magick ${source_file} -format "%w" info:)
  echo "- Image width: ${image_width} pixels"

  image_height=$(magick ${source_file} -format "%h" info:)
  echo "- Image height: ${image_height} pixels"

  if (( image_height >= image_width )); then
    ((longest_side = image_height))
    echo "- The longest side is the height"
  else
    echo "- The longest side is the width"
    ((longest_side = image_width))
  fi
  echo "- Longest side: ${longest_side} pixels"

  echo "- The squared image should be ${longest_side} x ${longest_side} pixels"

  magick convert \
      -background white \
      -gravity center \
      "${source_file}" \
      -resize "${longest_side}"x"${longest_side}" \
      -extent "${longest_side}"x"${longest_side}" \
      "${target_file}"

  echo "Created square picture: ${target_file}"
}

function process_file {
    source_file="${1}"

    if [[ ${source_file} =~ (.+).jpg$ ]]; then
        target_file_name="${BASH_REMATCH[1]}-vierkant.jpg"
    else
        target_file_name="vierkant-${source_file}"
    fi

    make_square "${source_file}" "${target_file_name}"
}

source="${1-.}"
echo "Source: ${source}"

if [ -d "${source}" ]; then
    # The source file is a directory
    echo "Make all jpg images in ${source} square"
    all_jpg_files="${source}/*.jpg"
    image_counter=0
    for source_file in $all_jpg_files
    do
        if [ -f "${source_file}" ]; then
          echo "${source_file}"

          process_file "${source_file}"
          ((image_counter=image_counter + 1))
        fi
    done
    echo "Made ${image_counter} image(s) square"
else
    # The source file is a single file
    process_file "${source}"
    echo "Made 1 image square"
fi
