local M = {}

M.config = function()
	local icons = require("mini.icons")
	icons.setup()
	-- This is the "magic" line that fixes other plugins
	icons.mock_nvim_web_devicons()
end

return M
