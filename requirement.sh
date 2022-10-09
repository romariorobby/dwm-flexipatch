#!/bin/sh
## Font
# - fontawesome
# - Siji
# - nerdfont patched
## Deps
# - xinerama?
# - imlib
# - xcb

case "$DISTRO" in
	"arch") sudo pacman -S imlib2 libxinerama ;;
	"pop") sudo apt libxinerama-dev libxcb-res0-dev libxft-dev libimlib2-dev libx11-xcb-dev ;;
esac
