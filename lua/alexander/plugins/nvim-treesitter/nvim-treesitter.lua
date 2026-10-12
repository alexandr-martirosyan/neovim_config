local M = {}

-- Install every available parser, as the old `ensure_installed = "all"` did.
-- ("all" skips parsers upstream marks as unsupported.) Kulala still manages its
-- own kulala_http parser and queries.
M.parsers = "all"
M.opts = {}

M.build = function()
	local treesitter = require("nvim-treesitter")
	-- Building every parser from source takes a while on first install.
	treesitter.install(M.parsers):wait(1800000)
	-- With no arguments, update() refreshes every installed parser.
	treesitter.update():wait(1800000)
end

-- Build every missing parser once, in the background, after an interactive start.
-- install() skips parsers that are already built. The stamp file stops failed
-- parsers from being retried on every launch; delete it to run this again.
M.install_missing_once = function()
	local stamp = vim.fn.stdpath("state") .. "/treesitter-install-all.done"
	if vim.uv.fs_stat(stamp) then
		return
	end
	vim.defer_fn(function()
		if #vim.api.nvim_list_uis() == 0 then
			return -- skip headless runs
		end
		vim.notify("Treesitter: building missing parsers in the background…")
		require("nvim-treesitter").install(M.parsers, { summary = true }):await(function(err)
			if err then
				return -- interrupted; try again next launch
			end
			local file = io.open(stamp, "w")
			if file then
				file:write(os.date("%Y-%m-%d %H:%M:%S"))
				file:close()
			end
		end)
	end, 2000)
end

M.config = function(_, opts)
	require("nvim-treesitter").setup(opts)
	M.install_missing_once()
	-- These chat buffers contain Markdown, not a separate grammar.
	vim.treesitter.language.register("markdown", { "Avante", "codecompanion", "kulala_ui" })
	local group = vim.api.nvim_create_augroup("AlexanderTreesitter", { clear = true })
	vim.api.nvim_create_autocmd("FileType", {
		group = group,
		callback = function(args)
			if
				vim.bo[args.buf].buftype ~= "" and not vim.tbl_contains({ "Avante", "codecompanion", "kulala_ui" }, args.match)
			then
				return
			end
			local lang = vim.treesitter.language.get_lang(args.match)
			if not lang then
				return
			end
			local ok, available = pcall(vim.treesitter.language.add, lang)
			if not ok or not available then
				return
			end
			vim.treesitter.start(args.buf, lang)
			if vim.bo[args.buf].buftype == "" and vim.treesitter.query.get(lang, "indents") then
				vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
			end
		end,
	})
end

return M
