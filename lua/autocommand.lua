-- auto menampilkan list sessions
-- vim.api.nvim_create_autocmd("VimEnter", {
-- 	callback = function()
-- 		if vim.fn.argc() == 0 and vim.api.nvim_buf_get_name(0) == "" then
-- 			vim.defer_fn(function()
-- 				local sessions = require('mini.sessions')
--
-- 				if next(sessions.detected) ~= nil then
-- 					sessions.select()
-- 				else
-- 					vim.api.nvim_echo({ { " 󱫐 No saved sessions found", "Comment" } }, false, {})
-- 				end
-- 			end, 50)
-- 		end
-- 	end,
-- })

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
