-- Preserve upstream native Deno detection, but avoid a nested Node project's
-- overlapping attachment (upstream denols currently ignores Node lockfiles).
local native_root = vim.lsp.config.denols.root_dir

return {
	root_dir = function(bufnr, on_dir)
		native_root(bufnr, function(root)
			local node_root =
				vim.fs.root(bufnr, { "package-lock.json", "yarn.lock", "pnpm-lock.yaml", "bun.lockb", "bun.lock" })
			if node_root and #node_root > #root then
				return
			end
			on_dir(root)
		end)
	end,
}
