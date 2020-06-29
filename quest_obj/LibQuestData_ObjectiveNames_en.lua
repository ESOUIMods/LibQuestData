--[[

LibQuestData
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
local lib = _G["LibQuestData"]

lib.objective_names["en"] = {
    [3822] = "Mud Tree Village",
    [3840] = "Bogmother",
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
    [6189] = "March of Sacrifices",
    [5301] = "Dungeon: Tempest Island",
    [5275] = "Dungeon: Darkshade Caverns I",
    [6497] = "Nchuthnkarst",
    [6162] = "Karnwasten",
    [4396] = "Haven",
    [4329] = "College of Aldmeri Propriety",
    [4338] = "Greenwater Cove",
    [4355] = "Dawnbreak",
    [4300] = "Torinaan",
    [4309] = "North Beacon",
    [4295] = "North Beacon",
    [4326] = "Quendeluun",
    [4220] = "Ezduiin",
    [4272] = "Glister Vale",
    [4441] = "Toothmaul Gully",
    [4293] = "Mathiisen",
    [4264] = "Phaer",
    [4277] = "Shattered Grove",
    [3999] = "Halmaera's House",
    [3996] = "Frostedge Camp",
    [3992] = "Skyshroud Barrow",
    [4016] = "Bleakrock Village",
    [4002] = "Bleakrock Village",
    [3987] = "Hozzin's Folly",
    [3988] = "Hunter's Camp",
    [3991] = "Bleakrock Village",
    [4023] = "Dhalmora",
    [6316] = "Weeping Scar",
    [3784] = "Bonesnap Ruins",
    [4893] = "Redfur Trading Post",
    [3783] = "Bonesnap Ruins",
    [4406] = "Root Sunder Ruins",
    [4436] = "Cave of Broken Sails",
    [4813] = "Dungeon: Wayrest Sewers II",
    [4246] = "Dungeon: Wayrest Sewers I",
    [6351] = "Dungeon: Lair of Maarselok",
    [4738] = "The Vile Manse",
    [4737] = "The Vile Manse",
    [4146] = "Forgotten Crypts",
    [4151] = "Forgotten Crypts",
    [4841] = "Rain Catcher Fields",
    [2550] = "Soulshriven Tower",
    [2251] = "Bergama",
}
