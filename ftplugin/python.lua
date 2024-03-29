local ts_utils = require "nvim-treesitter.ts_utils"

require("dap.python").setup()
require("dap.python").test_runner = "pytest"
nnoremap { "<leader>dn", ":lua require('dap.python').test_method()<CR>", silent = true }
nnoremap { "<leader>df", ":lua require('dap.python').test_class()<CR>", silent = true }
vnoremap { "<leader>ds", "<ESC>:lua require('dap.python').debug_selection()<CR>", silent = true }

toggle_fstring = function()
	local winnr = 0
	local cursor = vim.api.nvim_win_get_cursor(winnr)
	local node = ts_utils.get_node_at_cursor()

	while (node ~= nil) and (node:type() ~= "string") do
		node = node:parent()
	end
	if node == nil then
		print "f-string: not in string node :("
		return
	end

	local srow, scol, ecol, erow = ts_utils.get_vim_range { node:range() }
	vim.fn.setcursorcharpos(srow, scol)
	local char = vim.api.nvim_get_current_line():sub(scol, scol)
	local is_fstring = (char == "f")

	if is_fstring then
		vim.cmd "normal mzx"
		-- if cursor is in the same line as text change
		if srow == cursor[1] then
			cursor[2] = cursor[2] - 1 -- negative offset to cursor
		end
	else
		vim.cmd "normal mzif"
		-- if cursor is in the same line as text change
		if srow == cursor[1] then
			cursor[2] = cursor[2] + 1 -- positive offset to cursor
		end
	end
	vim.api.nvim_win_set_cursor(winnr, cursor)
end

nnoremap { "<leader>F", toggle_fstring }
