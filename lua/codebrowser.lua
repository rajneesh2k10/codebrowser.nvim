local config = {
	base_url = "https://github.com/user/repo/blob/main/",
}

local function open_url(url)
	local open_cmd
	if vim.fn.has("mac") == 1 then
		open_cmd = "open"
	elseif vim.fn.has("unix") == 1 then
		open_cmd = "xdg-open"
	elseif vim.fn.has("win32") == 1 or vim.fn.has("win64") then
		open_cmd = "start"
	else
		print("Unsupported OS")
		return
	end
	os.execute(open_cmd .. " " .. url)
end

local function get_relative_file_path()
	local file_path = vim.fn.expand("%:p")
	local relative_path = vim.fn.systemlist("git ls-files --full-name " .. file_path)[1]
	if vim.v.shell_error ~= 0 or relative_path == "" then
		print("Not inside a Git repository")
		return nil
	end
	return relative_path
end

local function construct_url()
	local relative_file_path = get_relative_file_path()
	if not relative_file_path then
		return
	end
	local line_number = vim.fn.line(".")
	local url = string.format("%s%s#L%d", config.base_url, relative_file_path, line_number)
	return url
end

local function open_code_in_browser()
	local url = construct_url()
	if not url then
		print("Failed to construct URL")
		return
	end
	open_url(url)
end

local function setup(user_config)
	config = vim.tbl_extend("force", config, user_config or {})
	vim.api.nvim_create_user_command("OpenCodeInBrowser", open_code_in_browser, {})
end

return setup
