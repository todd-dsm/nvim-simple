-- Core editor settings
-- Replicates vim-simple vimrc:38-96

local opt = vim.opt

-- Line numbers
opt.number = true
opt.relativenumber = false

-- Search settings
opt.incsearch = true         -- Incremental search
opt.hlsearch = true          -- Highlight search results
opt.ignorecase = true        -- Case-insensitive search
opt.smartcase = true         -- Case-sensitive if uppercase present

-- Indentation
opt.tabstop = 4              -- Tab width
opt.shiftwidth = 4           -- Indent width
opt.softtabstop = 4          -- Tab width in insert mode
opt.expandtab = true         -- Convert tabs to spaces
opt.autoindent = true        -- Auto-indent new lines
opt.smartindent = true       -- Smart auto-indenting

-- Text width and visual guide
opt.textwidth = 80           -- Line length limit
opt.colorcolumn = "80"       -- Visual column guide

-- Matching brackets
opt.showmatch = true         -- Show matching brackets

-- Command history
opt.history = 1000           -- Command history size

-- No backup/swap files
opt.backup = false
opt.writebackup = false
opt.swapfile = false

-- Encoding
opt.encoding = "utf-8"
opt.fileencoding = "utf-8"

-- Cursor position always visible
opt.ruler = true             -- Show cursor position
opt.cursorline = true        -- Highlight current line

-- Always show status line
opt.laststatus = 2

-- Better display for messages
opt.cmdheight = 1

-- Enable true color support (conditionally)
-- iTerm2 supports true colors (24-bit), but Terminal.app only supports 256 colors
-- Detect terminal capabilities and set accordingly
local term = vim.env.TERM_PROGRAM or vim.env.TERM or ""
if term:match("iTerm") or vim.env.COLORTERM == "truecolor" or vim.env.COLORTERM == "24bit" then
	opt.termguicolors = true  -- iTerm2 and true color terminals
else
	opt.termguicolors = false -- Terminal.app and other 256-color terminals
	vim.cmd("set t_Co=256")   -- Force 256 color mode
end

-- Enable mouse support
opt.mouse = "a"

-- Better completion experience
opt.completeopt = { "menu", "menuone", "noselect" }

-- Update time for better UX
opt.updatetime = 300

-- Split behavior
opt.splitright = true
opt.splitbelow = true

-- Sign column always on (for LSP and git signs)
opt.signcolumn = "yes"

-- Scrolloff
opt.scrolloff = 8
opt.sidescrolloff = 8

-- Clipboard integration
opt.clipboard = "unnamedplus"
