local M = {}

M.opts = {
	fast_wrap = {},
	disable_filetype = { "TelescopePrompt", "vim" },
}
M.config = function(_, opts)
	require("nvim-autopairs").setup(opts)

	-- setup cmp for autopairs (only when nvim-cmp itself is enabled; blink.cmp adds
	-- brackets via completion.accept.auto_brackets, and blink.compat's `cmp` shim has no events)
	local cmp_plugin = require("lazy.core.config").plugins["nvim-cmp"]
	if cmp_plugin and cmp_plugin._.loaded then
		local cmp_autopairs = require("nvim-autopairs.completion.cmp")
		require("cmp").event:on("confirm_done", cmp_autopairs.on_confirm_done())
	end
end

return M
