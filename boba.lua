
if thread and thread.StopAll then
    pcall(thread.StopAll)
end
if _G.boba_connections then
    for _, conn in ipairs(_G.boba_connections) do
        pcall(function() conn:Disconnect() end)
    end
end
_G.boba_connections = {}

local save_config, load_config, apply_skins_now, auto_apply_skins, is_gun_equipped, boba_store, boba_colors

if type(tick) ~= "function" then
    tick = function()
        if utility and utility.GetTime then return utility.GetTime() end
        if utility and utility.GetTickCount then return utility.GetTickCount() / 1000 end
        if os and os.clock then return os.clock() end
        if os and os.time then return os.time() end
        return 0
    end
end

boba_store = {
    b_aim = false,
    b_aim_key = 0x02,
    b_npc_aim_key = 0x02,
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
    b_no_recoil = false,
    b_recoil_reduc = 70,

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

    b_loadout_esp = false,
    b_loadout_sz = 38,
    b_loadout_x = 420,
    b_loadout_y = 120,

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
    b_cont_filter = 0,
    b_cont_range = 500,
    b_loot = false,
    b_loot_range = 400,
    b_loot_filter = 0,
    b_corpse = false,
    b_corpse_op_only = false,
    b_corpse_items = false,
    b_corpse_range = 500,
    b_quest = false,
    b_quest_range = 800,
    b_extract = false,
    b_extract_range = 3000,
    b_hazard = false,
    b_hazard_range = 1500,
    b_nograss = false,
    b_remove_foliage = false,
    b_bullet_tracers = false,
    b_bullet_tracers_c = {0.25, 0.65, 1.0, 1.0},
    b_tracer_duration = 1.0,
    b_hit_logs = false,
    b_hit_log_duration = 4.0,

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
    b_radar_rot = false,
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
    b_mod_alert = false,
    b_mod_mode = 1,
    b_cheater_finder = false,

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

boba_colors = {
    b_bullet_tracers = {1.0, 0.8, 0, 0.8},
    b_bullet_tracer_c = {1.0, 0.8, 0, 0.8},
    b_esp_box = {1, 0.3, 0.3, 1},
    b_esp_box_c = {1, 0.3, 0.3, 1},
    b_esp_skel = {1, 1, 1, 1},
    b_esp_skel_c = {1, 1, 1, 1},
    b_esp_name = {1, 1, 1, 1},
    b_esp_name_c = {1, 1, 1, 1},
    b_esp_hp = {0.2, 1, 0.2, 1},
    b_esp_hp_c = {0.2, 1, 0.2, 1},
    b_esp_dist = {0.7, 0.7, 0.7, 1},
    b_esp_dist_c = {0.7, 0.7, 0.7, 1},
    b_esp_weapon = {1, 0.7, 0.3, 1},
    b_esp_weapon_c = {1, 0.7, 0.3, 1},
    b_esp_armor = {0.6, 0.85, 1, 1},
    b_esp_armor_c = {0.6, 0.85, 1, 1},
    b_esp_snap = {0.4, 0.7, 1.0, 1.0},
    b_esp_snap_c = {0.4, 0.7, 1.0, 1.0},
    b_esp_vis_tag = {0.15, 1, 0.25, 1},
    b_esp_vis_tag_c = {0.15, 1, 0.25, 1},
    b_esp_staff = {1, 0.2, 1, 1},
    b_esp_staff_c = {1, 0.2, 1, 1},
    b_esp_hvt = {1, 0.85, 0.2, 1},
    b_esp_hvt_c = {1, 0.85, 0.2, 1},
    b_chams_vis = {0.0, 1.0, 0.3, 0.8},
    b_chams_occ = {1.0, 0.25, 0.25, 0.8},
    b_npc_box = {1, 0.5, 0.2, 1},
    b_npc_box_c = {1, 0.5, 0.2, 1},
    b_npc_name = {1, 0.8, 0.4, 1},
    b_npc_name_c = {1, 0.8, 0.4, 1},
    b_npc_skel = {1, 0.6, 0.3, 0.8},
    b_npc_skel_c = {1, 0.6, 0.3, 0.8},
    b_npc_hp = {0.2, 1, 0.2, 1},
    b_npc_hp_c = {0.2, 1, 0.2, 1},
    b_npc_dist = {0.7, 0.7, 0.7, 1},
    b_npc_dist_c = {0.7, 0.7, 0.7, 1},
    b_cont = {0.2, 0.8, 1, 1},
    b_cont_c = {0.2, 0.8, 1, 1},
    b_cont_items = {0.85, 0.85, 0.85, 1},
    b_cont_items_c = {0.85, 0.85, 0.85, 1},
    b_loot = {0.4, 1, 0.4, 1},
    b_loot_c = {0.4, 1, 0.4, 1},
    b_corpse = {0.8, 0.2, 0.2, 1},
    b_corpse_c = {0.8, 0.2, 0.2, 1},
    b_corpse_items = {0.85, 0.85, 0.85, 1},
    b_corpse_items_c = {0.85, 0.85, 0.85, 1},
    b_quest = {1, 0.85, 0.2, 1},
    b_quest_c = {1, 0.85, 0.2, 1},
    b_extract = {0.2, 1, 0.5, 1},
    b_extract_c = {0.2, 1, 0.5, 1},
    b_hazard = {1, 0.3, 0.1, 1},
    b_hazard_c = {1, 0.3, 0.1, 1},
    b_cross = {0, 1, 0, 1},
    b_cross_c = {0, 1, 0, 1},
    b_hitmarker = {1, 1, 1, 1},
    b_hitmarker_c = {1, 1, 1, 1},
    b_hit_logs = {0.25, 0.65, 1.0, 1.0},
    b_hit_logs_c = {0.25, 0.65, 1.0, 1.0},
    b_inspect = {0.4, 0.8, 1, 1},
    b_inspect_c = {0.4, 0.8, 1, 1},
    b_loadout_c = {0.4, 0.8, 1, 1},
    b_claymore = {1, 0.2, 0.2, 1},
    b_claymore_c = {1, 0.2, 0.2, 1},
    b_car = {0.2, 0.6, 1, 1},
    b_car_c = {0.2, 0.6, 1, 1},
    b_corpse_x = {1, 0, 0, 1},
    b_aim_fov = {1, 1, 1, 0.25},
    b_silent_fov = {1, 0.8, 0.2, 0.2},
    b_npc_aim_fov = {1, 0.6, 0.2, 0.3},
    b_aim_fov_c = {1, 1, 1, 0.25},
    b_silent_fov_c = {1, 0.8, 0.2, 0.2},
    b_npc_aim_fov_c = {1, 0.6, 0.2, 0.3}
}

if type(menu) ~= "table" then menu = {} end
local orig_m_get = menu.Get
local orig_m_set = menu.Set
local orig_m_gc = menu.GetColor
local orig_m_sc = menu.SetColor
local orig_m_gk = menu.GetKey
local orig_m_sk = menu.SetKey

menu.Get = function(id)
    if orig_m_get then
        local ok, v = pcall(orig_m_get, id)
        if ok and v ~= nil then return v end
    end
    if boba_store and boba_store[id] ~= nil then return boba_store[id] end
    return false
end

menu.Set = function(id, val)
    if boba_store then boba_store[id] = val end
    if orig_m_set then pcall(orig_m_set, id, val) end
end

menu.GetColor = function(id)
    if orig_m_gc then
        local ok, c = pcall(orig_m_gc, id)
        if ok and c ~= nil and type(c) == "table" and #c >= 3 then return c end
    end
    if boba_colors and boba_colors[id] ~= nil then return boba_colors[id] end
    return {1, 1, 1, 1}
end

menu.SetColor = function(id, col)
    if boba_colors then boba_colors[id] = col end
    if orig_m_sc then pcall(orig_m_sc, id, col) end
end

menu.GetKey = function(id)
    if orig_m_gk then
        local ok, k = pcall(orig_m_gk, id)
        if ok and k ~= nil and k ~= 0 then return k end
    end
    if boba_store and boba_store[id] ~= nil and type(boba_store[id]) == "number" then return boba_store[id] end
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

local SKEL_R6 = {
{"Head","Torso"},
{"Torso","Left Arm"}, {"Torso","Right Arm"},
{"Torso","Left Leg"}, {"Torso","Right Leg"}
}

local BONE_MAP = {
[0] = "Head", [1] = "UpperTorso", [2] = "LowerTorso"
}

local GRAY  = {0.6, 0.6, 0.6, 1}
local WHITE = {1, 1, 1, 1}
local RED   = {1, 0.2, 0.2, 1}
local GREEN = {0.2, 1, 0.2, 1}
-- (colors packed)

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
local GRAVITY_MS2 = 80.0 * 0.28

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
"truck", "jeep", "vehicle", "car", "buggy", "btr", "tank", "boat",
"sedan", "suv", "motorcycle", "bike", "quad", "atv", "heli", "helicopter",
"plane", "bmp", "tigr", "ural", "tractor", "van", "bus", "apc", "carspawner"
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
SerumGreen="special", SerumPurple="special",
SerumRed="special", SerumYellow="special",
ImmunsterReactor="special",
GiftTier1="special", GiftTier2="special", GiftTier3="special",
Rubles="special",
QuadNVG="special", ONV9="special",
}

local function get_item_category(name)
if not name then return "misc" end
if ITEM_CAT[name] then return ITEM_CAT[name] end
local lower = name:lower()
local cat = "misc"
if lower:find("gun") or lower:find("rifle") or lower:find("pistol")
or lower:find("smg") or lower:find("sniper") or lower:find("shotgun") then
cat = "weapon"
elseif lower:find("armor") or lower:find("vest") or lower:find("helmet")
or lower:find("plate") or lower:find("visor")
or lower:find("pants") or lower:find("shirt") or lower:find("glove")
or lower:find("backpack") or lower:find("mask") or lower:find("hood")
or lower:find("ghillie") then
cat = "armor"
elseif lower:find("key") or lower:find("card") or lower:find("gold")
or lower:find("plush") or lower:find("serum") or lower:find("gift")
or lower:find("gpu") or lower:find("cpu") or lower:find("hdd")
or lower:find("ssd") or lower:find("ram") or lower:find("token")
or lower:find("crown") or lower:find("statue") or lower:find("ring")
or lower:find("ticket") or lower:find("intel") or lower:find("document")
or lower:find("artifact") or lower:find("diamond") or lower:find("ruby")
or lower:find("emerald") or lower:find("nvg") or lower:find("replica") then
cat = "special"
end
ITEM_CAT[name] = cat
return cat
end

local OP_LOOT_MAP = {
AKM=true, AKMN=true, PKM=true, AsVal=true, FAL=true,
M4=true, SVD=true, Mosin=true, R700=true, RPG7=true,
Groza=true, MP5SD=true, Saiga12=true, ADAR15=true,
FlareGun=true, SPSh44=true, AnarchyTomahawk=true,
ButterflyKnife=true, ButterflyKnifeZenith=true, Cutlass=true,
FlipKnifeShark=true, Greatsword=true, IceAxe=true,
IceDagger=true, Karambit=true, Kukri=true, Longsword=true,
M9Fade=true, M9XR7=true, PlasmaNinjato=true, Scythe=true,
GoldenDV2=true, RealGoldenDV2=true, GoldenMakarov=true,
Altyn=true, AltynVisor=true, ScavKingHelmet=true, ScavKingVest=true,
["6B43"]=true, IOTV4=true, DozerArmor=true, FastMT=true,
FastVisor=true, MaskaVisor=true, QuadNVG=true, TitanShield=true, HSPV=true,
DAGR=true,
AntonPlush=true, DozerPlush=true, EnzoPlush=true, WhisperPlush=true,
GoldenTicket=true, GPU=true, CPU=true, SSD=true, RAM=true,
Gold50g=true, GoldSkull=true, GoldWatch=true, SolterStatue=true,
Matryoshka=true, Teapot=true, WeddingRing=true, CatToken=true,
InflatedCrown=true, MikeShades=true, ThermalModule=true, Reapir=true,
Defib=true, PortableConsole=true, Smartphone=true, Radio=true,
GiftTier1=true, GiftTier2=true, GiftTier3=true, Rubles=true,
RedCard=true, BlueCard=true, OrangeCard=true, EVACKey=true,
FactoryGarageKey=true, FrigateKey=true, LighthouseKey=true, PoolKey=true,
AirfieldTunnelsKey=true, GallerySecurityKey=true, CraneKey=true,
HydroBasementKey=true, DormA211Key=true, DormB203Key=true, B05Key=true,
ATCKey=true, Apartment13Key=true, Apartment21Key=true, CitySubstationtKey=true,
FuelingStationKey=true, VillageKey=true, Villa1Key=true,
SerumGreen=true, SerumPurple=true, SerumRed=true, SerumYellow=true,
ImmunsterReactor=true
}

local OP_CACHE = {}
local GOOD_CACHE = {}

local function is_mag_or_trash(name)
if not name or name == "" then return true end
local low = name:lower()
if low:find("keychain") or low:find("estonian") or low:find("fabric") then return true end
if low == "map" or low:find("map") then return true end
if low:find("mag") or low:find("drum") or low:find("ammobox") or low:match("%d+rnd") then return true end
return false
end

local function is_op_loot(name)
if not name or name == "" then return false end
if OP_CACHE[name] ~= nil then return OP_CACHE[name] end
local base = name:match("^(.-)%s*x%d+$") or name
if is_mag_or_trash(base) then
    OP_CACHE[name] = false
    return false
end
if OP_LOOT_MAP[base] then
    OP_CACHE[name] = true
    return true
end
local low = base:lower()
local res = (low:find("plush") or low:find("card") or low:find("gold") or low:find("ticket") or low:find("gpu") or low:find("dagr")) and true or false
OP_CACHE[name] = res
return res
end

local TRASH_ITEMS = {
Bandage=true, WoundDressing=true, Rags=true,
Beans=true, ChocolateBar=true, Jerky=true, WaterBottle=true,
BloxyCola=true, CatfrogSoda=true, KevCola=true, ResKola=true,
CondensedMilk=true, Tortilla=true,
Nails=true, Bolts=true, Nuts=true, DuctTape=true, SuperGlue=true,
Soap=true, MatchBox=true, LightBulb=true, Wrench=true,
FlatScrewdriver=true, PH2Screwdriver=true, SteelPipe=true,
Planks=true, MetalChunks=true, Gunpowder=true, AABattery=true,
Cologne=true, NaCl=true, GP5Filter=true, Sandbag=true, Barricade=true,
KeyChain=true, EstonianBorderMap=true, Map=true,
AramidFabric=true, CottonFabric=true, LinenFabric=true, RipstopFabric=true
}

local CORPSE_OP_ITEMS = {
    -- Ranged Weapons
    AsVal=true, ADAR15=true, TFZ0=true, MP443=true, PPSH41=true, SVD=true, PKM=true,
    Mosin=true, Makarov=true, AKM=true, TT33=true, IZh12=true, MP5SD=true, VZ61=true,
    Saiga12=true, TFZ98S=true, IZh81=true, RPG7=true, SKS=true, AKMN=true, R700=true,
    MK23=true, FAL=true, M4=true, GoldenMakarov=true, TOZ106=true, NagantRevolver=true,
    Groza=true, TOZ87=true, FlareGun=true, SPSh44=true,
    -- Melee Weapons
    AnarchyTomahawk=true, ButterflyKnife=true, Cutlass=true, DV2=true, GoldenDV2=true,
    RealGoldenDV2=true, Greatsword=true, IceAxe=true, IceDagger=true, Karambit=true,
    Kukri=true, Longsword=true, M9Fade=true, M9XR7=true, PlasmaNinjato=true, Scythe=true,
    -- High Tier Armor & Helmets
    Altyn=true, AltynVisor=true, FastMT=true, FastVisor=true, MaskaVisor=true, ZSh=true,
    ZShVisor=true, ["6B43"]=true, ["6B47"]=true, ["6B23"]=true, ["6B5"]=true, ["6B2"]=true,
    ["6B27"]=true, IOTV4=true, DozerArmor=true, TitanShield=true, HSPV=true, QuadNVG=true,
    ONV9=true, ScavKingHelmet=true, ScavKingVest=true, Kulon=true, JPC=true, Smersh=true,
    Attak5=true, SpecopsBackpack=true, GhillieHood=true, GhillieTorso=true, GhillieLegs=true,
    Lvl4Plate=true,
    -- Keys & Keycards
    RedCard=true, BlueCard=true, OrangeCard=true, EVACKey=true, FactoryGarageKey=true,
    FrigateKey=true, LighthouseKey=true, PoolKey=true, AirfieldTunnelsKey=true,
    GallerySecurityKey=true, CraneKey=true, HydroBasementKey=true, DormA211Key=true,
    DormB203Key=true, B05Key=true, ATCKey=true, Apartment13Key=true, Apartment21Key=true,
    CitySubstationtKey=true, FuelingStationKey=true, VillageKey=true, Villa1Key=true,
    -- High Value Barter / Electronics / Valuables
    GPU=true, CPU=true, SSD=true, RAM=true, PSU=true, Gold50g=true, GoldSkull=true,
    GoldWatch=true, SolterStatue=true, Matryoshka=true, Teapot=true, WeddingRing=true,
    GoldenTicket=true, AntonPlush=true, DozerPlush=true, EnzoPlush=true, WhisperPlush=true,
    DAGR=true, PDA=true, Smartphone=true, PortableConsole=true, Defib=true, Radio=true,
    GiftTier1=true, GiftTier2=true, GiftTier3=true, Rubles=true,
    -- Serums
    SerumGreen=true, SerumPurple=true, SerumRed=true, SerumYellow=true, ImmunsterReactor=true,
    -- Extended & High Tier Mags / Attachments
    ["762x39Rnd75Mag"]=true, ["762x25Rnd71Mag"]=true, Mag556Rnd100=true,
    ["9x19MP5DrumMAG"]=true, SaigaMag20rnd=true, ["762x54Rnd20Mag"]=true,
    ["9x18MakarovDrumMag"]=true, ["9x18vzDrumMag"]=true, AmmoBoxPKM100rnd=true,
    TimberWolfSuppressor=true, KACSuppressor=true, PBS1=true, T12W=true, ELCAN=true,
    ACOG=true, PEQ15=true
}

local CORPSE_TRASH_EXCLUDE = {
    -- Fabrics
    CottonFabric=true, AramidFabric=true, LinenFabric=true, RipstopFabric=true,
    -- Basic Clothes / Wastelander / Civilian
    WastelandShirt=true, WastelandPants=true, CivilianShirt=true, CivilianPants=true,
    SummerShirt=true, SummerPants=true, CamoShirt=true, CamoPants=true,
    GorkaShirt=true, GorkaPants=true, HandWraps=true, SewnMask=true, Balaclava=true,
    WastelandBackpack=true,
    -- Meds
    Bandage=true, WoundDressing=true, Rags=true, AI2=true, AA2=true, IFAK=true, AI4=true,
    Splint=true,
    -- Junk / Trash
    Beans=true, ChocolateBar=true, Jerky=true, WaterBottle=true, BloxyCola=true,
    CatfrogSoda=true, KevCola=true, ResKola=true, CondensedMilk=true, Tortilla=true,
    Nails=true, Bolts=true, Nuts=true, DuctTape=true, SuperGlue=true, Soap=true,
    MatchBox=true, LightBulb=true, Wrench=true, FlatScrewdriver=true, PH2Screwdriver=true,
    SteelPipe=true, Planks=true, MetalChunks=true, Gunpowder=true, AABattery=true,
    Cologne=true, NaCl=true, GP5Filter=true, Sandbag=true, Barricade=true, KeyChain=true,
    EstonianBorderMap=true, Map=true, OilCan=true, RepairKit=true, Hammer=true,
    Football=true, Snowball=true, TankCap=true, CFan=true, CopperCoil=true, Fuze=true
}

local function is_corpse_op_loot(name)
    if not name or name == "" then return false end
    local base = name:match("^(.-)%s*x%d+$") or name
    if CORPSE_TRASH_EXCLUDE[base] then return false end

    local low = base:lower()
    if low:find("fabric") or low:find("shirt") or low:find("pants") or low:find("bandage")
        or low:find("med") or low:find("cola") or low:find("food") or low:find("rags")
        or low:find("dressing") or low:find("splint") or low:find("backpack") or low:find("hat")
        or low:find("cap") or low:find("mask") or low:find("glove") or low:find("wrap")
        or low:find("wasteland") or low:find("civilian") or low:find("summer") or low:find("camo")
        or low:find("gorka") or low:find("water") or low:find("jerky") or low:find("beans")
        or low:find("keychain") or low:find("map") then
        return false
    end

    if CORPSE_OP_ITEMS[base] then return true end

    if low:find("rifle") or low:find("pistol") or low:find("shotgun") or low:find("smg")
        or low:find("sniper") or low:find("carbine") or low:find("gun") or low:find("revolver")
        or low:find("sword") or low:find("blade") or low:find("dagger") or low:find("knife")
        or low:find("tomahawk") or low:find("axe") or low:find("scythe") or low:find("fal")
        or low:find("m4") or low:find("svd") or low:find("mosin") or low:find("r700")
        or low:find("pkm") or low:find("val") or low:find("akm") or low:find("saiga") then
        return true
    end

    if low:find("card") or low:find("key") then
        return true
    end

    if low:find("plush") or low:find("gold") or low:find("ticket") or low:find("gpu")
        or low:find("cpu") or low:find("ssd") or low:find("ram") or low:find("serum")
        or low:find("thermal") or low:find("nvg") or low:find("altyn") or low:find("fastmt")
        or low:find("maska") or low:find("6b43") or low:find("iotv") or low:find("dozer")
        or low:find("dagr") or low:find("pda") or low:find("rubles") then
        return true
    end

    return false
end

local function is_good_item(name)
if not name or name == "" then return false end
if GOOD_CACHE[name] ~= nil then return GOOD_CACHE[name] end
local base = name:match("^(.-)%s*x%d+$") or name
if TRASH_ITEMS[base] or is_mag_or_trash(base) then
    GOOD_CACHE[name] = false
    return false
end
if OP_LOOT_MAP and OP_LOOT_MAP[base] then
    GOOD_CACHE[name] = true
    return true
end
local low = base:lower()
local res = (low:find("key") or low:find("card") or low:find("plush")
or low:find("dagr") or low:find("gold") or low:find("ticket") or low:find("gpu")
or low:find("serum") or low:find("statue") or low:find("replica")
or low:find("nvg") or low:find("scope") or low:find("suppressor")) and true or false
GOOD_CACHE[name] = res
return res
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
cam = nil,
hacker_tracker = {},
foliage_orig = {},
grass_orig = {},
foliage_done = false,
enemy_health = {},
enemy_last_pos = {},
hitmarker = nil,
tracers = {},
hit_logs = {},
last_shot = 0
}

local cfg = {}
local orig_light = nil
local orig_grass = nil
local panic_on = false
local silent_ok = false
local boba_menu_open = false

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
    return v_open
end

wm_x, wm_y = 10, 10
wm_drag = false
wm_dx, wm_dy = 0, 0
inv_x, inv_y = 10, 60
inv_drag = false
inv_dx, inv_dy = 0, 0
inv_target = nil
inv_target_data = nil
cached_heads = {}
local frame_players = {}

world_cars = {}

world_claymores = {}

-- (unused vars removed)
aim_target_ent = nil

locked_target = nil
lock_was_down = false

boss_x, boss_y = 5, 370
boss_drag, boss_dx, boss_dy = false, 0, 0
boss_data = {}
vehicle_data = {}
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

cheater_x, cheater_y = 320, 120
cheater_drag, cheater_dx, cheater_dy = false, 0, 0
avatar_cache = {}


detected_mods = {}
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
    local ok, v = pcall(menu.Get, id)
    if ok and v ~= nil then
        return v
    end
    if boba_store and boba_store[id] ~= nil then
        return boba_store[id]
    end
    if def ~= nil then return def end
    return false
end

local function mc(id, def)
    local ok, c = pcall(menu.GetColor, id)
    if ok and c ~= nil and type(c) == "table" and #c >= 3 then
        return c
    end
    if boba_colors and boba_colors[id] ~= nil then
        return boba_colors[id]
    end
    if def ~= nil then return def end
    return {1, 1, 1, 1}
end

local function mk(id, def)
    local ok, k = pcall(menu.GetKey, id)
    if ok and k ~= nil and k ~= 0 then
        return k
    end
    if boba_store and boba_store[id] ~= nil and type(boba_store[id]) == "number" then
        return boba_store[id]
    end
    if def ~= nil then return def end
    return 0
end

local function get_val(id, def)
    return mg(id, def)
end

local RS = game.ReplicatedStorage
local weapons = RS and RS:FindFirstChild("RangedWeapons")
local recoil_state = { enabled = false, originals = {}, reduction = 0.3 }

local function apply_recoil()
    if not weapons or not utility.IsValid(weapons) then
        if RS then weapons = RS:FindFirstChild("RangedWeapons") end
        if not weapons or not utility.IsValid(weapons) then return end
    end
    for _, weapon in ipairs(weapons:GetChildren()) do
        if not utility.IsValid(weapon) then goto continue end
        local pat_folder = weapon:FindFirstChild("RecoilPattern")
        if not pat_folder then goto continue end
        for _, pattern in ipairs(pat_folder:GetChildren()) do
            if not utility.IsValid(pattern) then goto continue2 end
            for _, v in ipairs(pattern:GetChildren()) do
                if utility.IsValid(v) and v.Value ~= nil then
                    local addr = v.Address or tostring(v)
                    if recoil_state.enabled then
                        if not recoil_state.originals[addr] then
                            recoil_state.originals[addr] = v.Value
                        end
                        v.Value = recoil_state.originals[addr] * recoil_state.reduction
                    elseif recoil_state.originals[addr] then
                        v.Value = recoil_state.originals[addr]
                        recoil_state.originals[addr] = nil
                    end
                end
            end
            ::continue2::
        end
        ::continue::
    end
end

local function set_val(id, val)
    if opt then opt[id] = val end
    if boba_store then boba_store[id] = val end
    pcall(function() menu.Set(id, val) end)
    if id == "b_aim" then cfg.aim = val
    elseif id == "b_aim_key" then cfg.aim_key = val
    elseif id == "b_npc_aim_key" then cfg.npc_aim_key = val
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
    elseif id == "b_no_recoil" then
        cfg.no_recoil = val
        recoil_state.enabled = (val == true)
        pcall(apply_recoil)
    elseif id == "b_recoil_reduc" then
        cfg.recoil_reduc = val
        local pct = (type(val) == "number" and val) or 70
        recoil_state.reduction = math.max(0, math.min(1, (100 - pct) / 100))
        if recoil_state.enabled then
            pcall(apply_recoil)
        end
    elseif id == "b_npc_aim" then cfg.npc_aim = val
    elseif id == "b_npc_aim_fov" then cfg.na_fov = val
    elseif id == "b_npc_aim_smooth" then cfg.na_sm = val
    elseif id == "b_npc_aim_pred" then cfg.na_pred = val
    elseif id == "b_npc_aim_fov_draw" then cfg.na_draw = val
    elseif id == "b_npc_aim_fov_filled" then cfg.na_fov_filled = val
    elseif id == "b_esp" then cfg.esp = val
    elseif id == "b_esp_style" then cfg.esp_style = val
    elseif id == "b_esp_box" then cfg.esp_box = val
    elseif id == "b_esp_skel" then cfg.esp_skel = val
    elseif id == "b_esp_hp" then cfg.esp_hp = val
    elseif id == "b_esp_hp_txt" then cfg.esp_hp_t = val
    elseif id == "b_esp_name" then cfg.esp_name = val
    elseif id == "b_esp_dist" then cfg.esp_dist = val
    elseif id == "b_esp_weapon" then cfg.esp_wep = val
    elseif id == "b_esp_snap" then cfg.esp_snap = val
    elseif id == "b_esp_range" then cfg.esp_range = val
    elseif id == "b_esp_team" then cfg.esp_team = val
    elseif id == "b_esp_staff" then cfg.esp_staff = val
    elseif id == "b_esp_armor" then cfg.esp_armor = val
    elseif id == "b_esp_hvt" then cfg.esp_hvt = val
    elseif id == "b_esp_vis_tag" then cfg.esp_vis_tag = val
    elseif id == "b_loadout_esp" then cfg.loadout_esp = val
    elseif id == "b_loadout_sz" then cfg.loadout_sz = val
    elseif id == "b_loadout_x" then cfg.loadout_x = val
    elseif id == "b_loadout_y" then cfg.loadout_y = val
    elseif id == "b_chams" then cfg.chams = val
    elseif id == "b_chams_mode" then cfg.chams_m = val
    elseif id == "b_chams_vc" then cfg.chams_vis = val
    elseif id == "b_wep_chams" then cfg.wep_chams = val
    elseif id == "b_wep_chams_style" then cfg.wep_chams_style = val
    elseif id == "b_wep_chams_pulse" then cfg.wep_chams_pulse = val
    elseif id == "b_npc" then cfg.npc = val
    elseif id == "b_npc_box" then cfg.npc_box = val
    elseif id == "b_npc_hp" then cfg.npc_hp = val
    elseif id == "b_npc_name" then cfg.npc_name = val
    elseif id == "b_npc_skel" then cfg.npc_skel = val
    elseif id == "b_npc_range" then cfg.npc_range = val
    elseif id == "b_extract" then cfg.extract = val; if val and scan_extracts then pcall(scan_extracts) end
    elseif id == "b_extract_range" then cfg.extract_r = val
    elseif id == "b_hazard" then cfg.hazard = val
    elseif id == "b_hazard_range" then cfg.hazard_r = val
    elseif id == "b_cont" then cfg.cont = val; if val and scan_containers then pcall(scan_containers) end
    elseif id == "b_cont_items" then cfg.cont_items = val
    elseif id == "b_cont_range" then cfg.cont_range = val
    elseif id == "b_cont_filter" then cfg.cont_filter = val
    elseif id == "b_loot" then cfg.loot = val; if val and scan_world_items then pcall(scan_world_items) end
    elseif id == "b_loot_range" then cfg.loot_range = val
    elseif id == "b_loot_filter" then cfg.loot_f = val
    elseif id == "b_corpse" then cfg.corpse = val
    elseif id == "b_corpse_op_only" then cfg.corpse_op_only = val
    elseif id == "b_corpse_items" then cfg.corpse_i = val
    elseif id == "b_corpse_range" then cfg.corpse_r = val
    elseif id == "b_corpse_x" then cfg.corpse_x = val
    elseif id == "b_quest" then cfg.quest = val; if val and scan_quests then pcall(scan_quests) end
    elseif id == "b_quest_range" then cfg.quest_r = val
    elseif id == "b_cheater_finder" then cfg.cheater_finder = val
    elseif id == "b_remove_foliage" then cfg.remove_foliage = val; pcall(apply_foliage_mods)
    elseif id == "b_nograss" then cfg.nograss = val; pcall(apply_world_mods)
    elseif id == "b_bullet_tracers" then cfg.bullet_tracers = val
    elseif id == "b_tracer_duration" then cfg.tracer_dur = val
    elseif id == "b_hitmarker" then cfg.hitmarker = val
    elseif id == "b_hit_logs" then cfg.hit_logs = val
    elseif id == "b_hit_log_duration" then cfg.hit_log_dur = val
    elseif id == "b_cross" then cfg.cross = val
    elseif id == "b_cross_style" then cfg.cross_style = val
    elseif id == "b_cross_sz" then cfg.cross_sz = val
    elseif id == "b_cross_gap" then cfg.cross_gap = val
    elseif id == "b_cross_thick" then cfg.cross_thick = val
    elseif id == "b_cross_spin" then cfg.cross_spin = val
    elseif id == "b_cross_spin_spd" then cfg.cross_spin_spd = val
    elseif id == "b_cross_pulse" then cfg.cross_pulse = val
    elseif id == "b_cross_pulse_spd" then cfg.cross_pulse_spd = val
    elseif id == "b_fov_changer" then cfg.fov_changer = val
    elseif id == "b_fov_val" then cfg.fov_val = val
    elseif id == "b_fov_ads_safe" then cfg.fov_ads_safe = val
    elseif id == "b_inspect" then cfg.inspect = val
    elseif id == "b_inv_weap" then cfg.inv_weap = val
    elseif id == "b_inv_armor" then cfg.inv_armor = val
    elseif id == "b_inv_special" then cfg.inv_special = val
    elseif id == "b_inv_misc" then cfg.inv_misc = val
    elseif id == "b_boss" then cfg.boss = val
    elseif id == "b_mod_alert" then cfg.mod_alert = val
    elseif id == "b_car" then cfg.car = val; if val and scan_cars then pcall(scan_cars) end
    elseif id == "b_car_range" then cfg.car_r = val
    elseif id == "b_claymore" then cfg.claymore = val
    elseif id == "b_claymore_names" then cfg.clay_names = val
    elseif id == "b_claymore_range" then cfg.clay_r = val
    elseif id == "b_radar" then cfg.radar = val
    elseif id == "b_radar_range" then cfg.radar_range = val
    elseif id == "b_radar_sz" then cfg.radar_sz = val
    elseif id == "b_radar_rot" then cfg.radar_rot = val
    elseif id == "b_skin_enable" then cfg.skin_enable = val
    elseif id == "b_skin_knife" then cfg.skin_knife = val
    elseif id == "b_skin_gun" then cfg.skin_gun = val
    elseif id == "b_skin_armor" then cfg.skin_armor = val
    elseif id == "b_wm" then cfg.wm = val
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
local r = model.PrimaryPart
or model:FindFirstChild("HumanoidRootPart")
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
            local ok_vis, vis = pcall(raycast.IsVisible, cam_pos.X, cam_pos.Y, cam_pos.Z, hp.X, hp.Y, hp.Z)
            if ok_vis and vis then return true end
        end
        local cp = p.Position
        if cp then
            local ok_vis, vis = pcall(raycast.IsVisible, cam_pos.X, cam_pos.Y, cam_pos.Z, cp.X, cp.Y + 0.8, cp.Z)
            if ok_vis and vis then return true end
        end
    end
    return false
end

local vis_cache_frame = 0
local vis_cache = {}
local function get_cached_player_visible(cam_pos, p)
    local cur_f = tick()
    if (cur_f - vis_cache_frame) > 0.05 then
        vis_cache_frame = cur_f
        vis_cache = {}
    end
    local pid = p.UserId or p.Name or p.Address
    if not pid then return check_player_visible(cam_pos, p) end
    if vis_cache[pid] ~= nil then
        return vis_cache[pid]
    end
    local v = check_player_visible(cam_pos, p)
    vis_cache[pid] = v
    return v
end

cached_ammo_lbl = nil
last_ammo_lbl_check = 0

local function get_local_ammo()
    if is_gun_equipped and not is_gun_equipped() then
        return nil
    end

    local now = utility.GetTickCount()
    if not cached_ammo_lbl or not utility.IsValid(cached_ammo_lbl) then
        if (now - last_ammo_lbl_check) > 3000 then
            last_ammo_lbl_check = now
            cached_ammo_lbl = nil
            pcall(function()
                local lp = game.LocalPlayer or (game.Players and game.Players.LocalPlayer)
                local pg = lp and lp:FindFirstChild("PlayerGui")
                local mg = pg and (pg:FindFirstChild("MainGui") or pg:FindFirstChild("NoInsetGui"))
                if mg then
                    cached_ammo_lbl = mg:FindFirstChild("Ammo", true)
                end
            end)
        end
    end
    if cached_ammo_lbl and utility.IsValid(cached_ammo_lbl) then
        local ok, txt = pcall(function() return cached_ammo_lbl.Text end)
        if ok and txt and txt ~= "" then
            local low = txt:lower()
            if low:find("empty") or txt == "-" .. "-" then
                return 0
            end
            local cur = txt:match("^(%d+)")
            if cur then
                return tonumber(cur)
            end
        end
    end

    local rep_ammo = nil
    pcall(function()
        local rep = game.ReplicatedStorage
        local lp = game.LocalPlayer or (game.Players and game.Players.LocalPlayer)
        if rep and lp and lp.Name then
            local p_data = rep:FindFirstChild("Players") and rep.Players:FindFirstChild(lp.Name)
            local status = p_data and p_data:FindFirstChild("Status")
            local gv = status and status:FindFirstChild("GameplayVariables")
            local eq = gv and gv:FindFirstChild("EquippedTool")
            if eq and eq.Value and utility.IsValid(eq.Value) then
                local item_props = eq.Value:FindFirstChild("ItemProperties") or eq.Value
                local loaded_ammo = item_props and item_props:FindFirstChild("LoadedAmmo")
                if loaded_ammo then
                    rep_ammo = #loaded_ammo:GetChildren()
                end
            end
        end
    end)
    if rep_ammo ~= nil then
        return rep_ammo
    end
    return nil
end


local CFG_IDS = {
"b_esp","b_esp_style","b_esp_box","b_esp_skel","b_esp_hp","b_esp_hp_txt",
"b_esp_name","b_esp_dist","b_esp_weapon","b_esp_snap","b_esp_range","b_esp_team",
"b_esp_staff","b_esp_armor","b_esp_hvt","b_esp_vis_tag","b_loadout_esp","b_loadout_sz","b_loadout_x","b_loadout_y",
"b_chams","b_chams_mode","b_chams_vc",
"b_npc","b_npc_box","b_npc_hp","b_npc_name","b_npc_dist","b_npc_skel","b_npc_range",
"b_cont","b_cont_items","b_cont_filter","b_cont_range",
"b_loot","b_loot_range","b_loot_filter",
"b_corpse","b_corpse_op_only","b_corpse_items","b_corpse_range","b_corpse_r",
"b_quest","b_quest_range",
"b_extract","b_extract_range","b_hazard","b_hazard_range",
"b_bullet_tracers","b_tracer_duration","b_hitmarker","b_hit_logs","b_hit_log_duration",
"b_aim","b_aim_key","b_npc_aim_key","b_aim_fov","b_aim_smooth","b_aim_bone","b_aim_vis_text","b_aim_pred",
"b_aim_lead","b_aim_lock",
"b_aim_vis","b_aim_team","b_aim_fov_draw","b_aim_fov_filled",
"b_silent","b_silent_bone","b_silent_vis_text","b_silent_multipoint","b_silent_fov","b_silent_vis","b_silent_team","b_silent_fov_draw","b_silent_fov_filled",
"b_no_recoil","b_recoil_reduc",
"b_npc_aim","b_npc_aim_bone","b_npc_aim_fov","b_npc_aim_smooth",
"b_npc_aim_pred","b_npc_aim_fov_draw","b_npc_aim_fov_filled",
"b_wm","b_cross","b_cross_style","b_cross_sz","b_cross_gap","b_cross_thick","b_cross_spin","b_cross_spin_spd","b_cross_pulse","b_cross_pulse_spd","b_inspect",
"b_inv_weap","b_inv_armor","b_inv_special","b_inv_misc",
"b_claymore","b_claymore_range",
"b_car","b_car_range",
"b_boss","b_cheater_finder","b_cheater_panel"
}

local COLOR_IDS = {
"b_bullet_tracers","b_bullet_tracer_c",
"b_esp_box","b_esp_box_c","b_esp_skel","b_esp_skel_c","b_esp_name","b_esp_name_c",
"b_esp_hp","b_esp_hp_c","b_esp_dist","b_esp_dist_c","b_esp_weapon","b_esp_weapon_c",
"b_esp_armor","b_esp_armor_c","b_esp_snap","b_esp_snap_c","b_esp_vis_tag","b_esp_vis_tag_c",
"b_esp_staff","b_esp_staff_c","b_esp_hvt","b_esp_hvt_c",
"b_chams_vis","b_chams_occ",
"b_npc_box","b_npc_box_c","b_npc_skel","b_npc_skel_c","b_npc_name","b_npc_name_c",
"b_npc_hp","b_npc_hp_c","b_npc_dist","b_npc_dist_c",
"b_cont","b_cont_c","b_cont_items","b_cont_items_c",
"b_loot","b_loot_c",
"b_corpse","b_corpse_c","b_corpse_items","b_corpse_items_c",
"b_quest","b_quest_c","b_extract","b_extract_c","b_hazard","b_hazard_c",
"b_claymore","b_claymore_c","b_car","b_car_c",
"b_cross","b_cross_c","b_hitmarker","b_hitmarker_c","b_hit_logs","b_hit_logs_c",
"b_inspect","b_inspect_c","b_loadout_c",
"b_aim_fov","b_aim_fov_c","b_silent_fov","b_silent_fov_c","b_npc_aim_fov","b_npc_aim_fov_c"
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
local seen = {}
local f = io.open(get_cfg_list_path(), "r")
if f then
    for line in f:lines() do
        local n = line:match("^%s*(.-)%s*$")
        if n and n ~= "" and not seen[n] then
            seen[n] = true
            table.insert(list, n)
        end
    end
    f:close()
end
if not seen["default"] then
    seen["default"] = true
    table.insert(list, 1, "default")
end
local folder = get_cfg_folder()
local common_names = {"legit", "rage", "semi_rage", "closet", "boba"}
for _, cn in ipairs(common_names) do
    if not seen[cn] then
        local tf = io.open(folder .. "boba_config_" .. cn .. ".txt", "r")
        if tf then
            tf:close()
            seen[cn] = true
            table.insert(list, cn)
        end
    end
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

local function apply_cfg_color(id, c_arr)
    if not id or not c_arr then return end
    if boba_colors then
        boba_colors[id] = c_arr
        if id:sub(-2) == "_c" then
            boba_colors[id:sub(1, -3)] = c_arr
        else
            boba_colors[id .. "_c"] = c_arr
        end
    end
    pcall(function() menu.SetColor(id, c_arr) end)
    if id:sub(-2) == "_c" then
        pcall(function() menu.SetColor(id:sub(1, -3), c_arr) end)
    else
        pcall(function() menu.SetColor(id .. "_c", c_arr) end)
    end

    if id == "b_chams_vis" then cfg.chams_vc = c_arr
    elseif id == "b_chams_occ" then cfg.chams_oc = c_arr
    elseif id == "b_esp_box" or id == "b_esp_box_c" then cfg.esp_box_c = c_arr
    elseif id == "b_esp_skel" or id == "b_esp_skel_c" then cfg.esp_skel_c = c_arr
    elseif id == "b_esp_name" or id == "b_esp_name_c" then cfg.esp_name_c = c_arr
    elseif id == "b_esp_hp" or id == "b_esp_hp_c" then cfg.esp_hp_c = c_arr
    elseif id == "b_esp_dist" or id == "b_esp_dist_c" then cfg.esp_dist_c = c_arr
    elseif id == "b_esp_weapon" or id == "b_esp_weapon_c" then cfg.esp_weapon_c = c_arr
    elseif id == "b_esp_armor" or id == "b_esp_armor_c" then cfg.esp_armor_c = c_arr
    elseif id == "b_esp_snap" or id == "b_esp_snap_c" then cfg.esp_snap_c = c_arr
    elseif id == "b_esp_vis_tag" or id == "b_esp_vis_tag_c" then cfg.esp_vis_tag_c = c_arr
    elseif id == "b_esp_staff" or id == "b_esp_staff_c" then cfg.esp_staff_c = c_arr
    elseif id == "b_esp_hvt" or id == "b_esp_hvt_c" then cfg.esp_hvt_c = c_arr
    elseif id == "b_npc_box" or id == "b_npc_box_c" then cfg.npc_box_c = c_arr
    elseif id == "b_npc_name" or id == "b_npc_name_c" then cfg.npc_name_c = c_arr
    elseif id == "b_npc_skel" or id == "b_npc_skel_c" then cfg.npc_skel_c = c_arr
    elseif id == "b_npc_hp" or id == "b_npc_hp_c" then cfg.npc_hp_c = c_arr
    elseif id == "b_npc_dist" or id == "b_npc_dist_c" then cfg.npc_dist_c = c_arr
    elseif id == "b_cont" or id == "b_cont_c" then cfg.cont_c = c_arr
    elseif id == "b_cont_items" or id == "b_cont_items_c" then cfg.cont_items_c = c_arr
    elseif id == "b_loot" or id == "b_loot_c" then cfg.loot_c = c_arr
    elseif id == "b_corpse" or id == "b_corpse_c" then cfg.corpse_c = c_arr
    elseif id == "b_corpse_items" or id == "b_corpse_items_c" then cfg.corpse_items_c = c_arr
    elseif id == "b_quest" or id == "b_quest_c" then cfg.quest_c = c_arr
    elseif id == "b_extract" or id == "b_extract_c" then cfg.extract_c = c_arr
    elseif id == "b_hazard" or id == "b_hazard_c" then cfg.hazard_c = c_arr
    elseif id == "b_cross" or id == "b_cross_c" then cfg.cross_c = c_arr
    elseif id == "b_hitmarker" or id == "b_hitmarker_c" then cfg.hitmarker_c = c_arr
    elseif id == "b_hit_logs" or id == "b_hit_logs_c" then cfg.hit_logs_c = c_arr
    elseif id == "b_inspect" or id == "b_inspect_c" then cfg.insp_c = c_arr
    elseif id == "b_loadout_c" then cfg.loadout_c = c_arr
    elseif id == "b_claymore" or id == "b_claymore_c" then cfg.claymore_c = c_arr
    elseif id == "b_car" or id == "b_car_c" then cfg.car_c = c_arr
    elseif id == "b_bullet_tracers" or id == "b_bullet_tracer_c" then cfg.bullet_tracer_c = c_arr
    elseif id == "b_aim_fov" or id == "b_aim_fov_c" then cfg.aim_fov_c = c_arr
    elseif id == "b_silent_fov" or id == "b_silent_fov_c" then cfg.sil_fov_c = c_arr
    elseif id == "b_npc_aim_fov" or id == "b_npc_aim_fov_c" then cfg.na_fov_c = c_arr
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
    local c = (boba_colors and boba_colors[id]) or mc(id)
    if c and type(c) == "table" and #c >= 3 then
        local key = id:find("_c$") and id or (id .. "_c")
        f:write(key .. "=" .. format("%.4f,%.4f,%.4f,%.4f",
            c[1] or 1, c[2] or 1, c[3] or 1, c[4] or 1) .. string.char(10))
    end
end
-- Save cheater panel position
f:write("cheater_panel_x=" .. tostring(math.floor(cheater_x or 320)) .. string.char(10))
f:write("cheater_panel_y=" .. tostring(math.floor(cheater_y or 120)) .. string.char(10))
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
            local c = (boba_colors and boba_colors[id]) or mc(id)
            if c and type(c) == "table" and #c >= 3 then
                local key = id:find("_c$") and id or (id .. "_c")
                alt_f:write(key .. "=" .. format("%.4f,%.4f,%.4f,%.4f",
                    c[1] or 1, c[2] or 1, c[3] or 1, c[4] or 1) .. string.char(10))
            end
        end
        alt_f:write("cheater_panel_x=" .. tostring(math.floor(cheater_x or 320)) .. string.char(10))
        alt_f:write("cheater_panel_y=" .. tostring(math.floor(cheater_y or 120)) .. string.char(10))
        alt_f:flush()
        alt_f:close()
    end
end

local list = read_config_list()
local found = false
for _, v in ipairs(list) do
    if v == name then found = true; break end
end
if not found then
    table.insert(list, name)
    write_config_list(list)
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
        if boba_store and type(boba_store[id]) == "number" then
            actual_val = tonumber(v)
        elseif boba_store and type(boba_store[id]) == "boolean" then
            actual_val = (v == "1" or v == "true")
        else
            local n = tonumber(v)
            if n ~= nil and (v ~= "0" and v ~= "1") then
                actual_val = n
            elseif v == "0" or v == "1" then
                actual_val = (v == "1")
            else
                actual_val = v
            end
        end
        if actual_val ~= nil then
            set_val(id, actual_val)
        end
    end
end
for _, id in ipairs(COLOR_IDS) do
    local cv = data[id .. "_c"] or data[id]
    if cv and type(cv) == "string" and cv:find(",") then
        local r,g,b,a = cv:match("([%d%.%-]+),([%d%.%-]+),([%d%.%-]+),([%d%.%-]+)")
        if r and g and b then
            local nr = tonumber(r) or 1
            local ng = tonumber(g) or 1
            local nb = tonumber(b) or 1
            local na = tonumber(a) or 1
            apply_cfg_color(id, {nr, ng, nb, na})
        end
    end
end
-- Load cheater panel position
if data["cheater_panel_x"] then
    local cx = tonumber(data["cheater_panel_x"])
    if cx then cheater_x = cx end
end
if data["cheater_panel_y"] then
    local cy = tonumber(data["cheater_panel_y"])
    if cy then cheater_y = cy end
end
write_active_cfg(name)
notify.Success("Config loaded", name)
end)
if not ok then notify.Error("Load failed", tostring(err)) end
end


local function collect_inventory_items(folder, out_list, depth)
if not folder or depth > 4 then return end
local ch = folder:GetChildren()
for i = 1, #ch do
local child = ch[i]
local cname = child.Name
local low_cn = cname:lower()
if cname ~= "Attachments" and cname ~= "LoadedAmmo" and cname ~= "Properties" and cname ~= "Connections"
and not low_cn:find("keychain") and not low_cn:find("estonian") then
local iname = nil
if child:IsA("ObjectValue") and child.Value then
iname = child.Value.Name
elseif child:IsA("StringValue") and child.Value ~= "" then
iname = child.Value
elseif child:IsA("Model") or child:IsA("Tool") then
iname = child.Name
elseif child.ClassName == "Folder" and tonumber(cname) == nil and cname ~= "Inventory" then
iname = cname
end
if not iname or tonumber(iname) ~= nil or iname:match("^Slot%d+") or iname:match("^Item%d+") then
if child:IsA("ObjectValue") and child.Value then
iname = child.Value.Name
elseif child:IsA("StringValue") and child.Value ~= "" then
iname = child.Value
else
local sub_iv = child:FindFirstChild("ItemName") or child:FindFirstChild("Item") or child:FindFirstChild("Value")
if sub_iv then
if sub_iv:IsA("StringValue") and sub_iv.Value ~= "" then
iname = sub_iv.Value
elseif sub_iv:IsA("ObjectValue") and sub_iv.Value then
iname = sub_iv.Value.Name
end
end
end
end
local low_in = iname and iname:lower() or ""
local is_kc = low_cn:find("keychain") or low_in:find("keychain") or low_in:find("estonian")
if iname and not is_kc and not is_mag_or_trash(iname) and tonumber(iname) == nil and not iname:match("^Slot%d+") and not iname:match("^Item%d+") and iname ~= "Properties" and iname ~= "MeshPart" and iname ~= "Model" and iname ~= "Folder" and iname ~= "Part" then
out_list[#out_list+1] = iname
end
if not is_kc then
local sub_inv = child:FindFirstChild("Inventory")
if sub_inv then
collect_inventory_items(sub_inv, out_list, depth + 1)
elseif child.ClassName == "Folder" and tonumber(cname) ~= nil then
collect_inventory_items(child, out_list, depth + 1)
end
end
end
end
end

local function get_inventory(model)
local inv = model:FindFirstChild("Inventory") or model:FindFirstChild("Items")
if not inv then return nil end
local items = {}
collect_inventory_items(inv, items, 0)
if #items == 0 then return nil end
local counts = {}
for i = 1, #items do
local n = items[i]
counts[n] = (counts[n] or 0) + 1
end
local out = {}
for n, c in pairs(counts) do
out[#out+1] = c > 1 and (n .. " x" .. c) or n
end
return #out > 0 and out or nil
end

local CONTAINER_NAMES = {
SportBag = true, LargeMilitaryBox = true, MedBag = true, SatchelBag = true,
MilitaryCrate = true, CashRegister = true, ModificationStation = true,
SmallMilitaryBox = true, WoodenCrate = true, Toolbox = true,
MedicalCabinet = true, Locker = true, FileCabinet = true, FilingCabinet = true,
Safe = true, HiddenCache = true, PC = true, SerumContainer = true,
GrenadeCrate = true, LargeABPOPABox = true, SmallShippingCrate = true,
LargeShippingCrate = true, Fridge = true, KGBBag = true,
SupplyDropMilitary = true, SupplyDropMilitary_Default = true, SupplyDropMilitary_XMAS = true,
}

local function scan_containers()
local result = {}
if not cfg.cont then world.containers = result; return end
local ws = game.Workspace
if not ws then world.containers = result; return end

local seen = {}
local function check_container(m)
    if not m or seen[m] then return end
    if (m.ClassName == "Model" or m.ClassName == "Folder") and not m:FindFirstChildOfClass("Humanoid") and (CONTAINER_NAMES[m.Name] or m:FindFirstChild("Inventory") or m:FindFirstChild("Properties")) then
        local part = get_root(m)
        if part then
            seen[m] = true
            local cnt = nil
            local op_c = nil
            if cfg.cont_items then
                cnt = get_inventory(m)
                if cnt then
                    for k = 1, #cnt do
                        if is_op_loot(cnt[k]) then
                            if not op_c then op_c = {} end
                            op_c[#op_c + 1] = cnt[k]
                        end
                    end
                end
            end
            result[#result+1] = {
                name = m.Name,
                part = part,
                model = m,
                contents = cnt,
                op_contents = op_c
            }
        end
    end
end

local cont_folder = ws:FindFirstChild("Containers") or ws:FindFirstChild("LootContainers")
if cont_folder then
    local cch = cont_folder:GetChildren()
    for i = 1, #cch do check_container(cch[i]) end
end

local nocoll = ws:FindFirstChild("NoCollision")
if nocoll then
    local ls = nocoll:FindFirstChild("LootSpawns")
    if ls then
        local cr = ls:FindFirstChild("Crates")
        if cr then
            local cch = cr:GetChildren()
            for i = 1, #cch do check_container(cch[i]) end
        end
        local op = ls:FindFirstChild("Open")
        if op then
            local och = op:GetChildren()
            for i = 1, #och do check_container(och[i]) end
        end
    end
end

local specific_folders = { "Containers", "LootContainers", "Debris", "Spawners" }
for _, sfn in ipairs(specific_folders) do
    local f = ws:FindFirstChild(sfn)
    if f then
        local fch = f:GetChildren()
        for i = 1, #fch do check_container(fch[i]) end
    end
end

local wch = ws:GetChildren()
for i = 1, #wch do
    local c = wch[i]
    if c and (CONTAINER_NAMES[c.Name] or (c.ClassName == "Model" and c:FindFirstChild("Inventory"))) then
        check_container(c)
    end
end

world.containers = result
end

local function scan_npcs()
    local result = {}
    if not cfg.npc and not cfg.npc_box and not cfg.npc_name and not cfg.npc_hp and not cfg.npc_dist and not cfg.npc_snap then
        world.npcs = result
        return
    end
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
        return false
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

    local zones = { "AiZones", "AIZones", "NPCs", "AI", "Enemies", "SafeZone", "Safezone", "Traders", "Trader", "Characters", "Living" }
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

local corpse_inv_cache = setmetatable({}, { __mode = "k" })
local function scan_world_items()
if not cfg.loot and not cfg.corpse then
    world.items = {}; world.corpses = {}; return
end
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
if not m or m.ClassName ~= "Model" or m.Name == "" then return end
local part = get_root(m)
if not part or not utility.IsValid(part) then return end
local hum = m:FindFirstChildOfClass("Humanoid")
if hum and hum.Health and hum.Health <= 0 then
    local cached = corpse_inv_cache[m]
    local cnt, good_cnt, op_cnt
    if cached then
        cnt = cached.cnt
        good_cnt = cached.good_cnt
        op_cnt = cached.op_cnt
    else
        cnt = get_inventory(m)
        if cnt then
            for k = 1, #cnt do
                if is_good_item(cnt[k]) then
                    if not good_cnt then good_cnt = {} end
                    good_cnt[#good_cnt + 1] = cnt[k]
                end
                if is_corpse_op_loot(cnt[k]) then
                    if not op_cnt then op_cnt = {} end
                    op_cnt[#op_cnt + 1] = cnt[k]
                end
            end
        end
        corpse_inv_cache[m] = { cnt = cnt, good_cnt = good_cnt, op_cnt = op_cnt }
    end
    corpses_r[#corpses_r+1] = {
        name = m.Name, part = part,
        contents = (cached and cached.cnt) or cnt,
        good_contents = (cached and cached.good_cnt) or good_cnt,
        op_contents = (cached and cached.op_cnt) or op_cnt
    }
else
    items_r[#items_r+1] = { name = m.Name, part = part, cat = get_item_category(m.Name) }
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
if not cfg.quest then world.quests = {}; return end
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

longshot_kills = {}

local function parse_kill_message(msg)
if not msg or type(msg) ~= "string" or msg == "" then return end
local lower_msg = msg:lower()
if not (lower_msg:find("kill") or lower_msg:find("elim") or lower_msg:find("shot") or lower_msg:find("snip") or lower_msg:find("from") or lower_msg:find("m%]") or lower_msg:find("m%)") or lower_msg:find("%d+m")) then
return
end
local dist_num = nil
for d in msg:gmatch("(%d+)%s*[mM]") do
local n = tonumber(d)
if n and n >= 100 and (not dist_num or n > dist_num) then
dist_num = n
end
end
if not dist_num then
for d in msg:gmatch("(%d+)%s*meters") do
local n = tonumber(d)
if n and n >= 100 and (not dist_num or n > dist_num) then
dist_num = n
end
end
end
if dist_num and dist_num >= 100 then
local players = entity.GetPlayers()
if players then
for i = 1, #players do
local p = players[i]
if p and p.Name and p.Name ~= "" then
local pname = p.Name
local pos = msg:find(pname, 1, true)
if pos then
local d_pos = msg:find(tostring(dist_num), 1, true)
if not d_pos or pos <= d_pos then
longshot_kills[pname] = (longshot_kills[pname] or 0) + 1
if longshot_kills[pname] >= 5 and notify and notify.Warning then
notify.Warning("CHEATER DETECTED", pname .. " (5x Longshots)", 8)
end
break
end
end
end
end
end
end
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
    local kd = 0
    local hours = 0
    local acct_age = -1
    local ls_kills = longshot_kills[pname] or 0
    local is_cheater = false
    pcall(function()
        local rblx_player = p.Player or game.Players:FindFirstChild(pname)
        if rblx_player and rblx_player.AccountAge then
            acct_age = rblx_player.AccountAge
        end
    end)
    if rep_p then
        local data = rep_p:FindFirstChild(pname)
        if data then
            local inv_f = data:FindFirstChild("Inventory")
            if inv_f then
                collect_inventory_items(inv_f, inv, 0)
            end
            local st = data:FindFirstChild("Status")
            local gv = (st and st:FindFirstChild("GameplayVariables")) or data:FindFirstChild("GameplayVariables")
            if gv then
                local hb = gv:FindFirstChild("Hotbar")
                if hb then
                    collect_inventory_items(hb, inv, 0)
                end
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
            local jn = (st and st:FindFirstChild("Journey")) or data:FindFirstChild("Journey")
            local ws_f = (jn and (jn:FindFirstChild("WipeStatistics") or jn:FindFirstChild("Statistics")))
                or (st and (st:FindFirstChild("WipeStatistics") or st:FindFirstChild("Statistics")))
                or data:FindFirstChild("WipeStatistics") or data:FindFirstChild("Statistics")

            if ws_f then
                local pvp_kdr = ws_f:FindFirstChild("PVPKDR") or ws_f:FindFirstChild("KDR") or ws_f:FindFirstChild("KD")
                if pvp_kdr and pvp_kdr.Value and tonumber(pvp_kdr.Value) then
                    kd = tonumber(pvp_kdr.Value)
                else
                    local pk = ws_f:FindFirstChild("PVPKills") or ws_f:FindFirstChild("Kills")
                    local pd = ws_f:FindFirstChild("Deaths")
                    local k_n = pk and pk.Value and tonumber(pk.Value) or 0
                    local d_n = pd and pd.Value and tonumber(pd.Value) or 0
                    if k_n > 0 or d_n > 0 then
                        kd = k_n / math.max(1, d_n)
                    end
                end
                local tp = ws_f:FindFirstChild("TimePlayed") or ws_f:FindFirstChild("Playtime")
                if tp and tp.Value and tonumber(tp.Value) then
                    local secs = tonumber(tp.Value)
                    hours = secs > 500 and math.floor(secs / 3600) or math.floor(secs)
                end
            end
            local ov_f = (jn and jn:FindFirstChild("Statistics")) or (st and st:FindFirstChild("Statistics")) or data:FindFirstChild("Statistics")
            if ov_f and ov_f ~= ws_f then
                if kd == 0 then
                    local pvp_kdr = ov_f:FindFirstChild("PVPKDR") or ov_f:FindFirstChild("KDR") or ov_f:FindFirstChild("KD")
                    if pvp_kdr and pvp_kdr.Value and tonumber(pvp_kdr.Value) then
                        kd = tonumber(pvp_kdr.Value)
                    else
                        local pk = ov_f:FindFirstChild("PVPKills") or ov_f:FindFirstChild("Kills")
                        local pd = ov_f:FindFirstChild("Deaths")
                        local k_n = pk and pk.Value and tonumber(pk.Value) or 0
                        local d_n = pd and pd.Value and tonumber(pd.Value) or 0
                        if k_n > 0 or d_n > 0 then
                            kd = k_n / math.max(1, d_n)
                        end
                    end
                end
                if hours == 0 then
                    local tp = ov_f:FindFirstChild("TimePlayed") or ov_f:FindFirstChild("Playtime")
                    if tp and tp.Value and tonumber(tp.Value) then
                        local secs = tonumber(tp.Value)
                        hours = secs > 500 and math.floor(secs / 3600) or math.floor(secs)
                    end
                end
            end
        end
    end
    if kd == 0 or hours == 0 then
        local pl = game.Players:FindFirstChild(pname)
        if pl then
            local ls = pl:FindFirstChild("leaderstats")
            if ls then
                if kd == 0 then
                    local pvp_kdr = ls:FindFirstChild("PVPKDR") or ls:FindFirstChild("KDR") or ls:FindFirstChild("KD")
                    if pvp_kdr and pvp_kdr.Value and tonumber(pvp_kdr.Value) then
                        kd = tonumber(pvp_kdr.Value)
                    else
                        local pk = ls:FindFirstChild("PVPKills") or ls:FindFirstChild("Kills")
                        local pd = ls:FindFirstChild("Deaths")
                        local k_n = pk and pk.Value and tonumber(pk.Value) or 0
                        local d_n = pd and pd.Value and tonumber(pd.Value) or 0
                        if k_n > 0 or d_n > 0 then
                            kd = k_n / math.max(1, d_n)
                        end
                    end
                end
                if hours == 0 then
                    local tp = ls:FindFirstChild("TimePlayed") or ls:FindFirstChild("Hours") or ls:FindFirstChild("Playtime")
                    if tp and tp.Value and tonumber(tp.Value) then
                        local secs = tonumber(tp.Value)
                        hours = secs > 500 and math.floor(secs / 3600) or math.floor(secs)
                    end
                end
            end
        end
    end
    if world.hacker_tracker[pname] and world.hacker_tracker[pname].is_speeding then
        is_cheater = true
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
        local iname = inv[j]
        if HVT_KEYS[iname] or (OP_LOOT_MAP and OP_LOOT_MAP[iname]) then
            if HVT_KEYS[iname] or iname:find("Plush") or iname == "GoldenTicket" or iname == "GPU" or iname:find("Card") then
                hvt = iname
                break
            end
        end
    end
    result[#result+1] = {
        name = pname,
        display = p.DisplayName or pname,
        entity = p, inventory = inv, equipped = equipped,
        head = head_ref, helmet = helmet, vest = vest, hvt = hvt,
        kd = kd, hours = hours, acct_age = acct_age, ls_kills = ls_kills, is_cheater = is_cheater
    }
end
end
local heads = {}
local p_map = {}
for i = 1, #result do
local r = result[i]
if r.head then heads[r.name] = r.head end
if r.name then p_map[r.name] = r end
end
cached_heads = heads
world.players = result
world.player_map = p_map
end

local function scan_extracts()
local result = {}
if not cfg.extract then world.extracts = result; return end
local ws = game.Workspace
if not ws then world.extracts = result; return end

local seen = {}
local function find_extract_part(o)
    if not o then return nil end
    if o:IsA("BasePart") then return o end
    if o:IsA("Model") and o.PrimaryPart then return o.PrimaryPart end
    local p = o:FindFirstChild("Zone") or o:FindFirstChild("Trigger") or o:FindFirstChild("Part") or o:FindFirstChild("Hitbox") or o:FindFirstChildOfClass("BasePart")
    if p and p:IsA("BasePart") then return p end
    local ch = o:GetChildren()
    for j = 1, #ch do
        if ch[j]:IsA("BasePart") then return ch[j] end
        if ch[j]:IsA("Model") and ch[j].PrimaryPart then return ch[j].PrimaryPart end
    end
    return nil
end

local function try_add(obj, custom_name)
    if not obj or seen[obj] then return end
    local part = find_extract_part(obj)
    if part and part.Position then
        seen[obj] = true
        seen[part] = true
        local dname = custom_name or obj.Name
        local low_dn = dname:lower()
        if low_dn == "part" or low_dn == "zone" or low_dn == "trigger" or low_dn == "hitbox" or low_dn == "root" then
            if obj.Parent and obj.Parent ~= ws then
                dname = obj.Parent.Name
            end
        end
        result[#result+1] = { name = dname, part = part }
    end
end

local function name_is_extract(n)
    if not n then return false end
    local lo = n:lower()
    if lo:find("lamp") or lo:find("flare") or lo:find("light") or lo:find("crate") or lo:find("barrel") or lo:find("fence") or lo:find("post") or lo:find("sign") then
        return false
    end
    return lo:find("extract") or lo:find("exfil") or lo:find("exit") or lo:find("evac")
end

-- 1. Check NoCollision
local nocoll = ws:FindFirstChild("NoCollision")
if nocoll then
    local exits = nocoll:FindFirstChild("ExitLocations") or nocoll:FindFirstChild("Exits") or nocoll:FindFirstChild("Extracts")
    if exits then
        local ech = exits:GetChildren()
        for i = 1, #ech do try_add(ech[i]) end
    end
    local nch = nocoll:GetChildren()
    for i = 1, #nch do
        if name_is_extract(nch[i].Name) then
            try_add(nch[i])
            local sub = nch[i]:GetChildren()
            for k = 1, #sub do try_add(sub[k], nch[i].Name) end
        end
    end
end

-- 2. Check search folders in Workspace
local search_parents = {
    "ExitLocations", "Extracts", "Extraction", "ExitZones", "Exits", "Exfil",
    "ExtractionPoints", "ExfilPoints", "Extractions", "ExtractionZones", "Zones"
}
for _, fname in ipairs(search_parents) do
    local folder = ws:FindFirstChild(fname)
    if folder then
        local ch = folder:GetChildren()
        for i = 1, #ch do
            try_add(ch[i])
            if ch[i]:IsA("Model") or ch[i]:IsA("Folder") then
                local sub = ch[i]:GetChildren()
                for k = 1, #sub do try_add(sub[k], ch[i].Name) end
            end
        end
    end
end

-- 3. Check Map folder
local map = ws:FindFirstChild("Map") or ws:FindFirstChild("map")
if map then
    for _, fname in ipairs(search_parents) do
        local folder = map:FindFirstChild(fname)
        if folder then
            local ch = folder:GetChildren()
            for i = 1, #ch do
                try_add(ch[i])
                if ch[i]:IsA("Model") or ch[i]:IsA("Folder") then
                    local sub = ch[i]:GetChildren()
                    for k = 1, #sub do try_add(sub[k], ch[i].Name) end
                end
            end
        end
    end
end

world.extracts = result
end

local function scan_hazards()
local result = {}
if not cfg.hazard then world.hazards = result; return end
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
local is_menu_open = is_any_menu_open()
local interval = is_menu_open and 250 or 1500
if (now - cfg_last_update) < interval then return end
cfg_last_update = now

cfg.esp       = mg("b_esp")
cfg.esp_style = mg("b_esp_style")
cfg.esp_box   = mg("b_esp_box")
cfg.esp_box_c = mc("b_esp_box_c", mc("b_esp_box", {1, 0.3, 0.3, 1}))
cfg.esp_skel  = mg("b_esp_skel")
cfg.esp_skel_c= mc("b_esp_skel_c", mc("b_esp_skel", {1, 1, 1, 1}))
cfg.esp_hp    = mg("b_esp_hp")
cfg.esp_hp_t  = mg("b_esp_hp_txt")
cfg.esp_hp_c  = mc("b_esp_hp_c", mc("b_esp_hp", {0.2, 1, 0.2, 1}))
cfg.esp_name  = mg("b_esp_name")
cfg.esp_name_c= mc("b_esp_name_c", mc("b_esp_name", {1, 1, 1, 1}))
cfg.esp_dist  = mg("b_esp_dist")
cfg.esp_dist_c= mc("b_esp_dist_c", mc("b_esp_dist", {0.7, 0.7, 0.7, 1}))
cfg.esp_wep   = mg("b_esp_weapon")
cfg.esp_weapon_c = mc("b_esp_weapon_c", mc("b_esp_weapon", {1, 0.7, 0.3, 1}))
cfg.esp_snap  = mg("b_esp_snap")
cfg.esp_snap_c= mc("b_esp_snap_c", mc("b_esp_snap", {0.4, 0.7, 1.0, 1.0}))
cfg.esp_range = (type(mg("b_esp_range", 1000)) == "number" and mg("b_esp_range", 1000)) or 1000
cfg.esp_team  = mg("b_esp_team")
cfg.esp_armor = mg("b_esp_armor")
cfg.esp_armor_c = mc("b_esp_armor_c", mc("b_esp_armor", {0.6, 0.85, 1, 1}))
cfg.esp_hvt   = mg("b_esp_hvt")
cfg.esp_hvt_c = mc("b_esp_hvt_c", mc("b_esp_hvt", {1, 0.85, 0.2, 1}))
cfg.esp_vis_tag = mg("b_esp_vis_tag")
cfg.esp_vis_tag_c = mc("b_esp_vis_tag_c", mc("b_esp_vis_tag", {0.15, 1, 0.25, 1}))
cfg.esp_staff = mg("b_esp_staff")
cfg.esp_staff_c = mc("b_esp_staff_c", mc("b_esp_staff", {1, 0.2, 1, 1}))
cfg.loadout_esp = mg("b_loadout_esp")
cfg.loadout_c   = mc("b_loadout_c", mc("b_loadout_esp", {0.4, 0.8, 1, 1}))
cfg.loadout_sz  = mg("b_loadout_sz", 38)
cfg.loadout_x   = mg("b_loadout_x", 420)
cfg.loadout_y   = mg("b_loadout_y", 120)
cfg.inv_weap    = mg("b_inv_weap", false)
cfg.inv_armor   = mg("b_inv_armor", false)
cfg.inv_special = mg("b_inv_special", false)
cfg.inv_misc    = mg("b_inv_misc", false)
cfg.inspect     = mg("b_inspect")
cfg.insp_c      = mc("b_inspect_c", mc("b_inspect", {0.4, 0.8, 1, 1}))

cfg.chams       = mg("b_chams")
cfg.chams_m     = mg("b_chams_mode", 0)
cfg.chams_vis   = mg("b_chams_vc")
cfg.chams_vc    = mc("b_chams_vis", {0.0, 1.0, 0.3, 0.8})
cfg.chams_oc    = mc("b_chams_occ", {1.0, 0.25, 0.25, 0.8})

cfg.npc         = mg("b_npc")
cfg.npc_box     = mg("b_npc_box")
cfg.npc_box_c   = mc("b_npc_box_c", mc("b_npc_box", {1, 0.5, 0.2, 1}))
cfg.npc_hp      = mg("b_npc_hp")
cfg.npc_hp_c    = mc("b_npc_hp_c", mc("b_npc_hp", {0.2, 1, 0.2, 1}))
cfg.npc_name    = mg("b_npc_name")
cfg.npc_name_c  = mc("b_npc_name_c", mc("b_npc_name", {1, 0.8, 0.4, 1}))
cfg.npc_dist    = mg("b_npc_dist")
cfg.npc_dist_c  = mc("b_npc_dist_c", mc("b_npc_dist", {0.7, 0.7, 0.7, 1}))
cfg.npc_skel    = mg("b_npc_skel")
cfg.npc_skel_c  = mc("b_npc_skel_c", mc("b_npc_skel", {1, 0.6, 0.3, 0.8}))
cfg.npc_range   = (type(mg("b_npc_range", 500)) == "number" and mg("b_npc_range", 500)) or 500
cfg.boss        = mg("b_boss")
cfg.cheater_finder = mg("b_cheater_finder")
cfg.cheater_panel  = mg("b_cheater_panel")

local old_cont = cfg.cont
cfg.cont        = mg("b_cont", false)
cfg.cont_c      = mc("b_cont_c", mc("b_cont", {0.2, 0.8, 1, 1}))
cfg.cont_items  = mg("b_cont_items", false)
cfg.cont_items_c = mc("b_cont_items_c", mc("b_cont_items", {0.85, 0.85, 0.85, 1}))
cfg.cont_filter = mg("b_cont_filter", 0)
cfg.cont_range  = (type(mg("b_cont_range", 500)) == "number" and mg("b_cont_range", 500)) or 500
if cfg.cont and (not old_cont or #world.containers == 0) then
    pcall(scan_containers)
end

local old_loot = cfg.loot
cfg.loot        = mg("b_loot", false)
cfg.loot_c      = mc("b_loot_c", mc("b_loot", {0.4, 1, 0.4, 1}))
cfg.loot_range  = (type(mg("b_loot_range", 400)) == "number" and mg("b_loot_range", 400)) or 400
cfg.corpse      = mg("b_corpse", false)
cfg.corpse_c    = mc("b_corpse_c", mc("b_corpse", {0.8, 0.2, 0.2, 1}))
cfg.corpse_op_only = mg("b_corpse_op_only", false)
cfg.corpse_i    = mg("b_corpse_items", false)
cfg.corpse_items_c = mc("b_corpse_items_c", mc("b_corpse_items", {0.85, 0.85, 0.85, 1}))
cfg.corpse_r    = (type(mg("b_corpse_r", mg("b_corpse_range", 500))) == "number" and mg("b_corpse_r", mg("b_corpse_range", 500))) or 500
if (cfg.loot or cfg.corpse) and (not old_loot or #world.items == 0) then
    pcall(scan_world_items)
end

cfg.quest       = mg("b_quest", false)
cfg.quest_c     = mc("b_quest_c", mc("b_quest", {1, 0.85, 0.2, 1}))
cfg.quest_r     = (type(mg("b_quest_range", 800)) == "number" and mg("b_quest_range", 800)) or 800
cfg.hazard      = mg("b_hazard", false)
cfg.hazard_c    = mc("b_hazard_c", mc("b_hazard", {1, 0.3, 0.1, 1}))
cfg.hazard_r    = (type(mg("b_hazard_range", 1500)) == "number" and mg("b_hazard_range", 1500)) or 1500

local old_extract = cfg.extract
cfg.extract     = mg("b_extract", false)
cfg.extract_c   = mc("b_extract_c", mc("b_extract", {0.2, 1, 0.5, 1}))
cfg.extract_r   = (type(mg("b_extract_range", 3000)) == "number" and mg("b_extract_range", 3000)) or 3000
if cfg.extract and (not old_extract or #world.extracts == 0) then
    pcall(scan_extracts)
end

cfg.claymore    = mg("b_claymore", false)
cfg.claymore_c  = mc("b_claymore_c", mc("b_claymore", {1, 0.2, 0.2, 1}))
cfg.car         = mg("b_car", false)
cfg.car_c       = mc("b_car_c", mc("b_car", {0.2, 0.6, 1, 1}))

cfg.aim         = mg("b_aim", false)
cfg.aim_key     = mg("b_aim_key", 0x02)
cfg.aim_fov     = mg("b_aim_fov", 150)
cfg.aim_sm      = mg("b_aim_smooth", 5.0)
cfg.aim_bone    = mg("b_aim_bone", 0)
cfg.aim_vis_txt = mg("b_aim_vis_text")
cfg.aim_pred    = mg("b_aim_pred")
cfg.aim_pred_scale = 1.0
cfg.aim_lead    = mg("b_aim_lead")
cfg.aim_lock    = mg("b_aim_lock")
cfg.aim_vis     = mg("b_aim_vis")
cfg.aim_team    = mg("b_aim_team")
cfg.aim_draw    = mg("b_aim_fov_draw") or mg("b_aim_draw_fov")
cfg.aim_fov_filled = mg("b_aim_fov_filled")
cfg.aim_fov_c   = mc("b_aim_fov_c", mc("b_aim_fov", {1, 1, 1, 0.25}))

cfg.sil         = mg("b_silent")
cfg.sil_key     = mg("b_silent_key", 0)
cfg.sil_mode    = mg("b_silent_mode", 0)
cfg.sil_hchance = mg("b_silent_hchance", 100)
cfg.sil_fov     = mg("b_silent_fov", 60)
cfg.sil_fov_c   = mc("b_silent_fov_c", mc("b_silent_fov", {1, 0.8, 0.2, 0.2}))
cfg.sil_draw    = mg("b_silent_fov_draw") or mg("b_silent_draw_fov")
cfg.sil_fov_filled = mg("b_silent_fov_filled")
cfg.sil_bone    = mg("b_silent_bone", 0)
cfg.sil_multipoint = mg("b_silent_multipoint")
cfg.sil_vis     = mg("b_silent_vis")
cfg.sil_team    = mg("b_silent_team")

cfg.na          = mg("b_npc_aim")
cfg.na_key      = mg("b_npc_aim_key", 0x02)
cfg.na_fov      = mg("b_npc_aim_fov", 90)
cfg.na_pred     = mg("b_npc_aim_pred")
cfg.na_draw     = mg("b_npc_aim_fov_draw")
cfg.na_fov_filled = mg("b_npc_aim_fov_filled")
cfg.na_fov_c    = mc("b_npc_aim_fov_c", mc("b_npc_aim_fov", {1, 0.6, 0.2, 0.3}))

cfg.no_recoil   = mg("b_no_recoil")
cfg.recoil_reduc= mg("b_recoil_reduc", 70)
cfg.hitmarker   = mg("b_hitmarker")
cfg.hitmarker_c = mc("b_hitmarker_c", mc("b_hitmarker", {1, 1, 1, 1}))
cfg.hit_logs    = mg("b_hit_logs", false)
cfg.hit_logs_c  = mc("b_hit_logs_c", mc("b_hit_logs", {0.25, 0.65, 1.0, 1.0}))
cfg.hit_log_dur = mg("b_hit_log_duration", 4.0)
cfg.bullet_tracers = mg("b_bullet_tracers")
cfg.bullet_tracer_c = mc("b_bullet_tracer_c", mc("b_bullet_tracers", {1, 0.8, 0, 0.8}))
cfg.cross       = mg("b_cross") or mg("b_crosshair")
cfg.cross_style = mg("b_cross_style", 0)
cfg.cross_sz    = mg("b_cross_sz", 8)
cfg.cross_gap   = mg("b_cross_gap", 3)
cfg.cross_thick = mg("b_cross_thick", 2)
cfg.cross_spin  = mg("b_cross_spin")
cfg.cross_spin_spd = mg("b_cross_spin_spd", 5)
cfg.cross_pulse = mg("b_cross_pulse")
cfg.cross_pulse_spd = mg("b_cross_pulse_spd", 4)
cfg.cross_c     = mc("b_cross_c", mc("b_cross", {0, 1, 0, 1}))
end


local function draw_esp_box(x, y, w, h, col)
    if draw.Box then
        pcall(draw.Box, x, y, w, h, col or WHITE, 0)
    elseif draw.Rect then
        pcall(draw.Rect, x, y, w, h, col or WHITE)
    end
end

local function draw_corner_box(x, y, w, h, col)
    if draw.CornerBox then
        pcall(draw.CornerBox, x, y, w, h, col or WHITE)
    elseif draw.Box then
        pcall(draw.Box, x, y, w, h, col or WHITE, 1)
    elseif draw.Rect then
        pcall(draw.Rect, x, y, w, h, col or WHITE)
    end
end

local function draw_health_bar(x, y, h, hp, max_hp)
    if draw.HealthBar then
        pcall(draw.HealthBar, x, y, h, hp or 100, max_hp or 100)
    else
        local mhp = max_hp or 100
        if mhp <= 0 then mhp = 100 end
        local ratio = math.clamp((hp or 100) / mhp, 0, 1)
        pcall(draw.RectFilled, x, y, 4, h, {0, 0, 0, 0.7})
        local cur_h = h * ratio
        pcall(draw.RectFilled, x + 1, y + h - cur_h, 2, cur_h, health_color(ratio))
    end
end

local function draw_player_chams()
if not cfg.chams then return end
local players = frame_players
if not players or #players == 0 then return end
local vc = cfg.chams_vc or {0.0, 1.0, 0.3, 0.8}
local oc = cfg.chams_oc or {1.0, 0.25, 0.25, 0.8}
local mode = cfg.chams_m or 0
local cam_pos = nil
if cfg.chams_vis then pcall(function() cam_pos = camera.GetPosition() end) end
local lp = nil
pcall(function() lp = entity.GetLocalPlayer() end)
local rbx_lp = nil
pcall(function() rbx_lp = game.Players.LocalPlayer end)
for i = 1, #players do
    local p = players[i]
    if p then
        local ok = true
        if not p.IsValid or not p.IsAlive or (p.Health and p.Health <= 0) then ok = false end
        if ok then
            local is_me = p.IsLocal or (lp and (p == lp or p.UserId == lp.UserId or p.Name == lp.Name))
            if not is_me and rbx_lp then
                if (rbx_lp.UserId and p.UserId == rbx_lp.UserId) or (rbx_lp.Name and p.Name == rbx_lp.Name) then is_me = true end
            end
            if not is_me then
                local d = nil
                pcall(function() d = p:DistanceTo() end)
                if d and d < 3 then ok = false end
            else ok = false end
        end
        if ok then
            local is_vis = false
            if cfg.chams_vis and cam_pos then
                is_vis = get_cached_player_visible(cam_pos, p)
            end
            local col = (cfg.chams_vis and (is_vis and vc or oc)) or vc
            pcall(draw.ChamsPlayer, p, col, mode)
        end
    end
end
end

local function draw_player_esp()
if not cfg.esp then return end
local players = frame_players
if not players or #players == 0 then return end
local scx, scy = input.GetScreenCenter()
local range_studs = (cfg.esp_range or 1000) * STUDS_PER_M

local p_data_map = world.player_map or {}
local lp = entity.GetLocalPlayer()
local rbx_lp = nil
pcall(function() rbx_lp = game.Players.LocalPlayer end)
local cam_pos = nil
if cfg.esp_vis_tag or (cfg.chams and cfg.chams_vis) then
    cam_pos = camera.GetPosition()
end

for i = 1, #players do
    local p = players[i]
    if p then
        if not p.IsValid or not p.IsAlive or (p.Health and p.Health <= 0) then goto cont end
        local is_me = p.IsLocal or (lp and (p == lp or p.UserId == lp.UserId or p.Name == lp.Name or (p.Address and lp.Address and p.Address == lp.Address)))
        if not is_me and rbx_lp then
            if (rbx_lp.UserId and p.UserId == rbx_lp.UserId) or (rbx_lp.Name and p.Name == rbx_lp.Name) or (p.Character and rbx_lp.Character and p.Character == rbx_lp.Character) then
                is_me = true
            end
        end
        if is_me then goto cont end
        local d_chk = p:DistanceTo()
        if d_chk and d_chk < 3 then goto cont end
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
        if not dist_studs or dist_studs > range_studs then goto cont end

        local b = nil
        local ok_b, gb = pcall(p.GetBounds, p)
        if ok_b and gb and gb.valid and gb.w and gb.w > 0 and gb.h and gb.h > 0 then
            b = gb
        end

        local mid = nil
        if b then
            mid = b.x + b.w * 0.5
        else
            local hp = p.HeadPosition
            local rp = p.Position
            if hp and rp then
                local hx, hy, hvis = utility.WorldToScreen(hp.X, hp.Y + 0.85, hp.Z)
                local fx, fy, fvis = utility.WorldToScreen(rp.X, rp.Y - 2.8, rp.Z)
                if hvis or fvis then
                    local bh = math.max(14, math.abs(fy - hy))
                    local bw = bh * 0.55
                    local cx = hvis and hx or fx
                    local bx = cx - bw * 0.5
                    local by = math.min(hy, fy)
                    b = { x = bx, y = by, w = bw, h = bh, valid = true }
                    mid = cx
                end
            end
        end

        if not b or not b.valid or not mid then goto cont end



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
            draw.Text(b.x - 8 - htw, b.y + b.h * 0.5 - 5, htxt, cfg.esp_hp_c or health_color(ratio), 11)
        end

        local label_y = b.y - 2
        local p_data = p_data_map[p.Name]

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
        if (cfg.esp_vis_tag or (cfg.chams and cfg.chams_vis)) and cam_pos then
            is_eye_vis = get_cached_player_visible(cam_pos, p)
        end

        if (cfg.esp_vis_tag or cfg.chams_vis) and is_eye_vis then
            local vtag = "[VISIBLE]"
            local vcol = {0.15, 1, 0.25, 1}
            local vtw = draw.GetTextSize(vtag, 11)
            label_y = label_y - 12
            draw.Text(mid - vtw * 0.5 + 1, label_y + 1, vtag, {0, 0, 0, 0.95}, 11)
            draw.Text(mid - vtw * 0.5, label_y, vtag, cfg.esp_vis_tag_c or vcol, 11)
        end

        if cfg.esp_wep then
            local p_data = p_data_map[p.Name]
            local wep = p_data and p_data.equipped
            if wep and wep ~= "" then
                local tw = draw.GetTextSize(wep, 11)
                label_y = label_y - 12
                draw.Text(mid - tw * 0.5, label_y, wep, cfg.esp_weapon_c or {1, 0.7, 0.3, 1}, 11)
            end
        end

        if cfg.esp_armor then
            local p_data = p_data_map[p.Name]
            if p_data and (p_data.helmet or p_data.vest) then
                local arm_str = (p_data.helmet or "-") .. " | " .. (p_data.vest or "-")
                local tw = draw.GetTextSize(arm_str, 11)
                label_y = label_y - 12
                draw.Text(mid - tw * 0.5, label_y, arm_str, cfg.esp_armor_c or {0.6, 0.85, 1, 1}, 11)
            end
        end

        if cfg.esp_hvt then
            local p_data = p_data_map[p.Name]
            if p_data and p_data.hvt then
                local hvt_str = "★ High Value Target: " .. p_data.hvt
                local tw = draw.GetTextSize(hvt_str, 12)
                label_y = label_y - 13
                draw.Text(mid - tw * 0.5, label_y, hvt_str, cfg.esp_hvt_c or {1, 0.85, 0.2, 1}, 12)
            end
        end

        if cfg.esp_dist then
            local dtxt = format("%dm", floor(dist_studs * M_PER_STUD))
            local tw = draw.GetTextSize(dtxt, 11)
            draw.Text(mid - tw * 0.5, b.y + b.h + 2, dtxt, cfg.esp_dist_c or GRAY, 11)
        end

        if cfg.esp_snap then
            draw.Line(scx, scy, mid, b.y + b.h, cfg.esp_snap_c, 1)
        end

        if cfg.esp_skel then
            local bones = nil
            pcall(function() bones = p:GetBonesScreen() end)
            if bones and type(bones) == "table" then
                local col = cfg.esp_skel_c or WHITE
                local skel_pairs = (bones["UpperTorso"] and SKEL) or (bones["Torso"] and SKEL_R6) or SKEL
                for j = 1, #skel_pairs do
                    local pair = skel_pairs[j]
                    local a = bones[pair[1]]
                    local sb = bones[pair[2]]
                    if a and sb then
                        local ax = a[1] or a.x or a.X
                        local ay = a[2] or a.y or a.Y
                        local bx = sb[1] or sb.x or sb.X
                        local by = sb[2] or sb.y or sb.Y
                        if ax and ay and bx and by then
                            draw.Line(ax, ay, bx, by, col, 1.5)
                        end
                    end
                end
            end
        end

        -- chams handled by draw_player_chams()

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
                            dt, cfg.npc_dist_c or GRAY, 11)
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

local function draw_world_label(part, name, col, max_r, contents, show_items, cam_pos)
if not part or not utility.IsValid(part) then return end
local pos = part.Position
if not pos then return end
local cam = cam_pos or (camera and camera.GetPosition and camera.GetPosition())
if not cam then return end
local dist = dist3(pos.X, pos.Y, pos.Z, cam.X, cam.Y, cam.Z)
max_r = (type(max_r) == "number" and max_r) or 3500
if max_r > 0 and dist > (max_r / 0.28) then return end
local sx, sy, vis = utility.WorldToScreen(pos.X, pos.Y, pos.Z)
if not vis then return end
local txt = format("%s [%dm]", name, floor(dist * 0.28))
local tw = #txt * 7.5
col = (type(col) == "table" and col) or {0.2, 0.8, 1, 1}
draw.Text(sx - tw*0.5, sy, txt, col, 13)
if show_items and contents then
local ly = sy + 14
local max_cnt = math.min(#contents, 12)
for j = 1, max_cnt do
    local itxt = contents[j]
    local itw = #itxt * 6.5
    local is_op = (is_op_loot and is_op_loot(itxt)) or (is_corpse_op_loot and is_corpse_op_loot(itxt))
    local icol = is_op and {1, 0.85, 0.2, 1} or (cfg.cont_items_c or cfg.corpse_items_c or GRAY)
    draw.Text(sx - itw*0.5, ly, itxt, icol, 11)
    ly = ly + 12
end
end
end

local function draw_world_esp()
local cam = camera and camera.GetPosition and camera.GetPosition()
if not cam then return end

if cfg.cont then
local max_c_dist = (cfg.cont_range or 500) / 0.28
local rendered_c = 0
for i = 1, #world.containers do
    local c = world.containers[i]
    if c.part and utility.IsValid(c.part) then
        local pos = c.part.Position
        if pos and dist3(pos.X, pos.Y, pos.Z, cam.X, cam.Y, cam.Z) <= max_c_dist then
            local items_to_show = (cfg.cont_filter == 1 and c.op_contents) or c.contents
            if cfg.cont_filter ~= 1 or (items_to_show and #items_to_show > 0) then
                draw_world_label(c.part, c.name, cfg.cont_c,
                    cfg.cont_range, items_to_show, cfg.cont_items, cam)
                rendered_c = rendered_c + 1
                if rendered_c >= 60 then break end
            end
        end
    end
end
end
if cfg.loot then
local pass = LOOT_PASS[cfg.loot_f] or LOOT_PASS[0]
local max_dist = (cfg.loot_range or 500) / 0.28
local rendered = 0
for i = 1, #world.items do
    local d = world.items[i]
    local cat = d.cat or get_item_category(d.name)
    if pass[cat] and d.part and utility.IsValid(d.part) then
        local pos = d.part.Position
        if pos and dist3(pos.X, pos.Y, pos.Z, cam.X, cam.Y, cam.Z) <= max_dist then
            draw_world_label(d.part, d.name, cfg.loot_c,
                cfg.loot_range, nil, false, cam)
            rendered = rendered + 1
            if rendered >= 60 then break end
        end
    end
end
end
if cfg.corpse then
local max_c_dist = (cfg.corpse_r or 500) * STUDS_PER_M
for i = 1, #world.corpses do
    local c = world.corpses[i]
    local should_draw = true
    local corpse_items = nil
    if cfg.corpse_op_only then
        if not c.op_contents or #c.op_contents == 0 then
            should_draw = false
        else
            corpse_items = c.op_contents
        end
    elseif cfg.corpse_i then
        corpse_items = c.good_contents or c.contents
    end

    if should_draw and c.part and utility.IsValid(c.part) then
        local pos = c.part.Position
        if pos and dist3(pos.X, pos.Y, pos.Z, cam.X, cam.Y, cam.Z) <= max_c_dist then
            local label = "CORPSE: " .. c.name
            draw_world_label(c.part, label, cfg.corpse_c,
                cfg.corpse_r, corpse_items, (cfg.corpse_i or cfg.corpse_op_only), cam)
        end
    end
end
end
if cfg.quest then
for i = 1, #world.quests do
    local q = world.quests[i]
    draw_world_label(q.part, q.name, cfg.quest_c,
        cfg.quest_r, nil, false, cam)
end
end
if cfg.extract then
for i = 1, #world.extracts do
    local e = world.extracts[i]
    draw_world_label(e.part, e.name or "Exit", cfg.extract_c,
        cfg.extract_r, nil, false, cam)
end
end
if cfg.hazard and world.hazards then
for i = 1, #world.hazards do
    local hz = world.hazards[i]
    local hz_col = hz.type == "rad" and {0.4, 1, 0.2, 0.9} or {1, 0.4, 0, 0.9}
    local hz_prefix = hz.type == "rad" and "RAD: " or "FIRE: "
    draw_world_label(hz.part, hz_prefix .. hz.name, cfg.hazard_c or hz_col,
        cfg.hazard_r or 1500, nil, false, cam)
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

-- (alias removed)

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

    local aim_key_mode = get_val("b_aim_key", 0x02) or 0x02
    local p_key_held = false
    if aim_key_mode == 0 or aim_key_mode == 0x02 then
        p_key_held = input.IsKeyDown(0x02)
    elseif aim_key_mode == 1 or aim_key_mode == 0x01 then
        p_key_held = input.IsKeyDown(0x01)
    elseif aim_key_mode == 2 or aim_key_mode == 0x12 or aim_key_mode == 0xA4 then
        p_key_held = input.IsKeyDown(0x12) or input.IsKeyDown(0xA4)
    elseif aim_key_mode == 3 or aim_key_mode == 0x10 or aim_key_mode == 0xA0 then
        p_key_held = input.IsKeyDown(0x10) or input.IsKeyDown(0xA0)
    elseif aim_key_mode == 4 then
        p_key_held = true
    elseif aim_key_mode > 4 then
        p_key_held = input.IsKeyDown(aim_key_mode)
    end

    local npc_key_mode = get_val("b_npc_aim_key", 0x02) or 0x02
    local npc_key_held = false
    if npc_key_mode == 0 or npc_key_mode == 0x02 then
        npc_key_held = input.IsKeyDown(0x02)
    elseif npc_key_mode == 1 or npc_key_mode == 0x01 then
        npc_key_held = input.IsKeyDown(0x01)
    elseif npc_key_mode == 2 or npc_key_mode == 0x12 or npc_key_mode == 0xA4 then
        npc_key_held = input.IsKeyDown(0x12) or input.IsKeyDown(0xA4)
    elseif npc_key_mode == 3 or npc_key_mode == 0x10 or npc_key_mode == 0xA0 then
        npc_key_held = input.IsKeyDown(0x10) or input.IsKeyDown(0xA0)
    elseif npc_key_mode == 4 then
        npc_key_held = true
    elseif npc_key_mode > 4 then
        npc_key_held = input.IsKeyDown(npc_key_mode)
    end

    local allow_players = cfg.aim and p_key_held
    local allow_npcs = cfg.npc_aim and npc_key_held

    if not allow_players and not allow_npcs then
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

        if allow_players then
            local players = frame_players or entity.GetPlayers() or {}
            local rbx_lp = nil
            pcall(function() rbx_lp = game.Players.LocalPlayer end)
            for i = 1, #players do
                local p = players[i]
                if p then
                    if not p.IsValid or not p.IsAlive or (p.Health and p.Health <= 0) or (p.IsDead == true) then goto skip_p end
                    local is_me = p.IsLocal or (lp and (p == lp or p.UserId == lp.UserId or p.Name == lp.Name or (p.Address and lp.Address and p.Address == lp.Address)))
                    if not is_me and rbx_lp then
                        if (rbx_lp.UserId and p.UserId == rbx_lp.UserId) or (rbx_lp.Name and p.Name == rbx_lp.Name) or (p.Character and rbx_lp.Character and p.Character == rbx_lp.Character) then
                            is_me = true
                        end
                    end
                    if is_me then goto skip_p end
                    local d_chk = p:DistanceTo()
                    if d_chk and d_chk < 3 then goto skip_p end
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
                    ::skip_p::
                end
            end
        end

        local best_npc = nil
        local best_npc_fov = cfg.na_fov or 150

        if allow_npcs and world and world.npcs and #world.npcs > 0 then
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

sil_rot_idx = 1
-- (unused vars removed)

local function run_silent_aim()
    local scx, scy = input.GetScreenCenter()
    if not scx or scx <= 0 or not scy or scy <= 0 then
        scx, scy = 960, 540
    end
    if cfg.sil_draw then
        local c = (type(cfg.sil_fov_c) == "table" and #cfg.sil_fov_c >= 3 and cfg.sil_fov_c)
            or (boba_colors and (boba_colors.b_silent_fov_c or boba_colors.b_silent_fov))
            or {1, 0.8, 0.2, 0.2}
        local a = c[4] or 0.2
        local fov_r = (type(cfg.sil_fov) == "number" and cfg.sil_fov > 0 and cfg.sil_fov)
            or tonumber(get_val("b_silent_fov", 200)) or 200
        if cfg.sil_fov_filled then
            draw.CircleFilled(scx, scy, fov_r, {c[1], c[2], c[3], a * 0.4}, 64)
        end
        draw.Circle(scx, scy, fov_r, c, 64)
    end

    if not cfg.silent or not is_gun_equipped() then
        if silent_ok then
            pcall(raycast.ClearSilentTarget)
            pcall(raycast.DisableSilentHook)
            silent_ok = false
        end
        world.silent_target_pos = nil
        world.silent_target_key = nil
        return
    end

    if not silent_ok then
        local s_ok = raycast.EnableSilentHook()
        if s_ok then silent_ok = true end
    end
    if not silent_ok then return end

    local lp = entity.GetLocalPlayer()
    if not lp then
        pcall(raycast.ClearSilentTarget)
        world.silent_target_pos = nil
        world.silent_target_key = nil
        world.silent_target_name = nil
        return
    end

    local players = frame_players or entity.GetPlayers() or {}
    local mode = get_val("b_silent_bone", 0) or 0
    local best_fov = cfg.sil_fov or 200
    local best_pos = nil
    local best_ply = nil

    for i = 1, #players do
        local p = players[i]
        if p then
            if not p.IsValid or not p.IsAlive or (p.Health and p.Health <= 0) or (p.IsDead == true) then goto skip end
            local is_me = p.IsLocal or (lp and (p.UserId == lp.UserId or p.Name == lp.Name or (p.Address and lp.Address and p.Address == lp.Address)))
            if not is_me then
                if cfg.sil_team and is_same_team(p) then goto skip end

                local bone_pos = get_player_bone_pos(p, mode == 4 and (sil_rot_idx - 1) or mode, scx, scy)
                if bone_pos then
                    local bx, by, bv = utility.WorldToScreen(bone_pos.X, bone_pos.Y, bone_pos.Z)
                    if bv then
                        local fov = screen_dist(bx, by, scx, scy)
                        if fov < best_fov then
                            best_fov = fov
                            best_pos = bone_pos
                            best_ply = p
                        end
                    end
                end
            end
            ::skip::
        end
    end

    if best_pos then
        world.silent_target_pos = best_pos
        world.silent_target_time = os.clock()
        world.silent_target_name = (best_ply and best_ply.Name) or "Player"
        world.silent_target_key = best_ply and (best_ply.UserId or best_ply.Name)
        world.silent_target_bone = mode
    else
        world.silent_target_pos = nil
        world.silent_target_key = nil
        world.silent_target_name = nil
    end

    local is_firing = input.IsKeyDown(0x01) and not is_any_menu_open()
    local origin = lp.HeadPosition or camera.GetPosition()
    if is_firing and best_pos and origin then
        local dir = best_pos - origin
        raycast.SetSilentTarget(origin, dir)
    else
        pcall(raycast.ClearSilentTarget)
    end
end



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
    if not vk or vk == 0 or vk == 0x02 then return "Right Click" end
    if vk == 0x01 or vk == 1 then return "Left Click"
    elseif vk == 0x04 then return "Middle Click"
    elseif vk == 0x05 then return "Mouse 4"
    elseif vk == 0x06 then return "Mouse 5"
    elseif vk == 0x20 then return "Space"
    elseif vk == 0x14 then return "Caps"
    elseif vk == 0x12 or vk == 0xA4 or vk == 2 then return "LAlt"
    elseif vk == 0x10 or vk == 0xA0 or vk == 3 then return "LShift"
    elseif vk == 4 then return "Auto"
    elseif vk == 0x24 then return "Home"
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
local cur_vk = get_val("b_menu_key", 0x24) or 0x24
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
        if p and p.IsValid and p.IsAlive and not p.IsLocal and not (p.Health and p.Health <= 0) then
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
local theme_col = cfg.insp_c or mc("b_inspect_c", {0.4, 0.8, 1, 1})
local theme_sub = { theme_col[1] * 0.85, theme_col[2] * 0.85, theme_col[3] * 0.85, 1.0 }
local tr, tg, tb = theme_col[1], theme_col[2], theme_col[3]
if not closest then
    lines[#lines+1] = {txt = "INVENTORY CHECKER", col = theme_col, size = 13}
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
            local base = iname:match("^(.-)%s*x%d+$") or iname
            if not is_mag_or_trash(base) and not TRASH_ITEMS[base] then
                local cat = get_item_category(base)
                local is_good = is_good_item(base)
                if (cat == "special" or is_good) and cfg.inv_special then
                    specials[#specials+1] = iname
                elseif cat == "weapon" and cfg.inv_weap then
                    if iname ~= closest.equipped then
                        weapons[#weapons+1] = iname
                    end
                elseif cat == "armor" and cfg.inv_armor then
                    armor[#armor+1] = iname
                elseif cfg.inv_misc and is_good then
                    misc_items[#misc_items+1] = iname
                end
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
    if cfg.cheater_finder and closest.is_cheater then
        lines[#lines+1] = {txt = "CHEATER", col = {1, 0.2, 0.2, 1}, size = 12}
    end
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
    pcall(function()
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
    end)
    if terrain and terrain.GetGrassLength then
        pcall(function() orig_grass = terrain.GetGrassLength() end)
    end
    pcall(function()
        local ws = game.Workspace
        local tr = ws and (ws.Terrain or ws:FindFirstChildOfClass("Terrain"))
        if tr and world.orig_decor == nil then
            world.orig_decor = tr.Decoration
        end
    end)
end

local function restore_originals()
    if orig_light then
        pcall(function()
            lighting.SetBrightness(orig_light.br)
            lighting.SetAmbient(orig_light.am)
            lighting.SetOutdoorAmbient(orig_light.oa)
            lighting.SetExposure(orig_light.ex)
            lighting.SetFogStart(orig_light.fs)
            lighting.SetFogEnd(orig_light.fe)
            lighting.SetDiffuseScale(orig_light.ds)
            lighting.SetSpecularScale(orig_light.ss)
        end)
        orig_light = nil
    end
    if orig_grass and terrain and terrain.SetGrassLength then
        pcall(function() terrain.SetGrassLength(orig_grass) end)
        orig_grass = nil
    end
    if world.orig_decor ~= nil then
        pcall(function()
            local ws = game.Workspace
            local tr = ws and (ws.Terrain or ws:FindFirstChildOfClass("Terrain"))
            if tr then
                pcall(function() sethiddenproperty(tr, "Decoration", world.orig_decor) end)
                pcall(function() tr.Decoration = world.orig_decor end)
            end
        end)
        world.orig_decor = nil
    end
    if world.grass_orig then
        for part, origTr in pairs(world.grass_orig) do
            pcall(function()
                if part and part.Parent then part.Transparency = origTr end
            end)
        end
        world.grass_orig = {}
    end
end

local last_applied_nograss = nil
local last_applied_bright = nil
local last_applied_nofog = nil
local last_applied_noshadow = nil
local last_applied_foliage = nil

local function apply_world_mods()
    local cur_nograss = (cfg.nograss == true) or (mg("b_nograss") == true)
    local cur_bright = (mg("b_bright") == true)
    local cur_nofog = (mg("b_nofog") == true)
    local cur_noshadow = (mg("b_noshadow") == true)

    if cur_nograss == last_applied_nograss
        and cur_bright == last_applied_bright
        and cur_nofog == last_applied_nofog
        and cur_noshadow == last_applied_noshadow then
        return
    end

    local any = cur_bright or cur_nofog or cur_noshadow or cur_nograss
    if any then save_originals() end

    if cur_bright ~= last_applied_bright then
        last_applied_bright = cur_bright
        if cur_bright then
            lighting.SetBrightness(4)
            lighting.SetAmbient(1)
            lighting.SetOutdoorAmbient(1)
        elseif orig_light then
            lighting.SetBrightness(orig_light.br)
            lighting.SetAmbient(orig_light.am)
            lighting.SetOutdoorAmbient(orig_light.oa)
        end
    end

    if cur_nofog ~= last_applied_nofog then
        last_applied_nofog = cur_nofog
        if cur_nofog then
            lighting.SetFogStart(100000)
            lighting.SetFogEnd(100000)
        elseif orig_light then
            lighting.SetFogStart(orig_light.fs)
            lighting.SetFogEnd(orig_light.fe)
        end
    end

    if cur_noshadow ~= last_applied_noshadow then
        last_applied_noshadow = cur_noshadow
        if cur_noshadow then
            lighting.SetDiffuseScale(0)
            lighting.SetSpecularScale(0)
        elseif orig_light then
            lighting.SetDiffuseScale(orig_light.ds)
            lighting.SetSpecularScale(orig_light.ss)
        end
    end

    if cur_nograss ~= last_applied_nograss then
        last_applied_nograss = cur_nograss
        if cur_nograss then
            if terrain and terrain.SetGrassLength then
                pcall(function() terrain.SetGrassLength(0) end)
            end
            pcall(function()
                local ws = game.Workspace
                local tr = ws and (ws.Terrain or ws:FindFirstChildOfClass("Terrain"))
                if tr then
                    local sethidden = sethiddenproperty or set_hidden_property or set_hidden_prop
                    if sethidden then pcall(sethidden, tr, "Decoration", false) end
                    pcall(function() tr.Decoration = false end)
                    for _, dec in ipairs(tr:GetChildren()) do
                        if dec:IsA("Decoration") or dec.Name:lower():find("grass") then
                            pcall(function() dec.Transparency = 1 end)
                        end
                    end
                end
            end)
            local ws = game.Workspace
            if ws then
                local function hide_grass_in(container)
                    if not container then return end
                    local ok_d, descs = pcall(function() return container:GetDescendants() end)
                    if not ok_d or not descs then return end
                    for _, o in ipairs(descs) do
                        if o and o:IsA("BasePart") and world.grass_orig[o] == nil then
                            world.grass_orig[o] = o.Transparency or 0
                            o.Transparency = 1
                        end
                    end
                end
                local ok_ch, wch = pcall(function() return ws:GetChildren() end)
                if ok_ch and wch then
                    for _, c in ipairs(wch) do
                        if c then
                            local cn = c.Name:lower()
                            if cn:find("grass") or cn:find("weed") or cn:find("clover") or cn:find("turf") then
                                if c:IsA("Model") or c:IsA("Folder") then
                                    hide_grass_in(c)
                                elseif c:IsA("BasePart") and world.grass_orig[c] == nil then
                                    world.grass_orig[c] = c.Transparency or 0
                                    c.Transparency = 1
                                end
                            end
                        end
                    end
                end
            end
        else
            if orig_grass and terrain and terrain.SetGrassLength then
                pcall(function() terrain.SetGrassLength(orig_grass) end)
            end
            pcall(function()
                local ws = game.Workspace
                local tr = ws and (ws.Terrain or ws:FindFirstChildOfClass("Terrain"))
                if tr then
                    local dec = (world.orig_decor ~= nil) and world.orig_decor or true
                    pcall(function() sethiddenproperty(tr, "Decoration", dec) end)
                    pcall(function() tr.Decoration = dec end)
                end
            end)
            if world.grass_orig and next(world.grass_orig) ~= nil then
                for part, origTr in pairs(world.grass_orig) do
                    pcall(function()
                        if part and part.Parent then
                            part.Transparency = origTr
                        end
                    end)
                end
                world.grass_orig = {}
            end
        end
    end
end

local function apply_foliage_mods()
    local on = (cfg.remove_foliage == true) or (mg("b_remove_foliage") == true)
    if on == last_applied_foliage then return end
    last_applied_foliage = on
    if on then
        local ws = game.Workspace
        if not ws then return end

        local function hide_foliage_in(container)
            if not container then return end
            local ok_d, descs = pcall(function() return container:GetDescendants() end)
            if not ok_d or not descs then return end
            for _, o in ipairs(descs) do
                if o and o:IsA("BasePart") and world.foliage_orig[o] == nil then
                    world.foliage_orig[o] = o.Transparency or 0
                    o.Transparency = 1
                end
            end
        end

        local sz = ws:FindFirstChild("SpawnerZones")
        if sz then
            local fol = sz:FindFirstChild("Foliage")
            if fol then hide_foliage_in(fol) end
        end
        local nc = ws:FindFirstChild("NoCollision")
        if nc then
            local fz = nc:FindFirstChild("FoliageZones")
            if fz then hide_foliage_in(fz) end
        end
        local map_f = ws:FindFirstChild("Map")
        if map_f then
            local fol = map_f:FindFirstChild("Foliage") or map_f:FindFirstChild("Trees") or map_f:FindFirstChild("Bushes")
            if fol then hide_foliage_in(fol) end
        end

        local ok_ch, wch = pcall(function() return ws:GetChildren() end)
        if ok_ch and wch then
            for _, c in ipairs(wch) do
                if c and c:IsA("Model") then
                    local cn = c.Name:lower()
                    if cn:find("tree") or cn:find("pine") or cn:find("birch") or cn:find("oak")
                        or cn:find("bush") or cn:find("shrub") or cn:find("fern")
                        or cn:find("plant") or cn:find("foliage") or cn:find("hedge") then
                        hide_foliage_in(c)
                    end
                elseif c and c:IsA("BasePart") and world.foliage_orig[c] == nil then
                    local cn = c.Name:lower()
                    if cn:find("leaf") or cn:find("leaves") or cn:find("foliage") or cn:find("bush") then
                        world.foliage_orig[c] = c.Transparency or 0
                        c.Transparency = 1
                    end
                end
            end
        end
    else
        if world.foliage_orig and next(world.foliage_orig) ~= nil then
            for part, origTr in pairs(world.foliage_orig) do
                pcall(function()
                    if part and part.Parent then
                        part.Transparency = origTr
                    end
                end)
            end
            world.foliage_orig = {}
        end
    end
end

local function scan_claymores()
if not cfg.claymore then world_claymores = {}; return end
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
if not cfg.boss then return end
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
if not cfg.mod_alert then detected_mods = {}; return end
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


local last_suspects_update = 0
local cached_suspects = {}

local function draw_cheater_panel()
    if not cfg.cheater_finder then
        cheater_drag = false
        return
    end

    -- Instant check: only show up when there is a sus player or cheater
    local has_sus = false
    if world.hacker_tracker then
        for _, ht in pairs(world.hacker_tracker) do
            if (ht.flags and ht.flags > 0) or ht.is_speeding or (ht.max_spd and ht.max_spd >= 35) then
                has_sus = true
                break
            end
        end
    end
    if not has_sus and longshot_kills then
        for _, lsk in pairs(longshot_kills) do
            if lsk >= 3 then
                has_sus = true
                break
            end
        end
    end
    if not has_sus then
        cheater_drag = false
        return
    end

    local pw = 320
    local TH = 24
    local PAD = 8
    local row_h = 36

    local now_t = tick()
    if (now_t - last_suspects_update) >= 0.5 then
        last_suspects_update = now_t
        local suspects = {}
        local p_list = frame_players or entity.GetPlayers() or {}
        local p_map = world.player_map or {}
        for i = 1, #p_list do
            local p = p_list[i]
            if p and not p.IsLocal then
                local pname = p.Name or "Player"
                local ht = (world.hacker_tracker and world.hacker_tracker[pname]) or {}
                local flags = ht.flags or 0
                local max_spd = ht.max_spd or 0
                local is_speeding = ht.is_speeding or false
                local wp = p_map[pname]
                local acct_age = (wp and wp.acct_age) or -1
                local ls_kills = (wp and wp.ls_kills) or (longshot_kills and longshot_kills[pname]) or 0
                local kd = (wp and wp.kd) or 0
                local hours = (wp and wp.hours) or 0

                if ls_kills >= 5 then
                    flags = flags + 2
                elseif ls_kills >= 3 then
                    flags = flags + 1
                end
                if acct_age >= 0 and acct_age < 30 and (flags > 0 or is_speeding) then
                    flags = flags + 1
                end

                local is_sus = (flags > 0) or is_speeding or (max_spd >= 35) or (ls_kills >= 3)
                if is_sus then
                    suspects[#suspects + 1] = {
                        name = pname,
                        display = p.DisplayName or pname,
                        acct_age = acct_age,
                        ls_kills = ls_kills,
                        kd = kd,
                        hours = hours,
                        flags = flags,
                        max_spd = max_spd,
                        is_speeding = is_speeding,
                        userId = p.UserId or ht.userId or 0
                    }
                end
            end
        end

        table.sort(suspects, function(a, b)
            if a.flags ~= b.flags then
                return a.flags > b.flags
            end
            if a.ls_kills ~= b.ls_kills then
                return a.ls_kills > b.ls_kills
            end
            if a.acct_age ~= b.acct_age then
                return a.acct_age < b.acct_age
            end
            return a.kd > b.kd
        end)
        cached_suspects = suspects
    end

    local suspects = cached_suspects
    if not suspects or #suspects == 0 then
        cheater_drag = false
        return
    end

    local top_count = math.min(8, #suspects)
    local ph = TH + PAD + (top_count * (row_h + 4)) + 4

    local menu_active = is_any_menu_open()
    if not menu_active then
        cheater_drag = false
    end

    local mx, my = utility.GetMousePos()
    local lmb = menu_active and input.IsKeyDown(0x01)
    if lmb then
        if not cheater_drag then
            if mx >= cheater_x and mx <= cheater_x + pw and my >= cheater_y and my <= cheater_y + TH then
                cheater_drag = true
                cheater_dx = mx - cheater_x
                cheater_dy = my - cheater_y
            end
        else
            cheater_x = mx - cheater_dx
            cheater_y = my - cheater_dy
        end
    else
        cheater_drag = false
    end

    local px, py = cheater_x, cheater_y
    local theme_col, theme_sub = get_active_theme()
    local tr, tg, tb = theme_col[1], theme_col[2], theme_col[3]

    -- Main window frame
    draw.RectFilled(px, py, pw, ph, {0.05 + tr * 0.04, 0.05 + tg * 0.04, 0.07 + tb * 0.04, 0.95}, 4)
    draw.RectFilled(px, py, pw, TH, {0.07 + tr * 0.05, 0.07 + tg * 0.05, 0.09 + tb * 0.05, 1.00}, 4)
    draw.RectFilled(px, py, 2, TH, theme_col, 0)
    draw.Line(px, py + TH, px + pw, py + TH, theme_col, 1)
    draw.Rect(px, py, pw, ph, {theme_col[1] * 0.5, theme_col[2] * 0.5, theme_col[3] * 0.5, 0.7}, 4, 1)

    local title = "Cheater Finder"
    if top_count > 0 then
        title = title .. string.format("  [%d Suspect%s]", top_count, top_count > 1 and "s" or "")
    else
        title = title .. "  [No Suspects]"
    end
    draw.Text(px + PAD + 2, py + 5, title, (top_count > 0) and {1.0, 0.3, 0.3, 1.0} or theme_col, 13)
    local hint = "drag ::"
    local hw = draw.GetTextSize(hint, 10)
    hw = (type(hw) == "number" and hw > 0 and hw) or 30
    draw.Text(px + pw - hw - PAD, py + 6, hint, {0.4, 0.4, 0.5, 0.8}, 10)

    if top_count == 0 then
        return
    end

    local ly = py + TH + PAD
    for idx = 1, top_count do
        local entry = suspects[idx]
        local ry = ly + (idx - 1) * (row_h + 4)
        local rw = pw - PAD * 2
        local rx = px + PAD

        -- Row background
        local row_bg = (entry.flags >= 2 or entry.is_speeding) and {0.24, 0.05, 0.05, 0.75} or {0.18, 0.10, 0.04, 0.70}
        draw.RectFilled(rx, ry, rw, row_h, row_bg, 3)
        draw.Rect(rx, ry, rw, row_h, (entry.flags >= 2 or entry.is_speeding) and {0.8, 0.2, 0.2, 0.5} or {0.8, 0.5, 0.1, 0.4}, 3, 1)

        -- Initials badge (instant, zero network lag)
        local av_sz = 26
        local av_x = rx + 4
        local av_y = ry + math.floor((row_h - av_sz) / 2)
        local ini_bg = (entry.flags >= 2 or entry.is_speeding) and {0.35, 0.08, 0.08, 0.95} or {0.22, 0.14, 0.05, 0.95}
        local ini_border = (entry.flags >= 2 or entry.is_speeding) and {0.9, 0.25, 0.25, 0.8} or {0.8, 0.55, 0.15, 0.8}
        draw.RectFilled(av_x, av_y, av_sz, av_sz, ini_bg, 2)
        draw.Rect(av_x, av_y, av_sz, av_sz, ini_border, 2, 1)
        local ini = entry.name:sub(1, 2):upper()
        draw.Text(av_x + 5, av_y + 6, ini, {1.0, 0.95, 0.95, 1.0}, 10)

        -- Player info — color name + stats based on threat level
        local info_x = av_x + av_sz + 6
        local name_txt = entry.name
        if #name_txt > 14 then name_txt = name_txt:sub(1, 13) .. ".." end
        -- Green for clean, orange for sus, red for cheater
        local name_col, stat_col
        if entry.flags >= 3 then
            name_col = {1.0, 0.25, 0.25, 1.0}
            stat_col = {1.0, 0.35, 0.35, 0.95}
        elseif entry.flags >= 1 or entry.is_speeding then
            name_col = {1.0, 0.75, 0.2, 1.0}
            stat_col = {1.0, 0.65, 0.25, 0.9}
        else
            name_col = {0.3, 0.95, 0.45, 1.0}
            stat_col = {0.35, 0.85, 0.5, 0.9}
        end
        draw.Text(info_x, ry + 3, name_txt, name_col, 11)

        -- Stats line: Account Age + Longshots + Speed
        local parts = {}
        if entry.acct_age >= 0 then
            local age_str
            if entry.acct_age < 1 then
                age_str = "<1d"
            elseif entry.acct_age < 365 then
                age_str = string.format("%dd", entry.acct_age)
            else
                age_str = string.format("%.1fy", entry.acct_age / 365)
            end
            parts[#parts + 1] = "Acct:" .. age_str
        end
        if entry.kd > 0 then
            parts[#parts + 1] = string.format("KD:%.1f", entry.kd)
        end
        if entry.hours > 0 then
            parts[#parts + 1] = string.format("%dh", entry.hours)
        end
        if entry.ls_kills > 0 then
            parts[#parts + 1] = string.format("LS:%d", entry.ls_kills)
        end
        if entry.max_spd and entry.max_spd > 0 then
            parts[#parts + 1] = string.format("%ds/s", entry.max_spd)
        end
        local stats_txt = #parts > 0 and table.concat(parts, " | ") or "monitoring..."
        draw.Text(info_x, ry + 17, stats_txt, stat_col, 9)


        -- Flag badge on the right
        local badge_col, badge_txt, bg_badge
        if entry.flags >= 3 then
            badge_col = {1.0, 0.2, 0.2, 1.0}
            bg_badge = {0.35, 0.05, 0.05, 0.85}
            badge_txt = string.format("CHEATER (%d)", entry.flags)
        elseif entry.flags >= 1 or entry.is_speeding then
            badge_col = {1.0, 0.75, 0.2, 1.0}
            bg_badge = {0.30, 0.18, 0.04, 0.85}
            badge_txt = string.format("SUS (%d)", math.max(1, entry.flags))
        else
            badge_col = {0.4, 0.85, 0.5, 0.8}
            bg_badge = {0.05, 0.18, 0.08, 0.6}
            badge_txt = "CLEAN"
        end

        local bw, _ = draw.GetTextSize(badge_txt, 10)
        bw = (type(bw) == "number" and bw > 0 and bw) or (#badge_txt * 6.5)
        local bx = rx + rw - bw - 10
        local by = ry + 4
        draw.RectFilled(bx - 3, by, bw + 6, 14, bg_badge, 2)
        draw.Rect(bx - 3, by, bw + 6, 14, badge_col, 2, 1)
        draw.Text(bx, by + 1, badge_txt, badge_col, 10)

        -- Speed indicator bottom-right
        if entry.max_spd and entry.max_spd > 0 then
            local spd_txt = string.format("%d s/s", entry.max_spd)
            local sw_sz, _ = draw.GetTextSize(spd_txt, 9)
            sw_sz = (type(sw_sz) == "number" and sw_sz > 0 and sw_sz) or (#spd_txt * 6)
            draw.Text(rx + rw - sw_sz - 10, ry + 20, spd_txt, {0.6, 0.6, 0.7, 0.75}, 9)
        end
    end
end


local function scan_cars()
    if not cfg.car then world_cars = {}; return end
    local ws = game.Workspace
    if not ws then return end
    local results = {}
    local seen = {}

    local function check_cand(model)
        if not model or seen[model] then return end
        local is_mod = model:IsA("Model")
        local is_folder = model:IsA("Folder")
        if not is_mod and not is_folder then return end

        local vseat = model:FindFirstChildOfClass("VehicleSeat")
            or model:FindFirstChild("DriveSeat")
        local name_match = is_car_name(model.Name)

        if vseat or name_match then
            local prim = vseat or model.PrimaryPart or model:FindFirstChild("Chassis") or model:FindFirstChild("Body") or model:FindFirstChildOfClass("BasePart")
            if prim and prim.Position then
                seen[model] = true
                results[#results + 1] = {
                    name = model.Name,
                    part = prim
                }
            end
        end
    end

    -- Check only dedicated vehicle spawn folders
    for _, fname in ipairs({"Vehicles", "Cars", "SpawnedVehicles", "VehicleSpawners", "WorldVehicles"}) do
        local folder = ws:FindFirstChild(fname)
        if folder then
            local ok, ch = pcall(function() return folder:GetChildren() end)
            if ok and ch then
                for _, c in ipairs(ch) do
                    check_cand(c)
                end
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
    local max_r = (cfg.car_r or 2000) * STUDS_PER_M
    for i = 1, #world_cars do
        local c = world_cars[i]
        local pos = c.part and utility.IsValid(c.part) and c.part.Position
        if pos then
            local d = dist3(pos.X, pos.Y, pos.Z, cx, cy, cz)
            if d <= max_r then
                local sx, sy, sv = utility.WorldToScreen(pos.X, pos.Y, pos.Z)
                if not sv then
                    sx, sy, sv = draw.WorldToScreen(pos.X, pos.Y, pos.Z)
                end
                if sv then
                    local dm = floor(d * M_PER_STUD)
                    local txt = format("CAR: %s [%dm]", c.name, dm)
                    local tw = draw.GetTextSize(txt, 13)
                    tw = (type(tw) == "number" and tw > 0 and tw) or (#txt * 7.5)
                    local col = cfg.car_c or {1.0, 0.75, 0.2, 1.0}
                    draw.Text(sx - tw * 0.5, sy, txt, col, 13)
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
    if p and p.IsValid and p.IsAlive and not (p.Health and p.Health <= 0) and not p.IsLocal then
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



local function update_hacker_detector()
    if not cfg.cheater_finder then return end
    local now = tick()
    local threshold = 35
    local duration = 0.8
    for i = 1, #frame_players do
        local p = frame_players[i]
        if p and not p.IsLocal and p.IsAlive then
            local pos = p.Position
            if pos then
                local d = world.hacker_tracker[p.Name]
                if not d then
                    world.hacker_tracker[p.Name] = { pos = pos, time = now, h_since = nil, last_alert = 0, is_speeding = false, flags = 0, max_spd = 0, userId = p.UserId or 0 }
                else
                    if not d.flags then d.flags = 0 end
                    if not d.max_spd then d.max_spd = 0 end
                    if not d.userId or d.userId == 0 then d.userId = p.UserId or 0 end
                    local dt = now - d.time
                    if dt >= 0.25 then
                        local dx = pos.X - d.pos.X
                        local dz = pos.Z - d.pos.Z
                        local dist_h = math.sqrt(dx * dx + dz * dz)
                        if dist_h > 65 then
                            d.pos = pos
                            d.time = now
                            d.h_since = nil
                        else
                            local actual_spd = dist_h / dt
                            if actual_spd >= threshold then
                                if not d.h_since then
                                    d.h_since = now
                                elseif (now - d.h_since) >= duration then
                                    if not d.is_speeding then
                                        d.flags = d.flags + 1
                                    end
                                    d.is_speeding = true
                                    local int_spd = math.floor(actual_spd + 0.5)
                                    if int_spd > d.max_spd then
                                        d.max_spd = int_spd
                                    end
                                    if world and world.players then
                                        for _, wp in ipairs(world.players) do
                                            if wp.name == p.Name then wp.is_cheater = true; break end
                                        end
                                    end
                                    if (now - d.last_alert) >= 10.0 then
                                        d.last_alert = now
                                        pcall(function()
                                            notify.Warning("HACKER DETECTED", string.format("%s moving abnormally fast! (%d studs/s)", p.Name, int_spd), 4)
                                        end)
                                    end
                                end
                            else
                                d.h_since = nil
                                d.is_speeding = false
                            end
                            d.pos = pos
                            d.time = now
                        end
                    end
                end
            end
        end
    end
end

local last_gun_check = 0
local cached_gun_state = false

is_gun_equipped = function()
    local now_t = tick()
    if (now_t - last_gun_check) < 0.25 then
        return cached_gun_state
    end
    last_gun_check = now_t

    local lp = entity.GetLocalPlayer()
    if not lp or not lp.IsAlive then
        cached_gun_state = false
        return false
    end

    local eq_name = nil
    pcall(function()
        local rep = game.ReplicatedStorage
        if rep and lp.Name then
            local p_data = rep:FindFirstChild("Players") and rep.Players:FindFirstChild(lp.Name)
            local status = p_data and p_data:FindFirstChild("Status")
            local gv = status and status:FindFirstChild("GameplayVariables")
            local eq = gv and gv:FindFirstChild("EquippedTool")
            if eq and eq.Value then
                eq_name = (type(eq.Value) == "string" and eq.Value)
                    or (type(eq.Value) == "userdata" and eq.Value.Name)
                    or tostring(eq.Value)
            end
        end
    end)

    if not eq_name or eq_name == "" or eq_name:lower() == "none" or eq_name:lower() == "hands" then
        pcall(function()
            local char = lp.Character
            if char and utility.IsValid(char) then
                for _, ch in ipairs(char:GetChildren()) do
                    if (ch:IsA("Model") or ch:IsA("Tool")) and ch.Name ~= "Clothing" and ch.Name ~= "Holstered" and ch.Name ~= "ViewModel" then
                        eq_name = ch.Name
                        break
                    end
                end
            end
        end)
    end

    if not eq_name or eq_name == "" or eq_name:lower() == "none" or eq_name:lower() == "hands" then
        cached_gun_state = false
        return false
    end

    local low = eq_name:lower()
    if low:find("knife") or low:find("dv2") or low:find("melee") or low:find("blade")
        or low:find("axe") or low:find("scythe") or low:find("tomahawk")
        or low:find("sword") or low:find("crowbar") or low:find("dagger")
        or low:find("karambit") or low:find("kukri") or low:find("pick")
        or low:find("lighter") or low:find("map") or low:find("bandage")
        or low:find("splint") or low:find("medkit") or low:find("ifak")
        or low:find("ai2") or low:find("injector") or low:find("suture")
        or low:find("food") or low:find("drink") or low:find("bottle")
        or low:find("can") or low:find("key") or low:find("card")
        or low:find("grenade") or low:find("f1") or low:find("rgd") then
        cached_gun_state = false
        return false
    end

    if WEAPON_CALIBER then
        for k in pairs(WEAPON_CALIBER) do
            if low:find(k:lower(), 1, true) then
                cached_gun_state = true
                return true
            end
        end
    end
    if low:find("rifle") or low:find("pistol") or low:find("shotgun") or low:find("smg")
        or low:find("sniper") or low:find("carbine") or low:find("gun") or low:find("revolver")
        or low:find("mosin") or low:find("ak") or low:find("m4") or low:find("svd")
        or low:find("val") or low:find("vintorez") or low:find("mp") or low:find("glock")
        or low:find("beretta") or low:find("colt") or low:find("tokarev") or low:find("makarov")
        or low:find("sks") or low:find("saiga") or low:find("toz") or low:find("izh")
        or low:find("fal") or low:find("r700") or low:find("tfz") or low:find("groza")
        or low:find("vz61") or low:find("tt33") or low:find("adar") or low:find("pkm")
        or low:find("ppsh") or low:find("scar") or low:find("aug") or low:find("hk")
        or low:find("m16") or low:find("m14") or low:find("remington") or low:find("mossberg")
        or low:find("deagle") or low:find("usp") or low:find("vector") or low:find("ump")
        or low:find("mpx") or low:find("p90") or low:find("sr25") or low:find("g3")
        or low:find("l96") or low:find("awm") or low:find("awp") or low:find("rpk") then
        cached_gun_state = true
        return true
    end

    cached_gun_state = true
    return true
end

local function is_weapon_full_auto()
    local lp = entity.GetLocalPlayer()
    local rep = game.ReplicatedStorage
    if rep and lp and lp.Name then
        local p_data = rep:FindFirstChild("Players") and rep.Players:FindFirstChild(lp.Name)
        local status = p_data and p_data:FindFirstChild("Status")
        local gv = status and status:FindFirstChild("GameplayVariables")
        local eq = gv and gv:FindFirstChild("EquippedTool")
        if eq and eq.Value then
            local n = tostring(eq.Value):lower()
            if n:find("ak") or n:find("m4a1") or n:find("pkm") or n:find("fal")
                or n:find("asval") or n:find("mp5") or n:find("ppsh")
                or n:find("groza") or n:find("vz61") then
                return true
            end
        end
    end
    return false
end

local function get_gun_muzzle_pos()
    local ws = game.Workspace
    local cam = get_cam_instance()
    local vm = (cam and cam:FindFirstChild("ViewModel")) or (ws and ws:FindFirstChild("ViewModel"))
    if vm and utility.IsValid(vm) then
        local item = vm:FindFirstChild("Item") or vm
        if item and utility.IsValid(item) then
            for _, name in ipairs({"Muzzle", "Flashhider", "Barrel", "MuzzleOffset", "Tip", "FrontSight"}) do
                local p = item:FindFirstChild(name)
                if p and utility.IsValid(p) and p.Position then
                    return p.Position
                end
            end
            local ch = item:GetChildren()
            for i = 1, #ch do
                local c = ch[i]
                if c and utility.IsValid(c) and c:IsA("BasePart") then
                    local cl = c.Name:lower()
                    if cl:find("muzzle") or cl:find("barrel") or cl:find("flash") then
                        return c.Position
                    end
                end
            end
        end
    end

    local lp = entity.GetLocalPlayer()
    local char = lp and lp.Character
    if char and utility.IsValid(char) then
        for _, ch in ipairs(char:GetChildren()) do
            if (ch:IsA("Model") or ch:IsA("Tool")) and ch.Name ~= "Clothing" and ch.Name ~= "Holstered" and ch.Name ~= "ViewModel" then
                local m = ch:FindFirstChild("Muzzle") or ch:FindFirstChild("Barrel")
                if m and utility.IsValid(m) and m.Position then
                    return m.Position
                end
            end
        end
        local rh = char:FindFirstChild("RightHand") or char:FindFirstChild("Right Arm")
        if rh and utility.IsValid(rh) and rh.Position then
            local look = camera.GetLookVector() or Vector3.New(0, 0, 1)
            return rh.Position + look * 1.5
        end
    end

    local cam_pos = camera.GetPosition()
    local look = camera.GetLookVector()
    if cam_pos and look then
        local up = Vector3.New(0, 1, 0)
        local right = Vector3.New(look.Z, 0, -look.X)
        local mag = math.sqrt(right.X * right.X + right.Z * right.Z)
        if mag > 0.001 then
            right = Vector3.New(right.X / mag, 0, right.Z / mag)
        else
            right = Vector3.New(1, 0, 0)
        end
        return cam_pos + look * 1.2 + right * 0.4 - up * 0.3
    end
    return nil
end

local function check_combat_hits()
    local is_hl_on = (cfg.hit_logs == true)
    local is_hm_on = (cfg.hitmarker == true)
    local is_tracer_on = (cfg.bullet_tracers == true)
    if not is_hl_on and not is_hm_on and not is_tracer_on then return end

    local now = os.clock()
    local hit_dur = cfg.hit_log_dur or 4.0

    -- 1. Check other Players live health
    for i = 1, #frame_players do
        local p = frame_players[i]
        if p and not p.IsLocal then
            local key = p.UserId or p.Name
            local old_hp = world.enemy_health[key]
            local cur_hp = p.Health
            local is_alive = p.IsAlive
            if is_alive == nil then
                is_alive = (not p.IsDead) and (cur_hp == nil or cur_hp > 0)
            end

            local pos = p.HeadPosition or p.Position
            if not pos and world.enemy_last_pos then
                pos = world.enemy_last_pos[key]
            end
            if not pos and world.my_last_target_key == key then
                pos = world.my_last_target_pos
            end
            if pos then
                if not world.enemy_last_pos then world.enemy_last_pos = {} end
                world.enemy_last_pos[key] = pos
            end

            local dmg = 0
            local is_kill = false

            if old_hp and old_hp > 0 then
                if cur_hp and cur_hp < old_hp and (old_hp - cur_hp) >= 1 then
                    dmg = math.floor(old_hp - cur_hp + 0.5)
                    if not is_alive or (cur_hp and cur_hp <= 0) then
                        is_kill = true
                    end
                elseif not is_alive or (cur_hp and cur_hp <= 0) then
                    -- One-shot or fatal hit!
                    dmg = math.floor(old_hp + 0.5)
                    is_kill = true
                end
            elseif old_hp == nil then
                if is_alive and cur_hp and cur_hp > 0 then
                    world.enemy_health[key] = cur_hp
                elseif not is_alive or (cur_hp and cur_hp <= 0) then
                    local time_since_shot = now - (world.my_last_shot_time or 0)
                    if time_since_shot >= 0 and time_since_shot <= 0.40 then
                        dmg = math.floor((p.MaxHealth and p.MaxHealth > 0 and p.MaxHealth) or 100)
                        is_kill = true
                    end
                end
            end

            if dmg > 0 then
                local is_my_hit = false
                local time_since_shot = now - (world.my_last_shot_time or 0)
                if time_since_shot >= 0 and time_since_shot <= 2.0 then
                    if world.my_last_target_key and (world.my_last_target_key == key or world.my_last_target_name == p.Name) then
                        is_my_hit = true
                    elseif world.silent_target_pos and pos and dist3(pos.X, pos.Y, pos.Z, world.silent_target_pos.X, world.silent_target_pos.Y, world.silent_target_pos.Z) <= 8.0 then
                        is_my_hit = true
                    elseif world.my_last_shot_look and pos then
                        local cam_pos = camera.GetPosition()
                        if cam_pos then
                            local v = pos - cam_pos
                            local proj = v.X * world.my_last_shot_look.X + v.Y * world.my_last_shot_look.Y + v.Z * world.my_last_shot_look.Z
                            if proj > 0.5 then
                                local rx = cam_pos.X + world.my_last_shot_look.X * proj
                                local ry = cam_pos.Y + world.my_last_shot_look.Y * proj
                                local rz = cam_pos.Z + world.my_last_shot_look.Z * proj
                                if dist3(pos.X, pos.Y, pos.Z, rx, ry, rz) <= 15.0 then
                                    is_my_hit = true
                                end
                            end
                        end
                    else
                        is_my_hit = true
                    end
                end

                if is_my_hit then
                    if is_hm_on then
                        world.hitmarker = { time = now, pos = pos, is_head = (dmg >= 55 or is_kill) }
                    end
                    if is_hl_on then
                        local ts = (os.date and os.date("%H:%M:%S")) or "00:00:00"
                        local p_name = p.Name or "Player"
                        local kill_str = is_kill and " [KILL]" or ""
                        table.insert(world.hit_logs, {
                            text = string.format("[%s] Hit %s for -%d HP%s", ts, p_name, dmg, kill_str),
                            created = now,
                            lifetime = hit_dur
                        })
                        if #world.hit_logs > 8 then table.remove(world.hit_logs, 1) end
                    end
                    if is_tracer_on and pos then
                        local muzzle_pos = get_gun_muzzle_pos()
                        local origin = world.my_last_shot_origin or muzzle_pos or camera.GetPosition()
                        if origin then
                            table.insert(world.tracers, {
                                created = now,
                                from = origin,
                                to = pos
                            })
                            if #world.tracers > 20 then table.remove(world.tracers, 1) end
                        end
                    end
                end
            end

            if is_alive and cur_hp and cur_hp > 0 then
                world.enemy_health[key] = cur_hp
            else
                world.enemy_health[key] = 0
            end
        end
    end

    -- 2. Check NPCs (Scavs, Raiders, Bosses) live health
    if world.npcs then
        for i = 1, #world.npcs do
            local npc = world.npcs[i]
            if npc and npc.hum and utility.IsValid(npc.hum) then
                local cur_hp = nil
                pcall(function() cur_hp = npc.hum.Health end)
                local key = (npc.hum.Address) or (npc.model and npc.model.Address) or ("npc_" .. i)
                local old_hp = world.enemy_health[key]

                local pos = nil
                if npc.head and utility.IsValid(npc.head) then
                    pos = npc.head.Position
                elseif npc.model and utility.IsValid(npc.model) and npc.model.PrimaryPart then
                    pos = npc.model.PrimaryPart.Position
                end
                if not pos and world.enemy_last_pos then
                    pos = world.enemy_last_pos[key]
                end
                if not pos and world.my_last_target_key == key then
                    pos = world.my_last_target_pos
                end
                if pos then
                    if not world.enemy_last_pos then world.enemy_last_pos = {} end
                    world.enemy_last_pos[key] = pos
                end

                local dmg = 0
                local is_kill = false

                if old_hp and old_hp > 0 then
                    if cur_hp and cur_hp < old_hp and (old_hp - cur_hp) >= 1 then
                        dmg = math.floor(old_hp - cur_hp + 0.5)
                        if cur_hp <= 0 then is_kill = true end
                    elseif cur_hp == nil or cur_hp <= 0 then
                        -- One-shot kill on NPC!
                        dmg = math.floor(old_hp + 0.5)
                        is_kill = true
                    end
                elseif old_hp == nil then
                    if cur_hp and cur_hp > 0 then
                        world.enemy_health[key] = cur_hp
                    else
                        local time_since_shot = now - (world.my_last_shot_time or 0)
                        if time_since_shot >= 0 and time_since_shot <= 0.40 then
                            dmg = 100
                            is_kill = true
                        end
                    end
                end

                if dmg > 0 then
                    local is_my_hit = false
                    local time_since_shot = now - (world.my_last_shot_time or 0)
                    if time_since_shot >= 0 and time_since_shot <= 2.0 then
                        if world.my_last_target_key and (world.my_last_target_key == key or world.my_last_target_name == npc.name) then
                            is_my_hit = true
                        elseif world.silent_target_pos and pos and dist3(pos.X, pos.Y, pos.Z, world.silent_target_pos.X, world.silent_target_pos.Y, world.silent_target_pos.Z) <= 8.0 then
                            is_my_hit = true
                        elseif world.my_last_shot_look and pos then
                            local cam_pos = camera.GetPosition()
                            if cam_pos then
                                local v = pos - cam_pos
                                local proj = v.X * world.my_last_shot_look.X + v.Y * world.my_last_shot_look.Y + v.Z * world.my_last_shot_look.Z
                                if proj > 0.5 then
                                    local rx = cam_pos.X + world.my_last_shot_look.X * proj
                                    local ry = cam_pos.Y + world.my_last_shot_look.Y * proj
                                    local rz = cam_pos.Z + world.my_last_shot_look.Z * proj
                                    if dist3(pos.X, pos.Y, pos.Z, rx, ry, rz) <= 15.0 then
                                        is_my_hit = true
                                    end
                                end
                            end
                        else
                            is_my_hit = true
                        end
                    end

                    if is_my_hit then
                        if is_hm_on then
                            world.hitmarker = { time = now, pos = pos, is_head = (dmg >= 55 or is_kill) }
                        end
                        if is_hl_on then
                            local ts = (os.date and os.date("%H:%M:%S")) or "00:00:00"
                            local target_name = npc.name or "Scav"
                            local kill_str = is_kill and " [KILL]" or ""
                            table.insert(world.hit_logs, {
                                text = string.format("[%s] Hit %s for -%d HP%s", ts, target_name, dmg, kill_str),
                                created = now,
                                lifetime = hit_dur
                            })
                            if #world.hit_logs > 8 then table.remove(world.hit_logs, 1) end
                        end
                        if is_tracer_on and pos then
                            local muzzle_pos = get_gun_muzzle_pos()
                            local origin = world.my_last_shot_origin or muzzle_pos or camera.GetPosition()
                            if origin then
                                table.insert(world.tracers, {
                                    created = now,
                                    from = origin,
                                    to = pos
                                })
                                if #world.tracers > 20 then table.remove(world.tracers, 1) end
                            end
                        end
                    end
                end

                if cur_hp and cur_hp > 0 then
                    world.enemy_health[key] = cur_hp
                else
                    world.enemy_health[key] = 0
                end
            end
        end
    end
end

local function draw_bullet_tracers()
    local is_tracer_on = cfg.bullet_tracers or menu.Get("b_bullet_tracers")
    local is_hm_on = cfg.hitmarker or menu.Get("b_hitmarker")
    local is_hl_on = cfg.hit_logs or menu.Get("b_hit_logs")
    if not is_tracer_on and not is_hm_on and not is_hl_on then return end

    local now = os.clock()
    local max_dur = cfg.tracer_dur or menu.Get("b_tracer_duration") or 1.0
    local tr_col = cfg.tracer_c or mc("b_bullet_tracers") or {0.25, 0.65, 1.0, 1.0}

    local is_lmb_down = input.IsKeyDown(0x01) or false
    local is_click = is_lmb_down and not world.last_tracer_lmb
    world.last_tracer_lmb = is_lmb_down

    if not is_any_menu_open() and is_lmb_down and is_gun_equipped() then
        local cur_ammo = get_local_ammo()

        if cur_ammo ~= nil and cur_ammo <= 0 then
            world.last_ammo = 0
        else
            local did_fire = false
            if cur_ammo ~= nil then
                if world.last_ammo ~= nil and cur_ammo < world.last_ammo then
                    -- Real shot: magazine round count decreased
                    did_fire = true
                elseif is_click and cur_ammo > 0 then
                    -- Trigger click with live rounds available
                    did_fire = true
                end
                world.last_ammo = cur_ammo
            else
                if is_click then
                    did_fire = true
                end
            end

            if did_fire then
                world.last_shot = now
                world.last_combat_action = now
                world.my_last_shot_time = now

                local muzzle_pos = get_gun_muzzle_pos()
                local cam_pos = camera.GetPosition()
                local look = camera.GetLookVector()

                if (muzzle_pos or cam_pos) and look then
                    local origin = muzzle_pos or (cam_pos + look * 1.2)
                    world.my_last_shot_origin = origin
                    world.my_last_shot_look = look
                    world.my_last_target_key = nil
                    world.my_last_target_name = nil
                    world.my_last_target_pos = nil

                    -- 1. If silent aim was active toward a target, associate this shot with that target
                    if world.silent_target_pos and (now - (world.silent_target_time or 0)) < 0.35 then
                        world.my_last_target_key = world.silent_target_key
                        world.my_last_target_name = world.silent_target_name
                        world.my_last_target_pos = world.silent_target_pos
                    else
                        -- 2. Otherwise associate shot with player/NPC closest to look vector
                        local closest_dist = 500
                        for pi = 1, #frame_players do
                            local ep = frame_players[pi]
                            if ep and not ep.IsLocal and ep.IsAlive then
                                local hp = ep.HeadPosition or ep.Position
                                if hp then
                                    local v = hp - cam_pos
                                    local proj = v.X * look.X + v.Y * look.Y + v.Z * look.Z
                                    if proj > 1.5 and proj < closest_dist then
                                        local rx = cam_pos.X + look.X * proj
                                        local ry = cam_pos.Y + look.Y * proj
                                        local rz = cam_pos.Z + look.Z * proj
                                        if dist3(hp.X, hp.Y, hp.Z, rx, ry, rz) <= 4.0 then
                                            closest_dist = proj
                                            world.my_last_target_key = ep.UserId or ep.Name
                                            world.my_last_target_name = ep.Name or "Player"
                                            world.my_last_target_pos = hp
                                        end
                                    end
                                end
                            end
                        end
                        if not world.my_last_target_key and world.npcs then
                            for ni = 1, #world.npcs do
                                local en = world.npcs[ni]
                                local nb = (en and en.head and en.head.Position) or (en and en.model and en.model.PrimaryPart and en.model.PrimaryPart.Position)
                                if nb then
                                    local v = nb - cam_pos
                                    local proj = v.X * look.X + v.Y * look.Y + v.Z * look.Z
                                    if proj > 1.5 and proj < closest_dist then
                                        local rx = cam_pos.X + look.X * proj
                                        local ry = cam_pos.Y + look.Y * proj
                                        local rz = cam_pos.Z + look.Z * proj
                                        if dist3(nb.X, nb.Y, nb.Z, rx, ry, rz) <= 4.0 then
                                            closest_dist = proj
                                            world.my_last_target_key = (en.hum and en.hum.Address) or ("npc_" .. ni)
                                            world.my_last_target_name = en.name or "Scav"
                                            world.my_last_target_pos = nb
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end

    if not is_tracer_on then return end
    local cam_pos = camera.GetPosition()
    local cam_look = camera.GetLookVector()
    local i = 1
    while i <= #world.tracers do
        local tr = world.tracers[i]
        local age = now - tr.created
        if age >= max_dur then
            table.remove(world.tracers, i)
        else
            local alpha = math.clamp(1.0 - (age / max_dur), 0, 1)
            local p1 = tr.from
            local p2 = tr.to

            -- Near-plane clipping to prevent tracers from wrapping behind camera or snapping to center
            local should_draw = true
            local draw_p1 = p1
            if cam_pos and cam_look then
                local d1 = (p1.X - cam_pos.X) * cam_look.X + (p1.Y - cam_pos.Y) * cam_look.Y + (p1.Z - cam_pos.Z) * cam_look.Z
                local d2 = (p2.X - cam_pos.X) * cam_look.X + (p2.Y - cam_pos.Y) * cam_look.Y + (p2.Z - cam_pos.Z) * cam_look.Z
                if d2 <= 0.2 then
                    should_draw = false
                elseif d1 < 0.6 and d2 > 0.6 then
                    local t = (0.6 - d1) / (d2 - d1)
                    draw_p1 = Vector3.New(
                        p1.X + (p2.X - p1.X) * t,
                        p1.Y + (p2.Y - p1.Y) * t,
                        p1.Z + (p2.Z - p1.Z) * t
                    )
                end
            end

            if should_draw then
                local sx1, sy1, sv1 = draw.WorldToScreen(draw_p1.X, draw_p1.Y, draw_p1.Z)
                local sx2, sy2, sv2 = draw.WorldToScreen(p2.X, p2.Y, p2.Z)

                local r = tr_col[1] or 0.25
                local g = tr_col[2] or 0.65
                local b = tr_col[3] or 1.0

                if sv2 then
                    if not sv1 then
                        local scx, scy = input.GetScreenCenter()
                        if not scx or not scy then scx, scy = 960, 540 end
                        sx1, sy1 = scx + 100, scy + 140
                        sv1 = true
                    end
                    draw.Line(sx1, sy1, sx2, sy2, {r, g, b, alpha * 0.9}, 2)
                    draw.Line(sx1, sy1, sx2, sy2, {1, 1, 1, alpha * 0.95}, 1)
                elseif sv1 then
                    local sx2_raw, sy2_raw = draw.WorldToScreen(p2.X, p2.Y, p2.Z)
                    if sx2_raw and sy2_raw then
                        draw.Line(sx1, sy1, sx2_raw, sy2_raw, {r, g, b, alpha * 0.8}, 2)
                    end
                end
            end

            i = i + 1
        end
    end
end

local function draw_hit_logs()
    local is_hl_on = cfg.hit_logs or menu.Get("b_hit_logs")
    if not is_hl_on or #world.hit_logs == 0 then return end
    local now = os.clock()
    local scx, scy = input.GetScreenCenter()
    if not scx or not scy then scx, scy = 960, 540 end
    local y_start = scy + 45
    local i = 1
    while i <= #world.hit_logs do
        local log = world.hit_logs[i]
        local age = now - log.created
        if age >= log.lifetime then
            table.remove(world.hit_logs, i)
        else
            local alpha = math.clamp(1.0 - (age / log.lifetime), 0, 1)
            local tw, th = draw.GetTextSize(log.text, 12)
            tw = (type(tw) == "number" and tw > 0 and tw) or (#log.text * 7.5)
            local pad_x = 10
            local pad_y = 3
            local box_w = tw + pad_x * 2
            local box_h = 20
            local lx = scx - math.floor(box_w / 2)
            local ly = y_start + (i - 1) * 23

            draw.RectFilled(lx, ly, box_w, box_h, {0.04, 0.04, 0.06, alpha * 0.88}, 3)
            local hcol = cfg.hit_logs_c or {0.25, 0.65, 1.0, 1.0}
            draw.Rect(lx, ly, box_w, box_h, {hcol[1], hcol[2], hcol[3], alpha * (hcol[4] or 0.75)}, 3, 1)

            draw.Text(lx + pad_x + 1, ly + pad_y + 1, log.text, {0, 0, 0, alpha * 0.95}, 12)
            local hcol = cfg.hit_logs_c or {0.55, 0.9, 1.0, 1.0}
            draw.Text(lx + pad_x, ly + pad_y, log.text, {hcol[1], hcol[2], hcol[3], alpha * (hcol[4] or 1.0)}, 12)
            i = i + 1
        end
    end
end

local function draw_hitmarker()
    local is_hm_on = cfg.hitmarker or menu.Get("b_hitmarker")
    if not is_hm_on or not world.hitmarker then return end
    local elapsed = os.clock() - world.hitmarker.time
    if elapsed >= 0.55 then
        world.hitmarker = nil
        return
    end
    local alpha = math.clamp(1.0 - (elapsed / 0.55), 0, 1)
    local s = 11
    local gap = 3
    local is_head = world.hitmarker.is_head
    local base_hm = cfg.hitmarker_c or {1.0, 1.0, 1.0, 1.0}
    local col = is_head and {1.0, 0.22, 0.22, alpha} or {base_hm[1], base_hm[2], base_hm[3], alpha * (base_hm[4] or 1.0)}
    local shadow_col = {0.0, 0.0, 0.0, alpha * 0.9}

    -- Always draw crisp crosshair hitmarker at screen center
    local cx, cy = input.GetScreenCenter()
    if not cx or not cy then cx, cy = 960, 540 end

    -- Dark background shadow for contrast on any background
    draw.Line(cx - s, cy - s, cx - gap, cy - gap, shadow_col, 3.5)
    draw.Line(cx + gap, cy + gap, cx + s, cy + s, shadow_col, 3.5)
    draw.Line(cx + s, cy - s, cx + gap, cy - gap, shadow_col, 3.5)
    draw.Line(cx - gap, cy + gap, cx - s, cy + s, shadow_col, 3.5)

    -- Bright foreground hitmarker lines
    draw.Line(cx - s, cy - s, cx - gap, cy - gap, col, 2.0)
    draw.Line(cx + gap, cy + gap, cx + s, cy + s, col, 2.0)
    draw.Line(cx + s, cy - s, cx + gap, cy - gap, col, 2.0)
    draw.Line(cx - gap, cy + gap, cx - s, cy + s, col, 2.0)

    -- If 3D hit position is available and on screen, also draw subtle 3D hit indicator
    if world.hitmarker.pos then
        local wx, wy, wv = draw.WorldToScreen(world.hitmarker.pos.X, world.hitmarker.pos.Y, world.hitmarker.pos.Z)
        if wv and (math.abs(wx - cx) > 15 or math.abs(wy - cy) > 15) then
            local ws = 6
            draw.Line(wx - ws, wy - ws, wx + ws, wy + ws, col, 1.5)
            draw.Line(wx + ws, wy - ws, wx - ws, wy + ws, col, 1.5)
        end
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
local pos = c.part and utility.IsValid(c.part) and c.part.Position
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
    if (now - wep_last_update) < 100 then return end
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
end

last_skin_auto_apply = 0
function auto_apply_skins()
    if not cfg.skin_enable then return end
    local now = utility.GetTickCount()
    if (now - last_skin_auto_apply) < 3000 then return end
    last_skin_auto_apply = now
    apply_skins_silent()
end


fov_current = nil
fov_applied = false
last_applied_fov = nil

local function run_fov_changer()
    local enabled = (cfg.fov_changer == true)

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

    local user_target = cfg.fov_val or 90
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




local init_native_menu = function()
    if type(menu) ~= 'table' or not menu.AddGroup then return end

    local tab_aim = "Aimbot"
    local tab_sil = "Silent Aim"
    local tab_na  = "NPC Aimbot"
    local tab_esp = "Player ESP"
    local tab_chm = "Player Chams"
    local tab_npc = "NPCs"
    local tab_wld = "World ESP"
    local tab_inv = "Inventory"
    local tab_cbt = "Combat Mods"
    local tab_cfg = "Config"
    local tab_main = tab_aim

    pcall(function()
        if menu.AddTab then
            menu.AddTab(tab_aim, "A")
            menu.AddTab(tab_sil, "S")
            menu.AddTab(tab_na,  "N")
            menu.AddTab(tab_esp, "P")
            menu.AddTab(tab_chm, "C")
            menu.AddTab(tab_npc, "E")
            menu.AddTab(tab_wld, "W")
            menu.AddTab(tab_inv, "I")
            menu.AddTab(tab_cbt, "M")
            menu.AddTab(tab_cfg, "O")
        end
    end)

    local function setup_toggle(parent_id, children, on_change)
        if not menu.SetCallback or not menu.SetVisible then return end
        menu.SetCallback(parent_id, function(on)
            for i = 1, #children do
                pcall(menu.SetVisible, children[i], on)
            end
            if on_change then pcall(on_change, on) end
        end)
        local init_val = menu.Get(parent_id) or false
        for i = 1, #children do
            pcall(menu.SetVisible, children[i], init_val)
        end
    end

    -- ==========================================
    -- TAB 1: BOBA (Main Suite)
    -- ==========================================

    -- Group 1: Aimbot
    pcall(function()
        menu.AddGroup(tab_main, "Aimbot")
        menu.AddCheckbox(tab_main, "Aimbot", "b_aim", "Enable Aimbot", false)
        menu.AddCombo(tab_main, "Aimbot", "b_aim_bone", "Target Bone", {"Head", "Chest", "Torso", "Random"}, 0, { parent = "b_aim" })
        menu.AddHotkey(tab_main, "Aimbot", "b_aim_key", "Aim Key", 0x02, { parent = "b_aim" })
        menu.AddCombo(tab_main, "Aimbot", "b_aim_mode", "Aim Mode", {"Hold", "Toggle"}, 0, { parent = "b_aim" })
        menu.AddSliderInt(tab_main, "Aimbot", "b_aim_fov", "FOV Radius", 1, 360, 90, "%d°", { parent = "b_aim" })
        menu.AddSliderFloat(tab_main, "Aimbot", "b_aim_smooth", "Smoothness", 1.0, 30.0, 5.0, "%.1f", { parent = "b_aim" })
        menu.AddCheckbox(tab_main, "Aimbot", "b_aim_pred", "Bullet Drop Prediction", false, { parent = "b_aim" })
        menu.AddCheckbox(tab_main, "Aimbot", "b_aim_lead", "Velocity Lead", false, { parent = "b_aim" })
        menu.AddCheckbox(tab_main, "Aimbot", "b_aim_lock", "Sticky Target Lock", false, { parent = "b_aim" })
        menu.AddCheckbox(tab_main, "Aimbot", "b_aim_vis", "Visible Check", false, { parent = "b_aim" })
        menu.AddCheckbox(tab_main, "Aimbot", "b_aim_team", "Team Check", false, { parent = "b_aim" })

        menu.AddCheckbox(tab_main, "Aimbot", "b_aim_fov_draw", "Draw FOV Circle", false, { parent = "b_aim" })
        menu.AddColorpicker(tab_main, "Aimbot", "b_aim_fov_c", "FOV Color", {1, 1, 1, 0.25}, { parent = "b_aim_fov_draw" })
        menu.AddCheckbox(tab_main, "Aimbot", "b_aim_fov_filled", "Filled FOV Circle", false, { parent = "b_aim_fov_draw" })

        setup_toggle("b_aim", {
            "b_aim_bone", "b_aim_key", "b_aim_mode", "b_aim_fov",
            "b_aim_smooth", "b_aim_pred", "b_aim_lead", "b_aim_lock",
            "b_aim_vis", "b_aim_team", "b_aim_fov_draw"
        })
        setup_toggle("b_aim_fov_draw", { "b_aim_fov_c", "b_aim_fov_filled" })
    end)

    -- Group 2: Silent Aim
    pcall(function()
        menu.AddGroup(tab_sil, "Silent Aim")
        menu.AddCheckbox(tab_sil, "Silent Aim", "b_silent", "Enable Silent Aim", false)
        menu.AddHotkey(tab_sil, "Silent Aim", "b_silent_key", "Silent Key (0=Always)", 0, { parent = "b_silent" })
        menu.AddCombo(tab_sil, "Silent Aim", "b_silent_mode", "Silent Mode", {"Always", "Hold", "Toggle"}, 0, { parent = "b_silent" })
        menu.AddSliderInt(tab_sil, "Silent Aim", "b_silent_hchance", "Hit Chance %", 1, 100, 100, "%d%%", { parent = "b_silent" })
        menu.AddSliderInt(tab_sil, "Silent Aim", "b_silent_fov", "Silent FOV", 1, 360, 60, "%d°", { parent = "b_silent" })
        menu.AddCombo(tab_sil, "Silent Aim", "b_silent_bone", "Silent Bone", {"Head", "Chest", "Torso", "Random"}, 0, { parent = "b_silent" })
        menu.AddCheckbox(tab_sil, "Silent Aim", "b_silent_multipoint", "Multi-Point (Bone Fallback)", false, { parent = "b_silent" })
        menu.AddCheckbox(tab_sil, "Silent Aim", "b_silent_vis", "Visible Check", false, { parent = "b_silent" })
        menu.AddCheckbox(tab_sil, "Silent Aim", "b_silent_team", "Team Check", false, { parent = "b_silent" })

        menu.AddCheckbox(tab_sil, "Silent Aim", "b_silent_fov_draw", "Draw Silent FOV", false, { parent = "b_silent" })
        menu.AddColorpicker(tab_sil, "Silent Aim", "b_silent_fov_c", "Silent FOV Color", {1, 0.8, 0.2, 0.2}, { parent = "b_silent_fov_draw" })
        menu.AddCheckbox(tab_sil, "Silent Aim", "b_silent_fov_filled", "Filled FOV Circle", false, { parent = "b_silent_fov_draw" })

        setup_toggle("b_silent", {
            "b_silent_key", "b_silent_mode", "b_silent_hchance", "b_silent_fov",
            "b_silent_bone", "b_silent_multipoint", "b_silent_vis", "b_silent_team",
            "b_silent_fov_draw"
        })
        setup_toggle("b_silent_fov_draw", { "b_silent_fov_c", "b_silent_fov_filled" })
    end)

    -- Group 3: Player ESP
    pcall(function()
        menu.AddGroup(tab_esp, "Player ESP")
        menu.AddCheckbox(tab_esp, "Player ESP", "b_esp", "Enable Player ESP", false)

        menu.AddCheckbox(tab_esp, "Player ESP", "b_esp_box", "Bounding Box", false, { parent = "b_esp" })
        menu.AddCombo(tab_esp, "Player ESP", "b_esp_style", "Box Style", {"Full Box", "Corner Box"}, 0, { parent = "b_esp_box" })
        menu.AddColorpicker(tab_esp, "Player ESP", "b_esp_box_c", "Box Color", {1, 1, 1, 1}, { parent = "b_esp_box" })

        menu.AddCheckbox(tab_esp, "Player ESP", "b_esp_skel", "Skeleton ESP", false, { parent = "b_esp" })
        menu.AddColorpicker(tab_esp, "Player ESP", "b_esp_skel_c", "Skeleton Color", {1, 1, 1, 0.8}, { parent = "b_esp_skel" })

        menu.AddCheckbox(tab_esp, "Player ESP", "b_esp_hp", "Health Bar", false, { parent = "b_esp" })
        menu.AddCheckbox(tab_esp, "Player ESP", "b_esp_hp_txt", "Health Text", false, { parent = "b_esp_hp" })
        menu.AddColorpicker(tab_esp, "Player ESP", "b_esp_hp_c", "Health Color", {0.2, 1, 0.2, 1}, { parent = "b_esp_hp" })

        menu.AddCheckbox(tab_esp, "Player ESP", "b_esp_name", "Player Name", false, { parent = "b_esp" })
        menu.AddColorpicker(tab_esp, "Player ESP", "b_esp_name_c", "Name Color", {1, 1, 1, 1}, { parent = "b_esp_name" })

        menu.AddCheckbox(tab_esp, "Player ESP", "b_esp_dist", "Distance", false, { parent = "b_esp" })
        menu.AddColorpicker(tab_esp, "Player ESP", "b_esp_dist_c", "Distance Color", {0.7, 0.7, 0.7, 1}, { parent = "b_esp_dist" })

        menu.AddCheckbox(tab_esp, "Player ESP", "b_esp_weapon", "Equipped Weapon", false, { parent = "b_esp" })
        menu.AddColorpicker(tab_esp, "Player ESP", "b_esp_weapon_c", "Weapon Color", {1, 0.7, 0.3, 1}, { parent = "b_esp_weapon" })

        menu.AddCheckbox(tab_esp, "Player ESP", "b_esp_armor", "Helmet & Armor", false, { parent = "b_esp" })
        menu.AddColorpicker(tab_esp, "Player ESP", "b_esp_armor_c", "Armor Color", {0.6, 0.85, 1, 1}, { parent = "b_esp_armor" })

        menu.AddCheckbox(tab_esp, "Player ESP", "b_esp_snap", "Snaplines", false, { parent = "b_esp" })
        menu.AddColorpicker(tab_esp, "Player ESP", "b_esp_snap_c", "Snapline Color", {1, 1, 1, 0.5}, { parent = "b_esp_snap" })

        menu.AddSliderInt(tab_esp, "Player ESP", "b_esp_range", "Max Range (m)", 10, 1000, 300, "%dm", { parent = "b_esp" })
        menu.AddCheckbox(tab_esp, "Player ESP", "b_esp_team", "Team Filter", false, { parent = "b_esp" })

        menu.AddCheckbox(tab_esp, "Player ESP", "b_esp_vis_tag", "Visible Tag", false, { parent = "b_esp" })
        menu.AddColorpicker(tab_esp, "Player ESP", "b_esp_vis_tag_c", "Visible Tag Color", {0.15, 1, 0.25, 1}, { parent = "b_esp_vis_tag" })

        menu.AddCheckbox(tab_esp, "Player ESP", "b_esp_staff", "Staff Detect Warning", false, { parent = "b_esp" })
        menu.AddColorpicker(tab_esp, "Player ESP", "b_esp_staff_c", "Staff Color", {1, 0.2, 0.2, 1}, { parent = "b_esp_staff" })

        menu.AddCheckbox(tab_esp, "Player ESP", "b_esp_hvt", "High Value Target Tag", false, { parent = "b_esp" })
        menu.AddColorpicker(tab_esp, "Player ESP", "b_esp_hvt_c", "High Value Target Color", {1, 0.85, 0.2, 1}, { parent = "b_esp_hvt" })

        menu.AddCheckbox(tab_esp, "Player ESP", "b_cheater_finder", "Cheater Detector", false, { parent = "b_esp" })
        menu.AddCheckbox(tab_esp, "Player ESP", "b_cheater_panel", "Cheaters Alert Panel", false, { parent = "b_cheater_finder" })

        setup_toggle("b_esp", {
            "b_esp_box", "b_esp_skel", "b_esp_hp", "b_esp_name", "b_esp_dist",
            "b_esp_weapon", "b_esp_armor", "b_esp_snap", "b_esp_range",
            "b_esp_team", "b_esp_vis_tag", "b_esp_staff", "b_esp_hvt", "b_cheater_finder"
        })
        setup_toggle("b_esp_box", { "b_esp_style", "b_esp_box_c" })
        setup_toggle("b_esp_skel", { "b_esp_skel_c" })
        setup_toggle("b_esp_hp", { "b_esp_hp_txt", "b_esp_hp_c" })
        setup_toggle("b_esp_name", { "b_esp_name_c" })
        setup_toggle("b_esp_dist", { "b_esp_dist_c" })
        setup_toggle("b_esp_weapon", { "b_esp_weapon_c" })
        setup_toggle("b_esp_armor", { "b_esp_armor_c" })
        setup_toggle("b_esp_snap", { "b_esp_snap_c" })
        setup_toggle("b_esp_vis_tag", { "b_esp_vis_tag_c" })
        setup_toggle("b_esp_staff", { "b_esp_staff_c" })
        setup_toggle("b_esp_hvt", { "b_esp_hvt_c" })
        setup_toggle("b_cheater_finder", { "b_cheater_panel" })
    end)

    -- Group 4: Chams
    pcall(function()
        menu.AddGroup(tab_chm, "Chams")
        menu.AddCheckbox(tab_chm, "Chams", "b_chams", "Enable Player Chams", false)
        menu.AddCombo(tab_chm, "Chams", "b_chams_mode", "Chams Mode", {"Solid", "Wireframe", "Glow"}, 0, { parent = "b_chams" })
        menu.AddCheckbox(tab_chm, "Chams", "b_chams_vc", "Visible Only (Vis Check)", false, { parent = "b_chams" })
        menu.AddColorpicker(tab_chm, "Chams", "b_chams_vis", "Visible Color", {0, 1, 0, 0.8}, { parent = "b_chams" })
        menu.AddColorpicker(tab_chm, "Chams", "b_chams_occ", "Occluded Color", {1, 0, 0, 0.8}, { parent = "b_chams" })

        setup_toggle("b_chams", { "b_chams_mode", "b_chams_vc", "b_chams_vis", "b_chams_occ" })
    end)

    -- Group 5: NPCs
    pcall(function()
        menu.AddGroup(tab_npc, "NPCs")
        menu.AddCheckbox(tab_npc, "NPCs", "b_npc", "Enable NPC ESP", false)

        menu.AddCheckbox(tab_npc, "NPCs", "b_npc_box", "NPC Box", false, { parent = "b_npc" })
        menu.AddColorpicker(tab_npc, "NPCs", "b_npc_box_c", "NPC Box Color", {1, 0.5, 0.2, 1}, { parent = "b_npc_box" })

        menu.AddCheckbox(tab_npc, "NPCs", "b_npc_skel", "NPC Skeleton", false, { parent = "b_npc" })
        menu.AddColorpicker(tab_npc, "NPCs", "b_npc_skel_c", "NPC Skeleton Color", {1, 0.6, 0.3, 0.8}, { parent = "b_npc_skel" })

        menu.AddCheckbox(tab_npc, "NPCs", "b_npc_hp", "NPC Health Bar", false, { parent = "b_npc" })
        menu.AddColorpicker(tab_npc, "NPCs", "b_npc_hp_c", "NPC Health Color", {0.2, 1, 0.2, 1}, { parent = "b_npc_hp" })

        menu.AddCheckbox(tab_npc, "NPCs", "b_npc_name", "NPC Name", false, { parent = "b_npc" })
        menu.AddColorpicker(tab_npc, "NPCs", "b_npc_name_c", "NPC Name Color", {1, 0.8, 0.4, 1}, { parent = "b_npc_name" })

        menu.AddCheckbox(tab_npc, "NPCs", "b_npc_dist", "NPC Distance", false, { parent = "b_npc" })
        menu.AddColorpicker(tab_npc, "NPCs", "b_npc_dist_c", "NPC Distance Color", {0.7, 0.7, 0.7, 1}, { parent = "b_npc_dist" })

        menu.AddSliderInt(tab_npc, "NPCs", "b_npc_range", "NPC Range (m)", 10, 600, 200, "%dm", { parent = "b_npc" })
        menu.AddCheckbox(tab_npc, "NPCs", "b_boss", "Boss Tracker Panel", false, { parent = "b_npc" })

        setup_toggle("b_npc", {
            "b_npc_box", "b_npc_skel", "b_npc_hp", "b_npc_name", "b_npc_dist", "b_npc_range", "b_boss"
        })
        setup_toggle("b_npc_box", { "b_npc_box_c" })
        setup_toggle("b_npc_skel", { "b_npc_skel_c" })
        setup_toggle("b_npc_hp", { "b_npc_hp_c" })
        setup_toggle("b_npc_name", { "b_npc_name_c" })
        setup_toggle("b_npc_dist", { "b_npc_dist_c" })
    end)

    -- Group 6: World ESP
    pcall(function()
        menu.AddGroup(tab_wld, "World ESP")
        menu.AddCheckbox(tab_wld, "World ESP", "b_cont", "Enable Container ESP", false)
        menu.AddColorpicker(tab_wld, "World ESP", "b_cont_c", "Container Color", {0.2, 0.8, 1, 1}, { parent = "b_cont" })
        menu.AddCheckbox(tab_wld, "World ESP", "b_cont_items", "Show Items Inside", false, { parent = "b_cont" })
        menu.AddColorpicker(tab_wld, "World ESP", "b_cont_items_c", "Container Items Color", {0.85, 0.85, 0.85, 1}, { parent = "b_cont_items" })
        menu.AddCombo(tab_wld, "World ESP", "b_cont_filter", "Container Filter", {"All Containers", "Only OP Loot Containers"}, 0, { parent = "b_cont" })
        menu.AddSliderInt(tab_wld, "World ESP", "b_cont_range", "Container Range (m)", 10, 500, 150, "%dm", { parent = "b_cont" })

        menu.AddCheckbox(tab_wld, "World ESP", "b_loot", "Dropped Items ESP", false)
        menu.AddColorpicker(tab_wld, "World ESP", "b_loot_c", "Dropped Items Color", {0.4, 1, 0.4, 1}, { parent = "b_loot" })
        menu.AddSliderInt(tab_wld, "World ESP", "b_loot_range", "Dropped Items Range (m)", 10, 500, 150, "%dm", { parent = "b_loot" })

        menu.AddCheckbox(tab_wld, "World ESP", "b_corpse", "Enable Corpse ESP", false)
        menu.AddColorpicker(tab_wld, "World ESP", "b_corpse_c", "Corpse Color", {0.8, 0.2, 0.2, 1}, { parent = "b_corpse" })
        menu.AddCheckbox(tab_wld, "World ESP", "b_corpse_x", "Corpse Marker", false, { parent = "b_corpse" })
        menu.AddCheckbox(tab_wld, "World ESP", "b_corpse_op_only", "Only OP Corpse Items", false, { parent = "b_corpse" })
        menu.AddCheckbox(tab_wld, "World ESP", "b_corpse_items", "Show Corpse Items", false, { parent = "b_corpse" })
        menu.AddColorpicker(tab_wld, "World ESP", "b_corpse_items_c", "Corpse Items Color", {0.85, 0.85, 0.85, 1}, { parent = "b_corpse_items" })
        menu.AddSliderInt(tab_wld, "World ESP", "b_corpse_r", "Corpse Range (m)", 10, 500, 200, "%dm", { parent = "b_corpse" })

        menu.AddCheckbox(tab_wld, "World ESP", "b_quest", "Quest Items ESP", false)
        menu.AddColorpicker(tab_wld, "World ESP", "b_quest_c", "Quest Color", {1, 0.85, 0.2, 1}, { parent = "b_quest" })
        menu.AddSliderInt(tab_wld, "World ESP", "b_quest_range", "Quest Range (m)", 10, 1000, 300, "%dm", { parent = "b_quest" })

        menu.AddCheckbox(tab_wld, "World ESP", "b_extract", "Extraction Points", false)
        menu.AddColorpicker(tab_wld, "World ESP", "b_extract_c", "Extract Color", {0.2, 1, 0.5, 1}, { parent = "b_extract" })
        menu.AddSliderInt(tab_wld, "World ESP", "b_extract_range", "Extraction Range (m)", 10, 4000, 3000, "%dm", { parent = "b_extract" })

        menu.AddCheckbox(tab_wld, "World ESP", "b_hazard", "Hazard Zones", false)
        menu.AddColorpicker(tab_wld, "World ESP", "b_hazard_c", "Hazard Color", {1, 0.3, 0.1, 1}, { parent = "b_hazard" })
        menu.AddSliderInt(tab_wld, "World ESP", "b_hazard_range", "Hazard Range (m)", 10, 2000, 500, "%dm", { parent = "b_hazard" })

        menu.AddCheckbox(tab_wld, "World ESP", "b_claymore", "Claymore ESP", false)
        menu.AddColorpicker(tab_wld, "World ESP", "b_claymore_c", "Claymore Color", {1, 0.2, 0.2, 1}, { parent = "b_claymore" })

        menu.AddCheckbox(tab_wld, "World ESP", "b_car", "Car ESP", false)
        menu.AddColorpicker(tab_wld, "World ESP", "b_car_c", "Car Color", {0.2, 0.6, 1, 1}, { parent = "b_car" })

        setup_toggle("b_cont", { "b_cont_c", "b_cont_items", "b_cont_filter", "b_cont_range" }, function(on)
            if on and scan_containers then pcall(scan_containers) end
        end)
        setup_toggle("b_cont_items", { "b_cont_items_c" })
        setup_toggle("b_loot", { "b_loot_c", "b_loot_range" }, function(on)
            if on and scan_world_items then pcall(scan_world_items) end
        end)
        setup_toggle("b_corpse", { "b_corpse_c", "b_corpse_x", "b_corpse_op_only", "b_corpse_items", "b_corpse_r" })
        setup_toggle("b_corpse_items", { "b_corpse_items_c" })
        setup_toggle("b_quest", { "b_quest_c", "b_quest_range" }, function(on)
            if on and scan_quests then pcall(scan_quests) end
        end)
        setup_toggle("b_extract", { "b_extract_c", "b_extract_range" }, function(on)
            if on and scan_extracts then pcall(scan_extracts) end
        end)
        setup_toggle("b_hazard", { "b_hazard_c", "b_hazard_range" })
        setup_toggle("b_claymore", { "b_claymore_c" })
        setup_toggle("b_car", { "b_car_c" })
    end)

    -- Group 7: Combat Mods
    pcall(function()
        menu.AddGroup(tab_cbt, "Combat Mods")
        menu.AddCheckbox(tab_cbt, "Combat Mods", "b_no_recoil", "No Recoil", false)
        menu.AddSliderInt(tab_cbt, "Combat Mods", "b_recoil_reduc", "Recoil Reduction %", 0, 100, 70, "%d%%", { parent = "b_no_recoil" })

        menu.AddCheckbox(tab_cbt, "Combat Mods", "b_hitmarker", "Hitmarker", false)
        menu.AddColorpicker(tab_cbt, "Combat Mods", "b_hitmarker_c", "Hitmarker Color", {1, 1, 1, 1}, { parent = "b_hitmarker" })

        menu.AddCheckbox(tab_cbt, "Combat Mods", "b_hit_logs", "Hit / Damage Logs", false)
        menu.AddColorpicker(tab_cbt, "Combat Mods", "b_hit_logs_c", "Hit Logs Color", {0.25, 0.65, 1.0, 1.0}, { parent = "b_hit_logs" })
        menu.AddSliderInt(tab_cbt, "Combat Mods", "b_hit_log_duration", "Log Duration (s)", 1, 10, 4, "%ds", { parent = "b_hit_logs" })

        menu.AddCheckbox(tab_cbt, "Combat Mods", "b_bullet_tracers", "Bullet Tracers", false)
        menu.AddColorpicker(tab_cbt, "Combat Mods", "b_bullet_tracer_c", "Tracer Color", {1, 0.8, 0, 0.8}, { parent = "b_bullet_tracers" })

        menu.AddCheckbox(tab_cbt, "Combat Mods", "b_cross", "Custom Crosshair", false)
        menu.AddCombo(tab_cbt, "Combat Mods", "b_cross_style", "Crosshair Style", {"Classic Cross", "Center Dot", "Circle Outline", "T-Shape Cross", "Arrow / Chevron", "Circle + Cross"}, 0, { parent = "b_cross" })
        menu.AddColorpicker(tab_cbt, "Combat Mods", "b_cross_c", "Crosshair Color", {0, 1, 0, 1}, { parent = "b_cross" })
        menu.AddSliderInt(tab_cbt, "Combat Mods", "b_cross_sz", "Crosshair Size", 2, 30, 8, "%d", { parent = "b_cross" })
        menu.AddSliderInt(tab_cbt, "Combat Mods", "b_cross_gap", "Crosshair Gap", 0, 20, 3, "%d", { parent = "b_cross" })
        menu.AddSliderInt(tab_cbt, "Combat Mods", "b_cross_thick", "Crosshair Thickness", 1, 6, 2, "%d", { parent = "b_cross" })

        menu.AddCheckbox(tab_cbt, "Combat Mods", "b_cross_spin", "Spin Animation", false, { parent = "b_cross" })
        menu.AddSliderInt(tab_cbt, "Combat Mods", "b_cross_spin_spd", "Spin Speed", 1, 20, 5, "%d", { parent = "b_cross_spin" })

        menu.AddCheckbox(tab_cbt, "Combat Mods", "b_cross_pulse", "Pulse Animation", false, { parent = "b_cross" })
        menu.AddSliderInt(tab_cbt, "Combat Mods", "b_cross_pulse_spd", "Pulse Speed", 1, 20, 4, "%d", { parent = "b_cross_pulse" })

        setup_toggle("b_no_recoil", { "b_recoil_reduc" })
        setup_toggle("b_hitmarker", { "b_hitmarker_c" })
        setup_toggle("b_hit_logs", { "b_hit_logs_c", "b_hit_log_duration" })
        setup_toggle("b_bullet_tracers", { "b_bullet_tracer_c" })
        setup_toggle("b_cross", {
            "b_cross_style", "b_cross_c", "b_cross_sz", "b_cross_gap", "b_cross_thick",
            "b_cross_spin", "b_cross_pulse"
        })
        setup_toggle("b_cross_spin", { "b_cross_spin_spd" })
        setup_toggle("b_cross_pulse", { "b_cross_pulse_spd" })

        if menu.SetCallback then
            menu.SetCallback("b_cross_style", function(v) cfg.cross_style = v; if boba_store then boba_store.b_cross_style = v end end)
            menu.SetCallback("b_cross_sz", function(v) cfg.cross_sz = v; if boba_store then boba_store.b_cross_sz = v end end)
            menu.SetCallback("b_cross_gap", function(v) cfg.cross_gap = v; if boba_store then boba_store.b_cross_gap = v end end)
            menu.SetCallback("b_cross_thick", function(v) cfg.cross_thick = v; if boba_store then boba_store.b_cross_thick = v end end)
        end
    end)

    -- Group 8: Config
    pcall(function()
        menu.AddGroup(tab_cfg, "Config")
        local cfg_list = read_config_list()
        if not cfg_list or #cfg_list == 0 then cfg_list = {"default"} end
        menu.AddCombo(tab_cfg, "Config", "b_cfg_selected", "Saved Configs", cfg_list, 0)
        menu.AddInput(tab_cfg, "Config", "b_cfg_name", "New Config Name", "default")
        menu.AddButton(tab_cfg, "Config", "b_btn_load", "Load Selected Config", function()
            local cfg_items = read_config_list()
            local sel_idx = menu.Get("b_cfg_selected") or 0
            local cfg_name = (cfg_items and cfg_items[sel_idx + 1]) or "default"
            pcall(load_config, cfg_name)
            notify.Success("BOBA", "Loaded config: " .. tostring(cfg_name))
        end)
        menu.AddButton(tab_cfg, "Config", "b_btn_save", "Save Config", function()
            local nm = menu.Get("b_cfg_name")
            if not nm or nm:match("^%s*$") then
                local sel_idx = menu.Get("b_cfg_selected") or 0
                local cfg_items = read_config_list()
                nm = (cfg_items and cfg_items[sel_idx + 1]) or "default"
            else
                nm = nm:match("^%s*(.-)%s*$")
            end
            pcall(save_config, nm)
            local updated_list = read_config_list()
            local sel_idx = 0
            for idx, v in ipairs(updated_list) do
                if v == nm then sel_idx = idx - 1; break end
            end
            pcall(menu.AddCombo, tab_cfg, "Config", "b_cfg_selected", "Saved Configs", updated_list, sel_idx)
            pcall(menu.Set, "b_cfg_selected", sel_idx)
            notify.Success("BOBA", "Saved config: " .. tostring(nm))
        end)
    end)

    -- ==========================================
    -- TAB 2: INVENTORY (HUD & Checker) - updated
    -- ==========================================
    pcall(function()
        menu.AddGroup(tab_inv, "Inventory HUD")
        menu.AddCheckbox(tab_inv, "Inventory HUD", "b_loadout_esp", "Enable Inventory HUD", false)
        menu.AddColorpicker(tab_inv, "Inventory HUD", "b_loadout_c", "HUD Color", {0.4, 0.8, 1, 1}, { parent = "b_loadout_esp" })

        setup_toggle("b_loadout_esp", { "b_loadout_c" })

        menu.AddGroup(tab_inv, "Inventory Checker")
        menu.AddCheckbox(tab_inv, "Inventory Checker", "b_inspect", "Enable Inventory Checker", false)
        menu.AddColorpicker(tab_inv, "Inventory Checker", "b_inspect_c", "Checker Color", {0.4, 0.8, 1, 1}, { parent = "b_inspect" })
        menu.AddCheckbox(tab_inv, "Inventory Checker", "b_inv_weap", "Show Weapons", false, { parent = "b_inspect" })
        menu.AddCheckbox(tab_inv, "Inventory Checker", "b_inv_armor", "Show Armor", false, { parent = "b_inspect" })
        menu.AddCheckbox(tab_inv, "Inventory Checker", "b_inv_special", "Show Special Items", false, { parent = "b_inspect" })
        menu.AddCheckbox(tab_inv, "Inventory Checker", "b_inv_misc", "Show Misc Items", false, { parent = "b_inspect" })

        setup_toggle("b_inspect", {
            "b_inspect_c", "b_inv_weap", "b_inv_armor", "b_inv_special", "b_inv_misc"
        })
    end)

    -- ==========================================
    -- TAB 3: NPC AIMBOT
    -- ==========================================
    pcall(function()
        menu.AddGroup(tab_na, "NPC Aimbot")
        menu.AddCheckbox(tab_na, "NPC Aimbot", "b_npc_aim", "Enable NPC Aimbot", false)
        menu.AddHotkey(tab_na, "NPC Aimbot", "b_npc_aim_key", "NPC Aim Key", 0x02, { parent = "b_npc_aim" })
        menu.AddCombo(tab_na, "NPC Aimbot", "b_npc_aim_bone", "Target Bone", {"Head", "Chest", "Torso"}, 0, { parent = "b_npc_aim" })
        menu.AddSliderInt(tab_na, "NPC Aimbot", "b_npc_aim_fov", "Aim FOV Radius", 1, 360, 90, "%d°", { parent = "b_npc_aim" })
        menu.AddSliderFloat(tab_na, "NPC Aimbot", "b_npc_aim_smooth", "Aim Smoothness", 1.0, 30.0, 5.0, "%.1f", { parent = "b_npc_aim" })
        menu.AddCheckbox(tab_na, "NPC Aimbot", "b_npc_aim_pred", "NPC Prediction", false, { parent = "b_npc_aim" })

        menu.AddCheckbox(tab_na, "NPC Aimbot", "b_npc_aim_fov_draw", "Draw FOV Circle", false, { parent = "b_npc_aim" })
        menu.AddColorpicker(tab_na, "NPC Aimbot", "b_npc_aim_fov_c", "FOV Color", {1, 0.6, 0.2, 0.3}, { parent = "b_npc_aim_fov_draw" })
        menu.AddCheckbox(tab_na, "NPC Aimbot", "b_npc_aim_fov_filled", "Filled FOV Circle", false, { parent = "b_npc_aim_fov_draw" })

        setup_toggle("b_npc_aim", {
            "b_npc_aim_key", "b_npc_aim_bone", "b_npc_aim_fov", "b_npc_aim_smooth",
            "b_npc_aim_pred", "b_npc_aim_fov_draw"
        })
        setup_toggle("b_npc_aim_fov_draw", { "b_npc_aim_fov_c", "b_npc_aim_fov_filled" })
    end)
end

pcall(init_native_menu)
local draw_nixware_menu = function() end

local draw_player_loadout = (function()
    local loadout_ui = {
        x = 420,
        y = 120,
        dragging = false,
        drag_ox = 0,
        drag_oy = 0,
        last_lmb = false,
        initialized = false
    }

    local img_cache = {}

    local KNOWN_IMAGES = {
        ["ai2"]=true, ["aa2"]=true, ["mikeshades"]=true, ["f1"]=true, ["bandage"]=true, ["wounddressing"]=true, ["scythe"]=true, ["ghillietorso"]=true, ["ghillielegs"]=true, ["ghilliehood"]=true, ["map"]=true, ["pathfinder"]=true, ["dagr"]=true, ["keychain"]=true, ["lighter"]=true, ["maxenergy"]=true, ["chocolatebar"]=true, ["bluecard"]=true, ["orangecard"]=true, ["serumred"]=true, ["serumgreen"]=true, ["serumyellow"]=true, ["serumpurple"]=true, ["bandoiler"]=true, ["ifak"]=true, ["ai4"]=true, ["rags"]=true, ["equalizer"]=true, ["6b2"]=true, ["6b23"]=true, ["6b27"]=true, ["6b45"]=true, ["6b47"]=true, ["6b5"]=true,
        adar15=true, akm=true, akmn=true, altyn=true, anarchytomahawk=true, asval=true, attak5=true,
        balaclava=true, bandolier=true, combatgloves=true, concealedvest=true, crown=true, cutlass=true,
        dozer=true, dragonslayer=true, dv2=true, fal=true, fastmt=true, goldmakarov=true, gp5=true,
        gp7=true, groza=true, handwraps=true, headmount=true, hspv=true, iceaxe=true, icedagger=true,
        improvedouter=true, improvedouterlower=true, izh12=true, izh81=true, jpc=true, karambit=true,
        kneepads=true, korakulon=true, longsword=true, m4=true, machete=true, makarov=true, mk23=true,
        mosin=true, motorcycle=true, mp443=true, mp5sd=true, onestrap=true, pantsir3=true, pkm=true,
        plasmaninjato=true, ppsh41=true, r700=true, rpg7=true, saiga=true, scavking=true, sks=true,
        smersh=true, specops=true, ssh68=true, svd=true, tanker=true, tfz0=true, tfz98=true, tors=true,
        tortilla=true, toz106=true, tt33=true, unohelmet=true, unovest=true, vz61=true,
        wastelandbackpack=true, zsh=true
    }

    local ALIASES = {
        m4a1 = "m4",
        goldenmakarov = "goldmakarov",
        gold_makarov = "goldmakarov",
        lynx = "attak5",
        as_val = "asval",
        val = "asval",
        fast_mt = "fastmt",
        fast = "fastmt",
        ssh_68 = "ssh68",
        ssh = "ssh68",
        kora_kulon = "korakulon",
        kora = "korakulon",
        pantsir = "pantsir3",
        scav_king = "scavking",
        spec_ops = "specops",
        specopsbackpack = "specops",
        uno_vest = "unovest",
        uno_helmet = "unohelmet",
        concealed_vest = "concealedvest",
        improved_outer = "improvedouter",
        combat_gloves = "combatgloves",
        combatglove = "combatgloves",
        gloves = "combatgloves",
        glove = "combatgloves",
        comba = "combatgloves",
        hand_wraps = "handwraps",
        kneepad = "kneepads",
        kneep = "kneepads",
        knee = "kneepads",
        legarmor = "kneepads",
        leg_armor = "kneepads",
        legar = "kneepads",
        balac = "balaclava",
        sewnmask = "balaclava", mikes = "mikeshades", mikeshade = "mikeshades", shades = "mikeshades", glasses = "mikeshades", sunglasses = "mikeshades", medkit = "ai2", bandage = "bandage", wounddressing = "bandage", wound = "bandage",
        sewn_mask = "balaclava",
        sewn = "balaclava",
        gasmask = "gp5",
        gas_mask = "gp5",
        ["6b43"] = "6b45",
        summershirt = "improvedouter",
        wastelandshirt = "improvedouter",
        camoshirt = "improvedouter",
        camo_shirt = "improvedouter",
        camos = "improvedouter",
        civilianshirt = "improvedouter",
        civilian_shirt = "improvedouter",
        civilians = "improvedouter",
        shirt = "improvedouter",
        tshirt = "improvedouter",
        summerpants = "improvedouterlower",
        wastelandpants = "improvedouterlower",
        camopants = "improvedouterlower",
        camo_pants = "improvedouterlower",
        camop = "improvedouterlower",
        civilianpants = "improvedouterlower",
        civilian_pants = "improvedouterlower",
        civilianp = "improvedouterlower",
        pants = "improvedouterlower",
        trousers = "improvedouterlower",
        attack5 = "attak5",
        attack = "attak5",
        sportbag = "onestrap",
        sport_bag = "onestrap",
        anarchy_tomahawk = "anarchytomahawk",
        dragon_slayer = "dragonslayer",
        ice_axe = "iceaxe",
        ice_dagger = "icedagger",
        plasma_ninjato = "plasmaninjato",
        wasteland_backpack = "wastelandbackpack",
        one_strap = "onestrap",
        nagantrevolver = "makarov",
        nagant = "makarov",
        tt = "tt33",
        mp443grach = "mp443",
        grach = "mp443",
        kulon = "korakulon",
        kora = "korakulon",
        gorkashirt = "improvedouter",
        gorkapants = "improvedouterlower",
        vamphshirt = "improvedouter",
        vamphpants = "improvedouterlower",
        kgbbag = "onestrap",
        medbag = "onestrap",
        satchelbag = "onestrap",
        ["6b5liquidator"] = "6b5",
        dozerarmor = "dozer",
        scavkingvest = "scavking",
        scavkinghelmet = "scavking",
        motorcyclehelmet = "motorcycle",
        maskavisor = "altyn",
        altynvisor = "altyn",
        dv = "dv2",
        dagr = "dagr",
        knife = "dv2",
        bayonet = "dv2",
        izh = "izh81",
        saiga12 = "saiga",
        ppsh = "ppsh41",
        toz = "toz106",
        vss = "asval",
        scar = "m4",
        ak74 = "akm",
        ak74m = "akm",
        ak = "akm",
        vest = "concealedvest",
        chestrig = "concealedvest",
        bag = "onestrap",
        backpack = "wastelandbackpack",
        helmet = "ssh68",
        headwear = "ssh68",
        mask = "balaclava",
        armor = "6b2",
        pm = "makarov",
        ["a12"] = "ai2",
        ["a1-2"] = "ai2",
        ["ai-2"] = "ai2",
        ["f1grenade"] = "f1",
        ["f-1"] = "f1",
        ["sychte"] = "scythe",
        ["tomahawk"] = "anarchytomahawk",
        ["bando"] = "bandolier",
        ["bandolierchestrig"] = "bandolier",
        ["ghillieshirt"] = "ghillietorso",
        ["ghilliepants"] = "ghillielegs",
        ["ghilliesuit"] = "ghillietorso",
        ["compass"] = "pathfinder",
        ["estonian"] = "map",
        ["estonianbordermap"] = "map",
        ["zippo"] = "lighter",
        ["maxenergy"] = "maxenergy",
        ["max_energy"] = "maxenergy",
        ["chocolate"] = "chocolatebar",
        ["choc"] = "chocolatebar",
        ["blue_card"] = "bluecard",
        ["kgb3"] = "bluecard",
        ["cardblue"] = "bluecard",
        ["orange_card"] = "orangecard",
        ["kgb5"] = "orangecard",
        ["cardorange"] = "orangecard",
        ["serumxred"] = "serumred",
        ["redserum"] = "serumred",
        ["serumxgreen"] = "serumgreen",
        ["greenserum"] = "serumgreen",
        ["serumxyellow"] = "serumyellow",
        ["yellowserum"] = "serumyellow",
        ["serumxpurple"] = "serumpurple",
        ["purpleserum"] = "serumpurple",
        ["aa2"] = "aa2",
        ["aa-2"] = "aa2",
        ["aa_2"] = "aa2",
        ["a1"] = "ai2",
        ["a-1"] = "ai2",
        ["ifak"] = "ifak",
        ["ai4"] = "ai4",
        ["ai-4"] = "ai4",
        ["rags"] = "rags",
        ["equalizer"] = "equalizer",
        ["bandoiler"] = "bandoiler"
    }

    local PISTOLS = {
        makarov = true, goldmakarov = true, goldenmakarov = true,
        mk23 = true, mp443 = true, tt33 = true, nagantrevolver = true, nagant = true
    }

    local function resolve_icon_name(raw_name)
        if not raw_name or type(raw_name) ~= "string" or raw_name == "" then return nil end
        local k = raw_name:lower():gsub("[%s%-_]", "")
        if KNOWN_IMAGES[k] then return k end
        if ALIASES[k] then return ALIASES[k] end
        for kn in pairs(KNOWN_IMAGES) do
            if k:find(kn, 1, true) then return kn end
        end
        for ak, av in pairs(ALIASES) do
            if k:find(ak, 1, true) then return av end
        end
        return nil
    end

    local img_log_count = 0
    local function boba_log_img(str)
        if img_log_count > 80 then return end
        img_log_count = img_log_count + 1
        pcall(function()
            local folder = get_cfg_folder()
            local f = io.open(folder .. "boba_image_log.txt", "a")
            if f then
                f:write(string.format("[%.2f] %s", tick(), str) .. string.char(10))
                f:close()
            end
        end)
    end

    pcall(function()
        local folder = get_cfg_folder()
        local f = io.open(folder .. "boba_image_log.txt", "w")
        if f then
            f:write("=== BOBA IMAGE LOG START ===" .. string.char(10))
            local dl = (type(draw) == "table" and type(draw.LoadImage)) or "nil"
            f:write("draw.LoadImage type: " .. tostring(dl) .. string.char(10))
            f:close()
        end
    end)

    local img_rev = tostring(math.floor(tick()))
    local img_handles = {}

    local function get_icon(name)
        local icon_name = resolve_icon_name(name)
        if not icon_name then return nil end
        if img_handles[icon_name] ~= nil then
            return img_handles[icon_name] or nil
        end
        local url = "https://cdn.jsdelivr.net/gh/boqnpenev1-design/delta-itemss@main/" .. icon_name .. ".png"
        local ok, ret = pcall(draw.LoadImage, url)
        if ok and ret then
            img_handles[icon_name] = ret
            return ret
        end
        local fb_url = "https://raw.githubusercontent.com/boqnpenev1-design/delta-itemss/main/" .. icon_name .. ".png"
        local ok2, ret2 = pcall(draw.LoadImage, fb_url)
        if ok2 and ret2 then
            img_handles[icon_name] = ret2
            return ret2
        end
        img_handles[icon_name] = false
        return nil
    end

    local function get_inst_name(val)
        if not val then return nil end
        if type(val) == "userdata" then
            local ok, nm = pcall(function() return val.Name end)
            if ok and nm and nm ~= "" then return nm end
        elseif type(val) == "string" and val ~= "" then
            return val
        end
        return nil
    end

    local function resolve_target_name(wp)
        if not wp then return "Player" end
        if type(wp.display) == "string" and wp.display ~= "" and wp.display ~= "Unknown" then
            return wp.display
        end
        if type(wp.name) == "string" and wp.name ~= "" and wp.name ~= "Unknown" then
            return wp.name
        end
        local ent = wp.entity
        if ent then
            if type(ent.DisplayName) == "string" and ent.DisplayName ~= "" then
                return ent.DisplayName
            end
            if type(ent.Name) == "string" and ent.Name ~= "" then
                return ent.Name
            end
            if ent.Character and type(ent.Character.Name) == "string" and ent.Character.Name ~= "" and ent.Character.Name ~= "Character" then
                return ent.Character.Name
            end
            local ok, nm = pcall(function()
                if ent.Character then
                    local pl = game.Players:GetPlayerFromCharacter(ent.Character)
                    if pl and pl.DisplayName and pl.DisplayName ~= "" then
                        return pl.DisplayName
                    elseif pl and pl.Name and pl.Name ~= "" then
                        return pl.Name
                    end
                end
            end)
            if ok and nm and nm ~= "" then return nm end
        end
        return "Player"
    end

    local function find_best_target()
        local scx, scy = input.GetScreenCenter()
        local best_p = nil
        local best_fov = 999999

        if inv_target_data and inv_target_data.entity and inv_target_data.entity.IsValid and inv_target_data.entity.IsAlive then
            local p = inv_target_data.entity
            local pos = p.Position
            if p.Character then
                local h = p.Character:FindFirstChild("Head") or p.Character:FindFirstChild("HumanoidRootPart")
                if h and h.Position then pos = h.Position end
            end
            if pos then
                local sx, sy, on_scr = utility.WorldToScreen(pos.X, pos.Y, pos.Z)
                if on_scr and screen_dist(sx, sy, scx, scy) < 320 then
                    return inv_target_data
                end
            end
        end

        if not world or not world.players or #world.players == 0 then return nil end
        local lp = entity.GetLocalPlayer()
        local lp_name = lp and lp.Name or ""

        for i = 1, #world.players do
            local wp = world.players[i]
            local p = wp and wp.entity
            if p and p.IsValid and p.IsAlive and not p.IsLocal and not (p.Health and p.Health <= 0) then
                if wp.name ~= lp_name then
                    local pos = p.Position
                    if p.Character then
                        local h = p.Character:FindFirstChild("Head") or p.Character:FindFirstChild("HumanoidRootPart")
                        if h and h.Position then pos = h.Position end
                    end
                    if pos then
                        local sx, sy, on_scr = utility.WorldToScreen(pos.X, pos.Y, pos.Z)
                        if on_scr then
                            local d = screen_dist(sx, sy, scx, scy)
                            if d < best_fov then
                                best_fov = d
                                best_p = wp
                            end
                        end
                    end
                end
            end
        end

        if not best_p then
            local min_w = 999999
            for i = 1, #world.players do
                local wp = world.players[i]
                local p = wp and wp.entity
                if p and p.IsValid and p.IsAlive and not p.IsLocal and not (p.Health and p.Health <= 0) then
                    if wp.name ~= lp_name then
                        local wd = p:DistanceTo() or 999999
                        if wd < min_w then
                            min_w = wd
                            best_p = wp
                        end
                    end
                end
            end
        end
        return best_p
    end

    local loadout_cache = {}
    local function get_player_loadout_data(wp)
        if not wp or not wp.name then return {}, {}, nil end
        local now_t = tick()
        local cached = loadout_cache[wp.name]
        if cached and (now_t - cached.t) < 0.5 then
            return cached.top_row, cached.bot_row, cached.active_tool
        end

        local top_row = { nil, nil, nil, nil, nil, nil, nil, nil }
        local bot_row = { nil, nil, nil, nil, nil, nil, nil }
        local active_tool = nil

        local char = wp.entity and wp.entity.Character
        if char then
            local clothing = char:FindFirstChild("Clothing")
            if clothing then
                local function c_read(k)
                    local o = clothing:FindFirstChild(k)
                    return o and get_inst_name(o.Value)
                end
                top_row[1] = c_read("ClothingHeadware")
                top_row[2] = c_read("ClothingMask")
                top_row[3] = c_read("ClothingChestRig")
                top_row[4] = c_read("ClothingShirt")
                top_row[5] = c_read("ClothingBackpack")
                top_row[6] = c_read("ClothingLegArmor")
                top_row[7] = c_read("ClothingPants")
                top_row[8] = c_read("ClothingGloves")
            end
            local rc = char:FindFirstChild("RealClothing")
            if rc then
                for _, m in ipairs(rc:GetChildren()) do
                    local mn = m.Name
                    local ml = mn:lower()
                    if not top_row[1] and (ml:find("fast") or ml:find("altyn") or ml:find("zsh") or ml:find("ssh") or ml:find("6b") or ml:find("helmet")) then top_row[1] = mn
                    elseif not top_row[2] and (ml:find("mask") or ml:find("gp") or ml:find("balaclava")) then top_row[2] = mn
                    elseif not top_row[3] and (ml:find("vest") or ml:find("jpc") or ml:find("outer") or ml:find("6b") or ml:find("pantsir")) then top_row[3] = mn
                    elseif not top_row[4] and ml:find("shirt") then top_row[4] = mn
                    elseif not top_row[5] and (ml:find("pack") or ml:find("bag") or ml:find("lynx") or ml:find("attak")) then top_row[5] = mn
                    elseif not top_row[6] and (ml:find("knee") or ml:find("lower") or ml:find("leg")) then top_row[6] = mn
                    elseif not top_row[7] and ml:find("pants") then top_row[7] = mn
                    elseif not top_row[8] and (ml:find("glove") or ml:find("wrap")) then top_row[8] = mn
                    end
                end
            end
        end

        if wp.inventory then
            for _, item_name in ipairs(wp.inventory) do
                local il = item_name:lower()
                if not top_row[1] and (il:find("fast") or il:find("altyn") or il:find("zsh") or il:find("ssh") or il:find("6b") or il:find("helmet")) then top_row[1] = item_name
                elseif not top_row[2] and (il:find("mask") or il:find("gp") or il:find("balaclava")) then top_row[2] = item_name
                elseif not top_row[3] and (il:find("vest") or il:find("jpc") or il:find("outer") or il:find("6b") or il:find("pantsir")) then top_row[3] = item_name
                elseif not top_row[4] and il:find("shirt") then top_row[4] = item_name
                elseif not top_row[5] and (il:find("pack") or il:find("bag") or il:find("lynx") or il:find("attak")) then top_row[5] = item_name
                elseif not top_row[6] and (il:find("knee") or il:find("lower") or il:find("leg")) then top_row[6] = item_name
                elseif not top_row[7] and il:find("pants") then top_row[7] = item_name
                elseif not top_row[8] and (il:find("glove") or il:find("wrap")) then top_row[8] = item_name
                end
            end
        end

        local rep = game.ReplicatedStorage
        local rep_p = rep and rep:FindFirstChild("Players")
        local pdata = rep_p and rep_p:FindFirstChild(wp.name)
        local gv = pdata and ((pdata:FindFirstChild("Status") and pdata.Status:FindFirstChild("GameplayVariables")) or pdata:FindFirstChild("GameplayVariables"))
        if gv then
            local eq = gv:FindFirstChild("EquippedTool")
            active_tool = eq and get_inst_name(eq.Value)
            local hb = gv:FindFirstChild("Hotbar")
            if hb then
                local function hb_read(k)
                    local o = hb:FindFirstChild(k)
                    return o and get_inst_name(o.Value)
                end
                bot_row[1] = hb_read("ItemBack1")
                bot_row[2] = hb_read("ItemBack2")
                bot_row[3] = hb_read("ItemHip1")
                bot_row[4] = hb_read("Hotbar4")
                bot_row[5] = hb_read("Hotbar5")
                bot_row[6] = hb_read("Hotbar6")
                bot_row[7] = hb_read("Hotbar7")
            end
        end

        if not active_tool and wp.equipped then
            active_tool = wp.equipped
        end

        if bot_row[3] then
            local p_chk = bot_row[3]:lower():gsub("[%s%-_]", "")
            if not PISTOLS[p_chk] then
                if not bot_row[1] then bot_row[1] = bot_row[3]
                elseif not bot_row[2] then bot_row[2] = bot_row[3] end
                bot_row[3] = nil
            end
        end

        if not bot_row[3] and wp.inventory then
            for _, item_name in ipairs(wp.inventory) do
                local c = item_name:lower():gsub("[%s%-_]", "")
                if PISTOLS[c] then
                    bot_row[3] = item_name
                    break
                end
            end
        end

        if not bot_row[1] and active_tool then
            local act_c = active_tool:lower():gsub("[%s%-_]", "")
            if not PISTOLS[act_c] then
                bot_row[1] = active_tool
            end
        end

        loadout_cache[wp.name] = { top_row = top_row, bot_row = bot_row, active_tool = active_tool, t = now_t }
        return top_row, bot_row, active_tool
    end

    local function draw_player_loadout_impl()
        if not get_val("b_loadout_esp", false) then return end

        if not loadout_ui.initialized then
            loadout_ui.initialized = true
            loadout_ui.x = get_val("b_loadout_x", 420) or 420
            loadout_ui.y = get_val("b_loadout_y", 120) or 120
        end

        local wp = find_best_target()
        local is_preview = false
        if not wp then
            is_preview = true
        end

        local top_labels = {"HELM", "MASK", "VEST", "SHIRT", "BAG", "KNEE", "PANTS", "GLOVE"}
        local bot_labels = {"PRI 1", "PRI 2", "PIST", "4", "5", "6", "7"}

        local top_row, bot_row, active_tool
        local pname, pdist
        if is_preview then
            pname = "Target Player (Preview)"
            pdist = 124
            top_row = {"Altyn", "Balaclava", "JPC", "WastelandShirt", "Attak5", "Kneepads", "WastelandPants", "CombatGloves"}
            bot_row = {"AKM", "Mosin", "Makarov", "AI2", "AA2", "PMN2", nil}
            active_tool = "AKM"
        else
            top_row, bot_row, active_tool = get_player_loadout_data(wp)
            pname = resolve_target_name(wp)
            pdist = math.floor((wp.entity and wp.entity:DistanceTo()) or 0)
        end

        local is_rainbow = (get_val("b_rainbow_mode", false) == true)
        local theme_col, theme_sub
        if is_rainbow then
            local now_t = tick()
            theme_col = hsv_to_rgb((now_t * 0.35) % 1.0, 0.85, 1.0)
            theme_sub = hsv_to_rgb((now_t * 0.35 + 0.38) % 1.0, 0.85, 1.0)
        else
            theme_col = cfg.loadout_c or mc("b_loadout_c", {0.4, 0.8, 1, 1})
            theme_sub = { theme_col[1] * 0.88, theme_col[2] * 0.88, theme_col[3] * 0.88, 1.0 }
        end

        local tr = math.floor(theme_col[1] * 255)
        local tg = math.floor(theme_col[2] * 255)
        local tb = math.floor(theme_col[3] * 255)

        local slot_sz = get_val("b_loadout_sz", 38) or 38
        if slot_sz < 24 then slot_sz = 24 end
        local gap = 4

        local top_w = 8 * slot_sz + 7 * gap
        local bot_w = 7 * slot_sz + 6 * gap
        local total_w = top_w + 12
        local total_h = 34 + slot_sz + 5 + slot_sz + 8

        local px = loadout_ui.x
        local py = loadout_ui.y

        local mx, my = input.GetMousePosition()
        mx = (type(mx) == "number" and mx) or 0
        my = (type(my) == "number" and my) or 0
        local lmb = input.IsKeyDown(0x01) or false
        local is_click = lmb and not loadout_ui.last_lmb

        if is_click and not loadout_ui.dragging then
            if mx >= px and mx <= px + total_w and my >= py and my <= py + 30 then
                loadout_ui.dragging = true
                loadout_ui.drag_ox = mx - px
                loadout_ui.drag_oy = my - py
            end
        end

        if loadout_ui.dragging then
            if lmb then
                loadout_ui.x = math.max(0, mx - loadout_ui.drag_ox)
                loadout_ui.y = math.max(0, my - loadout_ui.drag_oy)
                px = loadout_ui.x
                py = loadout_ui.y
            else
                loadout_ui.dragging = false
                pcall(menu.Set, "b_loadout_x", loadout_ui.x)
                pcall(menu.Set, "b_loadout_y", loadout_ui.y)
            end
        end
        loadout_ui.last_lmb = lmb

        draw.RectFilled(px, py, total_w, total_h, {0.02, 0.02, 0.03, 0.70}, 4)
        draw.Rect(px, py, total_w, total_h, {tr / 255 * 0.45, tg / 255 * 0.45, tb / 255 * 0.45, 0.45}, 4, 1)

        local cx = px + math.floor(total_w / 2)
        local nw, _ = draw.GetTextSize(pname, 13)
        nw = (type(nw) == "number" and nw > 0 and nw) or 60
        local dist_str = "[" .. tostring(pdist) .. "m]"
        local dw, _ = draw.GetTextSize(dist_str, 10)
        dw = (type(dw) == "number" and dw > 0 and dw) or 30

        local line_y = py + 12
        draw.Line(px + 8, line_y, cx - math.floor(nw / 2) - 6, line_y, theme_col, 1)
        draw.Text(cx - math.floor(nw / 2), py + 4, pname, theme_col, 13)
        draw.Line(cx + math.floor(nw / 2) + 6, line_y, px + total_w - 8, line_y, theme_col, 1)

        draw.Text(cx - math.floor(dw / 2), py + 19, dist_str, theme_sub, 10)

        local top_y = py + 34
        for i = 1, 8 do
            local sx = px + 6 + (i - 1) * (slot_sz + gap)
            local sy = top_y
            local iname = top_row[i]
            draw.RectFilled(sx, sy, slot_sz, slot_sz, {0.02, 0.02, 0.03, 0.95}, 3)
            draw.Rect(sx, sy, slot_sz, slot_sz, {0.20, 0.20, 0.26, 0.6}, 3, 1)
            if iname then
                local h = get_icon(iname)
                if h then
                    local pad = 6
                    local max_w = slot_sz - pad
                    local max_h = slot_sz - pad
                    local w_px = max_w
                    local h_px = max_h
                    local ok_sz, rw, rh = pcall(draw.ImageSize, h)
                    if ok_sz and type(rw) == "number" and type(rh) == "number" and rw > 0 and rh > 0 then
                        local sc = math.min(max_w / rw, max_h / rh)
                        w_px = math.max(1, math.floor(rw * sc))
                        h_px = math.max(1, math.floor(rh * sc))
                    end
                    local dx = sx + math.floor((slot_sz - w_px) / 2)
                    local dy = sy + math.floor((slot_sz - h_px) / 2)
                    pcall(draw.Image, h, dx, dy, w_px, h_px, 255, 255, 255, 255)
                else
                    local s_txt = iname
                    if #s_txt > 6 then s_txt = s_txt:sub(1, 5) end
                    local tw, _ = draw.GetTextSize(s_txt, 9)
                    tw = (type(tw) == "number" and tw > 0 and tw) or 18
                    draw.Text(sx + math.floor((slot_sz - tw) / 2), sy + math.floor(slot_sz / 2) - 5, s_txt, theme_sub, 9)
                end
            else
                local lbl = top_labels[i] or ""
                local tw, _ = draw.GetTextSize(lbl, 8)
                tw = (type(tw) == "number" and tw > 0 and tw) or 16
                draw.Text(sx + math.floor((slot_sz - tw) / 2), sy + math.floor(slot_sz / 2) - 4, lbl, {0.35, 0.35, 0.40, 0.35}, 8)
            end
        end

        local bot_ox = math.floor((slot_sz + gap) / 2)
        local bot_y = top_y + slot_sz + 5
        for j = 1, 7 do
            local sx = px + 6 + bot_ox + (j - 1) * (slot_sz + gap)
            local sy = bot_y
            local iname = bot_row[j]
            local is_eq = false
            if iname and active_tool then
                local a1 = iname:lower():gsub("[%s%-_]", "")
                local a2 = active_tool:lower():gsub("[%s%-_]", "")
                if a1 == a2 or a1:find(a2, 1, true) or a2:find(a1, 1, true) then
                    is_eq = true
                end
            end

            if is_eq then
                draw.RectFilled(sx, sy, slot_sz, slot_sz, {0.02, 0.02, 0.03, 0.95}, 3)
                draw.Rect(sx, sy, slot_sz, slot_sz, theme_col, 3, 2)
            else
                draw.RectFilled(sx, sy, slot_sz, slot_sz, {0.02, 0.02, 0.03, 0.95}, 3)
                draw.Rect(sx, sy, slot_sz, slot_sz, {0.20, 0.20, 0.26, 0.6}, 3, 1)
            end

            if iname then
                local h = get_icon(iname)
                if h then
                    local pad = 6
                    local max_w = slot_sz - pad
                    local max_h = slot_sz - pad
                    local w_px = max_w
                    local h_px = max_h
                    local ok_sz, rw, rh = pcall(draw.ImageSize, h)
                    if ok_sz and type(rw) == "number" and type(rh) == "number" and rw > 0 and rh > 0 then
                        local sc = math.min(max_w / rw, max_h / rh)
                        w_px = math.max(1, math.floor(rw * sc))
                        h_px = math.max(1, math.floor(rh * sc))
                    end
                    local dx = sx + math.floor((slot_sz - w_px) / 2)
                    local dy = sy + math.floor((slot_sz - h_px) / 2)
                    pcall(draw.Image, h, dx, dy, w_px, h_px, 255, 255, 255, 255)
                else
                    local s_txt = iname
                    if #s_txt > 6 then s_txt = s_txt:sub(1, 5) end
                    local tw, _ = draw.GetTextSize(s_txt, 9)
                    tw = (type(tw) == "number" and tw > 0 and tw) or 18
                    draw.Text(sx + math.floor((slot_sz - tw) / 2), sy + math.floor(slot_sz / 2) - 5, s_txt, is_eq and theme_col or theme_sub, 9)
                end
            else
                local lbl = bot_labels[j] or ""
                local tw, _ = draw.GetTextSize(lbl, 8)
                tw = (type(tw) == "number" and tw > 0 and tw) or 16
                draw.Text(sx + math.floor((slot_sz - tw) / 2), sy + math.floor(slot_sz / 2) - 4, lbl, {0.35, 0.35, 0.40, 0.35}, 8)
            end
        end
    end
    return draw_player_loadout_impl
end)()


local last_perf_cleanup = 0
_G.on_frame = function()
    local now_t = tick()
    if (now_t - last_perf_cleanup) > 15 then
        last_perf_cleanup = now_t
        if world.enemy_health then
            local count = 0
            for _ in pairs(world.enemy_health) do count = count + 1 end
            if count > 50 then
                world.enemy_health = {}
                world.enemy_last_pos = {}
            end
        end
        if world.hacker_tracker then
            local count = 0
            for _ in pairs(world.hacker_tracker) do count = count + 1 end
            if count > 50 then
                world.hacker_tracker = {}
            end
        end
        pcall(collectgarbage, "step", 150)
    end

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

    pcall(cache_cfg)
    -- wep chams removed

    frame_players = entity.GetPlayers() or {}

    pcall(draw_player_chams)
    pcall(draw_player_esp)
    pcall(draw_npc_esp)
    pcall(draw_world_esp)

    pcall(run_player_aim)
    pcall(run_npc_aim)
    pcall(run_silent_aim)

    pcall(draw_crosshair)
    pcall(check_combat_hits)
    pcall(draw_hitmarker)
    pcall(draw_bullet_tracers)
    pcall(draw_hit_logs)
    pcall(draw_player_loadout)
    if cfg.inspect then
        pcall(draw_inventory)
    end

    if cfg.cheater_finder then
        pcall(update_hacker_detector)
        if cfg.cheater_panel then
            pcall(draw_cheater_panel)
        end
    end

    if cfg.boss then
        pcall(draw_boss_panel)
    end
end
OnFrame = _G.on_frame
on_frame = _G.on_frame
onFrame = _G.on_frame
_G.OnFrame = _G.on_frame
_G.on_frame = _G.on_frame
_G.onFrame = _G.on_frame


thread.Create(scan_containers, 10000)
thread.Create(scan_world_items, 8000)
thread.Create(scan_quests, 30000)
thread.Create(scan_npcs, 6000)
thread.Create(scan_players, 10000)
thread.Create(scan_extracts, 10000)
thread.Create(update_bosses, 20000)

pcall(apply_world_mods)
pcall(apply_foliage_mods)


OnPlayerAdded = function(player)
if STAFF_IDS[player.UserId] then
notify.Warning("STAFF JOINED", player.Name, 10)
end
end

silent_ok = false

pcall(function()
    local rep = game.ReplicatedStorage
    local remotes = rep and rep:FindFirstChild("Remotes")
    if remotes then
        local s_msg = remotes:FindFirstChild("ServerMessage")
        if s_msg and s_msg.OnClientEvent then
            local c = s_msg.OnClientEvent:Connect(function(msg)
                if type(msg) == "string" then parse_kill_message(msg) end
            end)
            table.insert(_G.boba_connections, c)
        end
        local n_msg = remotes:FindFirstChild("NotificationMessage")
        if n_msg and n_msg.OnClientEvent then
            local c = n_msg.OnClientEvent:Connect(function(msg)
                if type(msg) == "string" then parse_kill_message(msg) end
            end)
            table.insert(_G.boba_connections, c)
        end
    end
    local tcs = game:GetService("TextChatService")
    if tcs and tcs.MessageReceived then
        local c = tcs.MessageReceived:Connect(function(msgObj)
            if msgObj and msgObj.Text then parse_kill_message(msgObj.Text) end
        end)
        table.insert(_G.boba_connections, c)
    end
end)

notify.Success("BOBA loaded", "Project Delta Suite")
print("[BOBA] loaded - " .. entity.GetPlayerCount() .. " players online")
pcall(function()
    local act = read_active_cfg and read_active_cfg() or "default"
    if world.menu_ui then
        world.menu_ui.selected_cfg = act
        world.menu_ui.cfg_name_buf = act
    end
end)
-- boba v2.1
