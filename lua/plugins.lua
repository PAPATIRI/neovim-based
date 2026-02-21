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
require("ufo").setup({
	fold_virt_text_handler = function(virtText, lnum, endLnum, width, truncate)
		local newVirtText = {}
		local suffix = ('  ... 󰁂 %d lines '):format(endLnum - lnum)
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
					table.insert(newVirtText, { (' '):rep(targetWidth - curWidth - chunkWidth), 'UfoFoldedEllipsis' })
				end
				break
			end
			curWidth = curWidth + chunkWidth
		end
		table.insert(newVirtText, { suffix, 'MoreMsg' })
		return newVirtText
	end,
	provider_selector = function(bufnr, filetype, buftype)
		return { 'lsp', 'indent' }
	end
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
require("hop").setup({
	keys = 'etovxqpdygfblzhckisuran'
})
-- Konfigurasi Mini Sessions
local sessions = require('mini.sessions')
sessions.setup({
	directory = vim.fn.stdpath('data') .. '/sessions',
	autowrite = true,
})
-- Keymap Navigasi Session
vim.keymap.set("n", "<leader>sl", function() sessions.select() end, { desc = "List Sessions" })
vim.keymap.set("n", "<leader>ss", function()
	local name = vim.fn.input("Session Name: ")
	if name ~= "" then
		require('mini.sessions').write(name)
		vim.cmd('redraw')
		vim.api.nvim_echo({ { " 󱫐 Session '" .. name .. "' saved!", "DiagnosticInfo" } }, true, {})
	end
end, { desc = "Save Session As" })
-- Menghapus session (dengan paksa jika itu session aktif)
vim.keymap.set("n", "<leader>sd", function()
	require('mini.sessions').select('delete', { force = true })
end, { desc = "Delete Session (Force)" })
