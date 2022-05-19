local ls = require "luasnip"
local types = require "luasnip.util.types"

ls.config.set_config {
	history = true,
	updateevents = "TextChanged,TextChangedI",
	enable_autosnippets = true,
	ext_opts = {
		[types.choiceNode] = {
			active = {
				virt_text = { { " <- Current Choice", "NonTest" } },
			},
		},
	},
}

-- Load Snippets
require("luasnip.loaders.from_lua").load { paths = "~/.config/nvim/lua/snips/ft" }

-- <c-j> is my expansion key
-- this will expand the current item or jump to the next item within the snippet.
vim.keymap.set({ "i", "s" }, "<c-j>", function()
	if ls.expand_or_jumpable() then
		ls.expand_or_jump()
	end
end, { silent = true })

-- <c-k> is my jump backwards key.
-- this always moves to the previous item within the snippet
vim.keymap.set({ "i", "s" }, "<c-k>", function()
	if ls.jumpable(-1) then
		ls.jump(-1)
	end
end, { silent = true })

-- <c-l> is selecting within a list of options.
vim.keymap.set({ "i", "s" }, "<c-l>", function()
	if ls.choice_active() then
		ls.change_choice(1)
	end
end, { silent = true })

vim.keymap.set("i", "<c-u>", require "luasnip.extras.select_choice")

-- Reload Snippets
vim.keymap.set("n", "<leader><leader>s", ":source ~/.config/nvim/lua/config/luasnip.lua<CR>")
