local illuminate = require "alexander.plugins.illuminate.vim-illuminate"

local M = {
  "RRethy/vim-illuminate",
  event = "BufEnter",
  config = illuminate.config,
}

return M
