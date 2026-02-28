vim.pack.add({
  -- LSP
  { src = "https://github.com/neovim/nvim-lspconfig" },
  { src = "https://github.com/nvim-flutter/flutter-tools.nvim" },
  { src = "https://github.com/nvim-lua/plenary.nvim" },
  { src = "https://github.com/windwp/nvim-ts-autotag" },
  { src = "https://github.com/Saghen/blink.cmp" },
  -- notification & lsp progress message
  { src = "https://github.com/j-hui/fidget.nvim" },
  { src = "https://github.com/nvim-treesitter/nvim-treesitter" },
  { src = "https://github.com/nvim-treesitter/nvim-treesitter-textobjects" },
  -- debugging
  { src = "https://github.com/mfussenegger/nvim-dap" },
  { src = "https://github.com/nvim-neotest/nvim-nio" },
  { src = "https://github.com/rcarriga/nvim-dap-ui" },
  -- easy motion like
  { src = "https://github.com/smoka7/hop.nvim" },
  -- file picker & lainnya dari mini plugins
  { src = "https://github.com/echasnovski/mini.pairs" },
  { src = "https://github.com/echasnovski/mini.surround" },
  { src = "https://github.com/echasnovski/mini.indentscope" },
})

-- setup plugin
require("mini.pairs").setup()
require("mini.surround").setup()
require("fidget").setup({})
require("mini.indentscope").setup({
  symbol = "│",
  options = {
    try_as_border = true,
    indent_at_cursor = false,
  },
})

-- lsp things
require("flutter-tools").setup({})

require("hop").setup({
  keys = "etovxqpdygfblzhckisuran",
})

require("nvim-ts-autotag").setup()
require("nvim-treesitter").setup({
  ensure_installed = { "javascript", "typescript", "tsx", "html", "css", "json", "lua", "go", "dart" },
  highlight = { enable = true },
  indent = { enable = true }
})

-- folding setting dengan treesitter
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldtext = ""
vim.o.foldlevel = 99
vim.o.foldlevelstart = 99
vim.api.nvim_set_hl(0, "Folded", {
  fg = "NONE",
  bg = "#21202e",
  italic = true
})

require("nvim-treesitter-textobjects").setup({
  select = {
    lookahead = true,
    selection_modes = {
      ["@parameter.outer"] = "v", -- charwise (karakter biasa)
      ["@function.outer"] = "V",  -- linewise (selalu hapus satu baris utuh)
      ["@class.outer"] = "<c-v>", -- blockwise
    },
  }
})
local select = require("nvim-treesitter-textobjects.select")
local function map_obj(key, query)
  vim.keymap.set({ "x", "o" }, key, function()
    select.select_textobject(query, "textobjects")
  end, { desc = "TS Textobject: " .. query })
end
-- functions
map_obj("af", "@function.outer")
map_obj("if", "@function.inner")
-- class
map_obj("ac", "@class.outer")
map_obj("ic", "@class.inner")
-- arguments
map_obj("ia", "@parameter.inner")
map_obj("aa", "@parameter.outer")
-- Block / Scope
map_obj("ab", "@block.outer")
map_obj("ib", "@block.inner")
-- Conditional (If-Else)
map_obj("ai", "@conditional.outer")
map_obj("ii", "@conditional.inner")
-- Call (Pemanggilan Fungsi)
map_obj("al", "@call.outer")
map_obj("il", "@call.inner")

require("blink.cmp").setup({
  keymap = { preset = "default" },
  appearance = {
    nerd_font_variant = "mono",
  },
  sources = {
    default = { "lsp", "path", "snippets", "buffer" },
  },
  completion = { documentation = { auto_show = false } },
  fuzzy = { implementation = "prefer_rust_with_warning" },
  signature = { enabled = true },
})

-- keymap
-- flutter-tools & debugging
local map = vim.keymap.set
map("n", "<leader>fe", ":FlutterEmulators<CR>", { desc = "Buka Emulator" })
map("n", "<leader>fr", ":FlutterRun<CR>", { desc = "Jalankan Project" })
map("n", "<leader>fq", ":FlutterQuit<CR>", { desc = "Hentikan Project" })
map("n", "<leader>fR", ":FlutterRestart<CR>", { desc = "Hot Restart" })
map("n", "<leader>fl", ":FlutterReload<CR>", { desc = "Hot Reload Manual" })

-- hop nvim
map("n", "<leader><leader>w", ":HopWord<CR>", { desc = "Hop Word" })
map("n", "<leader><leader>s", ":HopChar1<CR>", { desc = "Hop 1 Char" })
