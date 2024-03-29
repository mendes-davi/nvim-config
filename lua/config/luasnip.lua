local ls = require "luasnip"
local types = require "luasnip.util.types"

local feedkeys = function(key, mode)
	vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
end

ls.config.set_config {
	store_selection_keys = "<Tab>",
	history = true,
	updateevents = "TextChanged,TextChangedI",
	delete_check_events = "TextChanged,InsertLeave",
	enable_autosnippets = true,
	ext_opts = {
		[types.choiceNode] = {
			active = {
				virt_text = { { "", "Orange" } },
			},
		},
		[types.insertNode] = {
			active = {
				virt_text = { { "", "Blue" } },
			},
		},
	},
}

-- Load Snippets
require("luasnip.loaders.from_lua").lazy_load { paths = "~/.config/nvim/lua/snips/ft" }

-- <c-j> is my expansion key
-- this will expand the current item or jump to the next item within the snippet.
vim.keymap.set({ "i", "s", "x" }, "<c-j>", function()
	if ls.expand_or_jumpable() then
		ls.expand_or_jump()
	end
end, { silent = true, desc = "LuaSnip Forward Expand or Jump" })

-- <c-k> is my jump backwards key.
-- this always moves to the previous item within the snippet
vim.keymap.set({ "i", "s", "x" }, "<c-k>", function()
	if ls.jumpable(-1) then
		ls.jump(-1)
	end
end, { silent = true, desc = "LuaSnip Backward Jump" })

-- <c-l> is selecting within a list of options.
vim.keymap.set({ "i", "s" }, "<c-l>", function()
	if ls.choice_active() then
		ls.change_choice(1)
	else
		feedkeys("<right>", "n")
	end
end, { silent = true, desc = "LuaSnip Choice (fallback to <right>)" })

vim.keymap.set("i", "<c-u>", function()
	if ls.choice_active() then
		require "luasnip.extras.select_choice"
	end
end, { desc = "LuaSnip Select Choice" })

vim.keymap.set({ "i", "v" }, "<c-f>", "<cmd>lua require('luasnip.extras.otf').on_the_fly('s')<cr>", { desc = "LuaSnips Register Snippet" })
