vim.api.nvim_create_autocmd("VimEnter", {
	callback = function()
		local arg = tostring(vim.fn.argv(0))
		if arg ~= "" then
			local stat = vim.uv.fs_stat(arg)
			if stat and stat.type == "directory" then
				vim.cmd("cd " .. arg)
			end
		end
	end,
})
