local M = {}

M.opts = {
	select = {
		-- `vaf` also works when the cursor is before the function on the same line
		lookahead = true,
		selection_modes = {
			["@function.outer"] = "V", -- whole lines
			["@class.outer"] = "V",
		},
	},
	move = {
		set_jumps = true, -- <C-o> jumps back after ]f / [f
	},
}

local function select(query)
	return function()
		require("nvim-treesitter-textobjects.select").select_textobject(query, "textobjects")
	end
end

local function move(fn, query)
	return function()
		require("nvim-treesitter-textobjects.move")[fn](query, "textobjects")
	end
end

-- Text objects: use after an operator (d, c, y, …) or in Visual mode, e.g.
--   vaf select a function   dif delete its body   cia change an argument   yac copy a class
M.keys = {
	{ "af", select("@function.outer"), mode = { "x", "o" }, desc = "a function" },
	{ "if", select("@function.inner"), mode = { "x", "o" }, desc = "inside function" },
	{ "ac", select("@class.outer"), mode = { "x", "o" }, desc = "a class" },
	{ "ic", select("@class.inner"), mode = { "x", "o" }, desc = "inside class" },
	{ "aa", select("@parameter.outer"), mode = { "x", "o" }, desc = "an argument (with comma)" },
	{ "ia", select("@parameter.inner"), mode = { "x", "o" }, desc = "inside argument" },
	{ "al", select("@loop.outer"), mode = { "x", "o" }, desc = "a loop" },
	{ "il", select("@loop.inner"), mode = { "x", "o" }, desc = "inside loop" },

	-- Jump between functions
	{ "]f", move("goto_next_start", "@function.outer"), mode = { "n", "x", "o" }, desc = "Next function start" },
	{ "[f", move("goto_previous_start", "@function.outer"), mode = { "n", "x", "o" }, desc = "Previous function start" },
	{ "]F", move("goto_next_end", "@function.outer"), mode = { "n", "x", "o" }, desc = "Next function end" },
	{ "[F", move("goto_previous_end", "@function.outer"), mode = { "n", "x", "o" }, desc = "Previous function end" },
}

return M
