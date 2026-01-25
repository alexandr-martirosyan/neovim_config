local trouble = require "alexander.plugins.trouble.trouble"

local M = {
  {
    "folke/trouble.nvim",
    cmd = { "Trouble" },
    opts = trouble.opts, -- for default options, refer to the configuration section for custom setup.
    -- config = trouble.config,
  }
}

return M
