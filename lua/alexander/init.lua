-- load the vim loader
if vim.loader then
	vim.loader.enable()
end

require("alexander.configs.options")
require("alexander.configs.autocmds")
require("alexander.configs.diagnostics-commands")
require("alexander.configs.mappings")
require("alexander.configs.lazy")
