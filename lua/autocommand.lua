-- command :PackUpdate & :PackInstall untuk manajamen plugin
vim.api.nvim_create_user_command("PackUpdate", function()
  vim.pack.update()
  print("Mengecek dan memperbarui plugin...")
end, {})
vim.api.nvim_create_user_command("PackInstall", function()
  if type(vim.pack.install) == "function" then
    vim.pack.install()
    print("Menginstal plugin baru...")
  else
    vim.pack.update()
    print("Mengecek dan menginstal plugin baru...")
  end
end, {})
vim.api.nvim_create_user_command("PackClean", function()
  local data_path = vim.fn.stdpath("data")
  local plugin_dir = data_path .. "/site/pack/core/opt"

  if vim.fn.isdirectory(plugin_dir) == 1 then
    require("oil").open_float(plugin_dir)
    print("🗑️ Silakan arahkan kursor ke folder plugin yang mati, lalu tekan 'd' (delete) di Oil.")
  else
    print("Folder plugin belum ditemukan di: " .. plugin_dir)
  end
end, { desc = "Buka direktori plugin untuk dihapus manual via Oil" })

-- Mengatur Auto-Format pada saat menyimpan file (untuk Dart, Lua, dll)
vim.api.nvim_create_autocmd("BufWritePre", {
  group = vim.api.nvim_create_augroup("LspAutoFormat", { clear = true }),
  pattern = "*",
  callback = function(args)
    local clients = vim.lsp.get_clients({ bufnr = args.buf })

    if #clients > 0 then
      pcall(vim.lsp.buf.format, { bufnr = args.buf, async = false })
    end
  end,
})

-- Mengatur Auto-Organize Imports khusus untuk Golang saat save
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.go",
  callback = function()
    local range_params = vim.lsp.util.make_range_params(0, "utf-16")

    local params = {
      textDocument = range_params.textDocument,
      range = range_params.range,
      context = { only = { "source.organizeImports" } }
    }

    local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 1000)

    for cid, res in pairs(result or {}) do
      for _, r in pairs(res.result or {}) do
        if r.edit then
          local enc = (vim.lsp.get_client_by_id(cid) or {}).offset_encoding or "utf-16"
          vim.lsp.util.apply_workspace_edit(r.edit, enc)
        end
      end
    end
  end,
})

-- transparent
vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "*",
  callback = function()
    local transparent_groups = {
      "Normal",
      "NormalNC",
      "NormalFloat",
      "FloatBorder",
      "FloatTitle",
      "SignColumn",
      "EndOfBuffer",
      "Pmenu",
      "BlinkCmpMenu",
      "BlinkCmpMenuBorder",
      "BlinkCmpDoc",
      "BlinkCmpDocBorder",
      "BlinkCmpSignatureHelp",
      "BlinkCmpSignatureHelpBorder",
    }

    for _, group in ipairs(transparent_groups) do
      vim.api.nvim_set_hl(0, group, { bg = "none" })
    end
  end
})

-- agar tidak auto comment
vim.api.nvim_create_autocmd("BufEnter", {
  callback = function()
    vim.opt.formatoptions:remove({ "o", "r" })
  end,
  desc = "Matikan auto-comment pada baris baru",
})
