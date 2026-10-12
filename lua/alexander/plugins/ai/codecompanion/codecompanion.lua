local M = {}

local function open_file_in_existing_window(path)
	return require("alexander.plugins.ai.avante.file_reference").open_file(path)
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
						auth_method = "chat-gpt",
					},
				})
			end,
		},
		http = {
			deepseek_ollama = function()
				return require("codecompanion.adapters").extend("ollama", {
					name = "deepseek_ollama",
					schema = {
						model = {
							default = "deepseek-r1-70b-32k:latest",
						},
					},
				})
			end,
			-- qwen3_6_coder_light_ollama = function()
			-- 	return require("codecompanion.adapters").extend("ollama", {
			-- 		name = "qwen_ollama",
			-- 		schema = {
			-- 			model = {
			-- 				default = "qwen3.6:35b-a3b-coding-mxfp8",
			-- 			},
			-- 			-- temperature = {
			-- 			-- 	default = 0.2,
			-- 			-- },
			-- 		},
			-- 	})
			-- end,
			-- qwen3_6_coder_ollama = function()
			-- 	return require("codecompanion.adapters").extend("ollama", {
			-- 		name = "qwen_ollama",
			-- 		schema = {
			-- 			model = {
			-- 				default = "qwen3-coder-next:q4_K_M",
			-- 			},
			-- 			-- temperature = {
			-- 			-- 	default = 0.2,
			-- 			-- },
			-- 		},
			-- 	})
			-- end,
		},
	},

	interactions = {
		chat = {
			adapter = "deepseek_ollama",
			opts = {
				goto_file_action = open_file_in_existing_window,
			},
		},
		inline = {
			adapter = "deepseek_ollama",
		},
		cmd = {
			adapter = "deepseek_ollama",
		},
		background = {
			adapter = "deepseek_ollama",
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

M.keys = {
	{ "<leader>ica", "<cmd>CodeCompanionActions<CR>", mode = { "n", "x" }, desc = "open code companion actions" },
	{ "<leader>icc", "<cmd>CodeCompanionChat Toggle<CR>", mode = { "n", "x" }, desc = "toggle code companion chat" },
	{
		"<leader>icx",
		function()
			require("codecompanion").toggle_cli()
		end,
		mode = { "n", "x" },
		desc = "toggle code companion cli",
	},
	{
		"<leader>icp",
		function()
			require("codecompanion").cli({ prompt = true })
		end,
		mode = { "n", "x" },
		desc = "prompt code companion cli",
	},
	{
		"<leader>ics",
		function()
			require("codecompanion").cli("#{this}", { focus = false })
		end,
		mode = { "n", "x" },
		desc = "send current context to code companion cli",
	},
	{
		"<leader>icd",
		function()
			require("codecompanion").cli("#{diagnostics} Can you fix these?", { focus = false, submit = true })
		end,
		mode = "n",
		desc = "send diagnostics to code companion cli",
	},
	{ "<leader>icg", "<cmd>CodeCompanionChat Add<cr>", mode = "x", desc = "add selection to code companion chat" },
}

return M
