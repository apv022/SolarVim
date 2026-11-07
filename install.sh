#!/usr/bin/env bash
set -euo pipefail
d="${XDG_CONFIG_HOME:-$HOME/.config}/solarvim"
mkdir -p "$d"
cp -r init.lua colors "$d/"
echo "solarvim installed to $d. Run: NVIM_APPNAME=solarvim nvim"
