#!/bin/bash

# Counter to keep track of sequence
counter=0

# Loop through each PNG file sorted by filename
for file in $(ls *.png | sort -n); do
  # Generate a timestamp (you can modify this as per your requirements)
  timestamp=$(date -j -f "%s" "$(( $(date +%s) + counter ))" "+%Y:%m:%d %H:%M:%S")

  echo "Updating $file to $timestamp"

  # Update the metadata of the PNG file
  exiftool -overwrite_original -ExifIFD:DateTimeOriginal="$timestamp" "$file"

  # Increment the counter
  ((counter++))
done
