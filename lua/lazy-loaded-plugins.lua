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
    override_vim_notify = true,
    window = {
      max_width = 50,
    },
    configs = {
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
-- nvim-treesitter branch `main`: setup() tidak lagi menerima ensure_installed
-- ataupun highlight; instalasi parser lewat install() (async, skip yang sudah
-- ada) dan highlight harus dinyalakan manual per-buffer via vim.treesitter.start()
--
-- install() memanggil CLI `tree-sitter` via vim.system, yang di Windows tidak
-- bisa men-spawn shim .cmd buatan npm (libuv hanya bisa .exe) — arahkan PATH ke
-- tree-sitter.exe asli di dalam package tree-sitter-cli
if vim.fn.has("win32") == 1 then
  local shim = vim.fn.exepath("tree-sitter")
  if shim ~= "" and not shim:lower():match("%.exe$") then
    local pkg = vim.fs.joinpath(vim.fs.dirname(shim), "node_modules", "tree-sitter-cli")
    if vim.uv.fs_stat(vim.fs.joinpath(pkg, "tree-sitter.exe")) then
      vim.env.PATH = pkg .. ";" .. vim.env.PATH
    end
  end
end
require("nvim-treesitter").setup({})
require("nvim-treesitter").install({
  "javascript", "typescript", "tsx", "html", "css", "json", "lua", "go", "dart", "c_sharp",
})
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("TreesitterStart", { clear = true }),
  callback = function(ev)
    -- pcall: filetype tanpa parser (mis. buffer plugin) dilewati tanpa error
    if pcall(vim.treesitter.start, ev.buf) then
      vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end
  end,
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
