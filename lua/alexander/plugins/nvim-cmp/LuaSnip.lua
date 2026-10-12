local M = {}

M.opts = { history = true, updateevents = "TextChanged,TextChangedI" }

M.config = function(_, opts)
	require("luasnip").config.set_config(opts)

	local loaders = {
		{ "from_vscode", "vscode_snippets_path", { exclude = vim.g.vscode_snippets_exclude or {} } },
		{ "from_snipmate", "snipmate_snippets_path", {} },
		{ "from_lua", "lua_snippets_path", {} },
	}
	for _, loader in ipairs(loaders) do
		local options = loader[3]
		local custom_path = vim.g[loader[2]]
		local module = require("luasnip.loaders." .. loader[1])
		module.lazy_load(options)
		if custom_path and custom_path ~= "" then
			module.lazy_load(vim.tbl_extend("force", options, { paths = custom_path }))
		end
	end
	-- Keep active snippets when leaving Insert mode; Tab/Shift-Tab can resume them.
end

return M
