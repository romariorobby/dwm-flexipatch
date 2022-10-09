#!/bin/sh

case "$DISTRO" in
	"pop") 
		bitwardencmd="bitwarden"
		dragoncmd="Dragon"
		termcmd="kitty"
		;;
	"arch")
		bitwardencmd="bitwarden-desktop"
		dragoncmd="Dragon-drop"
		termcmd="kitty"
		;;
esac

defchange(){
	# sed -Ei "s/^(#define BITWARDEN).*/\1 \"$bitwardencmd\"/" config.def.h && echo "[config] Changed BITWARDEN -> $bitwardencmd"
	sed -Ei "s/^(#define $1).*/\1 \"$2\"/" config.def.h && echo "[config] changed $1 -> $2"
}
defchange "BITWARDEN" "$bitwardencmd"
defchange "DRAGONC" "$dragoncmd"
# defchange "TERM" "$termcmd"
