local M = {}

vim.g.copilot_nes_debounce = 500

M.opts = {
	suggestion = {
		enabled = false,
		auto_trigger = false,
	},
	panel = {
		enabled = false,
		auto_trigger = false,
	},
	-- nes = {
	-- 	enabled = true, -- requires copilot-lsp as a dependency
	-- 	auto_trigger = false,
	-- },

	-- server_opts_overrides = {
	-- 	offset_encoding = "utf-16", -- Set the offset encoding same as above, see `:h vim.lsp.start` for more info
	-- },
	-- Feel free to add other Copilot.lua options here (see docs)
}

return M
