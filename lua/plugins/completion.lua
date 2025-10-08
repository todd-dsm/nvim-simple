-- Completion configuration: nvim-cmp
-- Auto-popup completion with LSP, buffer, path, and snippet sources

local cmp_status, cmp = pcall(require, "cmp")
if not cmp_status then
	return
end

local luasnip_status, luasnip = pcall(require, "luasnip")
if not luasnip_status then
	return
end

cmp.setup({
	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body)
		end,
	},

	mapping = cmp.mapping.preset.insert({
		-- Tab to select and confirm completion
		["<Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			elseif luasnip.expand_or_jumpable() then
				luasnip.expand_or_jump()
			else
				fallback()
			end
		end, { "i", "s" }),

		-- Shift-Tab to select previous
		["<S-Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			elseif luasnip.jumpable(-1) then
				luasnip.jump(-1)
			else
				fallback()
			end
		end, { "i", "s" }),

		-- Ctrl-Space to trigger completion
		["<C-Space>"] = cmp.mapping.complete(),

		-- Ctrl-e to abort
		["<C-e>"] = cmp.mapping.abort(),

		-- Enter to confirm (with replace selection)
		["<CR>"] = cmp.mapping.confirm({
			behavior = cmp.ConfirmBehavior.Replace,
			select = false, -- Only confirm explicitly selected items
		}),

		-- Scroll docs
		["<C-d>"] = cmp.mapping.scroll_docs(-4),
		["<C-f>"] = cmp.mapping.scroll_docs(4),
	}),

	sources = cmp.config.sources({
		{ name = "nvim_lsp", priority = 1000 }, -- LSP (primary source)
		{ name = "luasnip", priority = 750 }, -- Snippets
		{ name = "buffer", priority = 500, keyword_length = 3 }, -- Buffer words (after 3 chars)
		{ name = "path", priority = 250 }, -- Path completion
	}),

	formatting = {
		format = function(entry, vim_item)
			-- Source names
			vim_item.menu = ({
				nvim_lsp = "[LSP]",
				luasnip = "[Snippet]",
				buffer = "[Buffer]",
				path = "[Path]",
			})[entry.source.name]
			return vim_item
		end,
	},

	window = {
		completion = cmp.config.window.bordered(),
		documentation = cmp.config.window.bordered(),
	},

	-- Trigger completion after 2-3 characters
	completion = {
		keyword_length = 2,
		autocomplete = { require("cmp.types").cmp.TriggerEvent.TextChanged },
	},

	experimental = {
		ghost_text = false, -- Disable ghost text (can be distracting)
	},
})

-- Integrate nvim-autopairs with nvim-cmp
local cmp_autopairs = require("nvim-autopairs.completion.cmp")
cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
