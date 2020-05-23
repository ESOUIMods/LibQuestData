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

lib.objective_names["jp"] = {
    [4255] = "Vulkhel Guard",
    [6045] = "Everwound Wellspring",
    [4664] = "Hazak's Hollow",
    [4625] = "Temple of the Mourning Springs",
    [4673] = "Windcatcher Plantation",
    [4692] = "Laughing Moons Plantation",
    [4620] = "Shattered Shoals",
    [4693] = "Speckled Shell Plantation",
    [6045] = "Everwound Wellspring",
    [4624] = "Mistral",
}
