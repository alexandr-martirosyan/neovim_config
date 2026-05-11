local copilot = require("alexander.plugins.copilot.copilot")
local copilot_cmp = require("alexander.plugins.copilot.copilot-cmp")
local copilot_chat = require("alexander.plugins.copilot.copilot-chat")

local M = {
	{
		"zbirenbaum/copilot.lua",
		dependencies = { "copilotlsp-nvim/copilot-lsp" },
		cmd = { "Copilot" },
		event = { "InsertEnter" },
		opts = copilot.opts,
	},
	{
		"zbirenbaum/copilot-cmp",
		dependencies = { "zbirenbaum/copilot.lua" },
		lazy = false,
		config = copilot_cmp.config,
	},
	{
		"CopilotC-Nvim/CopilotChat.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		cmd = { "CopilotChat", "CopilotChatOpen", "CopilotChatToggle" },
		build = "make tiktoken", -- Builds the optional native token counter
    opts = copilot_chat.opts,
	},
}

return M
