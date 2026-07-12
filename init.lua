-- MULAI MENGHITUNG WAKTU DI BARIS PERTAMA
local start_time = vim.uv.hrtime()

vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    local end_time = vim.uv.hrtime()
    local ms = (end_time - start_time) / 1000000

    vim.api.nvim_create_user_command("Startup", function()
      -- info=false: tanpa data branch/tag git yang lambat, cukup nama & status
      local plugins = vim.pack.get(nil, { info = false })
      table.sort(plugins, function(a, b)
        return a.spec.name < b.spec.name
      end)

      local n_active = 0
      for _, p in ipairs(plugins) do
        n_active = n_active + (p.active and 1 or 0)
      end

      print(string.format("🚀 Neovim siap dalam: %.2f ms", ms))
      print(string.format("📦 Plugin aktif: %d dari %d terpasang", n_active, #plugins))
      for _, p in ipairs(plugins) do
        print((p.active and "  ● " or "  ○ ") .. p.spec.name)
      end
    end, { desc = "Lihat waktu startup dan status plugin vim.pack" })
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
local lazy_plugins_loaded = false
vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
  group = vim.api.nvim_create_augroup("LazyLoadPlugins", { clear = true }),
  callback = function()
    if lazy_plugins_loaded then
      return
    end
    lazy_plugins_loaded = true

    require("lazy-loaded-plugins")
    require("lsp")
    require("debugging")

    -- Setup plugin di atas ada yang menyetel 'filetype' pada buffer internalnya
    -- (mis. panel dap-ui), sehingga flag internal `did_filetype` menyala di
    -- tengah rantai autocmd ini dan `setf` dari deteksi filetype bawaan menjadi
    -- no-op untuk buffer pemicunya. Ini hanya terjadi pada buffer yang dibuka
    -- via bufadd() (mini.pick, oil) karena jalur itu tidak me-reset flag
    -- tersebut, berbeda dengan :edit (yang dipakai session mini.sessions).
    -- Ulangi deteksi setelah rantai autocmd selesai agar event FileType terpicu
    -- saat vim.lsp.enable() sudah terdaftar: LSP, treesitter, dan ftplugin
    -- ter-attach ke buffer pertama.
    vim.schedule(function()
      for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].buftype == "" then
          if vim.bo[buf].filetype == "" then
            if vim.api.nvim_buf_get_name(buf) ~= "" then
              vim.api.nvim_buf_call(buf, function()
                vim.cmd("silent! filetype detect")
              end)
            end
          else
            -- Filetype sudah terdeteksi tapi event-nya sempat terpicu sebelum
            -- vim.lsp.enable() terdaftar: picu ulang khusus grup LSP saja.
            vim.api.nvim_buf_call(buf, function()
              pcall(vim.api.nvim_exec_autocmds, "FileType", {
                group = "nvim.lsp.enable",
                pattern = vim.bo[buf].filetype,
                modeline = false,
              })
            end)
          end
        end
      end
    end)
  end,
})

vim.cmd("colorscheme rose-pine")
