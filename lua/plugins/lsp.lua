local tools = {
  'clangd',
  'ruff', -- Provides formatting, linting, diagnostics and code actions for Python
  'ty', -- Provides type checking, autocompletions and other capabilities for Python
  'pyright', -- Provides some LSP features which Ruff lacks, such as renaming variables.
  'taplo', -- LSP for TOML
  'bashls', -- LSP for Bash
  'jsonls', -- LSP for JSON files.
  'lua_ls', -- Lua LSP
  'markdownlint', -- Linter for markdown files.
  'gitlint', -- Linter for gitcommit files.
}

-- Add custom configuration per LSP with vim.lsp.config

vim.pack.add {
  { src = 'https://github.com/mason-org/mason.nvim' },
  { src = 'https://github.com/neovim/nvim-lspconfig' },
  { src = 'https://github.com/mason-org/mason-lspconfig.nvim' },
  { src = 'https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim' },
  { src = 'https://github.com/j-hui/fidget.nvim.git' },
  {
    src = 'https://github.com/saghen/blink.cmp.git',
    version = vim.version.range '^1',
  },
  { src = 'https://github.com/folke/lazydev.nvim.git' },
}

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('my.lsp', {}),
  callback = function(args)
    local client = assert(vim.lsp.get_client_by_id(args.data.client_id))

    -- Auto-format ("lint") on save.
    -- Usually not needed if server supports "textDocument/willSaveWaitUntil".
    if not client:supports_method 'textDocument/willSaveWaitUntil' and client:supports_method 'textDocument/formatting' then
      vim.api.nvim_create_autocmd('BufWritePre', {
        group = vim.api.nvim_create_augroup('my.lsp', { clear = false }),
        buffer = args.buf,
        callback = function()
          vim.lsp.buf.format { bufnr = args.buf, id = client.id, timeout_ms = 1000 }
        end,
      })
    end
  end,
})

require('mason').setup()
require('mason-lspconfig').setup { -- Automatically enables LSPs thorugh vim.lsp.enable()
  ensure_installed = {}, -- Explicitly set to an empty table (populate installs via mason-tool-installer)
}
require('mason-tool-installer').setup { ensure_installed = tools }
require('lazydev').setup {}
require('blink.cmp').setup {
  sources = {
    per_filetype = { lua = { inherit_defaults = true, 'lazydev' } },
  },
}
vim.lsp.config.capabilities = vim.lsp.protocol.make_client_capabilities()

require('fidget').setup {}
