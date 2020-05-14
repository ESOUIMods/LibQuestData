--[[

LibQuestInfo
by Sharlikran
https://sharlikran.github.io/

--]]

-- Init
local lib = _G["LibQuestInfo"]

lib.displayName = libName
lib.idName = libName
if LibQuestInfo_SavedVariables == nil then LibQuestInfo_SavedVariables = {} end

-- Libraries
local LMP = LibMapPins
local GPS = LibGPS2

-- Default table
local quest_data_index_default = {
    [lib.quest_data_index.QUEST_NAME]   = "",
    [lib.quest_data_index.QUEST_GIVER]  = "",
    [lib.quest_data_index.QUEST_TYPE]   = -1, -- Undefined
    [lib.quest_data_index.QUEST_REPEAT]  = -1, -- Undefined
    [lib.quest_data_index.GAME_API]     = 100003, -- 100003 means unverified
    [lib.quest_data_index.QUEST_LINE]    = 10000, -- QuestLine (10000 = not assigned/not verified. 10001 = not part of a quest line/verified)
    [lib.quest_data_index.QUEST_NUMBER]  = 10000, -- Quest Number In QuestLine (10000 = not assigned/not verified)
    [lib.quest_data_index.QUEST_SERIES]  = 0, -- None = 0, Cadwell's Almanac = 1, Undaunted = 2, AD = 3, DC = 4, EP = 5
}

local quest_map_pin_index_default = {
    [lib.quest_map_pin_index.X_LOCATION] = -10, -- GetMapPlayerPosition() << -10 = Undefined >>
    [lib.quest_map_pin_index.Y_LOCATION] = -10, -- GetMapPlayerPosition() << -10 = Undefined >>
    [lib.quest_map_pin_index.X_LIBGPS]   = -10, -- LocalToGlobal(GetMapPlayerPosition()) << -10 = Undefined >>
    [lib.quest_map_pin_index.Y_LIBGPS]   = -10, -- LocalToGlobal(GetMapPlayerPosition()) << -10 = Undefined >>
    [lib.quest_map_pin_index.QUEST_ID]   = -1, -- -1 Unknown, Quest ID i.e. 6404 for "The Dragonguard"
}

-- Function to check for empty table
local function is_empty(t)
    if next(t) == nil then
        return true
    else
        return false
    end
end

local function is_in(search_value, search_table)
    for k, v in pairs(search_table) do
        if search_value == v then return true end
        if type(search_value) == "string" then
            if string.find(string.lower(v), string.lower(search_value)) then return true end
        end
    end
    return false
end

lib.quest_data_index = {
    QUEST_NAME  =    1, -- Number index of quest name i.e. 6404 for "The Dragonguard"
    QUEST_GIVER =    2, -- Arbitrary number pointing to an NPC Name 81004, "Abnur Tharn"
    QUEST_TYPE  =    3, -- MAIN_STORY, DUNGEON
    QUEST_REPEAT =    4, -- QUEST_REPEAT_DAILY, QUEST_REPEAT_NOT_REPEATABLE = 0, QUEST_REPEAT_REPEATABLE 
    GAME_API    =    5, -- 100003 means unverified, 100030 means quest data collected from API 100030
    QUEST_LINE   =    6,    -- QuestLine (10000 = not assigned/not verified. 10001 = not part of a quest line/verified)
    QUEST_NUMBER =    7,    -- Quest Number In QuestLine (10000 = not assigned/not verified)
    QUEST_SERIES =    8,    -- None = 0,    Cadwell's Almanac = 1,    Undaunted = 2, AD = 3, DC = 4, EP = 5.
}

lib.quest_map_pin_index = {
    X_LOCATION  =    1, -- GetMapPlayerPosition() << -10 = Undefined >>
    Y_LOCATION  =    2, -- GetMapPlayerPosition() << -10 = Undefined >>
    X_LIBGPS    =    3, -- LocalToGlobal(GetMapPlayerPosition()) << -10 = Undefined >>
    Y_LIBGPS    =    4, -- LocalToGlobal(GetMapPlayerPosition()) << -10 = Undefined >>
    QUEST_ID    =    5, -- Number index of quest name i.e. 6404 for "The Dragonguard"
}

lib.quest_data_type = {
    -- ESO Values
    QUEST_TYPE_NONE = 0,
    QUEST_TYPE_GROUP = 1,
    QUEST_TYPE_MAIN_STORY = 2,
    QUEST_TYPE_GUILD = 3,
    QUEST_TYPE_CRAFTING = 4,
    QUEST_TYPE_DUNGEON = 5,
    QUEST_TYPE_RAID = 6,
    QUEST_TYPE_AVA = 7, -- None in table, in check
    QUEST_TYPE_CLASS = 8, -- None in table
    QUEST_TYPE_AVA_GROUP = 10, -- None in table, in check
    QUEST_TYPE_AVA_GRAND = 11, -- None in table, in check
    QUEST_TYPE_HOLIDAY_EVENT = 12, -- None in table
    QUEST_TYPE_BATTLEGROUND = 13, -- None in table
    
    -- LibQuestInfo Values
    QUEST_TYPE_DAILY            = 14,
    QUEST_TYPE_CADWELL          = 15,
    QUEST_TYPE_AD               = 16,
    QUEST_TYPE_DC               = 17,
    QUEST_TYPE_EP               = 18,
    QUEST_TYPE_UNDEFINED        = 19,
    QUEST_TYPE_GUILD_MAGE       = 20,
    QUEST_TYPE_GUILD_FIGHTER    = 21,
    QUEST_TYPE_GUILD_PSIJIC     = 22,
    QUEST_TYPE_GUILD_THIEF      = 23,
    QUEST_TYPE_GUILD_DARK       = 24, -- Dark Brotherhood
    QUEST_TYPE_UNDAUNTED        = 25,
}

lib.quest_data_repeat = {
    QUEST_REPEAT_DAILY = 2,
    QUEST_REPEAT_NOT_REPEATABLE = 0,
    QUEST_REPEAT_REPEATABLE = 1,
}

lib.dest_quest_data_index = {
	QUEST_X =		1,
	QUEST_Y =		2,
	QUESTNPC =		3,
	QUESTTYPE = 	4,
	QUESTREPEAT =	5,
	QUESTID =		6,
	QUESTLINE =		7,	-- QuestLine (10000 = not assigned/not verified. 10001 = not part of a quest line/verified)
	QUESTNUMBER =	8,	-- Quest Number In QuestLine (10000 = not assigned/not verified)
	QUESTSERIES =	9,	-- None = 0,	Cadwell's Almanac = 1,	Undaunted = 2, AD = 3, DC = 4, EP = 5.
}

lib.dest_quest_series_index = {
    QUEST_SERIES_NONE       = 0,
    QUEST_SERIES_CADWELL    = 1,
    QUEST_SERIES_UNDAUNTED  = 2,
    QUEST_SERIES_AD         = 3,
    QUEST_SERIES_DC         = 4,
    QUEST_SERIES_EP         = 5,
}

-------------------------------------------------
----- Destinations Specific                  ----
-------------------------------------------------

function lib:get_quest_giver(id, lang)
    lang = lang or lib.client_lang
    return lib.quest_givers[lib.client_lang][id]
end

-------------------------------------------------
----- General Quest Info                     ----
-------------------------------------------------

function lib:get_quest_name(id, lang)
    lang = lang or lib.client_lang
    return lib.quest_names[lib.client_lang][id]
end

-- Event handler function for EVENT_PLAYER_ACTIVATED
local function OnPlayerActivated(eventCode)
    
    EVENT_MANAGER:UnregisterForEvent(lib.idName, EVENT_PLAYER_ACTIVATED)
end
EVENT_MANAGER:RegisterForEvent(lib.idName, EVENT_PLAYER_ACTIVATED, OnPlayerActivated)
