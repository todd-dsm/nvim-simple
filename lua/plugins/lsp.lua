-- LSP configuration
-- Native LSP + bash-language-server + none-ls for shellcheck/shfmt

local lspconfig_status, lspconfig = pcall(require, "lspconfig")
if not lspconfig_status then
	return
end

local cmp_nvim_lsp_status, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if not cmp_nvim_lsp_status then
	return
end

-- LSP keybindings (attached to buffers with LSP)
local on_attach = function(client, bufnr)
	local opts = { noremap = true, silent = true, buffer = bufnr }

	-- LSP navigation and actions
	vim.keymap.set("n", "gd", vim.lsp.buf.definition, vim.tbl_extend("force", opts, { desc = "Goto definition" }))
	vim.keymap.set("n", "gD", vim.lsp.buf.declaration, vim.tbl_extend("force", opts, { desc = "Goto declaration" }))
	vim.keymap.set("n", "gr", vim.lsp.buf.references, vim.tbl_extend("force", opts, { desc = "Goto references" }))
	vim.keymap.set("n", "gi", vim.lsp.buf.implementation, vim.tbl_extend("force", opts, { desc = "Goto implementation" }))
	vim.keymap.set("n", "K", vim.lsp.buf.hover, vim.tbl_extend("force", opts, { desc = "Hover documentation" }))
	vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, vim.tbl_extend("force", opts, { desc = "Signature help" }))
	vim.keymap.set(
		"n",
		"<leader>rn",
		vim.lsp.buf.rename,
		vim.tbl_extend("force", opts, { desc = "Rename symbol" })
	)
	vim.keymap.set(
		"n",
		"<leader>ca",
		vim.lsp.buf.code_action,
		vim.tbl_extend("force", opts, { desc = "Code actions" })
	)

	-- Diagnostic navigation
	vim.keymap.set(
		"n",
		"]d",
		vim.diagnostic.goto_next,
		vim.tbl_extend("force", opts, { desc = "Next diagnostic" })
	)
	vim.keymap.set(
		"n",
		"[d",
		vim.diagnostic.goto_prev,
		vim.tbl_extend("force", opts, { desc = "Previous diagnostic" })
	)
	vim.keymap.set(
		"n",
		"<leader>d",
		vim.diagnostic.open_float,
		vim.tbl_extend("force", opts, { desc = "Show diagnostic" })
	)

	-- Format on save (for LSP servers that support formatting)
	if client.supports_method("textDocument/formatting") then
		vim.api.nvim_create_autocmd("BufWritePre", {
			buffer = bufnr,
			callback = function()
				vim.lsp.buf.format({ bufnr = bufnr })
			end,
		})
	end
end

-- Enhanced capabilities with nvim-cmp
local capabilities = cmp_nvim_lsp.default_capabilities()

-- Bash Language Server setup
lspconfig.bashls.setup({
	on_attach = on_attach,
	capabilities = capabilities,
	filetypes = { "sh", "bash" },
})

-- none-ls setup for shellcheck and shfmt
local null_ls_status, null_ls = pcall(require, "null-ls")
if null_ls_status then
	null_ls.setup({
		sources = {
			-- Shellcheck: Linting
			null_ls.builtins.diagnostics.shellcheck.with({
				-- Only lint on save (not on text changed)
				method = null_ls.methods.DIAGNOSTICS_ON_SAVE,
			}),
			-- Shfmt: Formatting
			null_ls.builtins.formatting.shfmt.with({
				extra_args = { "-i", "4", "-bn", "-ci", "-sr" }, -- 4 spaces, binary ops on next line, switch cases indent, redirect follows command
			}),
		},
		on_attach = on_attach,
	})
end

-- Diagnostic configuration
vim.diagnostic.config({
	virtual_text = {
		prefix = "●",
		source = "if_many",
	},
	signs = true,
	underline = true,
	update_in_insert = false,
	severity_sort = true,
	float = {
		border = "rounded",
		source = "always",
		header = "",
		prefix = "",
	},
})

-- Diagnostic signs
local signs = { Error = "✘", Warn = "▲", Hint = "⚑", Info = "»" }
for type, icon in pairs(signs) do
	local hl = "DiagnosticSign" .. type
	vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

-- Future language servers can be added here:
-- Example for Python:
-- lspconfig.pyright.setup({
--     on_attach = on_attach,
--     capabilities = capabilities,
--     settings = {
--         python = {
--             analysis = {
--                 typeCheckingMode = "basic",
--             },
--         },
--     },
-- })
