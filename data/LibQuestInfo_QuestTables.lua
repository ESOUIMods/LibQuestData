local lib = _G["LibQuestInfo"]
--[[
This is a special table for preventing something
from being recorded or changed
]]--

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
6467 - The Gathering Storm, 
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

