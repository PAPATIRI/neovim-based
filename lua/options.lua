-- neovim ui basic
vim.o.number = true
vim.o.relativenumber = true
vim.o.wrap = false
vim.o.cursorline = true
vim.o.scrolloff = 10
vim.o.sidescrolloff = 10
vim.g.mapleader = " "
vim.o.winborder = "rounded"
vim.o.termguicolors = true
vim.o.signcolumn = "yes"
vim.o.fillchars = 'eob: ,fold: ,foldopen:,foldsep: ,foldinner: ,foldclose:'
vim.o.completeopt = "menuone,noinsert,noselect"
vim.o.showmode = false

-- tabwidth
vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.softtabstop = 2
vim.o.expandtab = true
vim.o.smartindent = true
vim.o.autoindent = true

-- searching & editing
vim.o.incsearch = true
vim.o.smartcase = true
vim.o.ignorecase = true
vim.opt.clipboard:append("unnamedplus")
vim.o.mouse = "a"

-- folding setting
vim.o.foldmethod = 'indent'
vim.o.foldcolumn = '0'
vim.o.foldlevel = 99
vim.o.foldlevelstart = 99
vim.o.foldenable = true

-- backup setting
local undodir = vim.fn.stdpath("data") .. "/undo"
if vim.fn.isdirectory(undodir) == 0 then
  vim.fn.mkdir(undodir, "p")
end
vim.o.swapfile = false
vim.o.backup = false
vim.o.writebackup = false
vim.o.undofile = true
vim.o.undodir = undodir
vim.o.updatetime = 300
vim.o.timeoutlen = 500
vim.o.ttimeoutlen = 0
vim.o.autoread = true
