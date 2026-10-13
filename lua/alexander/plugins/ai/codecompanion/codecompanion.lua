local M = {}

local function open_file_in_existing_window(path)
	return require("alexander.plugins.ai.avante.file_reference").open_file(path)
end

M.opts = {
	adapters = {
		acp = {
			-- Claude (Pro subscription) through Zed's claude-agent-acp (npm i -g @agentclientprotocol/claude-agent-acp).
			-- It uses the `claude` CLI's own login (once: `claude auth login --claudeai`). The adapter also accepts
			-- a CLAUDE_CODE_OAUTH_TOKEN env var (from `claude setup-token`) if that login is ever not enough.
			claude_code = function()
				return require("codecompanion.adapters").extend("claude_code", {})
			end,
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
		-- Local AI servers (none configured). Uncomment one, set the model, and select it in a chat with `ga`
		-- (or set it as the adapter of inline / cmd / background below).
		-- oMLX http://localhost:8000, llama.cpp server http://localhost:8080, LM Studio http://localhost:1234;
		-- all three offer an OpenAI-style (/v1/chat/completions) and an Anthropic-style (/v1/messages) API.
		-- http = {
		-- 	-- OpenAI-style API
		-- 	local_openai = function()
		-- 		return require("codecompanion.adapters").extend("openai_compatible", {
		-- 			name = "local_openai",
		-- 			formatted_name = "Local (OpenAI API)",
		-- 			env = {
		-- 				url = "http://localhost:1234", -- LM Studio; oMLX :8000, llama.cpp :8080
		-- 				api_key = "local", -- local servers need no key
		-- 			},
		-- 			schema = { model = { default = "model-id-from-the-server" } },
		-- 		})
		-- 	end,
		-- 	-- Anthropic-style API
		-- 	local_anthropic = function()
		-- 		return require("codecompanion.adapters").extend("anthropic", {
		-- 			name = "local_anthropic",
		-- 			formatted_name = "Local (Anthropic API)",
		-- 			url = "http://localhost:1234/v1/messages", -- LM Studio; oMLX :8000, llama.cpp :8080
		-- 			env = { api_key = "local" },
		-- 			schema = { model = { default = "model-id-from-the-server" } },
		-- 		})
		-- 	end,
		-- },
	},

	interactions = {
		chat = {
			-- ACP agents (claude_code, codex) work in the chat buffer only; change the adapter in a chat with `ga`.
			adapter = "claude_code",
			opts = {
				goto_file_action = open_file_in_existing_window,
			},
		},
		-- inline / cmd / background need a plain HTTP API, which the Claude Pro / ChatGPT subscriptions don't
		-- include, so no adapter is set: CodeCompanion falls back to its default, GitHub Copilot.
		-- To use a local server instead, uncomment a local adapter above and add e.g. `inline = { adapter = "local_openai" }`.
		cli = {
			agent = "codex",
			agents = {
				-- :CodeCompanionCLI agent=claude_code <prompt> (the default agent stays codex)
				claude_code = {
					cmd = "claude",
					args = {},
					description = "Claude Code CLI",
					provider = "terminal",
				},
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
