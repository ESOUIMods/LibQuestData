local lib = _G["LibQuestData"]
local internal = _G["LibQuestData_Internal"]

-- Local variables
local questGiverName = nil
local reward
-- Init saved variables table
local GPS = LibGPS3
local LMP = LibMapPins
local quest_shared
local quest_found

-- return true if map_id is not in the list of main zone maps
-- replaces IsBaseZone
function lib:is_zone_subzone()
  local map_id
  if SetMapToPlayerLocation() ~= SET_MAP_RESULT_FAILED then
    map_id = GetCurrentMapId()
  end
  if internal:is_in(map_id, lib.zone_id_list) then
    -- false because the zone_id was in the list of Main Zones
    return false
  else
    return true
  end
end

-- Check if both map zones to see if they are the same
local function is_same_zone_index(zone_index_1, zone_index_2)
  return (zone_index_1 == zone_index_2)
end

-- Check if both map ids are different
local function is_different_zone(map_id_1, map_id_2)
  return (map_id_1 ~= map_id_2)
end

function lib:get_giver_when_object(id)
  if internal:is_empty_or_nil(lib.questid_giver_lookup[id]) then
    --d("If giver is an object, one was not found")
    return {}
  else
    --d("Giver is an object, found one")
    return lib.questid_giver_lookup[id]
  end
end

local function get_sv_quest_info(zone)
  --d(zone)
  -- if type(zone) ~= "string"
  if internal:is_empty_or_nil(LibQuestData_SavedVariables.quests[zone]) then
    --d("get_sv_quest_info it was nil")
    return {}
  else
    --d("get_sv_quest_info was not nil")
    return LibQuestData_SavedVariables.quests[zone]
  end
end

local function is_giver_in_sv(id)
  --d(id)
  if internal:is_empty_or_nil(LibQuestData_SavedVariables["giver_names"][id]) then
    --d("The Quest ID and name set to an NPC or Unknown, was not found in the SV table")
    return false
  else
    --d("The Quest ID and name is already in the SV table")
    return true
  end
end

local function is_questname_in_sv(id)
  --d(id)
  --[[Note to self:
  Originally I saved it with a key for the name and realized
  it's faster to copy paste with an ID number.

  Since this is the save game information I don't have a
  lookup table for this nor should I make one. Converting
  the quest name to a quest ID is pointless. Just ensure
  I look at the table for quest names, return an empty
  table without an error

  Needs different way to handle this or leave it since
  the assignment overwrites the value each time regardless.
  ]]--
  if internal:is_empty_or_nil(LibQuestData_SavedVariables["quest_names"][id]) then
    --d("is_questname_in_sv it was nil")
    return false
  else
    --d("is_questname_in_sv was not nil")
    --d(LibQuestData_SavedVariables["quest_names"][id])
    return true
  end
end

local function get_quest_list_sv(zone)
  --d(zone)
  if type(zone) == "string" and LibQuestData_SavedVariables["location_info"][zone] ~= nil then
    return LibQuestData_SavedVariables["location_info"][zone]
  else
    return {}
  end
end

-- Event handler function for EVENT_QUEST_ADDED
local function OnQuestAdded(eventCode, journalIndex, questName, objectiveName)
  --internal.dm("Debug", "OnQuestAdded")
  if quest_shared then
    quest_shared = false
    return
  end
  --internal.dm("Debug", journalIndex)
  -- -1 for these means it is undefined since 0 is a valid value
  local quest_type = -1
  local quest_display_type = -1
  local repeat_type = -1
  local zone_name = ""
  local zone_index = -1
  local poi_index = -1
  local quest_id = -1
  -- "-1" means it has not been completed. Once complete set it to the time stamp
  -- I am considering using this to see if I can calculate order for Zone quests

  -- Add quest to saved variables table in correct zone element

  local zone = LMP:GetZoneAndSubzone(true, false, true)
  if LibQuestData_SavedVariables.quests[zone] == nil then LibQuestData_SavedVariables.quests[zone] = {} end
  local local_x, local_y = GetMapPlayerPosition("player")
  local global_x, global_y, zoneMapIndex = GPS:LocalToGlobal(local_x, local_y)
  local zone_id, _, _, _ = GetUnitWorldPosition("player")
  if journalIndex then
    quest_type = GetJournalQuestType(journalIndex)
    quest_display_type = GetJournalQuestInstanceDisplayType(journalIndex)
    repeat_type = GetJournalQuestRepeatType(journalIndex)
    zone_name, _, zone_index, poi_index = GetJournalQuestLocationInfo(journalIndex)
    --internal.dm("Debug", quest_type)
    --internal.dm("Debug", quest_display_type)
  end
  local quest = {
    ["zone_name"] = zone_name,
    ["zone_index"] = zone_index,
    ["poi_index"] = poi_index,
    ["quest_type"] = quest_type,
    ["quest_display_type"] = quest_display_type,
    ["repeat_type"] = repeat_type,
    ["name"] = questName,
    ["x"] = local_x,
    ["y"] = local_y,
    ["gpsx"] = global_x,
    ["gpsy"] = global_y,
    ["giver"] = questGiverName,
    ["questID"] = quest_id, -- assign this and get the ID when the quest is removed
    ["api"] = GetAPIVersion(),
    ["lang"] = GetCVar("language.2"),
  }
  if questGiverName == nil then
    quest["giver"] = lib.last_interaction_target
  end

  quest_found = false
  local quests_in_zone = get_sv_quest_info(zone)
  for num_entry, quest_from_table in pairs(quests_in_zone) do
    if quest_from_table.name == questName then
      quest_found = true
    end
  end
  if quest_found then
    --d("quest found")
  else
    --d("quest not found")
    table.insert(LibQuestData_SavedVariables.quests[zone], quest)
  end
end
EVENT_MANAGER:RegisterForEvent(lib.libName, EVENT_QUEST_ADDED, OnQuestAdded) -- Verified

-- Event handler function for EVENT_CHATTER_END
local function OnChatterEnd(eventCode)
  --d("OnChatterEnd")
  questGiverName = nil
  reward = nil
  -- Stop listening for the quest added event because it would only be for shared quests
  -- Shar I added if EVENT_QUEST_SHARED to OnQuestAdded UnregisterForEvent EVENT_QUEST_ADDED
  -- EVENT_MANAGER:UnregisterForEvent(lib.libName, EVENT_QUEST_ADDED)
  EVENT_MANAGER:UnregisterForEvent(lib.libName, EVENT_CHATTER_END) -- Verified
end

local function OnQuestSharred(eventCode, questID)
  --d("OnQuestSharred")
  quest_shared = true
  lib.last_interaction_target = ""
end
EVENT_MANAGER:RegisterForEvent(lib.libName, EVENT_QUEST_SHARED, OnQuestSharred) -- Verified

-- Event handler function for EVENT_QUEST_OFFERED
-- Note runs when you click writ board
local function OnQuestOffered(eventCode)
  --d("OnQuestOffered")
  -- Get the name of the NPC or intractable object
  -- (This could also be done in OnQuestAdded directly, but it's saver here because we are sure the dialogue is open)
  questGiverName = GetUnitName("interact")
  -- Now that the quest has been offered we can start listening for the quest added event
  -- Shar I added if EVENT_QUEST_SHARED to OnQuestAdded UnregisterForEvent EVENT_QUEST_ADDED
  -- EVENT_MANAGER:RegisterForEvent(lib.libName, EVENT_QUEST_ADDED, OnQuestAdded)
  EVENT_MANAGER:RegisterForEvent(lib.libName, EVENT_CHATTER_END, OnChatterEnd) -- Verified
end
EVENT_MANAGER:RegisterForEvent(lib.libName, EVENT_QUEST_OFFERED, OnQuestOffered) -- Verified

-- Event handler function for EVENT_QUEST_COMPLETE_DIALOG
local function OnQuestCompleteDialog(eventCode, journalIndex)
  --d("OnQuestCompleteDialog")
  local numRewards = GetJournalQuestNumRewards(journalIndex)
  if numRewards <= 0 then return end
  reward = {}
  for i = 1, numRewards do
    local rewardType = GetJournalQuestRewardInfo(journalIndex, i)
    table.insert(reward, rewardType)
  end
end
EVENT_MANAGER:RegisterForEvent(lib.libName, EVENT_QUEST_COMPLETE_DIALOG, OnQuestCompleteDialog) -- Verified

local function has_undefined_data(info)
  --[[
  This is used for both the main database and the save file
  ]]--
  local undefined = false
  if info[lib.quest_map_pin_index.global_x] == -10 then
    --d("global_x was -10 so undefined")
    undefined = true
  end
  --[[
  No quest Giver so it is undefined
  ]]--
  if info[lib.quest_map_pin_index.quest_giver] == -1 then
    --d("quest_giver was -1 so undefined")
    undefined = true
  end

  --[[ Very old format
  The save file might only have 1 to 5
  ]]--
  if #info <= 5 then
    --d("#info <= 5 data format")
    --[[
    meaning it's an old format and therefore it is all
    undefined.
    ]]--
    return true
  end

  --[[
  4/2/2021 New Format
  There are now exactly 6 fields.
  ]]--
  if #info == 6 then
    --d("#info == 6 data format")
    --[[
    meaning it's the new format and therefore it is all
    probably okay, will return true if previous checks
    failed
    ]]--
    return undefined
  end

  --[[
  There were about 10 quests that didn't get a giver
  and will be nil. Less then or equal to 8 because
  there are 9 fields.
  ]]--
  if #info <= 8 then
    --d("#info <= 8 data format")
    --[[
    meaning it's an old format and therefore it is all
    undefined.
    ]]--
    return true
  end

  return undefined
end

local function update_older_quest_info(source_data)
  --internal.dm("Debug", "update_older_quest_info")
  local old_quest_giver_value = 9 -- Updated, was 9 now 6
  if not source_data then return end
  -- source data is the table of all the quests in the zone
  --[[
  build a new table with quest location info that is properly defined
  discard all quest information that needs updated because the new
  data is already correct
  ]]--
  --internal.dm("Debug", #source_data)
  local result_table = {}
  local found = false
  for num_entry, quest_entry in ipairs(source_data) do
    if #quest_entry <= 5 then
      --internal.dm("Debug", "info is in the old format add new information")
      quest_entry[lib.quest_map_pin_index.quest_giver] = -1 -- Arbitrary number pointing to an NPC Name 81004, "Abnur Tharn"  << -1 = Undefined >>
      table.insert(result_table, quest_entry)
      found = true
    end
    if #quest_entry > 6 then
      local new_quest_entry
      --internal.dm("Debug", "info is not in the old format so we need to convert it")
      new_quest_entry[lib.quest_map_pin_index.local_x] = quest_entry[lib.quest_map_pin_index.local_x]
      new_quest_entry[lib.quest_map_pin_index.local_y] = quest_entry[lib.quest_map_pin_index.local_y]
      new_quest_entry[lib.quest_map_pin_index.global_x] = quest_entry[lib.quest_map_pin_index.global_x]
      new_quest_entry[lib.quest_map_pin_index.global_y] = quest_entry[lib.quest_map_pin_index.global_y]
      new_quest_entry[lib.quest_map_pin_index.quest_id] = quest_entry[lib.quest_map_pin_index.quest_id]
      new_quest_entry[lib.quest_map_pin_index.quest_giver] = quest_entry[old_quest_giver_value]
      table.insert(result_table, new_quest_entry)
      found = true
    end
    if #quest_entry == 6 then
      --internal.dm("Debug", "info is in the new format so no convertion needed")
      table.insert(result_table, quest_entry)
      found = true
    end

    if found then
      --internal.dm("Debug", "We found something")
    else
      --internal.dm("Debug", "Shit Hit the fan")
    end

  end
  --internal.dm("Debug", #result_table)
  return result_table
end

local function remove_older_quest_info(source_data, quest_info)
  -- source data is the table of all the quests in the zone
  --[[
  build a new table with quest location info that is properly defined
  discard all quest information that needs updated because the new
  data is already correct
  ]]--
  local result_table = {}
  for num_entry, quest_entry in ipairs(source_data) do
    if quest_entry[lib.quest_map_pin_index.quest_id] == quest_info[lib.quest_map_pin_index.quest_id] then
      local distance = zo_round(GPS:GetLocalDistanceInMeters(quest_entry[lib.quest_map_pin_index.local_x],
        quest_entry[lib.quest_map_pin_index.local_y], quest_info[lib.quest_map_pin_index.local_x],
        quest_info[lib.quest_map_pin_index.local_y]))
      --d("Distance: "..distance)
      if distance <= 25 then
        table.remove(source_data, num_entry)
      end
    end
  end
end

-- set alliance
local function SetQuestSeries(the_zone)
  local value = 0
  if string.match(the_zone, "cyrodiil") then
    if lib.player_alliance == ALLIANCE_ALDMERI_DOMINION then value = lib.quest_series_type.quest_type_ad end
    if lib.player_alliance == ALLIANCE_EBONHEART_PACT then value = lib.quest_series_type.quest_type_ep end
    if lib.player_alliance == ALLIANCE_DAGGERFALL_COVENANT then value = lib.quest_series_type.quest_type_dc end
  end
  return value
end

-- Event handler function for EVENT_QUEST_REMOVED
local function OnQuestRemoved(eventCode, isCompleted, journalIndex, questName, zoneIndex, poiIndex, questID)
  --internal.dm("Debug", "OnQuestRemoved")
  --internal.dm("Debug", questName)
  local quest_to_update = nil
  local the_zone
  local the_entry
  local giver_name_result
  local quest_info_changed = false
  local save_quest_location = true
  --local my_pos_x, my_pos_y = GetMapPlayerPosition("player")

  for zone, zone_quests in pairs(LibQuestData_SavedVariables.quests) do
    for num_entry, quest_from_table in pairs(zone_quests) do
      if quest_from_table.zone_index and quest_from_table.poi_index then
        if quest_from_table.zone_index == zoneIndex and quest_from_table.poi_index == poiIndex and quest_from_table.name == questName then
          --internal.dm("Debug", "Detailed quest info was all true")
          the_zone = zone
          the_entry = num_entry
          quest_to_update = quest_from_table
          break
        end
      elseif quest_from_table.name == questName then
        --internal.dm("Debug", "Quest name was true due to old information")
        the_zone = zone
        the_entry = num_entry
        quest_to_update = quest_from_table
        break
      end
    end
  end

  if quest_to_update == nil then
    return
  end

  if quest_to_update.zone_name then
    --internal.dm("Debug", "zone_name: " .. quest_to_update.zone_name)
  end
  if quest_to_update.zone_index then
    --internal.dm("Debug", "zone_index: " .. quest_to_update.zone_index)
    --internal.dm("Debug", "zoneIndex: " .. tostring(zoneIndex))
  end
  if quest_to_update.poi_index then
    --internal.dm("Debug", "poi_index: " .. quest_to_update.poi_index)
    --internal.dm("Debug", "poiIndex: " .. tostring(poiIndex))
  end
  if not quest_to_update.quest_display_type then
    --internal.dm("Debug", "quest_display_type did not exist, set to 0")
    quest_to_update.quest_display_type = INSTANCE_DISPLAY_TYPE_NONE
  end

  --internal.dm("Debug", "questID: " .. questID)
  if questID >= 1 then
    if quest_to_update.questID == -1 then
      quest_to_update.questID = questID
    end
  end

  --[[ set quest giver to it's ID number using the name of the NPC ]]--
  --[[ Check if Quest Giver is an Object, Sign, Note ]]--
  LibQuestData_SavedVariables["giver_names"] = LibQuestData_SavedVariables["giver_names"] or {}
  local temp_giver = lib:get_giver_when_object(quest_to_update.questID)
  --internal.dm("Debug", "temp_giver was:")
  --internal.dm("Debug", temp_giver)
  if internal:is_empty_or_nil(temp_giver) then
    --d("The temp_giver was nil")
    -- meaning no giver object found
  else
    --d("The temp_giver was not nil")
    -- meaning there was a giver object found
    quest_to_update.giver = lib:get_quest_giver(temp_giver)
    --d(temp_giver)
    --d(quest_to_update.giver)
    --d(lib.quest_givers["en"][quest_to_update.giver])
  end
  --internal.dm("Debug", "quest giver table was")
  --quest_to_update.giver = "The Fish Object"
  --internal.dm("Debug", quest_to_update.giver)
  giver_name_result = lib:get_npcids_table(quest_to_update.giver)
  --internal.dm("Debug", giver_name_result)
  if giver_name_result == nil then
    --[[ Check if Quest Giver is simply nil or empty, unassigned ]]--
    if internal:is_empty_or_nil(quest_to_update.giver) then
      --internal.dm("Debug", "Quest giver was nil, it is an empty table now from previous function")
      -- meaning set it to Unknown Target
      quest_to_update.giver = "Unknown Target"
      --d(quest_to_update.giver)
    else
      --internal.dm("Debug", "not empty or nil so continue")
    end
    --[[
    At this point we know:
    1: The quest giver was not in the main database
    2: It was/wasn't a sign of note, object
    3: The quest_to_update.giver was/wasn't nil and set to Unknown

    Result: The Quest Giver has been set to the object if it was a sign
    or post, or to Unknown if quest_to_update.giver was nil. Otherwise
    nothing happened to quest_to_update.giver because it's a valid
    NPC name but not in the main database yet.

    Next Step: Simply save the valid NPC name or Unknown using the QuestID
    as a key. Then I can make a custom Quest Giver ID for it.
    ]]--
    --d("quest giver lookup table is nil look in sv now")
    --d(giver_name_result)
    if is_giver_in_sv(quest_to_update.questID) then
      --internal.dm("Debug", "The giver was in the SV file")
      -- meaning don't save it because the NPC name was not in
      -- the Lua file but was in the save vars and I need an
      -- arbitrary value, use the string for now
    else
      --internal.dm("Debug", "The giver was not in the SV file")
      LibQuestData_SavedVariables.giver_names[quest_to_update.questID] = quest_to_update.giver
    end
    giver_name_result = quest_to_update.giver
  else
    --internal.dm("Debug", "quest giver lookup table is not nil")
    -- meaning we found it don't add it but I need the number
    giver_name_result = lib:get_npcids_table(quest_to_update.giver)[1]
    --internal.dm("Debug", giver_name_result)
  end
  --internal.dm("Debug", "end result was")
  --internal.dm("Debug", giver_name_result)

  --[[ set quest name ]]--
  --d(quest_to_update.questID)
  --d("Quest Name Please")
  --d(lib:get_quest_name(quest_to_update.questID))
  LibQuestData_SavedVariables["quest_names"] = LibQuestData_SavedVariables["quest_names"] or {}
  local temp_quest_name = lib:get_quest_name(quest_to_update.questID)
  if temp_quest_name == "Unknown Name" then
    --d("quest name is Unknown Name - So not found")
    if is_questname_in_sv(quest_to_update.questID) then
      --d("returned true so it was in the sv")
    else
      --d("returned false so it was not in the sv")
      LibQuestData_SavedVariables["quest_names"][quest_to_update.questID] = quest_to_update.name
    end
  else
    -- get_questname_sv
    --d("quest name is not Unknown Name - So it was found")
    --d(lib:get_quest_name(quest_to_update.questID))
    -- is the quest name different from a previous version of the game
    if temp_quest_name ~= questName then
      if is_questname_in_sv(quest_to_update.questID) then
        --d("returned true so it was in the sv")
      else
        --d("returned false so it was not in the sv")
        LibQuestData_SavedVariables["quest_names"][quest_to_update.questID] = quest_to_update.name
      end
    else
      --seems to be the same so don't save it
    end
  end

  --[[ Add Quest Information
  Step 1: Use series of comparisons to see if values are different
          and if they are save the new quest information.
          At first they will all be different for API but check
          anyway.
  ]]--
  local currentApiVersion = GetAPIVersion()
  the_quest_info = {
    [lib.quest_data_index.quest_type] = quest_to_update.quest_type,
    [lib.quest_data_index.quest_repeat] = quest_to_update.repeat_type,
    [lib.quest_data_index.game_api] = currentApiVersion,
    [lib.quest_data_index.quest_line] = 10000,
    [lib.quest_data_index.quest_number] = 10000,
    [lib.quest_data_index.quest_series] = SetQuestSeries(the_zone),
    [lib.quest_data_index.quest_display_type] = quest_to_update.quest_display_type,
  }

  LibQuestData_SavedVariables["quest_info"] = LibQuestData_SavedVariables["quest_info"] or {}
  local temp_quest_info = lib.quest_data[quest_to_update.questID]
  if temp_quest_info == nil then
    --d("quest information is nil")
    -- meaning I need to create it and save it, no compare
    LibQuestData_SavedVariables["quest_info"][quest_to_update.questID] = the_quest_info
  else
    --d("quest information is not nill")
    -- meaning I need to compare things and save if different
    --[[
    Depreciated
    if temp_quest_info[lib.quest_data_index.quest_name] ~= quest_to_update.questID then
        temp_quest_info [lib.quest_data_index.quest_name] = quest_to_update.questID
        quest_info_changed = true
    end
    ]]--

    -- quest_giver_is_object lib.quest_data_index.quest_giver, depreciated

    -- update alliance
    if string.match(the_zone, "cyrodiil") then
      if lib.player_alliance == ALLIANCE_ALDMERI_DOMINION then temp_quest_info[lib.quest_data_index.quest_series] = lib.quest_series_type.quest_type_ad end
      if lib.player_alliance == ALLIANCE_EBONHEART_PACT then temp_quest_info[lib.quest_data_index.quest_series] = lib.quest_series_type.quest_type_ep end
      if lib.player_alliance == ALLIANCE_DAGGERFALL_COVENANT then temp_quest_info[lib.quest_data_index.quest_series] = lib.quest_series_type.quest_type_dc end
      quest_info_changed = true
    end
    if not temp_quest_info[lib.quest_data_index.quest_display_type] then temp_quest_info[lib.quest_data_index.quest_display_type] = INSTANCE_DISPLAY_TYPE_NONE end
    if temp_quest_info[lib.quest_data_index.quest_display_type] ~= quest_to_update.quest_display_type then
      temp_quest_info[lib.quest_data_index.quest_display_type] = quest_to_update.quest_display_type
      quest_info_changed = true
    end
    if temp_quest_info[lib.quest_data_index.quest_type] ~= quest_to_update.quest_type then
      temp_quest_info[lib.quest_data_index.quest_type] = quest_to_update.quest_type
      quest_info_changed = true
    end
    if temp_quest_info[lib.quest_data_index.quest_repeat] ~= quest_to_update.repeat_type then
      temp_quest_info[lib.quest_data_index.quest_repeat] = quest_to_update.repeat_type
      quest_info_changed = true
    end
    if temp_quest_info[lib.quest_data_index.game_api] < currentApiVersion then
      temp_quest_info[lib.quest_data_index.game_api] = currentApiVersion
      quest_info_changed = true
    end
    -- quest_line is set manually
    -- quest_number is set manually
    -- quest_series is set manually
    --d(temp_quest_info)
    --[[ Check Saved Vars format ]]--
    if LibQuestData_SavedVariables.quest_info[quest_to_update.questID] ~= nil and #LibQuestData_SavedVariables.quest_info[quest_to_update.questID] > 7 then
      --internal.dm("Debug", "old format")
      --[[
      Not technically a change but the SavedVariables data is the old format
      so update it. It doesn't matter about what it is the main database has
      been converted already.
      ]]--
      quest_info_changed = true
    end
    --[[ Do not need to check main database format because it was updated ]]--

    if quest_info_changed then
      --internal.dm("Debug", "save the table")
      --internal.dm("Debug", temp_quest_info)
      LibQuestData_SavedVariables.quest_info[quest_to_update.questID] = temp_quest_info
    else
      --internal.dm("Debug", "do not save the table")
    end
  end

  the_quest_loc_info = {
    [lib.quest_map_pin_index.local_x] = quest_to_update.x,
    [lib.quest_map_pin_index.local_y] = quest_to_update.y,
    [lib.quest_map_pin_index.global_x] = quest_to_update.gpsx,
    [lib.quest_map_pin_index.global_y] = quest_to_update.gpsy,
    [lib.quest_map_pin_index.quest_id] = quest_to_update.questID,
    [lib.quest_map_pin_index.quest_giver] = giver_name_result,
  }

  --[[
  At this point save_quest_location is false and will not be set to false in this
  loop. It will only be true if there is the potentiol it is a secondary location
  for the same quest.

  Not sure I want to do this twice but later on in another loop I will look at the
  LibGPS value to also determine whether or not to save the information.

  Neeed to think this over but for now I am hoping the second loop will allow me to
  decide that if the information is about to be saved and it passed the first two
  verifications, only then can it be checked against -10.

  Also it might be better to build a table of the quests in the zone with the same
  questID and then check against that instead. Probably more efficent but I want to
  get this done for Greymore's Rough draft.

  If I make a table I want to make the table from the main database first, then the SV
  and then determine that there are pins that already exist so don't save the
  information.
  ]]--
  regular_quest_list = internal:get_zone_quests(the_zone)
  --d(quest_to_update.questID)
  for num_entry, quest_entry_table in ipairs(regular_quest_list) do
    --d(num_entry)
    --d(quest_entry_table)
    if quest_entry_table[lib.quest_map_pin_index.quest_id] == quest_to_update.questID then
      --d("Found an entry with the same quest ID so check LibGPS")
      -- my_pos_x, my_pos_y : not this may not be important because I know where I was standing
      local distance = zo_round(GPS:GetLocalDistanceInMeters(quest_entry_table[lib.quest_map_pin_index.local_x],
        quest_entry_table[lib.quest_map_pin_index.local_y], quest_to_update.x, quest_to_update.y))
      --d(distance)
      --d(quest_entry_table)
      if distance <= 25 then
        --d("The quest from the main database was close to the quest to update")
        --d("However is it -10?")
        if has_undefined_data(quest_entry_table) then
          --internal.dm("Debug", "quest_entry_table had undefined data")
          -- save_quest_location = true
        else
          --internal.dm("Debug", "quest_entry_table was defined properly")
          save_quest_location = false
        end
        if quest_entry_table[lib.quest_map_pin_index.quest_giver] ~= giver_name_result then
          --internal.dm("Debug", "The giver name is different so this may need updated")
          save_quest_location = true
        else
          --internal.dm("Debug", "The giver name was the same")
          -- save_quest_location = false
        end
      else
        --internal.dm("Debug", "The quest from the main database was NOT close to the quest to update")
        --internal.dm("Debug", "Could be set to true for saving to the SV file")
        -- meaning it should not be where I am standing
        -- consider saving the location
        -- question, how to avoid duplicates though
      end
    end
  end
  --internal.dm("Debug", "done first pass")

  --[[So save_quest_location is true by default in case it is a new
  quest that doesn't exist in the main database. If we are going to
  save it check saved vars first
  ]]--
  --internal.dm("Debug", "save_quest_location: "..tostring(save_quest_location))
  -- the api changed so save the location regardless
  if LibQuestData_SavedVariables["location_info"] == nil then
    --internal.dm("Debug", "location_info was nil")
    LibQuestData_SavedVariables["location_info"] = {}
  end
  if LibQuestData_SavedVariables["location_info"][the_zone] == nil then
    --internal.dm("Debug", "location_info the_zone was nil")
    LibQuestData_SavedVariables["location_info"][the_zone] = {}
  end
  -- clear all old entries
  LibQuestData_SavedVariables["location_info"][the_zone] = update_older_quest_info(LibQuestData_SavedVariables["location_info"][the_zone])
  -- now look for duplicates
  if save_quest_location then
    saved_vars_quest_list = get_quest_list_sv(the_zone)
    for num_entry, sv_quest_entry in ipairs(saved_vars_quest_list) do
      --internal.dm("Debug", "Num Entry: "..num_entry)
      --internal.dm("Debug", sv_quest_entry)
      if sv_quest_entry[lib.quest_map_pin_index.quest_id] == quest_to_update.questID then
        --internal.dm("Debug", "found that the entry 5 was equal to the ID of this quest in the SV file")
        -- meaning it is in the saved vars file don't duplicate it
        local distance = zo_round(GPS:GetLocalDistanceInMeters(sv_quest_entry[lib.quest_map_pin_index.local_x],
          sv_quest_entry[lib.quest_map_pin_index.local_y], quest_to_update.x, quest_to_update.y))
        --internal.dm("Debug", "Distance: "..distance)
        if internal:is_in(quest_to_update.questID, lib.quest_giver_moves) then
          --internal.dm("Debug", "We found a quest giver that moves")
          save_quest_location = false
        else
          --internal.dm("Debug", "We did not find a quest giver that moves")
        end
        --[[
        This should prevent saving prologue quests however, when the
        quest has has_undefined_data then it may save anyway to be examined
        manually and added
        ]]--
        if internal:is_in(quest_to_update.questID, lib.prologue_quest_list) then
          --internal.dm("Debug", "We found a prologue quest that can be accepted anywhere")
          save_quest_location = false
        else
          --internal.dm("Debug", "We did not find a prologue quest")
        end
        if internal:is_in(quest_to_update.questID, lib.object_quest_starter_list) then
          --internal.dm("Debug", "This was a starter quest from an object like a note")
          save_quest_location = false
        else
          --internal.dm("Debug", "This was not a starter quest from an object like a note")
        end
        if distance <= 25 then
          --internal.dm("Debug", "The quest to be saved is close to one already in the SV file")
          save_quest_location = false
        else
          --internal.dm("Debug", "The quest to be saved is not close one in the SV file")
        end
        --[[
        This may save some quests even though they were set to false and
        need to be examined manually
        ]]--
        if has_undefined_data(sv_quest_entry) then
          --internal.dm("Debug", "sv_quest_entry had undefined data")
          remove_older_quest_info(LibQuestData_SavedVariables["location_info"][the_zone], the_quest_loc_info)
          save_quest_location = true
        else
          --internal.dm("Debug", "sv_quest_entry was defined properly")
        end
      end
    end
  end
  --internal.dm("Debug", "done second pass")

  --[[ Save the qest location
  Somehow the quest was in the constants file and the LibGPS was -10
  so I determined I needed to save the updated location. Then after
  looking in the saved vars file for LibQuestData we did not see an
  entry for this quest in the zone so it needs to be saved.
  ]]--
  --save_quest_location = false
  --internal.dm("Debug", "About To Save")
  if save_quest_location and lib.supported_lang then
    --internal.dm("Debug", "save_quest_location is true saving")
    --internal.dm("Debug", the_zone)
    if LibQuestData_SavedVariables["location_info"][the_zone] == nil then
      --internal.dm("Debug", "location_info was nil")
      LibQuestData_SavedVariables["location_info"][the_zone] = {}
    end
    --internal.dm("Debug", "table insert into location_info")
    table.insert(LibQuestData_SavedVariables["location_info"][the_zone], the_quest_loc_info)
  else
    --internal.dm("Debug", "save_quest_location was false not saving")
  end

  --d(the_zone)
  --d(the_entry)

  table.remove(LibQuestData_SavedVariables.quests[the_zone], the_entry)

  --internal.dm("Debug", "Quest Recording Done")
  if not isCompleted then
    return
  end

  if isCompleted then
    if not LibQuestData_SavedVariables.reward_info then LibQuestData_SavedVariables.reward_info = {} end
    if not LibQuestData_SavedVariables.reward_info[questID] then LibQuestData_SavedVariables.reward_info[questID] = {} end
    LibQuestData_SavedVariables.reward_info[questID] = reward
    reward = nil
    lib:set_conditional_quests(questID)
  end
end
EVENT_MANAGER:RegisterForEvent(lib.libName, EVENT_QUEST_REMOVED, OnQuestRemoved) -- Verified

local function show_quests()
  for zone, zone_quests in pairs(LibQuestData_SavedVariables.quests) do
    d("zone: " .. zone)
    for num_entry, quest_from_table in pairs(zone_quests) do
      quest_to_update = quest_from_table
      d("Quest Name: " .. quest_to_update.name)
    end
  end
end

local function OnInteract(event_code, client_interact_result, interact_target_name)
  --internal.dm("Debug", "OnInteract Occured")
  --d(client_interact_result)
  local text = zo_strformat(SI_CHAT_MESSAGE_FORMATTER, interact_target_name)
  --internal.dm("Debug", text)
  lib.last_interaction_target = text
end
EVENT_MANAGER:RegisterForEvent(lib.libName, EVENT_CLIENT_INTERACT_RESULT, OnInteract)

function lib.on_map_zone_changed()
  internal.dm("Debug", "[5] on_map_zone_changed")

  internal.dm("Debug", "[5] Updating last_mapid and current_mapid")
  lib.last_mapid = lib.current_mapid
  lib.last_zone = lib.current_zone
  lib.current_mapid = GetCurrentMapId()
  lib.current_zone = LMP:GetZoneAndSubzone(true, false, true)

  if not lib.last_mapid then
    internal.dm("Debug", "[5] LMP did not set the last_mapid properly")
  end
  if not lib.last_zone then
    internal.dm("Debug", "[5] LMP did not set the last_zone properly")
  end
  if not lib.current_mapid then
    internal.dm("Debug", "[5] LMP did not set the current_mapid properly")
  end
  if not lib.current_zone then
    internal.dm("Debug", "[5] LMP did not set the current_zone properly")
  end

  local temp = string.format("[5] Last Mapid: %s", lib.last_mapid) or "[5] NA"
  internal.dm("Debug", temp)
  local temp = string.format("[5] Last Zone: %s", lib.last_zone) or "[5] NA"
  internal.dm("Debug", temp)
  local temp = string.format("[5] Current Mapid: %s", lib.current_mapid) or "[5] NA"
  internal.dm("Debug", temp)
  local temp = string.format("[5] Current Zone: %s", lib.current_zone) or "[5] NA"
  internal.dm("Debug", temp)
  lib.check_map_state()
end

function on_zone_changed(eventCode, zoneName, subZoneName, newSubzone, zoneId, subZoneId)
  lib.on_map_zone_changed()
end
EVENT_MANAGER:RegisterForEvent(lib.libName .. "_zone_changed", EVENT_ZONE_CHANGED, on_zone_changed)

-- Event handler function for EVENT_PLAYER_DEACTIVATED
local function OnPlayerDeactivated(eventCode)
  internal.dm("Debug", "[6] EVENT_PLAYER_DEACTIVATED")
  internal.dm("Debug", "[6] Updating last_mapid")
  lib.last_mapid = GetCurrentMapId()
  lib.last_zone = LMP:GetZoneAndSubzone(true, false, true)

  if not lib.last_mapid then
    internal.dm("Debug", "[6] LMP did not set the last_mapid properly")
  end
  if not lib.last_zone then
    internal.dm("Debug", "[6] LMP did not set the last_zone properly")
  end

  local temp = string.format("[6] Last Mapid: %s", lib.last_mapid) or "[6] NA"
  internal.dm("Debug", temp)
  local temp = string.format("[6] Last Zone: %s", lib.last_zone) or "[6] NA"
  internal.dm("Debug", temp)
end
EVENT_MANAGER:RegisterForEvent(lib.libName, EVENT_PLAYER_DEACTIVATED, OnPlayerDeactivated) -- Verified

-- Event handler function for EVENT_PLAYER_ACTIVATED
local function OnPlayerActivated(eventCode, initial)
  -- /script LibQuestData.logger:Debug(GetCurrentMapId())
  internal.dm("Debug", "[1] EVENT_PLAYER_ACTIVATED")

  if initial then
    internal.dm("Debug", "[1] Initial first load")
    lib.last_mapid = 0
    lib.last_zone = ""
    lib.current_mapid = GetCurrentMapId()
    lib.current_zone = LMP:GetZoneAndSubzone(true, false, true)
    lib.check_map_state()
  end

  internal.dm("Debug", "[1] Updating current_mapid")
  lib.current_mapid = GetCurrentMapId()
  lib.current_zone = LMP:GetZoneAndSubzone(true, false, true)

  if not lib.current_mapid then
    internal.dm("Debug", "[1] LMP did not set the current_mapid properly")
  end
  if not lib.current_zone then
    internal.dm("Debug", "[1] LMP did not set the current_zone properly")
  end

  local temp = string.format("[1] Current Mapid: %s", lib.current_mapid) or "[1] NA"
  internal.dm("Debug", temp)
  local temp = string.format("[1] Current Zone: %s", lib.current_zone) or "[1] NA"
  internal.dm("Debug", temp)

  lib.check_map_state()
end
EVENT_MANAGER:RegisterForEvent(lib.libName, EVENT_PLAYER_ACTIVATED, OnPlayerActivated) -- Verified
