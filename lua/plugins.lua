vim.pack.add({
	-- filetree
	{ src = "https://github.com/stevearc/oil.nvim" },
	-- LSP
	{ src = "https://github.com/mason-org/mason.nvim" },
	{ src = "https://github.com/neovim/nvim-lspconfig" },
	{ src = "https://github.com/nvim-flutter/flutter-tools.nvim" },
	{ src = "https://github.com/nvim-lua/plenary.nvim" },
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter" },
	{ src = "https://github.com/windwp/nvim-ts-autotag" },
	{ src = "https://github.com/Saghen/blink.cmp" },
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

-- setup plugin
require("mini.pick").setup()
require("mini.pairs").setup()
require("mini.icons").setup()
require("mini.surround").setup()
require("mini.sessions").setup({
	directory = vim.fn.stdpath("data") .. "/sessions",
	autowrite = true,
})
require("mini.indentscope").setup({
	symbol = "│",
	options = {
		try_as_border = true,
		indent_at_cursor = false,
	},
})

-- lsp things
require("mason").setup()
require("flutter-tools").setup({})
require("fidget").setup({})

require("hop").setup({
	keys = "etovxqpdygfblzhckisuran",
})

require("nvim-treesitter").setup({
	ensure_installed = { "javascript", "typescript", "tsx", "html", "css", "json", "lua", "go" },
	highlight = { enable = true },
})
require("nvim-ts-autotag").setup()

require("blink.cmp").setup({
	keymap = { preset = "default" },
	appearance = {
		nerd_font_variant = "mono",
	},
	sources = {
		default = { "lsp", "path", "snippets", "buffer" },
	},
	completion = { documentation = { auto_show = false } },
  fuzzy = { implementation = "prefer_rust_with_warning" },
	signature = { enabled = true },
})

require("ufo").setup({
	fold_virt_text_handler = function(virtText, lnum, endLnum, width, truncate)
		local newVirtText = {}
		local suffix = ("  ... 󰁂 %d lines "):format(endLnum - lnum)
		local sufWidth = vim.fn.strdisplaywidth(suffix)
		local targetWidth = width - sufWidth
		local curWidth = 0
		for _, chunk in ipairs(virtText) do
			local chunkText = chunk[1]
			local chunkWidth = vim.fn.strdisplaywidth(chunkText)
			if targetWidth > curWidth + chunkWidth then
				table.insert(newVirtText, chunk)
			else
				chunkText = truncate(chunkText, targetWidth - curWidth)
				table.insert(newVirtText, { chunkText, chunk[2] })
				chunkWidth = vim.fn.strdisplaywidth(chunkText)
				if curWidth + chunkWidth < targetWidth then
					table.insert(newVirtText, { (" "):rep(targetWidth - curWidth - chunkWidth), "UfoFoldedEllipsis" })
				end
				break
			end
			curWidth = curWidth + chunkWidth
		end
		table.insert(newVirtText, { suffix, "MoreMsg" })
		return newVirtText
	end,
	provider_selector = function(bufnr, filetype, buftype)
		return { "lsp", "indent" }
	end,
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
		get_win_title = function(dir)
			local dir = require("oil").get_current_dir()
			if not dir then
				return " Oil "
			end

			local cwd = vim.fn.getcwd()
			local root_name = vim.fn.fnamemodify(cwd, ":t")
			local relative_path = vim.fn.fnamemodify(dir, ":.")

			local display_path
			if relative_path == "." or relative_path == "" then
				display_path = root_name .. "\\"
			else
				display_path = root_name .. "\\" .. relative_path
			end

			display_path = display_path:gsub("/", "\\")

			local ok, mini_icons = pcall(require, "mini.icons")
			local icon = ok and mini_icons.get("directory", "") or ""

			return " " .. icon .. " " .. display_path .. " "
		end,
	},
})
