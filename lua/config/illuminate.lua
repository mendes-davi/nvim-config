local M = {}

M.opts = {
	providers = {
		"lsp",
		"treesitter",
		"regex",
	},
	delay = 100,
	large_file_cutoff = 2000,
	filetype_overrides = {
		providers = { "lsp" },
	},
	filetypes_denylist = {
		"alpha",
		"NvimTree",
		"Trouble",
	},
	filetypes_allowlist = {},
	modes_denylist = {},
	modes_allowlist = {},
	under_cursor = true,
}

M.map_keys = function()
	local cword = function()
		local line = vim.fn.getline "."
		local col = vim.fn.col "." - 1
		local left_part = vim.fn.strpart(line, 0, col + 1)
		local right_part = vim.fn.strpart(line, col, vim.fn.col "$")
		local word = vim.fn.matchstr(left_part, [[\k*$]]) .. string.sub(vim.fn.matchstr(right_part, [[^\k*]]), 2)
		return [[\<]] .. vim.fn.escape(word, [[/\]]) .. [[\>]]
	end

	local next_ref_cword = function(opt)
		local opt = opt or {}

		local next = require("illuminate").next_reference { wrap = true, reverse = opt.reverse }
		if next == nil then
			local word = cword()
			if word == [[\<\>]] then
				return
			end

			local flag = "w"
			if opt.reverse then
				flag = flag .. "b"
			end

			vim.fn.search(word, flag)
			local sc = vim.fn.searchcount { pattern = word }
			print("[" .. sc.current .. "/" .. sc.total .. "]")
		end
	end

	nnoremap {
		"<A-n>",
		function()
			next_ref_cword()
		end,
		silent = true,
	}

	nnoremap {
		"<A-p>",
		function()
			next_ref_cword { reverse = true }
		end,
		silent = true,
	}
end

return M
