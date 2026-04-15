# screen2

Simple, minimal, and practical — that’s the goal. There’s little reason to install tools like PuTTY just to perform a quick console or SSH access. This project was born out of that exact frustration.

In day-to-day use, it was common to see people relying on full-featured tools for a very simple task: connecting to a serial console. On macOS (and Linux as well), this can already be done natively with `screen` — but it still requires remembering commands, identifying device names, and typing everything manually.

`screen2` started as a small personal script to remove that friction. The idea is straightforward: automatically list available devices and let you connect with just a few keystrokes. No bloat, no unnecessary dependencies — just a fast and direct way to get the job done.

It was originally built for macOS (my current environment), but it should work just fine on Linux. With some adjustments, it can likely be adapted for Windows too.

## Features

- Automatically detects available `/dev/tty.usb*` serial devices
- Auto-connects when only one device is present
- Prompts for baud rate with a configurable default (9600)
- Clean, readable terminal output

## Requirements

- macOS
- `screen` (pre-installed on macOS)
- A USB-to-serial adapter (e.g., FTDI, CP210x)

## Installation

```bash
# Clone the repository
git clone https://github.com/uofsbr/screen2.git
cd screen2

# Make the script executable
chmod +x screen2.sh

# Create a symlink to make it available system-wide
ln -s "$(pwd)/screen2.sh" /usr/local/bin/screen2
```

## Usage

```bash
screen2
```

You will be prompted to select a device and confirm the baud rate:

```
  ┌─────────────────────────────────┐
  │   Console Connect  (screen)     │
  └─────────────────────────────────┘

  Available devices:

  [1]  /dev/tty.usbserial-A97L45W0
  [2]  /dev/tty.usbserial-B12C33X1

  Select a device [1-2]: 1

  Baud rate [9600]:

  Connecting...
  screen /dev/tty.usbserial-A97L45W0 9600

  (To exit screen: Ctrl+A → K → Y)
```

### Exiting a session

To disconnect from the serial console, press:

```
Ctrl+A  then  K  then  Y
```

## Supported Devices

Any USB-to-serial adapter that creates a `/dev/tty.usb*` or `/dev/tty.usbserial*` device node, including:

- FTDI (FT232R, FT231X)
- Silicon Labs CP210x
- Prolific PL2303

## License

MIT License. See [LICENSE](LICENSE) for details.
