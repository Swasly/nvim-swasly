# Requirements:
- ripgrep (rg)
- fdfind (fd)
- curl
- git
- lua-language-server
- jedi-language-server OR basedpyright
- pipx (to install some of the above)

# Plugins
- lazy.nvim
- nvim-lspconfig
- mini
- blink
- telescope
- treestitter
- catppuccin
- render-markdown

# Custom Shortcuts
- telescope
    - \<space>fd -> find_files cwd
    - \<space>fh -> search help
    - \<space>fg -> multigrep ("\<space>\<space>" to do filter of search)
    - \<space>en -> search neovim config
    - \<space>ep -> search neovim plugins
    - \<space>vb -> search veloce build infra + cwd, ignore veloce.med, veloce.wave dirs
- mini.files
    - "-" -> "lua MiniFiles.open()"
- vim
    - \<space>\<space>x -> source the current buffer
    - \<space>x -> source the current line
    - "v" <space>x -> source all selected lines
    - <M-j> move down in quickfix list ":cnext"
    - <M-k> moce up in quickfix list ":cprev"
    - <space>st -> open small terminal

