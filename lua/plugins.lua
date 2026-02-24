-- add plugin
vim.pack.add({
  -- filetree
  { src = "https://github.com/stevearc/oil.nvim" },
  -- LSP
  { src = "https://github.com/mason-org/mason.nvim" },
  { src = "https://github.com/neovim/nvim-lspconfig" },
  { src = "https://github.com/nvim-flutter/flutter-tools.nvim" },
  { src = "https://github.com/nvim-lua/plenary.nvim" },
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
vim.keymap.set("n", "<leader>sl", function() sessions.select() end, { desc = "List Sessions" })
vim.keymap.set("n", "<leader>ss", function()
  local name = vim.fn.input("Session Name: ")
  if name ~= "" then
    require('mini.sessions').write(name)
    vim.cmd('redraw')
    vim.api.nvim_echo({ { " 󱫐 Session '" .. name .. "' saved!", "DiagnosticInfo" } }, true, {})
  end
end, { desc = "Save Session As" })
vim.keymap.set("n", "<leader>sd", function()
  require('mini.sessions').select('delete', { force = true })
end, { desc = "Delete Session (Force)" })
