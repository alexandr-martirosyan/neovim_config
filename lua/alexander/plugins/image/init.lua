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
	-- Inside tmux TERM_PROGRAM is "tmux"; iTerm2 also sets LC_TERMINAL, which tmux passes on.
	-- image.nvim then wraps the images for tmux (needs `allow-passthrough on` in ~/.tmux.conf).
	if program == "iTerm.app" or vim.env.LC_TERMINAL == "iTerm2" or vim.env.WT_SESSION then
		return "sixel"
	end
end

local backend = image_backend()

local M = {
	{
		"3rd/image.nvim",
		cond = backend ~= nil,
		-- Load before an image file is read (its default hijack_file_patterns). Otherwise it only loaded with
		-- neo-tree on VeryLazy, too late for `nvim picture.png` (the picture showed as raw bytes).
		event = {
			"BufReadPre *.png",
			"BufReadPre *.jpg",
			"BufReadPre *.jpeg",
			"BufReadPre *.gif",
			"BufReadPre *.webp",
			"BufReadPre *.avif",
		},
		opts = {
			backend = backend,
			processor = "magick_cli", -- uses the ImageMagick command (`magick`); no Lua rock build needed
		},
		config = function(_, opts)
			require("image").setup(opts)
			-- Inside tmux, image.nvim tunnels Sixel past tmux ("passthrough") but moves the cursor through tmux,
			-- so iTerm2 drew the picture in the wrong place and tmux painted over it (empty buffer).
			-- tmux 3.4+ built with Sixel (Homebrew's is) draws Sixel images itself, in the right pane, so send
			-- them to tmux unwrapped. Same module path as image.nvim uses ("image/utils/tmux", with slashes).
			if opts.backend == "sixel" and vim.env.TMUX then
				require("image/utils/tmux").escape = function(sequence)
					return sequence
				end
				-- Known limitation (left as is): a popup drawn over the picture's lines (e.g. the E21 notification
				-- after pressing `i`) can make tmux drop the picture; reopen the file to see it again. A redraw on
				-- WinClosed was tried and made it worse in real use.
			end
		end,
	},
}

return M
