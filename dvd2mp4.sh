#!/usr/bin/env bash

# Function to initialize shell options and set GLOBIGNORE
initialize() {
  shopt -s dotglob    # Include hidden directories
  shopt -s nullglob    # Ignore empty directories
  shopt -s nocaseglob  # Ignore case sensitivity
  GLOBIGNORE='done/*'  # Ignore files in the "done" directory
}

# Function to reset shell options after execution
cleanup() {
  shopt -u dotglob
  shopt -u nullglob
  shopt -u nocaseglob
  unset GLOBIGNORE
}

# Function to convert VOB files to high-quality MP4 using H.264
convert_vob_to_mp4() {
  local file="$1"
  local output_directory="./done"
  mkdir -p "$output_directory"  # Ensure the 'done' directory exists
  
  # Get the base name of the file (e.g., VTS_01_0.VOB -> VTS_01_0.mp4)
  local output_file="$output_directory/$(basename "${file%.VOB}.mp4")"
  
  echo "Converting $file to $output_file"
  
  # ffmpeg command for converting VOB to MP4
  ffmpeg -fflags +genpts -y -i "$file" -c:v libx264 -preset slow -crf 18 -c:a aac -b:a 256k -ac 2 -movflags +faststart "$output_file"
  
  if [[ $? -ne 0 ]]; then
    echo "Error processing $file"
  else
    echo "Successfully processed $file"
  fi
}

# Main script loop
initialize

# Find all .vob files, excluding the "done" directory
echo "Searching for .vob files (excluding 'done' directory)..."

# Corrected find command to skip "done" directory and search for .vob files
find . -path ./done -prune -o -type f -iname "*.vob" -print | while read -r file; do
  echo "Found VOB file: $file"
  convert_vob_to_mp4 "$file"
done

cleanup
