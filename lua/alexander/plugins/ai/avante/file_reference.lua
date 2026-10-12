-- Shared by Avante and CodeCompanion; kept in the existing location.
local M = {}

function M.is_regular_edit_window(win)
	if not vim.api.nvim_win_is_valid(win) or vim.api.nvim_win_get_config(win).relative ~= "" then
		return false
	end
	local buf = vim.api.nvim_win_get_buf(win)
	local ft = vim.bo[buf].filetype:lower()
	return vim.bo[buf].buftype == ""
		and not ft:match("^avante")
		and not ft:match("^codecompanion")
		and not ft:match("^kulala")
		and not vim.tbl_contains({ "neo-tree", "oil", "trouble", "qf", "alpha", "lazy", "mason" }, ft)
end

function M.parse_target(target)
	target = vim.trim(target):gsub("^<", ""):gsub(">$", "")
	target = target:gsub("^[`'\"%(%[]+", ""):gsub("[`'\"%)%]%,;]+$", "")
	local path, row, col = target:match("^(.-):(%d+):(%d+)$")
	if not path then
		path, row = target:match("^(.-):(%d+)$")
	end
	if not path then
		path, row = target:match("^(.-)#L(%d+).*$")
	end
	path = path or target
	if path:match("^file://") then
		path = vim.uri_to_fname(path)
	elseif path:match("^%a[%w+.-]*://") then
		return nil
	end
	if path:sub(1, 2) == "~/" then
		path = vim.fn.expand("~") .. path:sub(2)
	end
	return { path = path, line = tonumber(row) or 1, column = tonumber(col) or 1 }
end

function M.resolve_path(path)
	local candidates = {}
	if vim.startswith(path, "/") then
		candidates = { path }
	else
		table.insert(candidates, vim.fs.joinpath(vim.fn.getcwd(), path))
		for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
			if M.is_regular_edit_window(win) then
				local name = vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(win))
				if name ~= "" then
					local root = vim.fs.root(name, { ".git", "package.json", "Cargo.toml", "pyproject.toml" })
					if root then
						table.insert(candidates, vim.fs.joinpath(root, path))
					end
					table.insert(candidates, vim.fs.joinpath(vim.fs.dirname(name), path))
				end
			end
		end
	end
	for _, candidate in ipairs(candidates) do
		candidate = vim.fs.normalize(vim.fn.fnamemodify(candidate, ":p"))
		local buf = vim.fn.bufnr(candidate)
		local stat = vim.uv.fs_stat(candidate)
		-- A named, unsaved buffer is a valid target even before its first write.
		if (buf >= 0 and vim.api.nvim_buf_is_loaded(buf)) or (stat and stat.type == "file") then
			return candidate
		end
	end
end

function M.open_file(path, row, column)
	local target = M.parse_target(path)
	if not target then
		return
	end
	local resolved = M.resolve_path(target.path)
	if not resolved then
		vim.notify("No readable file reference: " .. target.path, vim.log.levels.WARN)
		return
	end
	local buf = vim.fn.bufadd(resolved)
	vim.fn.bufload(buf)
	local current = vim.api.nvim_get_current_win()
	local previous = vim.fn.win_getid(vim.fn.winnr("#"))
	local target_win
	for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
		if M.is_regular_edit_window(win) and vim.api.nvim_win_get_buf(win) == buf then
			target_win = win
			break
		end
	end
	if not target_win and M.is_regular_edit_window(previous) then
		target_win = previous
	end
	if not target_win then
		for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
			if win ~= current and M.is_regular_edit_window(win) then
				target_win = win
				break
			end
		end
	end
	if target_win then
		local old_buf = vim.api.nvim_win_get_buf(target_win)
		if old_buf ~= buf and vim.bo[old_buf].modified and not vim.o.hidden then
			vim.api.nvim_set_current_win(target_win)
			vim.cmd.vsplit()
			target_win = vim.api.nvim_get_current_win()
		end
	else
		vim.cmd.vsplit()
		target_win = vim.api.nvim_get_current_win()
	end
	vim.api.nvim_set_current_win(target_win)
	vim.api.nvim_win_set_buf(target_win, buf)
	row = math.min(math.max(row or target.line, 1), vim.api.nvim_buf_line_count(buf))
	local line = vim.api.nvim_buf_get_lines(buf, row - 1, row, false)[1] or ""
	local col = math.min(math.max((column or target.column) - 1, 0), math.max(#line - 1, 0))
	vim.api.nvim_win_set_cursor(target_win, { row, col })
	vim.cmd("normal! zvzz")
	return target_win
end

function M.open_under_cursor()
	local line = vim.api.nvim_get_current_line()
	local cursor = vim.api.nvim_win_get_cursor(0)[2] + 1
	local candidates = {}
	local function add(text, first, last)
		local target = M.parse_target(text)
		if target and M.resolve_path(target.path) then
			table.insert(
				candidates,
				{
					text = text,
					distance = cursor >= first and cursor <= last and -1
						or math.min(math.abs(cursor - first), math.abs(cursor - last)),
				}
			)
		end
	end
	for first, text, last in line:gmatch("()%b[]%(([^%)]+)%)()") do
		add(text, first, last - 1)
	end
	for first, text, last in line:gmatch("()<([^>]+)>()") do
		add(text, first, last - 1)
	end
	for first, text, last in line:gmatch("()`([^`]+)`()") do
		add(text, first, last - 1)
	end
	for first, text, last in line:gmatch('()"([^"]+)"()') do
		add(text, first, last - 1)
	end
	for first, text, last in line:gmatch("()(%S+)()") do
		add(text, first, last - 1)
	end
	table.sort(candidates, function(a, b)
		return a.distance < b.distance
	end)
	if candidates[1] then
		return M.open_file(candidates[1].text)
	end
	vim.notify("No readable file reference found on this line", vim.log.levels.WARN)
end

return M
