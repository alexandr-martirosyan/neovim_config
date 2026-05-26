local M = {}

local function is_regular_edit_window(win)
	if not vim.api.nvim_win_is_valid(win) then
		return false
	end

	if vim.api.nvim_win_get_config(win).relative ~= "" then
		return false
	end

	local buf = vim.api.nvim_win_get_buf(win)
	local buftype = vim.api.nvim_get_option_value("buftype", { buf = buf })
	local filetype = vim.api.nvim_get_option_value("filetype", { buf = buf })
	local excluded_filetypes = {
		codecompanion = true,
		codecompanion_cli = true,
		["neo-tree"] = true,
		oil = true,
		Trouble = true,
		qf = true,
	}

	return buftype == "" and not excluded_filetypes[filetype]
end

local function open_file_in_existing_window(path)
	local current_win = vim.api.nvim_get_current_win()
	local uri = vim.uri_from_fname(path)
	local windows = vim.api.nvim_tabpage_list_wins(0)

	for _, win in ipairs(windows) do
		local buf = vim.api.nvim_win_get_buf(win)
		if vim.uri_from_bufnr(buf) == uri then
			vim.api.nvim_set_current_win(win)
			return win
		end
	end

	local previous_win = vim.fn.win_getid(vim.fn.winnr("#"))
	local target_win = previous_win ~= current_win and is_regular_edit_window(previous_win) and previous_win or nil

	if not target_win then
		for _, win in ipairs(windows) do
			if win ~= current_win and is_regular_edit_window(win) then
				target_win = win
				break
			end
		end
	end

	if target_win then
		vim.api.nvim_set_current_win(target_win)
		vim.cmd.edit(vim.fn.fnameescape(path))
		return target_win
	end

	vim.cmd.vsplit(vim.fn.fnameescape(path))
	return vim.api.nvim_get_current_win()
end

M.opts = {
	adapters = {
		acp = {
			codex = function()
				return require("codecompanion.adapters").extend("codex", {
					commands = {
						default = {
							"codex-acp",
							"-c",
							'web_search="live"',
						},
					},
					defaults = {
						auth_method = "chatgpt",
					},
				})
			end,
		},
		http = {
			qwen3_6_coder_light_ollama = function()
				return require("codecompanion.adapters").extend("ollama", {
					name = "qwen_ollama",
					schema = {
						model = {
							default = "qwen3.6:35b-a3b-coding-mxfp8",
						},
						-- temperature = {
						-- 	default = 0.2,
						-- },
					},
				})
			end,
			qwen3_6_coder_ollama = function()
				return require("codecompanion.adapters").extend("ollama", {
					name = "qwen_ollama",
					schema = {
						model = {
							default = "qwen3-coder-next:q4_K_M",
						},
						-- temperature = {
						-- 	default = 0.2,
						-- },
					},
				})
			end,
		},
	},

	interactions = {
		chat = {
			adapter = "codex",
			opts = {
				goto_file_action = open_file_in_existing_window,
			},
		},
		inline = {
			adapter = "qwen3_6_coder_ollama",
		},
		cmd = {
			adapter = "qwen3_6_coder_ollama",
		},
		background = {
			adapter = "qwen3_6_coder_ollama",
		},
		cli = {
			agent = "codex",
			agents = {
				codex = {
					cmd = "codex",
					args = { "--no-alt-screen", "--search" },
					description = "OpenAI Codex CLI",
					provider = "terminal",
				},
			},
		},
	},

	opts = {
		log_level = "ERROR",
	},
}

M.cmd = {
	"CodeCompanion",
	"CodeCompanionChat",
	"CodeCompanionActions",
	"CodeCompanionCmd",
	"CodeCompanionCLI",
}

return M
