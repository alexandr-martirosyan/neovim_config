return {
	settings = {
		Lua = {
			diagnostics = { globals = { "vim" } },
			-- lazydev supplies the relevant Neovim/plugin libraries on demand.
			workspace = { checkThirdParty = false },
		},
	},
}
