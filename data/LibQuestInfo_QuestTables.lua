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
This is a list of special NPCs that run around
or hunt you down. Once XY location is set, do not
change it

68884 - Stuga: Quest ID 5450: "Invitation to Orsinium"

Note: Table is of Quest ID numbers since that
is part of the XY location information from
lib.quest_locations
--]]
lib.quest_giver_moves = { 5450, }
