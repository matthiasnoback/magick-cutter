#!/usr/bin/env bash

set -eu

# Overlay watermark image in bottom-right corner:

function add_watermark {
  source_file="${1}"
  watermark_file="${2}"
  target_file="${3}"

  echo "Source file: ${source_file}"
  echo "Use watermark file: ${watermark_file}"

  watermark_image_width=$(magick ${watermark_file} -format "%w" info:)
  echo "- Watermark image width: ${watermark_image_width} pixels"

  watermark_image_height=$(magick ${watermark_file} -format "%h" info:)
  echo "- Watermark image height: ${watermark_image_height} pixels"

  image_width=$(magick ${source_file} -format "%w" info:)
  echo "- Image width: ${image_width} pixels"

  image_height=$(magick ${source_file} -format "%h" info:)
  echo "- Image height: ${image_height} pixels"

  if (( image_height <= image_width )); then
    ((shortest_side = image_height))
    echo "- The shortest side is the height"
  else
    echo "- The shortest side is the width"
    ((shortest_side = image_width))
  fi
  echo "- Shortest side: ${shortest_side} pixels"

  ((width_of_watermark = shortest_side / 5))
  ((height_of_watermark = width_of_watermark)) # We assume it's a square watermark
  echo "- Watermark should be ${width_of_watermark} pixels wide"

  ((margin = shortest_side / 20))
  echo "- Watermark should have a margin to the right and bottom of ${margin} pixels"

  magick composite \
      -dissolve 50 \
      -gravity SouthEast \
      -geometry "${width_of_watermark}"x"${height_of_watermark}"+"${margin}"+"${margin}" \
      "${watermark_file}" \
      "${source_file}" \
      "${target_file}"

  echo "Created file with watermark: ${target_file}"
}

function process_file {
    source_file="${1}"
    watermark_file="${2}"

    if [[ ${source_file} =~ (.+).jpg$ ]]; then
        target_file_name="${BASH_REMATCH[1]}-WK.jpg"
    else
        target_file_name="WK-${source_file}"
    fi

    add_watermark "${source_file}" "${watermark_file}" "${target_file_name}"
}

source="${1-.}"
echo "Source: ${source}"

if [ -d "${source}" ]; then
    # The source file is a directory
    echo "Add a watermark to all jpg images in ${source}"
    all_jpg_files="${source}/*.jpg"
    image_counter=0
    for source_file in $all_jpg_files
    do
        if [ -f "${source_file}" ]; then
          echo "${source_file}"

          process_file "${source_file}" "${2-watermark.png}"
          ((image_counter=image_counter + 1))
        fi
    done
    echo "Added watermark to ${image_counter} image(s)"
else
    # The source file is a single file
    process_file "${source}" "${2-watermark.png}"
    echo "Added watermark to 1 image"
fi
