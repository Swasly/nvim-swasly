return {
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      "saghen/blink.cmp",
      {
        "folke/lazydev.nvim",
        ft = "lua", -- only load on lua files
        opts = {
          library = {
            -- See the configuration section for more details
            -- Load luvit types when the `vim.uv` word is found
            { path = "${3rd}/luv/library", words = { "vim%.uv" } },
          },
        },
      },
    },
    config = function()
      -- enable virtual text
      -- virtual text are the diagnostic message served by the LSP on RHS of code
      vim.diagnostic.config({ virtual_text = true })

      -- get capabilities of blink auto complete, later inform each lsp of these capabilities
      local capabilities = require('blink.cmp').get_lsp_capabilities()


      -- see :help lspconfig-server-configurations for a list of supported LSPs
      -- startup for lua-language-server
      require("lspconfig").lua_ls.setup({ capablities = capabilities })

      -- startup for basedpyright. best so far :)
      -- should also try jedi and/or anakin
      -- require 'lspconfig'.basedpyright.setup {}
      require 'lspconfig'.jedi_language_server.setup { capablities = capabilities }

      -- when a buffer and an lsp attach, do the following
      vim.api.nvim_create_autocmd('LspAttach', {
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if not client then return end
          if client:supports_method('textDocument/formatting') then
            -- Format the current buffer on save
            vim.api.nvim_create_autocmd('BufWritePre', {
              buffer = args.buf,
              callback = function()
                vim.lsp.buf.format({ bufnr = args.buf, id = client.id })
              end,
            })
          end
        end,
      })
    end,
  }
}
