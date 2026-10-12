local M = {}

M.init = function()
	-- What a session stores. Compared to auto-session's recommended value this leaves out
	-- "terminal" and "blank" (no terminal buffers / empty windows come back) and "folds"
	-- (saved folds are the usual cause of restore errors after a file changed) and "localoptions":
	-- it froze per-window state such as image.nvim's `filetype=image_nvim`/`nomodifiable` and a
	-- snapshot of the lualine bars, and restoring that (picture.png) failed on every start. Filetype
	-- and the bars are set again normally when the file opens.
	vim.o.sessionoptions = "buffers,curdir,help,tabpages,winsize,winpos"
end

M.opts = {
	auto_save = true, -- save the session for the current folder on quit
	auto_restore = true, -- restore it when Neovim starts in that folder
	suppressed_dirs = { "~/", "~/Downloads", "/" },
	-- Don't save a session when the only thing open is the start screen
	bypass_save_filetypes = { "alpha" },
	-- Before saving, close windows that aren't normal files (neo-tree, terminals, AI panels, ...)
	-- so only file windows are stored and restored.
	close_unsupported_windows = true,
	-- If one part of a session fails to restore, keep restoring the rest.
	continue_restore_on_error = true,
}

return M
