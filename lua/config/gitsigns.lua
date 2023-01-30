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
		local wk_ok, wk = pcall(require, "which-key")

		local function map(mode, lhs, rhs, opts)
			opts = opts or {}
			opts.buffer = bufnr

			if wk_ok and opts.desc ~= nil then
				local wk_opts = {
					mode = mode,
					prefix = "",
					buffer = opts.buffer,
					silent = opts.silent or false,
					noremap = opts.noremap or false,
					nowait = opts.nowait or false,
				}

				if type(mode) == "string" then
					-- Registering label for operator-pending mode would cause duplicate labels
					if mode == "o" then
						opts.desc = "which_key_ignore"
					end

					-- Use which-key
					wk.register({ [lhs] = { rhs, opts.desc } }, wk_opts)
				elseif type(mode) == "table" then
					for _, m in pairs(mode) do
						if m == "o" then
							opts.desc = "which_key_ignore"
						end

						wk_opts.mode = m
						wk.register({ [lhs] = { rhs, opts.desc } }, wk_opts)
					end
				end
			else
				-- Use LUA API
				vim.keymap.set(mode, lhs, rhs, opts)
			end
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
		end, { expr = true, desc = "Next Hunk" })

		map("n", "[c", function()
			if vim.wo.diff then
				return "[c"
			end
			vim.schedule(function()
				gs.prev_hunk()
			end)
			return "<Ignore>"
		end, { expr = true, desc = "Previous Hunk" })

		-- Actions
		map("n", "<leader>gX", ":Gitsigns setqflist<CR>", { desc = "Git Preview in QF" })
		map({ "n", "v" }, "<leader>gs", ":Gitsigns stage_hunk<CR>", { desc = "Stage Hunk" })
		map({ "n", "v" }, "<leader>gr", ":Gitsigns reset_hunk<CR>", { desc = "Reset Hunk" })
		map("n", "<leader>gS", gs.stage_buffer, { desc = "Stage Buffer" })
		map("n", "<leader>gu", gs.undo_stage_hunk, { desc = "Unstage Hunk" })
		map("n", "<leader>gR", gs.reset_buffer, { desc = "Reset Buffer" })
		map("n", "<leader>gp", gs.preview_hunk, { desc = "Preview Hunk" })
		map("n", "<leader>gb", function()
			gs.blame_line { full = true }
		end, { desc = "Blame" })
		map("n", "<leader>gB", gs.toggle_current_line_blame, { desc = "Toggle Blame" })
		map("n", "<leader>gd", gs.diffthis, { desc = "Diff This" })
		map("n", "<leader>gD", function()
			gs.diffthis "~"
		end, { desc = "Diff This ~" })
		map("n", "<leader>gx", gs.toggle_deleted, { desc = "Toggle Deleted" })

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
