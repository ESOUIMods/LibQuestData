local libName, libVersion = "LibQuestInfo", 15
lib = {}
lib.quest_givers = {}
lib.quest_names = {}
lib.client_lang = GetCVar("language.2")

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

if LibQuestInfo_SavedVariables == nil then LibQuestInfo_SavedVariables = {} end

if LibQuestInfo_SavedVariables.quests == nil then LibQuestInfo_SavedVariables.quests = {} end
if LibQuestInfo_SavedVariables.questInfo == nil then LibQuestInfo_SavedVariables.questInfo = {} end
if LibQuestInfo_SavedVariables.subZones == nil then LibQuestInfo_SavedVariables.subZones = {} end
if LibQuestInfo_SavedVariables.version == nil then LibQuestInfo_SavedVariables.version = LibQuestInfo_SavedVariables.version or 1 end

-- note only the "lib.client_lang" will contain data be default

lib.quest_data_index = {
    QUEST_NAME      =    1, -- Number index of quest name i.e. 6404 for "The Dragonguard"
    QUEST_GIVER     =    2, -- Arbitrary number pointing to an NPC Name 81004, "Abnur Tharn"
    QUEST_TYPE      =    3, -- MAIN_STORY, DUNGEON
    QUEST_REPEAT    =    4, -- QUEST_REPEAT_DAILY, QUEST_REPEAT_NOT_REPEATABLE = 0, QUEST_REPEAT_REPEATABLE
    GAME_API        =    5, -- 100003 means unverified, 100030 means quest data collected from API 100030
    QUEST_LINE      =    6,    -- QuestLine (10000 = not assigned/not verified. 10001 = not part of a quest line/verified)
    QUEST_NUMBER    =    7,    -- Quest Number In QuestLine (10000 = not assigned/not verified)
    QUEST_SERIES    =    8,    -- None = 0,    Cadwell's Almanac = 1,    Undaunted = 2, AD = 3, DC = 4, EP = 5.
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

_G["LibQuestInfo"] = lib