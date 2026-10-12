local group = vim.api.nvim_create_augroup("AlexanderEditor", { clear = true })

vim.api.nvim_create_autocmd("BufEnter", {
	group = group,
	callback = function()
		vim.opt_local.formatoptions:remove({ "c", "r", "o" })
	end,
})

local function highlights()
	-- Visible separator between all windows (was #313244, almost the same as the background)
	vim.api.nvim_set_hl(0, "WinSeparator", { fg = "#6e738d", bg = "NONE" })
	-- Neo-tree uses its own separator group; Catppuccin paints it in the background colour (invisible)
	vim.api.nvim_set_hl(0, "NeoTreeWinSeparator", { fg = "#6e738d", bg = "NONE" })
	vim.api.nvim_set_hl(0, "LualineMessagePill", { bg = "#363a4f", fg = "#cad3f5" })
	vim.api.nvim_set_hl(0, "CmpItemKindCopilot", { fg = "#6CC644" })
	vim.api.nvim_set_hl(0, "BlinkCmpKindCopilot", { fg = "#6CC644" })
end
highlights()
vim.api.nvim_create_autocmd("ColorScheme", { group = group, callback = highlights })

-- When a real file is opened, drop leftover empty "[No Name]" buffers that no window shows
-- (e.g. the placeholder neo-tree creates when `nvim .` opens a folder), so they don't sit in the
-- buffer list. Only unnamed, unmodified, completely empty, normal buffers are removed.
vim.api.nvim_create_autocmd("BufEnter", {
	group = group,
	callback = function(ev)
		if vim.bo[ev.buf].buftype ~= "" or vim.api.nvim_buf_get_name(ev.buf) == "" then
			return
		end
		vim.schedule(function()
			for _, buf in ipairs(vim.api.nvim_list_bufs()) do
				if
					buf ~= ev.buf
					and vim.api.nvim_buf_is_valid(buf)
					and vim.bo[buf].buflisted
					and vim.bo[buf].buftype == ""
					and vim.api.nvim_buf_get_name(buf) == ""
					and not vim.bo[buf].modified
					and vim.api.nvim_buf_line_count(buf) == 1
					and vim.api.nvim_buf_get_lines(buf, 0, 1, false)[1] == ""
					and #vim.fn.win_findbuf(buf) == 0
				then
					pcall(vim.api.nvim_buf_delete, buf, {})
				end
			end
		end)
	end,
})

-- Big-file protection: files over 1.5 MB, or with very long lines (minified JSON/JS), get the
-- "bigfile" filetype. Treesitter, LSP and linters have nothing for that filetype, so they stay off;
-- folds, word highlighting and indent guides are switched off for that buffer below. Basic Vim syntax
-- colours are kept. Normal files are not affected.
local bigfile = { size = 1.5 * 1024 * 1024, avg_line_length = 1000 }
vim.filetype.add({
	pattern = {
		[".*"] = {
			function(path, buf)
				if not path or not buf or vim.bo[buf].filetype == "bigfile" then
					return
				end
				local size = vim.fn.getfsize(path)
				if size <= 0 then
					return
				end
				if size > bigfile.size then
					return "bigfile"
				end
				local lines = vim.api.nvim_buf_line_count(buf)
				if (size - lines) / lines > bigfile.avg_line_length then
					return "bigfile"
				end
			end,
			{ priority = math.huge },
		},
	},
})
vim.api.nvim_create_autocmd("FileType", {
	group = group,
	pattern = "bigfile",
	callback = function(ev)
		local buf = ev.buf
		local real_ft = vim.filetype.match({ buf = buf }) or ""
		vim.notify(
			("Big file (%s): language features off for this buffer"):format(vim.fn.fnamemodify(ev.file, ":t")),
			vim.log.levels.WARN
		)
		vim.api.nvim_buf_call(buf, function()
			vim.opt_local.foldmethod = "manual"
			vim.opt_local.conceallevel = 0
		end)
		pcall(function()
			require("ufo").detach(buf)
		end)
		pcall(function()
			require("ibl").setup_buffer(buf, { enabled = false })
		end)
		vim.schedule(function()
			if vim.api.nvim_buf_is_valid(buf) then
				vim.bo[buf].syntax = real_ft -- plain Vim syntax colours only
				pcall(vim.api.nvim_buf_call, buf, function()
					require("illuminate").pause_buf()
				end)
			end
		end)
	end,
})

-- Servers that attach to every filetype (e.g. typos_lsp) would still scan a big file; detach them.
vim.api.nvim_create_autocmd("LspAttach", {
	group = group,
	callback = function(ev)
		if vim.bo[ev.buf].filetype == "bigfile" then
			vim.schedule(function()
				pcall(vim.lsp.buf_detach_client, ev.buf, ev.data.client_id)
			end)
		end
	end,
})

vim.api.nvim_create_autocmd("VimEnter", {
	group = group,
	callback = function()
		local arg = tostring(vim.fn.argv(0))
		if arg ~= "" then
			local stat = vim.uv.fs_stat(arg)
			if stat and stat.type == "directory" then
				vim.api.nvim_set_current_dir(arg)
			end
		end
	end,
})
