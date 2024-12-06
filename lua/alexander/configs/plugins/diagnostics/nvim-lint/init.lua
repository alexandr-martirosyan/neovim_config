local M = {}

M.opts = {
	-- Event to trigger linters
	events = { "BufEnter", "BufWritePost", "BufReadPost", "InsertLeave" },
	linters_by_ft = {
		["*"] = { "typos" },
		solidity = { "solhint" },
		dockerfile = { "hadolint" },
		python = { "flake8" },
		-- javascript = { "eslint" },
		-- typescript = { "eslint" },
		-- html = { "eslint" },
		-- css = { "eslint" },
		-- Use the "*" filetype to run linters on all filetypes.
		-- ['*'] = { 'global linter' },
		-- Use the "_" filetype to run linters on filetypes that don't have other linters configured.
		-- ['_'] = { 'fallback linter' },
		-- ["*"] = { "typos" },
	},
}

M.config = function(_, opts)
	local lint = require "lint"

	lint.linters_by_ft = opts.linters_by_ft

	local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

	vim.api.nvim_create_autocmd(opts.events, {
		group = lint_augroup,
		callback = function()
			lint.try_lint()
		end,
	})
	-- maybe some code needed here
end

return M
