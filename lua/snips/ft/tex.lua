local ls = require "luasnip"
local s = ls.s
local r = ls.restore_node
local sn = ls.sn
local isn = ls.indent_snippet_node
local i = ls.insert_node
local t = ls.text_node
local d = ls.dynamic_node
local c = ls.choice_node
local f = ls.function_node
local FMT = require "luasnip.extras.fmt"
local fmta = FMT.fmta
local m = require("luasnip.extras").m

local shared = R "snips"
local same = shared.same

local tex = {}
tex.in_mathzone = function()
	return vim.fn["vimtex#syntax#in_mathzone"]() == 1
end
tex.in_text = function()
	return not tex.in_mathzone()
end
tex.in_env = function(env)
	vim.validate { env = { env, "string" } }
	local ret = vim.fn["vimtex#env#is_inside"](env)
	return ret[1] ~= 0 and ret[2] ~= 0
end
tex.in_item = function()
	return tex.in_env "itemize" or tex.in_env "enumerate"
end

local rec_item
rec_item = function()
	return sn(nil, {
		c(1, {
			-- important!! Having the sn(...) as the first choice will cause infinite recursion.
			t { "" },
			-- The same dynamicNode as in the snippet (also note: self reference).
			sn(nil, { t { "", "\t\\item " }, i(1), d(2, rec_item, {}) }),
		}),
	})
end

-- AUTOSNIPPETS
ls.add_snippets("tex", {
	-- \begin{} \end{}
	s(
		{ trig = "^beg", regTrig = true, hidden = true },
		fmta(
			[[
            \begin{<>} 
            <>
            \end{<>}
            <>
            ]],
			{ i(1), i(2), same(1), i(0) }
		)
	),

	-- inlinemath (in text mode)
	s({ trig = "mk", wordTrig = false, hidden = true }, fmta([[$<>$<>]], { i(1), i(0) }), { condition = tex.in_text }),

	-- ldots ...
	s({ trig = "...", wordTrig = false, hidden = true }, t [[\ldots]]),

	-- (sq)rt (in math mode)
	s({ trig = "sq", wordTrig = false, hidden = true }, fmta([[\sqrt{<>}<>]], { i(1), i(0) }), { condition = tex.in_mathzone }),

	-- frac (in math mode)
	s({ trig = "//", wordTrig = false, hidden = true }, fmta([[\frac{<>}{<>}<>]], { i(1), i(2), i(0) }), { condition = tex.in_mathzone }),

	-- equals (in math mode)
	s({ trig = "==", wordTrig = false, hidden = true }, fmta([[&= <>]], { c(1, { i(nil, ""), t [[ \\]] }) }), { condition = tex.in_mathzone }),

	-- neq (in math mode)
	s({ trig = "!=", wordTrig = false, hidden = true }, fmta([[\neq <>]], { i(0) }), { condition = tex.in_mathzone }),

	-- le & ge (in math mode)
	s({ trig = "leq", wordTrig = true, hidden = true }, fmta([[\le <>]], { i(0) }), { condition = tex.in_mathzone }),
	s({ trig = "geq", wordTrig = true, hidden = true }, fmta([[\ge <>]], { i(0) }), { condition = tex.in_mathzone }),

	-- td "to the power ^{}" (in math mode)
	s(
		{ trig = "td", wordTrig = false, hidden = true },
		fmta([[^{<>}<>]], { c(1, { i(nil, ""), sn(nil, { t "(", i(1), t ")" }) }), i(0) }),
		{ condition = tex.in_mathzone }
	),

	-- subscript (in math mode)
	s(
		{ trig = "__", wordTrig = false, hidden = true },
		fmta([[_{<>}<>]], { c(1, { i(nil, ""), sn(nil, { t "(", i(1), t ")" }) }), i(0) }),
		{ condition = tex.in_mathzone }
	),

	-- autosubscript
	s(
		{ trig = "([a-zA-Z])(%d)", regTrig = true, hidden = true },
		fmta([[<>_<><><><>]], {
			f(function(_, snip)
				return snip.captures[1]
			end),
			m(1, "%d", "{"),
			f(function(_, snip)
				return snip.captures[2]
			end),
			i(1),
			m(1, "%d", "}"),
		}),
		{ condition = tex.in_mathzone }
	),

	-- to (in math mode)
	s({ trig = "->", wordTrig = false, hidden = true }, fmta([[\to <>]], { i(0) }), { condition = tex.in_mathzone }),

	-- typographic text (in text mode)
	s({ trig = "ttt", wordTrig = false, hidden = true }, fmta([[\texttt{<>}<>]], { i(1), i(0) }), { condition = tex.in_text }),

	-- item (in itemize or enumerate)
	s({ trig = "^%s*it", regTrig = true, hidden = true }, fmta([[\item <>]], { i(0) }), { condition = tex.in_item }),

	-- (sub)section
	s({ trig = "^%s*(s*)sec", wordTrig = true, regTrig = true }, {
		f(function(_, snip)
			return { "\\" .. string.rep("sub", string.len(snip.captures[1])) }
		end, {}),
		t { "section{" },
		i(1),
		t { "}", "" },
		i(0),
	}),
}, {
	type = "autosnippets",
	key = "tex_auto",
})

-- GENERATED AUTOSNIPPETS
local math_fun_snips = {}
local math_funs = {
	"sin",
	"cos",
	"arccot",
	"cot",
	"csc",
	"ln",
	"log",
	"exp",
	"star",
	"perp",
	"arcsin",
	"arccos",
	"arctan",
	"arccot",
	"arccsc",
	"arcsec",
	"pi",
	"zeta",
	"int",
}

for _, fun in pairs(math_funs) do
	local snip = s({ trig = "(\\?)(" .. fun .. ")", regTrig = true, hidden = true }, fmta("\\" .. fun .. "<>", { i(0) }), { condition = tex.in_mathzone })
	table.insert(math_fun_snips, snip)
end

ls.add_snippets("tex", math_fun_snips, {
	type = "autosnippets",
	key = "auto_math_funs",
})

-- SNIPPETS
return {
	-- item & enumerate
	s("item", {
		t { "\\begin{itemize}", "\t\\item " },
		i(1),
		d(2, rec_item, {}),
		t { "", "\\end{itemize}" },
		i(0),
	}),
	s("enum", {
		t { "\\begin{enumerate}", "\t\\item " },
		i(1),
		d(2, rec_item, {}),
		t { "", "\\end{enumerate}" },
		i(0),
	}),

	-- text (in math mode)
	s({ trig = "tt", dscr = "text" }, fmta([[\text{<>}<>]], { i(1), i(0) }), { condition = tex.in_mathzone }),

	-- bold & italic (in math mode)
	s({ trig = "bf", dscr = "bold" }, fmta([[\mathbf{<>}<>]], { i(1), i(0) }), { condition = tex.in_mathzone }),
	s({ trig = "it", dscr = "italic" }, fmta([[\mathit{<>}<>]], { i(1), i(0) }), { condition = tex.in_mathzone }),
	-- bold & italic (in text mode)
	s({ trig = "bf", dscr = "bold" }, fmta([[\textbf{<>}<>]], { i(1), i(0) }), { condition = tex.in_text }),
	s({ trig = "it", dscr = "italic" }, fmta([[\textit{<>}<>]], { i(1), i(0) }), { condition = tex.in_text }),
}
