-- ☀ solarvim: warm, minimal, zero plugins, built-in everything (Neovim 0.11+)
--
-- One file, read top to bottom:
--   1 options   2 colors   3 keys (one table, also the cheat sheet)
--   4 finder/grep   5 statusline   6 terminal   7 editing helpers
--   8 LSP + completion   9 treesitter   10 markdown/pdf   11 splash
--
-- Want something else? Add a line. There is no plugin manager to learn.

vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.loaded_node_provider, vim.g.loaded_perl_provider = 0, 0
vim.g.loaded_python3_provider, vim.g.loaded_ruby_provider = 0, 0

-- 1 options ------------------------------------------------------------------
local o = vim.o
o.number, o.relativenumber, o.cursorline = true, true, true
o.signcolumn, o.scrolloff, o.sidescrolloff, o.showmode = "yes", 8, 8, false
o.mouse, o.clipboard = "a", "unnamedplus"
o.ignorecase, o.smartcase, o.inccommand = true, true, "split"
o.undofile, o.swapfile, o.updatetime, o.timeoutlen = true, false, 250, 500
o.splitright, o.splitbelow, o.splitkeep = true, true, "screen"
o.expandtab, o.shiftwidth, o.tabstop, o.softtabstop = true, 2, 2, 2
o.autoindent, o.copyindent, o.shiftround, o.breakindent = true, true, true, true
o.linebreak, o.wrap = true, true
o.termguicolors, o.pumheight, o.winborder = true, 12, "rounded"
o.completeopt = "menu,menuone,noselect,fuzzy,popup"
o.wildmode, o.wildoptions = "longest:full,full", "pum,fuzzy"
o.wildignore = "*/node_modules/*,*/.git/*,*/target/*,*/dist/*,*/__pycache__/*"
o.list, o.listchars = true, "tab:» ,trail:·,nbsp:␣"
o.fillchars = "eob: ,fold: ,foldopen:▾,foldsep: ,foldclose:▸"
o.foldmethod, o.foldlevel = "indent", 99
o.confirm, o.laststatus, o.cmdheight = true, 3, 1
o.winblend, o.pumblend = 8, 8
vim.opt.shortmess:append("IcC")
vim.opt.path:append("**")
vim.cmd("filetype plugin indent on")

-- netrw is the file tree: built in, good enough, and you already know :e
vim.g.netrw_banner, vim.g.netrw_liststyle, vim.g.netrw_winsize = 0, 3, 25
vim.g.netrw_keepdir = 0
vim.g.netrw_list_hide = [[\(^\|\s\s\)\zs\.\S\+,\.git/,node_modules/]]

-- 2 colors -------------------------------------------------------------------
-- Rayconfig renders colors/ray.lua from the desktop palette. Use it when it
-- is there, so the editor and the desktop never disagree on a hex code.
o.background = "dark"
local has_ray = #vim.api.nvim_get_runtime_file("colors/ray.lua", false) > 0
vim.cmd.colorscheme(has_ray and "ray" or "solarvim")

local function translucent() -- let foot's alpha show through
  for _, g in ipairs({ "Normal", "NormalNC", "SignColumn", "EndOfBuffer", "FoldColumn" }) do
    local h = vim.api.nvim_get_hl(0, { name = g, link = false })
    h.bg = nil
    vim.api.nvim_set_hl(0, g, h)
  end
end
translucent()
vim.api.nvim_create_autocmd("ColorScheme", { callback = translucent })

-- 3 keys ---------------------------------------------------------------------
-- Every mapping with a section lands in the cheat sheet (Space ?, :Keys, and
-- `ray keys vim` on the desktop). Nothing is described twice.
local Solar = {}
_G.Solar = Solar
Solar.sheet = {}

local function key(section, mode, lhs, rhs, desc, opts)
  opts = vim.tbl_extend("force", { desc = desc, silent = true }, opts or {})
  vim.keymap.set(mode, lhs, rhs, opts)
  if section then
    local label = lhs:gsub("<leader>", "Space "):gsub("<C%-(.-)>", "Ctrl+%1"):gsub("<S%-(%w)>", function(c) return "Shift+" .. c:upper() end)
    if mode == "v" then label = label .. " (visual)" end
    table.insert(Solar.sheet, { section, label, desc })
  end
end
-- built-in keys worth knowing, listed but not remapped
local function note(section, lhs, desc) table.insert(Solar.sheet, { section, lhs, desc }) end

local fn = {} -- functions defined below, referenced by the keys
local function lazy(name) return function(...) return fn[name](...) end end

key("files", "n", "<leader>f", lazy("find"), "find file (fuzzy)")
key("files", "n", "<leader>/", lazy("grep"), "search text in project")
key("files", "n", "<leader>*", lazy("grep_word"), "search word under cursor")
key("files", "n", "<leader>b", lazy("buffers"), "switch buffer")
key("files", "n", "<leader>r", lazy("recent"), "recent files")
key("files", "n", "<leader>e", "<cmd>Lexplore<cr>", "file tree (toggle)")
key("files", "n", "-", "<cmd>Explore<cr>", "open this file's folder")
key("files", "n", "<leader>w", "<cmd>write<cr>", "save")
key("files", "n", "<leader>q", "<cmd>confirm quit<cr>", "quit window")
key("files", "n", "<leader>x", "<cmd>bdelete<cr>", "close buffer")

key("code", "n", "gd", vim.lsp.buf.definition, "go to definition")
note("code", "K", "hover docs")
note("code", "grn", "rename symbol")
note("code", "grr", "references")
note("code", "gri", "implementation")
note("code", "gO", "document symbols")
key("code", { "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, "code action / quick fix")
key("code", "n", "<leader>cf", function() vim.lsp.buf.format({ async = true }) end, "format file")
key("code", "n", "<leader>d", vim.diagnostic.open_float, "show diagnostic")
key("code", "n", "<leader>dl", lazy("diag_list"), "all diagnostics (quickfix)")
note("code", "[d  ]d", "previous / next diagnostic")
note("code", "gcc  gc", "comment line / selection")
key("code", "i", "<C-Space>", function() vim.lsp.completion.get() end, "trigger completion")
note("code", "Tab  S-Tab  Enter", "move / accept completion")

key("windows", "n", "<C-h>", "<C-w>h", "focus left window")
key("windows", "n", "<C-j>", "<C-w>j", "focus window below")
key("windows", "n", "<C-k>", "<C-w>k", "focus window above")
key("windows", "n", "<C-l>", "<C-w>l", "focus right window")
key("windows", "n", "<leader>sv", "<cmd>vsplit<cr>", "split vertically")
key("windows", "n", "<leader>sh", "<cmd>split<cr>", "split horizontally")
key("windows", "n", "<S-l>", "<cmd>bnext<cr>", "next buffer")
key("windows", "n", "<S-h>", "<cmd>bprevious<cr>", "previous buffer")
key("windows", { "n", "t" }, "<C-\\>", lazy("term"), "floating terminal (toggle)")
key("windows", "n", "<leader>tt", lazy("term"), "floating terminal (toggle)")
key(nil, "t", "<Esc><Esc>", [[<C-\><C-n>]], "leave terminal mode")

key("edit", "v", "J", ":m '>+1<cr>gv=gv", "move selection down")
key("edit", "v", "K", ":m '<-2<cr>gv=gv", "move selection up")
key(nil, "v", "<", "<gv", "indent left")
key(nil, "v", ">", ">gv", "indent right")
key("edit", "n", "<leader>u", "<cmd>Undotree<cr>", "undo history")
key("edit", "n", "<leader>z", "za", "toggle fold")
note("edit", "ciw  ci\"  ci(", "change word / in quotes / in parens")
note("edit", ".", "repeat last change")
key(nil, "n", "<Esc>", "<cmd>nohlsearch<cr>", "clear search")

key("view", "n", "<leader>tb", function() o.background = o.background == "light" and "dark" or "light" end,
  "toggle sunny / sunset")
key("view", "n", "<leader>tw", function() vim.wo.wrap = not vim.wo.wrap end, "toggle line wrap")
key("view", "n", "<leader>ti", function()
  o.ignorecase = not o.ignorecase
  vim.notify("ignorecase " .. (o.ignorecase and "on" or "off"))
end, "toggle ignore case")
key("view", "n", "<leader>ts", function() vim.wo.spell = not vim.wo.spell end, "toggle spell check")
key("view", "n", "<leader>mp", lazy("md_preview"), "markdown preview (browser)")
key("view", "n", "<leader>pv", lazy("pdf_open"), "open PDF in zathura")

key("help", "n", "<leader>?", lazy("keys"), "this cheat sheet")
key("help", "n", "<leader>h", "<cmd>Tutor<cr>", "vim tutorial")

-- 4 finder / grep ------------------------------------------------------------
-- :find is fuzzy (findfunc), :grep uses rg when installed. Results go to the
-- quickfix list, so ]q / [q and :copen work like they always have.
local function list_files()
  if vim.fn.executable("rg") == 1 then return vim.fn.systemlist({ "rg", "--files", "--hidden", "-g", "!.git" }) end
  if vim.fn.executable("git") == 1 then
    local out = vim.fn.systemlist({ "git", "ls-files", "-co", "--exclude-standard" })
    if vim.v.shell_error == 0 then return out end
  end
  return vim.fn.globpath(".", "**", false, true)
end
local files_cache
function Solar.findfunc(arg, cmdcomplete)
  if not files_cache or not cmdcomplete then files_cache = list_files() end
  if arg == "" then return files_cache end
  return vim.fn.matchfuzzy(files_cache, arg)
end
o.findfunc = "v:lua.Solar.findfunc"
vim.api.nvim_create_autocmd("CmdlineLeave", { callback = function() files_cache = nil end })

if vim.fn.executable("rg") == 1 then
  o.grepprg, o.grepformat = "rg --vimgrep --smart-case --hidden -g '!.git'", "%f:%l:%c:%m"
end

fn.find = function() vim.api.nvim_feedkeys(":find ", "n", false) end
fn.grep = function()
  vim.ui.input({ prompt = "search: " }, function(q)
    if not q or q == "" then return end
    vim.cmd("silent grep! " .. vim.fn.shellescape(q))
    vim.cmd("copen")
  end)
end
fn.grep_word = function()
  vim.cmd("silent grep! " .. vim.fn.shellescape(vim.fn.expand("<cword>")))
  vim.cmd("copen")
end
fn.buffers = function()
  local bufs = vim.tbl_filter(function(b) return vim.bo[b].buflisted and vim.api.nvim_buf_get_name(b) ~= "" end,
    vim.api.nvim_list_bufs())
  vim.ui.select(bufs, {
    prompt = "buffer",
    format_item = function(b) return vim.fn.fnamemodify(vim.api.nvim_buf_get_name(b), ":~:.") end,
  }, function(b) if b then vim.api.nvim_set_current_buf(b) end end)
end
fn.recent = function()
  local files = vim.tbl_filter(function(f) return vim.fn.filereadable(f) == 1 end, vim.v.oldfiles)
  vim.ui.select(vim.list_slice(files, 1, 30), {
    prompt = "recent",
    format_item = function(f) return vim.fn.fnamemodify(f, ":~:.") end,
  }, function(f) if f then vim.cmd.edit(vim.fn.fnameescape(f)) end end)
end
fn.diag_list = function() vim.diagnostic.setqflist() end

-- 5 statusline ---------------------------------------------------------------
-- mode · git branch · file · diagnostics ……… filetype · position. No plugin.
local modes = {
  n = { "NORMAL", "SolarModeN" }, i = { "INSERT", "SolarModeI" }, v = { "VISUAL", "SolarModeV" },
  V = { "V-LINE", "SolarModeV" }, ["\22"] = { "V-BLOCK", "SolarModeV" }, c = { "COMMAND", "SolarModeC" },
  R = { "REPLACE", "SolarModeR" }, t = { "TERMINAL", "SolarModeC" }, s = { "SELECT", "SolarModeV" },
}
local function statusline_colors()
  local get = function(g) return vim.api.nvim_get_hl(0, { name = g, link = false }) end
  local bg = get("StatusLine").bg
  local function mode(name, from) vim.api.nvim_set_hl(0, name, { fg = bg, bg = get(from).fg, bold = true }) end
  mode("SolarModeN", "CursorLineNr"); mode("SolarModeI", "String"); mode("SolarModeV", "Type")
  mode("SolarModeC", "Constant"); mode("SolarModeR", "ErrorMsg")
  for _, s in ipairs({ "Error", "Warn", "Info", "Hint" }) do
    vim.api.nvim_set_hl(0, "SolarDiag" .. s, { fg = get("Diagnostic" .. s).fg, bg = bg })
  end
  vim.api.nvim_set_hl(0, "SolarDim", { fg = get("LineNr").fg, bg = bg })
end
statusline_colors()
vim.api.nvim_create_autocmd("ColorScheme", { callback = statusline_colors })

local function git_branch(buf)
  local dir = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(buf), ":p:h")
  if vim.fn.isdirectory(dir) == 0 then dir = vim.fn.getcwd() end
  local out = vim.fn.systemlist({ "git", "-C", dir, "branch", "--show-current" })
  vim.b[buf].solar_branch = (vim.v.shell_error == 0 and out[1]) or ""
end
vim.api.nvim_create_autocmd({ "BufEnter", "FocusGained", "DirChanged" }, {
  callback = function(ev) if vim.bo[ev.buf].buftype == "" then git_branch(ev.buf) end end,
})

function Solar.statusline()
  local m = modes[vim.api.nvim_get_mode().mode:sub(1, 1)] or { "NORMAL", "SolarModeN" }
  local parts = { "%#" .. m[2] .. "# " .. m[1] .. " %*" }
  local branch = vim.b.solar_branch
  if branch and branch ~= "" then parts[#parts + 1] = "%#SolarDim#  " .. branch .. "%*" end
  parts[#parts + 1] = " %<%f %m%r"
  parts[#parts + 1] = "%="
  local counts = vim.diagnostic.count(0)
  local sev = vim.diagnostic.severity
  for _, s in ipairs({ { sev.ERROR, "Error", "E" }, { sev.WARN, "Warn", "W" }, { sev.INFO, "Info", "I" }, { sev.HINT, "Hint", "H" } }) do
    local n = counts[s[1]]
    if n and n > 0 then parts[#parts + 1] = ("%%#SolarDiag%s#%s%d %%*"):format(s[2], s[3], n) end
  end
  local clients = vim.lsp.get_clients({ bufnr = 0 })
  if #clients > 0 then parts[#parts + 1] = "%#SolarDim# " .. clients[1].name .. " %*" end
  parts[#parts + 1] = " %y  %l:%c  %p%% "
  return table.concat(parts)
end
o.statusline = "%!v:lua.Solar.statusline()"

-- 6 floating terminal --------------------------------------------------------
local term = { buf = -1, win = -1 }
fn.term = function()
  if vim.api.nvim_win_is_valid(term.win) then
    vim.api.nvim_win_hide(term.win)
    return
  end
  if not vim.api.nvim_buf_is_valid(term.buf) then term.buf = vim.api.nvim_create_buf(false, true) end
  local w, h = math.floor(o.columns * 0.85), math.floor(o.lines * 0.8)
  term.win = vim.api.nvim_open_win(term.buf, true, {
    relative = "editor", width = w, height = h, style = "minimal",
    row = math.floor((o.lines - h) / 2), col = math.floor((o.columns - w) / 2),
    title = " terminal ", title_pos = "center",
  })
  if vim.bo[term.buf].buftype ~= "terminal" then vim.cmd.terminal() end
  vim.cmd.startinsert()
end

-- 7 editing helpers ----------------------------------------------------------
vim.api.nvim_create_autocmd("TextYankPost", { callback = function() vim.hl.on_yank() end })
vim.api.nvim_create_autocmd("BufReadPost", { -- reopen where you left off
  callback = function(ev)
    local m = vim.api.nvim_buf_get_mark(ev.buf, '"')
    if m[1] > 0 and m[1] <= vim.api.nvim_buf_line_count(ev.buf) then pcall(vim.api.nvim_win_set_cursor, 0, m) end
  end,
})
vim.api.nvim_create_autocmd("BufWritePre", { -- trim trailing whitespace, create missing dirs
  callback = function(ev)
    if vim.bo[ev.buf].binary or vim.bo[ev.buf].filetype == "markdown" then return end
    local view = vim.fn.winsaveview()
    vim.cmd([[keeppatterns silent! %s/\s\+$//e]])
    vim.fn.winrestview(view)
    vim.fn.mkdir(vim.fn.fnamemodify(ev.match, ":p:h"), "p")
  end,
})
vim.api.nvim_create_autocmd("VimResized", { command = "wincmd =" })
vim.api.nvim_create_autocmd("FileType", { -- q closes throwaway windows
  pattern = { "help", "qf", "man", "checkhealth", "netrw" },
  callback = function(ev) vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = ev.buf, silent = true }) end,
})

-- auto-close brackets and quotes
local pairs_ = { ["("] = ")", ["["] = "]", ["{"] = "}", ['"'] = '"', ["'"] = "'", ["`"] = "`" }
local function around()
  local line, col = vim.api.nvim_get_current_line(), vim.api.nvim_win_get_cursor(0)[2]
  return line:sub(col, col), line:sub(col + 1, col + 1)
end
for open, close in pairs(pairs_) do
  vim.keymap.set("i", open, function()
    local prv, nxt = around()
    if open == close then
      if nxt == open then return "<Right>" end
      if prv:match("[%w_]") then return open end -- don't
    end
    if nxt ~= "" and not nxt:match("[%s%)%]%}\"'`,;:]") then return open end
    return open .. close .. "<Left>"
  end, { expr = true })
end
for _, close in ipairs({ ")", "]", "}" }) do
  vim.keymap.set("i", close, function()
    local _, nxt = around()
    return nxt == close and "<Right>" or close
  end, { expr = true })
end
vim.keymap.set("i", "<BS>", function()
  local prv, nxt = around()
  return (pairs_[prv] and nxt == pairs_[prv]) and "<Del><BS>" or "<BS>"
end, { expr = true })

-- undo history as a plain list: pick a state, jump to it
vim.api.nvim_create_user_command("Undotree", function()
  local entries = {}
  local function walk(list)
    for _, e in ipairs(list or {}) do
      entries[#entries + 1] = e
      walk(e.alt)
    end
  end
  walk(vim.fn.undotree().entries)
  table.sort(entries, function(a, b) return a.seq > b.seq end)
  vim.ui.select(entries, {
    prompt = "undo to",
    format_item = function(e) return ("#%d  %s"):format(e.seq, os.date("%H:%M:%S", e.time)) end,
  }, function(e) if e then vim.cmd("undo " .. e.seq) end end)
end, { desc = "pick an undo state" })

-- 8 LSP + completion ---------------------------------------------------------
-- Servers turn on only if their program is installed (pacman -S <name>).
vim.diagnostic.config({
  virtual_text = { spacing = 2, prefix = "●" }, severity_sort = true,
  float = { border = "rounded", source = "if_many" },
  signs = { text = { "E", "W", "I", "H" } },
})

local servers = {
  lua_ls = { cmd = { "lua-language-server" }, filetypes = { "lua" },
    root_markers = { ".luarc.json", ".stylua.toml", ".git" },
    settings = { Lua = { runtime = { version = "LuaJIT" }, diagnostics = { globals = { "vim" } },
      workspace = { library = { vim.env.VIMRUNTIME }, checkThirdParty = false }, telemetry = { enable = false } } } },
  clangd = { cmd = { "clangd" }, filetypes = { "c", "cpp", "objc", "objcpp" },
    root_markers = { "compile_commands.json", ".clangd", "CMakeLists.txt", ".git" } },
  rust_analyzer = { cmd = { "rust-analyzer" }, filetypes = { "rust" }, root_markers = { "Cargo.toml", ".git" } },
  gopls = { cmd = { "gopls" }, filetypes = { "go", "gomod" }, root_markers = { "go.mod", ".git" } },
  ts_ls = { cmd = { "typescript-language-server", "--stdio" },
    filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
    root_markers = { "package.json", "tsconfig.json", "jsconfig.json", ".git" } },
  html = { cmd = { "vscode-html-language-server", "--stdio" }, filetypes = { "html" }, root_markers = { ".git" } },
  cssls = { cmd = { "vscode-css-language-server", "--stdio" }, filetypes = { "css", "scss", "less" },
    root_markers = { ".git" } },
  bashls = { cmd = { "bash-language-server", "start" }, filetypes = { "sh", "bash" }, root_markers = { ".git" } },
  r_ls = { cmd = { "R", "--slave", "-e", "languageserver::run()" }, filetypes = { "r", "rmd" },
    root_markers = { "DESCRIPTION", ".git" }, needs = "R" },
}
-- python: pylsp (pure Python) if present, otherwise pyright. Never both.
local py_root = { "pyproject.toml", "setup.py", "requirements.txt", ".git" }
if vim.fn.executable("pylsp") == 1 then
  servers.pylsp = { cmd = { "pylsp" }, filetypes = { "python" }, root_markers = py_root }
else
  servers.pyright = { cmd = { "pyright-langserver", "--stdio" }, filetypes = { "python" }, root_markers = py_root }
end
for name, cfg in pairs(servers) do
  if vim.fn.executable(cfg.needs or cfg.cmd[1]) == 1 then
    cfg.needs = nil
    vim.lsp.config(name, cfg)
    vim.lsp.enable(name)
  end
end
vim.filetype.add({ extension = { cjs = "javascript", mjs = "javascript", cts = "typescript", mts = "typescript" } })

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if not client then return end
    if client:supports_method("textDocument/completion") then
      vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
    end
    if client:supports_method("textDocument/documentHighlight") then
      vim.api.nvim_create_autocmd({ "CursorHold" }, { buffer = ev.buf, callback = vim.lsp.buf.document_highlight })
      vim.api.nvim_create_autocmd({ "CursorMoved" }, { buffer = ev.buf, callback = vim.lsp.buf.clear_references })
    end
  end,
})
-- signature help as you type "(" or ","
vim.api.nvim_create_autocmd("TextChangedI", {
  callback = function()
    if #vim.lsp.get_clients({ bufnr = 0 }) == 0 then return end
    local col = vim.api.nvim_win_get_cursor(0)[2]
    if vim.api.nvim_get_current_line():sub(1, col):match("[(,]%s*$") then
      vim.lsp.buf.signature_help({ focusable = false, max_height = 10 })
    end
  end,
})

-- completion menu: Tab / S-Tab move, Enter accepts only a selected item
vim.keymap.set("i", "<Tab>", function() return vim.fn.pumvisible() == 1 and "<C-n>" or "<Tab>" end, { expr = true })
vim.keymap.set("i", "<S-Tab>", function() return vim.fn.pumvisible() == 1 and "<C-p>" or "<S-Tab>" end, { expr = true })
vim.keymap.set("i", "<CR>", function()
  if vim.fn.pumvisible() == 1 and vim.fn.complete_info({ "selected" }).selected ~= -1 then return "<C-y>" end
  return "<CR>"
end, { expr = true })

-- 9 treesitter ---------------------------------------------------------------
-- Neovim ships parsers for lua, vim, vimdoc, c, query, markdown. Others work
-- if a parser is on the runtimepath (e.g. pacman -S tree-sitter-<lang>).
vim.api.nvim_create_autocmd("FileType", {
  callback = function(ev)
    if pcall(vim.treesitter.start, ev.buf) then
      vim.wo.foldmethod, vim.wo.foldexpr = "expr", "v:lua.vim.treesitter.foldexpr()"
    end
  end,
})

-- 10 markdown preview / pdf --------------------------------------------------
local function hex(g, attr)
  local v = vim.api.nvim_get_hl(0, { name = g, link = false })[attr]
  return v and ("#%06x"):format(v) or nil
end
fn.md_preview = function()
  local py = vim.fn.exepath("python3") ~= "" and "python3" or "python"
  if vim.fn.executable(py) ~= 1 then return vim.notify("python not found", vim.log.levels.ERROR) end
  vim.cmd("write")
  local html = vim.fn.system({ py, "-m", "markdown", "-x", "tables", "-x", "fenced_code", vim.api.nvim_buf_get_name(0) })
  if vim.v.shell_error ~= 0 then
    return vim.notify("needs python-markdown: sudo pacman -S python-markdown", vim.log.levels.ERROR)
  end
  local out = vim.fn.stdpath("cache") .. "/preview.html"
  vim.fn.mkdir(vim.fn.fnamemodify(out, ":h"), "p")
  local css = ("body{max-width:46em;margin:2em auto;padding:0 1em;font:16px/1.65 sans-serif;color:%s;background:%s}"
    .. "code,pre{background:%s;color:%s;padding:.1em .3em;border-radius:4px}pre{padding:1em;overflow:auto}"
    .. "a{color:%s}h1,h2,h3{color:%s}table{border-collapse:collapse}td,th{border:1px solid %s;padding:.3em .6em}")
    :format(hex("Normal", "fg") or "#ffe9b0", hex("NormalFloat", "bg") or "#0b0b0b", hex("Visual", "bg") or "#2a2a2a",
      hex("String", "fg") or "#d9e04a", hex("Keyword", "fg") or "#dc143c", hex("Title", "fg") or "#ff7a00",
      hex("LineNr", "fg") or "#8a7a5a")
  vim.fn.writefile(vim.split("<!doctype html><meta charset='utf-8'><title>preview</title><style>" .. css
    .. "</style>" .. html, "\n"), out)
  vim.ui.open(out)
end
vim.api.nvim_create_user_command("Preview", fn.md_preview, { desc = "markdown preview in browser" })

vim.api.nvim_create_autocmd("BufReadCmd", { -- PDFs open as text
  pattern = "*.pdf",
  callback = function(ev)
    if vim.fn.executable("pdftotext") ~= 1 then
      return vim.notify("pdftotext not found: sudo pacman -S poppler", vim.log.levels.ERROR)
    end
    vim.bo[ev.buf].modifiable = true
    vim.api.nvim_buf_set_lines(ev.buf, 0, -1, false, vim.fn.systemlist({ "pdftotext", "-layout", ev.file, "-" }))
    vim.bo[ev.buf].modified, vim.bo[ev.buf].modifiable, vim.bo[ev.buf].filetype = false, false, "text"
  end,
})
fn.pdf_open = function()
  local file = vim.fn.expand("%:p")
  if not file:match("%.pdf$") then return vim.notify("not a PDF", vim.log.levels.WARN) end
  vim.fn.jobstart({ "zathura", file }, { detach = true })
end
vim.api.nvim_create_user_command("View", fn.pdf_open, { desc = "open PDF in zathura" })

-- cheat sheet ----------------------------------------------------------------
local order = { "files", "code", "windows", "edit", "view", "help" }
function Solar.sheet_lines()
  local lines = {}
  for _, sec in ipairs(order) do
    lines[#lines + 1] = sec:upper()
    for _, k in ipairs(Solar.sheet) do
      if k[1] == sec then lines[#lines + 1] = ("  %-20s %s"):format(k[2], k[3]) end
    end
    lines[#lines + 1] = ""
  end
  lines[#lines + 1] = "COMMANDS"
  lines[#lines + 1] = ("  %-20s %s"):format(":Keys", "this cheat sheet")
  lines[#lines + 1] = ("  %-20s %s"):format(":Preview", "markdown in browser")
  lines[#lines + 1] = ("  %-20s %s"):format(":View", "PDF in zathura")
  lines[#lines + 1] = ("  %-20s %s"):format(":Undotree", "pick an undo state")
  lines[#lines + 1] = ("  %-20s %s"):format(":checkhealth vim.lsp", "which language servers are on")
  return lines
end
-- `nvim --headless "+lua Solar.print_sheet()" +q` — used by `ray keys vim`
function Solar.print_sheet() io.stdout:write(table.concat(Solar.sheet_lines(), "\n") .. "\n") end

fn.keys = function()
  local lines = Solar.sheet_lines()
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.bo[buf].modifiable, vim.bo[buf].bufhidden = false, "wipe"
  local w = 64
  local h = math.min(#lines, o.lines - 6)
  vim.api.nvim_open_win(buf, true, {
    relative = "editor", width = w, height = h, style = "minimal",
    row = math.floor((o.lines - h) / 2), col = math.floor((o.columns - w) / 2),
    title = " ☀ solarvim keys — q to close ", title_pos = "center",
  })
  for i, l in ipairs(lines) do
    if l:match("^%u") then vim.hl.range(buf, vim.api.nvim_create_namespace("solar_keys"), "Title", { i - 1, 0 }, { i - 1, -1 }) end
  end
  for _, k in ipairs({ "q", "<Esc>" }) do vim.keymap.set("n", k, "<cmd>close<cr>", { buffer = buf }) end
end
vim.api.nvim_create_user_command("Keys", fn.keys, { desc = "solarvim cheat sheet" })

-- 11 splash ------------------------------------------------------------------
local art = {
  [[███████╗ ██████╗ ██╗      █████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗]],
  [[██╔════╝██╔═══██╗██║     ██╔══██╗██╔══██╗██║   ██║██║████╗ ████║]],
  [[███████╗██║   ██║██║     ███████║██████╔╝██║   ██║██║██╔████╔██║]],
  [[╚════██║██║   ██║██║     ██╔══██║██╔══██╗╚██╗ ██╔╝██║██║╚██╔╝██║]],
  [[███████║╚██████╔╝███████╗██║  ██║██║  ██║ ╚████╔╝ ██║██║ ╚═╝ ██║]],
  [[╚══════╝ ╚═════╝ ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝  ╚═══╝  ╚═╝╚═╝     ╚═╝]],
}
local function splash()
  if vim.fn.argc() > 0 or #vim.api.nvim_list_uis() == 0 then return end
  local buf = vim.api.nvim_get_current_buf()
  local cur = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
  if #cur > 1 or (cur[1] or "") ~= "" or vim.api.nvim_buf_get_name(buf) ~= "" then return end
  local w, h = vim.api.nvim_win_get_width(0), vim.api.nvim_win_get_height(0)
  local function center(s) return string.rep(" ", math.max(0, math.floor((w - vim.fn.strdisplaywidth(s)) / 2))) .. s end
  local v = vim.version()
  local lines = {}
  for _ = 1, math.max(0, math.floor((h - #art - 10) / 2)) do lines[#lines + 1] = "" end
  for _, l in ipairs(art) do lines[#lines + 1] = center(l) end
  vim.list_extend(lines, {
    "", center(("sunny · minimal · zero plugins · Neovim %d.%d"):format(v.major, v.minor)), "",
    center("Space f  find file      Space /  search text      Space r  recent"),
    center("Space e  file tree      Ctrl+\\   terminal          Space ?  all keys"),
    center("i  type    Esc  stop    Space w  save    Space q  quit"),
  })
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.bo[buf].modified, vim.bo[buf].bufhidden = false, "wipe"
  vim.b[buf].solar_splash = true
  for i = 1, #lines do
    vim.hl.range(buf, vim.api.nvim_create_namespace("solar_splash"), i <= #lines - 5 and "Title" or "Comment",
      { i - 1, 0 }, { i - 1, -1 })
  end
end
vim.api.nvim_create_autocmd("VimEnter", { callback = function() vim.schedule(splash) end })
vim.api.nvim_create_autocmd({ "InsertEnter", "BufLeave" }, {
  callback = function(ev)
    if vim.b[ev.buf].solar_splash then
      vim.b[ev.buf].solar_splash = nil
      if ev.event == "InsertEnter" then vim.api.nvim_buf_set_lines(ev.buf, 0, -1, false, { "" }) end
    end
  end,
})

-- per-machine tweaks: ~/.config/solarvim/local.lua (gitignored, yours)
pcall(dofile, vim.fn.stdpath("config") .. "/local.lua")
