#!/usr/bin/env bash

# Utility function to print separators for better visual distinction
print_separator() {
  echo '********************************************'
}

# Function to initialize shell options and set GLOBIGNORE
initialize() {
  shopt -s dotglob    # Include hidden directories
  shopt -s nullglob    # Ignore empty directories
  shopt -s nocaseglob  # Ignore case sensitivity
  GLOBIGNORE='*_sub.mp4'  # Ignore already processed files ending with _sub.mp4
}

# Function to reset shell options after execution
cleanup() {
  shopt -u dotglob
  shopt -u nullglob
  shopt -u nocaseglob
  unset GLOBIGNORE
}

# Function to get metadata of a file using ffprobe
get_file_metadata() {
  local file="$1"
  ffprobe -v quiet -print_format json -show_format -show_streams "$file" 2>&1
}

# Function to gather subtitle files from a directory
get_subtitle_files() {
  local dir="$1"
  local filenameonly="$2"
  local -n subtitles_ref="$3"

  for srtfile in "$dir"*.srt; do
    if [[ "$srtfile" =~ .*?(english|eng|en).*\.srt$ ]]; then
      subtitles_ref+=("-i \"$srtfile\"")
    fi
  done

  if [ -z "${subtitles_ref[@]}" ]; then
    for srtfile in "$dir"*.srt; do
      subtitles_ref+=("-i \"$srtfile\"")
    done
  fi
}

# Function to convert VOB files to high-quality MP4 using H.264
convert_vob_to_mp4() {
  local file="$1"
  local output_file="./done/$(basename "${file%.vob}.mp4")"
  
  echo "Converting $file to $output_file"
  
  ffmpeg -fflags +genpts -y -i "$file" \
    -c:v libx264 -preset slow -crf 18 \  # H.264 with high-quality settings
    -c:a aac -b:a 256k -ac 2 \  # AAC audio with 256k bitrate
    -movflags +faststart \  # Optimize for streaming
    "$output_file"
  
  if [[ $? -ne 0 ]]; then
    echo "Error processing $file"
  fi
}

# Main script loop
initialize

# Loop through each directory
for dir in */; do
  if [[ $(basename "$dir") == "done" ]]; then
    continue
  fi

  echo "Directory: $dir"
  for file in "$dir"*.vob; do
    if [[ "${file}" == *_sub.mp4 ]]; then
      continue
    fi

    echo " VOB File: $file"
    convert_vob_to_mp4 "$file"

  done

done

cleanup
