local libName, libVersion = "LibQuestInfo", 188
lib = {}
internal = {}
lib.quest_givers = {}
lib.quest_names = {}
lib.objective_names = {}
lib.client_lang = GetCVar("language.2")
lib.libName = libName
lib.libVersion = libVersion

lib.name_to_questid_table = {}
lib.name_to_questid_table["de"] = {}
lib.name_to_questid_table["en"] = {}
lib.name_to_questid_table["es"] = {}
lib.name_to_questid_table["fr"] = {}
lib.name_to_questid_table["jp"] = {}
lib.name_to_questid_table["ru"] = {}

lib.name_to_npcid_table = {}
lib.name_to_npcid_table["de"] = {}
lib.name_to_npcid_table["en"] = {}
lib.name_to_npcid_table["es"] = {}
lib.name_to_npcid_table["fr"] = {}
lib.name_to_npcid_table["jp"] = {}
lib.name_to_npcid_table["ru"] = {}

lib.name_to_objectiveid_table = {}
lib.name_to_objectiveid_table["de"] = {}
lib.name_to_objectiveid_table["en"] = {}
lib.name_to_objectiveid_table["es"] = {}
lib.name_to_objectiveid_table["fr"] = {}
lib.name_to_objectiveid_table["jp"] = {}
lib.name_to_objectiveid_table["ru"] = {}

if LibQuestInfo_SavedVariables == nil then LibQuestInfo_SavedVariables = {} end

if LibQuestInfo_SavedVariables.version == nil then LibQuestInfo_SavedVariables.version = LibQuestInfo_SavedVariables.version or 1 end
if LibQuestInfo_SavedVariables.libVersion == nil then LibQuestInfo_SavedVariables.libVersion = LibQuestInfo_SavedVariables.libVersion or lib.libVersion end
if LibQuestInfo_SavedVariables.quests == nil then LibQuestInfo_SavedVariables.quests = {} end
if LibQuestInfo_SavedVariables.subZones == nil then LibQuestInfo_SavedVariables.subZones = {} end
if LibQuestInfo_SavedVariables.quest_info == nil then LibQuestInfo_SavedVariables.quest_info = {} end
if LibQuestInfo_SavedVariables.location_info == nil then LibQuestInfo_SavedVariables.location_info = {} end
if LibQuestInfo_SavedVariables.quest_names == nil then LibQuestInfo_SavedVariables.quest_names = {} end
if LibQuestInfo_SavedVariables.objective_info == nil then LibQuestInfo_SavedVariables.objective_info = {} end
if LibQuestInfo_SavedVariables.reward_info == nil then LibQuestInfo_SavedVariables.reward_info = {} end
if LibQuestInfo_SavedVariables.map_info == nil then LibQuestInfo_SavedVariables.map_info = {} end
if LibQuestInfo_SavedVariables.giver_names == nil then LibQuestInfo_SavedVariables.giver_names = {} end

-- note only the "lib.client_lang" will contain data be default

lib.quest_data_index = {
    quest_name      =    1, -- Number index of quest name i.e. 6404 for "The Dragonguard"
    -- quest_giver     =    2,  Depreciated, see quest_map_pin_index
    quest_type      =    2, -- MAIN_STORY, DUNGEON
    quest_repeat    =    3, -- quest_repeat_daily, quest_repeat_not_repeatable = 0, quest_repeat_repeatable
    game_api        =    4, -- 100003 means unverified, 100030 means quest data collected from API 100030
    quest_line      =    5,    -- QuestLine (10000 = not assigned/not verified. 10001 = not part of a quest line/verified)
    quest_number    =    6,    -- Quest Number In QuestLine (10000 = not assigned/not verified)
    quest_series    =    7,    -- None = 0,    Cadwell's Almanac = 1,    Undaunted = 2, AD = 3, DC = 4, EP = 5.
}

lib.quest_map_pin_index = {
    local_x     =    1, -- GetMapPlayerPosition() << -10 = Undefined >>
    local_y     =    2, -- GetMapPlayerPosition() << -10 = Undefined >>
    global_x    =    3, -- LocalToGlobal(GetMapPlayerPosition()) << -10 = Undefined >>
    global_y    =    4, -- LocalToGlobal(GetMapPlayerPosition()) << -10 = Undefined >>
    quest_id    =    5, -- Number index of quest name i.e. 6404 for "The Dragonguard"
    world_x     =    6, -- WorldX 3D Location
    world_y     =    7, -- WorldY 3D Location
    world_z     =    8, -- WorldZ 3D Location
    quest_giver =    9, -- Arbitrary number pointing to an NPC Name 81004, "Abnur Tharn"
}

lib.quest_data_type = {
    -- ESO Values
    quest_type_none = 0,
    quest_type_group = 1,
    quest_type_main_story = 2,
    quest_type_guild = 3,
    quest_type_crafting = 4,
    quest_type_dungeon = 5,
    quest_type_raid = 6,
    quest_type_ava = 7, -- None in table, in check
    quest_type_class = 8, -- None in table
    quest_type_ava_group = 10, -- None in table, in check
    quest_type_ava_grand = 11, -- None in table, in check
    quest_type_holiday_event = 12, -- None in table
    quest_type_battleground = 13, -- None in table

    -- LibQuestInfo Values
    quest_type_daily            = 14,
    quest_type_cadwell          = 15,
    quest_type_ad               = 16,
    quest_type_dc               = 17,
    quest_type_ep               = 18,
    quest_type_undefined        = 19,
    quest_type_guild_mage       = 20,
    quest_type_guild_fighter    = 21,
    quest_type_guild_psijic     = 22,
    quest_type_guild_thief      = 23,
    quest_type_guild_dark       = 24, -- Dark Brotherhood
    quest_type_undaunted        = 25,
}

lib.quest_data_repeat = {
    quest_repeat_daily = 2,
    quest_repeat_not_repeatable = 0,
    quest_repeat_repeatable = 1,
}

lib.dest_quest_data_index = {
	quest_x =		1,
	quest_y =		2,
	questnpc =		3,
	questtype = 	4,
	questrepeat =	5,
	questid =		6,
	questline =		7,	-- QuestLine (10000 = not assigned/not verified. 10001 = not part of a quest line/verified)
	questnumber =	8,	-- Quest Number In QuestLine (10000 = not assigned/not verified)
	questseries =	9,	-- None = 0,	Cadwell's Almanac = 1,	Undaunted = 2, AD = 3, DC = 4, EP = 5.
}

lib.dest_quest_series_index = {
    quest_series_none       = 0,
    quest_series_cadwell    = 1,
    quest_series_undaunted  = 2,
    quest_series_ad         = 3,
    quest_series_dc         = 4,
    quest_series_ep         = 5,
}

_G["LibQuestInfo"] = lib