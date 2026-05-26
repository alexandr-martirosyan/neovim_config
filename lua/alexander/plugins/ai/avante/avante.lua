local M = {}

M.opts = {
	provider = "codex",
	mode = "agentic",

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
			auth_method = "chatgpt",
		},
	},

	behaviour = {
		auto_suggestions = false,
		auto_apply_diff_after_generation = false,
		minimize_diff = true,
		auto_add_current_file = true,
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
	},

	windows = {
		position = "right",
		width = 35,
		wrap = true,
	},

	file_selector = {
		provider = "telescope",
	},

	selector = {
		provider = "telescope",
	},
}

M.cmd = {
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

return M
