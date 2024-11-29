-- load the vim loader
if vim.loader then
	vim.loader.enable()
end

require("alexander.configs.lazy")
require("alexander.configs.options")
require("lua.alexander.configs.diagnostics-commands")
vim.schedule(function()
	require("alexander.configs.mappings")
end)
