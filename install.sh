#!/bin/sh
# solarvim installer. Idempotent. Links ~/.config/solarvim to this checkout
# when it is a permanent clone, otherwise copies. Never deletes your config:
# an existing real directory is moved to ~/.config-backup/<timestamp>/.
set -eu
src=$(CDPATH='' cd -- "$(dirname -- "$0")" && pwd)
cfg=${XDG_CONFIG_HOME:-$HOME/.config}
dst=$cfg/solarvim
mkdir -p "$cfg"
if [ -L "$dst" ] && [ "$(readlink -f "$dst")" = "$src" ]; then
	echo "solarvim: already linked ($dst -> $src)"
else
	if [ -e "$dst" ] && [ ! -L "$dst" ]; then
		b=$HOME/.config-backup/$(date +%Y%m%d-%H%M%S)
		mkdir -p "$b" && mv "$dst" "$b/solarvim"
		echo "solarvim: backed up old config to $b/solarvim"
	fi
	case $src in
	/tmp/* | /var/tmp/*) rm -f "$dst"; mkdir -p "$dst"; cp -R "$src/init.lua" "$src/colors" "$dst/" ;;
	*) ln -sfn "$src" "$dst" ;;
	esac
	echo "solarvim: installed to $dst"
fi
command -v nvim >/dev/null 2>&1 || echo "solarvim: needs neovim 0.11+ (sudo pacman -S neovim)"
echo "run: NVIM_APPNAME=solarvim nvim     (Space ? for keys)"
