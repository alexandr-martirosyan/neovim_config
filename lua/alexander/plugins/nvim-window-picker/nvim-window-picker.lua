local M = {}

M.opts = {
	filter_rules = {
		include_current_win = false,
		autoselect_one = true,
		-- filter using buffer options
		bo = {
			-- if the file type is one of following, the window will be ignored
			filetype = { 'NvimTree', 'neo-tree', 'neo-tree-popup', 'notify' },
			-- if the buffer type is one of following, the window will be ignored
			buftype = { 'terminal', "quickfix" },
		},
	},
}

-- TODO: MAYBE needs to be configured after, it is just initial config
return M
