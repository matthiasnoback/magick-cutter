#!/usr/bin/env bash

set -eu

# Overlay watermark image in the center:

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

  ((width_of_watermark = shortest_side * 3 / 4 ))
  ((height_of_watermark = width_of_watermark)) # We assume it's a square watermark
  echo "- Watermark should be ${width_of_watermark} pixels wide"
  echo "- Watermark should be ${height_of_watermark} pixels high"

  ((margin_left = (image_width - width_of_watermark) / 2))
  echo "- Watermark should have a left margin of ${margin_left} pixels"
  ((margin_top = (image_height - height_of_watermark) / 2))
  echo "- Watermark should have a top margin of ${margin_top} pixels"

  magick composite \
      -dissolve 20 \
      -resize '1x1<' \
      -geometry "${width_of_watermark}"x"${height_of_watermark}"+"${margin_left}"+"${margin_top}" \
      "${watermark_file}" \
      "${source_file}" \
      "${target_file}"

  echo "Created file with watermark: ${target_file}"
}

function process_file {
    source_file="${1}"
    watermark_file="${2}"

    if [[ ${source_file} =~ (.+).jpg$ ]]; then
        target_file_name="${BASH_REMATCH[1]}-WG.jpg"
    else
        target_file_name="WG-${source_file}"
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
