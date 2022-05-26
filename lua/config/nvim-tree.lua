Variable.g {
	nvim_tree_side = "left", -- left by default
	nvim_tree_width = 30, -- 30 by default
	nvim_tree_git_hl = 1, -- 0 by default, will enable file highlight for git attributes (can be used without the icons).
	nvim_tree_root_folder_modifier = ":~", -- This is the default. See :help filename-modifiers for more options
	nvim_tree_allow_resize = 1, -- 0 by default, will not resize the tree when opening a file
	--If 0, do not show the icons for one of 'git' 'folder' and 'files'
	--1 by default, notice that if 'files' is 1, it will only display
	--if nvim-web-devicons is installed and on your runtimepath
	nvim_tree_show_icons = {
		git = 1,
		folders = 1,
		files = 1,
		folder_arrows = 1,
	},
	nvim_tree_special_files = {
		["go.mod"] = 1,
		["Cargo.toml"] = 1,
		["README.md"] = 1,
		["Makefile"] = 1,
		["MAKEFILE"] = 1,
	}, -- List of filenames that gets highlighted with NvimTreeSpecialFile
}

local lib = require "nvim-tree.lib"
local view = require "nvim-tree.view"

local function collapse_all()
	require("nvim-tree.actions.collapse-all").fn()
end

local function edit_or_open()
	-- open as vsplit on current node
	local action = "edit"
	local node = lib.get_node_at_cursor()

	-- Just copy what's done normally with vsplit
	if node.link_to and not node.nodes then
		require("nvim-tree.actions.open-file").fn(action, node.link_to)
		view.close() -- Close the tree if file was opened
	elseif node.nodes ~= nil then
		lib.expand_or_collapse(node)
	else
		require("nvim-tree.actions.open-file").fn(action, node.absolute_path)
		view.close() -- Close the tree if file was opened
	end
end

local function vsplit_preview()
	-- open as vsplit on current node
	local action = "vsplit"
	local node = lib.get_node_at_cursor()

	-- Just copy what's done normally with vsplit
	if node.link_to and not node.nodes then
		require("nvim-tree.actions.open-file").fn(action, node.link_to)
	elseif node.nodes ~= nil then
		lib.expand_or_collapse(node)
	else
		require("nvim-tree.actions.open-file").fn(action, node.absolute_path)
	end
end

-- https://github.com/kyazdani42/nvim-tree.lua#setup
require("nvim-tree").setup {
	hijack_netrw = false,
	hijack_directories = {
		enable = false,
		auto_open = false,
	},
	view = {
		mappings = {
			custom_only = false,
			list = {
				{ key = "l", action = "edit", action_cb = edit_or_open },
				{ key = "L", action = "vsplit_preview", action_cb = vsplit_preview },
				{ key = "h", action = "close_node" },
				{ key = "H", action = "collapse_all", action_cb = collapse_all },
			},
		},
	},
	actions = {
		open_file = {
			quit_on_open = true,
			window_picker = {
				exclude = {
					filetype = { "packer", "qf", "notify", "diff" },
					buftype = { "terminal", "nofile", "help" },
				},
			},
		},
	},
	filters = {
		custom = { ".git", "node_modules", ".cache", ".idea", "__pycache__" },
	},
	git = {
		enable = false,
	},
}

-- Auto-close
vim.api.nvim_create_autocmd("BufEnter", {
	command = "if winnr('$') == 1 && bufname() == 'NvimTree_' . tabpagenr() | quit | endif",
	nested = true,
})
