--[[

LibQuestInfo
by Sharlikran
https://sharlikran.github.io/

^(\d{1,4}), "(.*)"
    \[\1] = "\2",

(.*) = "(.*)" = "(.*), ",
"\2", = \{\3\,},

^"(.*)", = \{(.*)\},
    \["\1"] = \{\2 },

For renumbering new rebuilt tables

(.*)\[(\d{1,4})\] = "(.*)",
\2, "\3"


--]]
local lib = _G["LibQuestInfo"]

lib.objective_names["en"] = {
    [4255] = "Vulkhel Guard",
    [6045] = "Everwound Wellspring",
}
