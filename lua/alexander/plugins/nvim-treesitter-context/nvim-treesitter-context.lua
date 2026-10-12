local M = {}

M.opts = {
	max_lines = 3, -- at most 3 pinned lines; change while working with <leader>tc
	trim_scope = "outer", -- when there are more, keep the innermost (closest) ones
}

M.keys = {
	{
		"<leader>tc",
		function()
			local config = require("treesitter-context.config")
			vim.ui.input({ prompt = "Context max lines (0 = no limit): ", default = tostring(config.max_lines) }, function(input)
				local n = tonumber(input)
				if not n or n < 0 then
					return
				end
				config.max_lines = math.floor(n) -- read on every update, so it applies immediately
				vim.cmd("doautocmd <nomodeline> CursorMoved")
			end)
		end,
		mode = "n",
		desc = "Set pinned context max lines",
	},
}

return M
