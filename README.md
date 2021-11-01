# Patina User Components

Additional components for other use-cases.

## Table of Contents

- [Built-in Commands](#built-in-commands)
  - [Minecraft](#minecraft)
  - [Terminal Calibration](#terminal-calibration)
  - [YouTube-DL](#youtube-dl)

## Built-in Commands

### Minecraft

This component will download the Linux Minecraft launcher archive, extract the
contents, and build a read-only and mountable disk image.

```bash
p-minecraft  # Create an ISO disk image of the latest Minecraft Launcher.
```

### Terminal Calibration

```bash
p-calibrate <X> <Y>  # Draw a grid on the Terminal to help resize window.
```

### YouTube-DL

This command will download either video or audio depending on use.

```bash
p-yt-dl mp3 <URL>  # Download an MP3 audio file from a URL.
p-yt-dl mp4 <URL>  # Download an MP4 video file from a URL.
```

### yt-dlp

This command will download a video from a given URL.

```bash
p-yt-dlp best <URL>  # Download a video file in best detected format.
```
