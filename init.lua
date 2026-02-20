vim.o.number = true
vim.o.relativenumber = true
vim.o.wrap = false
vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.swapfile = false
vim.g.mapleader = " "
vim.o.winborder = "rounded"
vim.o.termguicolors = true
vim.o.signcolumn = "yes"
vim.o.smartindent = true
vim.o.undofile = true
vim.o.incsearch = true
vim.o.smartcase = true
vim.o.ignorecase = true
vim.o.cursorline = true
vim.o.scrolloff = 1
vim.opt.fillchars = { eob = " " }

-- add plugin
vim.pack.add({
	{ src = "https://github.com/stevearc/oil.nvim" },
	{ src = "https://github.com/nvim-mini/mini.pick" },
	{ src = "https://github.com/mason-org/mason.nvim" },
	{ src = "https://github.com/nvim-lua/plenary.nvim" },
	{ src = "https://github.com/neovim/nvim-lspconfig" },
	{ src = "https://github.com/nvim-flutter/flutter-tools.nvim" },
	{ src = "https://github.com/j-hui/fidget.nvim" },
	{ src = "https://github.com/mfussenegger/nvim-dap" },
	{ src = "https://github.com/nvim-neotest/nvim-nio" },
	{ src = "https://github.com/rcarriga/nvim-dap-ui" },
	{ src = "https://github.com/Shatur/neovim-session-manager" },
	{ src = "https://github.com/smoka7/hop.nvim" },
	{ src = "https://github.com/echasnovski/mini.pairs" },
	{ src = "https://github.com/echasnovski/mini.surround" },
	{ src = "https://github.com/echasnovski/mini.indentscope" },
	{ src = "https://github.com/echasnovski/mini.icons" }
})

-- setup plugin
require("mini.pick").setup()
require("mini.pairs").setup()
require("mini.icons").setup()
require("mini.surround").setup()
require("mini.indentscope").setup({
	symbol = "│",
	options = {
		try_as_border = true,
		indent_at_cursor = false,
	},
})
require("oil").setup({
	float = {
		padding = 2,
		max_width = math.floor(vim.o.columns * 0.8),
		max_height = math.floor(vim.o.lines * 0.8),
		border = "rounded",
		win_options = {
			winblend = 0,
			number = false,
			relativenumber = false,
			signcolumn = "no",
		},
	},
})
require("mason").setup()
require("flutter-tools").setup({})
require("fidget").setup({})
-- hop (easy motion like)
require("hop").setup({
	keys = 'etovxqpdygfblzhckisuran'
})
-- sessionmanager plugin
local session_manager = require("session_manager")
session_manager.setup({
	autoload_mode = require('session_manager.config').AutoloadMode.Disabled
})

-- keymap settings
require("keymap")
-- ui settings
require("ui.colorscheme")
require("ui.terminal")
require("ui.statusline")
require("autocmd.command")
-- lsp settings
require("lsp.config")
