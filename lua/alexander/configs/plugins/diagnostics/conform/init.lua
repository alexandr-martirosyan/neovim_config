local M = {}

M.opts = {
	formatters_by_ft = {
		lua = { "stylua" },
		css = { "prettier" },
		html = { "prettier" },
		javascript = { "prettier" },
		typescript = { "prettier" },
		rust = { "rustfmt" },
		-- dockerfile = { "dockerls" },
		-- Use the "*" filetype to run formatters on all filetypes.
		["*"] = { "codespell" },
		-- Use the "_" filetype to run formatters on filetypes that don't
		-- have other formatters configured.
		-- ["_"] = { "trim_whitespace" },
	},
	-- format_on_save = {
	--   -- These options will be passed to conform.format()
	--   timeout_ms = 500,
	--   lsp_fallback = true,
	-- },
}

M.config = function(_, opts)
	local conform = require("conform")

	local lfs = require("lfs")
	local path = vim.fn.expand("~/.config/nvim/lua/alexander/configs/plugins/diagnostics/conform/formatters")
	for file in lfs.dir(path) do
		if file:match("%.lua$") then -- Check if the file ends with `.lua`
			local formatter = file:gsub("%.lua$", "") -- Remove `.lua`
			conform.formatters[formatter] =
				require("alexander/configs/plugins/diagnostics/conform/formatters." .. formatter)
		end
	end

	conform.setup(opts)
end

return M
