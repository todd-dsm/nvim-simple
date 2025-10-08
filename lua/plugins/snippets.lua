-- LuaSnip configuration
-- Custom snippet engine with bash snippets

local status_ok, luasnip = pcall(require, "luasnip")
if not status_ok then
	return
end

-- LuaSnip configuration
luasnip.config.set_config({
	history = true, -- Keep last snippet local to jump back
	updateevents = "TextChanged,TextChangedI", -- Update changes as you type
	enable_autosnippets = false,
	ext_opts = {
		[require("luasnip.util.types").choiceNode] = {
			active = {
				virt_text = { { "●", "GruvboxOrange" } },
			},
		},
	},
})

-- Load custom snippets from lua/snippets/
require("luasnip.loaders.from_lua").lazy_load({ paths = { vim.fn.stdpath("config") .. "/lua/snippets" } })

-- Load friendly-snippets (optional, can be disabled if not needed)
require("luasnip.loaders.from_vscode").lazy_load()

-- Keymaps for snippet navigation (already handled in completion.lua via Tab/Shift-Tab)
-- Additional standalone keymaps:
vim.keymap.set({ "i", "s" }, "<C-j>", function()
	if luasnip.expand_or_jumpable() then
		luasnip.expand_or_jump()
	end
end, { silent = true, desc = "Expand or jump snippet" })

vim.keymap.set({ "i", "s" }, "<C-k>", function()
	if luasnip.jumpable(-1) then
		luasnip.jump(-1)
	end
end, { silent = true, desc = "Jump back in snippet" })
