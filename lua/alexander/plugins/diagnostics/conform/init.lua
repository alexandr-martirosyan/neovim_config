local M = {}

M.opts = {
	formatters_by_ft = {
		lua = { "stylua" },
		css = { "prettier" },
		html = { "prettier" },
		javascript = { "prettier" },
		typescript = { "prettier" },
		javascriptreact = { "prettier" },
		typescriptreact = { "prettier" },
		json = { "prettier" },
		jsonc = { "prettier" },
		python = { "black" },
		rust = { "rustfmt" },
		-- kulala-core's LSP does not provide formatting; use Conform's built-in kulala-fmt.
		http = { "kulala-fmt" },
		toml = { "tombi" },
		-- Use the "_" filetype to run formatters on filetypes that don't
		-- have other formatters configured.
		-- ["_"] = { "trim_whitespace" },
	},
	default_format_opts = {
		lsp_format = "fallback",
	},
	-- format_on_save = {
	--   -- These options will be passed to conform.format()
	--   timeout_ms = 500,
	--   lsp_format = "fallback",
	-- },
}

M.config = function(_, opts)
	local conform = require("conform")

	-- Load the existing per-formatter modules using Neovim runtime discovery.
	-- This searches your runtime path for the formatters folder
	local formatter_files =
		vim.api.nvim_get_runtime_file("lua/alexander/plugins/diagnostics/conform/formatters/*.lua", true)

	for _, filepath in ipairs(formatter_files) do
		-- Extract the filename (formatter name) without extension
		local formatter = vim.fn.fnamemodify(filepath, ":t:r")

		-- Require it safely
		conform.formatters[formatter] = require("alexander.plugins.diagnostics.conform.formatters." .. formatter)
	end

	conform.setup(opts)
end

M.keys = {
	{
		"<leader>fm",
		function()
			require("conform").format({
				lsp_format = "fallback",
				stop_after_first = true,
			})
		end,
		mode = "n",
		desc = "general format file",
	},
}

return M
