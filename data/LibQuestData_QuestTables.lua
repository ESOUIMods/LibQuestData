local lib = _G["LibQuestData"]
--[[
This is a special table for preventing something
from being recorded or changed
]]--

local function quest_ids(list)
  local ids = {}
  for _, l in ipairs(list) do ids[l] = true end
  return ids
end

--[[ List of what the numbers mean
This is a list of special objects like notes and
signs. The key is the quest ID and the value is the
quest giver.

6420 - In Defense of Pellitine, A Job Offer Sign

5949 - For Glory Sign
6176 - Nafarion's Note, His Final Gift
6130 - Housing Brochure, Room To Spare
6514 - The Antiquarian Circle
6537 - Bloated Fish, Potent Poison
6510 - The Maelmoth Mysterium, Peculiar Bottle
6492 - Soldiers of Fortune and Glory, Notice
6467 - The Gathering Storm, Brondold
6455 - Bound in Blood, Sarcophagus
6066 - The Precursor, Bulletin Board
4526 - Lost Bet, Altmeri Relic
4220 - The Mallari-Mora, Umbarile
4531 - A Brush With Death, Watch Captain Astanya
3991 - Escape from Bleakrock,Captain Rana
6093 - The Mages Dog, Journal of a Stranded Mage
4146 - A Family Divided, Sela
5630 - Contract: Bangkorai, Marked for Death
5659 - Contract: Grahtwood, Marked for Death
6476 - Dark Clouds Over Solitude, Lyris Titanborn
6092 - The Merchant's Heirloom, Dulza's Log
6014 - Midyear Mayhem, Details on the Midyear Mayhem

6533 = Kelbarn's Mining Samples
6534 - Inguya's Mining Samples
6535 = Reeh-La's Mining Samples
6536 = Ghamborz's Mining Samples
6538 = Adanzda's Mining Samples
--]]
lib.questid_giver_lookup = {
    [6420] = 100035,
    [5949] = 100050,
    [6176] = 100032,
    [6130] = 100051,
    [6514] = 200002,
    [6537] = 200035,
    [6510] = 200044,
    [6492] = 100050,
    [6467] = 200045,
    [6455] = 200037,
    [6533] = 200041,
    [6534] = 200036,
    [6535] = 200040,
    [6536] = 200039,
    [6538] = 200037,
    [6066] = 100040,
    [4526] = 500008,
    [4220] = 54154,
    [4531] = 29300,
    [3991] = 24277,
    [6093] = 92009,
    [4146] = 27560,
    [5630] = 500120,
    [5659] = 500120,
    [6476] = 80006,
    [6092] = 100096,
    [6014] = 100101,
}

--[[ List of what the numbers mean
This is a list of special NPCs that run around
or hunt you down. Once XY location is set, do not
change it

68884 - Stuga: Quest ID 5450: "Invitation to Orsinium"
54154 - Umbarile: Quest ID 4220: "The Mallari-Mora"
52751 - Firtorel: Quest ID 5058: "All the Fuss"
32298 - Endaraste: Quest ID 4264: "Plague of Phaer"
31327 - Ceborn: Quest ID 4264: "Plague of Phaer"
30069 - Aninwe: Quest ID 4264: "Plague of Phaer"
31326 - Anganirne: Quest ID 4264: "Plague of Phaer"
24316 - Darj the Hunter: Quest ID 3992: "What Waits Beneath"
80016 - Librarian Bradyn: Quest ID 5923: "The Lost Library"
80016 - Librarian Bradyn: Quest ID 5950: "The Ancestral Tombs"
10714 - Rajesh : Quest ID 4841: "Trouble at the Rain Catchers"
11315 - Qadim : Quest ID 2251: "Gone Missing"
28505 - Bera Moorsmith : Quest ID 3858: "The Dangerous Past"

Note: Table is of Quest ID numbers since that
is part of the XY location information from
lib.quest_locations
--]]
-- 4841 need mor data first for Rajesh
lib.quest_giver_moves = { 5450, 4220, 5058, 4264, 3992, 5923, 5950, 2251, 3858, }

--[[
This is a list of qusts that give skill points

6455 - Bound in Blood
6050 - To The Clockwork City
6476 - Dark Clouds Over Solitude
6481 - Daughter of the Wolf
6466 - The Vampire Scholar
6057 - In Search of a Sponsor
6409 - Reformation
6394 - Uneasy Alliances
]]--

lib.quest_has_skill_point = { 465, 467, 575, 1633, 2192, 2222, 2997, 3006, 3235, 3267, 3379, 3634, 3735, 3797, 3817, 3831, 3867, 3868, 3968, 3993, 4054, 4061, 4107, 4115, 4117, 4139, 4143, 4188, 4222, 4261, 4319, 4337, 4345, 4346, 4386, 4432, 4452, 4474, 4479, 4542, 4552, 4590, 4602, 4606, 4607, 4613, 4690, 4712, 4720, 4730, 4733, 4750, 4758, 4764, 4765, 4778, 4832, 4836, 4837, 4847, 4868, 4884, 4885, 4891, 4912, 4960, 4972, 5090, 5433, 6455, 6476, 6050, 6481, 6466, 6057, 6409, }

lib.quest_cadwell = quest_ids { 465, 467, 737, 736, 1341, 1346, 1437, 1529, 1536, 1541, 1591, 1799, 1834, 2130, 2146, 2184, 2192, 2222, 2495, 2496, 2497, 2552, 2564, 2566, 2567, 2997, 3064, 3082, 3174, 3189, 3191, 3235, 3267, 3277, 3280, 3338, 3379, 3584, 3585, 3587, 3588, 3615, 3616, 3632, 3633, 3634, 3637, 3673, 3686, 3687, 3695, 3696, 3705, 3734, 3735, 3749, 3791, 3797, 3810, 3817, 3818, 3826, 3831, 3837, 3838, 3868, 3909, 3928, 3957, 3968, 3978, 4058, 4059, 4060, 4061, 4069, 4075, 4078, 4086, 4095, 4106, 4115, 4116, 4117, 4123, 4124, 4139, 4143, 4147, 4150, 4158, 4166, 4186, 4188, 4193, 4194, 4217, 4222, 4255, 4256, 4260, 4261, 4293, 4294, 4302, 4330, 4331, 4345, 4385, 4386, 4437, 4452, 4453, 4459, 4461, 4479, 4546, 4550, 4573, 4574, 4580, 4587, 4590, 4593, 4601, 4606, 4608, 4613, 4652, 4653, 4690, 4712, 4719, 4720, 4739, 4750, 4755, 4765, 4857, 4868, 4884, 4885, 4902, 4903, 4912, 4922, 4943, 4958, 4959, 4960, 4972, 5024, }

-- list of map ID numbers using GetCurrentMapId()
-- 1552 Norg-Tzel
lib.zone_id_list = { 75, 74, 13, 61, 26, 7, 125, 30, 20, 227, 1, 10, 12, 201, 143, 9, 300, 258, 22, 256, 1429, 1747, 1313, 1348, 1354, 255, 1126, 1006, 994, 1484, 1552, 1555, 1654, 1349, 1060, 1719, 667, 16, 660, 108, }

lib.zone_names_list = {
    [75] = "balfoyen_base_0",
    [74] = "bleakrock_base_0",
    [13] = "deshaan_base_0",
    [61] = "eastmarch_base_0",
    [26] = "shadowfen_base_0",
    [7] = "stonefalls_base_0",
    [125] = "therift_base_0",
    [30] = "alikr_base_0",
    [20] = "bangkorai_base_0",
    [227] = "betnihk_base_0",
    [1] = "glenumbra_base_0",
    [10] = "rivenspire_base_0",
    [12] = "stormhaven_base_0",
    [201] = "strosmkai_base_0",
    [143] = "auridon_base_0",
    [9] = "grahtwood_base_0",
    [300] = "greenshade_base_0",
    [258] = "khenarthisroost_base_0",
    [22] = "malabaltor_base_0",
    [256] = "reapersmarch_base_0",
    [1429] = "artaeum_base_0",
    [1747] = "blackreach_base_0",
    [1313] = "clockwork_base_0",
    [1348] = "brassfortress_base_0",
    [1354] = "clockworkoutlawsrefuge_base_0",
    [255] = "coldharbour_base_0",
    [1126] = "craglorn_base_0",
    [1006] = "goldcoast_base_0",
    [994] = "hewsbane_base_0",
    [1484] = "murkmire_base_0",
    [1552] = "swampisland_ext_base_0",
    [1555] = "elsweyr_base_0",
    [1654] = "southernelsweyr_base_0",
    [1349] = "summerset_base_0",
    [1060] = "vvardenfell_base_0",
    [1719] = "westernskryim_base_0",
    [667] = "wrothgar_base_0",
    [16] = "ava_whole_0",
    [660] = "imperialcity_base_0",
    [108] = "eyevea_base_0",
}

--[[
This is a list of quests that when completed, other quests
are no longer available. The conditional_quest_id is
considered completed as well.

Format:

    quest_id, the main quest (integer)
    conditional_quest_id, the starter quest that leads you to
    the main quest (table of integers)

    quest_id = {
        conditional_quest_id,
    }
]]--
lib.conditional_quest_list = {
    [4453] = { -- A Favor Returned
        3956, -- Message To Mournhold
    },
    [3686] = { -- Three Tender Souls
        4163, -- Onward To Shadowfen
    },
    [3799] = { -- Scales of Retribution
        3732, -- Overrun
    },
    [3978] = { -- Tomb Beneath the Mountain
        4184, -- To Pinepeak Caverns
        5035, -- Calling Hakra
    },
    [3191] = { -- Reclaiming the Elements
        3183, -- To The Wyrd Tree
    },
    [3060] = { -- Seeking the Guardians
        3026, -- The Wyrd Sisters
    },
    [2222] = { -- Alasan's Plot
        4817, -- Tracking the Hand
    },
    --[[
    Double check this, The Scholar of Bergama leads to
    Gone Missing. Just because you completed it what
    if you abandon it?
    ]]--
    [2251] = { -- Gone Missing
        2193, -- The Scholar of Bergama
    },
    [4712] = { -- The First Step
        4799, -- To Saifa in Rawl'kha
        5092, -- The Champions at Rawl'kha
        4759, -- Hallowed to Rawl'kha
    },
    [3632] = { -- Breaking Fort Virak
        5040, -- Taking Precautions
    },
    [974] = { -- A Duke in Exile
        3283, -- Werewolves To The North
    },
    [521] = { -- Azura's Aid
        5052, -- An Offering To Azura
    },
    [1799] = {-- A City in Black
        3566, -- Kingdom in Mourning
        4991, -- Dark Wings
    },
    [4850] = { -- Shades Of Green
        4790, -- Breaking the Ward
    },
    [4689] = { -- A Door into Moonlight
        5091, -- Hallowed to Grimwatch
        5093, -- Moons Over Grimwatch
    },
    [4479] = { -- Motes in the Moonlight
        4802, -- To Moonmont
    },
    [4139] = { -- Shattered Hopes
        5036, -- Honrich Tower
    },
    [4364] = { -- A Thorn in Your Side
        4370, -- A Bargain With Shadows
        4369, -- The Will of the Worm
    },
    [4370] = { -- A Bargain With Shadows
        4369, -- The Will of the Worm
        4364, -- A Thorn in Your Side
    },
    [4369] = { -- The Will of the Worm
        4364, -- A Thorn in Your Side
        4370, -- A Bargain With Shadows
    },
    [4833] = { -- Bosmer Insight
        4974, -- Brackenleaf's Briars
    },
    [3695] = { -- Aggressive Negotiations
        3635, -- City at the Spire
    },
    [3678] = { -- Trials of the Burnished Scales
        3802, -- What Happened at Murkwater
    },
    [3840] = { -- Saving the Relics
        3982, -- Bound to the Bog
    },
    [3615] = { -- Wake the Dead
        3855, -- Mystery of Othrenis
    },
    [4899] = { -- Beyond the Call
        3281, -- Leading the Stand
    },
    [4652] = { -- The Colovian Occupation
        3981, -- To Taarengrav
        4710, -- Hallowed To Arenthia
    },
    [4147] = { -- The Shackled Guardian
        5034, -- A Grave Situation
    },
    [4293] = { -- Putting the Pieces Together
        4366, -- To Mathiisen
    },
    [4255] = { -- Ensuring Security
        4818, -- To Auridon
        5055, -- Missive to the Queen
        5058, -- All the Fus
    },
    [5058] = { -- All the Fus
        5055, -- Missive to the Queen
    },
    [5055] = { -- Missive to the Queen
        5058, -- All the Fus
    },
    [2552] = { -- Army at the Gates
        4443, -- To Alcaire Castle
    },
    [4546] = { -- Retaking the Pass
        5088, -- Naemon's Return
    },
    [5088] = { -- Naemon's Return
        4821, -- Report to Marbruk
    },
    [4574] = { -- Veil of Illusion
        4853, -- Woodhearth
    },
    [2130] = { -- Rise of the Dead
        4694, -- Word from the Throne
    },
    [4330] = { -- Lifting the Veil
        4549, -- Back to Skywatch
    },
    --[[
    [1803] = { -- The Water Stone
        1804, -- Sunken Knowledge
    },
    [1804] = { -- Sunken Knowledge
        1803, -- The Water Stone
    },
    ]]--
    [1536] = { -- Fire in the Fields
        5052, -- Offering To Azura
    },
    [5052] = { -- Offering To Azura
        1536, -- Fire in the Fields
    },
    [4028] = { -- Breaking The Tide
        4026, -- Zeren in Peril
    },
    [4026] = { -- Zeren in Peril
        4028, -- Breaking The Tide
    },
    [3595] = { -- Wayward Son
        3598, -- Giving for the Greater Good
    },
    [3598] = { -- Giving for the Greater Good
        3595, -- Wayward Son
    },
    [3653] = { -- Ratting Them Out
        3658, -- A Timely Matter
    },
    [3658] = { -- A Timely Matter
        3653, -- Ratting Them Out
    },
    [4679] = { -- The Shadow's Embrace
        4654, -- An Unusual Circumstance
    },
    [4654] = { -- An Unusual Circumstance
        4679, -- The Shadow's Embrace
    },
    [5072] = { -- Aid for Bramblebreach
        4735, -- The Staff of Magnus
    },
    [4735] = { -- The Staff of Magnus
        5072, -- Aid for Bramblebreach
    },
    --Cyrodiil
    --[4704] = "Welcome to Cyrodiil",
    --[4722] = "Welcome to Cyrodiil",
    --[4725] = "Welcome to Cyrodiil", dc
    --[4706] = "Reporting for Duty",
    --[4724] = "Reporting for Duty",
    --[4727] = "Reporting for Duty", dc
    --[4705] = "Siege Warfare",
    --[4723] = "Siege Warfare",
    --[4726] = "Siege Warfare", dc
    --[5487] = "City on the Brink",
	--[5493] = "City on the Brink", dc
	--[5496] = "City on the Brink",
    [4706] = { -- Reporting for Duty
        4704, -- Welcome to Cyrodiil
        4705, -- Siege Warfare
    },

}

--[[
/script LibQuestData_Internal.dm("Debug", LibQuestData.completed_quests[4726])
/script LibQuestData_Internal.dm("Debug", LibQuestData.player_alliance)
]]--
