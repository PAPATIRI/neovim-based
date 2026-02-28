local base_capabilities = vim.lsp.protocol.make_client_capabilities()

-- folding setting & enable snippet dan auto import
base_capabilities.textDocument.foldingRange = {
  dynamicRegistration = false,
  lineFoldingOnly = true
}

local capabilities = require('blink.cmp').get_lsp_capabilities(base_capabilities)

capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.resolveSupport = {
  properties = { "documentation", "detail", "additionalTextEdits" }
}

-- flutter & dart lsp
require("flutter-tools").setup({
  ui = { border = "rounded" },
  decorations = { statusline = { app_version = true, device = true } },
  debugger = {
    enabled = true,
    run_via_dap = true
  },
  lsp = {
    capabilities = capabilities,
  },
})

-- golang lsp
vim.lsp.config.gopls = {
  cmd = { "gopls" },
  capabilities = capabilities,
  root_markers = { "go.work", "go.mod", ".git" },
  settings = {
    gopls = {
      analyses = {
        unusedparams = true,
      },
      staticcheck = true,
      gofumpt = true
    }
  }
}
vim.lsp.enable("gopls")

-- lua lsp
vim.lsp.config.lua_ls = {
  cmd = { "lua-language-server" },
  capabilities = capabilities,
  settings = {
    Lua = {
      runtime = { version = "LuaJIT" },
      workspace = {
        library = { vim.env.VIMRUNTIME },
        checkThirdParty = false
      },
      telemetry = { enable = false }
    },
  },
}
vim.lsp.enable("lua_ls")

-- typescript lsp
vim.lsp.config.ts_ls = {
  cmd = { "typescript-language-server", "--stdio" },
  capabilities = capabilities,
  root_markers = { "package.json", "tsconfig.json", "jsconfig.json", ".git" },
  settings = {
    typescript = {
      suggest = {
        includeCompletionsForImportStatements = true
      }
    },
    javascript = {
      suggest = {
        includeCompletionsForImportStatements = true
      }
    }
  }
}
vim.lsp.enable("ts_ls")

-- tailwindcss lsp
vim.lsp.config.tailwindcss = {
  cmd = { "tailwindcss-language-server", "--stdio" },
  capabilities = capabilities,
  root_markers = { "tailwind.config.js", "tailwind.config.ts", "postcss.config.js" },
  settings = {
    tailwindCSS = {
      experimental = {
        classRegex = {
          { "cva\\(([^)]*)\\)", "[\"'`]([^\"'`]*).*?[\"'`]" },
          { "cx\\(([^)]*)\\)",  "(?:'|\"|`)([^']*)(?:'|\"|`)" }
        },
      },
    },
  }
}
vim.lsp.enable("tailwindcss")

-- emmet lsp
vim.lsp.config.emmet_language_server = {
  cmd = { "emmet-language-server", "--stdio" },
  capabilities = capabilities,
  filetypes = {
    "css", "html", "javascript", "javascriptreact",
    "less", "sass", "scss", "typescriptreact"
  },
  init_options = {
    showExpandedAbbreviation = "always",
    showAbbreviationSuggestions = true
  }
}
vim.lsp.enable("emmet_language_server")

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    -- completion
    vim.bo[args.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

    -- mapping ketika lsp di attach
    local map = function(keys, func)
      vim.keymap.set("n", keys, func, { buffer = args.buf })
    end

    map("K", vim.lsp.buf.hover)
    map("gd", vim.lsp.buf.definition)
    map("gD", vim.lsp.buf.declaration)
    map("gi", vim.lsp.buf.implementation)
    map("gr", vim.lsp.buf.references)
    map("<leader>rn", vim.lsp.buf.rename)
    map("<leader>ca", vim.lsp.buf.code_action)
  end,
})
