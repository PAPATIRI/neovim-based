-- dap plugin
local dap = require("dap")
local dapui = require("dapui")

dapui.setup()
dap.listeners.after.event_initialized["dapui_config"] = function()
	dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
	dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
	dapui.close()
end

-- general keymap
local map = vim.keymap.set
map("n", "<leader>o", ":update<CR> :source<CR>")
map("n", "<leader>w", ":write<CR>")
map("n", "<leader>q", ":quit<CR>")
map("i", "jk", "<Esc>")
map("i", "jj", "<Esc>")
map({ "v", "n", "x" }, "<leader>y", '"+y<CR>')
map({ "v", "n", "x" }, "<leader>d", '"+d<CR>')
map({ "v", "n", "x" }, "<leader>s", ":e #<CR>")
map({ "v", "n", "x" }, "<leader>S", ":sf #<CR>")

local trigger_completion = function()
	vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-x><C-o>", true, false, true), "n", true)
end
map("i", "<C-Space>", trigger_completion, { desc = "Trigger Completion" })
map("i", "<C-@>", trigger_completion, { desc = "Trigger Completion Fallback" })

-- plugin keymap
vim.ui.select = require("mini.pick").ui_select
map("n", "<leader>ff", ":Pick files<CR>")
map("n", "<leader>h", ":Pick help<CR>")
map("n", "<leader>bl", ":Pick buffers<CR>", { desc = "Pick Open Buffers" })
map("n", "<leader>bd", ":bd<CR>", { desc = "Close Buffer" })
map("n", "<S-h>", ":bprevious<CR>", { desc = "Buffer Sebelumnya", silent = true })
map("n", "<S-l>", ":bnext<CR>", { desc = "Buffer Selanjutnya", silent = true })
map("n", "<leader>e", function()
	require("oil").toggle_float()
end, { desc = "Toggle Oil Explorer" })
map("n", "<leader>lf", vim.lsp.buf.format)
-- flutter-tools & debugging
map("n", "<leader>fe", ":FlutterEmulators<CR>", { desc = "Buka Emulator" })
map("n", "<leader>fr", ":FlutterRun<CR>", { desc = "Jalankan Project" })
map("n", "<leader>fq", ":FlutterQuit<CR>", { desc = "Hentikan Project" })
map("n", "<leader>fR", ":FlutterRestart<CR>", { desc = "Hot Restart" })
map("n", "<leader>fl", ":FlutterReload<CR>", { desc = "Hot Reload Manual" })
map("n", "<leader>db", dap.toggle_breakpoint, { desc = "Toggle Breakpoint" })
map("n", "<leader>dc", dap.continue, { desc = "Start/Continue" })
map("n", "<leader>do", dap.step_over, { desc = "Step Over" })
map("n", "<leader>di", dap.step_into, { desc = "Step Into" })
map("n", "<leader>du", dapui.toggle, { desc = "Toggle UI Debug" })
-- hop nvim
map("n", "<leader><leader>w", ":HopWord<CR>", { desc = "Hop Word" })
map("n", "<leader><leader>s", ":HopChar1<CR>", { desc = "Hop 1 Char" })
-- ufo nvim
map('n', 'zR', require('ufo').openAllFolds)
map('n', 'zM', require('ufo').closeAllFolds)
