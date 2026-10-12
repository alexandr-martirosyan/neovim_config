local mini_icons = require("alexander.plugins.mini-icons.mini-icons")

local M = {
	{
		"nvim-mini/mini.icons",
		version = "*",
		init = mini_icons.init,
		config = mini_icons.config,
	},
}

return M
