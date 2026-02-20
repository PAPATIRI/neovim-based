-- coloscheme settings
local palette = {
	base = "#191724",
	surface = "#1f1d2e",
	overlay = "#26233a",
	text = "#e0def4",
	subtle = "#6e6a86",
	love = "#eb6f92",
	gold = "#f6c177",
	rose = "#ebbcba",
	pine = "#31748f",
	iris = "#c4a7e7",
}

-- Reset Colorscheme bawaan agar clean
vim.cmd("hi clear")
if vim.fn.exists("syntax_on") then
	vim.cmd("syntax reset")
end
vim.o.termguicolors = true

-- Shortcut variable
local hl = vim.api.nvim_set_hl

-- EDITOR BASE
hl(0, "Normal", { fg = palette.text, bg = "NONE" })
hl(0, "LineNr", { fg = palette.subtle })
hl(0, "CursorLine", { bg = palette.surface })
hl(0, "CursorLineNr", { fg = palette.text, bold = true })
hl(0, "Visual", { bg = palette.overlay })

-- SYNTAX
hl(0, "Comment", { fg = palette.subtle, italic = true })
hl(0, "Constant", { fg = palette.rose })
hl(0, "String", { fg = palette.rose })
hl(0, "Character", { link = "String" })
hl(0, "Identifier", { fg = palette.text })
hl(0, "Function", { fg = palette.text })
hl(0, "Statement", { fg = palette.text })
hl(0, "PreProc", { fg = palette.text })
hl(0, "Type", { fg = palette.text })
hl(0, "Special", { fg = palette.text })
hl(0, "Error", { fg = palette.love })
hl(0, "Todo", { fg = palette.love, bold = true })

-- UI & FLOATING WINDOW
hl(0, "NormalFloat", { bg = palette.base, fg = palette.text })
hl(0, "FloatBorder", { bg = palette.base, fg = palette.subtle })

-- Pmenu (Autocomplete popup)
hl(0, "Pmenu", { bg = palette.base, fg = palette.subtle })
hl(0, "PmenuSel", { bg = palette.overlay, fg = palette.text, bold = true })
hl(0, "PmenuThumb", { bg = palette.subtle })

-- Search
hl(0, "Search", { bg = palette.text, fg = palette.base })
hl(0, "CurSearch", { bg = palette.love, fg = palette.base })
hl(0, "IncSearch", { link = "CurSearch" })

-- Statusline simpel
hl(0, "StatusLine", { bg = palette.surface, fg = palette.text })
hl(0, "StatusLineNC", { bg = palette.base, fg = palette.subtle })

-- Fidget Plugin
hl(0, "FidgetTitle", { fg = palette.pine, bold = true })
hl(0, "FidgetTask", { fg = palette.subtle })

-- Hop.nvim
hl(0, "HopNextKey", { fg = palette.love, bold = true })
hl(0, "HopNextKey1", { fg = palette.gold, bold = true })
hl(0, "HopNextKey2", { fg = palette.rose })
hl(0, "HopUnmatched", { fg = palette.subtle })

-- Oil.nvim (File Explorer)
hl(0, "OilDir", { fg = palette.pine, bold = true })
hl(0, "OilDirIcon", { fg = palette.pine })
hl(0, "OilFile", { fg = palette.text })

-- mini indentscope
hl(0, "MiniIndentscopeSymbol", { fg = palette.overlay })
-- mini icons
for _, group in ipairs({ "Azure", "Blue", "Cyan", "Green", "Grey", "Orange", "Purple", "Red", "Yellow" }) do
	hl(0, "MiniIcons" .. group, { fg = palette.pine })
end
