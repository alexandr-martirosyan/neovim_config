local M = {}

M.opts = {
	adapters = {
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
			adapter = "qwen3_6_coder_ollama",
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
