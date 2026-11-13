-- solarvim: crimson sunset (dark) / rose dawn (light)
vim.cmd("hi clear")
if vim.fn.exists("syntax_on") == 1 then vim.cmd("syntax reset") end
vim.g.colors_name = "solarvim"

local dark = vim.o.background == "dark"
local c = dark and {
  bg = "#0b0b0b", bg2 = "#171112", bg3 = "#2e2023", fg = "#f5e3d7", dim = "#8f7470",
  sun = "#ff3355", amber = "#ff8c6b", orange = "#ff5a36", red = "#e0233f",
  green = "#f2b880", teal = "#ffa08a", blue = "#ff7088", purple = "#c94f7c",
} or {
  bg = "#fff4ee", bg2 = "#fde4dc", bg3 = "#f5cfc4", fg = "#43242a", dim = "#a07f7a",
  sun = "#c8102e", amber = "#b8401f", orange = "#d0451b", red = "#a3122a",
  green = "#8a6a1e", teal = "#2f7a72", blue = "#3d6ea6", purple = "#8e3b6e",
}

local function hl(g, s) vim.api.nvim_set_hl(0, g, s) end
local groups = {
  Normal = { fg = c.fg, bg = c.bg }, NormalFloat = { fg = c.fg, bg = c.bg2 },
  FloatBorder = { fg = c.sun, bg = c.bg2 }, EndOfBuffer = { fg = c.bg },
  CursorLine = { bg = c.bg2 }, CursorLineNr = { fg = c.sun, bold = true },
  LineNr = { fg = c.dim }, SignColumn = { bg = c.bg }, ColorColumn = { bg = c.bg2 },
  Visual = { bg = c.bg3 }, Search = { fg = c.bg, bg = c.sun }, CurSearch = { fg = c.bg, bg = c.orange },
  IncSearch = { fg = c.bg, bg = c.orange }, MatchParen = { fg = c.orange, bold = true, underline = true },
  Pmenu = { fg = c.fg, bg = c.bg2 }, PmenuSel = { bg = c.bg3, bold = true },
  PmenuSbar = { bg = c.bg2 }, PmenuThumb = { bg = c.sun },
  StatusLine = { fg = c.fg, bg = c.bg3 }, StatusLineNC = { fg = c.dim, bg = c.bg2 },
  WinSeparator = { fg = c.bg3 }, Folded = { fg = c.dim, bg = c.bg2 },
  NonText = { fg = c.bg3 }, Whitespace = { fg = c.bg3 }, SpecialKey = { fg = c.bg3 },
  Directory = { fg = c.blue }, Title = { fg = c.orange, bold = true },
  ErrorMsg = { fg = c.red, bold = true }, WarningMsg = { fg = c.amber }, MoreMsg = { fg = c.green },
  Question = { fg = c.teal }, ModeMsg = { fg = c.sun },
  Comment = { fg = c.dim, italic = true }, Constant = { fg = c.orange },
  String = { fg = c.green }, Character = { fg = c.green }, Number = { fg = c.orange }, Boolean = { fg = c.orange },
  Identifier = { fg = c.fg }, Function = { fg = c.blue }, Statement = { fg = c.red },
  Operator = { fg = c.dim }, Keyword = { fg = c.red }, Type = { fg = c.amber },
  PreProc = { fg = c.purple }, Special = { fg = c.teal }, Delimiter = { fg = c.dim },
  Error = { fg = c.red }, Todo = { fg = c.bg, bg = c.sun, bold = true },
  DiagnosticError = { fg = c.red }, DiagnosticWarn = { fg = c.amber },
  DiagnosticInfo = { fg = c.blue }, DiagnosticHint = { fg = c.teal },
  DiagnosticUnderlineError = { undercurl = true, sp = c.red },
  DiagnosticUnderlineWarn = { undercurl = true, sp = c.amber },
  DiagnosticUnderlineInfo = { undercurl = true, sp = c.blue },
  DiagnosticUnderlineHint = { undercurl = true, sp = c.teal },
  LspReferenceText = { bg = c.bg2 }, LspReferenceRead = { bg = c.bg2 }, LspReferenceWrite = { bg = c.bg3 },
  DiffAdd = { bg = c.bg2, fg = c.green }, DiffChange = { bg = c.bg2, fg = c.amber },
  DiffDelete = { fg = c.red }, DiffText = { bg = c.bg3, bold = true },
  Added = { fg = c.green }, Changed = { fg = c.amber }, Removed = { fg = c.red },
}
for g, s in pairs(groups) do hl(g, s) end
