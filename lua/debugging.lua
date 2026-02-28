-- dap plugin for debugging
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

local map = vim.keymap.set
map("n", "<leader>db", dap.toggle_breakpoint, { desc = "Toggle Breakpoint" })
map("n", "<leader>dc", dap.continue, { desc = "Start/Continue" })
map("n", "<leader>do", dap.step_over, { desc = "Step Over" })
map("n", "<leader>di", dap.step_into, { desc = "Step Into" })
map("n", "<leader>du", dapui.toggle, { desc = "Toggle UI Debug" })

-- debugging setting for golang
dap.adapters.delve = {
  type = 'server',
  host = '127.0.0.1', -- KUNCI 1: Paksa Neovim pakai IPv4
  port = '${port}',
  executable = {
    -- KUNCI 2: Cari path absolut .exe agar tidak disita oleh cmd/terminal baru
    command = vim.fn.exepath('dlv'),
    args = { 'dap', '-l', '127.0.0.1:${port}' },
    options = {
      detached = false,
    }
  }
}

dap.configurations.go = {
  {
    type = "delve",
    name = "Debug File Ini (main.go)",
    request = "launch",
    program = "${file}" -- Menjalankan file yang sedang terbuka
  },
  {
    type = "delve",
    name = "Debug Seluruh Package",
    request = "launch",
    program = "${fileDirname}" -- Menjalankan folder tempat file berada
  },
  {
    type = "delve",
    name = "Debug Test",
    request = "launch",
    mode = "test",
    program = "${file}" -- Menjalankan go test pada file saat ini
  },
}
