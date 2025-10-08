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
	-- Colorscheme: Solarized
	{
		"maxmx03/solarized.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			local ok, solarized = pcall(require, "solarized")
			if ok then
				solarized.setup({
					theme = "default", -- Use default theme
					transparent = {
						enabled = false, -- Disable transparency for better 256-color support
						pmenu = false,
						normal = false,
						normalfloat = false,
						neotree = false,
						nvimtree = false,
						whichkey = false,
						telescope = false,
						lazy = false,
					},
					on_highlights = nil,
					on_colors = nil,
					palette = "solarized", -- Use official solarized palette
					variant = "winter", -- Use winter variant for better contrast
					error_lens = {
						text = false,
						symbol = false,
					},
				})
			end
			vim.o.background = "dark"
			vim.cmd.colorscheme("solarized")
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
