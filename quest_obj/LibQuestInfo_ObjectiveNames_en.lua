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
    [4664] = "Hazak's Hollow",
    [4625] = "Temple of the Mourning Springs",
    [4673] = "Windcatcher Plantation",
    [4692] = "Laughing Moons Plantation",
    [4620] = "Shattered Shoals",
    [4693] = "Speckled Shell Plantation",
    [4624] = "Mistral",
    [4621] = "Cat's Eye Quay",
    [4208] = "Silsailen",
    [4361] = "Castle Rilis",
    [4219] = "South Beacon",
    [3995] = "Orkey's Hollow",
    [6480] = "The Lightless Hollow",
    [6465] = "Kilkreath Temple",
    [6468] = "Karthwatch",
    [6471] = "Dusktown",
    [6472] = "Greymoor Keep",
    [6459] = "Morthal",
    [6460] = "The Silver Cormorant",
    [6461] = "Dark Moon Grotto",
    [6484] = "Mor Khazgur",
    [6473] = "Dragon Bridge",
}
