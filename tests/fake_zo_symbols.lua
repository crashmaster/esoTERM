REGISTER_FOR = nil

EVENT_ADD_ON_LOADED = 0
EVENT_PLAYER_ACTIVATED = 1
EVENT_EXPERIENCE_UPDATE = 2
EVENT_VETERAN_POINTS_UPDATE = 3
EVENT_LEVEL_UPDATE = 4
EVENT_VETERAN_RANK_UPDATE = 5
EVENT_ALLIANCE_POINT_UPDATE = 6
EVENT_LOOT_RECEIVED = 7
EVENT_PLAYER_COMBAT_STATE = 8
EVENT_COMBAT_EVENT = 9
EVENT_UNIT_DEATH_STATE_CHANGED = 10
EVENT_CHAMPION_POINT_GAINED = 11
EVENT_INVENTORY_SINGLE_SLOT_UPDATE = 12

ACTION_RESULT_DAMAGE = 1
ACTION_RESULT_CRITICAL_DAMAGE = 2
ACTION_RESULT_HEAL = 3
ACTION_RESULT_CRITICAL_HEAL = 4
ACTION_RESULT_DOT_TICK = 5
ACTION_RESULT_DOT_TICK_CRITICAL = 6
ACTION_RESULT_HOT_TICK = 7
ACTION_RESULT_HOT_TICK_CRITICAL = 8

COMBAT_UNIT_TYPE_GROUP = 1
COMBAT_UNIT_TYPE_NONE = 2
COMBAT_UNIT_TYPE_OTHER = 3
COMBAT_UNIT_TYPE_PLAYER = 4
COMBAT_UNIT_TYPE_PLAYER_PET = 5

ACTION_SLOT_TYPE_BLOCK = 1
ACTION_SLOT_TYPE_HEAVY_ATTACK = 2
ACTION_SLOT_TYPE_LIGHT_ATTACK = 3
ACTION_SLOT_TYPE_NORMAL_ABILITY = 4
ACTION_SLOT_TYPE_OTHER = 5
ACTION_SLOT_TYPE_ULTIMATE = 6
ACTION_SLOT_TYPE_WEAPON_ATTACK = 7

POWERTYPE_FINESSE = 1
POWERTYPE_HEALTH = 2
POWERTYPE_HEALTH_BONUS = 3
POWERTYPE_INVALID = 4
POWERTYPE_MAGICKA = 5
POWERTYPE_MOUNT_STAMINA = 6
POWERTYPE_STAMINA = 7
POWERTYPE_ULTIMATE = 8
POWERTYPE_WEREWOLF = 9

DAMAGE_TYPE_COLD = 1
DAMAGE_TYPE_DISEASE = 2
DAMAGE_TYPE_DROWN = 3
DAMAGE_TYPE_EARTH = 4
DAMAGE_TYPE_FIRE = 5
DAMAGE_TYPE_GENERIC = 6
DAMAGE_TYPE_MAGIC = 7
DAMAGE_TYPE_NONE = 8
DAMAGE_TYPE_OBLIVION = 9
DAMAGE_TYPE_PHYSICAL = 10
DAMAGE_TYPE_POISON = 11
DAMAGE_TYPE_SHOCK = 12

SI_TOOLTIP_ITEM_NAME = "SI_TOOLTIP_ITEM_NAME"

BAG_BACKPACK = 1
BAG_BANK = 2
LINK_STYLE_DEFAULT = 1

SLASH_COMMANDS = {}

function GetBagSize() end

function GetChampionXPInRank() end

function GetItemLink() end

function GetItemName() end

function GetPlayerChampionPointsEarned() end

function GetPlayerChampionXP() end

function GetSlotStackSize() end

function zo_callLater(func) func() end

function zo_strformat(format_string, stuff) return stuff end

EVENT_MANAGER = {
    UnregisterForEvent = function(operation, event) return nil end,
    RegisterForEvent = function(addon, event, callback) return nil end
}

ZO_SimpleSceneFragment = {
    New = function(window) return nil end
}

SCENE = {
    AddFragment = function(fragment) return nil end
}

GAME_MENU_SCENE = {
    RegisterCallback = function(event, callback) return nil end
}

SCENE_MANAGER = {
    GetScene = function(scene) return SCENE end
}

ZO_SavedVars = {
    New = function(table_name, version, namespace, default) return nil end
}

CALLBACK_MANAGER = {
    FireCallbacks = function(event_name) return nil end
}
