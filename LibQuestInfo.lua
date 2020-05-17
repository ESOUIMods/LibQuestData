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
