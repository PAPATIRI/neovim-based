local cached_branch = ""
local last_check = 0

local function git_branch()
  local now = vim.loop.now()
  if now - last_check > 5000 then
    local branch = vim.fn.system({ "git", "branch", "--show-current" }):gsub("[\n\r]", "")

    if vim.v.shell_error == 0 and branch ~= "" then
      cached_branch = "\u{e725} " .. branch .. " "
    else
      cached_branch = ""
    end
    last_check = now
  end
  return cached_branch
end

local function file_type()
  local ft = vim.bo.filetype
  local icons = {
    lua             = "\u{e620}",
    dart            = "\u{e798}",
    go              = "\u{e724}",
    php             = "\u{e73d}",
    javascript      = "\u{e74e}",
    typescript      = "\u{e628}",
    javascriptreact = "\u{e7ba}",
    typescriptreact = "\u{e7ba}",
    html            = "\u{e736}",
    css             = "\u{e749}",
    json            = "\u{e60b}",
    vue             = "\u{fd42}",
    markdown        = "\u{e73e}",
  }

  if ft == "" then
    return " \u{f15b} "
  end

  return ((icons[ft] or " \u{f15b} "))
end

local function mode_icon()
  local mode = vim.fn.mode()
  local modes = {
    n       = "NORMAL ",
    i       = "INSERT ",
    v       = "VISUAL ",
    V       = "V-LINE ",
    ["\22"] = "V-BLOCK ",
    c       = "COMMAND ",
    R       = "REPLACE ",
    t       = "TERMINAL ",
  }
  return modes[mode] or (" \u{f059} " .. mode .. " ")
end

_G.sl_mode = mode_icon
_G.sl_git = git_branch
_G.sl_ft = file_type

vim.cmd([[
  highlight StatusLineModeMsg gui=bold cterm=bold
]])

local function setup_dynamic_statusline()
  local ignored_filetypes = {
    "oil",
  }
  -- Saat window aktif (sedang digunakan)
  vim.api.nvim_create_autocmd({ "WinEnter", "BufEnter" }, {
    callback = function()
      local is_floating = vim.api.nvim_win_get_config(0).relative ~= ""
      local is_ignored = vim.tbl_contains(ignored_filetypes, vim.bo.filetype)

      if is_floating or is_ignored then
        vim.opt_local.statusline = "%#Normal#"
        return
      end

      vim.opt_local.statusline = table.concat({
        "\u{e70f} ",
        "%#StatusLineModeMsg#",
        "%{v:lua.sl_mode()}",
        "%#StatusLine#",

        "%=",
        "%{v:lua.sl_ft()} %t %m%r ",

        "%=",
        "%{v:lua.sl_git()}",
        "%P ",
      })
    end,
  })

  -- Saat window tidak aktif (split screen, kursor di tempat lain)
  vim.api.nvim_create_autocmd({ "WinLeave", "BufLeave" }, {
    callback = function()
      vim.opt_local.statusline = "%= %{v:lua.sl_ft()} %t %m%r %="
    end,
  })
end

setup_dynamic_statusline()
