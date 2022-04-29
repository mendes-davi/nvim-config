local gs = require "gitsigns"

-- Sets GIT_* ENV Variables for my dotfiles repo
-- https://github.com/lewis6991/gitsigns.nvim/issues/397
if vim.fn.getcwd() == vim.fn.expand "$HOME" then
	local jid = vim.fn.jobstart { "git", "--git-dir=$HOME/.dots", "--work-tree=$HOME", "rev-parse" }
	local ret = vim.fn.jobwait({ jid })[1]
	if ret > 0 then
		vim.env.GIT_DIR = vim.fn.expand "~/.dots"
		vim.env.GIT_WORK_TREE = vim.fn.expand "~"
	end
end

gs.setup {
	signs = {
		add = { hl = "DiffAdd", text = "│", numhl = "GitSignsAddNr" },
		change = { hl = "DiffChange", text = "│", numhl = "GitSignsChangeNr" },
		delete = { hl = "DiffDelete", text = "_", numhl = "GitSignsDeleteNr" },
		topdelete = { hl = "DiffDelete", text = "‾", numhl = "GitSignsDeleteNr" },
		changedelete = { hl = "DiffChange", text = "~", numhl = "GitSignsChangeNr" },
	},
	numhl = false,
	sign_priority = 6,
	on_attach = function(bufnr)
		local gs = package.loaded.gitsigns

		local function map(mode, l, r, opts)
			opts = opts or {}
			opts.buffer = bufnr
			vim.keymap.set(mode, l, r, opts)
		end

		-- Navigation
		map("n", "]c", function()
			if vim.wo.diff then
				return "]c"
			end
			vim.schedule(function()
				gs.next_hunk()
			end)
			return "<Ignore>"
		end, { expr = true })

		map("n", "[c", function()
			if vim.wo.diff then
				return "[c"
			end
			vim.schedule(function()
				gs.prev_hunk()
			end)
			return "<Ignore>"
		end, { expr = true })

		-- Actions
		map({ "n", "v" }, "<leader>hs", ":Gitsigns stage_hunk<CR>")
		map({ "n", "v" }, "<leader>hr", ":Gitsigns reset_hunk<CR>")
		map("n", "<leader>hS", gs.stage_buffer)
		map("n", "<leader>hu", gs.undo_stage_hunk)
		map("n", "<leader>hR", gs.reset_buffer)
		map("n", "<leader>hP", gs.preview_hunk)
		map("n", "<leader>hb", function()
			gs.blame_line { full = true }
		end)
		map("n", "<leader>tb", gs.toggle_current_line_blame)
		map("n", "<leader>hd", gs.diffthis)
		map("n", "<leader>hD", function()
			gs.diffthis "~"
		end)
		map("n", "<leader>td", gs.toggle_deleted)

		-- Text object
		map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>")
	end,

	watch_gitdir = {
		interval = 1000,
	},
	current_line_blame = false,
	update_debounce = 500,
	diff_opts = { internal = true },
	status_formatter = nil, -- Use default
}
