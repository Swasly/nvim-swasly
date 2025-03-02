return {
  --{
  --"catppuccin/nvim",
  --name = "catppuccin",
  --priority = 1000,
  --config = function()
  --vim.cmd.colorscheme "catppuccin-mocha"
  --end
  --},
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      style = "night"
    },

    config = function()
      require("tokyonight").setup({
        on_highlights = function(hl, c)
          hl.comment = {
            bg = c.none,
            fg = c.none,
          }
        end
      })
      vim.cmd.colorscheme("tokyonight")
    end
  }
}
