
local save_config, load_config, apply_skins_now, auto_apply_skins

if type(tick) ~= "function" then
    tick = function()
        if utility and utility.GetTime then return utility.GetTime() end
        if utility and utility.GetTickCount then return utility.GetTickCount() / 1000 end
        if os and os.clock then return os.clock() end
        if os and os.time then return os.time() end
        return 0
    end
end


do
local boba_store = {
    b_aim = false,
    b_aim_key = 0,
    b_aim_fov = 150,
    b_aim_smooth = 5.0,
    b_aim_bone = 0,
    b_aim_vis_text = false,
    b_aim_pred = false,
    b_aim_lead = false,
    b_aim_lock = false,
    b_aim_vis = false,
    b_aim_team = false,
    b_aim_fov_draw = false,
    b_aim_fov_filled = false,

    b_silent = false,
    b_silent_bone = 0,
    b_silent_vis_text = false,
    b_silent_multipoint = false,
    b_silent_fov = 200,
    b_silent_vis = false,
    b_silent_team = false,
    b_silent_fov_draw = false,
    b_silent_fov_filled = false,

    b_npc_aim = false,
    b_npc_aim_bone = 0,
    b_npc_aim_fov = 150,
    b_npc_aim_smooth = 5.0,
    b_npc_aim_bone = 0,
    b_npc_aim_pred = false,
    b_npc_aim_fov_draw = false,
    b_npc_aim_fov_filled = false,

    b_esp = false,
    b_esp_style = 0,
    b_esp_box = false,
    b_esp_skel = false,
    b_esp_hp = false,
    b_esp_hp_txt = false,
    b_esp_name = false,
    b_esp_dist = false,
    b_esp_weapon = false,
    b_esp_snap = false,
    b_esp_range = 1000,
    b_esp_team = false,
    b_esp_staff = false,
    b_esp_armor = false,
    b_esp_hvt = false,
    b_esp_vis_tag = false,

    b_chams = false,
    b_chams_mode = 0,
    b_chams_vc = false,
    b_wep_chams = false,
    b_wep_chams_style = 0,
    b_wep_chams_pulse = false,

    b_npc = false,
    b_npc_box = false,
    b_npc_hp = false,
    b_npc_name = false,
    b_npc_dist = false,
    b_npc_skel = false,
    b_npc_range = 500,

    b_cont = false,
    b_cont_items = false,
    b_cont_range = 500,
    b_loot = false,
    b_loot_range = 400,
    b_loot_filter = 0,
    b_corpse = false,
    b_corpse_items = false,
    b_corpse_range = 500,
    b_quest = false,
    b_quest_range = 800,
    b_extract = false,
    b_extract_range = 3000,
    b_hazard = false,
    b_hazard_range = 1500,
    b_nograss = false,

    b_wm = false,
    b_cross = false,
    b_cross_style = 0,
    b_cross_sz = 8,
    b_cross_gap = 3,
    b_cross_thick = 2,
    b_cross_spin = false,
    b_cross_spin_spd = 5,
    b_cross_pulse = false,
    b_cross_pulse_spd = 4,
    b_radar = false,
    b_radar_sz = 180,
    b_radar_range = 150,
    b_radar_rot = true,
    b_hitmarker = false,
    b_corpse_x = false,

    b_inspect = false,
    b_inv_weap = false,
    b_inv_armor = false,
    b_inv_special = false,
    b_inv_misc = false,
    b_claymore = false,
    b_claymore_names = false,
    b_claymore_range = 140,
    b_car = false,
    b_car_range = 500,
    b_boss = false,
    b_slf = false,
    b_mod_alert = false,
    b_mod_mode = 1,

    b_skin_enable = false,
    b_skin_knife = 0,
    b_skin_gun = 0,
    b_skin_armor = 0,

    b_fov_changer = false,
    b_fov_val = 90,
    b_fov_ads_safe = false,

    b_menu_key = 0x24,
    b_menu_theme = 0,
    b_hard_side = false,
    b_rainbow_mode = false
}

local boba_colors = {
    b_esp_box = {1, 0.3, 0.3, 1},
    b_esp_skel = {1, 1, 1, 1},
    b_esp_name = {1, 1, 1, 1},
    b_esp_snap = {0.4, 0.7, 1.0, 1.0},
    b_esp_staff = {1, 0.2, 1, 1},
    b_esp_hvt = {1, 0.85, 0.2, 1},
    b_chams_vis = {0.0, 1.0, 0.3, 1},
    b_chams_occ = {1.0, 0.25, 0.25, 1},
    b_wep_chams = {0.2, 0.85, 1.0, 1.0},
    b_npc_box = {1, 0.3, 0.3, 1},
    b_npc_name = {1, 0.3, 0.3, 1},
    b_npc_skel = {1, 1, 1, 1},
    b_cont = {0.5, 0.5, 1, 1},
    b_loot = {1, 0.8, 0, 1},
    b_corpse = {0.8, 0.15, 0.15, 1},
    b_quest = {1, 0.5, 1, 1},
    b_extract = {0.2, 1, 0.5, 1},
    b_hazard = {1, 0.4, 0, 1},
    b_cross = {0.25, 0.95, 0.35, 1},
    b_inspect = {0.4, 0.8, 1, 1},
    b_claymore = {1, 0.3, 0.1, 1},
    b_car = {0.4, 1, 0.4, 1},
    b_corpse_x = {1, 0, 0, 1},
    b_aim_fov = {1, 1, 1, 0.25},
    b_silent_fov = {1, 0.8, 0.2, 0.2},
    b_npc_aim_fov = {1, 0.6, 0.6, 0.25}
}

if type(menu) ~= "table" then menu = {} end
local orig_m_get = menu.Get
local orig_m_set = menu.Set
local orig_m_gc = menu.GetColor
local orig_m_sc = menu.SetColor

menu.Get = function(id)
    if boba_store[id] ~= nil then return boba_store[id] end
    if orig_m_get then
        local ok, v = pcall(orig_m_get, id)
        if ok and v ~= nil then return v end
    end
    return false
end

menu.Set = function(id, val)
    boba_store[id] = val
    if orig_m_set then pcall(orig_m_set, id, val) end
end

menu.GetColor = function(id)
    if boba_colors[id] ~= nil then return boba_colors[id] end
    if orig_m_gc then
        local ok, c = pcall(orig_m_gc, id)
        if ok and c ~= nil then return c end
    end
    return {1, 1, 1, 1}
end

menu.SetColor = function(id, col)
    boba_colors[id] = col
    if orig_m_sc then pcall(orig_m_sc, id, col) end
end

menu.GetKey = function(id)
    if boba_store[id] ~= nil then return boba_store[id] end
    return 0
end

_G.ResetAllBobaOptions = function()
    for k, v in pairs(boba_store) do
        if type(v) == "boolean" then
            boba_store[k] = false
        elseif k == "b_aim_fov" or k == "b_npc_aim_fov" then
            boba_store[k] = 150
        elseif k == "b_silent_fov" then
            boba_store[k] = 200
        elseif k == "b_fov_val" then
            boba_store[k] = 90
        elseif k == "b_esp_range" then
            boba_store[k] = 1000
        elseif k == "b_menu_key" then
            boba_store[k] = 0x24
        elseif k == "b_menu_theme" then
            boba_store[k] = 0
        end
        if _G.NixwareSyncVal then _G.NixwareSyncVal(k, boba_store[k]) end
    end
end
end

local sqrt = math.sqrt
local floor = math.floor
local ceil = math.ceil
local abs = math.abs
local min = math.min
local max = math.max
local sin = math.sin
local cos = math.cos
local atan2 = math.atan2
local rad = math.rad
local deg = math.deg
local pi = math.pi
local format = string.format
local huge = math.huge
local function clamp(v, min_v, max_v)
    if v < min_v then return min_v end
    if v > max_v then return max_v end
    return v
end
math.clamp = clamp

local SKEL = {
{"Head","UpperTorso"}, {"UpperTorso","LowerTorso"},
{"UpperTorso","LeftUpperArm"}, {"UpperTorso","RightUpperArm"},
{"LeftUpperArm","LeftLowerArm"}, {"RightUpperArm","RightLowerArm"},
{"LeftLowerArm","LeftHand"}, {"RightLowerArm","RightHand"},
{"LowerTorso","LeftUpperLeg"}, {"LowerTorso","RightUpperLeg"},
{"LeftUpperLeg","LeftLowerLeg"}, {"RightUpperLeg","RightLowerLeg"},
{"LeftLowerLeg","LeftFoot"}, {"RightLowerLeg","RightFoot"}
}

local BONE_MAP = {
[0] = "Head", [1] = "UpperTorso", [2] = "LowerTorso"
}

local GRAY  = {0.6, 0.6, 0.6, 1}
local WHITE = {1, 1, 1, 1}
local RED   = {1, 0.2, 0.2, 1}
local GREEN = {0.2, 1, 0.2, 1}
local CYAN  = {0, 0.9, 1, 1}
local MAGENTA = {1, 0.2, 1, 1}

local M_PER_STUD = 0.28
local STUDS_PER_M = 1 / 0.28

local BULLET_SPEED = {
["12ga"]=425, ["9x39"]=424, ["762x39"]=715, ["556x45"]=933,
["762x54"]=885, ["762x51"]=820, ["338lm"]=992, ["9x18"]=359,
["9x19"]=465, ["45super"]=465, ["762x25"]=460, ["127x108"]=820,
}
local WEAPON_CALIBER = {
["AKMN"]="762x39", ["AKM"]="762x39", ["SKS"]="762x39",
["M4"]="556x45", ["M4A1"]="556x45", ["ADAR15"]="556x45",
["PKM"]="762x54", ["SVD"]="762x54", ["Mosin"]="762x54",
["FAL"]="762x51", ["R700"]="338lm", ["TFZ98S"]="338lm", ["TFZ0"]="9x18",
["AsVal"]="9x39", ["MP443"]="9x18", ["Makarov"]="9x18",
["MP5SD"]="9x19", ["PPSH41"]="762x25",
["Saiga"]="12ga", ["TOZ106"]="12ga", ["IZh12"]="12ga", ["IZh81"]="12ga",
["MK23"]="45super", ["RPG7"]="127x108", ["Groza"]="762x39",
["VZ61"]="9x19", ["TT33"]="9x18",
}
local GRAVITY_STUDS = 80.0
local GRAVITY_MS2 = GRAVITY_STUDS * M_PER_STUD

local function get_bullet_speed(weapon_name)
if not weapon_name or weapon_name == "" then return 715 end
local w = weapon_name:gsub("%s+", "")
for k, v in pairs(WEAPON_CALIBER) do
if w:lower():find(k:lower(), 1, true) then return BULLET_SPEED[v] or 715 end
end
return 715
end

local function calc_ballistic_drop(dist_m, speed_ms)
if not speed_ms or speed_ms <= 0 then speed_ms = 715 end
local t = dist_m / speed_ms
return 0.5 * GRAVITY_MS2 * t * t, t
end

local CAR_NAMES = {
"uaz", "vaz", "vaz2108", "niva", "lada", "kamaz", "gaz", "zil",
"truck", "jeep", "vehicle",
}
local function is_car_name(name)
if not name then return false end
local n = name:lower()
for _, k in ipairs(CAR_NAMES) do
if n:find(k, 1, true) then return true end
end
return false
end

local STAFF_IDS = {
[66395685] = true,
}
local staff_warned = {}

local ITEM_CAT = {
ADAR15="weapon", AKM="weapon", AKMN="weapon", AsVal="weapon",
FAL="weapon", FlareGun="weapon", Groza="weapon", IZh12="weapon",
IZh81="weapon", M4="weapon", MK23="weapon", Makarov="weapon",
Mosin="weapon", MP443="weapon", MP5SD="weapon", NagantRevolver="weapon",
PKM="weapon", PPSH41="weapon", R700="weapon", RPG7="weapon",
SKS="weapon", SVD="weapon", Saiga12="weapon", SPSh44="weapon",
TFZ0="weapon", TFZ98S="weapon", TOZ106="weapon", TT33="weapon",
VZ61="weapon",
AnarchyTomahawk="weapon", ButterflyKnife="weapon",
ButterflyKnifeZenith="weapon", Cutlass="weapon", DV2="weapon",
FlipKnifeShark="weapon", Greatsword="weapon", IceAxe="weapon",
IceDagger="weapon", Karambit="weapon", Kukri="weapon",
Longsword="weapon", M9Fade="weapon", M9XR7="weapon",
PlasmaNinjato="weapon", Scythe="weapon",
F1="weapon", Fuze="weapon", M84="weapon", RGD5="weapon",
RGO="weapon", MON50="weapon", PMN2="weapon", Snowball="weapon",
GrenadeTrap="weapon",
["6B2"]="armor", ["6B23"]="armor", ["6B27"]="armor",
["6B43"]="armor", ["6B47"]="armor", ["6B5"]="armor",
Altyn="armor", AltynVisor="armor", ConcealedVest="armor",
DozerArmor="armor", FastMT="armor", FastVisor="armor",
HSPV="armor", IOTV4="armor", JPC="armor", LegArmor="armor",
Lvl4Plate="armor", MaskaVisor="armor", MotorcycleHelmet="armor",
MotorcycleHelmetVisor="armor", LowCutVisor="armor",
Pantsir3="armor", SSH68="armor", ScavKingHelmet="armor",
ScavKingVest="armor", Smersh="armor", TitanShield="armor",
UNOHelmet="armor", UNOVest="armor", ZSh="armor", ZShVisor="armor",
Balaclava="armor", CamoPants="armor", CamoShirt="armor",
CivilianPants="armor", CivilianShirt="armor",
CombatGloves="armor", GhillieHood="armor", GhillieLegs="armor",
GhillieTorso="armor", GorkaPants="armor", GorkaShirt="armor",
GP5="armor", HandWraps="armor", KneePads="armor",
SewnMask="armor", SummerPants="armor", SummerShirt="armor",
WastelandPants="armor", WastelandShirt="armor",
SantaHat="armor", TankCap="armor",
Bandoiler="armor", SpecopsBackpack="armor", WastelandBackpack="armor",
ATCKey="special", AirfieldTunnelsKey="special",
Apartment13Key="special", Apartment21Key="special",
B05Key="special", CitySubstationtKey="special",
CraneKey="special", DormA211Key="special", DormB203Key="special",
EVACKey="special", FactoryGarageKey="special",
FrigateKey="special", FuelingStationKey="special",
GallerySecurityKey="special", HydroBasementKey="special",
LighthouseKey="special", PoolKey="special",
Villa1Key="special", VillageKey="special",
BlueCard="special", OrangeCard="special", RedCard="special",
GPU="special", CPU="special", HDD="special", SSD="special",
RAM="special", PSU="special", ThermalModule="special",
PDA="special", Smartphone="special", PortableConsole="special",
DAGR="special", Radio="special",
Gold50g="special", GoldSkull="special", GoldWatch="special",
GoldenTicket="special", GoldenDV2="special", GoldenMakarov="special",
RealGoldenDV2="special",
EnzoPlush="special", DozerPlush="special", AntonPlush="special",
WhisperPlush="special", CatToken="special", InflatedCrown="special",
SolterStatue="special", Matryoshka="special", WeddingRing="special",
MikeShades="special", Football="special", Teapot="special",
EstonianBorderMap="special", KeyChain="special",
SerumGreen="special", SerumPurple="special",
SerumRed="special", SerumYellow="special",
ImmunsterReactor="special",
GiftTier1="special", GiftTier2="special", GiftTier3="special",
Rubles="special",
QuadNVG="special", ONV9="special",
}

local function get_item_category(name)
if ITEM_CAT[name] then return ITEM_CAT[name] end
local lower = name:lower()
if lower:find("gun") or lower:find("rifle") or lower:find("pistol")
or lower:find("smg") or lower:find("sniper") or lower:find("shotgun") then
return "weapon"
end
if lower:find("armor") or lower:find("vest") or lower:find("helmet")
or lower:find("plate") or lower:find("visor")
or lower:find("pants") or lower:find("shirt") or lower:find("glove")
or lower:find("backpack") or lower:find("mask") or lower:find("hood")
or lower:find("ghillie") then
return "armor"
end
if lower:find("key") or lower:find("card") or lower:find("gold")
or lower:find("plush") or lower:find("serum") or lower:find("gift")
or lower:find("gpu") or lower:find("cpu") or lower:find("hdd")
or lower:find("ssd") or lower:find("ram") or lower:find("token")
or lower:find("crown") or lower:find("statue") or lower:find("ring")
or lower:find("ticket") or lower:find("intel") or lower:find("document")
or lower:find("artifact") or lower:find("diamond") or lower:find("ruby")
or lower:find("emerald") or lower:find("nvg") then
return "special"
end
return "misc"
end

local LOOT_PASS = {
[0] = { weapon=true, armor=true, special=true, misc=true },
[1] = { weapon=true, armor=true, special=true },
[2] = { weapon=true, armor=true },
[3] = { weapon=true },
}

local EXTRACT_NAMES = {
Extract = true, Extraction = true, ExitZone = true, Exit = true,
Exfiltration = true, ExfilPoint = true, ExfilZone = true,
Evac = true, EvacZone = true, Escape = true,
}


local world = {
npcs = {}, containers = {}, items = {},
corpses = {}, quests = {}, players = {},
extracts = {}, hazards = {},
cam = nil
}

local cfg = {}
local orig_light = nil
local orig_grass = nil
local panic_on = false
local silent_ok = false
local boba_menu_open = true

local function is_any_menu_open()
    if boba_menu_open then return true end
    local v_open = false
    pcall(function()
        if menu then
            if type(menu.IsOpen) == "function" and menu.IsOpen() then v_open = true
            elseif type(menu.is_open) == "function" and menu.is_open() then v_open = true
            elseif type(menu.IsVisible) == "function" and menu.IsVisible() then v_open = true
            elseif type(menu.is_visible) == "function" and menu.is_visible() then v_open = true
            end
        end
    end)
    if v_open then return true end
    pcall(function()
        if input then
            if type(input.IsCursorVisible) == "function" and input.IsCursorVisible() then v_open = true
            elseif type(input.GetCursorVisible) == "function" and input.GetCursorVisible() then v_open = true
            end
        end
    end)
    return v_open or false
end

wm_x, wm_y = 10, 10
wm_drag = false
wm_dx, wm_dy = 0, 0
inv_x, inv_y = 10, 60
inv_drag = false
inv_dx, inv_dy = 0, 0
inv_target = nil
inv_target_data = nil
local cached_heads = {}
local frame_players = {}

local world_cars = {}

local world_claymores = {}

local RADAR_POS = { x = 20, y = 100 }

local hitmarker_time = 0
local aim_target_ent = nil

local locked_target = nil
local lock_was_down = false

boss_x, boss_y = 5, 370
boss_drag, boss_dx, boss_dy = false, 0, 0
local boss_data = {}
local vehicle_data = {}
local BOSS_DEFS = {
{ zone = "Sawmill",    name = "Anton"    },
{ zone = "Factory",    name = "Dozer"    },
{ zone = "Whisper",    name = "Whisper"  },
{ zone = "Death",      name = "Death"    },
{ zone = "ScavCastle", name = "ScavKing" },
}
local VEHICLE_DEFS = {
{ name = "MI24V", label = "Mi-24V Hind" },
{ name = "BTR80", label = "BTR-80"       },
}

slf_x, slf_y = 20, 200
slf_drag, slf_dx, slf_dy = false, 0, 0
local slf_results = {}
local SLF_ITEMS = {
"GPU", "Gold50g", "SPSh44", "FlareGun", "Mag556Rnd100",
"SOCOM556", "Reapir", "HSPV", "TitanShield",
}


local detected_mods = {}
local MOD_NAMES = {
["solter"]=true,["kupczakk"]=true,["nutsock112"]=true,["thecrafter103"]=true,
["forkycheck"]=true,["necanwx"]=true,["kbhgaming480"]=true,["lumivoxi"]=true,
["natan_113"]=true,["ianeyeballs"]=true,["imblu1"]=true,["gribler1"]=true,
["e2equl"]=true,["hhauoli"]=true,["farlan9"]=true,["zondering"]=true,
["strawberry_banana0"]=true,["exp_l0"]=true,["raechevel00"]=true,["yuckey47"]=true,
["shawnybear6"]=true,["deadlymagicaz"]=true,["jannu2010"]=true,["duhacek1112"]=true,
["sparky_deeny"]=true,["aidendenkule13"]=true,["hakaji"]=true,["c7asher"]=true,
["dominik7772"]=true,["atlas_thegamer"]=true,["accldentshappen"]=true,["libertadwar"]=true,
}




local opt = {}

local function mg(id, def)
    if opt[id] ~= nil then return opt[id] end
    local ok, v = pcall(function() return menu.Get(id) end)
    if ok and v ~= nil and v ~= false then
        opt[id] = v
        return v
    end
    if def ~= nil then return def end
    return ok and v or false
end

local function mc(id, def)
    local ok, c = pcall(function() return menu.GetColor(id) end)
    if ok and c ~= nil then return c end
    if def ~= nil then return def end
    return {1, 1, 1, 1}
end

local function mk(id, def)
    local ok, k = pcall(function() return menu.GetKey(id) end)
    if ok and k ~= nil then return k end
    if def ~= nil then return def end
    return 0
end

local function get_val(id, def)
    if opt[id] ~= nil then return opt[id] end
    local v = mg(id, nil)
    if v ~= nil then
        opt[id] = v
        return v
    end
    if def ~= nil then return def end
    return v
end

local function set_val(id, val)
    opt[id] = val
    pcall(function() menu.Set(id, val) end)
    if id == "b_aim" then cfg.aim = val
    elseif id == "b_aim_key" then cfg.aim_key = val
    elseif id == "b_aim_bone" then cfg.aim_bone = val
    elseif id == "b_silent_bone" then cfg.sil_bone = val
    elseif id == "b_npc_aim_bone" then cfg.na_bone = val
    elseif id == "b_aim_fov" then cfg.aim_fov = val
    elseif id == "b_aim_smooth" then cfg.aim_sm = val
    elseif id == "b_aim_pred" then cfg.aim_pred = val
    elseif id == "b_aim_lead" then cfg.aim_lead = val
    elseif id == "b_aim_lock" then cfg.aim_lock = val
    elseif id == "b_aim_team" then cfg.aim_team = val
    elseif id == "b_aim_fov_draw" then cfg.aim_draw = val
    elseif id == "b_aim_fov_filled" then cfg.aim_fov_filled = val
    elseif id == "b_silent" then cfg.silent = val
    elseif id == "b_silent_fov" then cfg.sil_fov = val
    elseif id == "b_silent_multipoint" then cfg.sil_multi = val
    elseif id == "b_silent_team" then cfg.sil_team = val
    elseif id == "b_silent_fov_draw" then cfg.sil_draw = val
    elseif id == "b_silent_fov_filled" then cfg.sil_fov_filled = val
    elseif id == "b_npc_aim" then cfg.npc_aim = val
    elseif id == "b_npc_aim_fov" then cfg.na_fov = val
    elseif id == "b_npc_aim_smooth" then cfg.na_sm = val
    elseif id == "b_npc_aim_pred" then cfg.na_pred = val
    elseif id == "b_npc_aim_fov_draw" then cfg.na_draw = val
    elseif id == "b_npc_aim_fov_filled" then cfg.na_fov_filled = val
    elseif id == "b_esp" then cfg.esp = val
    elseif id == "b_esp_box" then cfg.esp_box = val
    elseif id == "b_esp_skel" then cfg.esp_skel = val
    elseif id == "b_esp_hp" then cfg.esp_hp = val
    elseif id == "b_esp_hp_txt" then cfg.esp_hp_t = val
    elseif id == "b_esp_name" then cfg.esp_name = val
    elseif id == "b_esp_dist" then cfg.esp_dist = val
    elseif id == "b_esp_weapon" then cfg.esp_wep = val
    elseif id == "b_esp_snap" then cfg.esp_snap = val
    elseif id == "b_esp_range" then cfg.esp_range = val
    elseif id == "b_esp_vis_tag" then cfg.esp_vis_tag = val
    elseif id == "b_chams" then cfg.chams = val
    elseif id == "b_chams_vc" then cfg.chams_vis = val
    elseif id == "b_npc" then cfg.npc = val
    elseif id == "b_npc_box" then cfg.npc_box = val
    elseif id == "b_npc_hp" then cfg.npc_hp = val
    elseif id == "b_npc_name" then cfg.npc_name = val
    elseif id == "b_npc_skel" then cfg.npc_skel = val
    elseif id == "b_npc_range" then cfg.npc_range = val
    elseif id == "b_extract" then cfg.extract = val
    elseif id == "b_extract_range" then cfg.extract_r = val
    elseif id == "b_hazard" then cfg.hazard = val
    elseif id == "b_hazard_range" then cfg.hazard_r = val
    elseif id == "b_cont" then cfg.cont = val
    elseif id == "b_menu_key" then cfg.menu_key = val
    elseif id == "b_menu_theme" then cfg.menu_theme = val
    elseif id == "b_hard_side" then cfg.hard_side = val
    elseif id == "b_rainbow_mode" then cfg.rainbow_mode = val
    end
end

local diag_queue = {}
local function log_diag(event, details)
    local ts = (os.date and os.date("%H:%M:%S")) or tostring(floor(tick()))
    local line = string.format("[%s] [%s] %s", ts, tostring(event), tostring(details))
    table.insert(diag_queue, line)
    if #diag_queue > 200 then
        table.remove(diag_queue, 1)
    end
end

local function flush_diag()
    if #diag_queue == 0 then return end
    pcall(function()
        local f = io.open("c:\\Users\\boqnp\\Desktop\\Project boba\\diag_dump.txt", "a")
        if not f then f = io.open("diag_dump.txt", "a") end
        if f then
            for i = 1, #diag_queue do
                f:write(diag_queue[i] .. "\n")
            end
            f:close()
            diag_queue = {}
        end
    end)
end

local function get_root(model)
if not model then return nil end
local r = model:FindFirstChild("HumanoidRootPart")
or model:FindFirstChild("Root")
or model:FindFirstChild("MainPart")
if r then return r end
r = model:FindFirstChildOfClass("MeshPart")
or model:FindFirstChildOfClass("Part")
or model:FindFirstChildOfClass("UnionOperation")
return r
end

local function dist3(ax, ay, az, bx, by, bz)
local dx, dy, dz = ax - bx, ay - by, az - bz
return sqrt(dx*dx + dy*dy + dz*dz)
end

local function screen_dist(ax, ay, bx, by)
local dx, dy = ax - bx, ay - by
return sqrt(dx*dx + dy*dy)
end

local function health_color(ratio)
if ratio > 0.7 then return GREEN end
if ratio > 0.35 then return {1, 0.8, 0, 1} end
return RED
end

local function is_same_team(p)
if not p.HasTeam then return false end
local lp = entity.GetLocalPlayer()
if not lp or not lp.HasTeam then return false end
return p.Team == lp.Team
end

local function get_cam_instance()
    local ws = game.Workspace
    if not ws then return nil end
    return ws.CurrentCamera or ws:FindFirstChildOfClass("Camera") or ws:FindFirstChild("Camera")
end

local function check_player_visible(cam_pos, p)
    if not p then return false end
    local is_dead = (p.IsDead == true) or (p.Health ~= nil and p.Health <= 0)
    if is_dead then return false end

    if raycast and raycast.IsPlayerVisible then
        if p.Character then
            local ok, v = pcall(raycast.IsPlayerVisible, p.Character)
            if ok and v ~= nil then return (v == true) end
        end
        if p.Address then
            local ok, v = pcall(raycast.IsPlayerVisible, p.Address)
            if ok and v ~= nil then return (v == true) end
        end
        local ok, v = pcall(raycast.IsPlayerVisible, p)
        if ok and v ~= nil then return (v == true) end
    end

    if raycast and raycast.IsVisible and cam_pos then
        local hp = p.HeadPosition
        if hp then
            local ok_vis, vis = pcall(raycast.IsVisible, cam_pos, hp)
            if ok_vis and vis then return true end
        end
        local cp = p.Position
        if cp then
            local chest = Vector3.New(cp.X, cp.Y + 0.8, cp.Z)
            local ok_vis, vis = pcall(raycast.IsVisible, cam_pos, chest)
            if ok_vis and vis then return true end
        end
    end
    return false
end

local cached_ammo_lbl = nil
local last_ammo_lbl_check = 0

local function get_local_ammo()
    local now = utility.GetTickCount()
    if not cached_ammo_lbl or (now - last_ammo_lbl_check) > 1000 then
        last_ammo_lbl_check = now
        cached_ammo_lbl = nil
        pcall(function()
            local lp = game.Players.LocalPlayer
            local pg = lp and lp:FindFirstChild("PlayerGui")
            local mg = pg and (pg:FindFirstChild("MainGui") or pg:FindFirstChild("NoInsetGui"))
            local mf = mg and mg:FindFirstChild("MainFrame")
            local inf = mf and mf:FindFirstChild("InteractionFrame")
            local eq = inf and inf:FindFirstChild("EquippedItem")
            local fr = eq and eq:FindFirstChild("Frame")
            cached_ammo_lbl = fr and fr:FindFirstChild("Ammo")
        end)
    end
    if cached_ammo_lbl then
        local ok, txt = pcall(function() return cached_ammo_lbl.Text end)
        if ok and txt then
            local cur = txt:match("^(%d+)")
            if cur then return tonumber(cur) end
        end
    end
    return nil
end


local CFG_IDS = {
"b_esp","b_esp_style","b_esp_box","b_esp_skel","b_esp_hp","b_esp_hp_txt",
"b_esp_name","b_esp_dist","b_esp_weapon","b_esp_snap","b_esp_range","b_esp_team",
"b_esp_staff","b_esp_armor","b_esp_hvt","b_esp_vis_tag",
"b_chams","b_chams_mode","b_chams_vc","b_wep_chams","b_wep_chams_style","b_wep_chams_pulse",
"b_npc","b_npc_box","b_npc_hp","b_npc_name","b_npc_dist","b_npc_skel","b_npc_range",
"b_cont","b_cont_items","b_cont_range",
"b_loot","b_loot_range","b_loot_filter",
"b_corpse","b_corpse_items","b_corpse_range",
"b_quest","b_quest_range",
"b_extract","b_extract_range","b_hazard","b_hazard_range",
"b_nograss",
"b_aim","b_aim_key","b_aim_fov","b_aim_smooth","b_aim_bone","b_aim_vis_text","b_aim_pred",
"b_aim_lead","b_aim_lock",
"b_aim_vis","b_aim_team","b_aim_fov_draw","b_aim_fov_filled",
"b_silent","b_silent_bone","b_silent_vis_text","b_silent_multipoint","b_silent_fov","b_silent_vis","b_silent_team","b_silent_fov_draw","b_silent_fov_filled",
"b_npc_aim","b_npc_aim_bone","b_npc_aim_fov","b_npc_aim_smooth","b_npc_aim_bone",
"b_npc_aim_pred","b_npc_aim_fov_draw","b_npc_aim_fov_filled",
"b_wm","b_cross","b_cross_style","b_cross_sz","b_cross_gap","b_cross_thick","b_cross_spin","b_cross_spin_spd","b_cross_pulse","b_cross_pulse_spd","b_inspect",
"b_inv_weap","b_inv_armor","b_inv_special","b_inv_misc",
"b_claymore","b_claymore_names","b_claymore_range",
"b_car","b_car_range",
"b_radar","b_radar_sz","b_radar_range","b_radar_rot",
"b_hitmarker","b_corpse_x",
"b_boss","b_slf","b_mod_alert","b_mod_mode",
"b_skin_enable","b_skin_knife","b_skin_gun","b_skin_armor",
"b_fov_changer","b_fov_val","b_fov_ads_safe",
"b_menu_key","b_menu_theme","b_hard_side","b_rainbow_mode"
}

local COLOR_IDS = {
"b_esp_box","b_esp_skel","b_esp_name","b_esp_snap","b_esp_staff","b_esp_hvt",
"b_chams_vis","b_chams_occ","b_wep_chams",
"b_npc_box","b_npc_name","b_npc_skel",
"b_cont","b_loot","b_corpse","b_quest","b_extract","b_hazard",
"b_cross","b_inspect","b_claymore","b_car","b_corpse_x",
"b_aim_fov","b_silent_fov","b_npc_aim_fov"
}

local function get_cfg_folder()
local ad = os.getenv("LOCALAPPDATA")
if ad then return ad .. "/Project Vector/Scripts/" end
return ""
end

local function get_cfg_path(name)
    name = (name and name ~= "") and name or "default"
    local folder = get_cfg_folder()
    local path = folder .. "boba_config_" .. name .. ".txt"
    if name == "default" then
        local f = io.open(path, "r")
        if f then f:close(); return path end
        local alt = folder .. "boba_config.txt"
        local f2 = io.open(alt, "r")
        if f2 then f2:close(); return alt end
        local alt3 = folder .. "boba_config_boba.txt"
        local f3 = io.open(alt3, "r")
        if f3 then f3:close(); return alt3 end
    end
    return path
end

local function get_cfg_list_path()
return get_cfg_folder() .. "boba_config_list.txt"
end

local function get_active_cfg_path()
return get_cfg_folder() .. "boba_active_cfg.txt"
end

local function read_active_cfg()
local f = io.open(get_active_cfg_path(), "r")
if f then
    local n = f:read("*l")
    f:close()
    if n and n:match("^%s*(.-)%s*$") ~= "" then
        return n:match("^%s*(.-)%s*$")
    end
end
local lf = io.open(get_cfg_list_path(), "r")
if lf then
    for line in lf:lines() do
        local n = line:match("^%s*(.-)%s*$")
        if n and n ~= "" then
            lf:close()
            return n
        end
    end
    lf:close()
end
return "default"
end

local function write_active_cfg(name)
local f = io.open(get_active_cfg_path(), "w")
if f then
    f:write(tostring(name) .. string.char(10))
    f:close()
end
end

local function read_config_list()
local list = {}
local f = io.open(get_cfg_list_path(), "r")
if f then
    for line in f:lines() do
        local n = line:match("^%s*(.-)%s*$")
        if n and n ~= "" then
            table.insert(list, n)
        end
    end
    f:close()
end
if #list == 0 then
    list = {"default"}
end
return list
end

local function write_config_list(list)
local f = io.open(get_cfg_list_path(), "w")
if f then
    for _, n in ipairs(list) do
        f:write(n .. string.char(10))
    end
    f:close()
end
end

save_config = function(name)
name = (name and name ~= "") and name or "default"
local ok, err = pcall(function()
local primary_path = get_cfg_path(name)
local f = io.open(primary_path, "w")
if not f then
    local folder = get_cfg_folder()
    primary_path = folder .. "boba_config_" .. name .. ".txt"
    f = io.open(primary_path, "w")
end
if not f then
    notify.Error("Save failed", "Cannot open " .. name)
    return
end
for _, id in ipairs(CFG_IDS) do
    local v = get_val(id)
    if v == nil then v = mg(id) end
    if type(v) == "boolean" then
        f:write(id .. "=" .. (v and "1" or "0") .. string.char(10))
    elseif type(v) == "number" then
        f:write(id .. "=" .. tostring(v) .. string.char(10))
    end
end
for _, id in ipairs(COLOR_IDS) do
    local c = mc(id)
    if c then
        f:write(id .. "_c=" .. format("%.4f,%.4f,%.4f,%.4f",
            c[1] or 1, c[2] or 1, c[3] or 1, c[4] or 1) .. string.char(10))
    end
end
f:flush()
f:close()

if name == "default" then
    local alt_f = io.open(get_cfg_folder() .. "boba_config.txt", "w")
    if alt_f then
        for _, id in ipairs(CFG_IDS) do
            local v = get_val(id)
            if v == nil then v = mg(id) end
            if type(v) == "boolean" then
                alt_f:write(id .. "=" .. (v and "1" or "0") .. string.char(10))
            elseif type(v) == "number" then
                alt_f:write(id .. "=" .. tostring(v) .. string.char(10))
            end
        end
        for _, id in ipairs(COLOR_IDS) do
            local c = mc(id)
            if c then
                alt_f:write(id .. "_c=" .. format("%.4f,%.4f,%.4f,%.4f",
                    c[1] or 1, c[2] or 1, c[3] or 1, c[4] or 1) .. string.char(10))
            end
        end
        alt_f:flush()
        alt_f:close()
    end
end

write_active_cfg(name)
notify.Success("Config saved", name)
end)
if not ok then notify.Error("Save failed", tostring(err)) end
end

load_config = function(name)
name = (name and name ~= "") and name or "default"
local ok, err = pcall(function()
local f = io.open(get_cfg_path(name), "r")
if not f and name == "default" then
    local folder = get_cfg_folder()
    f = io.open(folder .. "boba_config.txt", "r") or io.open(folder .. "boba_config_boba.txt", "r")
end
if not f then
    if name ~= "default" then
        notify.Warning("Config not found", name)
    end
    return
end
local data = {}
for line in f:lines() do
    local k, v = line:match("^([^=]+)=(.*)$")
    if k and v then data[k] = v end
end
f:close()
for _, id in ipairs(CFG_IDS) do
    if data[id] then
        local v = data[id]
        local actual_val
        if id == "b_fov_changer" then
            actual_val = true
        elseif v == "0" or v == "1" then
            actual_val = (v == "1")
        else
            local n = tonumber(v)
            if n then actual_val = n end
        end
        if actual_val ~= nil then
            set_val(id, actual_val)
        end
    end
end
set_val("b_fov_changer", true)
for _, id in ipairs(COLOR_IDS) do
    local cv = data[id .. "_c"]
    if cv then
        local r,g,b,a = cv:match("([%d%.%-]+),([%d%.%-]+),([%d%.%-]+),([%d%.%-]+)")
        if r and g and b then
            local nr = tonumber(r) or 1
            local ng = tonumber(g) or 1
            local nb = tonumber(b) or 1
            local na = tonumber(a) or 1
            if nr < 0.12 and ng < 0.12 and nb < 0.12 then
                nr, ng, nb = 0.85, 0.85, 0.85
            end
            if na < 0.5 then na = 1.0 end
            local c_arr = {nr, ng, nb, na}
            pcall(function()
                menu.SetColor(id, c_arr)
            end)
            if id == "b_chams_vis" then cfg.chams_vc = c_arr
            elseif id == "b_chams_occ" then cfg.chams_oc = c_arr
            elseif id == "b_esp_box" then cfg.esp_box_c = c_arr
            elseif id == "b_esp_name" then cfg.esp_name_c = c_arr
            elseif id == "b_esp_skel" then cfg.esp_skel_c = c_arr
            elseif id == "b_esp_snap" then cfg.esp_snap_c = c_arr
            elseif id == "b_npc_box" then cfg.npc_box_c = c_arr
            elseif id == "b_npc_name" then cfg.npc_name_c = c_arr
            end
        end
    end
end
write_active_cfg(name)
notify.Success("Config loaded", name)
end)
if not ok then notify.Error("Load failed", tostring(err)) end
end


local function get_inventory(model)
local inv = model:FindFirstChild("Inventory")
if not inv then return nil end
local ch = inv:GetChildren()
if #ch == 0 then return nil end
local counts = {}
for i = 1, #ch do
local n = ch[i].Name
if n ~= "" then counts[n] = (counts[n] or 0) + 1 end
end
local out = {}
for n, c in pairs(counts) do
out[#out+1] = c > 1 and (n .. " x" .. c) or n
end
return #out > 0 and out or nil
end

local CONTAINER_NAMES = {
SportBag = true, LargeMilitaryBox = true, MedBag = true,
MilitaryCrate = true, CashRegister = true, ModificationStation = true,
SmallMilitaryBox = true, WoodenCrate = true, Toolbox = true,
MedicalCabinet = true, Locker = true, FileCabinet = true, FilingCabinet = true,
Safe = true, HiddenCache = true, PC = true, SerumContainer = true,
GrenadeCrate = true, LargeABPOPABox = true, SmallShippingCrate = true,
}

local function scan_containers()
local result = {}
local ws = game.Workspace
if not ws then world.containers = result; return end

local seen = {}
local function check_container(m)
    if not m or seen[m] then return end
    if m.ClassName == "Model" and (CONTAINER_NAMES[m.Name] or m:FindFirstChild("Inventory")) then
        local inv = m:FindFirstChild("Inventory")
        if inv and inv.ClassName == "Folder" then
            local part = get_root(m)
            if part then
                seen[m] = true
                result[#result+1] = {
                    name = m.Name,
                    part = part,
                    contents = get_inventory(m)
                }
            end
        end
    end
end

local cont_folder = ws:FindFirstChild("Containers") or ws:FindFirstChild("LootContainers")
if cont_folder then
    local cch = cont_folder:GetChildren()
    for i = 1, #cch do check_container(cch[i]) end
end
world.containers = result
end

local function scan_npcs()
    local result = {}
    local ws = game.Workspace
    if not ws then world.npcs = result; return end

    local pnames = {}
    local p_chars = {}
    for _, p in ipairs(entity.GetPlayers()) do
        if p.Name and p.Name ~= "" then pnames[p.Name] = true end
        if p.Character then p_chars[p.Character] = true end
    end
    local lp = entity.GetLocalPlayer()
    if lp and lp.Name and lp.Name ~= "" then pnames[lp.Name] = true end
    local rbx_lp = nil
    pcall(function() rbx_lp = game.Players.LocalPlayer end)
    if rbx_lp and rbx_lp.Name and rbx_lp.Name ~= "" then pnames[rbx_lp.Name] = true end
    local lp_char = (lp and lp.Character) or (rbx_lp and rbx_lp.Character)
    if lp_char then p_chars[lp_char] = true end

    local cam = camera.GetPosition()
    local cx, cy, cz = cam and cam.X or 0, cam and cam.Y or 0, cam and cam.Z or 0

    local function is_player_model(npc)
        if not npc then return true end
        if p_chars[npc] then return true end
        if pnames[npc.Name] then return true end
        local rbx_plr = false
        pcall(function()
            if game.Players and game.Players.GetPlayerFromCharacter then
                if game.Players:GetPlayerFromCharacter(npc) then
                    rbx_plr = true
                end
            end
        end)
        return rbx_plr
    end

    local function process(npc)
        if not npc or npc.ClassName ~= "Model" then return end
        if CONTAINER_NAMES and CONTAINER_NAMES[npc.Name] then return end
        local hum = npc:FindFirstChildOfClass("Humanoid")
        if not hum then return end
        local hp = hum.Health
        if not hp or hp <= 0 then return end
        if is_player_model(npc) then return end
        local head = npc:FindFirstChild("Head") or npc:FindFirstChild("HeadTopHitBox")
        local root = npc:FindFirstChild("HumanoidRootPart") or npc:FindFirstChild("Torso") or head
        if not head and not root then return end
        local h_part = head or root
        local hpos = h_part and h_part.Position
        if hpos and cam then
            local d = dist3(hpos.X, hpos.Y, hpos.Z, cx, cy, cz)
            if d < 6 then return end
        end
        local parts = {}
        local ch = npc:GetChildren()
        for k = 1, #ch do
            local p = ch[k]
            if p:IsA("BasePart") then parts[p.Name] = { part = p } end
        end
        result[#result+1] = {
            name = npc.Name, model = npc,
            hum = hum, head = head or root, parts = parts
        }
    end

    local function walk(folder)
        if not folder then return end
        local ch = folder:GetChildren()
        for i = 1, #ch do
            local c = ch[i]
            if c.ClassName == "Folder" then walk(c)
            elseif c.ClassName == "Model" then process(c) end
        end
    end

    local zones = { "AiZones", "AIZones", "NPCs", "AI", "Enemies", "SpawnerZones", "SafeZone", "Safezone", "Traders", "Trader", "Characters", "Living" }
    for zi = 1, #zones do
        local z = ws:FindFirstChild(zones[zi])
        if z then walk(z) end
    end

    local direct_traders = { "Nurse", "Seryozha", "Anna", "Blaze", "Tarmo", "Bartender", "Mechanic", "Doctor", "Medic", "Trader", "ScavKing", "Anton", "Dozer", "Whisper", "Death" }
    for ti = 1, #direct_traders do
        local m = ws:FindFirstChild(direct_traders[ti])
        if m and m.ClassName == "Model" then process(m) end
    end

    world.npcs = result
end

local function scan_world_items()
local ws = game.Workspace
if not ws then
world.items = {}; world.corpses = {}; return
end
local drops = ws:FindFirstChild("DroppedItems")
or ws:FindFirstChild("RuntimeItems")
or ws:FindFirstChild("Drops")
if not drops then
world.items = {}; world.corpses = {}; return
end
local items_r, corpses_r = {}, {}
local function proc(m)
if m.ClassName ~= "Model" or m.Name == "" then return end
local part = get_root(m)
if not part then return end
local hum = m:FindFirstChildOfClass("Humanoid")
if hum and hum.Health and hum.Health <= 0 then
    corpses_r[#corpses_r+1] = {
        name = m.Name, part = part,
        contents = get_inventory(m)
    }
else
    items_r[#items_r+1] = { name = m.Name, part = part }
end
end
local ch = drops:GetChildren()
for i = 1, #ch do
if ch[i].ClassName == "Folder" then
    local sub = ch[i]:GetChildren()
    for j = 1, #sub do proc(sub[j]) end
else proc(ch[i]) end
end
world.items = items_r
world.corpses = corpses_r
end

local function scan_quests()
local ws = game.Workspace
if not ws then world.quests = {}; return end
local src = ws:FindFirstChild("QuestItems")
if not src then world.quests = {}; return end
local result = {}
local ch = src:GetChildren()
for i = 1, #ch do
local c = ch[i]
if c.ClassName == "Model" and c.Name ~= "" then
    local part = get_root(c)
    if part then
        result[#result+1] = { name = c.Name, part = part }
    end
end
end
world.quests = result
end

local function scan_players()
local result = {}
local players = entity.GetPlayers()
if not players then world.players = result; return end
local rep = game.ReplicatedStorage
local rep_p = rep and rep:FindFirstChild("Players")
for i = 1, #players do
local p = players[i]
if p and p.IsValid and p.IsAlive then
    local pname = p.Name or ""
    local inv = {}
    local equipped = nil
    if rep_p then
        local data = rep_p:FindFirstChild(pname)
        if data then
            local inv_f = data:FindFirstChild("Inventory")
            if inv_f then
                local ch = inv_f:GetChildren()
                for j = 1, #ch do
                    if ch[j].Name ~= "" then
                        inv[#inv+1] = ch[j].Name
                    end
                end
            end
            local st = data:FindFirstChild("Status")
            if st then
                local gv = st:FindFirstChild("GameplayVariables")
                if gv then
                    local eq = gv:FindFirstChild("EquippedTool")
                    if eq and eq.Value then
                        local v = eq.Value
                        if type(v) == "string" and v ~= "" then
                            equipped = v
                        elseif type(v) == "userdata" then
                            equipped = v.Name
                        end
                    end
                end
            end
        end
    end
    local head_ref = nil
    local helmet = nil
    local vest = nil
    local hvt = nil
    local char = p.Character
    if char then
        head_ref = char:FindFirstChild("Head")
        local clothing = char:FindFirstChild("Clothing")
        if clothing then
            local hw = clothing:FindFirstChild("ClothingHeadware")
            if hw and hw.Value and hw.Value ~= "" then
                helmet = tostring(hw.Value)
            end
            local cr = clothing:FindFirstChild("ClothingChestRig")
            if cr and cr.Value and cr.Value ~= "" then
                vest = tostring(cr.Value)
            end
        end
    end
    local HVT_KEYS = {
        RedCard = true, EVACKey = true, FactoryGarageKey = true,
        LighthouseKey = true, DormA211Key = true, DormB203Key = true,
        FrigateKey = true, GoldBar = true
    }
    for j = 1, #inv do
        if HVT_KEYS[inv[j]] then
            hvt = inv[j]
            break
        end
    end
    result[#result+1] = {
        name = pname,
        display = p.DisplayName or pname,
        entity = p, inventory = inv, equipped = equipped,
        head = head_ref, helmet = helmet, vest = vest, hvt = hvt
    }
end
end
local heads = {}
for i = 1, #result do
local r = result[i]
if r.head then heads[r.name] = r.head end
end
cached_heads = heads
world.players = result
end

local function scan_extracts()
if world.extracts and #world.extracts > 0 then return end
local result = {}
local ws = game.Workspace
if not ws then world.extracts = result; return end

local seen = {}
local function try_add(obj)
    if not obj or seen[obj] then return end
    seen[obj] = true
    local part
    if obj:IsA("BasePart") then
        part = obj
    elseif obj.ClassName == "Model" then
        part = get_root(obj)
    end
    if part then
        result[#result+1] = { name = obj.Name, part = part }
    end
end

local function name_is_extract(n)
    local lo = n:lower()
    return lo:find("extract") or lo:find("exfil") or lo:find("exit")
        or lo:find("evac") or lo:find("escape")
end

local nocoll = ws:FindFirstChild("NoCollision")
if nocoll then
    local exits = nocoll:FindFirstChild("ExitLocations")
    if exits then
        local ech = exits:GetChildren()
        for i = 1, #ech do try_add(ech[i]) end
    end
end

local search_parents = {
    "ExitLocations", "Extracts", "Extraction", "ExitZones", "Exits", "Exfil",
    "ExtractionPoints", "ExfilPoints", "Extractions"
}
for _, fname in ipairs(search_parents) do
    local folder = ws:FindFirstChild(fname)
    if folder then
        local ch = folder:GetChildren()
        for i = 1, #ch do try_add(ch[i]) end
    end
end

local map = ws:FindFirstChild("Map") or ws:FindFirstChild("map")
if map then
    for _, fname in ipairs(search_parents) do
        local folder = map:FindFirstChild(fname)
        if folder then
            local ch = folder:GetChildren()
            for i = 1, #ch do try_add(ch[i]) end
        end
    end
    local mch = map:GetChildren()
    for i = 1, #mch do
        if name_is_extract(mch[i].Name) then
            try_add(mch[i])
        end
    end
end

world.extracts = result
end

local function scan_hazards()
local result = {}
local ws = game.Workspace
if not ws then world.hazards = result; return end
local nocoll = ws:FindFirstChild("NoCollision")
if nocoll then
    local rad = nocoll:FindFirstChild("RadiationZones")
    if rad then
        local ch = rad:GetChildren()
        for i = 1, #ch do
            local part = get_root(ch[i]) or (ch[i]:IsA("BasePart") and ch[i])
            if part then
                result[#result+1] = { name = "Radiation Zone", part = part, type = "rad" }
            end
        end
    end
    local fire = nocoll:FindFirstChild("FireZones")
    if fire then
        local ch = fire:GetChildren()
        for i = 1, #ch do
            local part = get_root(ch[i]) or (ch[i]:IsA("BasePart") and ch[i])
            if part then
                result[#result+1] = { name = "Fire Zone", part = part, type = "fire" }
            end
        end
    end
end
world.hazards = result
end


local cfg_last_update = 0
local function cache_cfg()
local now = utility.GetTickCount()
if (now - cfg_last_update) < 200 then return end
cfg_last_update = now

cfg.esp       = mg("b_esp")
cfg.esp_style = mg("b_esp_style")
cfg.esp_box   = mg("b_esp_box")
cfg.esp_box_c = mc("b_esp_box")
cfg.esp_skel  = mg("b_esp_skel")
cfg.esp_skel_c= mc("b_esp_skel")
cfg.esp_hp    = mg("b_esp_hp")
cfg.esp_hp_t  = mg("b_esp_hp_txt")
cfg.esp_name  = mg("b_esp_name")
cfg.esp_name_c= mc("b_esp_name")
cfg.esp_dist  = mg("b_esp_dist")
cfg.esp_wep   = mg("b_esp_weapon")
cfg.esp_snap  = mg("b_esp_snap")
cfg.esp_snap_c= mc("b_esp_snap")
cfg.esp_range = mg("b_esp_range")
cfg.esp_team  = mg("b_esp_team")
cfg.esp_armor = mg("b_esp_armor")
cfg.esp_hvt   = mg("b_esp_hvt")
cfg.esp_hvt_c = mc("b_esp_hvt")
cfg.esp_vis_tag = mg("b_esp_vis_tag")

cfg.chams     = mg("b_chams")
cfg.chams_m   = mg("b_chams_mode") or 0
cfg.chams_vc  = mc("b_chams_vis")
cfg.chams_oc  = mc("b_chams_occ")
cfg.chams_vis = mg("b_chams_vc")
cfg.wep_chams = mg("b_wep_chams")
cfg.wep_chams_c = mc("b_wep_chams")
cfg.wep_chams_style = mg("b_wep_chams_style") or 0
cfg.wep_chams_pulse = mg("b_wep_chams_pulse")

cfg.npc       = mg("b_npc")
cfg.npc_box   = mg("b_npc_box")
cfg.npc_box_c = mc("b_npc_box")
cfg.npc_hp    = mg("b_npc_hp")
cfg.npc_name  = mg("b_npc_name")
cfg.npc_name_c= mc("b_npc_name")
cfg.npc_dist  = mg("b_npc_dist")
cfg.npc_skel  = mg("b_npc_skel")
cfg.npc_skel_c= mc("b_npc_skel")
cfg.npc_range = mg("b_npc_range")

cfg.cont      = mg("b_cont")
cfg.cont_c    = mc("b_cont")
cfg.cont_items= mg("b_cont_items")
cfg.cont_range= mg("b_cont_range")
cfg.loot      = mg("b_loot")
cfg.loot_c    = mc("b_loot")
cfg.loot_range= mg("b_loot_range")
cfg.corpse    = mg("b_corpse")
cfg.corpse_c  = mc("b_corpse")
cfg.corpse_i  = mg("b_corpse_items")
cfg.corpse_r  = mg("b_corpse_range")
cfg.quest     = mg("b_quest")
cfg.quest_c   = mc("b_quest")
cfg.quest_r   = mg("b_quest_range")

cfg.aim       = get_val("b_aim", false)
cfg.aim_key   = get_val("b_aim_key", 0)
cfg.aim_fov   = get_val("b_aim_fov", 150)
cfg.aim_sm    = get_val("b_aim_smooth", 5.0)
cfg.aim_bone  = get_val("b_aim_bone", 0)
cfg.aim_vis_txt = mg("b_aim_vis_text")
cfg.aim_pred  = mg("b_aim_pred")
cfg.aim_pred_scale = 1.0
cfg.aim_lead  = mg("b_aim_lead")
cfg.aim_lock  = mg("b_aim_lock")
cfg.aim_vis   = mg("b_aim_vis")
cfg.aim_team  = mg("b_aim_team")
cfg.aim_draw  = mg("b_aim_fov_draw")
cfg.aim_fov_filled = mg("b_aim_fov_filled")
cfg.aim_fov_c = mc("b_aim_fov")

cfg.silent    = get_val("b_silent", false)
cfg.sil_bone  = get_val("b_silent_bone", 0)
cfg.sil_vis_txt = false
cfg.sil_multi = get_val("b_silent_multipoint", true)
cfg.sil_fov   = get_val("b_silent_fov", 200)
cfg.sil_vis   = mg("b_silent_vis")
cfg.sil_team  = mg("b_silent_team")
cfg.sil_draw  = mg("b_silent_fov_draw")
cfg.sil_fov_filled = mg("b_silent_fov_filled")
cfg.sil_fov_c = mc("b_silent_fov")

cfg.npc_aim   = mg("b_npc_aim")
cfg.na_fov    = mg("b_npc_aim_fov")
cfg.na_sm     = mg("b_npc_aim_smooth")
cfg.na_bone   = mg("b_npc_aim_bone")
cfg.na_pred   = mg("b_npc_aim_pred")
cfg.na_draw   = mg("b_npc_aim_fov_draw")
cfg.na_fov_filled = mg("b_npc_aim_fov_filled")
cfg.na_fov_c = mc("b_npc_aim_fov")

cfg.wm        = mg("b_wm")
cfg.cross     = mg("b_cross")
cfg.cross_c   = mc("b_cross")
cfg.cross_style = mg("b_cross_style") or 0
cfg.cross_sz  = mg("b_cross_sz") or 8
cfg.cross_gap = mg("b_cross_gap") or 3
cfg.cross_thick = mg("b_cross_thick") or 2
cfg.cross_spin = mg("b_cross_spin")
cfg.cross_spin_spd = mg("b_cross_spin_spd") or 5
cfg.cross_pulse = mg("b_cross_pulse")
cfg.cross_pulse_spd = mg("b_cross_pulse_spd") or 4
cfg.inspect   = mg("b_inspect")
cfg.insp_c    = mc("b_inspect")

cfg.esp_staff = mg("b_esp_staff")
cfg.esp_staff_c = mc("b_esp_staff")

cfg.extract   = mg("b_extract")
cfg.extract_c = mc("b_extract")
cfg.extract_r = mg("b_extract_range")
cfg.hazard    = mg("b_hazard")
cfg.hazard_c  = mc("b_hazard")
cfg.hazard_r  = mg("b_hazard_range")

cfg.loot_f    = mg("b_loot_filter")

cfg.nograss   = mg("b_nograss")

cfg.claymore  = mg("b_claymore")
cfg.clay_c    = mc("b_claymore")
cfg.clay_names= mg("b_claymore_names")
cfg.clay_r    = mg("b_claymore_range")

cfg.car       = mg("b_car")
cfg.car_c     = mc("b_car")
cfg.car_r     = mg("b_car_range")

cfg.radar     = mg("b_radar")
cfg.radar_sz  = mg("b_radar_sz")
cfg.radar_range = mg("b_radar_range")
cfg.radar_rot = mg("b_radar_rot")

cfg.hitmarker = mg("b_hitmarker")
cfg.corpse_x  = mg("b_corpse_x")
cfg.corpse_xc = mc("b_corpse_x")

cfg.boss      = mg("b_boss")
cfg.slf       = mg("b_slf")
cfg.mod_alert = mg("b_mod_alert")
cfg.mod_mode  = mg("b_mod_mode")

cfg.skin_enable = mg("b_skin_enable")
cfg.skin_knife = mg("b_skin_knife") or 0
cfg.skin_gun  = mg("b_skin_gun") or 0
cfg.skin_armor = mg("b_skin_armor") or 0
cfg.fov_changer = mg("b_fov_changer")
cfg.fov_val     = mg("b_fov_val") or 90
cfg.fov_ads_safe= mg("b_fov_ads_safe")

cfg.inv_weap  = mg("b_inv_weap")
cfg.inv_armor = mg("b_inv_armor")
cfg.inv_special = mg("b_inv_special")
cfg.inv_misc  = mg("b_inv_misc")

end


local player_bounds_cache = {}

local function draw_esp_box(x, y, w, h, col)
    local c = col or {1, 1, 1, 1}
    local ix, iy, iw, ih = math.floor(x), math.floor(y), math.floor(w), math.floor(h)
    draw.Line(ix - 1, iy - 1, ix + iw + 1, iy - 1, {0, 0, 0, 0.95}, 1)
    draw.Line(ix - 1, iy + ih + 1, ix + iw + 1, iy + ih + 1, {0, 0, 0, 0.95}, 1)
    draw.Line(ix - 1, iy - 1, ix - 1, iy + ih + 1, {0, 0, 0, 0.95}, 1)
    draw.Line(ix + iw + 1, iy - 1, ix + iw + 1, iy + ih + 1, {0, 0, 0, 0.95}, 1)

    draw.Line(ix, iy, ix + iw, iy, c, 1.5)
    draw.Line(ix, iy + ih, ix + iw, iy + ih, c, 1.5)
    draw.Line(ix, iy, ix, iy + ih, c, 1.5)
    draw.Line(ix + iw, iy, ix + iw, iy + ih, c, 1.5)

    if iw > 6 and ih > 6 then
        draw.Line(ix + 1, iy + 1, ix + iw - 1, iy + 1, {0, 0, 0, 0.95}, 1)
        draw.Line(ix + 1, iy + ih - 1, ix + iw - 1, iy + ih - 1, {0, 0, 0, 0.95}, 1)
        draw.Line(ix + 1, iy + 1, ix + 1, iy + ih - 1, {0, 0, 0, 0.95}, 1)
        draw.Line(ix + iw - 1, iy + 1, ix + iw - 1, iy + ih - 1, {0, 0, 0, 0.95}, 1)
    end
end

local function draw_corner_box(x, y, w, h, col)
    local c = col or {1, 1, 1, 1}
    local ix, iy, iw, ih = math.floor(x), math.floor(y), math.floor(w), math.floor(h)
    local cw = math.max(4, math.floor(iw * 0.25))
    local ch = math.max(4, math.floor(ih * 0.20))
    local function cseg(x1, y1, x2, y2)
        draw.Line(x1, y1, x2, y2, {0, 0, 0, 0.95}, 2.5)
        draw.Line(x1, y1, x2, y2, c, 1.0)
    end
    cseg(ix, iy, ix + cw, iy)
    cseg(ix, iy, ix, iy + ch)
    cseg(ix + iw, iy, ix + iw - cw, iy)
    cseg(ix + iw, iy, ix + iw, iy + ch)
    cseg(ix, iy + ih, ix + cw, iy + ih)
    cseg(ix, iy + ih, ix, iy + ih - ch)
    cseg(ix + iw, iy + ih, ix + iw - cw, iy + ih)
    cseg(ix + iw, iy + ih, ix + iw, iy + ih - ch)
end

local function draw_health_bar(x, y, h, hp, max_hp)
    local mhp = max_hp
    if not mhp or mhp <= 0 then mhp = 100 end
    local cur_hp = math.max(0, math.min(mhp, hp or 0))
    local ratio = cur_hp / mhp
    local bar_w = 3
    draw.RectFilled(x - 1, y - 1, bar_w + 2, h + 2, {0, 0, 0, 0.85}, 0)
    local fill_h = math.max(1, math.floor(h * ratio))
    local col = health_color(ratio)
    draw.RectFilled(x, y + (h - fill_h), bar_w, fill_h, col, 0)
end

draw.CornerBox = draw_corner_box
draw.Box = function(x, y, w, h, col) draw_esp_box(x, y, w, h, col) end
draw.HealthBar = draw_health_bar

local function draw_player_esp()
if not cfg.esp then return end
local players = frame_players
if not players or #players == 0 then return end
local scx, scy = input.GetScreenCenter()
local range_studs = cfg.esp_range * STUDS_PER_M

local p_data_map = {}
for wi = 1, #world.players do
    local wp = world.players[wi]
    if wp.name then
        p_data_map[wp.name] = wp
    end
end

for i = 1, #players do
    local p = players[i]
    if p then
        local lp = entity.GetLocalPlayer()
        local rbx_lp = nil
        pcall(function() rbx_lp = game.Players.LocalPlayer end)
        local is_me = p.IsLocal or (lp and (p == lp or p.UserId == lp.UserId or p.Name == lp.Name or (p.Address and lp.Address and p.Address == lp.Address)))
        if not is_me and rbx_lp then
            if (rbx_lp.UserId and p.UserId == rbx_lp.UserId) or (rbx_lp.Name and p.Name == rbx_lp.Name) or (p.Character and rbx_lp.Character and p.Character == rbx_lp.Character) then
                is_me = true
            end
        end
        local d_chk = p:DistanceTo()
        if not is_me and d_chk and d_chk < 3 then is_me = true end
        if is_me or not p.IsValid or not p.IsAlive then goto cont end
        if cfg.esp_team and is_same_team(p) then goto cont end

        local is_staff = false
        if cfg.esp_staff and STAFF_IDS[p.UserId] then
            is_staff = true
            if not staff_warned[p.UserId] then
                staff_warned[p.UserId] = true
                notify.Warning("STAFF DETECTED", (p.DisplayName or p.Name), 10)
            end
        end

        local pid = p.UserId or p.Name
        if not p.IsAlive or (p.Health and p.Health <= 0) then
            player_bounds_cache[pid] = nil
            goto cont
        end

        local dist_studs = p:DistanceTo()
        if not dist_studs or dist_studs > range_studs then
            player_bounds_cache[pid] = nil
            goto cont
        end

        local b = p:GetBounds()
        if not b or not b.valid or not b.w or b.w <= 0 or not b.h or b.h <= 0 then
            b = nil
            local bones = p:GetBonesScreen()
            if bones and bones["Head"] then
                local h_pt = bones["Head"]
                local lf_pt = bones["LeftFoot"]
                local rf_pt = bones["RightFoot"]
                local ut_pt = bones["UpperTorso"]
                local top_y = h_pt[2] - 8
                local bot_y = top_y + 30
                if lf_pt and rf_pt then
                    bot_y = max(lf_pt[2], rf_pt[2]) + 4
                elseif lf_pt then
                    bot_y = lf_pt[2] + 4
                elseif rf_pt then
                    bot_y = rf_pt[2] + 4
                elseif ut_pt then
                    bot_y = ut_pt[2] + (ut_pt[2] - top_y) * 2.2
                end
                local bh = max(16, bot_y - top_y)
                local bw = bh * 0.55
                local bx = h_pt[1] - bw * 0.5
                b = { x = bx, y = top_y, w = bw, h = bh, valid = true }
            end
        end

        if not b or not b.valid or not b.w or b.w <= 0 or not b.h or b.h <= 0 then
            b = nil
            local hp = p.HeadPosition
            local rp = p.Position
            if hp and rp then
                local hx, hy, hvis = utility.WorldToScreen(hp.X, hp.Y + 0.9, hp.Z)
                local fx, fy, fvis = utility.WorldToScreen(rp.X, rp.Y - 2.8, rp.Z)
                if hvis or fvis then
                    local bh = max(16, abs(fy - hy))
                    local bw = bh * 0.55
                    local bx = hx - bw * 0.5
                    local by = min(hy, fy)
                    b = { x = bx, y = by, w = bw, h = bh, valid = true }
                end
            elseif rp then
                local sx, sy, svis = utility.WorldToScreen(rp.X, rp.Y, rp.Z)
                if svis then
                    local dist = p:DistanceTo() or 50
                    local scale = math.max(10, 1200 / (dist + 1))
                    local bh = scale * 5.0
                    local bw = scale * 2.5
                    local bx = sx - bw * 0.5
                    local by = sy - scale * 0.8
                    b = { x = bx, y = by, w = bw, h = bh, valid = true }
                end
            end
        end

        local now = utility.GetTime and utility.GetTime() or tick()
        if b and b.valid then
            player_bounds_cache[pid] = { x = b.x, y = b.y, w = b.w, h = b.h, pos = p.Position, t = now, valid = true }
        elseif player_bounds_cache[pid] then
            local cached = player_bounds_cache[pid]
            local moved_far = false
            if p.Position and cached.pos then
                local dx = p.Position.X - cached.pos.X
                local dy = p.Position.Y - cached.pos.Y
                local dz = p.Position.Z - cached.pos.Z
                if (dx*dx + dy*dy + dz*dz) > 625 then moved_far = true end
            end
            if not moved_far and (now - cached.t) < 0.15 then
                b = cached
            else
                player_bounds_cache[pid] = nil
            end
        end

        if not b or not b.valid then goto cont end

        local mid = b.x + b.w * 0.5

        if cfg.esp_box then
            local style = cfg.esp_style or 0
            if style == 1 then
                draw_corner_box(b.x, b.y, b.w, b.h, cfg.esp_box_c)
            else
                draw_esp_box(b.x, b.y, b.w, b.h, cfg.esp_box_c)
            end
        end

        if cfg.esp_hp then
            draw_health_bar(b.x - 6, b.y, b.h, p.Health, p.MaxHealth)
        end

        if cfg.esp_hp_t then
            local mhp = p.MaxHealth
            if not mhp or mhp <= 0 then mhp = 100 end
            local ratio = p.Health / mhp
            local htxt = format("%d", p.Health)
            local htw = draw.GetTextSize(htxt, 11)
            draw.Text(b.x - 8 - htw, b.y + b.h * 0.5 - 5, htxt, health_color(ratio), 11)
        end

        local label_y = b.y - 2
        if cfg.esp_name then
            local nm = (p.DisplayName and p.DisplayName ~= "" and p.DisplayName) or (p.Name and p.Name ~= "" and p.Name) or "Player"
            if is_staff then nm = "[STAFF] " .. nm end
            local name_col = (is_staff and cfg.esp_staff_c) or cfg.esp_name_c or {1, 1, 1, 1}
            local tw = draw.GetTextSize(nm, 13)
            label_y = label_y - 14
            local tx = mid - tw * 0.5
            draw.Text(tx + 1, label_y + 1, nm, {0, 0, 0, 0.95}, 13)
            draw.Text(tx, label_y, nm, name_col, 13)
        end

        local is_eye_vis = nil
        if cfg.esp_vis_tag or (cfg.chams and cfg.chams_vis) then
            local cam_pos = camera.GetPosition()
            is_eye_vis = check_player_visible(cam_pos, p)
        end

        if (cfg.esp_vis_tag or cfg.chams_vis) and is_eye_vis then
            local vtag = "[VISIBLE]"
            local vcol = {0.15, 1, 0.25, 1}
            local vtw = draw.GetTextSize(vtag, 11)
            label_y = label_y - 12
            draw.Text(mid - vtw * 0.5 + 1, label_y + 1, vtag, {0, 0, 0, 0.95}, 11)
            draw.Text(mid - vtw * 0.5, label_y, vtag, vcol, 11)
        end

        if cfg.esp_wep then
            local p_data = p_data_map[p.Name]
            local wep = p_data and p_data.equipped
            if wep and wep ~= "" then
                local tw = draw.GetTextSize(wep, 11)
                label_y = label_y - 12
                draw.Text(mid - tw * 0.5, label_y, wep, {1, 0.7, 0.3, 1}, 11)
            end
        end

        if cfg.esp_armor then
            local p_data = p_data_map[p.Name]
            if p_data and (p_data.helmet or p_data.vest) then
                local arm_str = (p_data.helmet or "-") .. " | " .. (p_data.vest or "-")
                local tw = draw.GetTextSize(arm_str, 11)
                label_y = label_y - 12
                draw.Text(mid - tw * 0.5, label_y, arm_str, {0.6, 0.85, 1, 1}, 11)
            end
        end

        if cfg.esp_hvt then
            local p_data = p_data_map[p.Name]
            if p_data and p_data.hvt then
                local hvt_str = "★ HVT: " .. p_data.hvt
                local tw = draw.GetTextSize(hvt_str, 12)
                label_y = label_y - 13
                draw.Text(mid - tw * 0.5, label_y, hvt_str, cfg.esp_hvt_c or {1, 0.85, 0.2, 1}, 12)
            end
        end

        if cfg.esp_dist then
            local dtxt = format("%dm", floor(dist_studs * M_PER_STUD))
            local tw = draw.GetTextSize(dtxt, 11)
            draw.Text(mid - tw * 0.5, b.y + b.h + 2, dtxt, GRAY, 11)
        end

        if cfg.esp_snap then
            draw.Line(scx, scy, mid, b.y + b.h, cfg.esp_snap_c, 1)
        end

        if cfg.esp_skel then
            local bones = p:GetBonesScreen()
            if bones then
                for j = 1, #SKEL do
                    local pair = SKEL[j]
                    local a, sb = bones[pair[1]], bones[pair[2]]
                    if a and sb then
                        draw.Line(a[1], a[2], sb[1], sb[2], cfg.esp_skel_c, 1.5)
                    end
                end
            end
        end

        if cfg.chams then
            local vc = cfg.chams_vc or {0.0, 1.0, 0.3, 1.0}
            local oc = cfg.chams_oc or {1.0, 0.25, 0.25, 1.0}
            if cfg.chams_vis then
                local col = (is_eye_vis == true) and vc or oc
                draw.ChamsPlayer(p, col, cfg.chams_m or 0)
            else
                draw.ChamsPlayer(p, vc, cfg.chams_m or 0)
            end
        end

        ::cont::
    end
end
end


local function draw_npc_esp()
if not cfg.npc or #world.npcs == 0 then return end
local cam = camera.GetPosition()
if not cam then return end
local cx, cy, cz = cam.X, cam.Y, cam.Z
local max_r = cfg.npc_range

for i = 1, #world.npcs do
local n = world.npcs[i]
if n.head and n.hum then
    local hp = n.hum.Health
    if hp and hp > 0 then
        local hpos = n.head.Position
        if hpos then
            local dist = dist3(hpos.X, hpos.Y, hpos.Z, cx, cy, cz)
            if dist > 6 and dist <= max_r / 0.28 then
                local parts = n.parts or {}
                local lf = (parts["LeftFoot"] and parts["LeftFoot"].part) or (parts["LeftLowerLeg"] and parts["LeftLowerLeg"].part) or (parts["Left Leg"] and parts["Left Leg"].part)
                local rf = (parts["RightFoot"] and parts["RightFoot"].part) or (parts["RightLowerLeg"] and parts["RightLowerLeg"].part) or (parts["Right Leg"] and parts["Right Leg"].part)
                local foot_y
                if lf and lf.Position and rf and rf.Position then
                    foot_y = math.min(lf.Position.Y, rf.Position.Y) - 0.8
                elseif lf and lf.Position then
                    foot_y = lf.Position.Y - 0.8
                elseif rf and rf.Position then
                    foot_y = rf.Position.Y - 0.8
                else
                    local root = (parts["HumanoidRootPart"] and parts["HumanoidRootPart"].part) or (parts["Torso"] and parts["Torso"].part) or (parts["LowerTorso"] and parts["LowerTorso"].part)
                    if root and root.Position then
                        foot_y = root.Position.Y - 2.8
                    else
                        foot_y = hpos.Y - 4.5
                    end
                end

                local top_y_3d = hpos.Y + 0.8
                local tx, ty, tvis = utility.WorldToScreen(hpos.X, top_y_3d, hpos.Z)
                local bx_w, by_w, bvis = utility.WorldToScreen(hpos.X, foot_y, hpos.Z)

                if tvis or bvis then
                    local bh = math.max(16, math.abs(by_w - ty))
                    local bw = bh * 0.55
                    local center_x = tvis and tx or bx_w
                    local bx = center_x - bw * 0.5
                    local by = math.min(ty, by_w)

                    if cfg.npc_box then
                        draw_esp_box(bx, by, bw, bh, cfg.npc_box_c)
                    end
                    if cfg.npc_hp then
                        draw_health_bar(bx - 6, by, bh,
                            hp, n.hum.MaxHealth or 100)
                    end
                    local mid = bx + bw * 0.5
                    if cfg.npc_name then
                        local tw = draw.GetTextSize(n.name, 13)
                        draw.Text(mid - tw*0.5, by - 15,
                            n.name, cfg.npc_name_c, 13)
                    end
                    if cfg.npc_dist then
                        local dt = format("%dm", floor(dist * 0.28))
                        local tw = draw.GetTextSize(dt, 11)
                        draw.Text(mid - tw*0.5, by + bh + 2,
                            dt, GRAY, 11)
                    end
                end
                if cfg.npc_skel and dist < 150 then
                    local screen = {}
                    for name, pd in pairs(n.parts) do
                        if pd.part then
                            local pos = pd.part.Position
                            if pos then
                                local bsx, bsy, bsv = utility.WorldToScreen(
                                    pos.X, pos.Y, pos.Z)
                                if bsv then
                                    screen[name] = {bsx, bsy}
                                end
                            end
                        end
                    end
                    for j = 1, #SKEL do
                        local a = screen[SKEL[j][1]]
                        local sb = screen[SKEL[j][2]]
                        if a and sb then
                            draw.Line(a[1], a[2], sb[1], sb[2],
                                cfg.npc_skel_c, 1.5)
                        end
                    end
                end
            end
        end
    end
end
end
end

local function draw_world_label(part, name, col, max_r, contents, show_items)
if not part then return end
local pos = part.Position
if not pos then return end
local cam = camera.GetPosition()
if not cam then return end
local dist = dist3(pos.X, pos.Y, pos.Z, cam.X, cam.Y, cam.Z)
if dist > max_r / 0.28 then return end
local sx, sy, vis = utility.WorldToScreen(pos.X, pos.Y, pos.Z)
if not vis then return end
local txt = format("%s [%dm]", name, floor(dist * 0.28))
local tw = draw.GetTextSize(txt, 13)
draw.Text(sx - tw*0.5, sy, txt, col, 13)
if show_items and contents then
local ly = sy + 14
for j = 1, #contents do
    local itw = draw.GetTextSize(contents[j], 11)
    draw.Text(sx - itw*0.5, ly, contents[j], GRAY, 11)
    ly = ly + 12
end
end
end

local function draw_world_esp()
if cfg.cont then
for i = 1, #world.containers do
    local c = world.containers[i]
    draw_world_label(c.part, c.name, cfg.cont_c,
        cfg.cont_range, c.contents, cfg.cont_items)
end
end
if cfg.loot then
local pass = LOOT_PASS[cfg.loot_f] or LOOT_PASS[0]
for i = 1, #world.items do
    local d = world.items[i]
    local cat = get_item_category(d.name)
    if pass[cat] then
        draw_world_label(d.part, d.name, cfg.loot_c,
            cfg.loot_range, nil, false)
    end
end
end
if cfg.corpse then
for i = 1, #world.corpses do
    local c = world.corpses[i]
    local label = "☠ " .. c.name
    draw_world_label(c.part, label, cfg.corpse_c,
        cfg.corpse_r, c.contents, cfg.corpse_i)
end
end
if cfg.quest then
for i = 1, #world.quests do
    local q = world.quests[i]
    draw_world_label(q.part, "★ " .. q.name, cfg.quest_c,
        cfg.quest_r, nil, false)
end
end
if cfg.extract then
for i = 1, #world.extracts do
    local e = world.extracts[i]
    draw_world_label(e.part, "⬆ " .. e.name, cfg.extract_c,
        cfg.extract_r, nil, false)
end
end
if cfg.hazard and world.hazards then
for i = 1, #world.hazards do
    local hz = world.hazards[i]
    local hz_col = hz.type == "rad" and {0.4, 1, 0.2, 0.9} or {1, 0.4, 0, 0.9}
    local hz_icon = hz.type == "rad" and "☢ " or "♨ "
    draw_world_label(hz.part, hz_icon .. hz.name, cfg.hazard_c or hz_col,
        cfg.hazard_r or 1500, nil, false)
end
end
end


local function get_player_bone_pos(p, bone_mode, scx, scy)
    if not p then return nil, nil end
    local char = p.Character

    local function get_part_by_name(name)
        if char then
            local part = char:FindFirstChild(name)
            if part and part.Position then return part.Position, part end
        end
        return nil, nil
    end

    local head_pos, head_part = nil, nil
    if p.HeadPosition then
        head_pos = p.HeadPosition
        if char then head_part = char:FindFirstChild("Head") end
    else
        head_pos, head_part = get_part_by_name("Head")
    end

    local chest_pos, chest_part = get_part_by_name("UpperTorso")
    if not chest_pos then chest_pos, chest_part = get_part_by_name("Torso") end
    if not chest_pos and head_pos and p.Position then
        chest_pos = p.Position + (head_pos - p.Position) * 0.5
    end

    local pelvis_pos, pelvis_part = get_part_by_name("LowerTorso")
    if not pelvis_pos then pelvis_pos, pelvis_part = get_part_by_name("HumanoidRootPart") end
    if not pelvis_pos then pelvis_pos = p.Position end

    local root_pos = p.Position or pelvis_pos or head_pos
    local root_part = pelvis_part or head_part or (char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso")))

    if bone_mode == 0 then
        return (head_pos or chest_pos or root_pos), (head_part or chest_part or root_part)
    elseif bone_mode == 1 then
        return (chest_pos or head_pos or pelvis_pos or root_pos), (chest_part or head_part or pelvis_part or root_part)
    elseif bone_mode == 2 then
        return (pelvis_pos or chest_pos or root_pos), (pelvis_part or chest_part or root_part)
    elseif bone_mode == 3 then
        local candidates = {
            { pos = head_pos, part = head_part },
            { pos = chest_pos, part = chest_part },
            { pos = pelvis_pos, part = pelvis_part }
        }
        local best_cand = head_pos or chest_pos or pelvis_pos or root_pos
        local best_part = head_part or chest_part or pelvis_part or root_part
        local best_d = 999999
        for ci = 1, #candidates do
            local c = candidates[ci]
            if c.pos then
                local sx, sy, sv = utility.WorldToScreen(c.pos.X, c.pos.Y, c.pos.Z)
                if sv then
                    local d = screen_dist(sx, sy, scx or 0, scy or 0)
                    if d < best_d then
                        best_d = d
                        best_cand = c.pos
                        best_part = c.part
                    end
                end
            end
        end
        return best_cand, best_part
    end
    return (head_pos or chest_pos or root_pos), (head_part or chest_part or root_part)
end

local get_bone_pos = get_player_bone_pos

local function get_npc_target_bone(n, na_b)
    local parts = n.parts or {}
    local model = n.model
    local function find_p(names)
        for j = 1, #names do
            local nm = names[j]
            if parts[nm] and parts[nm].part and parts[nm].part.Position then
                return parts[nm].part
            end
            if model then
                local p = model:FindFirstChild(nm)
                if p and p:IsA("BasePart") and p.Position then
                    return p
                end
            end
        end
        return nil
    end

    local head = n.head or find_p({"Head", "HeadTopHitBox"})
    local chest = find_p({"UpperTorso", "Torso", "Chest"})
    local pelvis = find_p({"LowerTorso", "HumanoidRootPart", "Torso", "Pelvis"})

    local b_idx = na_b or 0
    if b_idx == 0 then
        return head or chest or pelvis
    elseif b_idx == 1 then
        return chest or head or pelvis
    elseif b_idx == 2 then
        return pelvis or chest or head
    end
    return head or chest or pelvis
end

local function run_player_aim()
    aim_target_ent = nil
    local scx, scy = input.GetScreenCenter()

    if cfg.aim and cfg.aim_draw then
        local c = cfg.aim_fov_c or {1, 1, 1, 0.25}
        local a = c[4] or 0.25
        if cfg.aim_fov_filled then
            draw.CircleFilled(scx, scy, cfg.aim_fov or 150, {c[1], c[2], c[3], a * 0.4}, 64)
        end
        draw.Circle(scx, scy, cfg.aim_fov or 150, c, 64)
    end

    if cfg.npc_aim and cfg.na_draw then
        local c = cfg.na_fov_c or {1, 0.6, 0.6, 0.25}
        local a = c[4] or 0.25
        if cfg.na_fov_filled then
            draw.CircleFilled(scx, scy, cfg.na_fov or 150, {c[1], c[2], c[3], a * 0.4}, 64)
        end
        draw.Circle(scx, scy, cfg.na_fov or 150, c, 64)
    end

    if not cfg.aim and not cfg.npc_aim then
        locked_target = nil
        lock_was_down = false
        return
    end

    local lp = entity.GetLocalPlayer()
    local cam = camera.GetPosition()
    if not cam then return end

    local aim_key_mode = get_val("b_aim_key", 0) or 0
    local key_held = false
    if aim_key_mode == 0 then
        key_held = input.IsKeyDown(0x02)
    elseif aim_key_mode == 1 then
        key_held = input.IsKeyDown(0x01)
    elseif aim_key_mode == 2 then
        key_held = input.IsKeyDown(0x12)
    elseif aim_key_mode == 3 then
        key_held = input.IsKeyDown(0xA0)
    elseif aim_key_mode == 4 then
        key_held = true
    end

    if not key_held then
        locked_target = nil
        lock_was_down = false
        return
    end

    local equipped = nil
    if lp then
        for wi = 1, #world.players do
            local wp = world.players[wi]
            if wp.name == (lp.Name or "") and wp.equipped then
                equipped = wp.equipped
                break
            end
        end
    end

    local b_mode = get_val("b_aim_bone", 0) or 0
    local na_b = get_val("b_npc_aim_bone", 0) or cfg.na_bone or 0

    local target = nil

    if cfg.aim_lock and locked_target then
        local lt = locked_target
        if lt.is_npc then
            local n = lt.npc
            if n and n.hum and n.hum.Health and n.hum.Health > 0 then
                local bp = get_npc_target_bone(n, na_b)
                if bp and bp.Position then
                    lt.bone_pos = bp.Position
                    lt.part = bp
                    target = lt
                end
            end
        else
            local p = lt.player
            if p and p.IsValid and not p.IsDead and (p.Health == nil or p.Health > 0) then
                local bp, tp = get_player_bone_pos(p, b_mode, scx, scy)
                if bp then
                    lt.bone_pos = bp
                    lt.part = tp
                    target = lt
                end
            end
        end
    end

    if not target then
        local best_p = nil
        local best_p_fov = cfg.aim_fov or 150

        if cfg.aim then
            local players = frame_players or entity.GetPlayers() or {}
            local rbx_lp = nil
            pcall(function() rbx_lp = game.Players.LocalPlayer end)
            for i = 1, #players do
                local p = players[i]
                local is_me = p and (p.IsLocal or (lp and (p == lp or p.UserId == lp.UserId or p.Name == lp.Name or (p.Address and lp.Address and p.Address == lp.Address))))
                if not is_me and rbx_lp and p then
                    if (rbx_lp.UserId and p.UserId == rbx_lp.UserId) or (rbx_lp.Name and p.Name == rbx_lp.Name) or (p.Character and rbx_lp.Character and p.Character == rbx_lp.Character) then
                        is_me = true
                    end
                end
                local d_chk = p and p:DistanceTo()
                if not is_me and d_chk and d_chk < 3 then is_me = true end
                if p and not is_me then
                    local is_dead = (p.IsDead == true) or (p.Health ~= nil and p.Health <= 0)
                    if not is_dead then
                        if cfg.aim_team and is_same_team(p) then goto skip_p end
                        local bone_pos, target_part = get_player_bone_pos(p, b_mode, scx, scy)
                        if bone_pos then
                            local bx, by, bv = utility.WorldToScreen(bone_pos.X, bone_pos.Y, bone_pos.Z)
                            if bv then
                                local fov = screen_dist(bx, by, scx, scy)
                                if fov < best_p_fov then
                                    best_p_fov = fov
                                    best_p = { player = p, bone_pos = bone_pos, part = target_part, fov = fov, is_npc = false }
                                end
                            end
                        end
                    end
                    ::skip_p::
                end
            end
        end

        local best_npc = nil
        local best_npc_fov = cfg.na_fov or 150

        if cfg.npc_aim and world and world.npcs and #world.npcs > 0 then
            for i = 1, #world.npcs do
                local n = world.npcs[i]
                if n.hum and n.hum.Health and n.hum.Health > 0 then
                    local bp = get_npc_target_bone(n, na_b)
                    if bp and bp.Position then
                        local pos = bp.Position
                        local d_c = dist3(pos.X, pos.Y, pos.Z, cam.X, cam.Y, cam.Z)
                        if d_c > 6 then
                            local ax, ay, az = pos.X, pos.Y, pos.Z
                            if cfg.na_pred then
                                local vel = bp.Velocity
                                if vel then
                                    local dist = dist3(ax, ay, az, cam.X, cam.Y, cam.Z)
                                    local t = dist / 750
                                    if t > 0.4 then t = 0.4 end
                                    local vlen = sqrt(vel.X*vel.X + vel.Y*vel.Y + vel.Z*vel.Z)
                                    if vlen > 2 then
                                        ax = ax + vel.X * t
                                        ay = ay + vel.Y * t
                                        az = az + vel.Z * t
                                    end
                                end
                            end
                            local sx, sy, sv = utility.WorldToScreen(ax, ay, az)
                            if sv then
                                local fov = screen_dist(sx, sy, scx, scy)
                                if fov < best_npc_fov then
                                    best_npc_fov = fov
                                    best_npc = { npc = n, bone_pos = Vector3.New(ax, ay, az), part = bp, fov = fov, is_npc = true }
                                end
                            end
                        end
                    end
                end
            end
        end

        if best_p and best_npc then
            if best_p_fov <= best_npc_fov then
                target = best_p
            else
                target = best_npc
            end
        elseif best_p then
            target = best_p
        elseif best_npc then
            target = best_npc
        end

        if cfg.aim_lock and target then
            locked_target = target
            lock_was_down = true
        end
    end

    if not target then return end
    aim_target_ent = target

    local bone_pos = target.bone_pos
    local target_part = target.part
    local ax, ay, az = bone_pos.X, bone_pos.Y, bone_pos.Z
    local sm = 5.0

    if target.is_npc then
        sm = cfg.na_sm or 5.0
    else
        sm = cfg.aim_sm or 5.0
        local p = target.player
        local dist_studs = dist3(ax, ay, az, cam.X, cam.Y, cam.Z)
        local dist_m = dist_studs * M_PER_STUD
        local t_flight = 0
        if cfg.aim_pred then
            local speed_ms = get_bullet_speed(equipped)
            local drop_m, tf = calc_ballistic_drop(dist_m, speed_ms)
            t_flight = tf
            local drop_studs = (drop_m * (cfg.aim_pred_scale or 1.0)) * STUDS_PER_M
            ay = ay + drop_studs
        end
        if cfg.aim_lead and p and p.Velocity and t_flight > 0 then
            local v = p.Velocity
            local vlen = sqrt(v.X*v.X + v.Y*v.Y + v.Z*v.Z)
            if vlen > 0.5 then
                ax = ax + v.X * t_flight
                ay = ay + v.Y * t_flight
                az = az + v.Z * t_flight
            end
        end
    end

    if sm < 1.0 then sm = 1.0 end
    local sx, sy, on_screen = utility.WorldToScreen(ax, ay, az)
    if on_screen and input and input.MoveMouse then
        local mdx = (sx - scx) / sm
        local mdy = (sy - scy) / sm
        input.MoveMouse(mdx, mdy)
    end

    if target_part then
        pcall(camera.LookAt, target_part, sm)
    end
    pcall(camera.LookAt, ax, ay, az, sm)
end

local function run_npc_aim()
end

local sil_rot_idx = 1
local sil_rot_order = { "Head", "UpperTorso", "LowerTorso" }
local sil_was_lmb = false

local function run_silent_aim()
    if not cfg.silent then
        if silent_ok then
            pcall(raycast.ClearSilentTarget)
            pcall(raycast.DisableSilentHook)
            silent_ok = false
        end
        return
    end

    if not silent_ok then
        local s_ok = raycast.EnableSilentHook()
        if s_ok then silent_ok = true end
    end
    if not silent_ok then return end

    local scx, scy = input.GetScreenCenter()
    if cfg.sil_draw then
        local c = cfg.sil_fov_c or {1, 0.8, 0.2, 0.2}
        local a = c[4] or 0.2
        if cfg.sil_fov_filled then
            draw.CircleFilled(scx, scy, cfg.sil_fov or 200, {c[1], c[2], c[3], a * 0.4}, 64)
        end
        draw.Circle(scx, scy, cfg.sil_fov or 200, c, 64)
    end

    local lp = entity.GetLocalPlayer()
    if not lp then
        raycast.ClearSilentTarget()
        return
    end

    local origin = lp.HeadPosition or camera.GetPosition()
    if not origin then
        raycast.ClearSilentTarget()
        return
    end

    local players = frame_players or entity.GetPlayers() or {}
    local mode = get_val("b_silent_bone", 0) or 0
    local best_fov = cfg.sil_fov or 200
    local best_pos = nil

    for i = 1, #players do
        local p = players[i]
        local is_me = p and (p.IsLocal or (lp and (p.UserId == lp.UserId or p.Name == lp.Name or (p.Address and lp.Address and p.Address == lp.Address))))
        if p and not is_me then
            local is_dead = (p.IsDead == true) or (p.Health ~= nil and p.Health <= 0)
            if not is_dead then
                if cfg.sil_team and is_same_team(p) then goto skip end

                local bone_pos = get_player_bone_pos(p, mode == 4 and (sil_rot_idx - 1) or mode, scx, scy)
                if bone_pos then
                    local bx, by, bv = utility.WorldToScreen(bone_pos.X, bone_pos.Y, bone_pos.Z)
                    if bv then
                        local fov = screen_dist(bx, by, scx, scy)
                        if fov < best_fov then
                            best_fov = fov
                            best_pos = bone_pos
                        end
                    end
                end
            end
            ::skip::
        end
    end

    if best_pos then
        local dir = best_pos - origin
        raycast.SetSilentTarget(origin, dir)
    else
        raycast.ClearSilentTarget()
    end
end



local ui_prev_visible = false



local THEMES = {
    { name = "White", col = {0.95, 0.95, 0.95, 1.0} },
    { name = "Blue", col = {0.25, 0.65, 1.0, 1.0} },
    { name = "Green", col = {0.25, 0.95, 0.35, 1.0} },
    { name = "Red", col = {1.0, 0.25, 0.25, 1.0} },
    { name = "Purple", col = {0.70, 0.35, 1.0, 1.0} },
    { name = "Yellow", col = {1.0, 0.90, 0.20, 1.0} },
    { name = "Magenta", col = {1.0, 0.20, 0.85, 1.0} },
    { name = "Cyan", col = {0.15, 0.95, 1.0, 1.0} },
    { name = "Pink", col = {1.0, 0.45, 0.75, 1.0} },
    { name = "Turquoise", col = {0.20, 0.90, 0.75, 1.0} }
}

local function hsv_to_rgb(h, s, v)
    local i = math.floor(h * 6)
    local f = h * 6 - i
    local p = v * (1 - s)
    local q = v * (1 - f * s)
    local t = v * (1 - (1 - f) * s)
    local r, g, b = 0, 0, 0
    local mod = i % 6
    if mod == 0 then r, g, b = v, t, p
    elseif mod == 1 then r, g, b = q, v, p
    elseif mod == 2 then r, g, b = p, v, t
    elseif mod == 3 then r, g, b = p, q, v
    elseif mod == 4 then r, g, b = t, p, v
    elseif mod == 5 then r, g, b = v, p, q
    end
    return {r, g, b, 1.0}
end

local function get_vk_name(vk)
    if not vk or vk == 0 then return "Home" end
    if vk == 0x24 then return "Home"
    elseif vk == 0x2D then return "Insert"
    elseif vk == 0x2E then return "Delete"
    elseif vk == 0x23 then return "End"
    elseif vk == 0x21 then return "PageUp"
    elseif vk == 0x22 then return "PageDown"
    elseif vk == 0x70 then return "F1"
    elseif vk == 0x71 then return "F2"
    elseif vk == 0x72 then return "F3"
    elseif vk == 0x73 then return "F4"
    elseif vk == 0x74 then return "F5"
    elseif vk == 0x75 then return "F6"
    elseif vk == 0x76 then return "F7"
    elseif vk == 0x77 then return "F8"
    elseif vk == 0x78 then return "F9"
    elseif vk == 0x79 then return "F10"
    elseif vk == 0x7A then return "F11"
    elseif vk == 0x7B then return "F12"
    elseif vk == 0xA1 then return "RShift"
    elseif vk == 0xA0 then return "LShift"
    elseif vk == 0x10 then return "Shift"
    elseif vk == 0xA3 then return "RCtrl"
    elseif vk == 0xA2 then return "LCtrl"
    elseif vk == 0x11 then return "Ctrl"
    elseif vk == 0xA5 then return "RAlt"
    elseif vk == 0xA4 then return "LAlt"
    elseif vk == 0x12 then return "Alt"
    elseif vk == 0x09 then return "Tab"
    elseif vk == 0xC0 then return "~"
    elseif vk >= 0x41 and vk <= 0x5A then
        return string.char(vk)
    elseif vk >= 0x30 and vk <= 0x39 then
        return string.char(vk)
    end
    return string.format("0x%X", vk)
end

local function get_active_theme()
    local is_rainbow = (menu.Get("b_rainbow_mode") == true)
    local cur_theme_idx = menu.Get("b_menu_theme") or 0
    local cur_theme_data = THEMES[cur_theme_idx + 1] or THEMES[1]
    if is_rainbow then
        local now_t = (utility and utility.GetTime and utility.GetTime()) or (os.clock and os.clock()) or 0
        local main_col = hsv_to_rgb((now_t * 0.35) % 1.0, 0.85, 1.0)
        local sub_col = hsv_to_rgb((now_t * 0.35 + 0.38) % 1.0, 0.85, 1.0)
        return main_col, sub_col, { sub_col[1] * 0.75, sub_col[2] * 0.75, sub_col[3] * 0.75, 1.0 }
    else
        local col = cur_theme_data.col
        return col, { col[1] * 0.88, col[2] * 0.88, col[3] * 0.88, 1.0 }, { col[1] * 0.70, col[2] * 0.70, col[3] * 0.70, 1.0 }
    end
end

local function draw_watermark()
if not cfg.wm then return end
local fps = utility.GetFPS()
local theme_col, theme_sub = get_active_theme()
local tr, tg, tb = theme_col[1], theme_col[2], theme_col[3]
local cur_vk = menu.Get("b_menu_key") or 0x24
local key_name = get_vk_name(cur_vk)
local line1 = "ProjectBoba"
local line2 = format("FPS: %.0f  |  Open: [%s]", fps, key_name)
local tw1 = draw.GetTextSize(line1, 14)
local tw2 = draw.GetTextSize(line2, 11)
tw1 = (type(tw1) == "number" and tw1) or 60
tw2 = (type(tw2) == "number" and tw2) or 80
local w = (tw1 > tw2 and tw1 or tw2) + 24
local h = 38

local sw, sh = draw.GetScreenSize()
if sw and sh and sw > 100 and sh > 100 then
    wm_x = max(0, min(wm_x, sw - w))
    wm_y = max(0, min(wm_y, sh - h))
end

local menu_active = is_any_menu_open()
if not menu_active then
    wm_drag = false
end

local mx, my = input.GetMousePosition()
if menu_active and input.IsKeyDown(0x01) then
if not wm_drag then
    if mx >= wm_x and mx <= wm_x + w and my >= wm_y and my <= wm_y + h then
        wm_drag = true
        wm_dx = mx - wm_x
        wm_dy = my - wm_y
    end
else
    wm_x = mx - wm_dx
    wm_y = my - wm_dy
    if sw and sh and sw > 100 and sh > 100 then
        wm_x = max(0, min(wm_x, sw - w))
        wm_y = max(0, min(wm_y, sh - h))
    end
end
else
wm_drag = false
end

draw.RectFilled(wm_x, wm_y, w, h, {0.05 + tr * 0.06, 0.05 + tg * 0.06, 0.07 + tb * 0.06, 0.92}, 4)
draw.Rect(wm_x, wm_y, w, h, {theme_col[1] * 0.5, theme_col[2] * 0.5, theme_col[3] * 0.5, 0.75}, 4)
draw.RectFilled(wm_x + 2, wm_y + 2, w - 4, 2, theme_col, 0)
draw.Text(wm_x + 10, wm_y + 5, line1, theme_col, 14)
draw.Text(wm_x + 10, wm_y + 20, line2, WHITE, 11)
end

local function rot_line(cx, cy, x1, y1, x2, y2, ang, col, th)
    if ang == 0 then
        draw.Line(cx + x1, cy + y1, cx + x2, cy + y2, col, th)
    else
        local c = math.cos(ang)
        local s = math.sin(ang)
        local rx1 = x1 * c - y1 * s
        local ry1 = x1 * s + y1 * c
        local rx2 = x2 * c - y2 * s
        local ry2 = x2 * s + y2 * c
        draw.Line(cx + rx1, cy + ry1, cx + rx2, cy + ry2, col, th)
    end
end

local function draw_crosshair()
local cx, cy = input.GetScreenCenter()
local cur_sz = cfg.cross_sz or 8
local cur_gap = cfg.cross_gap or 3

if cfg.cross then
    local c = cfg.cross_c or {0, 1, 0, 1}
    local th = cfg.cross_thick or 2
    local style = cfg.cross_style or 0
    local now_t = utility.GetTime and utility.GetTime() or tick()

    local pulse = 0
    if cfg.cross_pulse then
        pulse = math.sin(now_t * (cfg.cross_pulse_spd or 4)) * (cur_sz * 0.35)
    end
    cur_sz = max(2, cur_sz + pulse)
    cur_gap = max(0, cur_gap + (pulse * 0.5))

    local angle = 0
    if cfg.cross_spin then
        angle = (now_t * (cfg.cross_spin_spd or 5)) % (math.pi * 2)
    end

    if style == 0 then
        rot_line(cx, cy, 0, -cur_gap, 0, -cur_gap - cur_sz, angle, c, th)
        rot_line(cx, cy, 0, cur_gap, 0, cur_gap + cur_sz, angle, c, th)
        rot_line(cx, cy, -cur_gap, 0, -cur_gap - cur_sz, 0, angle, c, th)
        rot_line(cx, cy, cur_gap, 0, cur_gap + cur_sz, 0, angle, c, th)
    elseif style == 1 then
        draw.CircleFilled(cx, cy, max(1.5, cur_sz * 0.35), c, 16)
    elseif style == 2 then
        draw.Circle(cx, cy, cur_sz, c, 32)
        if cur_gap > 1 then
            draw.CircleFilled(cx, cy, 1.5, c, 8)
        end
    elseif style == 3 then
        rot_line(cx, cy, -cur_gap, 0, -cur_gap - cur_sz, 0, angle, c, th)
        rot_line(cx, cy, cur_gap, 0, cur_gap + cur_sz, 0, angle, c, th)
        rot_line(cx, cy, 0, cur_gap, 0, cur_gap + cur_sz, angle, c, th)
    elseif style == 4 then
        rot_line(cx, cy, -cur_sz, cur_sz * 0.5, 0, -cur_sz * 0.3, angle, c, th)
        rot_line(cx, cy, 0, -cur_sz * 0.3, cur_sz, cur_sz * 0.5, angle, c, th)
    elseif style == 5 then
        draw.CircleFilled(cx, cy, 1.5, c, 8)
        local g = cur_gap + 3
        rot_line(cx, cy, 0, -g, 0, -g - cur_sz, angle, c, th)
        rot_line(cx, cy, 0, g, 0, g + cur_sz, angle, c, th)
        rot_line(cx, cy, -g, 0, -g - cur_sz, 0, angle, c, th)
        rot_line(cx, cy, g, 0, g + cur_sz, 0, angle, c, th)
    end
end

local show_vis = (cfg.aim_vis_txt and aim_has_visible) or (cfg.sil_vis_txt and sil_has_visible)
if show_vis then
    local vtxt = "VISIBLE"
    local f_sz = 16
    local tw = draw.GetTextSize(vtxt, f_sz)
    local tx = cx - tw * 0.5
    local ty = cy + (cfg.cross and (cur_sz + cur_gap + 12) or 16)
    draw.Text(tx + 1, ty + 1, vtxt, {0, 0, 0, 0.95}, f_sz)
    draw.Text(tx - 1, ty, vtxt, {0, 0, 0, 0.95}, f_sz)
    draw.Text(tx, ty - 1, vtxt, {0, 0, 0, 0.95}, f_sz)
    draw.Text(tx, ty, vtxt, {0.15, 1, 0.25, 1}, f_sz)
end
end

local function draw_inventory()
if not cfg.inspect then return end
local scx, scy = input.GetScreenCenter()

local closest, closest_d = nil, 500
if world.players then
    for i = 1, #world.players do
        local d = world.players[i]
        local p = d.entity
        if p and p.IsValid and p.IsAlive and not p.IsLocal then
            local pos = p.Position
            if pos then
                local sx, sy, sv = utility.WorldToScreen(pos.X, pos.Y, pos.Z)
                if sv then
                    local sd = screen_dist(sx, sy, scx, scy)
                    if sd < closest_d then
                        closest_d = sd
                        closest = d
                    end
                end
            end
        end
    end
end

if closest then
    inv_target_data = closest
else
    closest = inv_target_data
end

local lines = {}
local theme_col, theme_sub = get_active_theme()
local tr, tg, tb = theme_col[1], theme_col[2], theme_col[3]
if not closest then
    lines[#lines+1] = {txt = "INVENTORY INSPECTOR", col = theme_col, size = 13}
    lines[#lines+1] = {txt = "Aim at a player to inspect", col = GRAY, size = 11}
    lines[#lines+1] = {txt = "(Draggable header)", col = theme_sub, size = 10}
else
    local weapons, armor, specials, misc_items = {}, {}, {}, {}
    local pname = closest.name or "Unknown"

    if closest.equipped then
        weapons[#weapons+1] = closest.equipped
    end
    if closest.inventory then
        for j = 1, #closest.inventory do
            local iname = closest.inventory[j]
            local cat = get_item_category(iname)
            if cat == "weapon" and cfg.inv_weap then
                if iname ~= closest.equipped then
                    weapons[#weapons+1] = iname
                end
            elseif cat == "armor" and cfg.inv_armor then
                armor[#armor+1] = iname
            elseif cat == "special" and cfg.inv_special then
                specials[#specials+1] = iname
            elseif cat == "misc" and cfg.inv_misc then
                misc_items[#misc_items+1] = iname
            end
        end
    end

    if #weapons == 0 and closest.entity and closest.entity.Character then
        local char = closest.entity.Character
        local holding = char:FindFirstChild("Holding") or char:FindFirstChild("Item")
        if holding and holding.Name ~= "" then
            weapons[#weapons+1] = holding.Name
        end
        for _, it in ipairs(char:GetChildren()) do
            if it:IsA("Model") and it.Name ~= "Clothing" and it.Name ~= "Holstered" and it.Name ~= "Hair" and #weapons == 0 then
                weapons[#weapons+1] = it.Name
            end
        end
    end

    lines[#lines+1] = {txt = pname, col = theme_col, size = 13}
    local inv_dist = closest.entity and closest.entity:DistanceTo()
    if inv_dist then
        lines[#lines+1] = {txt = format("%dm away", floor(inv_dist * M_PER_STUD)), col = theme_sub, size = 11}
    end

    if #weapons > 0 then
        lines[#lines+1] = {txt = "Weapons:", col = theme_col, size = 11}
        for _, w in ipairs(weapons) do
            local col = (w == closest.equipped) and theme_sub or GRAY
            lines[#lines+1] = {txt = "  " .. w, col = col, size = 11}
        end
    end
    if #armor > 0 then
        lines[#lines+1] = {txt = "Armor:", col = theme_col, size = 11}
        for _, a in ipairs(armor) do
            lines[#lines+1] = {txt = "  " .. a, col = GRAY, size = 11}
        end
    end
    if #specials > 0 then
        lines[#lines+1] = {txt = "Special:", col = theme_col, size = 11}
        for _, s in ipairs(specials) do
            lines[#lines+1] = {txt = "  " .. s, col = {1,0.8,0,1}, size = 11}
        end
    end
    if #misc_items > 0 then
        lines[#lines+1] = {txt = "Misc:", col = theme_col, size = 11}
        for _, m in ipairs(misc_items) do
            lines[#lines+1] = {txt = "  " .. m, col = GRAY, size = 11}
        end
    end
    if #weapons == 0 and #armor == 0 and #specials == 0 and #misc_items == 0 then
        lines[#lines+1] = {txt = "  (No items visible)", col = GRAY, size = 11}
    end
end

local max_w = 0
for j = 1, #lines do
    local tw = draw.GetTextSize(lines[j].txt, lines[j].size)
    if tw > max_w then max_w = tw end
end
local pad = 10
local pw = max_w + pad * 2
local line_h = 14
local ph = #lines * line_h + pad * 2

local sw, sh = draw.GetScreenSize()
if sw and sh and sw > 100 and sh > 100 then
    inv_x = max(0, min(inv_x, sw - pw))
    inv_y = max(0, min(inv_y, sh - ph))
end

local menu_active = is_any_menu_open()
if not menu_active then
    inv_drag = false
end

local mx, my = input.GetMousePosition()
if menu_active and input.IsKeyDown(0x01) then
    if not inv_drag then
        if mx >= inv_x and mx <= inv_x + pw and my >= inv_y and my <= inv_y + 24 then
            inv_drag = true
            inv_dx = mx - inv_x
            inv_dy = my - inv_y
        end
    else
        inv_x = mx - inv_dx
        inv_y = my - inv_dy
        if sw and sh and sw > 100 and sh > 100 then
            inv_x = max(0, min(inv_x, sw - pw))
            inv_y = max(0, min(inv_y, sh - ph))
        end
    end
else
    inv_drag = false
end

draw.RectFilled(inv_x, inv_y, pw, ph, {0.05 + tr * 0.05, 0.05 + tg * 0.05, 0.07 + tb * 0.05, 0.90}, 5)
draw.Rect(inv_x, inv_y, pw, ph, {theme_col[1] * 0.4, theme_col[2] * 0.4, theme_col[3] * 0.4, 0.7}, 5)
draw.RectFilled(inv_x + 1, inv_y + 1, pw - 2, 2, theme_col, 0)

local ty = inv_y + pad
for j = 1, #lines do
    draw.Text(inv_x + pad, ty, lines[j].txt, lines[j].col, lines[j].size)
    ty = ty + line_h
end
end


local function save_originals()
if orig_light then return end
orig_light = {
br = lighting.GetBrightness(),
am = lighting.GetAmbient(),
oa = lighting.GetOutdoorAmbient(),
ex = lighting.GetExposure(),
fs = lighting.GetFogStart(),
fe = lighting.GetFogEnd(),
ds = lighting.GetDiffuseScale(),
ss = lighting.GetSpecularScale()
}
orig_grass = terrain.GetGrassLength()
end

local function restore_originals()
if orig_light then
lighting.SetBrightness(orig_light.br)
lighting.SetAmbient(orig_light.am)
lighting.SetOutdoorAmbient(orig_light.oa)
lighting.SetExposure(orig_light.ex)
lighting.SetFogStart(orig_light.fs)
lighting.SetFogEnd(orig_light.fe)
lighting.SetDiffuseScale(orig_light.ds)
lighting.SetSpecularScale(orig_light.ss)
orig_light = nil
end
if orig_grass then
terrain.SetGrassLength(orig_grass)
orig_grass = nil
end
end

local function apply_world_mods()
local any = mg("b_bright") or mg("b_nofog") or mg("b_noshadow") or mg("b_nograss")
if any then save_originals() end

if mg("b_bright") then
lighting.SetBrightness(4)
lighting.SetAmbient(1)
lighting.SetOutdoorAmbient(1)
end
if mg("b_nofog") then
lighting.SetFogStart(100000)
lighting.SetFogEnd(100000)
end
if mg("b_noshadow") then
lighting.SetDiffuseScale(0)
lighting.SetSpecularScale(0)
end
if mg("b_nograss") then
terrain.SetGrassLength(0)
end
end


local function scan_claymores()
local ws = game.Workspace
if not ws then return end
local results = {}
local function scan_folder(folder, depth)
    if not depth then depth = 1 end
    if depth > 2 then return end
    local ok, children = pcall(function() return folder:GetChildren() end)
    if not ok or not children then return end
    for _, child in ipairs(children) do
        local n = child.Name:lower()
        if n:find("claymore") or n:find("landmine") or n:find("mon50") or n:find("pmn") then
            local mesh = child:FindFirstChild("MeshPart")
                or child:FindFirstChild("Part")
                or child:FindFirstChildOfClass("BasePart")
            if mesh and mesh.Position then
                local trig = child:FindFirstChild("Trigger")
                results[#results+1] = {
                    name = child.Name, part = mesh,
                    trigger = trig, model = child
                }
            end
        elseif child:IsA("Folder") then
            scan_folder(child, depth + 1)
        end
    end
end
local ai = ws:FindFirstChild("AiZones")
if ai then scan_folder(ai) end
local traps = ws:FindFirstChild("Traps")
if traps then scan_folder(traps) end
local items = ws:FindFirstChild("Items")
if items then scan_folder(items) end
world_claymores = results
end

local function draw_claymores()
if not cfg.claymore then return end
local lp = entity.GetLocalPlayer()
local mp = lp and lp.Position
if not mp then return end
local cx, cy, cz = mp.X, mp.Y, mp.Z
local max_r = cfg.clay_r * STUDS_PER_M
local red = {1, 0.15, 0.15, 1}
for i = 1, #world_claymores do
local c = world_claymores[i]
local mpos = c.part and c.part.Position
if mpos then
    local d = dist3(mpos.X, mpos.Y, mpos.Z, cx, cy, cz)
    if d <= max_r then
        local sx, sy, sv = draw.WorldToScreen(mpos.X, mpos.Y, mpos.Z)
        if sv then
            local s = 8
            draw.Line(sx, sy-s, sx+s, sy, cfg.clay_c, 2)
            draw.Line(sx+s, sy, sx, sy+s, cfg.clay_c, 2)
            draw.Line(sx, sy+s, sx-s, sy, cfg.clay_c, 2)
            draw.Line(sx-s, sy, sx, sy-s, cfg.clay_c, 2)
            if cfg.clay_names then
                local dm = floor(d * M_PER_STUD)
                local txt = format("%s [%dm]", c.name, dm)
                local tw = draw.GetTextSize(txt, 12)
                draw.Text(sx - tw*0.5, sy - 20, txt, cfg.clay_c, 12)
            end
            if c.trigger then
                local tpos = c.trigger.Position
                if tpos then
                    local tx, ty, tv = draw.WorldToScreen(tpos.X, tpos.Y, tpos.Z)
                    if tv then draw.Line(sx, sy, tx, ty, red, 1) end
                end
            end
        end
    end
end
end
end


local function update_bosses()
local ws = game.Workspace
if not ws then return end
local ai_zones = ws:FindFirstChild("AiZones")
local lp = entity.GetLocalPlayer()
local mp = lp and lp.Position
for i, def in ipairs(BOSS_DEFS) do
local entry = { name = def.name, status = "none", hp = 0, max_hp = 0, dist = -1 }
if ai_zones then
    local zone = ai_zones:FindFirstChild(def.zone)
    local boss = zone and zone:FindFirstChild(def.name)
    if boss then
        local hum = boss:FindFirstChildOfClass("Humanoid")
        if hum then
            local hp = hum.Health or 0
            local mhp = hum.MaxHealth or 100
            if hp > 0 then
                entry.status = "alive"
                entry.hp = floor(hp)
                entry.max_hp = floor(mhp)
                local hrp = boss:FindFirstChild("HumanoidRootPart")
                if mp and hrp then
                    local bp = hrp.Position
                    if bp then
                        entry.dist = floor(dist3(mp.X, mp.Y, mp.Z, bp.X, bp.Y, bp.Z) * 0.28)
                    end
                end
            else entry.status = "dead" end
        else entry.status = "dead" end
    end
end
boss_data[i] = entry
end
for i, def in ipairs(VEHICLE_DEFS) do
local entry = { name = def.label, status = "none", dist = -1 }
local veh = ws:FindFirstChild(def.name)
if not veh and ai_zones then
    local ok2, zones = pcall(function() return ai_zones:GetChildren() end)
    if ok2 and zones then
        for _, z in ipairs(zones) do
            local f = z:FindFirstChild(def.name)
            if f then veh = f; break end
        end
    end
end
if veh then
    entry.status = "spawned"
    local root = veh:FindFirstChild("HumanoidRootPart")
    if not root then
        local ok2, ch = pcall(function() return veh:GetChildren() end)
        if ok2 and ch then
            for _, c in ipairs(ch) do
                if c:IsA("BasePart") then root = c; break end
            end
        end
    end
    if mp and root then
        local vp = root.Position
        if vp then
            entry.dist = floor(dist3(mp.X, mp.Y, mp.Z, vp.X, vp.Y, vp.Z) * 0.28)
        end
    end
end
vehicle_data[i] = entry
end
end

local BOSS_COL = {
bg     = {0.05, 0.05, 0.07, 0.96},
title  = {0.07, 0.07, 0.10, 1.00},
border = {0.18, 0.72, 0.84, 1.00},
accent = {0.18, 0.72, 0.84, 1.00},
dim    = {0.25, 0.25, 0.30, 1.00},
alive  = {0.47, 1.00, 0.63, 1.00},
warn   = {1.00, 0.78, 0.24, 1.00},
dead   = {1.00, 0.31, 0.31, 1.00},
none   = {0.47, 0.47, 0.50, 1.00},
veh    = {1.00, 0.85, 0.20, 1.00},
white  = {1.00, 1.00, 1.00, 1.00},
}

local function boss_hp_color(hp, mhp)
if mhp <= 0 then return BOSS_COL.none end
local pct = hp / mhp
if pct > 0.5 then return BOSS_COL.alive end
if pct > 0.2 then return BOSS_COL.warn end
return BOSS_COL.dead
end

local function draw_boss_panel()
if not cfg.boss then boss_drag = false; return end
local pw = 170
local TH, PAD, RH, SH, FS = 24, 8, 18, 16, 12
local nb, nv = #BOSS_DEFS, #VEHICLE_DEFS
local ph = TH + SH + (nb * RH) + 4 + SH + (nv * RH) + 4 + PAD
local menu_active = is_any_menu_open()
if not menu_active then
    boss_drag = false
end

local mx, my = utility.GetMousePos()
local lmb = menu_active and input.IsKeyDown(0x01)
if lmb then
if not boss_drag then
    if mx >= boss_x and mx <= boss_x + pw and my >= boss_y and my <= boss_y + TH then
        boss_drag = true; boss_dx = mx - boss_x; boss_dy = my - boss_y
    end
else boss_x = mx - boss_dx; boss_y = my - boss_dy end
else boss_drag = false end
local px, py = boss_x, boss_y
local theme_col, theme_sub = get_active_theme()
local tr, tg, tb = theme_col[1], theme_col[2], theme_col[3]
draw.RectFilled(px, py, pw, ph, {0.05 + tr * 0.05, 0.05 + tg * 0.05, 0.07 + tb * 0.05, 0.95}, 4)
draw.RectFilled(px, py, pw, TH, {0.07 + tr * 0.06, 0.07 + tg * 0.06, 0.09 + tb * 0.06, 1.00}, 4)
draw.RectFilled(px, py, 2, TH, theme_col, 0)
draw.Line(px, py+TH, px+pw, py+TH, theme_col, 1)
draw.Rect(px, py, pw, ph, {theme_col[1]*0.5, theme_col[2]*0.5, theme_col[3]*0.5, 0.7}, 4, 1)
draw.Text(px+10, py+5, "Boss Tracker", theme_col, FS)
local hint = "drag ::"
local hw = draw.GetTextSize(hint, 10)
draw.Text(px+pw-hw-PAD, py+6, hint, BOSS_COL.dim, 10)
local ly = py + TH
draw.RectFilled(px, ly, pw, SH, {0.07 + tr * 0.05, 0.07 + tg * 0.05, 0.09 + tb * 0.05, 1}, 0)
draw.RectFilled(px, ly, 2, SH, theme_col, 0)
local btw = draw.GetTextSize("BOSSES", 9)
draw.Text(px + (pw - btw) * 0.5, ly + 3, "BOSSES", theme_col, 9)
ly = ly + SH
for i, entry in ipairs(boss_data) do
local ry = ly + (i-1) * RH
draw.Text(px+PAD+4, ry+3, entry.name, BOSS_COL.white, FS)
local stxt, scol
if entry.status == "alive" then
    local pct = entry.max_hp > 0 and floor(entry.hp / entry.max_hp * 100) or 0
    stxt = format("%d/%d (%d%%)", entry.hp, entry.max_hp, pct)
    if entry.dist >= 0 then stxt = stxt .. "  " .. entry.dist .. "m" end
    scol = boss_hp_color(entry.hp, entry.max_hp)
elseif entry.status == "dead" then
    stxt = "Dead"; scol = BOSS_COL.dead
else
    stxt = "Not Spawned"; scol = BOSS_COL.none
end
local nw = draw.GetTextSize(entry.name, FS)
draw.Text(px+PAD+4+nw+6, ry+3, stxt, scol, FS)
end
ly = ly + (nb * RH) + 4
draw.RectFilled(px, ly, pw, SH, {0.07 + tr * 0.05, 0.07 + tg * 0.05, 0.09 + tb * 0.05, 1}, 0)
draw.RectFilled(px, ly, 2, SH, theme_col, 0)
local vtw = draw.GetTextSize("VEHICLES", 9)
draw.Text(px + (pw - vtw) * 0.5, ly + 3, "VEHICLES", theme_col, 9)
ly = ly + SH
for i, entry in ipairs(vehicle_data) do
local ry = ly + (i-1) * RH
draw.Text(px+PAD+4, ry+3, entry.name, BOSS_COL.white, FS)
local stxt, scol
if entry.status == "spawned" then
    stxt = "Spawned"
    if entry.dist >= 0 then stxt = stxt .. "  " .. entry.dist .. "m" end
    scol = BOSS_COL.veh
else
    stxt = "Not Spawned"; scol = BOSS_COL.none
end
local nw = draw.GetTextSize(entry.name, FS)
draw.Text(px+PAD+4+nw+6, ry+3, stxt, scol, FS)
end
end


local function update_mod_check()
local found = {}
local players = entity.GetPlayers()
if players then
for i = 1, #players do
    local p = players[i]
    if p and p.IsValid and p.Name then
        if MOD_NAMES[p.Name:lower()] then
            found[#found+1] = p.Name
        end
    end
end
end
detected_mods = found
end

local function draw_mod_alert()
if not cfg.mod_alert then return end
local mode = cfg.mod_mode or 1
local count = #detected_mods
if mode == 1 and count == 0 then return end
local sw, sh = draw.GetScreenSize()
local label = count > 0 and ("MODS IN SERVER: " .. count) or "NO MODS IN SERVER"
local fs = 18
local tw, th = draw.GetTextSize(label, fs)
local x = sw * 0.5 - tw * 0.5
local y = 12
local tc = count > 0 and {1, 0.08, 0.08, 1} or {0.3, 1, 0.3, 1}
local bc = count > 0 and {1, 0.1, 0.1, 0.9} or {0.2, 0.9, 0.2, 0.9}
draw.RectFilled(x - 8, y - 4, tw + 16, th + 8, {0, 0, 0, 0.7}, 4)
draw.Rect(x - 8, y - 4, tw + 16, th + 8, bc, 3, 1.5)
draw.Text(x, y, label, tc, fs)
end


local function slf_scan()
local found = {}
for _, wp in ipairs(world.players) do
local p = wp.entity
if p and p.IsValid and p.IsAlive and not p.IsLocal then
    local matched = {}
    for _, item in ipairs(wp.inventory) do
        local il = item:lower()
        for _, tracked in ipairs(SLF_ITEMS) do
            if il:find(tracked:lower(), 1, true) then
                matched[#matched+1] = item
                break
            end
        end
    end
    if #matched > 0 then
        found[#found+1] = { name = wp.name, items = matched }
    end
end
end
slf_results = found
end

local SLF_COL = {
bg     = {0.05, 0.05, 0.07, 0.96},
title  = {0.07, 0.07, 0.10, 1.00},
border = {0.18, 0.72, 0.84, 1.00},
accent = {0.18, 0.72, 0.84, 1.00},
dim    = {0.25, 0.25, 0.30, 1.00},
player = {1.00, 1.00, 1.00, 1.00},
item   = {0.35, 0.90, 0.45, 1.00},
none   = {0.45, 0.45, 0.50, 1.00},
sep    = {0.18, 0.72, 0.84, 0.3},
}

local function draw_slf_panel()
if not cfg.slf then slf_drag = false; return end
local pw = 280
local TH, PAD, LH, FS, FSS = 24, 8, 16, 13, 11
local nr = #slf_results
local ph = TH + PAD
if nr == 0 then
ph = ph + LH + PAD
else
for _, entry in ipairs(slf_results) do
    ph = ph + LH + (#entry.items * LH) + 6
end
ph = ph + PAD
end
local menu_active = is_any_menu_open()
if not menu_active then
    slf_drag = false
end

local mx, my = utility.GetMousePos()
local lmb = menu_active and input.IsKeyDown(0x01)
if lmb then
if not slf_drag then
    if mx >= slf_x and mx <= slf_x + pw and my >= slf_y and my <= slf_y + TH then
        slf_drag = true; slf_dx = mx - slf_x; slf_dy = my - slf_y
    end
else slf_x = mx - slf_dx; slf_y = my - slf_dy end
else slf_drag = false end
local px, py = slf_x, slf_y
local theme_col, theme_sub = get_active_theme()
local tr, tg, tb = theme_col[1], theme_col[2], theme_col[3]
draw.RectFilled(px, py, pw, ph, {0.05 + tr * 0.05, 0.05 + tg * 0.05, 0.07 + tb * 0.05, 0.95}, 4)
draw.RectFilled(px, py, pw, TH, {0.07 + tr * 0.06, 0.07 + tg * 0.06, 0.09 + tb * 0.06, 1.00}, 4)
draw.RectFilled(px, py, 2, TH, theme_col, 0)
draw.Line(px, py+TH, px+pw, py+TH, theme_col, 1)
draw.Rect(px, py, pw, ph, {theme_col[1]*0.5, theme_col[2]*0.5, theme_col[3]*0.5, 0.7}, 4, 1)
local title = "Server Loot Finder"
if nr > 0 then title = title .. "  [" .. nr .. "]" end
draw.Text(px+PAD+2, py+5, title, theme_col, FS)
local hint = "drag ::"
local hw = draw.GetTextSize(hint, 10)
draw.Text(px+pw-hw-PAD, py+6, hint, SLF_COL.dim, 10)
local ly = py + TH + PAD
if nr == 0 then
draw.Text(px+PAD, ly, "No tracked loot found", SLF_COL.none, FS)
return
end
for i, entry in ipairs(slf_results) do
draw.Text(px+PAD, ly, "> " .. entry.name, SLF_COL.player, FS)
ly = ly + LH
for _, item in ipairs(entry.items) do
    draw.Text(px+PAD+4, ly, "  - " .. item, SLF_COL.item, FSS)
    ly = ly + LH
end
if i < nr then
    draw.Line(px+PAD, ly+1, px+pw-PAD, ly+1, SLF_COL.sep, 1)
end
ly = ly + 6
end
end


local function scan_cars()
local ws = game.Workspace
if not ws then return end
local results = {}
local function check_model(model)
if not model:IsA("Model") then return end
local has_seat = model:FindFirstChildOfClass("VehicleSeat")
if not has_seat and not is_car_name(model.Name) then return end
local prim = model:FindFirstChildOfClass("VehicleSeat")
    or model:FindFirstChildOfClass("BasePart")
if prim and prim.Position then
    results[#results+1] = {
        name = model.Name, part = prim
    }
end
end
for _, fname in ipairs({"Vehicles", "Cars", "SpawnedVehicles", "VehicleSpawners"}) do
    local folder = ws:FindFirstChild(fname)
    if folder then
        local ok2, fc = pcall(function() return folder:GetChildren() end)
        if ok2 and fc then
            for _, child in ipairs(fc) do check_model(child) end
        end
    end
end
world_cars = results
end

local function draw_cars()
if not cfg.car then return end
local lp = entity.GetLocalPlayer()
local mp = lp and lp.Position
if not mp then return end
local cx, cy, cz = mp.X, mp.Y, mp.Z
local max_r = cfg.car_r * STUDS_PER_M
for i = 1, #world_cars do
local c = world_cars[i]
local pos = c.part and c.part.Position
if pos then
    local d = dist3(pos.X, pos.Y, pos.Z, cx, cy, cz)
    if d <= max_r then
        local sx, sy, sv = draw.WorldToScreen(pos.X, pos.Y, pos.Z)
        if sv then
            local dm = floor(d * M_PER_STUD)
            local txt = format("[CAR] %s [%dm]", c.name, dm)
            local tw = draw.GetTextSize(txt, 13)
            draw.Text(sx - tw*0.5, sy, txt, cfg.car_c, 13)
        end
    end
end
end
end


local function draw_radar()
if not cfg.radar then return end
local lp = entity.GetLocalPlayer()
if not lp or not lp.IsAlive then return end
local mp = lp.Position
if not mp then return end

local sz = cfg.radar_sz
local half = sz * 0.5
local range = cfg.radar_range * STUDS_PER_M
local rx, ry = 20, 100
local cx, cy = rx + half, ry + half

draw.RectFilled(rx, ry, sz, sz, {0.05, 0.05, 0.1, 0.75}, 4)
draw.Rect(rx, ry, sz, sz, {0.2, 0.3, 0.5, 0.6}, 4)
draw.Line(cx, ry+2, cx, ry+sz-2, {0.2, 0.3, 0.4, 0.3}, 1)
draw.Line(rx+2, cy, rx+sz-2, cy, {0.2, 0.3, 0.4, 0.3}, 1)
draw.RectFilled(cx-2, cy-2, 4, 4, {0, 1, 0, 1}, 0)

local yaw = 0
if cfg.radar_rot then
local ok_lv, look = pcall(function() return camera.GetLookVector() end)
if ok_lv and look then
    yaw = math.atan2(-look.X, -look.Z)
end
end
local cos_y = math.cos(yaw)
local sin_y = math.sin(yaw)

local players = frame_players
if players then
for i = 1, #players do
    local p = players[i]
    if p and p.IsValid and p.IsAlive and not p.IsLocal then
        local pp = p.Position
        if pp then
            local dx = pp.X - mp.X
            local dz = pp.Z - mp.Z
            local rdx = dx * cos_y - dz * sin_y
            local rdz = dx * sin_y + dz * cos_y
            local px = cx + (rdx / range) * half
            local py = cy + (rdz / range) * half
            if px >= rx and px <= rx+sz and py >= ry and py <= ry+sz then
                local col = is_same_team(p) and {0.3, 0.7, 1, 1} or {1, 0.3, 0.3, 1}
                draw.RectFilled(px-2, py-2, 4, 4, col, 0)
            end
        end
    end
end
end

for i = 1, #world.npcs do
local n = world.npcs[i]
local np = n.part and n.part.Position
if np then
    local dx = np.X - mp.X
    local dz = np.Z - mp.Z
    local rdx = dx * cos_y - dz * sin_y
    local rdz = dx * sin_y + dz * cos_y
    local px = cx + (rdx / range) * half
    local py = cy + (rdz / range) * half
    if px >= rx and px <= rx+sz and py >= ry and py <= ry+sz then
        draw.RectFilled(px-1, py-1, 3, 3, {1, 0.6, 0.2, 1}, 0)
    end
end
end

draw.Text(rx+4, ry+2, format("RADAR [%dm]", cfg.radar_range), {0.6, 0.7, 0.9, 0.8}, 10)
end


local function draw_hitmarker()
if not cfg.hitmarker then return end
local now = os.clock()
if aim_target_ent and input.IsKeyDown(0x01) then
hitmarker_time = now
end
local elapsed = now - hitmarker_time
if elapsed < 0.25 then
local scx, scy = input.GetScreenCenter()
local alpha = 1.0 - (elapsed / 0.25)
local s = 6
local col = {1, 1, 1, alpha}
draw.Line(scx-s, scy-s, scx-3, scy-3, col, 2)
draw.Line(scx+s, scy-s, scx+3, scy-3, col, 2)
draw.Line(scx-s, scy+s, scx-3, scy+3, col, 2)
draw.Line(scx+s, scy+s, scx+3, scy+3, col, 2)
end
end


local function draw_corpse_markers()
if not cfg.corpse_x then return end
local lp = entity.GetLocalPlayer()
local mp = lp and lp.Position
if not mp then return end
local cx, cy, cz = mp.X, mp.Y, mp.Z
for i = 1, #world.corpses do
local c = world.corpses[i]
local pos = c.part and c.part.Position
if pos then
    local d = dist3(pos.X, pos.Y, pos.Z, cx, cy, cz)
    if d <= cfg.corpse_r * STUDS_PER_M then
        local sx, sy, sv = draw.WorldToScreen(pos.X, pos.Y, pos.Z)
        if sv then
            local s = 5
            draw.Line(sx-s, sy-s, sx+s, sy+s, cfg.corpse_xc, 2)
            draw.Line(sx+s, sy-s, sx-s, sy+s, cfg.corpse_xc, 2)
        end
    end
end
end
end


wep_orig_props = {}
wep_highlights = {}
wep_cham_applied = {}
wep_last_update = 0

local function cleanup_wep_chams()
    pcall(function()
        if exploits and exploits.RevertChams then
            exploits.RevertChams()
        end
    end)
    wep_cham_applied = {}

    for model, hl in pairs(wep_highlights) do
        pcall(function()
            if hl and utility.IsValid(hl) then
                if instance and instance.Destroy then
                    instance.Destroy(hl)
                elseif hl.Destroy then
                    hl:Destroy()
                end
            end
        end)
    end
    wep_highlights = {}

    for part, orig in pairs(wep_orig_props) do
        pcall(function()
            if utility.IsValid(part) then
                if orig.Color then part.Color = orig.Color end
                if orig.Material then part.Material = orig.Material end
                if orig.Transparency then part.Transparency = orig.Transparency end
                if orig.TextureID ~= nil and part:IsA("MeshPart") then
                    part.TextureID = orig.TextureID
                end
                if orig.sa and utility.IsValid(orig.sa) then
                    orig.sa.Parent = part
                end
            end
        end)
    end
    wep_orig_props = {}
end

local function apply_cham_to_part(part, c3)
    if not part or not utility.IsValid(part) or not part:IsA("BasePart") then return end
    if part.Transparency >= 0.95 then return end
    local pname = part.Name:lower()
    if pname == "humanoidrootpart" or pname == "rootpart" or pname == "itemroot" then return end

    local addr = part.Address
    if addr and not wep_cham_applied[addr] then
        pcall(function()
            if exploits and exploits.ApplyChamsToInstance then
                if exploits.ApplyChamsToInstance(part) then
                    wep_cham_applied[addr] = true
                end
            end
        end)
    end

    if not wep_orig_props[part] then
        local orig = {}
        pcall(function() orig.Color = part.Color end)
        pcall(function() orig.Material = part.Material end)
        pcall(function() orig.Transparency = part.Transparency end)
        if part:IsA("MeshPart") then
            pcall(function() orig.TextureID = part.TextureID end)
        end
        local sa = part:FindFirstChildOfClass("SurfaceAppearance")
        if sa then
            orig.sa = sa
        end
        wep_orig_props[part] = orig
    end

    pcall(function()
        local sa = part:FindFirstChildOfClass("SurfaceAppearance")
        if sa then
            sa.Parent = nil
        end
    end)

    pcall(function()
        part.Color = c3
        part.Transparency = 0
        pcall(function() part.Material = "Neon" end)
        pcall(function() part.Material = 288 end)
        if part:IsA("MeshPart") and part.TextureID ~= "" then
            part.TextureID = ""
        end
    end)
end

local function apply_highlight_to_model(model, c3)
    if not model or not utility.IsValid(model) then return end
    local hl = wep_highlights[model]
    if not hl or not utility.IsValid(hl) then
        pcall(function()
            if instance and instance.New and (not instance.IsReady or instance.IsReady()) then
                hl = instance.New("Highlight", model)
                wep_highlights[model] = hl
            end
        end)
    end
    if hl and utility.IsValid(hl) then
        pcall(function()
            hl.FillColor = c3
            hl.OutlineColor = c3
            hl.FillTransparency = 0.15
            hl.OutlineTransparency = 0.0
            hl.DepthMode = 0
            hl.Enabled = true
        end)
    end
end

local function run_wep_chams()
    if not cfg.wep_chams then
        if next(wep_orig_props) or next(wep_highlights) or next(wep_cham_applied) then
            cleanup_wep_chams()
        end
        return
    end

    local now = utility.GetTickCount()
    if (now - wep_last_update) < 40 then return end
    wep_last_update = now

    local c = cfg.wep_chams_c or {0.2, 0.85, 1.0, 1.0}
    local r, g, b = c[1] or 0.2, c[2] or 0.85, c[3] or 1.0

    if cfg.wep_chams_pulse then
        local t = now * 0.003
        r = 0.5 + 0.5 * sin(t)
        g = 0.5 + 0.5 * sin(t + 2.094)
        b = 0.5 + 0.5 * sin(t + 4.188)
    end

    local c3 = nil
    pcall(function() c3 = Color3.fromRGB(floor(r * 255), floor(g * 255), floor(b * 255)) end)
    if not c3 then
        pcall(function() c3 = Color3.new(r, g, b) end)
    end
    if not c3 then return end

    local style_idx = cfg.wep_chams_style or 0
    local chams_mode = (style_idx == 0 and 1) or (style_idx == 1 and 2) or 3
    pcall(function()
        if exploits and exploits.SetChamsMode then
            exploits.SetChamsMode(chams_mode)
        end
    end)

    local chams_color_idx = 5
    if cfg.wep_chams_pulse then
        chams_color_idx = (floor(now * 0.002) % 6) + 1
    else
        if r > 0.7 and g < 0.4 and b < 0.4 then chams_color_idx = 1
        elseif g > 0.7 and r < 0.4 and b < 0.4 then chams_color_idx = 2
        elseif b > 0.7 and r < 0.4 and g < 0.7 then chams_color_idx = 3
        elseif r > 0.7 and g > 0.7 and b < 0.4 then chams_color_idx = 4
        elseif g > 0.7 and b > 0.7 and r < 0.4 then chams_color_idx = 5
        elseif r > 0.7 and g > 0.7 and b > 0.7 then chams_color_idx = 0
        else chams_color_idx = 5 end
    end
    pcall(function()
        if exploits and exploits.SetChamsColor then
            exploits.SetChamsColor(chams_color_idx)
        end
    end)

    local ws = game.Workspace
    local cam = get_cam_instance()
    local vm = (cam and cam:FindFirstChild("ViewModel")) or (ws and ws:FindFirstChild("ViewModel"))
    local lp = entity.GetLocalPlayer()
    local char = lp and lp.Character

    local active_parts = {}
    local active_models = {}

    if vm then
        local item = vm:FindFirstChild("Item")
        if item then
            active_models[item] = true
            apply_highlight_to_model(item, c3)
            for _, p in ipairs(item:GetDescendants()) do
                if p:IsA("BasePart") then
                    active_parts[p] = true
                    apply_cham_to_part(p, c3)
                end
            end
        end

        for _, p in ipairs(vm:GetDescendants()) do
            if p:IsA("BasePart") and not active_parts[p] then
                local pname = p.Name:lower()
                local is_arm = pname:find("arm") or pname:find("hand") or pname:find("sleeve") or pname:find("glove") or pname:find("wrist") or pname:find("body")
                if not is_arm and p.Transparency < 0.95 then
                    active_parts[p] = true
                    apply_cham_to_part(p, c3)
                end
            end
        end
    end

    if char then
        for _, obj in ipairs(char:GetChildren()) do
            if (obj:IsA("Model") or obj:IsA("Tool")) and obj.Name ~= "ViewModel" and obj.Name ~= "Clothing" and obj.Name ~= "Holstered" then
                active_models[obj] = true
                apply_highlight_to_model(obj, c3)
                for _, p in ipairs(obj:GetDescendants()) do
                    if p:IsA("BasePart") and p.Name ~= "ItemRoot" and p.Name ~= "Handle" then
                        active_parts[p] = true
                        apply_cham_to_part(p, c3)
                    end
                end
            end
        end
    end

    for model, hl in pairs(wep_highlights) do
        if not active_models[model] then
            pcall(function()
                if hl and utility.IsValid(hl) then
                    if instance and instance.Destroy then instance.Destroy(hl) else hl:Destroy() end
                end
            end)
            wep_highlights[model] = nil
        end
    end

    for part in pairs(wep_orig_props) do
        if not active_parts[part] then
            local orig = wep_orig_props[part]
            if orig and utility.IsValid(part) then
                pcall(function()
                    if orig.Color then part.Color = orig.Color end
                    if orig.Material then part.Material = orig.Material end
                    if orig.Transparency then part.Transparency = orig.Transparency end
                    if orig.TextureID ~= nil and part:IsA("MeshPart") then
                        part.TextureID = orig.TextureID
                    end
                    if orig.sa and utility.IsValid(orig.sa) then
                        orig.sa.Parent = part
                    end
                end)
            end
            wep_orig_props[part] = nil
            if part.Address then
                wep_cham_applied[part.Address] = nil
            end
        end
    end
end


local KNIFE_NAMES = {
    [1] = "Karambit", [2] = "FlipKnifeShark", [3] = "ButterflyKnife",
    [4] = "PlasmaNinjato", [5] = "Scythe", [6] = "Kukri",
    [7] = "M9Fade", [8] = "M9XR7", [9] = "Greatsword",
    [10] = "Longsword", [11] = "GoldenDV2", [12] = "AnarchyTomahawk",
    [13] = "IceAxe", [14] = "IceDagger",
}

local GUN_SKINS = {
    [1] = { weapon = "AKM", skin = "Banana" },
    [2] = { weapon = "M4", skin = "Pumpkin" },
    [3] = { weapon = "AKMN", skin = "DeltaAnime" },
    [4] = { weapon = "Saiga12", skin = "Valentine" },
    [5] = { weapon = "M4", skin = "Devil" },
    [6] = { weapon = "M4", skin = "Freedom" },
    [7] = { weapon = "SOCOM556", skin = "Blackout" },
    [8] = { weapon = "PPSH41", skin = "Arctic" },
    [9] = { weapon = "Mosin", skin = "WhiteDeath" },
    [10] = { weapon = "M4", skin = "XR7" },
}

local ARMOR_PACKS = {
    [1] = "Crusader", [2] = "Anarchy", [3] = "Blackout",
    [4] = "Valentine", [5] = "Freedom", [6] = "Arctic",
    [7] = "Adibass",
}

local function get_visual_meshparts(root)
    local list = {}
    if not root then return list end
    for _, p in ipairs(root:GetDescendants()) do
        if p:IsA("MeshPart") and p.Name ~= "ItemRoot" and p.Name ~= "HumanoidRootPart" and p.Name ~= "RootPart" then
            table.insert(list, p)
        end
    end
    if #list == 0 then
        for _, p in ipairs(root:GetDescendants()) do
            if p:IsA("MeshPart") then
                table.insert(list, p)
            end
        end
    end
    return list
end

local function is_item_melee(vm_item, rep, lp)
    if vm_item then
        local sref = vm_item:FindFirstChild("SelfRef")
        if sref and sref.Value then
            local sname = (type(sref.Value) == "string" and sref.Value)
                or (type(sref.Value) == "userdata" and sref.Value.Name)
                or tostring(sref.Value)
            local slow = sname:lower()
            if slow:find("dv2") or slow:find("knife") or slow:find("melee") or slow:find("blade")
                or slow:find("karambit") or slow:find("kukri") or slow:find("scythe")
                or slow:find("axe") or slow:find("dagger") or slow:find("sword") or slow:find("tomahawk") then
                return true
            end
            if slow:find("ak") or slow:find("m4") or slow:find("saiga") or slow:find("socom")
                or slow:find("ppsh") or slow:find("mosin") or slow:find("rifle") or slow:find("svd") or slow:find("asval") then
                return false
            end
        end
    end

    local char = lp and lp.Character
    if char then
        for _, ch in ipairs(char:GetChildren()) do
            if (ch:IsA("Model") or ch:IsA("Tool")) and ch.Name ~= "ViewModel" and ch.Name ~= "Clothing" and ch.Name ~= "Holstered" then
                local ch_low = ch.Name:lower()
                if ch_low:find("dv2") or ch_low:find("knife") or ch_low:find("melee")
                    or ch_low:find("karambit") or ch_low:find("kukri") or ch_low:find("scythe")
                    or ch_low:find("axe") or ch_low:find("dagger") or ch_low:find("sword") then
                    return true
                end
            end
        end
    end

    if rep and lp and lp.Name then
        local rep_p = rep:FindFirstChild("Players")
        local p_data = rep_p and rep_p:FindFirstChild(lp.Name)
        local status = p_data and p_data:FindFirstChild("Status")
        local gv = status and status:FindFirstChild("GameplayVariables")
        local eq = gv and gv:FindFirstChild("EquippedTool")
        if eq and eq.Value then
            local eq_name = (type(eq.Value) == "string" and eq.Value) or (type(eq.Value) == "userdata" and eq.Value.Name)
            if eq_name and type(eq_name) == "string" then
                local low = eq_name:lower()
                if low:find("knife") or low:find("dv2") or low:find("melee") or low:find("blade")
                    or low:find("axe") or low:find("scythe") or low:find("tomahawk")
                    or low:find("sword") or low:find("crowbar") or low:find("dagger")
                    or low:find("karambit") or low:find("kukri") then
                    return true
                end
                if low:find("ak") or low:find("m4") or low:find("saiga") or low:find("socom")
                    or low:find("ppsh") or low:find("mosin") or low:find("rifle") or low:find("pistol") then
                    return false
                end
            end
        end
    end

    if vm_item then
        local vname = vm_item.Name:lower()
        if vname:find("knife") or vname:find("dv2") or vname:find("melee") then return true end
        local has_firearm = false
        local has_melee_part = false
        for _, p in ipairs(vm_item:GetChildren()) do
            local pname = p.Name:lower()
            if pname:find("barrel") or pname:find("receiver") or pname:find("mag") or pname:find("sight") or pname:find("trigger") or pname:find("stock") then
                has_firearm = true
            end
            if pname:find("blade") or pname:find("knife") or pname:find("itemmodel") then
                has_melee_part = true
            end
        end
        if has_firearm then return false end
        if has_melee_part then return true end
    end
    return false
end

local function apply_skins_silent()
    if not cfg.skin_enable then return false end
    local applied_any = false

    pcall(function()
        local rep = game.ReplicatedStorage
        if not rep then return end

        local ws = game.Workspace
        local cam = ws and (ws.CurrentCamera or ws:FindFirstChildOfClass("Camera") or ws:FindFirstChild("Camera"))
        local vm = (cam and cam:FindFirstChild("ViewModel")) or (ws and ws:FindFirstChild("ViewModel"))
        local vm_item = vm and (vm:FindFirstChild("Item") or vm)
        local lp = entity.GetLocalPlayer()
        local char = lp and lp.Character

        local holding_melee = is_item_melee(vm_item, rep, lp)

        local k_idx = cfg.skin_knife or 0
        if k_idx > 0 and KNIFE_NAMES[k_idx] then
            local knife_target = KNIFE_NAMES[k_idx]
            applied_any = true

            local src_knife = (rep:FindFirstChild("ThirdPersonModels") and rep.ThirdPersonModels:FindFirstChild(knife_target))
                or (rep:FindFirstChild("Skins") and rep.Skins:FindFirstChild("Melee") and rep.Skins.Melee:FindFirstChild(knife_target))
                or (rep:FindFirstChild("ItemsListModels") and rep.ItemsListModels:FindFirstChild(knife_target))
                or (rep:FindFirstChild("ViewModels") and rep.ViewModels:FindFirstChild(knife_target))
                or (rep:FindFirstChild("SkinPacks") and rep.SkinPacks:FindFirstChild(knife_target))

            if src_knife and vm_item and holding_melee then
                local existing_custom = vm_item:FindFirstChild("BobaKnifeSkin")
                if not existing_custom then
                    pcall(function()
                        local clone = src_knife:Clone()
                        clone.Name = "BobaKnifeSkin"
                        clone.Parent = vm_item
                        local root = vm_item:FindFirstChild("ItemRoot") or vm_item:FindFirstChild("Root") or vm_item:FindFirstChildWhichIsA("BasePart")
                        for _, p in ipairs(clone:GetDescendants()) do
                            if p:IsA("BasePart") then
                                p.CanCollide = false
                                p.Anchored = false
                                if root and root ~= p then
                                    local w = instance.New("WeldConstraint", p)
                                    w.Part0 = p
                                    w.Part1 = root
                                    p.CFrame = root.CFrame
                                end
                            end
                        end
                        for _, orig_p in ipairs(vm_item:GetChildren()) do
                            if orig_p ~= clone and orig_p.Name ~= "ItemRoot" then
                                for _, sub in ipairs(orig_p:GetDescendants()) do
                                    if sub:IsA("BasePart") then sub.Transparency = 1 end
                                    if sub:IsA("SurfaceAppearance") then sub.Parent = nil end
                                end
                                if orig_p:IsA("BasePart") then orig_p.Transparency = 1 end
                            end
                        end
                    end)
                end
            elseif not holding_melee and vm_item then
                local old_knife = vm_item:FindFirstChild("BobaKnifeSkin")
                if old_knife then
                    pcall(function()
                        if instance and instance.Destroy then instance.Destroy(old_knife) else old_knife:Destroy() end
                    end)
                end
                for _, orig_p in ipairs(vm_item:GetChildren()) do
                    if orig_p.Name ~= "ItemRoot" then
                        for _, sub in ipairs(orig_p:GetDescendants()) do
                            if sub:IsA("BasePart") and sub.Transparency == 1 then sub.Transparency = 0 end
                        end
                        if orig_p:IsA("BasePart") and orig_p.Transparency == 1 then orig_p.Transparency = 0 end
                    end
                end
            end

            if char and src_knife and holding_melee then
                for _, c_obj in ipairs(char:GetChildren()) do
                    if (c_obj:IsA("Model") or c_obj:IsA("Tool")) and c_obj.Name ~= "ViewModel" and c_obj.Name ~= "Clothing" and c_obj.Name ~= "Holstered" then
                        local c_low = c_obj.Name:lower()
                        local is_c_melee = c_low:find("knife") or c_low:find("melee") or c_low:find("dv2") or c_low:find("blade")
                        if is_c_melee then
                            local existing_c_custom = c_obj:FindFirstChild("BobaKnifeSkin")
                            if not existing_c_custom then
                                pcall(function()
                                    local clone = src_knife:Clone()
                                    clone.Name = "BobaKnifeSkin"
                                    clone.Parent = c_obj
                                    local root = c_obj:FindFirstChild("Handle") or c_obj:FindFirstChild("ItemRoot") or c_obj:FindFirstChildWhichIsA("BasePart")
                                    for _, p in ipairs(clone:GetDescendants()) do
                                        if p:IsA("BasePart") then
                                            p.CanCollide = false
                                            p.Anchored = false
                                            if root and root ~= p then
                                                local w = instance.New("WeldConstraint", p)
                                                w.Part0 = p
                                                w.Part1 = root
                                                p.CFrame = root.CFrame
                                            end
                                        end
                                    end
                                    for _, orig_p in ipairs(c_obj:GetChildren()) do
                                        if orig_p ~= clone and orig_p.Name ~= "Handle" then
                                            for _, sub in ipairs(orig_p:GetDescendants()) do
                                                if sub:IsA("BasePart") then sub.Transparency = 1 end
                                                if sub:IsA("SurfaceAppearance") then sub.Parent = nil end
                                            end
                                            if orig_p:IsA("BasePart") then orig_p.Transparency = 1 end
                                        end
                                    end
                                end)
                            end
                        end
                    end
                end
            end
        end

        local g_idx = cfg.skin_gun or 0
        if g_idx > 0 and GUN_SKINS[g_idx] then
            local g_def = GUN_SKINS[g_idx]
            applied_any = true

            local skins_f = rep:FindFirstChild("Skins")
            local target_skin = skins_f and (skins_f:FindFirstChild(g_def.weapon) or skins_f:FindFirstChild("Front" .. g_def.weapon))
            local skin_folder = target_skin and target_skin:FindFirstChild(g_def.skin)

            local sp_pack = rep:FindFirstChild("SkinPacks") and rep.SkinPacks:FindFirstChild(g_def.skin)
            local sp_gun = sp_pack and (sp_pack:FindFirstChild(g_def.weapon) or sp_pack:FindFirstChild("Front" .. g_def.weapon))

            local donor = skin_folder or sp_gun
            if donor and vm_item and not holding_melee then
                local donor_textures = donor:FindFirstChild("Textures") or donor
                for _, part in ipairs(vm_item:GetDescendants()) do
                    if part:IsA("MeshPart") then
                        local src_part = donor_textures:FindFirstChild(part.Name, true)
                        if src_part and src_part:IsA("MeshPart") then
                            if src_part.TextureID ~= "" and part.TextureID ~= src_part.TextureID then
                                part.TextureID = src_part.TextureID
                            end
                            local d_sa = src_part:FindFirstChildOfClass("SurfaceAppearance")
                            local p_sa = part:FindFirstChildOfClass("SurfaceAppearance")
                            if d_sa and p_sa then
                                pcall(function()
                                    p_sa.ColorMap = d_sa.ColorMap
                                    p_sa.NormalMap = d_sa.NormalMap
                                    p_sa.RoughnessMap = d_sa.RoughnessMap
                                    p_sa.MetalnessMap = d_sa.MetalnessMap
                                end)
                            end
                        end
                    end
                end
            end
        end

        local a_idx = cfg.skin_armor or 0
        if a_idx > 0 and ARMOR_PACKS[a_idx] then
            local a_name = ARMOR_PACKS[a_idx]
            applied_any = true

            local sp_pack = rep:FindFirstChild("SkinPacks") and rep.SkinPacks:FindFirstChild(a_name)
            if char and sp_pack then
                for _, armor_part in ipairs(sp_pack:GetChildren()) do
                    local char_item = char:FindFirstChild(armor_part.Name)
                    if char_item then
                        for _, p in ipairs(char_item:GetDescendants()) do
                            if p:IsA("MeshPart") then
                                local src = armor_part:FindFirstChild(p.Name, true)
                                if src and src:IsA("MeshPart") and src.TextureID ~= "" and p.TextureID ~= src.TextureID then
                                    p.TextureID = src.TextureID
                                end
                            end
                        end
                    end
                end
            end
        end
    end)

    return applied_any
end

function apply_skins_now()
    if not cfg.skin_enable then
        notify.Warning("Skin Changer", "Enable Skin Changer first before applying!")
        return
    end

    local ok = apply_skins_silent()
    if ok then
        notify.Success("Skin Changer", "Skins applied successfully!")
    else
        notify.Warning("Skin Changer", "Select a skin from the dropdown first!")
    end

    thread.Create(function()
        pcall(function()
            local rep = game.ReplicatedStorage
            local remotes = rep and rep:FindFirstChild("Remotes")
            local cs = remotes and remotes:FindFirstChild("ChangeSkin")
            if cs and (cs:IsA("RemoteFunction") or cs.InvokeServer) then
                local k_idx = cfg.skin_knife or 0
                if k_idx > 0 and KNIFE_NAMES[k_idx] then
                    pcall(function() cs:InvokeServer("Melee", KNIFE_NAMES[k_idx]) end)
                end
                local g_idx = cfg.skin_gun or 0
                if g_idx > 0 and GUN_SKINS[g_idx] then
                    local g_def = GUN_SKINS[g_idx]
                    pcall(function() cs:InvokeServer(g_def.weapon, g_def.skin) end)
                end
            end
        end)
    end, 200)
end

last_skin_auto_apply = 0
function auto_apply_skins()
    if not cfg.skin_enable then return end
    local now = utility.GetTickCount()
    if (now - last_skin_auto_apply) < 300 then return end
    last_skin_auto_apply = now
    apply_skins_silent()
end


fov_current = nil
fov_applied = false
last_applied_fov = nil

local function run_fov_changer()
    local enabled = menu.Get("b_fov_changer")
    if enabled == nil then enabled = true end

    local cam = get_cam_instance()
    local rad_70 = math.rad(70)

    if not enabled then
        if fov_applied then
            pcall(function() camera.SetFov(rad_70) end)
            if cam and cam.FieldOfView then pcall(function() cam.FieldOfView = rad_70 end) end
            fov_applied = false
            fov_current = nil
            last_applied_fov = nil
        end
        return
    end

    local is_aiming = input.IsKeyDown(0x02)
    if is_aiming then
        last_applied_fov = nil
        return
    end

    if cfg.fov_ads_safe then
        local cur_f = (cam and cam.FieldOfView) or (camera and camera.GetFov and camera.GetFov())
        if type(cur_f) == "number" then
            local deg_f = deg(cur_f)
            if deg_f < 35 then
                last_applied_fov = nil
                return
            end
        end
    end

    local raw_val = menu.Get("b_fov_val")
    local user_target = (type(raw_val) == "number" and raw_val) or cfg.fov_val or 90
    user_target = clamp(floor(user_target), 70, 110)
    local target_rad = math.rad(user_target)

    local cur_rad = nil
    if camera and camera.GetFov then
        local ok_g, gf = pcall(camera.GetFov)
        if ok_g and type(gf) == "number" then cur_rad = gf end
    end
    if not cur_rad and cam and cam.FieldOfView then
        cur_rad = cam.FieldOfView
    end

    local needs_apply = false
    if not last_applied_fov or abs(user_target - last_applied_fov) > 0.5 then
        needs_apply = true
    elseif user_target ~= 70 and cur_rad and abs(cur_rad - rad_70) < 0.02 then
        needs_apply = true
    end

    if needs_apply then
        last_applied_fov = user_target
        fov_applied = true
        pcall(function() camera.SetFov(target_rad) end)
        if cam and cam.FieldOfView then
            pcall(function() cam.FieldOfView = target_rad end)
        end
    end
end


local function do_panic()
panic_on = not panic_on
if panic_on then
restore_originals()
if silent_ok then
    raycast.ClearSilentTarget()
    raycast.DisableSilentHook()
    silent_ok = false
end
camera.StopTracking()
cleanup_wep_chams()
if fov_applied then
    local rad_70 = math.rad(70)
    pcall(function() camera.SetFov(rad_70) end)
    local cam = get_cam_instance()
    if cam and cam.FieldOfView then pcall(function() cam.FieldOfView = rad_70 end) end
    fov_applied = false
    fov_current = nil
    last_applied_fov = nil
end
notify.Warning("BOBA", "Panic — all features hidden")
else
local ok = raycast.EnableSilentHook()
if ok then silent_ok = true end
notify.Success("BOBA", "Features restored")
end
end




local draw_nixware_menu
do
local ui = {
    visible = true,
    x = 100,
    y = 60,
    w = 818,
    h = 520,
    dragging = false,
    drag_ox = 0,
    drag_oy = 0,
    tab = 0,
    active_slider = nil,
    binding_key = false,
    last_lmb = false,
    last_toggle_key = false
}

local intro_start = tick()
local intro_done = false

local tabs = {
    { icon = "A", label = "Aimbots" },
    { icon = "E", label = "Visuals" },
    { icon = "H", label = "Chams" },
    { icon = "M", label = "Misc" },
    { icon = "C", label = "Config" }
}


local cfg_name_buf = ""
local cfg_focus = false
local selected_cfg = "default"
local cfg_files_list = {"default"}
local last_keys = {}

local ui_prev_visible = false

local PALETTE = {
    { name = "Red", col = {1.0, 0.25, 0.25, 1.0} },
    { name = "Grn", col = {0.25, 0.95, 0.35, 1.0} },
    { name = "Blu", col = {0.25, 0.65, 1.0, 1.0} },
    { name = "Yel", col = {1.0, 0.90, 0.20, 1.0} },
    { name = "Cyn", col = {0.15, 0.95, 1.0, 1.0} },
    { name = "Mag", col = {1.0, 0.20, 0.85, 1.0} },
    { name = "Pnk", col = {1.0, 0.45, 0.75, 1.0} },
    { name = "Tur", col = {0.20, 0.90, 0.75, 1.0} },
    { name = "Wht", col = {1.0, 1.0, 1.0, 1.0} },
    { name = "Orn", col = {1.0, 0.55, 0.15, 1.0} }
}






_G.NixwareSyncVal = function(id, val)
    set_val(id, val)
end

pcall(function()
    if read_config_list then
        cfg_files_list = read_config_list()
    end
end)

local function draw_menu()
    boba_menu_open = ui.visible
    local now_t = tick()

    if not intro_done then
        local el = now_t - intro_start
        if el < 2.5 then
            local scx, scy = input.GetScreenCenter()
            local sw = scx * 2
            local sh = scy * 2
            local a = 1.0
            if el > 1.8 then
                a = math.max(0, (2.5 - el) / 0.7)
            elseif el < 0.4 then
                a = math.min(1.0, el / 0.4)
            end
            draw.RectFilled(0, 0, sw, sh, {0.02, 0.02, 0.03, a}, 0)
            local t = "Project Boba"
            local sub = "Vector Suite Active"
            local tw, _ = draw.GetTextSize(t, 30)
            tw = (type(tw) == "number" and tw) or 170
            local sw_txt, _ = draw.GetTextSize(sub, 13)
            sw_txt = (type(sw_txt) == "number" and sw_txt) or 120
            draw.Line(scx - 110, scy + 24, scx + 110, scy + 24, {0.25, 0.65, 1.0, a * 0.9}, 2)
            draw.Text(scx - math.floor(tw / 2) + 1, scy - 18 + 1, t, {0, 0, 0, a}, 30)
            draw.Text(scx - math.floor(tw / 2), scy - 18, t, {1.0, 1.0, 1.0, a}, 30)
            draw.Text(scx - math.floor(sw_txt / 2), scy + 34, sub, {0.7, 0.7, 0.75, a * 0.85}, 13)
        else
            intro_done = true
        end
    end

    local mx, my = input.GetMousePosition()
    mx = (type(mx) == "number" and mx) or 0
    my = (type(my) == "number" and my) or 0

    local lmb = input.IsKeyDown(0x01) or false
    local is_click = lmb and not ui.last_lmb

    local is_rainbow = (get_val("b_rainbow_mode", false) == true)
    local cur_theme_idx = get_val("b_menu_theme", 0) or 0
    local cur_theme_data = THEMES[cur_theme_idx + 1] or THEMES[1]

    local theme_col, theme_sub, theme_dim
    if is_rainbow then
        theme_col = hsv_to_rgb((now_t * 0.35) % 1.0, 0.85, 1.0)
        theme_sub = hsv_to_rgb((now_t * 0.35 + 0.38) % 1.0, 0.85, 1.0)
        theme_dim = { theme_sub[1] * 0.75, theme_sub[2] * 0.75, theme_sub[3] * 0.75, 1.0 }
    else
        theme_col = cur_theme_data.col
        theme_sub = { theme_col[1] * 0.88, theme_col[2] * 0.88, theme_col[3] * 0.88, 1.0 }
        theme_dim = { theme_col[1] * 0.70, theme_col[2] * 0.70, theme_col[3] * 0.70, 1.0 }
    end

    local is_hard = (get_val("b_hard_side", false) == true)
    local tr, tg, tb = theme_col[1], theme_col[2], theme_col[3]

    local main_bg_a = is_hard and 0.95 or 0.42
    local card_bg_a = is_hard and 0.96 or 0.38
    local side_bg_a = is_hard and 0.96 or 0.35
    local bar_bg_a  = is_hard and 0.98 or 0.50

    local bg_tint   = { 0.04 + tr * 0.08, 0.04 + tg * 0.08, 0.05 + tb * 0.08, main_bg_a }
    local card_tint = { 0.06 + tr * 0.09, 0.06 + tg * 0.09, 0.07 + tb * 0.09, card_bg_a }
    local side_tint = { 0.05 + tr * 0.08, 0.05 + tg * 0.08, 0.06 + tb * 0.08, side_bg_a }
    local bar_tint  = { 0.07 + tr * 0.12, 0.07 + tg * 0.12, 0.08 + tb * 0.12, bar_bg_a }

    local cur_toggle_vk = get_val("b_menu_key", 0x24) or 0x24

    if ui.binding_key then
        local specific_mods = {0xA1, 0xA0, 0xA3, 0xA2, 0xA5, 0xA4}
        local found_vk = nil
        for _, mvk in ipairs(specific_mods) do
            local is_down = input.IsKeyDown(mvk)
            if is_down and not last_keys[mvk] then
                found_vk = mvk
                break
            end
            last_keys[mvk] = is_down
        end
        if not found_vk then
            for vk = 0x08, 0xFE do
                if vk ~= 0x01 and vk ~= 0x02 and vk ~= 0x04 and vk ~= 0x10 and vk ~= 0x11 and vk ~= 0x12 then
                    local is_down = input.IsKeyDown(vk)
                    if is_down and not last_keys[vk] then
                        found_vk = vk
                        break
                    end
                    last_keys[vk] = is_down
                end
            end
        end
        if found_vk then
            set_val("b_menu_key", found_vk)
            cur_toggle_vk = found_vk
            ui.binding_key = false
            last_keys[found_vk] = true
            notify.Success("Menu Key", "Bound to " .. get_vk_name(found_vk), 2)
        end
    end

    local toggle_down = false
    if not ui.binding_key then
        toggle_down = input.IsKeyDown(cur_toggle_vk) or false
    end
    if toggle_down and not ui.last_toggle_key then
        ui.visible = not ui.visible
        boba_menu_open = ui.visible
    end
    ui.last_toggle_key = toggle_down

    if not ui.visible then
        if ui_prev_visible then
            ui_prev_visible = false
            pcall(function()
                local uis = game:GetService("UserInputService")
                if uis then
                    if Enum.OverrideMouseIconBehavior then
                        uis.OverrideMouseIconBehavior = Enum.OverrideMouseIconBehavior.None
                    end
                    uis.MouseBehavior = Enum.MouseBehavior.LockCenter
                    uis.MouseIconEnabled = false
                end
                local cas = game:GetService("ContextActionService")
                if cas then
                    cas:UnbindAction("BobaMenuSink")
                end
            end)
        end
        ui.last_lmb = lmb
        return
    end

    if not ui_prev_visible then
        ui_prev_visible = true
        pcall(function()
            local uis = game:GetService("UserInputService")
            if uis then
                uis.MouseBehavior = Enum.MouseBehavior.Default
                uis.MouseIconEnabled = true
                if Enum.OverrideMouseIconBehavior then
                    uis.OverrideMouseIconBehavior = Enum.OverrideMouseIconBehavior.ForceShow
                end
            end
            local cas = game:GetService("ContextActionService")
            if cas then
                cas:BindActionAtPriority("BobaMenuSink", function()
                    return Enum.ContextActionResult.Sink
                end, false, 10000, Enum.UserInputType.MouseButton1, Enum.UserInputType.MouseButton2, Enum.UserInputType.MouseButton3)
            end
        end)
    end

    local title_h = 21
    local px = ui.x
    local py = ui.y

    if is_click then
        if mx >= px and mx <= px + ui.w and my >= py and my <= py + title_h then
            ui.dragging = true
            ui.drag_ox = mx - px
            ui.drag_oy = my - py
        end
    end

    if ui.dragging then
        if lmb then
            ui.x = math.max(0, mx - ui.drag_ox)
            ui.y = math.max(0, my - ui.drag_oy)
            px = ui.x
            py = ui.y
        else
            ui.dragging = false
        end
    end

    draw.RectFilled(px, py, ui.w, ui.h, bg_tint, 0)
    draw.Rect(px, py, ui.w, ui.h, {0.02, 0.02, 0.02, 1.0}, 0, 1.5)

    draw.RectFilled(px, py, ui.w, title_h, bar_tint, 0)
    draw.Line(px, py + title_h, px + ui.w, py + title_h, {0.02, 0.02, 0.02, 1.0}, 1.0)

    draw.Text(px + 8, py + 3, "ProjectBoba", theme_col, 14)
    local cur_tab_title = (tabs[ui.tab + 1] and tabs[ui.tab + 1].label) or "Menu"
    draw.Text(px + 315, py + 3, "[ " .. cur_tab_title .. " ]", theme_col, 14)

    local close_btn_w = 20
    local close_x = px + ui.w - 22
    local close_y = py + 1
    local close_hov = mx >= close_x and mx <= close_x + close_btn_w and my >= close_y and my <= close_y + title_h - 2
    if is_click and close_hov then
        ui.visible = false
        boba_menu_open = false
    end
    draw.Text(close_x + 5, close_y + 2, "x", close_hov and {1.0, 0.4, 0.4, 1.0} or {0.6, 0.6, 0.6, 1.0}, 13)

    local side_x = px + 9
    local side_y = py + 30
    local side_w = 58
    local side_h = 481

    draw.RectFilled(side_x, side_y, side_w, side_h, side_tint, 0)
    draw.Rect(side_x, side_y, side_w, side_h, {0.02, 0.02, 0.02, 1.0}, 0, 1.5)

    for i, t in ipairs(tabs) do
        local tid = i - 1
        local tx = side_x + 2
        local ty = side_y + 10 + tid * 52
        local tw = 54
        local th = 49
        local active = (ui.tab == tid)
        local hov = mx >= tx and mx <= tx + tw and my >= ty and my <= ty + th

        draw.RectFilled(tx, ty, tw, th, {0.08, 0.08, 0.09, side_bg_a}, 0)
        if active then
            draw.RectFilled(tx, ty, 2, th, theme_col, 0)
            draw.Text(tx + 22, ty + 16, t.icon, theme_col, 16)
        else
            if hov then
                draw.RectFilled(tx, ty, tw, th, {0.15, 0.15, 0.15, 0.8}, 0)
            end
            draw.Text(tx + 22, ty + 16, t.icon, {0.55, 0.55, 0.55, 1.0}, 16)
        end

        if is_click and hov then
            ui.tab = tid
        end
    end

    local function draw_card(cx, cy, cw, ch, title)
        draw.RectFilled(cx, cy, cw, ch, card_tint, 0)
        draw.Rect(cx, cy, cw, ch, {0.02, 0.02, 0.02, 1.0}, 0, 1.5)

        draw.RectFilled(cx, cy, cw, 22, bar_tint, 0)
        draw.Line(cx, cy + 22, cx + cw, cy + 22, {0.02, 0.02, 0.02, 1.0}, 1.0)
        draw.Text(cx + 10, cy + 3, title, theme_col, 14)
    end

    local function draw_cycle(x, y, w, label, key, options, callback)
        local cur_idx = get_val(key, 0) or 0
        if cur_idx < 0 or cur_idx >= #options then cur_idx = 0 end
        local opt_text = options[cur_idx + 1] or options[1] or "Head"

        draw.Text(x, y + 2, label, theme_dim, 13)

        local btn_w = 90
        local btn_h = 20
        local bx = x + w - btn_w
        local by = y

        local is_hov = mx >= x and mx <= x + w and my >= by - 2 and my <= by + btn_h + 4
        local bg_col = is_hov and {0.08, 0.08, 0.11, 1.0} or {0.04, 0.04, 0.05, 1.0}

        draw.RectFilled(bx, by, btn_w, btn_h, bg_col, 0)
        draw.Rect(bx, by, btn_w, btn_h, is_hov and theme_col or {0.02, 0.02, 0.02, 1.0}, 0, 1.0)

        local tw, _ = draw.GetTextSize(opt_text, 12)
        tw = (type(tw) == "number" and tw) or (#opt_text * 6.5)
        local tx = bx + math.floor((btn_w - tw) / 2)
        draw.Text(tx, by + 3, opt_text, is_hov and theme_col or theme_sub, 12)

        if is_click and is_hov then
            local next_idx = (cur_idx + 1) % #options
            set_val(key, next_idx)
            if callback then callback(next_idx) end
        end
    end

local function draw_checkbox(x, y, label, key)
        local box_sz = 16
        local hov = mx >= x and mx <= x + 210 and my >= y and my <= y + box_sz + 4

        local is_on = (get_val(key, false) == true)
        if is_click and hov then
            is_on = not is_on
            set_val(key, is_on)
        end

        draw.RectFilled(x, y + 2, box_sz, box_sz, {0.04, 0.04, 0.05, 1.0}, 0)
        draw.Rect(x, y + 2, box_sz, box_sz, hov and theme_col or {0.02, 0.02, 0.02, 1.0}, 0, 1.0)

        if is_on then
            draw.Line(x + 3, y + 10, x + 7, y + 14, theme_col, 1.5)
            draw.Line(x + 7, y + 14, x + 13, y + 5, theme_col, 1.5)
        end

        draw.Text(x + 24, y + 2, label, is_on and theme_col or theme_dim, 13)
    end

    local function draw_slider(sid, x, y, w, label, key, min_val, max_val, fmt)
        local cur_val = get_val(key, min_val) or min_val
        draw.Text(x, y, label, theme_dim, 13)

        local val_str = string.format(fmt or "%.1f", cur_val)
        local vw, _ = draw.GetTextSize(val_str, 13)
        vw = (type(vw) == "number" and vw) or 30
        draw.Text(x + w - vw, y, val_str, theme_sub, 13)

        local trk_y = y + 18
        local trk_h = 4
        draw.RectFilled(x, trk_y, w, trk_h, {0.04, 0.04, 0.05, 1.0}, 0)
        draw.Rect(x, trk_y, w, trk_h, {0.02, 0.02, 0.02, 1.0}, 0, 1.0)

        local frac = math.max(0, math.min(1, (cur_val - min_val) / (max_val - min_val)))
        local fill_w = math.max(0, w * frac)
        if fill_w > 0 then
            draw.RectFilled(x, trk_y, fill_w, trk_h, theme_col, 0)
        end
        draw.RectFilled(x + fill_w - 2, trk_y - 2, 4, 8, theme_sub, 0)
        draw.Rect(x + fill_w - 2, trk_y - 2, 4, 8, {0.02, 0.02, 0.02, 1.0}, 0, 1.0)

        local s_hov = mx >= x - 2 and mx <= x + w + 2 and my >= trk_y - 4 and my <= trk_y + 10
        if is_click and s_hov then
            ui.active_slider = sid
        end

        if ui.active_slider == sid then
            if lmb then
                local n_frac = math.max(0, math.min(1, (mx - x) / w))
                local step = min_val + n_frac * (max_val - min_val)
                local nv = step
                if fmt and fmt:find("d") then
                    nv = math.floor(step + 0.5)
                else
                    nv = math.floor(step * 10 + 0.5) / 10
                end
                set_val(key, nv)
            else
                ui.active_slider = nil
            end
        end
    end

    local function draw_button(x, y, w, h, label, callback)
        local hov = mx >= x and mx <= x + w and my >= y and my <= y + h
        local bg = hov and {0.14, 0.15, 0.18, 0.9} or {0.06, 0.06, 0.08, 0.85}
        draw.RectFilled(x, y, w, h, bg, 0)
        draw.Rect(x, y, w, h, hov and theme_col or {0.02, 0.02, 0.02, 1.0}, 0, 1.0)

        local lw, _ = draw.GetTextSize(label, 13)
        lw = (type(lw) == "number" and lw) or 60
        local lx = x + math.floor((w - lw) / 2)
        draw.Text(lx, y + 4, label, hov and theme_col or theme_sub, 13)

        if is_click and hov then
            callback()
        end
    end

    local function draw_color_palette(x, y, w, color_id, callback)
        local cur_c = mc(color_id)
        local btn_w = math.floor((w - 16) / 5)
        local btn_h = 16
        for i, p in ipairs(PALETTE) do
            local col_idx = (i - 1) % 5
            local row_idx = math.floor((i - 1) / 5)
            local bx = x + col_idx * (btn_w + 4)
            local by = y + row_idx * 19
            local hov = mx >= bx and mx <= bx + btn_w and my >= by and my <= by + btn_h
            local is_sel = false
            if cur_c and p.col then
                local dr = math.abs((cur_c[1] or 0) - p.col[1])
                local dg = math.abs((cur_c[2] or 0) - p.col[2])
                local db = math.abs((cur_c[3] or 0) - p.col[3])
                if dr < 0.1 and dg < 0.1 and db < 0.1 then
                    is_sel = true
                end
            end

            draw.RectFilled(bx, by, btn_w, btn_h, p.col, 0)
            if is_sel then
                draw.Rect(bx - 1, by - 1, btn_w + 2, btn_h + 2, {1.0, 1.0, 1.0, 1.0}, 0, 1.5)
            elseif hov then
                draw.Rect(bx, by, btn_w, btn_h, {0.9, 0.9, 0.9, 0.8}, 0, 1.0)
            else
                draw.Rect(bx, by, btn_w, btn_h, {0.02, 0.02, 0.02, 1.0}, 0, 1.0)
            end

            if is_click and hov then
                pcall(function() menu.SetColor(color_id, p.col) end)
                if callback then callback(p.col) end
            end
        end
    end

    if ui.tab == 0 then
        local col1_x = px + 78
        draw_card(col1_x, py + 30, 236, 481, "Player Aimbot")
        draw_checkbox(col1_x + 12, py + 56, "Enable Aimbot", "b_aim")
        draw_cycle(col1_x + 12, py + 80, 212, "Aim Key", "b_aim_key", {"Right Click", "Left Click", "Left Alt", "Left Shift", "Auto"})
        draw_cycle(col1_x + 12, py + 104, 212, "Target Bone", "b_aim_bone", {"Head", "Chest", "Pelvis", "Closest"})
        draw_slider("s_aim_fov", col1_x + 12, py + 128, 212, "FOV", "b_aim_fov", 30, 800, "%d deg")
        draw_slider("s_aim_sm", col1_x + 12, py + 166, 212, "Smooth", "b_aim_smooth", 1.0, 20.0, "%.1f")
        draw_checkbox(col1_x + 12, py + 204, "Bullet Drop Prediction", "b_aim_pred")
        draw_checkbox(col1_x + 12, py + 228, "Velocity Lead", "b_aim_lead")
        draw_checkbox(col1_x + 12, py + 252, "Sticky Target Lock", "b_aim_lock")
        draw_checkbox(col1_x + 12, py + 276, "Team Check", "b_aim_team")
        draw_checkbox(col1_x + 12, py + 302, "Draw FOV Circle", "b_aim_fov_draw")
        draw_checkbox(col1_x + 12, py + 328, "Filled FOV Circle", "b_aim_fov_filled")
        draw.Text(col1_x + 12, py + 356, "FOV Color:", theme_sub, 12)
        draw_color_palette(col1_x + 12, py + 374, 212, "b_aim_fov", function(c)
            cfg.aim_fov_c = c
        end)

        local col2_x = px + 322
        draw_card(col2_x, py + 30, 236, 481, "Silent Aim")
        draw_checkbox(col2_x + 12, py + 56, "Enable Silent Aim", "b_silent")
        draw_cycle(col2_x + 12, py + 80, 212, "Silent Bone", "b_silent_bone", {"Head", "Chest", "Pelvis", "Closest", "Cycle"})
        draw_slider("s_sil_fov", col2_x + 12, py + 104, 212, "Silent FOV", "b_silent_fov", 30, 500, "%d deg")
        draw_checkbox(col2_x + 12, py + 142, "Multi-Point (Bone Fallback)", "b_silent_multipoint")
        draw_checkbox(col2_x + 12, py + 168, "Team Check", "b_silent_team")
        draw_checkbox(col2_x + 12, py + 214, "Draw Silent FOV", "b_silent_fov_draw")
        draw_checkbox(col2_x + 12, py + 238, "Filled FOV Circle", "b_silent_fov_filled")
        draw.Text(col2_x + 12, py + 262, "Silent FOV Color:", theme_sub, 12)
        draw_color_palette(col2_x + 12, py + 278, 212, "b_silent_fov", function(c)
            cfg.sil_fov_c = c
        end)

        local col3_x = px + 566
        draw_card(col3_x, py + 30, 240, 481, "NPC Aimbot")
        draw_checkbox(col3_x + 12, py + 56, "Enable NPC Aimbot", "b_npc_aim")
        draw_cycle(col3_x + 12, py + 80, 216, "NPC Bone", "b_npc_aim_bone", {"Head", "Chest", "Pelvis"})
        draw_slider("s_na_fov", col3_x + 12, py + 104, 216, "NPC FOV", "b_npc_aim_fov", 30, 500, "%d deg")
        draw_slider("s_na_sm", col3_x + 12, py + 142, 216, "NPC Smooth", "b_npc_aim_smooth", 1.0, 20.0, "%.1f")
        draw_checkbox(col3_x + 12, py + 180, "NPC Prediction", "b_npc_aim_pred")
        draw_checkbox(col3_x + 12, py + 204, "Draw NPC FOV", "b_npc_aim_fov_draw")
        draw_checkbox(col3_x + 12, py + 228, "Filled FOV Circle", "b_npc_aim_fov_filled")
        draw.Text(col3_x + 12, py + 252, "NPC FOV Color:", theme_sub, 12)
        draw_color_palette(col3_x + 12, py + 268, 216, "b_npc_aim_fov", function(c)
            cfg.na_fov_c = c
        end)

    elseif ui.tab == 1 then
        local col1_x = px + 78
        draw_card(col1_x, py + 30, 236, 481, "Player ESP")
        draw_checkbox(col1_x + 12, py + 60, "Enable Player ESP", "b_esp")
        draw_checkbox(col1_x + 12, py + 86, "Box ESP", "b_esp_box")
        draw_checkbox(col1_x + 12, py + 112, "Skeleton ESP", "b_esp_skel")
        draw_checkbox(col1_x + 12, py + 138, "Health Bar", "b_esp_hp")
        draw_checkbox(col1_x + 12, py + 164, "Name ESP", "b_esp_name")
        draw_checkbox(col1_x + 12, py + 190, "Distance ESP", "b_esp_dist")
        draw_checkbox(col1_x + 12, py + 216, "Weapon ESP", "b_esp_weapon")
        draw_checkbox(col1_x + 12, py + 242, "Snaplines", "b_esp_snap")
        draw_slider("s_esp_r", col1_x + 12, py + 270, 212, "Player Range (m)", "b_esp_range", 50, 5000, "%d m")

        draw.Text(col1_x + 12, py + 312, "Box Color:", theme_sub, 12)
        draw_color_palette(col1_x + 12, py + 328, 212, "b_esp_box", nil)
        draw.Text(col1_x + 12, py + 370, "Snapline Color:", theme_sub, 12)
        draw_color_palette(col1_x + 12, py + 386, 212, "b_esp_snap", nil)

        local col2_x = px + 322
        draw_card(col2_x, py + 30, 236, 481, "NPC & Extraction")
        draw_checkbox(col2_x + 12, py + 60, "Enable NPC ESP", "b_npc")
        draw_checkbox(col2_x + 12, py + 86, "NPC Box", "b_npc_box")
        draw_checkbox(col2_x + 12, py + 112, "NPC Health", "b_npc_hp")
        draw_checkbox(col2_x + 12, py + 138, "NPC Name", "b_npc_name")
        draw_checkbox(col2_x + 12, py + 164, "NPC Skeleton", "b_npc_skel")
        draw_slider("s_npc_r", col2_x + 12, py + 192, 212, "NPC Range (m)", "b_npc_range", 50, 2000, "%d m")
        draw_checkbox(col2_x + 12, py + 232, "Extraction Points", "b_extract")
        draw_slider("s_ext_r", col2_x + 12, py + 258, 212, "Extract Range (m)", "b_extract_range", 50, 4000, "%d m")
        draw_checkbox(col2_x + 12, py + 298, "Hazard Zones", "b_hazard")
        draw_slider("s_haz_r", col2_x + 12, py + 324, 212, "Hazard Range (m)", "b_hazard_range", 50, 2000, "%d m")

        local col3_x = px + 566
        draw_card(col3_x, py + 30, 240, 481, "Containers & World Loot")
        draw_checkbox(col3_x + 12, py + 60, "Containers ESP", "b_cont")
        draw_checkbox(col3_x + 12, py + 86, "Show Container Items", "b_cont_items")
        draw_slider("s_cont_r", col3_x + 12, py + 114, 216, "Container Range", "b_cont_range", 10, 500, "%d m")
        draw_checkbox(col3_x + 12, py + 154, "World Loot ESP", "b_loot")
        draw_slider("s_loot_r", col3_x + 12, py + 180, 216, "Loot Range", "b_loot_range", 10, 500, "%d m")
        draw_checkbox(col3_x + 12, py + 220, "Corpses ESP", "b_corpse")
        draw_checkbox(col3_x + 12, py + 246, "Show Corpse Items", "b_corpse_items")
        draw_slider("s_corp_r", col3_x + 12, py + 274, 216, "Corpse Range", "b_corpse_range", 10, 600, "%d m")
        draw_checkbox(col3_x + 12, py + 314, "Quest Items ESP", "b_quest")
        draw_slider("s_qst_r", col3_x + 12, py + 340, 216, "Quest Range", "b_quest_range", 10, 1000, "%d m")

    elseif ui.tab == 2 then
        local col1_x = px + 78
        draw_card(col1_x, py + 30, 355, 481, "Player Chams")
        draw_checkbox(col1_x + 12, py + 60, "Enable Player Chams", "b_chams")
        draw_checkbox(col1_x + 12, py + 90, "Visible Only (Vis Check)", "b_chams_vc")

        draw.Text(col1_x + 12, py + 130, "Visible Chams Color:", theme_sub, 12)
        draw_color_palette(col1_x + 12, py + 150, 331, "b_chams_vis", function(c)
            cfg.chams_vc = c
        end)

        draw.Text(col1_x + 12, py + 204, "Occluded Chams Color:", theme_sub, 12)
        draw_color_palette(col1_x + 12, py + 224, 331, "b_chams_occ", function(c)
            cfg.chams_oc = c
        end)

        local col2_x = px + 445
        draw_card(col2_x, py + 30, 361, 481, "Weapon Chams")
        draw_checkbox(col2_x + 12, py + 60, "Weapon Chams (Work in Progress)", "b_wep_chams")
        draw_checkbox(col2_x + 12, py + 90, "Pulse Animation", "b_wep_chams_pulse")

        draw.Text(col2_x + 12, py + 130, "Weapon Chams Color:", theme_sub, 12)
        draw_color_palette(col2_x + 12, py + 150, 337, "b_wep_chams", function(c)
            cfg.wep_chams_c = c
        end)

    elseif ui.tab == 3 then
        local col1_x = px + 78
        draw_card(col1_x, py + 30, 236, 481, "Inventory & Item Checker")
        draw_checkbox(col1_x + 12, py + 60, "Inventory Viewer", "b_inspect")
        draw_checkbox(col1_x + 12, py + 86, "Show Weapons", "b_inv_weap")
        draw_checkbox(col1_x + 12, py + 112, "Show Armor", "b_inv_armor")
        draw_checkbox(col1_x + 12, py + 138, "Show Special Items", "b_inv_special")
        draw_checkbox(col1_x + 12, py + 164, "Show Misc Items", "b_inv_misc")
        draw_checkbox(col1_x + 12, py + 196, "Server Loot Finder (SLF)", "b_slf")
        draw_checkbox(col1_x + 12, py + 222, "Boss Tracker", "b_boss")
        draw_checkbox(col1_x + 12, py + 248, "Mod Alert", "b_mod_alert")

        local col2_x = px + 322
        draw_card(col2_x, py + 30, 236, 481, "FOV Changer & World")
        draw_checkbox(col2_x + 12, py + 60, "FOV Changer (Not Fully Working)", "b_fov_changer")
        draw_slider("s_fov_v", col2_x + 12, py + 86, 212, "Field of View", "b_fov_val", 70, 110, "%d deg")
        draw_checkbox(col2_x + 12, py + 124, "Preserve Sniper Zoom (<35°)", "b_fov_ads_safe")
        draw_checkbox(col2_x + 12, py + 154, "Remove Grass (No Grass)", "b_nograss")
        draw_checkbox(col2_x + 12, py + 180, "Claymore ESP", "b_claymore")
        draw_checkbox(col2_x + 12, py + 206, "Car ESP", "b_car")

        local col3_x = px + 566
        draw_card(col3_x, py + 30, 240, 481, "Skin Changer")
        draw_checkbox(col3_x + 12, py + 60, "Skin Changer (Work in Progress)", "b_skin_enable")
        draw_button(col3_x + 12, py + 92, 216, 26, "Apply Selected Skins", function()
            pcall(function()
                if apply_skins_now then apply_skins_now() end
                notify.Success("Skins", "Applied selected skins", 3)
            end)
        end)
        draw_button(col3_x + 12, py + 126, 216, 24, "Knife: Karambit", function()
            pcall(function() menu.Set("b_skin_knife", 1) end)
            notify.Success("Knife", "Set to Karambit", 2)
        end)
        draw_button(col3_x + 12, py + 156, 216, 24, "Knife: Butterfly", function()
            pcall(function() menu.Set("b_skin_knife", 3) end)
            notify.Success("Knife", "Set to Butterfly", 2)
        end)
        draw_button(col3_x + 12, py + 186, 216, 24, "Gun: M4 Devil", function()
            pcall(function() menu.Set("b_skin_gun", 5) end)
            notify.Success("Gun", "Set to M4 Devil", 2)
        end)
        draw_button(col3_x + 12, py + 216, 216, 24, "Gun: AKM Banana", function()
            pcall(function() menu.Set("b_skin_gun", 1) end)
            notify.Success("Gun", "Set to AKM Banana", 2)
        end)
        draw_button(col3_x + 12, py + 246, 216, 24, "Armor: Crusader Pack", function()
            pcall(function() menu.Set("b_skin_armor", 1) end)
            notify.Success("Armor", "Set to Crusader", 2)
        end)

    elseif ui.tab == 4 then
        local col1_x = px + 78
        draw_card(col1_x, py + 30, 355, 481, "Config & Menu Settings")

        draw.Text(col1_x + 12, py + 56, "Config Name:", theme_sub, 12)

        local ibx = col1_x + 12
        local iby = py + 72
        local ibw = 331
        local ibh = 22
        local ib_hov = mx >= ibx and mx <= ibx + ibw and my >= iby and my <= iby + ibh
        if is_click then
            cfg_focus = ib_hov
                    end

        if cfg_focus then
            for vk = 0x41, 0x5A do
                local down = input.IsKeyDown(vk)
                if down and not last_keys[vk] then
                    cfg_name_buf = cfg_name_buf .. string.char(vk + 32)
                end
                last_keys[vk] = down
            end
            for vk = 0x30, 0x39 do
                local down = input.IsKeyDown(vk)
                if down and not last_keys[vk] then
                    cfg_name_buf = cfg_name_buf .. string.char(vk)
                end
                last_keys[vk] = down
            end
            local bs_down = input.IsKeyDown(0x08)
            if bs_down and not last_keys[0x08] and #cfg_name_buf > 0 then
                cfg_name_buf = cfg_name_buf:sub(1, -2)
            end
            last_keys[0x08] = bs_down
            local sp_down = input.IsKeyDown(0x20) or input.IsKeyDown(0xBD)
            if sp_down and not last_keys[0x20] then
                cfg_name_buf = cfg_name_buf .. "_"
            end
            last_keys[0x20] = sp_down
        end

        draw.RectFilled(ibx, iby, ibw, ibh, cfg_focus and {0.14, 0.15, 0.18, 1.0} or {0.05, 0.05, 0.07, 1.0}, 0)
        draw.Rect(ibx, iby, ibw, ibh, cfg_focus and theme_col or {0.02, 0.02, 0.02, 1.0}, 0, 1.0)
        draw.Text(ibx + 6, iby + 3, cfg_name_buf .. (cfg_focus and "_" or ""), theme_col, 12)

        draw_button(col1_x + 12, py + 98, 331, 22, "Create / Save Config", function()
            local cname = (cfg_name_buf ~= "") and cfg_name_buf or (selected_cfg ~= "" and selected_cfg or "default")
            save_config(cname)
            local exists = false
            for _, cn in ipairs(cfg_files_list) do
                if cn == cname then exists = true; break end
            end
            if not exists then
                table.insert(cfg_files_list, cname)
                write_config_list(cfg_files_list)
            end
            selected_cfg = cname
            cfg_name_buf = cname
        end)

        draw_button(col1_x + 12, py + 124, 105, 22, "Load Config", function()
            local cname = (selected_cfg ~= "") and selected_cfg or "default"
            load_config(cname)
            cfg_name_buf = cname
        end)

        draw_button(col1_x + 122, py + 124, 105, 22, "Delete Config", function()
            local new_list = {}
            for _, cn in ipairs(cfg_files_list) do
                if cn ~= selected_cfg then
                    table.insert(new_list, cn)
                end
            end
            if #new_list == 0 then new_list = {"default"} end
            cfg_files_list = new_list
            write_config_list(cfg_files_list)
            selected_cfg = cfg_files_list[1]
            cfg_name_buf = selected_cfg
            notify.Warning("Config Removed", selected_cfg, 3)
        end)

        draw_button(col1_x + 232, py + 124, 111, 22, "Reset All", function()
            if _G.ResetAllBobaOptions then
                _G.ResetAllBobaOptions()
                notify.Success("Reset", "All options reset to default", 3)
            end
        end)

        draw.Text(col1_x + 12, py + 150, "Saved Configurations:", theme_sub, 12)

        local list_x = col1_x + 12
        local list_y = py + 164
        local list_w = 331
        local list_h = 96
        draw.RectFilled(list_x, list_y, list_w, list_h, {0.05, 0.05, 0.07, 0.9}, 0)
        draw.Rect(list_x, list_y, list_w, list_h, {0.02, 0.02, 0.02, 1.0}, 0, 1.0)

        for i, cname in ipairs(cfg_files_list) do
            local ry = list_y + 2 + (i - 1) * 20
            if ry + 18 <= list_y + list_h then
                local is_sel = (selected_cfg == cname)
                local r_hov = mx >= list_x + 2 and mx <= list_x + list_w - 2 and my >= ry and my <= ry + 18

                if is_sel then
                    draw.RectFilled(list_x + 2, ry, list_w - 4, 18, {theme_col[1], theme_col[2], theme_col[3], 0.35}, 0)
                    draw.Text(list_x + 8, ry + 2, ">  " .. cname, theme_col, 12)
                else
                    if r_hov then
                        draw.RectFilled(list_x + 2, ry, list_w - 4, 18, {0.14, 0.15, 0.18, 0.6}, 0)
                    end
                    draw.Text(list_x + 8, ry + 2, "   " .. cname, theme_dim, 12)
                end

                if is_click and r_hov then
                    selected_cfg = cname
                    cfg_name_buf = cname
                end
            end
        end

        draw_checkbox(col1_x + 12, py + 274, "Hard Side", "b_hard_side")
        draw_checkbox(col1_x + 183, py + 274, "Rainbow Mode", "b_rainbow_mode")

        draw.Text(col1_x + 12, py + 304, "Menu Toggle Key:", theme_sub, 12)
        local key_btn_text = ui.binding_key and "[Press Any Key...]" or ("Toggle Key: [ " .. get_vk_name(cur_toggle_vk) .. " ]")
        draw_button(col1_x + 12, py + 320, 331, 22, key_btn_text, function()
            ui.binding_key = not ui.binding_key
        end)

        draw.Text(col1_x + 12, py + 348, "Menu Theme & Font Color:", theme_sub, 12)
        for i, t in ipairs(THEMES) do
            local tid = i - 1
            local col_idx = (i - 1) % 5
            local row_idx = math.floor((i - 1) / 5)
            local tx = col1_x + 12 + col_idx * (62 + 5)
            local ty = py + 364 + row_idx * 23
            local tw = 62
            local th = 20
            local is_cur = (cur_theme_idx == tid)
            local hov = mx >= tx and mx <= tx + tw and my >= ty and my <= ty + th

            draw.RectFilled(tx, ty, tw, th, is_cur and {0.18, 0.19, 0.22, 1.0} or {0.06, 0.06, 0.08, 0.9}, 0)
            draw.Rect(tx, ty, tw, th, is_cur and t.col or (hov and t.col or {0.02, 0.02, 0.02, 1.0}), 0, is_cur and 1.5 or 1.0)

            local nw, _ = draw.GetTextSize(t.name, 11)
            nw = (type(nw) == "number" and nw) or 30
            local nx = tx + math.floor((tw - nw) / 2)
            draw.Text(nx, ty + 3, t.name, is_cur and t.col or (hov and t.col or {0.65, 0.65, 0.65, 1.0}), 11)

            if is_click and hov then
                set_val("b_menu_theme", tid)
            end
        end

        draw_button(col1_x + 12, py + 420, 331, 22, "Reset UI Position", function()
            ui.x = 100
            ui.y = 60
        end)

        local col2_x = px + 445
        draw_card(col2_x, py + 30, 361, 481, "Crosshair")
        draw_checkbox(col2_x + 12, py + 60, "Enable Crosshair", "b_cross")
        draw_slider("s_cr_sz", col2_x + 12, py + 84, 337, "Crosshair Size", "b_cross_sz", 2, 30, "%d px")
        draw_slider("s_cr_gp", col2_x + 12, py + 116, 337, "Crosshair Gap", "b_cross_gap", 0, 20, "%d px")
        draw_slider("s_cr_th", col2_x + 12, py + 148, 337, "Crosshair Thickness", "b_cross_thick", 1, 6, "%d px")
        draw_checkbox(col2_x + 12, py + 180, "Spin Animation", "b_cross_spin")
        draw_slider("s_cr_spn", col2_x + 12, py + 204, 337, "Spin Speed", "b_cross_spin_spd", 1, 20, "%d")
        draw_checkbox(col2_x + 12, py + 236, "Pulse Animation", "b_cross_pulse")
        draw_slider("s_cr_pls", col2_x + 12, py + 260, 337, "Pulse Speed", "b_cross_pulse_spd", 1, 20, "%d")

        draw.Text(col2_x + 12, py + 292, "Crosshair Color:", theme_sub, 12)
        draw_color_palette(col2_x + 12, py + 308, 337, "b_cross", function(c)
            cfg.cross_c = c
        end)

        draw.Text(col2_x + 12, py + 356, "Crosshair Styles:", theme_sub, 12)
        draw_button(col2_x + 12, py + 374, 163, 24, "Classic Cross", function()
            set_val("b_cross_style", 0)
        end)
        draw_button(col2_x + 186, py + 374, 163, 24, "Center Dot", function()
            set_val("b_cross_style", 1)
        end)
        draw_button(col2_x + 12, py + 402, 163, 24, "Circle Outline", function()
            set_val("b_cross_style", 2)
        end)
        draw_button(col2_x + 186, py + 402, 163, 24, "T-Shape Cross", function()
            set_val("b_cross_style", 3)
        end)
        draw_button(col2_x + 12, py + 430, 163, 24, "Arrow / Chevron", function()
            set_val("b_cross_style", 4)
        end)
        draw_button(col2_x + 186, py + 430, 163, 24, "Circle + Cross", function()
            set_val("b_cross_style", 5)
        end)
    end

    ui.last_lmb = lmb
end

draw_nixware_menu = draw_menu
end


_G.on_frame = function()
local pkey = mk("b_panic")
if pkey ~= 0 and input.IsKeyDown(pkey) then
if not panic_held then
    panic_held = true
    do_panic()
end
else
panic_held = false
end

if panic_on then return end

pcall(run_fov_changer)

pcall(run_wep_chams)

pcall(auto_apply_skins)

frame_players = entity.GetPlayers() or {}

pcall(draw_player_esp)
pcall(draw_npc_esp)
pcall(draw_world_esp)

pcall(run_player_aim)
pcall(run_npc_aim)
pcall(run_silent_aim)

pcall(draw_watermark)
pcall(draw_crosshair)
pcall(draw_inventory)
pcall(draw_claymores)
pcall(draw_cars)
pcall(draw_radar)
pcall(draw_hitmarker)
pcall(draw_corpse_markers)
pcall(draw_boss_panel)
pcall(draw_mod_alert)
pcall(draw_slf_panel)
local m_ok, m_err = pcall(draw_nixware_menu)
if not m_ok and m_err then
    print("[BOBA MENU ERROR] " .. tostring(m_err))
end
end
_G.OnFrame = _G.on_frame
_G.onFrame = _G.on_frame


thread.Create(scan_containers, 15000)
thread.Create(scan_world_items, 10000)
thread.Create(scan_quests, 20000)
thread.Create(scan_npcs, 3500)
thread.Create(scan_players, 5000)
thread.Create(scan_extracts, 30000)
thread.Create(scan_hazards, 20000)
thread.Create(scan_claymores, 10000)
thread.Create(scan_cars, 10000)

thread.Create(apply_world_mods, 5000)

thread.Create(update_bosses, 2500)
thread.Create(update_mod_check, 2500)
thread.Create(slf_scan, 3000)
thread.Create(cache_cfg, 1500)


OnPlayerAdded = function(player)
if STAFF_IDS[player.UserId] then
notify.Warning("STAFF JOINED", player.Name, 10)
end
end

silent_ok = false





notify.Success("BOBA loaded", "Project Delta Suite")
print("[BOBA] loaded — " .. entity.GetPlayerCount() .. " players online")
pcall(function()
    local act = read_active_cfg and read_active_cfg() or "default"
    selected_cfg = act
    cfg_name_buf = act
    load_config(act)
end)
