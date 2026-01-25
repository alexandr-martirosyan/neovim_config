local M = {}

M.config = function(_, opts)
	require 'alpha'.setup(require 'alpha.themes.dashboard'.config)
end

-- TODO: need to be configured

return M
