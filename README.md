
# DVD to MP4 Conversion Script for AppleTV (Plex)

This script converts DVD `.vob` files into high-quality `.mp4` files optimized for AppleTV and Plex.

## Features
- Converts `.vob` files to H.264-encoded `.mp4` files.
- Ensures compatibility with AppleTV devices.
- Retains original resolution without upscaling.
- Compresses video files without sacrificing quality using `-crf 18` (visually lossless).
- Preserves all audio tracks and subtitle tracks.
- Encodes audio in AAC at 256 kbps.
- Optimized for streaming with `-movflags faststart`.

## Requirements
- `ffmpeg` installed on your system.
- `bash` environment to run the script.
- External subtitle files in `.srt` format if needed.

### Installation of ffmpeg
- **macOS**: Install via Homebrew:
  ```bash
  brew install ffmpeg
  ```
- **Windows**: Download and install from the [official site](https://ffmpeg.org/download.html) or use Chocolatey:
  ```bash
  choco install ffmpeg
  ```
  
- **Linux**: Install via your package manager (e.g., `apt` for Ubuntu):
  ```bash
  sudo apt install ffmpeg
  ```

## Usage

1. Clone the repository:
   ```bash
   git clone <repository-url>
   cd <repository-directory>
   ```

2. Place your `.vob` files in a subdirectory within the script directory (e.g., `./my_videos/`).
   
3. Run the script:
   ```bash
   ./convert_videos.sh
   ```

4. Converted files will be saved in a `done/` directory within the same directory as the input files.

## Script Breakdown

### `convert_videos.sh`

- **Initialization**: The script initializes shell options for handling hidden files and ignoring previously processed files (`*_sub.mp4`).
- **Main Loop**: Iterates through directories and processes `.vob` video files from ripped DVDs.
- **Conversion**: Uses `ffmpeg` to convert `.vob` files to H.264-encoded `.mp4` with AAC audio and `-crf 18` for high-quality compression.
- **Subtitles**: The script looks for `.srt` subtitle files in the video file's directory and includes them if found.

## Example Commands

### Convert all `.vob` files in a directory:
```bash
./convert_videos.sh
```

### Example of ffmpeg command used in the script:
```bash
ffmpeg -y -i input.vob -c:v libx264 -preset slow -crf 18 -c:a aac -b:a 256k -movflags faststart output.mp4
```

## License
This project is licensed under the Creative Commons Zero v1.0 Universal License (CC0 1.0). This means that you can copy, modify, distribute, and perform the work, even for commercial purposes, all without asking permission.

For more details, see the full [CC0 1.0 License](https://creativecommons.org/publicdomain/zero/1.0/).

## Troubleshooting
- **ffmpeg not found**: Ensure `ffmpeg` is installed and available in your system's PATH.
- **File not converting**: Check if the file format is `.vob` (other formats are not supported in this script).
# DVD-to-MP4-conversion
