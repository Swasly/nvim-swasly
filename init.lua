-- check the nvim runpaths for the lazy.lua file
-- Try: ':echo nvim_list_runtime_paths()'
-- this particular file lives at /home/wtonks/.config/nvim-wtonks/lua/config/lazy.lua
require("config.lazy")

vim.opt.number = true
vim.opt.relativenumber = false

-- enable nerd font (if terminal has it installed)
-- TODO: nerd font is not working :(
vim.g.have_nerd_font = true

vim.g.termguicolors = 1

-- setup vim opts
-- indent size
vim.opt.shiftwidth = 4
-- set clipboard to system clipboard (hooray!!!)
vim.opt.clipboard = "unnamedplus"

-- shortcut for ":source %" (source the current buffer)
vim.keymap.set("n", "<space><space>x", "<cmd>source %<CR>", { desc = "nvim source the current buffer" })

-- shortcut for ":.lua" (run the current line)
vim.keymap.set("n", "<space>x", ":.lua<CR>", { desc = "nvim source line" })
vim.keymap.set("v", "<space>x", ":lua<CR>", { desc = "nvim source selected line(s)" })

-- shortcuts to move up and down in the qf list
-- (populate qf list w/ <C-q> in telescope results)
vim.keymap.set("n", "<M-j>", "<cmd>cnext<CR>")
vim.keymap.set("n", "<M-k>", "<cmd>cprev<CR>")

-- Highlight when yanking text
-- See ':help vim.highlight.on_yank()'
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking text',
  group = vim.api.nvim_create_augroup('brief-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Run below commands whenever vim terminal is opened
vim.api.nvim_create_autocmd('TermOpen', {
  desc = 'Turn off number options when opening terminal',
  group = vim.api.nvim_create_augroup('term-open-custom', { clear = true }),
  callback = function()
    vim.opt.number = false
    vim.opt.relativenumber = false
  end,
})

-- open a small terminal on the bottom of the screen
-- save the job_id of the terminal so we can send commands to it later
local term_job_id = 0
vim.keymap.set("n", "<space>st", function()
    vim.cmd.vnew()
    vim.cmd.term()
    vim.cmd.wincmd("J")
    vim.api.nvim_win_set_height(0, 15)
    term_job_id = vim.bo.channel
  end,
  { desc = "open small terminal" })

-- shortcut to send commands to an opened terminal
vim.keymap.set("n", "<space>term", function()
  vim.fn.chansend(term_job_id, "echo hello\n")
end)

IS_VEL_BUILD_DIR = 0
if vim.fn.filereadable("veloce.config") == 1 then
  IS_VEL_BUILD_DIR = 1
end
