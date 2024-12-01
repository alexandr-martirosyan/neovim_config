local illuminate = require "alexander.configs.plugins.illuminate"

local M = {
  "RRethy/vim-illuminate",
  event = "BufEnter",
  config = illuminate.config,
}

return M
