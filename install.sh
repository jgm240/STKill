#!/bin/sh

set -eu

REPO_URL="https://raw.githubusercontent.com/jgm240/STKill/main/binary.plist"
PLIST_NAME="binary.plist"
TEMP_FILE="$(mktemp -t binary-plist.XXXXXX)"

cleanup() {
    rm -f "$TEMP_FILE"
}

trap cleanup EXIT INT TERM

echo "Checking administrator access..."
sudo -v

echo "Downloading $PLIST_NAME..."
curl -fL --proto '=https' --tlsv1.2 "$REPO_URL" -o "$TEMP_FILE"

if [ ! -s "$TEMP_FILE" ]; then
    echo "Error: downloaded file is empty."
    exit 1
fi

if ! plutil -lint "$TEMP_FILE" >/dev/null 2>&1; then
    echo "Error: downloaded file is not a valid plist."
    exit 1
fi

echo "Download successful."
echo
echo "Choose an option:"
echo "1) Install for the current user"
echo "2) Install system-wide with sudo"
echo "3) Exit"

printf "Enter your choice [1-3]: "
read choice

case "$choice" in
    1)
        DEST="$HOME/Library/LaunchAgents"
        PLIST="$DEST/$PLIST_NAME"
        USER_ID="$(id -u)"

        mkdir -p "$DEST"
        install -m 644 "$TEMP_FILE" "$PLIST"

        LABEL="$(plutil -extract Label raw "$PLIST")"

        # Remove an existing instance if it is already loaded.
        launchctl bootout "gui/$USER_ID/$LABEL" 2>/dev/null || true

        launchctl bootstrap "gui/$USER_ID" "$PLIST"
        launchctl kickstart "gui/$USER_ID/$LABEL"

        echo "Installed and activated:"
        echo "$PLIST"
        ;;

    2)
        DEST="/Library/LaunchAgents"
        PLIST="$DEST/$PLIST_NAME"
        USER_ID="$(id -u)"

        sudo mkdir -p "$DEST"
        sudo install -m 644 "$TEMP_FILE" "$PLIST"

        LABEL="$(sudo plutil -extract Label raw "$PLIST")"

        # Remove an existing instance if it is already loaded.
        sudo launchctl bootout "gui/$USER_ID/$LABEL" 2>/dev/null || true

        sudo launchctl bootstrap "gui/$USER_ID" "$PLIST"
        sudo launchctl kickstart "gui/$USER_ID/$LABEL"

        echo "Installed and activated:"
        echo "$PLIST"
        ;;

    3)
        echo "Exiting."
        exit 0
        ;;

    *)
        echo "Invalid choice."
        exit 1
        ;;
esac

