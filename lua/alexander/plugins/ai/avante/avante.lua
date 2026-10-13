local M = {}

M.init = function()
	local group = vim.api.nvim_create_augroup("AlexanderAvanteFileReference", { clear = true })

	vim.api.nvim_create_autocmd("FileType", {
		group = group,
		pattern = "Avante",
		callback = function(args)
			vim.keymap.set("n", "gR", function()
				require("alexander.plugins.ai.avante.file_reference").open_under_cursor()
			end, {
				buffer = args.buf,
				desc = "Open Avante file reference",
				silent = true,
			})
		end,
	})
end

M.opts = {
	provider = "codex",
	mode = "agentic",
	-- Preserve existing history rather than silently switching storage roots.
	history = { storage_path = vim.fn.stdpath("data") .. "/avante" },

	-- ACP providers preserved for reference
	acp_providers = {
		codex = {
			command = "codex-acp",
			args = {
				"-c",
				'web_search="live"',
			},
			env = {
				NODE_NO_WARNINGS = "1",
			},
			auth_method = "chat-gpt",
		},
		-- Claude (Pro subscription) through Zed's ACP adapter: npm i -g @agentclientprotocol/claude-agent-acp.
		-- It uses the `claude` CLI's own login (once: `claude auth login --claudeai`); no API key.
		-- Switch with <leader>iap (:AvanteSwitchProvider claude-code). Permissions are asked in Avante
		-- (Avante's default ACP_PERMISSION_MODE=bypassPermissions is not read by claude-agent-acp 0.89+).
		["claude-code"] = {
			command = "claude-agent-acp",
			args = {},
			env = {
				NODE_NO_WARNINGS = "1",
			},
		},
	},

	-- Local AI servers (none configured; uncomment one and set the model to use it with :AvanteSwitchProvider).
	-- oMLX http://localhost:8000, llama.cpp server http://localhost:8080, LM Studio http://localhost:1234;
	-- all three offer an OpenAI-style (/v1/chat/completions) and an Anthropic-style (/v1/messages) API.
	-- providers = {
	-- 	-- OpenAI-style API
	-- 	["local-openai"] = {
	-- 		__inherited_from = "openai",
	-- 		endpoint = "http://localhost:1234/v1", -- LM Studio; oMLX :8000/v1, llama.cpp :8080/v1
	-- 		model = "model-id-from-the-server",
	-- 		api_key_name = "cmd:echo local", -- local servers need no key; a dummy stops Avante asking
	-- 		timeout = 120000,
	-- 	},
	-- 	-- Anthropic-style API (Avante adds /v1/messages)
	-- 	["local-anthropic"] = {
	-- 		__inherited_from = "claude",
	-- 		endpoint = "http://localhost:1234", -- LM Studio; oMLX :8000, llama.cpp :8080
	-- 		model = "model-id-from-the-server",
	-- 		api_key_name = "cmd:echo local",
	-- 		timeout = 120000,
	-- 	},
	-- },

	behaviour = {
		-- Avante's automatic keys use mode "v" (Visual + Select). All its keys are defined in M.keys
		-- below instead, with Visual-only ("x") where they take a selection.
		auto_set_keymaps = false,
		auto_suggestions = false,
		auto_apply_diff_after_generation = false,
		minimize_diff = true,
		auto_add_current_file = true,
		auto_approve_tool_permissions = false,
		confirmation_ui_style = "inline_buttons",
		acp_follow_agent_locations = true,
	},

	mappings = {
		ask = "<leader>iaa",
		new_ask = "<leader>ian",
		edit = "<leader>iae",
		refresh = "<leader>iar",
		focus = "<leader>iaf",
		stop = "<leader>ias",
		toggle = {
			default = "<leader>iat",
			debug = "<leader>iad",
			selection = "<leader>iaC",
			suggestion = "<leader>iaS",
			repomap = "<leader>iaR",
		},
		files = {
			add_current = "<leader>iaF",
			add_all_buffers = "<leader>iaB",
		},
		select_model = "<leader>iam",
		select_history = "<leader>iah",
		select_acp_model = "<leader>iaM",
		select_acp_mode = "<leader>iao",
		zen_mode = "<leader>iaz", -- default <leader>az made <leader>a (Harpoon add) wait for a second key
	},

	windows = {
		position = "right",
		width = 35,
		wrap = true,
		ask = {
			start_insert = false,
		},
	},

	file_selector = {
		provider = "telescope",
	},

	selector = {
		provider = "telescope",
	},
}

M.cmd = {
	"Avante",
	"AvanteAsk",
	"AvanteBuild",
	"AvanteChat",
	"AvanteChatNew",
	"AvanteHistory",
	"AvanteClear",
	"AvanteEdit",
	"AvanteFocus",
	"AvanteRefresh",
	"AvanteStop",
	"AvanteSwitchProvider",
	"AvanteShowRepoMap",
	"AvanteToggle",
	"AvanteModels",
	"AvanteACPModels",
	"AvanteACPModes",
	"AvanteSwitchSelectorProvider",
	"AvanteSwitchInputProvider",
}

M.keys = {
	{ "<leader>iaa", "<cmd>AvanteAsk<CR>", mode = "n", desc = "avante ask" },
	{ "<leader>iaa", ":AvanteAsk<CR>", mode = "x", desc = "avante ask selection" },
	{ "<leader>iae", ":AvanteEdit<CR>", mode = "x", desc = "avante edit selection" },
	{ "<leader>iac", "<cmd>AvanteChat<CR>", mode = "n", desc = "avante chat" },
	-- Same action as Avante's `mappings.new_ask`, defined here so the key also loads Avante.
	{
		"<leader>ian",
		function()
			require("avante.api").ask({ new_chat = true })
		end,
		mode = { "n", "x" },
		desc = "avante new ask",
	},
	{ "<leader>iaN", "<cmd>AvanteChatNew<CR>", mode = "n", desc = "avante new chat" },
	{
		"<leader>iaz",
		function()
			require("avante.api").zen_mode()
		end,
		mode = "n",
		desc = "avante zen mode",
	},
	{ "<leader>iat", "<cmd>AvanteToggle<CR>", mode = "n", desc = "toggle avante sidebar" },
	-- Previously added by Avante's automatic keymaps (behaviour.auto_set_keymaps, now off).
	{ "<leader>iad", "<Plug>(AvanteToggleDebug)", mode = "n", remap = true, desc = "toggle avante debug" },
	{ "<leader>iaC", "<Plug>(AvanteToggleSelection)", mode = "n", remap = true, desc = "toggle avante selection" },
	{ "<leader>iaS", "<Plug>(AvanteToggleSuggestion)", mode = "n", remap = true, desc = "toggle avante suggestion" },
	{ "<leader>iaB", "<Plug>(AvanteAddAllBuffers)", mode = "n", remap = true, desc = "avante add all open buffers" },
	{ "<leader>iaf", "<cmd>AvanteFocus<CR>", mode = "n", desc = "focus avante sidebar" },
	{ "<leader>iar", "<cmd>AvanteRefresh<CR>", mode = "n", desc = "refresh avante" },
	{ "<leader>ias", "<cmd>AvanteStop<CR>", mode = "n", desc = "stop avante request" },
	{ "<leader>iah", "<cmd>AvanteHistory<CR>", mode = "n", desc = "avante history" },
	{ "<leader>iam", "<cmd>AvanteModels<CR>", mode = "n", desc = "avante models" },
	{ "<leader>iaM", "<cmd>AvanteACPModels<CR>", mode = "n", desc = "avante acp models" },
	{ "<leader>iao", "<cmd>Avante acp modes<CR>", mode = "n", desc = "avante acp mode" },
	{ "<leader>iaR", "<cmd>AvanteShowRepoMap<CR>", mode = "n", desc = "avante repo map" },
	{ "<leader>iap", "<cmd>AvanteSwitchProvider<CR>", mode = "n", desc = "switch avante provider" },
}

return M
