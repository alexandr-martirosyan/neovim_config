local M = {}

M.init = function()
	-- Any require("nvim-web-devicons") gets mini's mock, even before mini.icons has loaded.
	package.preload["nvim-web-devicons"] = function()
		require("mini.icons").mock_nvim_web_devicons()
		return package.loaded["nvim-web-devicons"]
	end
end

M.config = function()
	local icons = require("mini.icons")
	icons.setup()
	-- This is the "magic" line that fixes other plugins
	icons.mock_nvim_web_devicons()
end

return M
