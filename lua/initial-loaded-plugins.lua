require("mini.pick").setup()
require("mini.icons").setup()
require("mason").setup({
  registries = {
    "github:mason-org/mason-registry",
    "github:Crashdummyy/mason-registry",
  },
})
require("mini.sessions").setup({
  directory = vim.fn.stdpath("data") .. "/sessions",
  autowrite = true,
})

local function oil_title()
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
  local icon = ok and mini_icons.get("directory", "") or ""

  return " " .. icon .. " " .. display_path .. " "
end

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
    get_win_title = oil_title,
  },
})
