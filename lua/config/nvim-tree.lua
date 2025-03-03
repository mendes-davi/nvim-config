local api = require "nvim-tree.api"

local function edit_or_open()
	local node = api.tree.get_node_under_cursor()

	if node.nodes ~= nil then
		-- expand or collapse folder
		api.node.open.edit()
	else
		-- open file
		api.node.open.edit()
		-- Close the tree if file was opened
		api.tree.close()
	end
end

-- open as vsplit on current node
local function vsplit_preview()
	local node = api.tree.get_node_under_cursor()

	if node.nodes ~= nil then
		-- expand or collapse folder
		api.node.open.edit()
	else
		-- open file as vsplit
		api.node.open.vertical()
	end
end

local function my_on_attach(bufnr)
	-- default mappings
	api.config.mappings.default_on_attach(bufnr)

	local function opts(desc)
		return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
	end

	-- custom mappings
	vim.keymap.set("n", "l", edit_or_open, opts "edit/open")
	vim.keymap.set("n", "L", vsplit_preview, opts "vsp preview")
	vim.keymap.set("n", "h", api.node.navigate.parent_close, opts "close node")
	vim.keymap.set("n", "H", api.tree.collapse_all, opts "close node")
	vim.keymap.set("n", "?", api.tree.toggle_help, opts "help")
end

-- https://github.com/kyazdani42/nvim-tree.lua#setup
require("nvim-tree").setup {
	on_attach = my_on_attach,
	hijack_netrw = false,
	hijack_directories = {
		enable = false,
		auto_open = false,
	},
	sync_root_with_cwd = true,
	view = {
		width = 55,
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
	renderer = {
		indent_width = 1,
		special_files = { "go.mod", "Cargo.toml", "README.md", "Makefile", "MAKEFILE" },
		indent_markers = {
			enable = true,
		},
	},
	diagnostics = {
		enable = false,
		show_on_dirs = false,
		show_on_open_dirs = true,
	},
}

vim.api.nvim_create_autocmd({ "QuitPre" }, {
	callback = function()
		vim.cmd "NvimTreeClose"
	end,
})
