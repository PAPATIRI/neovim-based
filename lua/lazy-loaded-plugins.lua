vim.pack.add({
  -- LSP
  { src = "https://github.com/neovim/nvim-lspconfig" },
  { src = "https://github.com/nvim-flutter/flutter-tools.nvim" },
  { src = "https://github.com/nvim-lua/plenary.nvim" },
  { src = "https://github.com/windwp/nvim-ts-autotag" },
  { src = "https://github.com/Saghen/blink.cmp" },
  -- koleksi snippet vscode-style (cw -> Console.WriteLine, dll.),
  -- otomatis terdeteksi oleh source "snippets" milik blink.cmp
  { src = "https://github.com/rafamadriz/friendly-snippets" },
  { src = "https://github.com/seblyng/roslyn.nvim" },
  -- notification & lsp progress message
  { src = "https://github.com/j-hui/fidget.nvim" },
  { src = "https://github.com/nvim-treesitter/nvim-treesitter" },
  { src = "https://github.com/nvim-treesitter/nvim-treesitter-textobjects" },
  -- debugging
  { src = "https://github.com/mfussenegger/nvim-dap" },
  { src = "https://github.com/nvim-neotest/nvim-nio" },
  { src = "https://github.com/rcarriga/nvim-dap-ui" },
  { src = "https://github.com/theHamsta/nvim-dap-virtual-text" },
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
require("fidget").setup({
  notification = {
    -- semua vim.notify() (mis. pesan error/warning dari nvim-dap) tampil sebagai
    -- popup di pojok kanan bawah, bukan di command line yang memicu "Press ENTER"
    override_vim_notify = true,
    -- pesan panjang dipotong, cukup sebagai penanda; detail lengkap via <leader>sna
    window = {
      max_width = 50,
    },
    configs = {
      -- ikon default "❰❰" tidak ada di font (ter-render sebagai "(("), ganti bell
      default = vim.tbl_extend("force", require("fidget.notification").default_config, {
        name = "Notifikasi",
        icon = "󰂚",
      }),
    },
  },
})
vim.keymap.set("n", "<leader>sna", function()
  require("fidget.notification").show_history()
end, { desc = "Lihat Semua Notifikasi" })
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
  ensure_installed = { "javascript", "typescript", "tsx", "html", "css", "json", "lua", "go", "dart", "c_sharp" },
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
  -- preset "enter": <CR> menerima item completion yang tersorot,
  -- tetap berfungsi sebagai newline biasa saat menu tidak tampil
  keymap = { preset = "enter" },
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
