-- MULAI MENGHITUNG WAKTU DI BARIS PERTAMA
local start_time = vim.uv.hrtime()

vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    local end_time = vim.uv.hrtime()
    local ms = (end_time - start_time) / 1000000

    vim.api.nvim_create_user_command("Startup", function()
      local rtp = vim.api.nvim_list_runtime_paths()
      print(string.format("🚀 Neovim siap dalam: %.2f ms", ms))
      print("📦 Jumlah path/plugin di-load: " .. #rtp)

      for _, path in ipairs(rtp) do
        print(path)
      end
    end, { desc = "Lihat waktu startup dan jumlah plugin" })
  end,
})

-- initial loaded plugins
vim.pack.add({
  { src = "https://github.com/stevearc/oil.nvim" },
  { src = "https://github.com/echasnovski/mini.icons" },
  { src = "https://github.com/echasnovski/mini.sessions" },
  { src = "https://github.com/nvim-mini/mini.pick" },
  { src = "https://github.com/mason-org/mason.nvim" },
  { src = "https://github.com/rose-pine/neovim" },
})
require("initial-loaded-plugins")
require("options")
require("keymap")
require("autocommand")
require("ui.terminal")
require("ui.statusline")

-- lazy loaded plugins
vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
  group = vim.api.nvim_create_augroup("LazyLoadPlugins", { clear = true }),
  callback = function()
    require("lazy-loaded-plugins")
    require("lsp")
    require("debugging")
  end,
})

vim.cmd("colorscheme rose-pine")
