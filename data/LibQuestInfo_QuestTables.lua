local lib = _G["LibQuestInfo"]
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
signs so we don't want to change the giver name

5949 - For Glory Sign
6420 - A Job Offer Sign
6066 - The Precursor
--]]
lib.quest_giver_is_object = { 5949, 6420, 6066, }

--[[ List of what the numbers mean
This is a list of special objects like notes and
signs. The key is the quest ID and the value is the
quest giver.

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

6533 = Kelbarn's Mining Samples
6534 - Inguya's Mining Samples
6535 = Reeh-La's Mining Samples
6536 = Ghamborz's Mining Samples
6538 = Adanzda's Mining Samples
--]]
lib.questid_giver_lookup = {
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
    [6066] = 100040
}

--[[ List of what the numbers mean
This is a list of special NPCs that run around
or hunt you down. Once XY location is set, do not
change it

68884 - Stuga: Quest ID 5450: "Invitation to Orsinium"

Note: Table is of Quest ID numbers since that
is part of the XY location information from
lib.quest_locations
--]]
lib.quest_giver_moves = { 5450, }

--[[ List of what the numbers mean
This may not be needed since I can check the distance
of the X,Y coordinates.

This is a list of special Quests that have two locations
or two ways to get the quest. Allow for duplicates in
the zone

4209 "Teldur's End"
4210 "Real Marines"
--]]
lib.dupe_quest_starters = { 4209, 4210, }

--[[
This is a list of qusts that give skill points

6455 - Bound in Blood
6476 - Dark Clouds Over Solitude
6050 - To The Clockwork City
]]--

lib.quest_skill_point = quest_ids { 465, 467, 575, 1633, 2192, 2222, 2997, 3006, 3235, 3267, 3379, 3634, 3735, 3797, 3817, 3831, 3867, 3868, 3968, 3993, 4054, 4061, 4107, 4115, 4117, 4139, 4143, 4188, 4222, 4261, 4319, 4337, 4345, 4346, 4386, 4432, 4452, 4474, 4479, 4542, 4552, 4590, 4602, 4606, 4607, 4613, 4690, 4712, 4720, 4730, 4733, 4750, 4758, 4764, 4765, 4778, 4832, 4836, 4837, 4847, 4868, 4884, 4885, 4891, 4912, 4960, 4972, 5090, 5433, 6455, 6476, 6050, }

lib.quest_cadwell = quest_ids { 465, 467, 737, 736, 1341, 1346, 1437, 1529, 1536, 1541, 1591, 1799, 1834, 2130, 2146, 2184, 2192, 2222, 2495, 2496, 2497, 2552, 2564, 2566, 2567, 2997, 3064, 3082, 3174, 3189, 3191, 3235, 3267, 3277, 3280, 3338, 3379, 3584, 3585, 3587, 3588, 3615, 3616, 3632, 3633, 3634, 3637, 3673, 3686, 3687, 3695, 3696, 3705, 3734, 3735, 3749, 3791, 3797, 3810, 3817, 3818, 3826, 3831, 3837, 3838, 3868, 3909, 3928, 3957, 3968, 3978, 4058, 4059, 4060, 4061, 4069, 4075, 4078, 4086, 4095, 4106, 4115, 4116, 4117, 4123, 4124, 4139, 4143, 4147, 4150, 4158, 4166, 4186, 4188, 4193, 4194, 4217, 4222, 4255, 4256, 4260, 4261, 4293, 4294, 4302, 4330, 4331, 4345, 4385, 4386, 4437, 4452, 4453, 4459, 4461, 4479, 4546, 4550, 4573, 4574, 4580, 4587, 4590, 4593, 4601, 4606, 4608, 4613, 4652, 4653, 4690, 4712, 4719, 4720, 4739, 4750, 4755, 4765, 4857, 4868, 4884, 4885, 4902, 4903, 4912, 4922, 4943, 4958, 4959, 4960, 4972, 5024, }
