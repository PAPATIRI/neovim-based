-- dap plugin for debugging
local dap = require("dap")
local dapui = require("dapui")

dapui.setup()
require("nvim-dap-virtual-text").setup({})

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

-- F-key ala visual studio
map("n", "<F5>", dap.continue, { desc = "Debug: Start/Continue" })
map("n", "<S-F5>", dap.terminate, { desc = "Debug: Stop" })
map("n", "<F9>", dap.toggle_breakpoint, { desc = "Debug: Toggle Breakpoint" })
map("n", "<F10>", dap.step_over, { desc = "Debug: Step Over" })
map("n", "<F11>", dap.step_into, { desc = "Debug: Step Into" })
map("n", "<S-F11>", dap.step_out, { desc = "Debug: Step Out" })

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

-- debugging setting for c# / dotnet
dap.adapters.coreclr = {
  type = "executable",
  -- JANGAN pakai shim netcoredbg.CMD di mason/bin (spawn-nya sering exit code 1 di Windows,
  -- ada bug normalisasi slash di dalam script batch-nya). Tunjuk langsung ke .exe aslinya
  -- di dalam folder packages -- ini native PE binary, tidak perlu wrapper cmd.exe sama sekali.
  command = vim.fn.stdpath("data") .. "/mason/packages/netcoredbg/netcoredbg/netcoredbg.exe",
  args = { "--interpreter=vscode" },
}

-- helper: cari .dll hasil build, cross-platform (tanpa shell `find`, aman di Windows)
local function get_dll_path()
  local cwd = vim.fn.getcwd()
  local dlls = vim.fn.globpath(cwd, "**/bin/Debug/**/*.dll", false, true)
  if #dlls == 1 then
    return dlls[1]
  elseif #dlls > 1 then
    -- lebih dari satu .csproj di solution -> biar user pilih
    local choice = vim.fn.confirm("Pilih dll:\n" .. table.concat(dlls, "\n"), "&1\n&Manual", 1)
    if choice == 1 then
      return dlls[1]
    end
  end
  return vim.fn.input("Path ke .dll: ", cwd .. "/bin/Debug/", "file")
end

dap.configurations.cs = {
  {
    type = "coreclr",
    name = "Build lalu Launch",
    request = "launch",
    program = function()
      vim.fn.system("dotnet build -c Debug")
      return get_dll_path()
    end,
    cwd = "${workspaceFolder}",
    -- jalankan di terminal betulan supaya output kelihatan & Console.ReadLine() bisa input
    console = "integratedTerminal",
  },
  {
    type = "coreclr",
    name = "Launch tanpa build ulang",
    request = "launch",
    program = get_dll_path,
    cwd = "${workspaceFolder}",
    console = "integratedTerminal",
  },
  {
    type = "coreclr",
    name = "Attach ke proses",
    request = "attach",
    processId = require("dap.utils").pick_process,
  },
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
