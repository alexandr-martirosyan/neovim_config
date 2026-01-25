local M = {}

M.opts = {}
M.build = function()
	require("dbee").install()
end
M.config = function(_, opts)
	-- require("dbee").setup(opts)
	require("dbee").setup()
end
M.cmd = { "Dbee" }

return M
