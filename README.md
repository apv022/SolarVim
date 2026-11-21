# ☀ solarvim

A warm, feature-rich Neovim config in **one file** with **zero plugins**. Everything is built-in Neovim 0.11+.

```sh
git clone https://github.com/apv022/SolarVim ~/.local/share/solarvim
~/.local/share/solarvim/install.sh
NVIM_APPNAME=solarvim nvim
```

On a Rayconfig desktop this is already installed, `nvim` already means solarvim, and the colors come from the desktop palette.

## What you get (no plugins)

| feature | how it is built |
|---|---|
| fuzzy file finder | `:find` + `findfunc` + `matchfuzzy` (uses `rg`/`git` if present) |
| project search | `:grep` with ripgrep → quickfix list |
| buffers / recent files | `vim.ui.select` |
| statusline with mode, git branch, diagnostics, LSP | `%!v:lua` |
| floating terminal | `nvim_open_win` + `:terminal` |
| LSP for Lua, C/C++, Rust, Go, Python, JS/TS, HTML, CSS, Bash, R | `vim.lsp.config`; each turns on only if installed |
| completion, signature help, symbol highlight | `vim.lsp.completion` |
| treesitter highlight + folds | `vim.treesitter.start` |
| auto-pairs, trim whitespace on save, restore cursor | autocmds |
| undo history picker | `undotree()` |
| commenting | built-in `gc` |
| markdown preview, PDF as text | python-markdown / pdftotext |

## Keys

`Space ?` (or `:Keys`) opens the cheat sheet. It is generated from the same table that creates the mappings, so it can't go stale. From a shell: `ray keys vim`.

Per-machine tweaks go in `~/.config/solarvim/local.lua` (gitignored).
