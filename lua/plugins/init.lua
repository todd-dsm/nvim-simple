-- Plugin manager setup with lazy.nvim
-- Auto-bootstrap and plugin configuration

-- Auto-bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-- Plugin specifications
require("lazy").setup({
	-- Colorscheme: Solarized (classic, proven 256-color support)
	{
		"ishan9299/nvim-solarized-lua",
		lazy = false,
		priority = 1000,
		config = function()
			vim.o.background = "dark"
			-- Set Solarized options before loading
			vim.g.solarized_italic_comments = true
			vim.g.solarized_italic_keywords = false
			vim.g.solarized_italic_functions = false
			vim.g.solarized_italic_variables = false
			vim.g.solarized_contrast = true
			vim.g.solarized_borders = false
			vim.g.solarized_disable_background = false

			vim.cmd.colorscheme("solarized")

			-- Fix sign column and line number background to match body
			vim.api.nvim_create_autocmd("ColorScheme", {
				pattern = "solarized",
				callback = function()
					if vim.opt.termguicolors:get() then
						-- iTerm2: true colors - make SignColumn match Normal background
						local normal_bg = vim.api.nvim_get_hl(0, { name = "Normal" }).bg
						local lineNr_fg = vim.api.nvim_get_hl(0, { name = "LineNr" }).fg
						local cursorline_bg = vim.api.nvim_get_hl(0, { name = "CursorLine" }).bg
						vim.api.nvim_set_hl(0, "SignColumn", { fg = lineNr_fg, bg = normal_bg })
						vim.api.nvim_set_hl(0, "LineNr", { fg = lineNr_fg, bg = normal_bg })
					else
						-- Terminal.app: 256-color - match iTerm2's cursor line color
						vim.api.nvim_set_hl(0, "Normal", { ctermfg = 244, ctermbg = "NONE" })
						vim.api.nvim_set_hl(0, "SignColumn", { ctermfg = 240, ctermbg = "NONE" })
						vim.api.nvim_set_hl(0, "LineNr", { ctermfg = 240, ctermbg = "NONE" })
						-- CursorLine: use base02 (235) to match iTerm2
						vim.api.nvim_set_hl(0, "CursorLine", { ctermbg = 235 })
						vim.api.nvim_set_hl(0, "CursorLineNr", { ctermfg = 245, ctermbg = 235 })
						-- Fix Treesitter parameter highlighting (no background)
						vim.api.nvim_set_hl(0, "@variable.parameter", { ctermfg = 33, ctermbg = "NONE" })
						vim.api.nvim_set_hl(0, "@variable.parameter.bash", { link = "@variable.parameter" })
					end

					-- Fix git signs colors
					vim.api.nvim_set_hl(0, "GitSignsAdd", { link = "DiffAdd" })
					vim.api.nvim_set_hl(0, "GitSignsChange", { link = "DiffChange" })
					vim.api.nvim_set_hl(0, "GitSignsDelete", { link = "DiffDelete" })

					-- Disable spell highlighting completely
					vim.api.nvim_set_hl(0, "SpellBad", {})
					vim.api.nvim_set_hl(0, "SpellCap", {})
					vim.api.nvim_set_hl(0, "SpellRare", {})
					vim.api.nvim_set_hl(0, "SpellLocal", {})
				end,
			})

			-- Trigger the autocmd now
			vim.cmd("doautocmd ColorScheme solarized")
		end,
	},

	-- Status line: lualine
	{
		"nvim-lualine/lualine.nvim",
		event = "VeryLazy",
		config = function()
			require("plugins.ui")
		end,
	},

	-- Git integration: vim-fugitive
	{
		"tpope/vim-fugitive",
		cmd = { "Git", "G" },
	},

	-- Git signs: gitsigns.nvim
	{
		"lewis6991/gitsigns.nvim",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			require("plugins.git")
		end,
	},

	-- Text manipulation: commentary
	{
		"tpope/vim-commentary",
		event = "VeryLazy",
	},

	-- Text manipulation: surround
	{
		"tpope/vim-surround",
		event = "VeryLazy",
	},

	-- Treesitter: better syntax highlighting
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		event = { "BufReadPost", "BufNewFile" },
		config = function()
			require("plugins.treesitter")
		end,
	},

	-- Telescope: fuzzy finder
	{
		"nvim-telescope/telescope.nvim",
		branch = "0.1.x",
		dependencies = { "nvim-lua/plenary.nvim" },
		cmd = "Telescope",
		keys = {
			{ "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find files" },
			{ "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Live grep" },
			{ "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Find buffers" },
			{ "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Help tags" },
		},
		config = function()
			require("plugins.telescope")
		end,
	},

	-- LSP: nvim-lspconfig
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
		},
		config = function()
			require("plugins.lsp")
		end,
	},

	-- Formatting: conform.nvim (shfmt)
	{
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		cmd = { "ConformInfo" },
		opts = {
			formatters_by_ft = {
				sh = { "shfmt" },
				bash = { "shfmt" },
			},
			format_on_save = {
				timeout_ms = 500,
				lsp_fallback = true,
			},
			formatters = {
				shfmt = {
					prepend_args = { "-i", "4", "-bn", "-ci", "-sr" },
				},
			},
		},
	},

	-- Linting: nvim-lint (shellcheck)
	{
		"mfussenegger/nvim-lint",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			require("lint").linters_by_ft = {
				sh = { "shellcheck" },
				bash = { "shellcheck" },
			}
			-- Lint on save
			vim.api.nvim_create_autocmd({ "BufWritePost" }, {
				callback = function()
					require("lint").try_lint()
				end,
			})
		end,
	},

	-- Completion: nvim-cmp
	{
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		dependencies = {
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-nvim-lsp",
			"L3MON4D3/LuaSnip",
			"saadparwaiz1/cmp_luasnip",
		},
		config = function()
			require("plugins.completion")
		end,
	},

	-- Snippets: LuaSnip
	{
		"L3MON4D3/LuaSnip",
		version = "v2.*",
		build = "make install_jsregexp",
		dependencies = { "rafamadriz/friendly-snippets" },
		config = function()
			require("plugins.snippets")
		end,
	},
}, {
	-- Lazy.nvim options
	checker = {
		enabled = true,
		notify = false,
	},
	change_detection = {
		notify = false,
	},
})
