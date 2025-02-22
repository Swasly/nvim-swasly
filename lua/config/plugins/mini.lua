return {
  {
    'echasnovski/mini.nvim',
    config = function()
      require('mini.statusline').setup({ use_icons = true })
      require('mini.icons').setup()
      require('mini.files').setup()
      require('mini.deps').setup()

      vim.keymap.set("n", "-", require('mini.files').open)
    end
  },
}
