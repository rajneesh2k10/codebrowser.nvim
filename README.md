# codebrowser.nvim

**codebrowser.nvim** is a Neovim plugin that allows you to open the current line of code in your web browser. This is particularly useful for navigating to specific lines in version-controlled repositories hosted on platforms like GitHub, GitLab, etc.


## Installation

### Using [lazy.nvim](https://github.com/folke/lazy.nvim)
```lua
{
    'rajneesh2k10/codebrowser.nvim',
    config = function()
        require('codebrowser').setup({
            urls = {
                {
                    description = "GitHub",
                    base_url = "https://github.com/your_username/your_repo/blob/main/",
                    line_number_anchor = "#L" -- GitHub line anchor
                },
                {
                    description = "GitLab",
                    base_url = "https://gitlab.com/your_username/your_repo/-/blob/main/",
                    line_number_anchor = "#n" -- GitLab line anchor
                }
                -- Add more configurations as needed
            }
        })
    end
}
```

## Features

- Open the current line in a web browser using a configurable base URL.
- Support for multiple repository URLs, with a choice menu for selection.
- Configurable anchor characters for different platforms (e.g., `#L` for GitHub, `#n` for GitLab).
- Automatically detects the file's relative path within the Git repository.


## Usage

Open the current file in the browser anchored to the current line number: `:OpenCodeInBrowser`

If more than one URLs are configured, a choice menu will be displayed to select the desired portal.

## Setup

To setup the plugin, call the setup function with a table containing the URL configurations. You must configure at least one URL. Every URL configuration must contain a `description`, `base_url`, and `line_number_anchor` key. 

For example:

```lua
urls = {
    {
        description = "GitHub",
        base_url = "https://github.com/your_username/your_repo/blob/main/",
        line_number_anchor = "#L"
    },
}
```


