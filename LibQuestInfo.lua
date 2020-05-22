--[[

LibQuestInfo
by Sharlikran
https://sharlikran.github.io/

--]]

-- Init
local lib = _G["LibQuestInfo"]

lib.displayName = libName
lib.idName = libName

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
function internal:is_empty_or_nil(t)
    if type(t) == "table" then
        if next(t) == nil then
            return true
        else
            return false
        end
    elseif type(t) == "string" then
        if t == nil then
            return true
        elseif t == "" then
            return true
        else
            return false
        end
    elseif type(t) == "nil" then
        return true
    end
end

function internal:is_nil(t)
    if t == nil then
        return true
    else
        return false
    end
end

function internal:is_in(search_value, search_table)
    for k, v in pairs(search_table) do
        if search_value == v then return true end
        if type(search_value) == "string" then
            if string.find(string.lower(v), string.lower(search_value)) then return true end
        end
    end
    return false
end

-------------------------------------------------
----- General Quest Info                     ----
-------------------------------------------------

function lib:get_quest_list(zone)
    if type(zone) == "string" and lib.quest_locations[zone] ~= nil then
        return lib.quest_locations[zone]
    else
        return {}
    end
end

-------------------------------------------------
----- Lookup By ID: returns name             ----
-------------------------------------------------

function lib:get_quest_giver(id, lang)
    lang = lang or lib.client_lang
    return lib.quest_givers[lib.client_lang][id]
end

function lib:get_quest_name(id, lang)
    lang = lang or lib.client_lang
    return lib.quest_names[lib.client_lang][id] or "Unknown Name"
end

function lib:get_objective_name(id, lang)
    lang = lang or lib.client_lang
    return lib.objective_names[lib.client_lang][id]
end

-------------------------------------------------
----- Lookup By Name: returns table of IDs   ----
-------------------------------------------------
--[[

Get a table of quest IDs when given a quest name

Use: Drawing a pin with a different color if the player has started the
quest and has not finished it yet. Loop over the table

example:
for _, id in ipairs(ids) do
    started_quests[id] = true
end
--]]

function lib:get_questids_table(name, lang)
    local lang = lang or lib.client_lang
    if type(name) == "string" then
        return lib.name_to_questid_table[lang][name]
    end
end

function lib:get_npcids_table(name, lang)
    local lang = lang or lib.client_lang
    if type(name) == "string" then
        return lib.name_to_npcid_table[lang][name]
    end
end

function lib:get_objids_table(name, lang)
    local lang = lang or lib.client_lang
    if type(name) == "string" then
        return lib.name_to_objectiveid_table[lang][name]
    end
end
-------------------------------------------------
----- Generate QuestID Table By Language     ----
-------------------------------------------------

--[[
Build ID table is indexed by the quest name, only default language
is built by default. Author must build other languages as needed.
--]]

local function contains_id(quent_ids, id_to_find)
    local found_id = false
    for questname, quest_ids in pairs(quent_ids) do
        -- print(questname)
        for _, quest_id in pairs(quest_ids) do
            -- print(quest_id)
            if quest_id == id_to_find then
                found_id = true
            end
        end
    end
    return found_id
end

function lib:build_questid_table(lang)
    local lang = lang or lib.client_lang
    local built_table = {}

    for var1, var2 in pairs(lib.quest_names[lang]) do
        -- print(var2)
        -- print(var2)
        if built_table[var2] == nil then built_table[var2] = {} end
        if contains_id(built_table, var1) then
            -- print("Var 1 is in ids")
        else
            -- print("Var 1 is not in ids")
            table.insert(built_table[var2], var1)
        end
    end

    lib.name_to_questid_table[lang] = built_table

end

function lib:build_objectiveid_table(lang)
    local lang = lang or lib.client_lang
    local built_table = {}

    for var1, var2 in pairs(lib.objective_names[lang]) do
        -- print(var2)
        -- print(var2)
        if built_table[var2] == nil then built_table[var2] = {} end
        if contains_id(built_table, var1) then
            -- print("Var 1 is in ids")
        else
            -- print("Var 1 is not in ids")
            table.insert(built_table[var2], var1)
        end
    end

    lib.name_to_objectiveid_table[lang] = built_table

end

function lib:build_npcid_table(lang)
    local lang = lang or lib.client_lang
    local built_table = {}

    for var1, var2 in pairs(lib.quest_givers[lang]) do
        -- print(var2)
        -- print(var2)
        if built_table[var2] == nil then built_table[var2] = {} end
        if contains_id(built_table, var1) then
            -- print("Var 1 is in ids")
        else
            -- print("Var 1 is not in ids")
            table.insert(built_table[var2], var1)
        end
    end

    lib.name_to_npcid_table[lang] = built_table

end

-- Event handler function for EVENT_PLAYER_ACTIVATED
local function OnPlayerActivated(eventCode)
    if LibQuestInfo_SavedVariables.version ~= 3 then
        -- d("ding not 2")
        LibQuestInfo_SavedVariables = {}
        LibQuestInfo_SavedVariables.version = 3
        LibQuestInfo_SavedVariables.quests = {}
        LibQuestInfo_SavedVariables.subZones = {}

        LibQuestInfo_SavedVariables.quest_info = {}
        LibQuestInfo_SavedVariables.location_info = {}
        LibQuestInfo_SavedVariables.quest_names = {}
        LibQuestInfo_SavedVariables.objective_info = {}
        LibQuestInfo_SavedVariables.reward_info = {}
        LibQuestInfo_SavedVariables.map_info = {}
        LibQuestInfo_SavedVariables.giver_names = {}
    end
    lib:build_questid_table(lib.client_lang) -- build name lookup table once
    lib:build_npcid_table(lib.client_lang) -- build npc names lookup table once
    lib:build_objectiveid_table(lib.client_lang) -- build objective names lookup table once
    -- d("I am here")

    EVENT_MANAGER:UnregisterForEvent(lib.idName, EVENT_PLAYER_ACTIVATED)
end
EVENT_MANAGER:RegisterForEvent(lib.idName, EVENT_PLAYER_ACTIVATED, OnPlayerActivated)
