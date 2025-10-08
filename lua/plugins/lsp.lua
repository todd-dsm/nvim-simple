-- LSP configuration
-- Native LSP + bash-language-server + none-ls for shellcheck/shfmt

-- Enhanced capabilities with nvim-cmp
local cmp_nvim_lsp_status, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
local capabilities = vim.lsp.protocol.make_client_capabilities()
if cmp_nvim_lsp_status then
	capabilities = cmp_nvim_lsp.default_capabilities()
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

	-- Note: Format on save is now handled by conform.nvim
	-- Linting is handled by nvim-lint (both configured in lua/plugins/init.lua)
end

-- Set up LspAttach autocmd to apply keybindings when LSP attaches
vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(args)
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		if client then
			on_attach(client, args.buf)
		end
	end,
})

-- Bash Language Server setup
-- Use new vim.lsp.config API if available (Neovim 0.11+), fallback to lspconfig
if vim.lsp.config then
	-- Neovim 0.11+ native configuration
	vim.lsp.config.bashls = {
		cmd = { "bash-language-server", "start" },
		filetypes = { "sh", "bash" },
		root_markers = { ".git" },
		capabilities = capabilities,
	}
	vim.api.nvim_create_autocmd("FileType", {
		pattern = { "sh", "bash" },
		callback = function(args)
			vim.lsp.enable("bashls", args.buf)
		end,
	})
else
	-- Fallback to lspconfig for older Neovim versions
	local lspconfig_status, lspconfig = pcall(require, "lspconfig")
	if lspconfig_status then
		lspconfig.bashls.setup({
			on_attach = on_attach,
			capabilities = capabilities,
			filetypes = { "sh", "bash" },
		})
	end
end

-- Formatting and linting are now handled by:
-- - conform.nvim for formatting (shfmt)
-- - nvim-lint for linting (shellcheck)
-- See lua/plugins/init.lua for configuration

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
