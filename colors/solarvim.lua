-- solarvim: warm, muted sunset (dark) / paper sunny (light). Matches Rayconfig.
vim.cmd("hi clear")
if vim.fn.exists("syntax_on") == 1 then vim.cmd("syntax reset") end
vim.g.colors_name = "solarvim"

local dark = vim.o.background == "dark"
local c = dark and {
  bg = "#161311", bg2 = "#1f1b18", bg3 = "#2e2925", fg = "#e8dfd0", dim = "#8c8174",
  sun = "#e6b450", amber = "#d4a05a", orange = "#dd8754", red = "#d0605e",
  green = "#a9b665", teal = "#89b8a8", blue = "#82a6c8", purple = "#c08aa8",
} or {
  bg = "#f6f0e6", bg2 = "#ece4d6", bg3 = "#ddd2bf", fg = "#3d342b", dim = "#8d8172",
  sun = "#b8860b", amber = "#a8701c", orange = "#b8572a", red = "#a83a3a",
  green = "#687d2a", teal = "#3f7f72", blue = "#3f6f9a", purple = "#8a4a78",
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
