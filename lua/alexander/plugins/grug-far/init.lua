local grug_far = require("alexander.plugins.grug-far.grug-far")

local M = {
	{
		-- Project-wide find & replace with live preview (uses ripgrep)
		"MagicDuck/grug-far.nvim",
		cmd = { "GrugFar", "GrugFarWithin" },
		keys = grug_far.keys,
		opts = grug_far.opts,
	},
}

return M
