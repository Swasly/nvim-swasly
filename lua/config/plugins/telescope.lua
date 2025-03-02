return {
  {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.8',
    dependencies = {
      'nvim-lua/plenary.nvim',
      -- make fzf faster
      { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' }
    },
    config = function()
      require('telescope').setup {
        pickers = {
          find_files = {
            theme = "ivy"
          }
        },
        extensions = {
          fzf = {}
        }
      }

      -- load fzf-native extension
      require('telescope').load_extension('fzf')

      -- fzf files under cwd:
      vim.keymap.set("n", "<space>fd", require('telescope.builtin').find_files, { desc = "telescope search cwd" })
      -- fzf help:
      vim.keymap.set("n", "<space>fh", require('telescope.builtin').help_tags, { desc = "telescope search nvim help" })
      -- fzf files in the neovim config directory:
      vim.keymap.set("n", "<space>en", function()
          require('telescope.builtin').find_files {
            cwd = vim.fn.stdpath("config")
          }
        end,
        { desc = "telescope search nvim config" })
      -- fzf files in neovim lazy plugins dir
      vim.keymap.set("n", "<space>ep", function()
          require('telescope.builtin').find_files {
            cwd = vim.fs.joinpath(vim.fn.stdpath("data"), "lazy")
          }
        end,
        { desc = "telescope search nvim plugins" })

      -- fzf files in p4 area $STEM/src/emu
      vim.keymap.set("n", "<space>fe", function()
          if vim.env.STEM then
            print(vim.fs.joinpath(vim.env.STEM, "/src/emu"))
            require('telescope.builtin').find_files {
              cwd = vim.fs.joinpath(vim.env.STEM, "/src/emu")
            }
          else
            print("$STEM is not defined!")
          end
        end,
        { desc = "telescope search p4 emu setup" })

      -- fzf for files related to veloce build area:
      -- DOES NOT SEARCH:
      -- - veloce.wave directory
      -- - veloce.med directory
      vim.keymap.set("n", "<space>vs", function()
          local find_command = { "rg", "--files", "--color=never", "--no-heading", "--with-filename", "--line-number",
            "--column",
            "--smart-case", "--glob=!*veloce.med*", "--glob=!*veloce.wave*" }

          if not vim.env.STEM then
            print("ERR: $STEM is not set")
            return nil
          end

          local stem = vim.env.STEM
          local search_dirs = { "/src/emu", "/import/", "_env" }

          for i = #search_dirs, 1, -1 do
            search_dirs[i] = vim.fs.joinpath(stem, search_dirs[i])
            if vim.fn.isdirectory(search_dirs[i]) == 0 then
              table.remove(search_dirs, i)
            end
          end

          if IS_VEL_BUILD_DIR == 1 then
            table.insert(search_dirs, 1, vim.fn.getcwd())
          end

          require("telescope.builtin").find_files {
            --cwd = search_dirs[1],
            cwd = stem,
            find_command = find_command,
            search_dirs = search_dirs
          }
        end,
        { desc = "telescope search p4 veloce areas" })

      require "config.telescope.multigrep".setup()
    end,
  },
}
