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
3991 - Escape from Bleakrock, Captain Rana
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
6591 = Falkfyr's Notes, Page 1

4680 = "To My Friend From the Beach", "Storm on the Horizon"
6134 = "The New Life Festival", "New Life Festival Scroll"
6549 = "The Ravenwatch Inquiry", "House Ravenwatch Contract"
4382 = "Moment of Truth", "Dugroth"
4585 = "Relative Matters", "Hojard"
5664 = "The Sweetroll Killer", "A Call to the Worthy",
6449 = "Lumpy Sack", "Take Your Lumps"
6445 = "J'saad's Note", "J'saad's Stone"
6431 = "Sourcing the Ensorcelled", "Guybert Flaubert"
4955 = "A Lucky Break", "Nedras' Journal"
6226 = Cyrodilic Collections Needs You!, "Cyrodilic Collections Needs You!"
5950 = "The Ancestral Tombs", "Librarian Bradyn"
6275 = "Frog Totem Turnaround", "Romantic Argonian Poem"
6295 = "Death-Hunts", "Death-Hunts Await"
4145 = "Mine All Mine", Tervur Sadri
5599 = "Questions of Faith", "Kor"
5352 = "Into the Maw", "Adara'hai"
6549 = "The Ravenwatch Inquiry",
6612 = "A Mortal's Touch",
5013 = "Hushed Whispers", "Dominion Correspondence"
6370 = "Ache for Cake", "Jubilee Cake Voucher"
4379 = "Lover's Torment", "Shard of Alanwe"
3970 = "An Ill-Fated Venture", "Letter to Tavo"
4656 = "Tharayya's Trail", "Tharayya Journal Entry: 19"
6144 = "Pearls Before Traitors", "To Chief Justiciar Carawen"
6314 = "Scariest in Show", "Tahara's Traveling Menagerie",
6596 = "The Symbol of Hrokkibeg", "Letter to Apprentice Gwerina"
6631 = "Giving Up the Ghost", "Phantasmal Discovery Awaits!"
6337 = "A Battle of Silk and Flame", "Morgane's Guild Orders"
6731 = "Robhir's Final Delivery", "Robhir's Letter"
6706 = "Mettle and Stone", "Torn Journal Page",
6730 =  "Courier's Folly", "Telofasa's Diary",
6705 =  "Death Stalks the Weak", "Note for Khazasha",
6728 =  "A Gem of a Mystery", "Mikget's To-Do List",

ID   = Quest Name, Object for comments
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
    [6591] = 200050,
    [4680] = 72002,
    [6134] = 77001,
    [6532] = 90012,
    [6553] = 90013,
    [6348] = 100035,
    [6170] = 91012,
    [6549] = 80017,
    [5742] = 80018, -- special holliday quest for halloween check if it's in any location
    [4382] = 35873,
    [4585] = 39774,
    [5664] = 80023,
    [6442] = 80027,
    [6449] = 81018,
    [6445] = 81019,
    [6431] = 100034,
    [4955] = 500085,
    [6226] = 100134,
    [5950] = 80016,
    [6275] = 94002,
    [6295] = 94004,
    [4145] = 27743,
    [5599] = 100136,
    [5352] = 60285,
    [5941] = 100138,
    [6375] = 100160,
    [6549] = 79001,
    [6612] = 79001,
    [5013] = 100169,
    [6370] = 100173,
    [4379] = 33961,
    [3970] = 100186,
    [4656] = 100183,
    [6144] = 100182,
    [6314] = 100181,
    [6596] = 90004,
    [6631] = 95012,
    [6646] = 95033,
    [6337] = 95034,
    [6663] =  95039,
    [6647] =  95041,
    [6731] = 96001,
    [6709] = 96002,
    [6706] = 96004,
    [6730] = 96005,
    [6705] = 96006,
    [6728] = 100209,
}

--[[ This list contains Prologue quests that can be
accepted anywhere

[4831] = "The Harborage",
[5941] = "The Jester's Festival",
[6370] = "Ache for Cake",
[5935] = "The Missing Prophecy",
[6023] = "Of Knives and Long Shadows",
[6097] = "Through a Veil Darkly",
[6226] = "Ruthless Competition",
[6299] = "The Demon Weapon",
[6395] = "The Dragonguard's Legacy",
[6454] = "The Coven Conspiracy",
[6549] = "The Ravenwatch Inquiry",
[6612] = "A Mortal's Touch",
[6629] = "A Visit to Elsweyr",
[6701] = "An Apocalyptic Situation",
[6687] = "Bounties of Blackwood",
[6729] = "Guidance for Guides",
]]--
lib.prologue_quest_list = {
  4831, 5941, 6370, 5935, 6023, 6097, 6226, 6299, 6395, 6454, 6549, 6612, 6629, 6701, 6687, 6729,
  --[[Jan 2022: Added for Companion Quests that can be accepted anywhere
  ]]--
  6662, 6664, 6666, 6667,
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
28505 - Bera Moorsmith : Quest ID 3885: "The Prismatic Core"
28505 - Bera Moorsmith : Quest ID 3856: "Anchors from the Harbour"
5897 - Serge Arcole : Quest ID 2451: "A Ransom for Miranda"
xx - xx : Quest ID 5102: "The Mage's Tower"
5057 - First Mate Elvira Derre : Quest ID 1637: "Divert and Deliver",
6624 - Tyree Marence : Quest ID 728: "Repair Koeglin Lighthouse"
xxxx - Josajeh: Quest ID 6181: "Breaches On the Bay"
xxxx - Gathwen: Quest ID 4625: "Tears of the Two Moons"
xxxx - "Initiate Delighre" ? : Quest ID 4552: "Chasing Shadows"

Note: Table is of Quest ID numbers since that
is part of the XY location information from
lib.quest_locations
--]]
-- 4841 need more data first for Rajesh
-- 5742 needs verified as it is for halloween quest


--[[
Another use is that this will prevent a daily or quest from
a location that is off the map. Southern Elsweyr for example
and the quests in the Dragonguard place
]]--
lib.quest_giver_moves = {
-- regular quests
  5450, 4220, 5058, 4264, 3992, 5923, 5950, 2251, 5742, 5102, 3856, 3858, 3885, 2451, 728, 6181, 4625, 4552,

--[[
[6428] = "Sticks and Bones",
[6429] = "Digging Up the Garden",
[6430] = "File Under D",
[6433] = "Rude Awakening",
[6434] = "The Dragonguard's Quarry",
[6435] = "The Dragonguard's Quarry",
[6405] = "Taking Them to Tusk",
[6406] = "A Lonely Grave",
[3924] = "Song of Awakening",

]]--
-- Dragonguard quests
  6428, 6429, 6430, 6433, 6434, 6435, 6405, 6406, 3924
}

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
5534 = Cleaning House
]]--

lib.quest_has_skill_point = { 465, 467, 575, 1633, 2192, 2222, 2997, 3006, 3235, 3267, 3379, 3634, 3735, 3797, 3817, 3831, 3867, 3868, 3968, 3993, 4054, 4061, 4107, 4115, 4117, 4139, 4143, 4188, 4222, 4261, 4319, 4337, 4345, 4346, 4386, 4432, 4452, 4474, 4479, 4542, 4552, 4590, 4602, 4606, 4607, 4613, 4690, 4712, 4720, 4730, 4733, 4750, 4758, 4764, 4765, 4778, 4832, 4836, 4837, 4847, 4868, 4884, 4885, 4891, 4912, 4960, 4972, 5090, 5433, 6455, 6476, 6050, 6481, 6466, 6057, 6409, 5891,
-- new
6560, 6547, 6548, 6550, 6551, 6552, 6570, 6554, 6566, 4296, 5540, 6399, 6349, 6394, 6351, 5534,
--also new
5889, 3910, 5447, 4555, 4813, 6414, 4303, 6416, 4822, 5595, 5532, 5597, 5598, 5599, 5600, 4641, 5481, 4202, 6507, 6188, 5549, 5545, 6576, 4145, 6578, 5468, 5556, 4469, 5403, 6505, 4336, 5113, 5342, 6186, 6249, 5596, 5702, 5567, 4246, 4589, 4675, 4831, 6304, 6113, 6315, 6126, 6336, 6048, 5922, 4867, 6052, 6025, 6063, 5136, 6003, 6132, 4597, 4379, 4538, 5531, 5948, 5120, 6046, 6047, 6432, 6064, 6065,
--blackwood
6616, 6660, 6619, 6404, 6402, 6403,
--Deadlands
6646,
}

lib.quest_cadwell = quest_ids { 465, 467, 737, 736, 1341, 1346, 1437, 1529, 1536, 1541, 1591, 1799, 1834, 2130, 2146, 2184, 2192, 2222, 2495, 2496, 2497, 2552, 2564, 2566, 2567, 2997, 3064, 3082, 3174, 3189, 3191, 3235, 3267, 3277, 3280, 3338, 3379, 3584, 3585, 3587, 3588, 3615, 3616, 3632, 3633, 3634, 3637, 3673, 3686, 3687, 3695, 3696, 3705, 3734, 3735, 3749, 3791, 3797, 3810, 3817, 3818, 3826, 3831, 3837, 3838, 3868, 3909, 3928, 3957, 3968, 3978, 4058, 4059, 4060, 4061, 4069, 4075, 4078, 4086, 4095, 4106, 4115, 4116, 4117, 4123, 4124, 4139, 4143, 4147, 4150, 4158, 4166, 4186, 4188, 4193, 4194, 4217, 4222, 4255, 4256, 4260, 4261, 4293, 4294, 4302, 4330, 4331, 4345, 4385, 4386, 4437, 4452, 4453, 4459, 4461, 4479, 4546, 4550, 4573, 4574, 4580, 4587, 4590, 4593, 4601, 4606, 4608, 4613, 4652, 4653, 4690, 4712, 4719, 4720, 4739, 4750, 4755, 4765, 4857, 4868, 4884, 4885, 4902, 4903, 4912, 4922, 4943, 4958, 4959, 4960, 4972, 5024, }

-- list of map ID numbers using GetCurrentMapId()
-- 1552 Norg-Tzel
lib.zone_id_list = { 75, 74, 13, 61, 26, 7, 125, 30, 20, 227, 1, 10, 12, 201, 143, 9, 300, 258, 22, 256, 1429, 1747, 1313, 1348, 1354, 255, 1126, 1006, 994, 1484, 1552, 1555, 1654, 1349, 1060, 1719, 667, 16, 660, 108, 1207, 1208, 1261, 1282, 1283, 1286, }

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
    [1207] = "reach_base_0",
    [1208] = "u28_blackreach_base_0",
    [1261] = "blackwood_base_0",
    [1282] = "u32_fargrave_base_0",
    [1283] = "u32_theshambles_base_0",
    [1286] = "u32deadlandszone_base_0",
}

--[[
This is a list of quests that can not be completed, until
you have completed and achievement. Unlike conditional_quest_list
this is not a table.


Example, hide "A Cold Wind From the Mountain" while missing the achievement "Hero of Wrothgar".

Format:

    quest_id, the main quest (integer)
    achievement_quest_id, the achievement ID

    quest_id = achievement_quest_id
]]--
lib.achievement_quest_list = {
  [5479] = 1248, -- "A Cold Wind From the Mountain", "Hero of Wrothgar"
  [6320] = 2463, -- "The Singing Crystal", Mural
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
    [1834] = { -- Heart of Evil
        4992, -- Searching for the Searchers
        3530, -- Destroying the Dark Witnesses
    },
    [3817] = { -- The Seal of Three
        5103, -- Mournhold Market Misery
    },
    [2495] = { -- The Signet Ring
        5050, -- Waiting for Word
    },
    [1536] = { -- Fire in the Fields"
        1735, -- Unanswered Questions
    },
    [5071] = { --Curinure's Invitation
        5074,
        5076,
    },
    [5074] = { --Rudrasa's Invitation
        5071,
        5076,
    },
    [5076] = { --Nemarc's Invitation
        5071,
        5074,
    },
    [5073] = { --Aicessar's Invitation
        5077,
        5075,
    },
    [5077] = { --Basile's Invitation
        5073,
        5075,
    },
    [5075] = { --Hilan's Invitation
        5073,
        5077,
    },

}

--[[
/script LibQuestData_Internal.dm("Debug", LibQuestData.completed_quests[4726])
/script LibQuestData_Internal.dm("Debug", LibQuestData.player_alliance)
]]--


--[[
This is a list of quests that you get when using an object such
as Folded Note for Real Marines; ID 4210. It can also be for
quest starters from the crown store

[4210] = "Real Marines", "Folded Note"
[5312] = "Taking the Undaunted Pledge"
]]--
lib.object_quest_starter_list = {
  4210, 5312
}

--[[
These tables are quests for guilds that are not available
until you reach a certain rank

Format: [QuestID] = rank
]]--
lib.guild_rank_quest_list = {
  [lib.quest_series_type.quest_type_guild_fighter] = {
    [3856] = 0,
    [3858] = 1,
    [3885] = 2,
    [3898] = 3,
    [3973] = 4,
  },
  [lib.quest_series_type.quest_type_guild_mage] = {
    [3916] = 0,
    [4435] = 1,
    [3918] = 2,
    [3953] = 3,
    [3997] = 4,
    [4971] = 4,
  },
  [lib.quest_series_type.quest_type_guild_thief] = {
    [5549] = 6,
    [5545] = 7,
    [5581] = 8,
    [5553] = 9,
  },
  [lib.quest_series_type.quest_type_guild_dark] = {
    [5595] = 1,
    [5599] = 2,
    [5596] = 3,
    [5567] = 4,
    [5597] = 5,
    [5598] = 6,
    [5600] = 7,
  },
}

lib.known_removed_quest = {
    [3442] = true, -- Dawn of the Dragonguard
}
