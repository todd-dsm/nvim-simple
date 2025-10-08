-- Treesitter configuration
-- Better syntax highlighting for bash and future languages

local status_ok, treesitter = pcall(require, "nvim-treesitter.configs")
if not status_ok then
	return
end

treesitter.setup({
	-- Install parsers for these languages
	ensure_installed = {
		"bash",
		"lua",
		"vim",
		"vimdoc",
		"markdown",
		-- Future languages (uncomment when needed):
		-- "python",
		-- "dockerfile",
	},

	-- Auto-install missing parsers when entering buffer
	auto_install = true,

	-- Highlighting
	highlight = {
		enable = true,
		additional_vim_regex_highlighting = false,
	},

	-- Indentation based on treesitter
	indent = {
		enable = true,
	},

	-- Incremental selection
	incremental_selection = {
		enable = true,
		keymaps = {
			init_selection = "<CR>",
			node_incremental = "<CR>",
			scope_incremental = "<S-CR>",
			node_decremental = "<BS>",
		},
	},
})
