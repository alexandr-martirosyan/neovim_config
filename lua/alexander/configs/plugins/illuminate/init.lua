local M = {}

M.opts = {}

M.config = function (_, opts)
  require('illuminate').configure(opts)
end

return M
