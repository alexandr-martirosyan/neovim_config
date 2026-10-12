local M = {}

M.opts = {}

M.config = function(_, opts)
	require("illuminate").configure(opts)
end

-- Illuminate only adds <A-n>/<A-p> itself when nothing else has taken them yet, so define them here.
M.keys = {
	{
		"<A-n>",
		function()
			require("illuminate").goto_next_reference()
		end,
		mode = "n",
		desc = "Move to next reference",
	},
	{
		"<A-p>",
		function()
			require("illuminate").goto_prev_reference()
		end,
		mode = "n",
		desc = "Move to previous reference",
	},
}

return M
