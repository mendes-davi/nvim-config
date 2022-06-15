map { "p", "<Plug>(miniyank-autoput)" }
map { "P", "<Plug>(miniyank-autoPut)" }
-- Don't touch unnamed register when pasting over visual selection
xnoremap {
	"p",
	function()
		return '<Plug>(miniyank-autoput)gv"' .. vim.v.register .. "y"
	end,
	expr = true,
}

map { "<leader>n", "<Plug>(miniyank-cycle)" }
map { "<leader>N", "<Plug>(miniyank-cycleback)" }
-- " the standard "+gP and "+y commands very difficult to use
vmap { "<RightMouse>", '"+y' }
vmap { "<leader>yy", '"+y' }
nnoremap { "<C-y>", '"+y' }
vnoremap { "<C-y>", '"+y' }
nnoremap { "<C-p>", '"+gP' }
vnoremap { "<C-p>", '"+gP' }
-- " make Y consistent with C and D. See :help Y.
nnoremap { "Y", "y$" }
