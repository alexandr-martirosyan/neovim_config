local illuminate = require("alexander.plugins.illuminate.vim-illuminate")

local M = {
	"RRethy/vim-illuminate",
	event = "BufEnter",
	keys = illuminate.keys,
	config = illuminate.config,
}

return M
