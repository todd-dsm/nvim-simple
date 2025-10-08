-- Telescope configuration
-- Fuzzy finder for files, grep, buffers, and more

local status_ok, telescope = pcall(require, "telescope")
if not status_ok then
	return
end

local actions = require("telescope.actions")

telescope.setup({
	defaults = {
		prompt_prefix = "🔍 ",
		selection_caret = "➤ ",
		path_display = { "truncate" },
		mappings = {
			i = {
				["<C-j>"] = actions.move_selection_next,
				["<C-k>"] = actions.move_selection_previous,
				["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
				["<Esc>"] = actions.close,
			},
			n = {
				["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
				["q"] = actions.close,
			},
		},
		file_ignore_patterns = {
			"node_modules",
			".git/",
			"%.jpg",
			"%.jpeg",
			"%.png",
			"%.gif",
			"%.pdf",
		},
	},
	pickers = {
		find_files = {
			theme = "dropdown",
			previewer = false,
			hidden = true, -- Show hidden files
		},
		live_grep = {
			theme = "ivy",
		},
		buffers = {
			theme = "dropdown",
			previewer = false,
			initial_mode = "normal",
		},
	},
	extensions = {
		-- Add extensions here if needed
	},
})
