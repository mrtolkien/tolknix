#!/bin/bash

set -eo pipefail

resolve_home() {
    if [ -n "${HOME:-}" ]; then
        printf '%s\n' "$HOME"
        return 0
    fi

    getent passwd "$(id -un)" | cut -d: -f6
}

REAL_HOME="$(resolve_home)"
if [ -z "$REAL_HOME" ]; then
    notify-send "Screenshot failed" "Could not determine home directory" -a "Hyprland"
    exit 1
fi

LOG_FILE="/tmp/hyprshot_menu.log"
{
    printf '=== %s ===\n' "$(date -Is)"
    printf 'USER=%s\n' "${USER:-}"
    printf 'HOME=%s\n' "${HOME:-}"
    printf 'REAL_HOME=%s\n' "$REAL_HOME"
    printf 'PATH=%s\n' "${PATH:-}"
} >> "$LOG_FILE"

# Define the screenshot directory
SS_DIR="$REAL_HOME/Pictures/Screenshots"
# Ensure the directory exists
mkdir -p "$SS_DIR"

# Hyprland keybinds may run with a reduced PATH. Resolve hyprshot explicitly so
# Nix profile installs keep working even if ~/.nix-profile/bin is missing there.
PATH="$REAL_HOME/.nix-profile/bin:$REAL_HOME/.local/bin:${PATH:-/usr/bin:/bin}"

HYPRSHOT_BIN="${HYPRSHOT_BIN:-}"
if [ -z "$HYPRSHOT_BIN" ]; then
    HYPRSHOT_BIN="$(command -v hyprshot || true)"
fi
if [ -z "$HYPRSHOT_BIN" ] && [ -x "$REAL_HOME/.nix-profile/bin/hyprshot" ]; then
    HYPRSHOT_BIN="$REAL_HOME/.nix-profile/bin/hyprshot"
fi
if [ -z "$HYPRSHOT_BIN" ]; then
    printf 'hyprshot not found\n' >> "$LOG_FILE"
    notify-send "Screenshot failed" "hyprshot is not available in PATH" -a "Hyprland"
    exit 127
fi

printf 'HYPRSHOT_BIN=%s\n' "$HYPRSHOT_BIN" >> "$LOG_FILE"

# Define the menu options for vicinae
MENU_OPTIONS="Region\nActive Window\nSelect Window\nFull Screen\nRegion (Copy Only)"
MENU_SETTLE_DELAY_SECONDS="${MENU_SETTLE_DELAY_SECONDS:-0.2}"

pick_choice() {
    if command -v wofi >/dev/null 2>&1; then
        printf 'MENU_BACKEND=wofi\n' >> "$LOG_FILE"
        printf '%b\n' "$MENU_OPTIONS" | wofi --dmenu --prompt "Screenshot:"
        return $?
    fi

    printf 'MENU_BACKEND=vicinae\n' >> "$LOG_FILE"
    printf '%b\n' "$MENU_OPTIONS" | vicinae dmenu --placeholder "Screenshot: "
}

# Capture both stdout and status explicitly instead of letting `set -e` abort.
CHOICE="${TEST_CHOICE:-}"
USED_MENU_PICKER=0
if [ -z "$CHOICE" ]; then
    set +e
    CHOICE="$(pick_choice)"
    PICKER_STATUS=$?
    set -e
    USED_MENU_PICKER=1
else
    PICKER_STATUS=0
fi

printf 'PICKER_STATUS=%s\n' "$PICKER_STATUS" >> "$LOG_FILE"
printf 'CHOICE=%s\n' "$CHOICE" >> "$LOG_FILE"
printf 'USED_MENU_PICKER=%s\n' "$USED_MENU_PICKER" >> "$LOG_FILE"

# Exit if the user cancels vicinae
if [ -z "$CHOICE" ]; then
    exit 0
fi

# Give the launcher overlay a moment to disappear before the screenshot starts.
if [ "$USED_MENU_PICKER" -eq 1 ] && [ "${MENU_SETTLE_DELAY_SECONDS:-0}" != "0" ]; then
    printf 'MENU_SETTLE_DELAY_SECONDS=%s\n' "$MENU_SETTLE_DELAY_SECONDS" >> "$LOG_FILE"
    sleep "$MENU_SETTLE_DELAY_SECONDS"
fi

# Determine the hyprshot command based on the choice
case "$CHOICE" in
    "Region")
        # Capture a region, copy to clipboard, and save to file
        "$HYPRSHOT_BIN" -o "$SS_DIR" -m region
        ;;
    "Active Window")
        # Capture the currently active window
        "$HYPRSHOT_BIN" -o "$SS_DIR" -m window -m active
        ;;
    "Select Window")
        # Capture a window by selecting it
        "$HYPRSHOT_BIN" -o "$SS_DIR" -m window
        ;;
    "Full Screen")
        # Capture the entire screen
        "$HYPRSHOT_BIN" -o "$SS_DIR" -m output
        ;;
    "Region (Copy Only)")
        # Capture a region and copy only (no file save)
        "$HYPRSHOT_BIN" -o "$SS_DIR" -m region --clipboard-only
        ;;
    *)
        # Default or unhandled case
        printf 'Unhandled choice\n' >> "$LOG_FILE"
        exit 1
        ;;
esac
