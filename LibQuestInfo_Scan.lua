local lib = _G["LibQuestInfo"]

-- Local variables
local questGiverName = nil
local reward
local lastZone
-- Init saved variables table
local GPS = LibGPS2
local LMP = LibMapPins
local quest_shared
local quest_found

-- Check if zone is base zone
local function IsBaseZone(zoneAndSubzone)
    return (zoneAndSubzone:match("(.*)/") == zoneAndSubzone:match("/(.*)[%._]base"))
end

-- Check if both subzones are in the same zone
local function IsSameZone(zoneAndSubzone1, zoneAndSubzone2)
    return (zoneAndSubzone1:match("(.*)/") == zoneAndSubzone2:match("(.*)/"))
end

local function get_quest_list_sv(zone)
    -- d(zone)
    if type(zone) == "string" and LibQuestInfo_SavedVariables.quests[zone] ~= nil then
        return LibQuestInfo_SavedVariables.quests[zone]
    else
        return {}
    end
end

-- Event handler function for EVENT_QUEST_ADDED
local function OnQuestAdded(eventCode, journalIndex, questName, objectiveName)
    if string.find(string.lower(questName), "writ") then return end
    -- d("OnQuestAdded")
    if quest_shared then
        quest_shared = false
        return
    end
    -- -1 for these means it is undefined since 0 is a valid value
    local quest_type = -1
    local repeat_type = -1
    local quest_id = -1
    -- -1 means it has not been completed. Once complete set it to the time stamp
    -- I am considering using this to see if I can calculate order for Zone quests

    -- Add quest to saved variables table in correct zone element

    local zone = LMP:GetZoneAndSubzone(true, false, true)
    if LibQuestInfo_SavedVariables.quests[zone] == nil then LibQuestInfo_SavedVariables.quests[zone] = {} end
    local normalizedX, normalizedY = GetMapPlayerPosition("player")
    local gpsx, gpsy, zoneMapIndex = GPS:LocalToGlobal(normalizedX, normalizedY)
    local measurement = GPS:GetCurrentMapMeasurements()
    if journalIndex then
        quest_type = GetJournalQuestType(journalIndex)
        repeat_type = GetJournalQuestRepeatType(journalIndex)
    end
    local quest = {
        ["quest_type"]  = quest_type,
        ["repeat_type"] = repeat_type,
        ["name"]        = questName,
        ["x"]           = normalizedX,
        ["y"]           = normalizedY,
        ["gpsx"]        = gpsx,
        ["gpsy"]        = gpsy,
        ["giver"]       = questGiverName,
        ["questID"]     = quest_id, -- assign this and get the ID when the quest is removed
        ["otherInfo"] = {
            ["api"]             = GetAPIVersion(),
            ["lang"]            = GetCVar("language.2"),
            ["measurement"]     = measurement,
        },
    }

    quest_found = false
    local QuestMap_zonelist = lib:get_quest_list(zone)
    for num_entry, quest_from_table in pairs(QuestMap_zonelist) do
        local quest_map_questname = lib:get_quest_name(quest_from_table[lib.quest_map_pin_index.QUEST_ID])
        if quest_map_questname == questName then
            quest_found = true
        end
    end
    local QuestScout_zonelist = get_quest_list_sv(zone)
    for num_entry, quest_from_table in pairs(QuestScout_zonelist) do
        if quest_from_table.name == questName then
            quest_found = true
        end
    end
    if quest_found then
        -- d("quest found")
    else
        -- d("quest not found")
        table.insert(LibQuestInfo_SavedVariables.quests[zone], quest)
    end
end
EVENT_MANAGER:RegisterForEvent(lib.idName, EVENT_QUEST_ADDED, OnQuestAdded) -- Verified

-- Event handler function for EVENT_CHATTER_END
local function OnChatterEnd(eventCode)
    -- d("OnChatterEnd")
    questGiverName = nil
    reward = nil
    -- Stop listening for the quest added event because it would only be for shared quests
    -- Shar I added if EVENT_QUEST_SHARED to OnQuestAdded UnregisterForEvent EVENT_QUEST_ADDED
    -- EVENT_MANAGER:UnregisterForEvent(lib.idName, EVENT_QUEST_ADDED)
    EVENT_MANAGER:UnregisterForEvent(lib.idName, EVENT_CHATTER_END) -- Verified
end

local function OnQuestSharred(eventCode, questID)
    -- d("OnQuestSharred")
    quest_shared = true
end
EVENT_MANAGER:RegisterForEvent(lib.idName, EVENT_QUEST_SHARED, OnQuestSharred) -- Verified

-- Event handler function for EVENT_QUEST_OFFERED
-- Note runs when you click writ board
local function OnQuestOffered(eventCode)
    -- d("OnQuestOffered")
    -- Get the name of the NPC or intractable object
    -- (This could also be done in OnQuestAdded directly, but it's saver here because we are sure the dialogue is open)
    questGiverName = GetUnitName("interact")
    -- Now that the quest has ben offered we can start listening for the quest added event
    -- Shar I added if EVENT_QUEST_SHARED to OnQuestAdded UnregisterForEvent EVENT_QUEST_ADDED
    -- EVENT_MANAGER:RegisterForEvent(lib.idName, EVENT_QUEST_ADDED, OnQuestAdded)
    EVENT_MANAGER:RegisterForEvent(lib.idName, EVENT_CHATTER_END, OnChatterEnd) -- Verified
end
EVENT_MANAGER:RegisterForEvent(lib.idName, EVENT_QUEST_OFFERED, OnQuestOffered) -- Verified

-- Event handler function for EVENT_QUEST_COMPLETE_DIALOG
local function OnQuestCompleteDialog(eventCode, journalIndex)
    -- d("OnQuestCompleteDialog")
    local numRewards = GetJournalQuestNumRewards(journalIndex)
    if numRewards <= 0 then return end
    reward = {}
    for i=1, numRewards do
        local rewardType = GetJournalQuestRewardInfo(journalIndex, i)
        table.insert(reward, rewardType)
    end
end
EVENT_MANAGER:RegisterForEvent(lib.idName, EVENT_QUEST_COMPLETE_DIALOG, OnQuestCompleteDialog) -- Verified

-- Event handler function for EVENT_QUEST_REMOVED
local function OnQuestRemoved(eventCode, isCompleted, journalIndex, questName, zoneIndex, poiIndex, questID)
    if string.find(string.lower(questName), "writ") then return end
    -- d(questName)
    -- d("OnQuestRemoved")
    local quest_to_update = nil

    for zone, zone_quests in pairs(LibQuestInfo_SavedVariables.quests) do
        for num_entry, quest_from_table in pairs(zone_quests) do
            if quest_from_table.name == questName then
                quest_to_update = quest_from_table
                break
            end
        end
    end

    if quest_to_update == nil then
        return
    end

    if questID >= 1 then
        if quest_to_update.questID == -1 then
            quest_to_update.questID = questID
        end
    end

    if not isCompleted  then
        return
    end

    -- clean up old vars, remove them
    if quest_to_update["preQuest"] then quest_to_update["preQuest"] = nil end
    if quest_to_update["otherInfo"]["time"] then quest_to_update["otherInfo"]["time"] = nil end
    if quest_to_update["otherInfo"].time_completed then quest_to_update["otherInfo"].time_completed = nil end

    -- clean up, add new vars if not present
    if quest_to_update["quest_type"] == nil then quest_to_update["quest_type"] = -1 end
    if quest_to_update["repeat_type"] == nil then quest_to_update["repeat_type"] = -1 end
    if quest_to_update["questID"] == nil then quest_to_update["questID"] = -1 end

    if isCompleted then
        if not LibQuestInfo_SavedVariables.questInfo then LibQuestInfo_SavedVariables.questInfo = {} end
        if not LibQuestInfo_SavedVariables.questInfo[questID] then LibQuestInfo_SavedVariables.questInfo[questID] = {} end
        LibQuestInfo_SavedVariables.questInfo[questID].repeatType = GetJournalQuestRepeatType(journalIndex)
        LibQuestInfo_SavedVariables.questInfo[questID].rewardTypes = reward
        reward = nil
    end
end
EVENT_MANAGER:RegisterForEvent(lib.idName, EVENT_QUEST_REMOVED, OnQuestRemoved) -- Verified

-- Event handler function for EVENT_PLAYER_DEACTIVATED
local function OnPlayerDeactivated(eventCode)
    lastZone = LMP:GetZoneAndSubzone(true, false, true)
end
EVENT_MANAGER:RegisterForEvent(lib.idName, EVENT_PLAYER_DEACTIVATED, OnPlayerDeactivated) -- Verified

local function show_quests()
    for zone, zone_quests in pairs(LibQuestInfo_SavedVariables.quests) do
        d("zone: "..zone)
        for num_entry, quest_from_table in pairs(zone_quests) do
            quest_to_update = quest_from_table
            d("Quest Name: "..quest_to_update.name)
        end
    end
end

-- Event handler function for EVENT_PLAYER_ACTIVATED
local function OnPlayerActivated(eventCode)
    local zone = LMP:GetZoneAndSubzone(true, false, true)
    -- Check if leaving subzone (entering base zone)
    if lastZone and zone ~= lastZone and IsBaseZone(zone) and IsSameZone(zone, lastZone) then
        if LibQuestInfo_SavedVariables.subZones[zone] == nil then LibQuestInfo_SavedVariables.subZones[zone] = {} end
        if LibQuestInfo_SavedVariables.subZones[zone][lastZone] == nil then
            -- Save entrance position
            local x, y = GetMapPlayerPosition("player")
            local gpsx, gpsy, gpsm = GPS:LocalToGlobal(x, y)
            local measurement = GPS:GetCurrentMapMeasurements()
            LibQuestInfo_SavedVariables.subZones[zone][lastZone] = {
                -- previously this was reversed ?? GetMapPlayerPosition
                -- won't reverse that ??
                -- ["y"] = x,
                -- ["x"] = y,
                ["x"] = x,
                ["y"] = y,
                ["gpsx"] = gpsx,
                ["gpsy"] = gpsy,
                ["measurement"] = measurement,
            }
        end
    end
    lastZone = zone

    SLASH_COMMANDS["/qmslist"] = show_quests

end
EVENT_MANAGER:RegisterForEvent(lib.idName, EVENT_PLAYER_ACTIVATED, OnPlayerActivated) -- Verified
