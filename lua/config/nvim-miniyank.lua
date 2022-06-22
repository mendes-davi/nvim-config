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

-- " make Y consistent with C and D. See :help Y.
nnoremap { "Y", "y$" }
