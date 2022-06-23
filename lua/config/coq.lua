local remap = vim.api.nvim_set_keymap
local npairs = require "nvim-autopairs"

local feedkeys = function(key, mode)
	vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
end

npairs.setup {
	map_cr = false,
	map_bs = false,
	map_c_h = true,
}

remap("i", "<esc>", [[pumvisible() ? "<c-e><esc>" : "<esc>"]], { expr = true, noremap = true })
remap("i", "<c-c>", [[pumvisible() ? "<c-e><c-c>" : "<c-c>"]], { expr = true, noremap = true })

_G.MUtils = {}
MUtils.CR = function()
	if vim.fn.pumvisible() ~= 0 then
		if vim.fn.complete_info({ "selected" }).selected ~= -1 then
			return npairs.esc "<c-y>"
		else
			-- you can change <c-g><c-g> to <c-e> if you don't use other i_CTRL-X modes
			return npairs.esc "<c-g><c-g>" .. npairs.autopairs_cr()
		end
	else
		return npairs.autopairs_cr()
	end
end
remap("i", "<cr>", "v:lua.MUtils.CR()", { expr = true, noremap = true })

MUtils.BS = function()
	if vim.fn.pumvisible() ~= 0 and vim.fn.complete_info({ "mode" }).mode == "eval" then
		return npairs.esc "<c-e>" .. npairs.autopairs_c_h()
	else
		return npairs.autopairs_c_h()
	end
end
remap("i", "<bs>", "v:lua.MUtils.BS()", { expr = true, noremap = false })

MUtils.TAB = function()
	if vim.fn.pumvisible() ~= 0 then
		feedkeys("<c-n>", "n")
	else
		feedkeys("<tab>", "n")
	end
end
inoremap { "<tab>", MUtils.TAB }

MUtils.S_TAB = function()
	if vim.fn.pumvisible() ~= 0 then
		feedkeys("<c-p>", "n")
	else
		feedkeys("<bs>", "n")
	end
end
inoremap { "<s-tab>", MUtils.S_TAB }
