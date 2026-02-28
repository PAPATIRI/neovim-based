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
  { src = "https://github.com/nvim-mini/mini.completion" },
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
require('mini.sessions').setup({
  directory = vim.fn.stdpath('data') .. '/sessions',
  autowrite = true,
})
require("mini.indentscope").setup({
  symbol = "│",
  options = {
    try_as_border = true,
    indent_at_cursor = false,
  },
})
require("mini.completion").setup({
  delay = { completion = 50, info = 100, signature = 50 },
  lsp_completion = {
    source_func = 'omnifunc',
    auto_setup = true
  }
})
-- local trigger_completion = function()
--   vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-x><C-o>", true, false, true), "n", true)
-- end
-- vim.keymap.set("i", "<C-Space>", trigger_completion, { desc = "Trigger Completion Manual" })
-- vim.keymap.set("i", "<C-@>", trigger_completion, { desc = "Trigger Completion Fallback" })
-- local toggle_autocomplete_info = function()
--   vim.g.minicompletion_disable = not vim.g.minicompletion_disable
--
--   if vim.g.minicompletion_disable then
--     vim.api.nvim_echo({ { "Auto-Completion: OFF! (<C-Space> = shows completion))", "DiagnosticInfo" } }, true, {})
--   else
--     vim.api.nvim_echo({ { "Auto-Completion: ON!", "DiagnosticInfo" } }, true, {})
--   end
-- end
-- vim.keymap.set("n", "<leader>tc", toggle_autocomplete_info, { desc = "Toggle Auto-Completion" })

-- lsp things
require("mason").setup()
require("flutter-tools").setup({})
require("fidget").setup({})

require("hop").setup({
  keys = 'etovxqpdygfblzhckisuran'
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
    get_win_title = function(dir)
      local dir = require("oil").get_current_dir()
      if not dir then
        return " Oil "
      end

      local cwd = vim.fn.getcwd()
      local root_name = vim.fn.fnamemodify(cwd, ":t")
      local relative_path = vim.fn.fnamemodify(dir, ":.")

      local display_path
      if relative_path == "." or relative_path == "" then
        display_path = root_name .. "\\"
      else
        display_path = root_name .. "\\" .. relative_path
      end

      display_path = display_path:gsub("/", "\\")

      local ok, mini_icons = pcall(require, "mini.icons")
      local icon = ok and mini_icons.get("directory", "") or ""

      return " " .. icon .. " " .. display_path .. " "
    end
  },
})
