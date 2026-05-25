local M = {}

M.opts = {
	formatters = {
		kulala = {
			command = "kulala-fmt",
			args = { "format", "$FILENAME" },
			stdin = false,
		},
	},
	formatters_by_ft = {
		lua = { "stylua" },
		css = { "prettier" },
		html = { "prettier" },
		javascript = { "prettier" },
		typescript = { "prettier" },
		json = { "prettier" },
		jsonc = { "prettier" },
		python = { "black" },
		rust = { "rustfmt" },
		http = { "kulala" },
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

-- lua/alexander/plugins/diagnostics/conform/init.lua

-- TODO: this is Gemini suggested code so I need to look to it
M.config = function(_, opts)
	local conform = require("conform")

	-- IMPROVEMENT: Use native Neovim API instead of "lfs" and hardcoded paths
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

return M
