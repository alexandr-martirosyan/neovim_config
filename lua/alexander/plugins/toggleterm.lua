local M = {
	{
		'akinsho/toggleterm.nvim',
		version = "*",
		cmd = { 'ToggleTerm' },
		opts = require("alexander.configs.plugins.toggleterm").opts
	}
}

return M
