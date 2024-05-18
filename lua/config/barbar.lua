local map = vim.api.nvim_set_keymap
local opts = { noremap = true }

-- Move to previous/next
map("n", "<A-[>", "<cmd>BufferPrevious<CR>", opts)
map("n", "<A-]>", "<cmd>BufferNext<CR>", opts)
-- Re-order to previous/next
map("n", "<A-<>", "<cmd>BufferMovePrevious<CR>", opts)
map("n", "<A->>", "<cmd>BufferMoveNext<CR>", opts)
-- Goto buffer in position...
map("n", "<A-1>", "<cmd>BufferGoto 1<CR>", opts)
map("n", "<A-2>", "<cmd>BufferGoto 2<CR>", opts)
map("n", "<A-3>", "<cmd>BufferGoto 3<CR>", opts)
map("n", "<A-4>", "<cmd>BufferGoto 4<CR>", opts)
map("n", "<A-5>", "<cmd>BufferGoto 5<CR>", opts)
map("n", "<A-6>", "<cmd>BufferGoto 6<CR>", opts)
map("n", "<A-7>", "<cmd>BufferGoto 7<CR>", opts)
map("n", "<A-8>", "<cmd>BufferGoto 8<CR>", opts)
map("n", "<A-9>", "<cmd>BufferGoto 9<CR>", opts)
map("n", "<A-0>", "<cmd>BufferLast<CR>", opts)
-- Close buffer
map("n", "<A-e>", "<cmd>BufferClose<CR>", opts)
-- Wipeout buffer
map("n", "<A-E>", "<cmd>bw!<CR>", opts)

-- Close commands
--                 <cmd>BufferCloseAllButCurrent<CR>
--                 <cmd>BufferCloseBuffersLeft<CR>
--                 <cmd>BufferCloseBuffersRight<CR>
-- Magic buffer-picking mode
map("n", "<A-u>", "<cmd>BufferPick<CR>", opts)

-- Sort automatically by...
-- map('n', '<Space>bd', '<cmd>BufferOrderByDirectory<CR>', opts)
-- map('n', '<Space>bl', '<cmd>BufferOrderByLanguage<CR>', opts)

-- Other:
-- :BarbarEnable - enables barbar (enabled by default)
-- :BarbarDisable - very bad command, should never be used

-- Set barbar's options
require("barbar").setup {
	-- Enable/disable animations
	animation = true,

	-- Enable/disable auto-hiding the tab bar when there is a single buffer
	auto_hide = false,

	-- Enable/disable current/total tabpages indicator (top right corner)
	tabpages = true,

	-- Enables/disable clickable tabs
	--  - left-click: go to buffer
	--  - middle-click: delete buffer
	clickable = true,

	-- Excludes buffers from the tabline
	exclude_ft = {
		"NvimTree",
		"packer",
		"startify",
		"fugitive",
		"fugitiveblame",
		"vista_kind",
		"dap-repl",
	},
	exclude_name = { "package.json", "NvimTree_1" },

	-- Enable/disable icons
	icons = {
		-- Configure the base icons on the bufferline.
		buffer_index = true,
		buffer_number = false,
		button = "",
		-- Enables / disables diagnostic symbols
		diagnostics = {
			[vim.diagnostic.severity.ERROR] = { enabled = false },
			[vim.diagnostic.severity.WARN] = { enabled = false },
			[vim.diagnostic.severity.INFO] = { enabled = false },
			[vim.diagnostic.severity.HINT] = { enabled = false },
		},
		filetype = {
			-- Sets the icon's highlight group.
			-- If false, will use nvim-web-devicons colors
			custom_colors = false,

			-- Requires `nvim-web-devicons` if `true`
			enabled = true,
		},
		separator = { left = "▎", right = "" },

		-- Configure the icons on the bufferline when modified or pinned.
		-- Supports all the base icon options.
		modified = { button = "●" },
		pinned = { button = "車" },

		-- Configure the icons on the bufferline based on the visibility of a buffer.
		-- Supports all the base icon options, plus `modified` and `pinned`.
		alternate = { filetype = { enabled = false } },
		current = { buffer_index = true },
		inactive = { button = "" },
		visible = { modified = { buffer_number = false } },
	},

	sidebar_filetypes = { NvimTree = true },

	-- If true, new buffers will be inserted at the end of the list.
	-- Default is to insert after current buffer.
	insert_at_end = false,
	insert_at_start = false,

	-- Sets the maximum padding width with which to surround each tab
	maximum_padding = 100,
	minimum_padding = 2,

	-- Sets the maximum buffer name length.
	maximum_length = 30,

	-- If set, the letters for each buffer in buffer-pick mode will be
	-- assigned based on their name. Otherwise or in case all letters are
	-- already assigned, the behavior is to assign letters in order of
	-- usability (see order below)
	semantic_letters = true,

	-- New buffer letters are assigned in this order. This order is
	-- optimal for the qwerty keyboard layout but might need adjustement
	-- for other layouts.
	letters = "asdfjkl;ghnmxcvbziowerutyqpASDFJKLGHNMXCVBZIOWERUTYQP",

	-- Sets the name of unnamed buffers. By default format is "[Buffer X]"
	-- where X is the buffer number. But only a static string is accepted here.
	no_name_title = nil,
}
