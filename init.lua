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
vim.o.fillchars = 'eob: ,fold: ,foldopen:,foldsep: ,foldinner: ,foldclose:'
vim.o.completeopt = "menuone,noinsert,noselect"
-- folding setting
vim.o.foldmethod = 'indent'
vim.o.foldcolumn = '0'
vim.o.foldlevel = 99
vim.o.foldlevelstart = 99
vim.o.foldenable = true

-- add plugin
vim.pack.add({
	-- filetree
	{ src = "https://github.com/stevearc/oil.nvim" },
	-- LSP
	{ src = "https://github.com/mason-org/mason.nvim" },
	{ src = "https://github.com/neovim/nvim-lspconfig" },
	{ src = "https://github.com/nvim-flutter/flutter-tools.nvim" },
	{ src = "https://github.com/nvim-lua/plenary.nvim" },
	-- notification & lsp progress message
	{ src = "https://github.com/j-hui/fidget.nvim" },
	-- debugging
	{ src = "https://github.com/mfussenegger/nvim-dap" },
	{ src = "https://github.com/nvim-neotest/nvim-nio" },
	{ src = "https://github.com/rcarriga/nvim-dap-ui" },
	-- easy motion like
	{ src = "https://github.com/smoka7/hop.nvim" },
	-- file picker & lainnya dari mini plugins
	{ src = "https://github.com/nvim-mini/mini.pick" },
	{ src = "https://github.com/echasnovski/mini.pairs" },
	{ src = "https://github.com/echasnovski/mini.surround" },
	{ src = "https://github.com/echasnovski/mini.indentscope" },
	{ src = "https://github.com/echasnovski/mini.icons" },
	{ src = "https://github.com/echasnovski/mini.sessions" },
	-- colorscheme
	{ src = "https://github.com/rose-pine/neovim" },
	-- folding
	{ src = "https://github.com/kevinhwang91/promise-async" },
	{ src = "https://github.com/kevinhwang91/nvim-ufo" },
})

-- keymap settings
require("plugins")
require("keymap")
require("lsp")
require("autocommand")
-- ui settings
vim.cmd("colorscheme rose-pine")
-- require("ui.colorscheme")
require("ui.terminal")
require("ui.statusline")
