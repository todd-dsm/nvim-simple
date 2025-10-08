-- Autocommands
-- Replicate vim-simple vimrc:182-186

local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

-- General settings group
local general = augroup("General", { clear = true })

-- Auto-remove trailing whitespace on save (all filetypes)
autocmd("BufWritePre", {
	group = general,
	pattern = "*",
	callback = function()
		-- Save cursor position
		local save_cursor = vim.fn.getpos(".")
		-- Remove trailing whitespace
		vim.cmd([[%s/\s\+$//e]])
		-- Restore cursor position
		vim.fn.setpos(".", save_cursor)
	end,
	desc = "Remove trailing whitespace on save",
})

-- Filetype detection group
local filetype_detect = augroup("FiletypeDetect", { clear = true })

-- Force .sh files to bash filetype
autocmd({ "BufRead", "BufNewFile" }, {
	group = filetype_detect,
	pattern = "*.sh",
	callback = function()
		vim.bo.filetype = "bash"
	end,
	desc = "Set .sh files to bash filetype",
})

-- Force .zsh files to zsh filetype
autocmd({ "BufRead", "BufNewFile" }, {
	group = filetype_detect,
	pattern = "*.zsh",
	callback = function()
		vim.bo.filetype = "zsh"
	end,
	desc = "Set .zsh files to zsh filetype",
})

-- Highlight on yank
autocmd("TextYankPost", {
	group = general,
	callback = function()
		vim.highlight.on_yank({ higroup = "IncSearch", timeout = 200 })
	end,
	desc = "Highlight yanked text",
})

-- Don't auto comment new lines
autocmd("BufEnter", {
	group = general,
	pattern = "*",
	callback = function()
		vim.opt.formatoptions:remove({ "c", "r", "o" })
	end,
	desc = "Disable auto-commenting new lines",
})
