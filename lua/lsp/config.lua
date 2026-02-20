local capabilities = vim.lsp.protocol.make_client_capabilities()

require("flutter-tools").setup({
	ui = { border = "rounded" },
	decorations = { statusline = { app_version = true, device = true } },
	debugger = {
		enabled = true,
		run_via_dap = true
	},
	lsp = {
		capabilities = capabilities,
	},
})

vim.lsp.config.lua_ls = {
	cmd = { "lua-language-server" },
	capabilities = capabilities,
	settings = {
		Lua = {
			workspace = { library = vim.api.nvim_get_runtime_file("", true), checkThirdParty = false },
			runtime = { version = "LuaJIT" },
		},
	},
}
vim.lsp.enable("lua_ls")

vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(args)
		local map = function(keys, func)
			vim.keymap.set("n", keys, func, { buffer = args.buf })
		end

		map("K", vim.lsp.buf.hover)
		map("gd", vim.lsp.buf.definition)
		map("gD", vim.lsp.buf.declaration)
		map("gi", vim.lsp.buf.implementation)
		map("gr", vim.lsp.buf.references)
		map("<leader>rn", vim.lsp.buf.rename)
		map("<leader>ca", vim.lsp.buf.code_action)
	end,
})
