-- Bash-specific settings
-- Replicates vim-simple vim/after/ftplugin/sh.vim

-- Buffer-local settings for bash files
local opt = vim.opt_local

-- Indentation: 4 spaces, expandtab
opt.tabstop = 4
opt.shiftwidth = 4
opt.softtabstop = 4
opt.expandtab = true

-- Text width: 80 characters
opt.textwidth = 80

-- Comment string for commenting/uncommenting
opt.commentstring = "# %s"
