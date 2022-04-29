#!/usr/bin/env lua
local telescope = require "telescope"
local actions = require "telescope.actions"

telescope.load_extension "dotfiles"
telescope.load_extension "dap"

nnoremap {
	"<leader><leader>", -- Fallback to find_files if git_files can't find a .git directory
	function()
		local opts = {}
		local ok = pcall(require("telescope.builtin").git_files, opts)
		if not ok then
			require("telescope.builtin").find_files(opts)
		end
	end,
}
nnoremap { "<leader>g", "<cmd>lua require('telescope.builtin').live_grep()<cr>" }
nnoremap {
	"<leader>b",
	"<cmd>lua require('telescope.builtin').buffers({ignore_current_buffer = true, sort_mru = true, layout_strategy='vertical',layout_config={width=80}})<cr>",
}
nnoremap { "<leader>fh", "<cmd>lua require('telescope.builtin').help_tags()<cr>" }
nnoremap { "<leader>A", "<cmd>lua require('telescope.builtin').lsp_code_actions({layout_strategy='cursor',layout_config={width=50, height = 10}})<cr>" }

-- Global remapping
------------------------------
require("telescope").setup {
	defaults = {
		mappings = {
			i = {
				-- To disable a keymap, put [map] = false
				-- So, to not map "<C-n>", just put
				["<C-n>"] = false,
				["<C-p>"] = false,

				["<C-j>"] = actions.move_selection_next,
				["<C-k>"] = actions.move_selection_previous,
			},
			n = {
				["q"] = actions.close,
				["yw"] = function(prompt_bufnr)
					local selection = require("telescope.actions.state").get_selected_entry()
					local dir = vim.fn.fnamemodify(selection.path, ":p:h")
					require("telescope.actions").close(prompt_bufnr)
					-- Depending on what you want put `cd`, `lcd`, `tcd`
					vim.cmd(string.format("silent lcd %s", dir))
				end,
			},
		},
		vimgrep_arguments = {
			"rg",
			"--color=never",
			"--no-heading",
			"--with-filename",
			"--line-number",
			"--column",
			"--smart-case",
			"--trim", -- avoid indentation for grep results
		},
	},
	pickers = {
		git_files = {
			show_untracked = false,
		},
		find_files = {
			find_command = { "fd", "--type", "f", "--strip-cwd-prefix" },
		},
	},
	extensions = {
		fzy_native = {
			override_generic_sorter = true,
			override_file_sorter = true,
		},
	},
}

-- This will load fzy_native and have it override the default file sorter
telescope.load_extension "fzy_native"
