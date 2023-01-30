require "utils"

-------------------------------------------------------------------
-- let global vars (let g:xx = xxx)
-------------------------------------------------------------------

Variable.g {
	-- " enable embeded lua syntax
	-- " see https://github.com/neovim/neovim/pull/14213
	vimsyn_embed = "l",
	mousehide = true, --  "hide when characters are typed
}

-------------------------------------------------------------------
-- set global options (set xxx = xxx)
-------------------------------------------------------------------

Option.g {
	fileencodings = "ucs-bom,utf-8,default,latin1",
	encoding = "utf-8", -- "set encoding for text
	--     " enable true colors
	-- " If you're using tmux version 2.2 or later, you can remove the outermost $TMUX check and use tmux's 24-bit color support
	-- " (see < http://sunaku.github.io/tmux-24bit-color.html#usage > for more information.)
	-- " Tmux
	-- " Tmux version must >= v2.2
	-- " set your $TERM to "xterm-256color"
	-- " add this line to your .tmux.conf:
	-- " set-option -ga terminal-overrides ",xterm-256color:Tc"
	-- " enable "true color" in the terminal
	termguicolors = true,

	-- " Neovim ignores t_Co and other terminal codes
	-- " see https://github.com/neovim/neovim/wiki/FAQ#colors-arent-displayed-correctly
	-- " set t_Co=256

	-- enable cursorline
	cursorline = true,

	-- for simnalamburt/vim-mundo
	-- enable persistent undo so that undo history persists across vim sessions
	undofile = true,
	cmdheight = 1,
	laststatus = 3,
	--  -- INSERT -- is unnecessary anymore because the mode information is displayed in the statusline
	showmode = false,
	-- Set completeopt to have a better completion experience
	completeopt = "menuone,noinsert,noselect",
	-- Avoid showing message extra message when using completion
	shortmess = vim.o.shortmess .. "c",
	-- lua print(vim.bo.list)
	-- E5108: Error executing lua /usr/local/share/nvim/runtime/lua/vim/_meta.lua:94: 'list' is a window option, not a buffer option. See ":help list"
	-- but it is OK: lua print(vim.bo.list)
	-- highlight whitespace
	list = false,
	whichwrap = "<,>,[,],h,l",

	-- stylua: ignore
	listchars = "nbsp:⦸,extends:»,precedes:«,tab:▷⋯,trail:•,space:·,eol:↲,conceal:┊",

	fillchars = "diff:╱,fold:·,vert:┃,foldopen:,foldclose:",

	-- " The delay is governed by vim's updatetime option,
	-- " default updatetime 4000ms is not good for async update
	updatetime = 300,

	-- set signcolumn to 2 to avoid git gutter sign conflict with linter sign
	signcolumn = "auto",
	-- set fold column
	foldcolumn = "auto",

	background = "dark",

	-- base configuration
	title = true,
	-- titlestring is: relative-short-path [+=-] - NVIM
	titlestring = [[%{pathshorten(fnamemodify(expand('%'), ':~:.'))}%m - NVIM]],
	titlelen = 50, -- default is 85
	timeoutlen = 500, --mapping timeout
	ttimeoutlen = 100, --keycode timeout

	mouse = "a", --"enable mouse
	history = 1000, --number of command lines to remember
	ttyfast = true, -- assume fast terminal connection
	viewoptions = "folds,options,cursor,unix,slash", -- unix/windows compatibility
	hidden = true, -- allow buffer switching without saving
	autoread = true, -- auto reload if file saved externally
	fileformats = "unix,dos,mac", -- add mac to auto-detection of file format line endings
	-- nrformats = "bin,hex"
	showcmd = true,
	showfulltag = true,
	modeline = true,
	modelines = 5,

	shelltemp = false, -- use pipes
	-- whitespace
	backspace = "indent,eol,start", --" allow backspacing everything in insert mode
	autoindent = true, --          " automatically indent to match adjacent lines
	expandtab = true, --" spaces instead of tabs
	smarttab = true, --" use shiftwidth to enter tabs
	tabstop = 4, --" number of spaces per tab for display
	softtabstop = 4, --" number of spaces per tab in insert mode
	shiftwidth = 4, --" number of spaces when indenting
	shiftround = true,
	linebreak = true,
	showbreak = "↳ ",

	scrolloff = 5, --always show content after scroll
	scrolljump = 0, --minimum number of lines to scroll
	display = "lastline,msgsep",
	wildmenu = true, --show list for autocomplete
	wildmode = "longest:full,full", -- Command-line completion mode
	wildignorecase = true,
	wildcharm = vim.fn.char2nr "", -- <C-z>

	splitbelow = true,
	splitright = true,
	-- splitkeep (former stabilize.nvim)
	splitkeep = "screen",

	-- disable sounds
	visualbell = false,

	-- searching
	hlsearch = true, --"highlight searches
	incsearch = true, --"incremental searching
	ignorecase = true, --"ignore case for searching
	smartcase = true, --"do case-sensitive if there's a capital letter

	--  backups
	backup = true,
	backupdir = vim.fn.expand(vim.fn.stdpath "data" .. "/backup"),
	-- no swap files
	swapfile = false,

	-- ui configuration
	showmatch = true, --"automatically highlight matching braces/brackets/etc.
	matchtime = 2, --"tens of a second to show matching parentheses
	number = true,
	lazyredraw = true,
	foldenable = true, --"enable folds by default
	foldmethod = "indent", --"do not use syntax as fdm due to performance issue
	foldlevelstart = 99, --"open all folds by default

	textwidth = 100,
	-- colorcolumn = "+1", --highlight column after 'textwidth'

	formatoptions = "jql",

	clipboard = "unnamedplus",

	pumblend = 15,
}

-- fixup SHELL env in docker (for example: FTerm.nvim)
if not os.getenv "SHELL" then
	vim.fn.setenv("SHELL", "sh")
end

if string.match(os.getenv "SHELL" or "bash", "/fish$") then
	-- VIM expects to be run from a POSIX shell.
	vim.go.shell = "sh"
end

if vim.fn.executable "rg" then
	-- " When the --vimgrep flag is given to ripgrep, then the default value for the --color flag changes to 'never'.
	vim.go.grepprg = "rg --no-heading --vimgrep --smart-case --follow"
	vim.go.grepformat = "%f:%l:%c:%m"
end

-- local options
-- https://neovim.io/doc/user/options.html#local-options

-- window options
Option.w {}

-- buffer options
Option.b {}

-------------------------------------------------------------------
-- keybinds
-------------------------------------------------------------------
nnoremap { "c", '"_c' }
nnoremap { "<S-Tab>", "za" }

-- `<Tab>`/`<S-Tab>` to move between matches without leaving incremental search.
-- Note dependency on `'wildcharm'` being set to `<C-z>` in order for this to
-- work.
local t = function(key)
	return vim.api.nvim_replace_termcodes(key, true, true, true)
end
local is_search = function()
	local cmdtype = vim.fn.getcmdtype()
	return cmdtype == "/" or cmdtype == "?"
end

cnoremap {
	"<Tab>",
	function()
		if is_search() then
			return t "<CR>/<C-r>/"
		else
			return t "<C-z>"
		end
	end,
	expr = true,
}
cnoremap {
	"<S-Tab>",
	function()
		if is_search() then
			return t "<CR>?<C-r>/"
		else
			return t "<S-Tab>"
		end
	end,
	expr = true,
}

inoremap { "jk", "<Esc>" }

-- " in visual mode you can select text, type tb and it'll be replaced by the command output
-- " https://vi.stackexchange.com/questions/7388/replace-selection-with-output-of-external-command/17949#17949
vnoremap { "tb", 'c<C-R>=system(@")<CR><ESC>' }

--   " remap arrow keys
--   " quick switch buf
nnoremap { "<up>", "<cmd> bprev<CR>" }
nnoremap { "<down>", "<cmd> bnext<CR>" }

--   " quick switch tab window
nnoremap { "<right>", "<cmd> tabnext<CR>" }
nnoremap { "<left>", "<cmd> tabprev<CR>" }

--   " change cursor position in insert mode
inoremap { "<C-h>", "<left>" }
inoremap { "<C-l>", "<right>" }

inoremap { "<C-u>", "<C-g>u<C-u>" }

--   " sane regex
nnoremap { "/", "/\\v" }
vnoremap { "/", "/\\v" }
nnoremap { "?", "?\\v" }
vnoremap { "?", "?\\v" }
nnoremap { ":s/", ":s/\\v" }

--   " command-line window
nnoremap { "q:", "q:i" }
nnoremap { "q/", "q/i" }
nnoremap { "q?", "q?i" }

--   " folds
nnoremap { "zr", "zr<cmd> echo &foldlevel<cr>" }
nnoremap { "zm", "zm<cmd> echo &foldlevel<cr>" }
nnoremap { "zR", "zR<cmd> echo &foldlevel<cr>" }
nnoremap { "zM", "zM<cmd> echo &foldlevel<cr>" }

--   " screen line scroll
nnoremap { "j", "gj" }
nnoremap { "k", "gk" }

--   " auto center
nnoremap { "n", "nzz", silent = true }
nnoremap { "N", "Nzz", silent = true }
nnoremap { "*", "*zz", silent = true }
nnoremap { "#", "#zz", silent = true }
nnoremap { "g*", "g*zz", silent = true }
nnoremap { "g#", "g#zz", silent = true }
nnoremap { "<C-o>", "<C-o>zz", silent = true }
nnoremap { "<C-i>", "<C-i>zz", silent = true }

--   " reselect visual block after indent
vnoremap { "<", "<gv" }
vnoremap { ">", ">gv" }

-- " reselect last pasted text
nnoremap { "gp", "`[v`]" }

--   " hide annoying quit message
nnoremap { "<C-c>", "<C-c><cmd> echo<cr>" }

--   " general
--   " nnoremap <BS> :set hlsearch! hlsearch?<cr>
--   " better nohl via https://vi.stackexchange.com/a/252
nnoremap { "<BS>", '<cmd> let @/=""<cr>' }
--   " Press Space to turn off highlighting and clear any message already displayed.
--   " nnoremap <silent> <Space> :nohlsearch<Bar>:echo<CR>

--   " leave without save
map { "<A-s>", "<cmd> write<CR>", nowait = true }
imap { "<A-s>", "<cmd> write<CR>", nowait = true }

--   " save as sudo
vim.cmd "cabbrev w!! execute 'silent! write !sudo tee % >/dev/null' <bar> edit!<CR>"
