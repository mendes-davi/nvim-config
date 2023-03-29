local mind = require "mind"

mind.setup {
	persistence = {
		state_path = "~/vimwiki/mind/mind.json",
		data_dir = "~/vimwiki/mind/data",
	},

	ui = {
		width = 40,

		highlight = {
			local_marker = "Comment",
			data_marker = "Comment",
			modifier_empty = "Comment",
			node_root = "Number",
		},
	},
	keymaps = {
		normal = {
			T = function(args)
				require("mind.ui").with_cursor(function(line)
					local tree = args.get_tree()
					local node = require("mind.node").get_node_by_line(tree, line)

					if node.icon == nil or node.icon == " " then
						node.icon = " "
					elseif node.icon == " " then
						node.icon = " "
					end

					args.save_tree()
					require("mind.ui").rerender(tree, args.opts)
				end)
			end,
		},
	},
}

local ok, which_key = pcall(require, "which-key")
assert(ok, "failed to assign which-key keybinds")
if not ok then
	return
end

local opts = {
	mode = "n",
	prefix = "<leader>",
	buffer = nil,
	silent = true,
	noremap = true,
	nowait = false,
}

local mappings = {
	m = {
		name = "Mind - Smart Tree",
		m = { "<cmd>MindOpenSmartProject<CR>", "Open Smart Project" },
		c = {
			function()
				mind.wrap_smart_project_tree_fn(function(args)
					require("mind.commands").create_node_index(args.get_tree(), require("mind.node").MoveDir.INSIDE_END, args.save_tree, args.opts)
				end)
			end,
			"Create Node in Smart Project",
		},
		i = {
			function()
				vim.notify "MIND - Initializing Project Tree"
				mind.wrap_smart_project_tree_fn(function(args)
					local tree = args.get_tree()
					local mind_node = require "mind.node"

					local _, tasks = mind_node.get_node_by_path(tree, "/Tasks", true)
					tasks.icon = "陼"

					local _, backlog = mind_node.get_node_by_path(tree, "/Tasks/Backlog", true)
					backlog.icon = " "

					local _, on_going = mind_node.get_node_by_path(tree, "/Tasks/On-going", true)
					on_going.icon = " "

					local _, done = mind_node.get_node_by_path(tree, "/Tasks/Done", true)
					done.icon = " "

					local _, cancelled = mind_node.get_node_by_path(tree, "/Tasks/Cancelled", true)
					cancelled.icon = " "

					local _, notes = mind_node.get_node_by_path(tree, "/Notes", true)
					notes.icon = " "

					args.save_tree()
				end)
			end,
			"Initialize Tree in Smart Project",
		},
		l = {
			function()
				require("mind").wrap_smart_project_tree_fn(function(args)
					require("mind.commands").copy_node_link_index(args.get_tree(), nil, args.opts)
				end)
			end,
			"Copy Link in Smart Project",
		},
		s = {
			function()
				require("mind").wrap_smart_project_tree_fn(function(args)
					require("mind.commands").open_data_index(args.get_tree(), args.data_dir, args.save_tree, args.opts)
				end)
			end,
			"Open Data Index in Smart Project",
		},
	},
	M = {
		name = "Mind - Main Tree",
		m = { "<cmd>MindOpenMain<CR>", "Open Main Project" },
		c = {
			function()
				mind.wrap_main_tree_fn(function(args)
					require("mind.commands").create_node_index(args.get_tree(), require("mind.node").MoveDir.INSIDE_END, args.save_tree, args.opts)
				end)
			end,
			"Create None in Main Project",
		},
		l = {
			function()
				require("mind").wrap_main_tree_fn(function(args)
					require("mind.commands").copy_node_link_index(args.get_tree(), nil, args.opts)
				end)
			end,
			"Copy Link in Main Project",
		},
		j = {
			function()
				require("mind").wrap_main_tree_fn(function(args)
					local tree = args.get_tree()
					local path = vim.fn.strftime "/Journal/%Y/%b/%d"
					local _, node = require("mind.node").get_node_by_path(tree, path, true)

					if node == nil then
						vim.notify("cannot open journal 🙁", vim.log.levels.WARN)
						return
					end

					require("mind.commands").open_data(tree, node, args.data_dir, args.save_tree, args.opts)
					args.save_tree()
				end)
			end,
			"Open Journal",
		},
		s = {
			function()
				require("mind").wrap_main_tree_fn(function(args)
					require("mind.commands").open_data_index(args.get_tree(), args.data_dir, args.save_tree, args.opts)
				end)
			end,
			"Open Data Index in Main Project",
		},
	},
}
which_key.register(mappings, opts)
