-- ☀ solarvim: minimal, warm, zero plugins, built-in LSP (Neovim 0.11+)
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.opt.shortmess:append("I") -- hide Neovim's default intro, solarvim shows its own

local o = vim.o
o.number, o.relativenumber, o.cursorline = true, true, true
o.signcolumn, o.scrolloff, o.showmode = "yes", 8, false
o.mouse, o.clipboard = "a", "unnamedplus"
o.ignorecase, o.smartcase = true, true
o.undofile, o.swapfile, o.updatetime, o.timeoutlen = true, false, 250, 400
o.splitright, o.splitbelow = true, true
o.expandtab, o.shiftwidth, o.tabstop, o.smartindent = true, 2, 2, true
o.breakindent, o.linebreak, o.wrap = true, true, true
o.termguicolors, o.pumheight = true, 10
o.completeopt = "menu,menuone,noselect,fuzzy,popup"
o.wildmode, o.wildignore = "longest:full,full", "*/node_modules/*,*/.git/*"
o.list, o.listchars = true, "tab:» ,trail:·,nbsp:␣"
o.statusline = " %f %m%r%=%y   %l:%c   %p%% "
vim.opt.path:append("**")

-- folder sidebar (netrw, built in)
vim.g.netrw_banner = 0
vim.g.netrw_liststyle = 3
vim.g.netrw_winsize = 35
vim.g.netrw_keepdir = 0
vim.g.netrw_list_hide = [[\.git/,node_modules/]]

vim.o.background = "dark"
vim.cmd.colorscheme("solarvim")

local map = vim.keymap.set
map("n", "<Esc>", "<cmd>nohlsearch<cr>")
map("n", "<leader>w", "<cmd>write<cr>", { desc = "Save" })
map("n", "<leader>q", "<cmd>quit<cr>", { desc = "Quit" })
map("n", "<leader>e", "<cmd>Lexplore<cr>", { desc = "Folder tree (toggle)" })
map("n", "<leader>f", ":find ", { desc = "Find file" })
map("n", "<leader>b", ":ls<cr>:b<space>", { desc = "Switch buffer" })
map("n", "<leader>h", "<cmd>Tutor<cr>", { desc = "Tutorial" })
map("n", "<leader>d", vim.diagnostic.open_float, { desc = "Show diagnostic" })
map("n", "<leader>cf", function() vim.lsp.buf.format() end, { desc = "Format" })
map("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
map("n", "<leader>tb", function()
  vim.o.background = vim.o.background == "light" and "dark" or "light"
end, { desc = "Toggle sunny/sunset" })
for _, k in ipairs({ "h", "j", "k", "l" }) do map("n", "<C-" .. k .. ">", "<C-w>" .. k) end
map("v", "J", ":m '>+1<cr>gv=gv")
map("v", "K", ":m '<-2<cr>gv=gv")
map("v", "<", "<gv")
map("v", ">", ">gv")

-- completion: Tab/S-Tab to move, Enter to accept, Ctrl-Space to trigger
map("i", "<Tab>", function() return vim.fn.pumvisible() == 1 and "<C-n>" or "<Tab>" end, { expr = true })
map("i", "<S-Tab>", function() return vim.fn.pumvisible() == 1 and "<C-p>" or "<S-Tab>" end, { expr = true })
map("i", "<CR>", function()
  if vim.fn.pumvisible() == 1 and vim.fn.complete_info({ "selected" }).selected ~= -1 then return "<C-y>" end
  return "<CR>"
end, { expr = true })
map("i", "<C-Space>", function() vim.lsp.completion.get() end)

vim.api.nvim_create_autocmd("TextYankPost", { callback = function() vim.hl.on_yank() end })
vim.api.nvim_create_autocmd("BufReadPost", {
  callback = function()
    local m = vim.api.nvim_buf_get_mark(0, '"')
    if m[1] > 0 and m[1] <= vim.api.nvim_buf_line_count(0) then pcall(vim.api.nvim_win_set_cursor, 0, m) end
  end,
})

-- splash screen shown when you start solarvim with no file ---------------
local art = {
  [[███████╗ ██████╗ ██╗      █████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗]],
  [[██╔════╝██╔═══██╗██║     ██╔══██╗██╔══██╗██║   ██║██║████╗ ████║]],
  [[███████╗██║   ██║██║     ███████║██████╔╝██║   ██║██║██╔████╔██║]],
  [[╚════██║██║   ██║██║     ██╔══██║██╔══██╗╚██╗ ██╔╝██║██║╚██╔╝██║]],
  [[███████║╚██████╔╝███████╗██║  ██║██║  ██║ ╚████╔╝ ██║██║ ╚═╝ ██║]],
  [[╚══════╝ ╚═════╝ ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝  ╚═══╝  ╚═╝╚═╝     ╚═╝]],
}
local function show_splash()
  if vim.fn.argc() > 0 then return end
  local buf = vim.api.nvim_get_current_buf()
  local cur = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
  if #cur > 1 or (cur[1] or "") ~= "" or vim.api.nvim_buf_get_name(buf) ~= "" then return end
  local w, h = vim.api.nvim_win_get_width(0), vim.api.nvim_win_get_height(0)
  local function center(s)
    return string.rep(" ", math.max(0, math.floor((w - vim.fn.strdisplaywidth(s)) / 2))) .. s
  end
  local v = vim.version()
  local lines = {}
  for _ = 1, math.max(0, math.floor((h - #art - 8) / 2)) do lines[#lines + 1] = "" end
  for _, l in ipairs(art) do lines[#lines + 1] = center(l) end
  lines[#lines + 1] = ""
  lines[#lines + 1] = center(("solarvim  ·  sunny, minimal, zero plugins  ·  Neovim %d.%d"):format(v.major, v.minor))
  lines[#lines + 1] = ""
  lines[#lines + 1] = center("i  start typing     Esc  stop typing     :w  save     :q  quit")
  lines[#lines + 1] = center("<Space>e  folder tree     <Space>f  find file     <Space>h  tutorial")
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.bo[buf].modified = false
  vim.b[buf].solar_splash = true
end
vim.api.nvim_create_autocmd("VimEnter", { callback = function() vim.schedule(show_splash) end })
vim.api.nvim_create_autocmd("InsertEnter", {
  callback = function(ev)
    if vim.b[ev.buf].solar_splash then
      vim.api.nvim_buf_set_lines(ev.buf, 0, -1, false, { "" })
      vim.b[ev.buf].solar_splash = nil
    end
  end,
})

-- LSP ----------------------------------------------------------------------
vim.diagnostic.config({
  virtual_text = true, severity_sort = true, update_in_insert = false,
  float = { border = "rounded" },
})

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if client and client:supports_method("textDocument/completion") then
      vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
    end
  end,
})

-- Each server only turns on if its program is installed.
-- Built-in keys: K hover, grn rename, gra code action, grr references, [d ]d diagnostics.
local servers = {
  lua_ls = {
    cmd = { "lua-language-server" }, filetypes = { "lua" },
    root_markers = { ".luarc.json", ".luarc.jsonc", ".stylua.toml", ".git" },
    settings = { Lua = {
      runtime = { version = "LuaJIT" }, diagnostics = { globals = { "vim" } },
      workspace = { library = { vim.env.VIMRUNTIME }, checkThirdParty = false },
      telemetry = { enable = false },
    } },
  },
  pyright = {
    cmd = { "pyright-langserver", "--stdio" }, filetypes = { "python" },
    root_markers = { "pyproject.toml", "setup.py", "requirements.txt", ".git" },
  },
  clangd = {
    cmd = { "clangd" }, filetypes = { "c", "cpp", "objc", "objcpp" },
    root_markers = { "compile_commands.json", ".clangd", "CMakeLists.txt", ".git" },
  },
  r_languageserver = {
    cmd = { "R", "--slave", "-e", "languageserver::run()" }, filetypes = { "r", "rmd" },
    root_markers = { ".git", "DESCRIPTION" },
  },
  ts_ls = {
    cmd = { "typescript-language-server", "--stdio" },
    filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
    root_markers = { "package.json", "tsconfig.json", "jsconfig.json", ".git" },
  },
  html = {
    cmd = { "vscode-html-language-server", "--stdio" }, filetypes = { "html" },
    root_markers = { "package.json", ".git" },
  },
  cssls = {
    cmd = { "vscode-css-language-server", "--stdio" }, filetypes = { "css", "scss", "less" },
    root_markers = { "package.json", ".git" },
  },
  bashls = {
    cmd = { "bash-language-server", "start" }, filetypes = { "sh", "bash" }, root_markers = { ".git" },
  },
}
for name, cfg in pairs(servers) do
  if vim.fn.executable(cfg.cmd[1]) == 1 then
    vim.lsp.config(name, cfg)
    vim.lsp.enable(name)
  end
end

-- auto hover docs + signature help (VS Code style) --------------------------
-- solar_hover
local function lsp_ready()
  return #vim.lsp.get_clients({ bufnr = 0 }) > 0
    and vim.api.nvim_win_get_config(0).relative == ""
end

-- docs pop up after you pause on a symbol in Normal mode
vim.api.nvim_create_autocmd("CursorHold", {
  callback = function()
    if lsp_ready() and #vim.diagnostic.get(0, { lnum = vim.api.nvim_win_get_cursor(0)[1] - 1 }) == 0 then vim.lsp.buf.hover({ border = "rounded", max_height = 20, max_width = 80 }) end
  end,
})

-- parameter help pops up after you type "(" or ","
vim.api.nvim_create_autocmd("TextChangedI", {
  callback = function()
    local col = vim.api.nvim_win_get_cursor(0)[2]
    local before = vim.api.nvim_get_current_line():sub(1, col)
    if lsp_ready() and before:match("[(,]%s*$") then
      vim.lsp.buf.signature_help({ border = "rounded" })
    end
  end,
})

-- full docs for the completion item you highlight
vim.o.completeopt = "menu,menuone,noselect,fuzzy,popup"

-- solar_transparent: let the terminal's opacity show through
vim.o.winblend = 12
vim.o.pumblend = 12
local function solar_translucent()
  for _, g in ipairs({ "Normal", "NormalNC", "SignColumn", "EndOfBuffer" }) do
    local hl = vim.api.nvim_get_hl(0, { name = g, link = false })
    hl.bg = nil
    vim.api.nvim_set_hl(0, g, hl)
  end
end
solar_translucent()
vim.api.nvim_create_autocmd("ColorScheme", { callback = solar_translucent })

-- solar_preview_py: replaces the pandoc preview with python-markdown (small, no Haskell)
map("n", "<leader>mp", function()
  if vim.fn.executable("python") ~= 1 then
    vim.notify("python not found", vim.log.levels.ERROR)
    return
  end
  vim.cmd("write")
  local src = vim.api.nvim_buf_get_name(0)
  local out = vim.fn.stdpath("cache") .. "/preview.html"
  local html = vim.fn.system({ "python", "-m", "markdown", "-x", "tables", "-x", "fenced_code", src })
  if vim.v.shell_error ~= 0 then
    vim.notify("markdown failed: " .. html, vim.log.levels.ERROR)
    return
  end
  local page = "<!doctype html><meta charset='utf-8'><title>preview</title>"
    .. "<style>body{max-width:44em;margin:2em auto;font:16px/1.6 sans-serif;color:#f5e3d7;background:#0b0b0b}"
    .. "code,pre{background:#171112;color:#ff8c6b}a{color:#ff3355}</style>"
  vim.fn.writefile(vim.split(page .. html, "\n"), out)
  vim.ui.open(out)
end, { desc = "Markdown preview (browser)" })

-- solar_pdf: read PDFs as text in the editor, open them in Zathura on demand
vim.api.nvim_create_autocmd("BufReadCmd", {
  pattern = "*.pdf",
  callback = function(ev)
    if vim.fn.executable("pdftotext") ~= 1 then
      vim.notify("pdftotext not found: sudo pacman -S poppler", vim.log.levels.ERROR)
      return
    end
    local lines = vim.fn.systemlist({ "pdftotext", "-layout", ev.file, "-" })
    vim.bo[ev.buf].modifiable = true
    vim.api.nvim_buf_set_lines(ev.buf, 0, -1, false, lines)
    vim.bo[ev.buf].modified = false
    vim.bo[ev.buf].modifiable = false
    vim.bo[ev.buf].filetype = "text"
  end,
})

map("n", "<leader>pv", function()
  local file = vim.fn.expand("%:p")
  if not file:match("%.pdf$") then
    vim.notify("Current file is not a PDF", vim.log.levels.WARN)
    return
  end
  vim.fn.jobstart({ "zathura", file }, { detach = true })
end, { desc = "Open PDF in Zathura" })

-- solar_cmds: short, typeable commands for things you'd otherwise forget ----
vim.api.nvim_create_user_command("View", function()
  local file = vim.fn.expand("%:p")
  if not file:match("%.pdf$") then
    vim.notify("Current file is not a PDF", vim.log.levels.WARN)
    return
  end
  vim.fn.jobstart({ "zathura", file }, { detach = true })
end, { desc = "Open current PDF in Zathura" })

vim.api.nvim_create_user_command("Preview", function()
  vim.cmd("normal! \\<Space>mp")
end, { desc = "Markdown preview in browser" })

-- Bare keys: type `?` to see the list of solarvim keys in a float.
map("n", "?", function()
  local keys = {
    " SOLARVIM KEYS (Space = leader)",
    "",
    " Space w      save            Space q   quit",
    " Space e      folder tree     Space f   find file",
    " Space b      buffers         Space h   tutorial",
    " Space d      diagnostic      Space cf  format",
    " Space tb     light/dark      Space mp  markdown preview",
    " Space pv     PDF in Zathura  Space z   zoom window",
    "",
    " gd  definition     K  hover     grr  references",
    " gra code action    grn rename  Ctrl+hjkl  move window",
    "",
    " :View     open PDF in Zathura",
    " :Preview  markdown in browser",
  }
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, keys)
  vim.bo[buf].modifiable = false
  vim.api.nvim_open_win(buf, true, {
    relative = "editor", width = 50, height = #keys,
    row = math.floor((vim.o.lines - #keys) / 2),
    col = math.floor((vim.o.columns - 50) / 2),
    style = "minimal", border = "rounded",
  })
  vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = buf })
  vim.keymap.set("n", "<Esc>", "<cmd>close<cr>", { buffer = buf })
end, { desc = "Show solarvim keys" })

-- solar_md_fix: working browser Markdown preview, and keys cleanup -------
local function solar_md_preview()
  if vim.fn.executable("python") ~= 1 then
    vim.notify("python not found", vim.log.levels.ERROR)
    return
  end
  vim.cmd("write")
  local src = vim.api.nvim_buf_get_name(0)
  local out = vim.fn.stdpath("cache") .. "/preview.html"
  vim.fn.mkdir(vim.fn.fnamemodify(out, ":h"), "p")
  local html = vim.fn.system({ "python", "-m", "markdown", "-x", "tables", "-x", "fenced_code", src })
  if vim.v.shell_error ~= 0 then
    vim.notify("markdown failed: " .. html, vim.log.levels.ERROR)
    return
  end
  local page = "<!doctype html><meta charset='utf-8'><title>preview</title>"
    .. "<style>body{max-width:44em;margin:2em auto;font:16px/1.6 sans-serif;color:#f5e3d7;background:#0b0b0b}"
    .. "code,pre{background:#171112;color:#ff8c6b}a{color:#ff3355}</style>"
  vim.fn.writefile(vim.split(page .. html, "\n"), out)
  vim.ui.open(out)
end
map("n", "<leader>mp", solar_md_preview, { desc = "Markdown preview (browser)" })
vim.api.nvim_create_user_command("Preview", solar_md_preview, { desc = "Markdown preview in browser" })

-- undo the earlier bare '?' mapping so backward search works again
pcall(vim.keymap.del, "n", "?")
map("n", "<leader>?", function()
  vim.cmd("normal! \\<Esc>")
  vim.cmd("help solarvim-keys")
end, { desc = "Show solarvim keys" })

-- solar_pairs: auto-close brackets and quotes (built-in, no plugin) ------
local solar_pairs = { ["("] = ")", ["["] = "]", ["{"] = "}", ['"'] = '"', ["'"] = "'", ["`"] = "`" }
local solar_closers = { [")"] = true, ["]"] = true, ["}"] = true }

local function solar_open(open, close)
  return function()
    local line = vim.api.nvim_get_current_line()
    local col = vim.api.nvim_win_get_cursor(0)[2]
    local prv, nxt = line:sub(col, col), line:sub(col + 1, col + 1)
    if open == close then
      if nxt == open then return "<Right>" end        -- step over an existing quote
      if prv:match("[%w_]") then return open end      -- keep apostrophes like don't
    end
    if nxt ~= "" and not nxt:match("[%s%)%]%}\"'`,;]") then return open end
    return open .. close .. "<Left>"
  end
end

for open, close in pairs(solar_pairs) do
  map("i", open, solar_open(open, close), { expr = true })
end

for close in pairs(solar_closers) do
  map("i", close, function()
    local line = vim.api.nvim_get_current_line()
    local col = vim.api.nvim_win_get_cursor(0)[2]
    if line:sub(col + 1, col + 1) == close then return "<Right>" end
    return close
  end, { expr = true })
end

-- backspace removes both halves of an empty pair: ( | ) -> nothing
map("i", "<BS>", function()
  local line = vim.api.nvim_get_current_line()
  local col = vim.api.nvim_win_get_cursor(0)[2]
  local prv, nxt = line:sub(col, col), line:sub(col + 1, col + 1)
  if solar_pairs[prv] and nxt == solar_pairs[prv] then return "<Del><BS>" end
  return "<BS>"
end, { expr = true })

-- quick fix menu for the error under the cursor
map({ "n", "v" }, "<leader>ca", function()
  vim.lsp.buf.code_action()
end, { desc = "Quick fix / code action" })

-- solar_indent: language-aware auto-indent (built-in, no plugin) ---------
vim.cmd("filetype plugin indent on")
vim.o.autoindent = true
vim.o.smartindent = false   -- cindent/indentexpr from filetype rules take over
vim.o.cindent = true
vim.o.copyindent = true     -- keep the existing indent style when you add lines
vim.o.shiftround = true     -- > and < snap to multiples of shiftwidth

-- solar_case: case-sensitive and insensitive search keys
map("n", "<leader>fi", ":grep! -i ", { desc = "Search text (ignore case)" })
map("n", "<leader>ti", function()
  vim.o.ignorecase = not vim.o.ignorecase
  vim.notify("ignorecase: " .. tostring(vim.o.ignorecase))
end, { desc = "Toggle ignore case" })

-- solar_js_ts: JavaScript and TypeScript filetypes for ts_ls
vim.filetype.add({
  extension = {
    cjs = "javascript", mjs = "javascript",
    cts = "typescript", mts = "typescript",
  },
})
if vim.fn.executable("typescript-language-server") == 1 then
  vim.lsp.config("ts_ls", {
    cmd = { "typescript-language-server", "--stdio" },
    filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
    root_markers = { "package.json", "tsconfig.json", "jsconfig.json", ".git" },
  })
  vim.lsp.enable("ts_ls")
end

-- solar_python: python-lsp-server (pylsp), pure Python, not Microsoft
if vim.fn.executable("pylsp") == 1 then
  vim.lsp.config("pylsp", {
    cmd = { "pylsp" },
    filetypes = { "python" },
    root_markers = { "pyproject.toml", "setup.py", "requirements.txt", ".git" },
  })
  vim.lsp.enable("pylsp")
end
