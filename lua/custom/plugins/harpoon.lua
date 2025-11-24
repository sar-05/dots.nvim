return {
  'ThePrimeagen/harpoon',
  branch = 'harpoon2',
  dependencies = { 'nvim-lua/plenary.nvim' },
  keys = {
    {
      '<leader>a',
      function()
        require('harpoon'):list():add()
      end,
      desc = 'Add to harpoon',
    },
    {
      '<leader>h',
      function()
        require('harpoon').ui:toggle_quick_menu(require('harpoon'):list())
      end,
      desc = 'Open harpoon menu',
    },
    {
      '<C-1>',
      function()
        require('harpoon'):list():select(1)
      end,
      desc = 'Switch to harpoon #1',
    },
    {
      '<C-2>',
      function()
        require('harpoon'):list():select(2)
      end,
      desc = 'Switch to harpoon #2',
    },
    {
      '<C-3>',
      function()
        require('harpoon'):list():select(3)
      end,
      desc = 'Switch to harpoon #3',
    },
    {
      '<C-4>',
      function()
        require('harpoon'):list():select(4)
      end,
      desc = 'Switch to harpoon #4',
    },
  },
}
