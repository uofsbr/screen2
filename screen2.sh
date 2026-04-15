#!/usr/bin/env bash
# screen2: serial console helper
# Usage: screen2

set -euo pipefail

# ── Colors ────────────────────────────────────────────────────────────────────
BOLD='\033[1m'
CYAN='\033[0;36m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
RESET='\033[0m'

DEFAULT_BAUD=9600

# ── Banner ────────────────────────────────────────────────────────────────────
echo ""
echo -e "${CYAN}${BOLD}  ┌─────────────────────────────────┐"
echo -e "  │   Console Connect  (screen)     │"
echo -e "  └─────────────────────────────────┘${RESET}"
echo ""

# ── Find available serial tty devices ────────────────────────────────────────
mapfile -t DEVICES < <(ls /dev/tty.usb* /dev/tty.usbserial* 2>/dev/null | sort -u)

if [[ ${#DEVICES[@]} -eq 0 ]]; then
  echo -e "${RED}  No serial devices found at /dev/tty.usb*${RESET}"
  echo -e "  Make sure the USB cable is connected.\n"
  exit 1
fi

# ── List devices ──────────────────────────────────────────────────────────────
echo -e "${BOLD}  Available devices:${RESET}\n"
for i in "${!DEVICES[@]}"; do
  printf "  ${GREEN}[%d]${RESET}  %s\n" $((i + 1)) "${DEVICES[$i]}"
done
echo ""

# ── Device selection ──────────────────────────────────────────────────────────
if [[ ${#DEVICES[@]} -eq 1 ]]; then
  SELECTED_DEV="${DEVICES[0]}"
  echo -e "  Only one device available, using it automatically.\n"
else
  while true; do
    read -rp "  Select a device [1-${#DEVICES[@]}]: " CHOICE
    if [[ "$CHOICE" =~ ^[0-9]+$ ]] && (( CHOICE >= 1 && CHOICE <= ${#DEVICES[@]} )); then
      SELECTED_DEV="${DEVICES[$((CHOICE - 1))]}"
      break
    fi
    echo -e "  ${RED}Invalid option. Enter a number between 1 and ${#DEVICES[@]}.${RESET}"
  done
fi

# ── Baud rate ─────────────────────────────────────────────────────────────────
read -rp "  Baud rate [${DEFAULT_BAUD}]: " BAUD_INPUT
BAUD="${BAUD_INPUT:-$DEFAULT_BAUD}"

if ! [[ "$BAUD" =~ ^[0-9]+$ ]]; then
  echo -e "  ${RED}Invalid baud rate: '${BAUD}'${RESET}"
  exit 1
fi

# ── Confirm and connect ───────────────────────────────────────────────────────
echo ""
echo -e "  ${BOLD}Connecting...${RESET}"
echo -e "  ${YELLOW}screen ${SELECTED_DEV} ${BAUD}${RESET}"
echo ""
echo -e "  ${CYAN}(To exit screen: Ctrl+A → K → Y)${RESET}"
echo ""

exec screen "$SELECTED_DEV" "$BAUD"
