local auto_session = require("alexander.plugins.auto-session.auto-session")

local M = {
	{
		-- Saves open files and window layout per project folder and restores them on start.
		-- :AutoSession restore / save / delete / search
		"rmagatti/auto-session",
		lazy = false, -- docs: must load at startup to restore the session
		init = auto_session.init,
		opts = auto_session.opts,
	},
}

return M
