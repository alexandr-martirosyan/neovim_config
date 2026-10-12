-- Pick the image protocol from the terminal, so the same config works on macOS, Linux and WSL.
--   kitty protocol: kitty, Ghostty, WezTerm
--   sixel: iTerm2 (macOS), Windows Terminal (also when running WSL inside it)
-- Any other terminal: image.nvim stays disabled (installed, just not loaded).
local function image_backend()
	local term, program = vim.env.TERM or "", vim.env.TERM_PROGRAM or ""
	if vim.env.KITTY_WINDOW_ID or term == "xterm-kitty" or term == "xterm-ghostty" or program == "ghostty" then
		return "kitty"
	end
	if program == "WezTerm" then
		return "kitty"
	end
	if program == "iTerm.app" or vim.env.WT_SESSION then
		return "sixel"
	end
end

local backend = image_backend()

local M = {
	{
		"3rd/image.nvim",
		cond = backend ~= nil,
		opts = {
			backend = backend,
			processor = "magick_cli", -- uses the ImageMagick command (`magick`); no Lua rock build needed
		},
	},
}

return M
