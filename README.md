# ☀ solarvim

A minimal, warm Neovim config. Zero plugins, built-in LSP, crimson sunset colors.

Needs Neovim 0.11+.

## Install

```sh
./install.sh
NVIM_APPNAME=solarvim nvim
```

It installs to `~/.config/solarvim`, so it sits alongside your normal Neovim config rather than replacing it.

## What's in it

- **Crimson sunset theme**: dark by default, with a light "rose dawn" variant (`Space tb` toggles).
- **LSP with no plugins**: Lua, Python (pyright or pylsp), C/C++, R, JS/TS, HTML, CSS, and Bash. Each server only turns on if it's installed.
- **Completion, hover docs, and signature help** as you type.
- **Auto-closing brackets and quotes.**
- **Folder tree** using the built-in netrw.
- **Markdown preview** in the browser (needs Python's `markdown` package).
- **PDFs** open as text, or in Zathura with `:View`.

## Keys

`Space` is the leader key.

| Key | Action |
| --- | --- |
| `Space w` / `Space q` | save / quit |
| `Space e` | folder tree |
| `Space f` | find file |
| `Space b` | switch buffer |
| `Space d` | show diagnostic |
| `Space ca` | code action / quick fix |
| `Space cf` | format |
| `Space tb` | toggle light/dark |
| `Space mp` | markdown preview |
| `Space pv` | open PDF in Zathura |
| `Space h` | Neovim tutorial |
| `gd` / `K` | go to definition / hover |
| `grn` / `grr` | rename / references |
| `Ctrl+h/j/k/l` | move between windows |
