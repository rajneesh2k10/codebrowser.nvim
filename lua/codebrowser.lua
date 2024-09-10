local M = {}

local config = {
	urls = {
		{
			description = "GitHub",
			base_url = "https://github.com/",
			line_number_anchor = "#L",
		},
	},
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

local function construct_url(index)
	local relative_file_path = get_relative_file_path()
	if not relative_file_path then
		return
	end
	local line_number = vim.fn.line(".")
	local url = string.format(
		"%s%s%s%d",
		config.urls[index].base_url,
		relative_file_path,
		config.urls[index].line_number_anchor,
		line_number
	)
	return url
end

local function open_code_in_browser()
	-- If no URLs are configured, print a message and return
	if #config.urls == 0 then
		print("No URLs configured")
		return
	end

	-- If only one URL is configured, open it and return
	local url = nil
	if #config.urls == 1 then
		url = construct_url(1)
		open_url(url)
		return
	end

	-- If multiple URLs are configured, prompt the user to choose one
	local choices = {}
	for i, cfg in ipairs(config.urls) do
		table.insert(choices, { index = i, cfg.description })
	end

	-- Use vim.ui.select to prompt the user to choose a URL
	vim.ui.select(choices, {
		prompt = "Select a URL",
		format_item = function(choice)
			return choice.description
		end,
	}, function(choice)
		if choice then
			url = construct_url(choice.index)
			open_url(url)
		end
	end)
end

function M.setup(user_config)
	config = vim.tbl_extend("force", config, user_config or {})
	vim.api.nvim_create_user_command("OpenCodeInBrowser", open_code_in_browser, {})
end

return M
