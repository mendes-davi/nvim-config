vim.o.guifont = "Inconsolata LGC Nerd Font Mono:h11"

vim.keymap.set("v", "<A-c>", '"+y') -- Copy
vim.keymap.set("n", "<A-v>", '"+P') -- Paste normal mode
vim.keymap.set("v", "<A-v>", '"+P') -- Paste visual mode
vim.keymap.set("c", "<A-v>", "<C-R>+") -- Paste command mode
vim.keymap.set("i", "<A-v>", '<ESC>l"+Pli') -- Paste insert mode

vim.g.neovide_scale_factor = 1.0

local change_scale_factor = function(delta)
	vim.g.neovide_scale_factor = vim.g.neovide_scale_factor * delta
end

vim.keymap.set("n", "<C-=>", function()
	change_scale_factor(1.1)
end)
vim.keymap.set("n", "<C-->", function()
	change_scale_factor(1 / 1.1)
end)
vim.keymap.set("n", "<C-0>", function()
	vim.g.neovide_scale_factor = 1.0
end)

vim.g.neovide_padding_top = 4
vim.g.neovide_padding_bottom = 4
vim.g.neovide_padding_right = 4
vim.g.neovide_padding_left = 4

-- Helper function for transparency formatting
-- local alpha = function()
--     return string.format("%x", math.floor(255 * vim.g.transparency or 0.8))
-- end
-- g:neovide_transparency should be 0 if you want to unify transparency of content and title bar.
-- vim.g.neovide_transparency = 0.95
-- vim.g.transparency = 0.0
-- vim.g.neovide_background_color = "#0f1117" .. alpha()
