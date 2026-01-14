vim.api.nvim_create_autocmd('PackChanged', {
  desc = 'Handle nvim-treesitter updates',
  group = vim.api.nvim_create_augroup('nvim-treesitter-pack-changed-update-handler', { clear = true }),
  callback = function(event)
    if event.data.kind == 'update' and event.data.spec.name == 'nvim-treesitter' then
      vim.notify('nvim-treesitter updated, running TSUpdate...', vim.log.levels.INFO)
      ---@diagnostic disable-next-line: param-type-mismatch
      local ok = pcall(vim.cmd, 'TSUpdate')
      if ok then
        vim.notify('TSUpdate completed successfully!', vim.log.levels.INFO)
      else
        vim.notify('TSUpdate command not available yet, skipping', vim.log.levels.WARN)
      end
    end
  end,
})

vim.pack.add {
  { src = 'https://github.com/nvim-treesitter/nvim-treesitter',                version = 'master' },
  { src = 'https://github.com/nvim-treesitter/nvim-treesitter-textobjects.git' }
}

require("nvim-treesitter.configs").setup({
  ensure_installed = { 'bash', 'c', 'diff', 'html', 'lua', 'luadoc', 'markdown', 'markdown_inline', 'query', 'vim', 'vimdoc' },
  -- Autoinstall languages that are not installed
  auto_install = true,
  highlight = {
    enable = true,
    -- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
    --  If you are experiencing weird indenting issues, add the language to
    --  the list of additional_vim_regex_highlighting and disabled languages for indent.
    additional_vim_regex_highlighting = { 'ruby' },
  },
  indent = { enable = true, disable = { 'ruby' } },

  textobjects = {
    select = {
      enable = true,

      -- Automatically jump forward to textobj, similar to targets.vim
      lookahead = true,

      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        -- ['af'] = '@function.outer',
        -- ['if'] = '@function.inner',
        ['af'] = '@call.outer', -- a function call
        ['if'] = '@call.inner', -- inside function call
        ['ac'] = '@class.outer',
        -- You can optionally set descriptions to the mappings (used in the desc parameter of
        -- nvim_buf_set_keymap) which plugins like which-key display
        ['ic'] = { query = '@class.inner', desc = 'Select inner part of a class region' },
        -- You can also use captures from other query groups like `locals.scm`
        ['as'] = { query = '@local.scope', query_group = 'locals', desc = 'Select language scope' },
      },
    },
  },

})

-- require('nvim-treesitter').setup {
--   auto_install = true,
--   highlight = {
--     enable = true,
--     additional_vim_regex_highlighting = false,
--   },
--   indent = {
--     enable = true,
--   },
-- }
-- require('nvim-treesitter').install { 'bash', 'c', 'python', 'json', 'diff', 'lua', 'luadoc', 'markdown', 'markdown_inline', 'query', 'vim', 'vimdoc' }

-- require("nvim-treesitter").setup {
--   textobjects = {
--     select = {
--       enable = true,
--       lookahead = true,
--       keymaps = {
--         ["af"] = "@call.outer", -- a function call
--         ["if"] = "@call.inner", -- inside function call
--         ["ai"] = "@parameter.inner",
--       },
--     },
--   },
-- }

-- TODO: Create auto
-- Set treesitter as fold expression method
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
