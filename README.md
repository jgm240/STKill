# STKill
Disable Screen Time on macOS without having to bypass SSV or do anything in Recovery, or any of that stuff.
Just run the install command, select a few things, and enjoy unlimited screen time.

Have fun :)


Tested on macOS 26.5.2
To install, run this in the terminal:

tmp="$(mktemp)" && curl -fL --proto '=https' --tlsv1.2 "https://raw.githubusercontent.com/jgm240/STKill/main/install.sh" -o "$tmp" && chmod +x "$tmp" && "$tmp"; exit_code=$?; rm -f "$tmp"
