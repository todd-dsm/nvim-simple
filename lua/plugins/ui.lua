-- UI configuration: lualine status line
-- Replicates vim-simple status line components

local status_ok, lualine = pcall(require, "lualine")
if not status_ok then
	return
end

-- Custom component for buffer number
local function buffer_number()
	return "Buf:" .. vim.api.nvim_get_current_buf()
end

-- Custom component for character hex value
local function char_hex()
	local char = vim.fn.strpart(vim.fn.getline("."), vim.fn.col(".") - 1, 1)
	if char == "" then
		return ""
	end
	return string.format("0x%X", string.byte(char))
end

-- Custom component for LSP diagnostics summary
local function lsp_diagnostics()
	local errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
	local warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })

	if errors > 0 then
		return string.format("E:%d W:%d", errors, warnings)
	elseif warnings > 0 then
		return string.format("W:%d", warnings)
	else
		return "✓"
	end
end

lualine.setup({
	options = {
		icons_enabled = false,
		theme = "solarized_dark",
		component_separators = { left = "|", right = "|" },
		section_separators = { left = "", right = "" },
		disabled_filetypes = {},
		always_divide_middle = true,
		globalstatus = false,
	},
	sections = {
		-- Left side: buffer number, filename, modified/readonly flags
		lualine_a = { buffer_number },
		lualine_b = {
			{
				"filename",
				path = 0, -- Just filename
				symbols = {
					modified = "[+]",
					readonly = "[RO]",
				},
			},
		},
		lualine_c = {
			{ "fileformat" }, -- unix/dos
			{ "filetype" }, -- file type
			{ "encoding" }, -- file encoding
		},

		-- Right side: git branch, LSP diagnostics, char hex, location, progress
		lualine_x = {
			{ "branch", icon = "" }, -- Git branch
			{ lsp_diagnostics }, -- LSP diagnostics
		},
		lualine_y = {
			{ char_hex }, -- Character hex value
			{ "location" }, -- Line:Column
		},
		lualine_z = { { "progress" } }, -- File percentage
	},
	inactive_sections = {
		lualine_a = {},
		lualine_b = {},
		lualine_c = { "filename" },
		lualine_x = { "location" },
		lualine_y = {},
		lualine_z = {},
	},
	tabline = {},
	extensions = { "fugitive" },
})
