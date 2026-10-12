local M = {}
local map = vim.keymap.set

M.opts = {}

-- export on_attach & capabilities
M.on_attach = function(client, bufnr)
	local function opts(desc)
		return { buffer = bufnr, desc = "LSP " .. desc }
	end

	-- Code lens: small actionable labels above lines (e.g. rust-analyzer "▶ Run test | Debug").
	-- Shown automatically when the server supports them; `grx` runs the one on the current line.
	if client:supports_method("textDocument/codeLens") then
		vim.lsp.codelens.enable(true, { bufnr = bufnr })
		map("n", "<leader>lc", function()
			vim.lsp.codelens.enable(not vim.lsp.codelens.is_enabled({ bufnr = 0 }), { bufnr = 0 })
		end, opts("Toggle code lens"))
	end

	map("n", "gh", vim.lsp.buf.hover, opts("Hover"))
	map("n", "gD", vim.lsp.buf.declaration, opts("Go to declaration"))
	map("n", "gd", vim.lsp.buf.definition, opts("Go to definition"))
	-- Kept as built-in <C-]> (user's choice). It asks the server through 'tagfunc' with a fixed 1 s
	-- limit, so a slow first lookup in a session can fall back to "E433: No tags file"; pressing it
	-- again works. To use gd's lookup instead (no limit, <C-t> still jumps back), enable:
	-- if client:supports_method("textDocument/definition") then
	-- 	map("n", "<C-]>", vim.lsp.buf.definition, opts("Go to definition"))
	-- end
	-- Neovim built-ins replace these: gri implementation, grt type definition, grn rename,
	-- gra code action, grr references. Removing them also restores built-in `gi` and makes `gr*` instant.
	-- map("n", "gi", vim.lsp.buf.implementation, opts("Go to implementation"))
	map("n", "<leader>sh", vim.lsp.buf.signature_help, opts("Show signature help"))
	map("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts("Add workspace folder"))
	map("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opts("Remove workspace folder"))

	map("n", "<leader>wl", function()
		print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
	end, opts("List workspace folders"))

	-- map("n", "<leader>D", vim.lsp.buf.type_definition, opts("Go to type definition"))
	-- map("n", "<leader>rn", vim.lsp.buf.rename, opts("Rename symbol"))

	-- map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts("Code action"))
	-- map("n", "gr", vim.lsp.buf.references, opts("Show references"))
end

-- Preserve the preference for Treesitter highlighting over semantic tokens.
M.on_init = function(client)
	client.server_capabilities.semanticTokensProvider = nil
end

M.disabled_servers = {
	-- lua_ls = true,
	-- solidity_ls_nomicfoundation = true,
}

M.config = function()
	-- M.capabilities = require("cmp_nvim_lsp").default_capabilities() -- nvim-cmp
	M.capabilities = require("blink.cmp").get_lsp_capabilities()
	M.capabilities.general = M.capabilities.general or {}
	M.capabilities.general.positionEncodings = { "utf-16" }
	vim.lsp.config("*", { capabilities = M.capabilities })

	-- Buffer mappings and highlighting policy do not override upstream server hooks.
	local group = vim.api.nvim_create_augroup("AlexanderLspAttach", { clear = true })
	vim.api.nvim_create_autocmd("LspAttach", {
		group = group,
		callback = function(args)
			local client = vim.lsp.get_client_by_id(args.data.client_id)
			if client then
				M.on_init(client)
				M.on_attach(client, args.buf)
			end
		end,
	})
end

-- M.handlers = {
--   ["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
--     -- Disable virtual_text
--     virtual_text = false,
--     underline = true,
--   }),
-- }

return M
