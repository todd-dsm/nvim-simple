-- Custom bash snippets
-- Preserves exact vim-simple snippets with modern [[ ]] syntax

local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
	-- if statement with [[ ]] syntax
	s("if", {
		t("if [[ "),
		i(1, "condition"),
		t(" ]]; then"),
		t({ "", "\t" }),
		i(0),
		t({ "", "fi" }),
	}),

	-- elif statement with [[ ]] syntax
	s("elif", {
		t("elif [[ "),
		i(1, "condition"),
		t(" ]]; then"),
		t({ "", "\t" }),
		i(0),
	}),

	-- for loop
	s("for", {
		t("for "),
		i(1, "i"),
		t(" in "),
		i(2, "words"),
		t("; do"),
		t({ "", "\t" }),
		i(0),
		t({ "", "done" }),
	}),

	-- while loop with [[ ]] syntax
	s("while", {
		t("while [[ "),
		i(1, "condition"),
		t(" ]]; do"),
		t({ "", "\t" }),
		i(0),
		t({ "", "done" }),
	}),

	-- case statement
	s("case", {
		t("case "),
		i(1, "word"),
		t(" in"),
		t({ "", "\t" }),
		i(2, "pattern"),
		t(")"),
		t({ "", "\t\t" }),
		i(0),
		t({ "", "\t\t;;" }),
		t({ "", "esac" }),
	}),

	-- function definition
	s("func", {
		i(1, "function_name"),
		t("() {"),
		t({ "", "\t" }),
		i(0),
		t({ "", "}" }),
	}),

	-- until loop with [[ ]] syntax
	s("until", {
		t("until [[ "),
		i(1, "condition"),
		t(" ]]; do"),
		t({ "", "\t" }),
		i(0),
		t({ "", "done" }),
	}),
}
