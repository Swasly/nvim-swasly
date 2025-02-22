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
      vim.keymap.set("n", "<space>fd", require('telescope.builtin').find_files)
      -- fzf help:
      vim.keymap.set("n", "<space>fh", require('telescope.builtin').help_tags)
      -- fzf files in the neovim config directory:
      vim.keymap.set("n", "<space>en", function()
        require('telescope.builtin').find_files {
          cwd = vim.fn.stdpath("config")
        }
      end)
      -- fzf files in neovim lazy plugins dir
      vim.keymap.set("n", "<space>ep", function()
        require('telescope.builtin').find_files {
          cwd = vim.fs.joinpath(vim.fn.stdpath("data"), "lazy")
        }
      end)

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
      end)

      -- fzf for files related to veloce build area:
      -- - cwd
      -- - $STEM/src/emu
      -- - $STEM/import/
      -- - $STEM/_env/
      -- DO NOT SEARCH:
      -- - veloce.wave directory
      -- - veloce.med directory
      vim.keymap.set("n", "<space>vb", function()
        local find_command = { "rg", "--files", "--color=never", "--no-heading", "--with-filename", "--line-number",
          "--column",
          "--smart-case", "--glob=!*veloce.med*", "--glob=!*veloce.wave*" }

        if not vim.env.STEM then
          print("$STEM is not set")
          return nil
        end

        local stem = vim.env.STEM
        local joinpath = vim.fs.joinpath
        local search_dirs = { joinpath(stem, "/src/emu"), joinpath(stem, "/import/"), joinpath(stem, "_env") }

        for i = #search_dirs, 1, -1 do
          print(search_dirs[i])
          if vim.fn.isdirectory(search_dirs[i]) == 0 then
            print("not a directory")
            table.remove(search_dirs, i)
          end
        end

        table.insert(search_dirs, vim.fn.getcwd())

        require("telescope.builtin").find_files {
          cwd = vim.fn.getcwd(),
          find_command = find_command,
          search_dirs = search_dirs
        }
      end)

      require "config.telescope.multigrep".setup()
    end,
  },
}
