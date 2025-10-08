-- Global keybindings
-- Preserve muscle memory from vim-simple (`,` leader)

local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Set leader key to comma (CRITICAL: preserve muscle memory)
vim.g.mapleader = ","
vim.g.maplocalleader = ","

-- Editor controls (MUST preserve these from vim-simple)
keymap("n", "<leader>N", function()
	vim.opt.number = not vim.opt.number:get()
end, { desc = "Toggle line numbers" })

keymap("n", "<leader>l", function()
	vim.opt.list = not vim.opt.list:get()
end, { desc = "Toggle invisible characters" })

keymap("n", "<leader>.", ":nohlsearch<CR>", { desc = "Clear search highlighting", silent = true })

keymap("n", "<F2>", function()
	vim.opt.paste = not vim.opt.paste:get()
end, { desc = "Toggle paste mode" })

-- Git integration (preserve for muscle memory)
-- Note: These will be implemented via vim-fugitive plugin
keymap("n", "<leader>gs", ":Git status<CR>", { desc = "Git status" })
keymap("n", "<leader>gd", ":Git diff<CR>", { desc = "Git diff" })
keymap("n", "<leader>gb", ":Git blame<CR>", { desc = "Git blame" })

-- Modern Telescope keybindings (fuzzy finder)
keymap("n", "<leader>ff", "<cmd>Telescope find_files<CR>", { desc = "Find files" })
keymap("n", "<leader>fg", "<cmd>Telescope live_grep<CR>", { desc = "Live grep" })
keymap("n", "<leader>fb", "<cmd>Telescope buffers<CR>", { desc = "Find buffers" })
keymap("n", "<leader>fh", "<cmd>Telescope help_tags<CR>", { desc = "Help tags" })

-- LSP keybindings (will be set up in LSP config as well)
keymap("n", "gd", vim.lsp.buf.definition, { desc = "Goto definition" })
keymap("n", "gr", vim.lsp.buf.references, { desc = "Goto references" })
keymap("n", "K", vim.lsp.buf.hover, { desc = "Hover documentation" })
keymap("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename symbol" })
keymap("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code actions" })

-- Diagnostic navigation
keymap("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
keymap("n", "[d", vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })

-- Better window navigation
keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
keymap("n", "<C-l>", "<C-w>l", opts)

-- Better indenting
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- Move text up and down
keymap("v", "J", ":m '>+1<CR>gv=gv", opts)
keymap("v", "K", ":m '<-2<CR>gv=gv", opts)
