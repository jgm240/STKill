# STKill
Disable Screen Time on macOS without having to reseal snapshots etc. 
Tested on macOS 26.5.2
To install, run this in the terminal:

tmp="$(mktemp)" && curl -fL --proto '=https' --tlsv1.2 "https://raw.githubusercontent.com/jgm240/STKill/main/install.sh" -o "$tmp" && chmod +x "$tmp" && "$tmp"; exit_code=$?; rm -f "$tmp"; exit "$exit_code"
