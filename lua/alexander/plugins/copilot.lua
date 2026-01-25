local copilot = require("alexander.configs.plugins.copilot.copilot")
local copilot_cmp = require("alexander.configs.plugins.copilot.copilot-cmp")
local copilot_chat = require("alexander.configs.plugins.copilot.copilot-chat")

local M = {
	{
		"zbirenbaum/copilot.lua",
		dependencies = { "copilotlsp-nvim/copilot-lsp" },
		event = copilot.event, -- Load Copilot when entering Insert mode for the first time
		cmd = copilot.cmd, -- Also allow manual `:Copilot` command to trigger it
		opts = copilot.opts,
	},
	{
		"zbirenbaum/copilot-cmp",
		dependencies = { "zbirenbaum/copilot.lua" },
		lazy = false,
		config = function()
			require("copilot_cmp").setup()
		end,
	},
	{
		"CopilotC-Nvim/CopilotChat.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		cmd = { "CopilotChat", "CopilotChatOpen", "CopilotChatToggle" },
		build = "make tiktoken", -- Builds the optional native token counter
		opts = {}, -- use default settings; you can add config here if needed
	},
}

return M
