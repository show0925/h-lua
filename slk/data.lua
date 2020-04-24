slk = require "slk"

local tempData = {}

HLUA_SLK_KEYS = {
    COMMON = 99,
    PLAYER_MAP_LEVEL_AWARD_MAX = 100,
    PLAYER_MAP_LEVEL_AWARD = 101,
    UNIT_TOKEN = 102,
    UNIT_TOKEN_LEAP = 103,
    UNIT_TREE = 104,
    SKILL_ITEM_SEPARATE = 105,
    SKILL_BREAK = 106,
    SKILL_SWIM_UNLIMIT = 107,
    SKILL_INVISIBLE = 108,
    SKILL_HERO_TAVERN_SELECTION = 109,
    UNIT_HERO_TAVERN = 110,
    UNIT_HERO_TAVERN_TOKEN = 111,
    UNIT_HERO_DEATH_TOKEN = 112,
    ITEM_MOMENT = 113,
    ATTR_STR_GREEN_ADD = 114,
    ATTR_STR_GREEN_SUB = 115,
    ATTR_AGI_GREEN_ADD = 116,
    ATTR_AGI_GREEN_SUB = 117,
    ATTR_INT_GREEN_ADD = 118,
    ATTR_INT_GREEN_SUB = 119,
    ATTR_ATTACK_GREEN_ADD = 120,
    ATTR_ATTACK_GREEN_SUB = 121,
    ATTR_ATTACK_WHITE_ADD = 122,
    ATTR_ATTACK_WHITE_SUB = 123,
    ATTR_ITEM_ATTACK_WHITE_ADD = 124,
    ATTR_ITEM_ATTACK_WHITE_SUB = 125,
    ATTR_ATTACK_SPEED_ADD = 126,
    ATTR_ATTACK_SPEED_SUB = 127,
    ATTR_DEFEND_ADD = 128,
    ATTR_DEFEND_SUB = 129,
    ATTR_MANA_ADD = 130,
    ATTR_MANA_SUB = 131,
    ATTR_LIFE_ADD = 132,
    ATTR_LIFE_SUB = 133,
    ATTR_AVOID_ADD = 134,
    ATTR_AVOID_SUB = 135,
    ATTR_SIGHT_ADD = 136,
    ATTR_SIGHT_SUB = 137,
    ENV_MODEL_NAME = 138,
    ENV_MODEL = 139,
    EX_SHAPESHIFT = 200
}

--科技
-- #地图等级奖励
table.insert(
    tempData,
    {
        HLUA_SLK_KEYS.PLAYER_MAP_LEVEL_AWARD,
        -1,
        50,
        "int"
    }
)
for i = 1, 50 do
    local obj = slk.upgrade.Rhde:new("dzapi_map_level_award_" .. i)
    obj.EditorSuffix = "#h-lua"
    obj.Name = "达到地图等级：" .. i .. "级"
    obj.Hotkey = ""
    obj.Tip = ""
    obj.Ubertip = ""
    obj.Buttonpos1 = 0
    obj.Buttonpos2 = 0
    obj.Art = "ReplaceableTextures\\CommandButtons\\BTNControlMagic.blp"
    table.insert(
        tempData,
        {
            HLUA_SLK_KEYS.PLAYER_MAP_LEVEL_AWARD,
            i,
            obj:get_id(),
            "int"
        }
    )
end

--单位
-- #token
local obj = slk.unit.ogru:new("unit_token")
obj.EditorSuffix = "#h-lua"
obj.Name = "Token"
obj.special = 1
obj.abilList = "Avul,Aloc"
obj.upgrade = ""
obj.file = ".mdl"
obj.unitShadow = ""
obj.collision = 0
obj.Art = ""
obj.movetp = "fly"
obj.moveHeight = 25.00
obj.spd = 522
obj.turnRate = 3.00
obj.moveFloor = 25.00
obj.weapsOn = 0
obj.race = "other"
obj.fused = 0
obj.sight = 0
obj.nsight = 0
obj.Builds = ""
obj.upgrades = ""
table.insert(
    tempData,
    {
        HLUA_SLK_KEYS.COMMON,
        HLUA_SLK_KEYS.UNIT_TOKEN,
        obj:get_id(),
        "int"
    }
)

--冲击单位
-- #token
obj = slk.unit.ogru:new("unit_token_leap")
obj.EditorSuffix = "#h-lua"
obj.Name = "Token - leap"
obj.special = 1
obj.abilList = "Avul,Aloc"
obj.upgrade = ""
obj.file = "war3mapImported\\interface_token.mdx"
obj.unitShadow = ""
obj.collision = 0
obj.Art = ""
obj.modelScale = 1.00
obj.movetp = "fly"
obj.moveHeight = 0.00
obj.moveFloor = 0.00
obj.spd = 0
obj.turnRate = 3.00
obj.weapsOn = 0
obj.race = "other"
obj.fused = 0
obj.sight = 250
obj.nsight = 250
obj.Builds = ""
obj.upgrades = ""
table.insert(
    tempData,
    {
        HLUA_SLK_KEYS.COMMON,
        HLUA_SLK_KEYS.UNIT_TOKEN_LEAP,
        obj:get_id(),
        "int"
    }
)

--树
-- #token
obj = slk.unit.ogru:new("unit_tree")
obj.EditorSuffix = "#h-lua"
obj.Name = "Tree"
obj.special = 1
obj.abilList = "Avul,Aloc"
obj.upgrade = ""
obj.file = "war3mapImported\\deco_NewBirch.mdl"
obj.unitShadow = "ShadowFlyer"
obj.Art = "ReplaceableTextures\\WorldEditUI\\Doodad-Destructible.blp"
obj.movetp = ""
obj.moveHeight = 0
obj.spd = 0
obj.turnRate = 0
obj.moveFloor = 0
obj.weapsOn = 0
obj.race = "other"
obj.fused = 0
obj.sight = 0
obj.nsight = 0
obj.Builds = ""
obj.upgrades = ""
table.insert(
    tempData,
    {
        HLUA_SLK_KEYS.COMMON,
        HLUA_SLK_KEYS.UNIT_TREE,
        obj:get_id(),
        "int"
    }
)

--技能
-- #拆分物品
obj = slk.ability.ANtm:new("skill_item_separate")
obj.EditorSuffix = "#h-lua"
obj.Name = "拆分物品"
obj.DataD1 = 0
obj.DataA1 = 0
obj.Tip = "拆分物品(|cffffcc00N|r)"
obj.Ubertip = "如果物品|cffffff80多个叠加|r，会先被拆分成多个|cffffff80单品|r|n当单品是一个|cffffff80合成物|r时，将被拆分成|cffffff80相应的零件|r|n|cffff8080 * 注意拆分后的物品如果持有会掉落在地上，做好心理准备|r"
obj.Art = "ReplaceableTextures\\CommandButtons\\BTNAdvStruct.blp"
obj.Hotkey = "N"
obj.Buttonpos1 = 3
obj.Buttonpos2 = 0
obj.Missileart = ""
obj.Missilespeed = 99999
obj.Missilearc = 0.00
obj.Animnames = ""
obj.hero = 0
obj.race = "other"
obj.BuffID = ""
obj.Cool1 = 0.00
obj.targs1 = "item,nonhero"
obj.Cost1 = 0
obj.Rng1 = 30.00
table.insert(
    tempData,
    {
        HLUA_SLK_KEYS.COMMON,
        HLUA_SLK_KEYS.SKILL_ITEM_SEPARATE,
        obj:get_id(),
        "int"
    }
)

-- #眩晕[0.05-0.5]
for dur = 1, 10, 1 do
    local swDur = dur * 0.05
    obj = slk.ability.AHtb:new("skill_break_" .. swDur)
    obj.EditorSuffix = "#h-lua"
    obj.Name = "技能系统-眩晕" .. swDur .. "秒"
    obj.DataA1 = 0.00
    obj.Tip = "眩晕" .. swDur .. "秒"
    obj.Ubertip = "眩晕" .. swDur .. "秒"
    obj.Art = ""
    obj.Missileart = ""
    obj.Missilespeed = 999999
    obj.Animnames = ""
    obj.hero = 0
    obj.race = "other"
    obj.levels = 1
    obj.Cool1 = 10.00
    obj.targs1 = "neutral,vulnerable,ground,enemies,invulnerable,organic,debris,air,friend,self"
    obj.Dur1 = swDur
    obj.HeroDur1 = swDur
    obj.Cost1 = 0
    obj.Rng1 = 9999.00
    table.insert(
        tempData,
        {
            HLUA_SLK_KEYS.SKILL_BREAK,
            dur,
            obj:get_id(),
            "int"
        }
    )
end

-- #无限眩晕
obj = slk.ability.AHtb:new("skill_swim_unlimit")
obj.EditorSuffix = "#h-lua"
obj.Name = "技能系统 无限眩晕"
obj.DataA1 = 0.00
obj.Tip = "无限眩晕"
obj.Ubertip = "无限眩晕"
obj.Art = ""
obj.Missileart = ""
obj.Missilespeed = 999999
obj.Missilearc = 0.00
obj.Animnames = ""
obj.hero = 0
obj.race = "other"
obj.levels = 1
obj.Cool1 = 10.00
obj.targs1 = "neutral,vulnerable,ground,enemies,invulnerable,organic,debris,air,friend,self"
obj.Dur1 = 0.000
obj.HeroDur1 = 0.000
obj.Cost1 = 0
obj.Rng1 = 9999.00
table.insert(
    tempData,
    {
        HLUA_SLK_KEYS.COMMON,
        HLUA_SLK_KEYS.SKILL_SWIM_UNLIMIT,
        obj:get_id(),
        "int"
    }
)

--隐身
obj = slk.ability.Apiv:new("skill_invisible")
obj.EditorSuffix = "#h-lua"
obj.Name = "技能系统-隐身"
obj.DataA1 = 0.00
obj.Tip = "隐身"
obj.Ubertip = "隐身"
obj.Art = ""
obj.hero = 0
obj.race = "other"
obj.Dur1 = 0
obj.HeroDur1 = 0
table.insert(
    tempData,
    {
        HLUA_SLK_KEYS.COMMON,
        HLUA_SLK_KEYS.SKILL_INVISIBLE,
        obj:get_id(),
        "int"
    }
)

-- #酒馆选英雄选择单位
obj = slk.ability.Aneu:new("skill_hero_tavern_selection")
obj.EditorSuffix = "#h-lua"
obj.Name = "技能系统 酒馆选英雄选择单位"
obj.DataA1 = 1000.00
obj.DataB1 = 4
obj.DataC1 = 0
obj.DataD1 = 0
obj.Rng1 = 900.00
table.insert(
    tempData,
    {
        HLUA_SLK_KEYS.COMMON,
        HLUA_SLK_KEYS.SKILL_HERO_TAVERN_SELECTION,
        obj:get_id(),
        "int"
    }
)

-- #酒馆演示 tavern
local aid = obj:get_id()
obj = slk.unit.ntav:new("unit_hero_tavern")
obj.EditorSuffix = "#h-lua"
obj.Name = "英雄系统 酒馆"
obj.abilList = "Avul,Asid," .. aid
obj.Sellunits = ""
obj.pathTex = ""
obj.collision = ""
obj.modelScale = 0.60
obj.scale = 2.00
obj.uberSplat = ""
obj.teamColor = 12
table.insert(
    tempData,
    {
        HLUA_SLK_KEYS.COMMON,
        HLUA_SLK_KEYS.UNIT_HERO_TAVERN,
        obj:get_id(),
        "int"
    }
)

-- #token
obj = slk.unit.ogru:new("unit_hero_tavern_token")
obj.EditorSuffix = "#h-lua"
obj.Name = "英雄系统 选英雄Token"
obj.special = 1
obj.abilList = "Avul,AInv"
obj.upgrade = ""
obj.collision = 0.00
obj.file = ".mdl"
obj.unitShadow = ""
obj.Art = ""
obj.movetp = "fly"
obj.moveHeight = 25.00
obj.spd = 522
obj.turnRate = 3.00
obj.moveFloor = 25.00
obj.weapsOn = 0
obj.race = "other"
obj.fused = 0
obj.sight = 1250
obj.nsight = 1250
obj.Builds = ""
obj.upgrades = ""
table.insert(
    tempData,
    {
        HLUA_SLK_KEYS.COMMON,
        HLUA_SLK_KEYS.UNIT_HERO_TAVERN_TOKEN,
        obj:get_id(),
        "int"
    }
)

-- #死亡标志
obj = slk.unit.nban:new("unit_hero_death_token")
obj.EditorSuffix = "#h-lua"
obj.Name = "英雄死亡时轮"
obj.tilesets = "*"
obj.special = 1
obj.hostilePal = 0
obj.abilList = "Avul,Alnv,Aloc"
obj.upgrade = ""
obj.collision = 0.00
obj.unitSound = 0.00
obj.modelScale = 0.75
obj.scale = 0.75
obj.file = "war3mapImported\\ClockRune.mdl"
obj.red = 255
obj.blue = 255
obj.green = 255
obj.maxPitch = 0.00
obj.maxRoll = 0.00
obj.impactZ = 0.00
obj.unitShadow = ""
obj.Art = ""
obj.movetp = "fly"
obj.spd = 0
obj.turnRate = 3.00
obj.moveFloor = 25.00
obj.weapsOn = 0
obj.race = "other"
obj.fused = 0
obj.sight = 250
obj.nsight = 250
obj.Builds = ""
obj.upgrades = ""
table.insert(
    tempData,
    {
        HLUA_SLK_KEYS.COMMON,
        HLUA_SLK_KEYS.UNIT_HERO_DEATH_TOKEN,
        obj:get_id(),
        "int"
    }
)

-- #地上自动捡拾物
local item_moments = {
    { Name = "金币", file = "Objects\\InventoryItems\\PotofGold\\PotofGold.mdl", modelScale = 1.00, moveHeight = -30 },
    {
        Name = "木材",
        file = "Objects\\InventoryItems\\BundleofLumber\\BundleofLumber.mdl",
        modelScale = 1.00,
        moveHeight = -30
    },
    { Name = "黄色书", file = "Objects\\InventoryItems\\tomeBrown\\tomeBrown.mdl", modelScale = 1.00, moveHeight = -20 },
    { Name = "绿色书", file = "Objects\\InventoryItems\\tomeGreen\\tomeGreen.mdl", modelScale = 1.00, moveHeight = -20 },
    { Name = "紫色书", file = "Objects\\InventoryItems\\tome\\tome.mdl", modelScale = 1.00, moveHeight = -20 },
    { Name = "蓝色书", file = "Objects\\InventoryItems\\tomeBlue\\tomeBlue.mdl", modelScale = 1.00, moveHeight = -20 },
    { Name = "红色书", file = "Objects\\InventoryItems\\tomeRed\\tomeRed.mdl", modelScale = 1.00, moveHeight = -20 },
    { Name = "神符", file = "Objects\\InventoryItems\\runicobject\\runicobject.mdl", modelScale = 0.80, moveHeight = -10 },
    { Name = "浮雕", file = "Objects\\InventoryItems\\Glyph\\Glyph.mdl", modelScale = 0.60, moveHeight = 0 },
    {
        Name = "蛋",
        file = "Objects\\InventoryItems\\ThunderLizardEgg\\ThunderLizardEgg.mdl",
        modelScale = 1.30,
        moveHeight = 20
    },
    { Name = "碎片", file = "Objects\\InventoryItems\\CrystalShard\\CrystalShard.mdl", modelScale = 1.00, moveHeight = -20 },
    { Name = "问号", file = "Objects\\InventoryItems\\QuestionMark\\QuestionMark.mdl", modelScale = 0.60, moveHeight = 0 },
    { Name = "荧光草", file = "Objects\\InventoryItems\\Shimmerweed\\Shimmerweed.mdl", modelScale = 0.80, moveHeight = 0 },
    { Name = "Dota2赏金符", file = "war3mapImported\\Dota2.Runes.Bounty.mdl", modelScale = 0.80, moveHeight = -10 },
    { Name = "Dota2伤害符", file = "war3mapImported\\Dota2.Runes.DoubleDamage.mdl", modelScale = 0.80, moveHeight = -10 },
    { Name = "Dota2恢复符", file = "war3mapImported\\Dota2.Runes.Regeneration.mdl", modelScale = 0.80, moveHeight = -10 },
    { Name = "Dota2极速符", file = "war3mapImported\\Dota2.Runes.Haste.mdl", modelScale = 0.80, moveHeight = -10 },
    { Name = "Dota2幻象符", file = "war3mapImported\\Dota2.Runes.Illusion.mdl", modelScale = 0.80, moveHeight = -10 },
    { Name = "Dota2隐身符", file = "war3mapImported\\Dota2.Runes.Invisibility.mdl", modelScale = 0.80, moveHeight = -10 }
}
local itemMomentsLen = 0
for k, v in ipairs(item_moments) do
    itemMomentsLen = itemMomentsLen + 1
    obj = slk.unit.ogru:new("item_moment_" .. v.Name)
    obj.EditorSuffix = "#h-lua"
    obj.Name = "瞬逝物系统 " .. v.Name
    obj.special = 1
    obj.abilList = "Avul,Aloc"
    obj.upgrade = ""
    obj.collision = 0.00
    obj.modelScale = v.modelScale
    obj.file = v.file
    obj.unitShadow = ""
    obj.Art = ""
    obj.movetp = ""
    obj.moveHeight = v.moveHeight
    obj.spd = 0
    obj.turnRate = 0.1
    obj.weapsOn = 0
    obj.race = "other"
    obj.fused = 0
    obj.sight = 0
    obj.nsight = 0
    table.insert(
        tempData,
        {
            HLUA_SLK_KEYS.ITEM_MOMENT,
            k,
            obj:get_id(),
            "int"
        }
    )
end
table.insert(
    tempData,
    {
        HLUA_SLK_KEYS.ITEM_MOMENT,
        -1,
        itemMomentsLen,
        "int"
    }
)

--属性系统
for i = 1, 9 do
    local val = math.floor(10 ^ (i - 1))
    -- #力量
    obj = slk.ability.Aamk:new("attr_str_green_add_" .. i)
    obj.EditorSuffix = "#h-lua"
    obj.Name = "属性系统#力量+" .. val
    obj.Art = ""
    obj.hero = 0
    obj.race = "other"
    obj.item = 1
    obj.levels = 10
    for j = 0, 9 do
        obj["DataA" .. (j + 1)] = 0
        obj["DataB" .. (j + 1)] = 0
        obj["DataC" .. (j + 1)] = 1 * val * j
        obj["DataD" .. (j + 1)] = 1
    end
    table.insert(
        tempData,
        {
            HLUA_SLK_KEYS.ATTR_STR_GREEN_ADD,
            val,
            obj:get_id(),
            "int"
        }
    )
    -- #负力量
    obj = slk.ability.Aamk:new("attr_str_green_sub_" .. i)
    obj.EditorSuffix = "#h-lua"
    obj.Name = "属性系统#力量-" .. val
    obj.Art = ""
    obj.hero = 0
    obj.race = "other"
    obj.item = 1
    obj.levels = 10
    for j = 0, 9 do
        obj["DataA" .. (j + 1)] = 0
        obj["DataB" .. (j + 1)] = 0
        obj["DataC" .. (j + 1)] = -1 * val * j
        obj["DataD" .. (j + 1)] = 1
    end
    table.insert(
        tempData,
        {
            HLUA_SLK_KEYS.ATTR_STR_GREEN_SUB,
            val,
            obj:get_id(),
            "int"
        }
    )
    -- #敏捷
    obj = slk.ability.Aamk:new("attr_agi_green_add_" .. i)
    obj.EditorSuffix = "#h-lua"
    obj.Name = "属性系统#敏捷+" .. val
    obj.Art = ""
    obj.hero = 0
    obj.race = "other"
    obj.item = 1
    obj.levels = 10
    for j = 0, 9 do
        obj["DataA" .. (j + 1)] = 1 * val * j
        obj["DataB" .. (j + 1)] = 0
        obj["DataC" .. (j + 1)] = 0
        obj["DataD" .. (j + 1)] = 1
    end
    table.insert(
        tempData,
        {
            HLUA_SLK_KEYS.ATTR_AGI_GREEN_ADD,
            val,
            obj:get_id(),
            "int"
        }
    )
    -- #负敏捷
    obj = slk.ability.Aamk:new("attr_agi_green_sub_" .. i)
    obj.EditorSuffix = "#h-lua"
    obj.Name = "属性系统#敏捷-" .. val
    obj.Art = ""
    obj.hero = 0
    obj.race = "other"
    obj.item = 1
    obj.levels = 10
    for j = 0, 9 do
        obj["DataA" .. (j + 1)] = -1 * val * j
        obj["DataB" .. (j + 1)] = 0
        obj["DataC" .. (j + 1)] = 0
        obj["DataD" .. (j + 1)] = 1
    end
    table.insert(
        tempData,
        {
            HLUA_SLK_KEYS.ATTR_AGI_GREEN_SUB,
            val,
            obj:get_id(),
            "int"
        }
    )
    -- #智力
    obj = slk.ability.Aamk:new("attr_int_green_add_" .. i)
    obj.EditorSuffix = "#h-lua"
    obj.Name = "属性系统#智力+" .. val
    obj.Art = ""
    obj.hero = 0
    obj.race = "other"
    obj.item = 1
    obj.levels = 10
    for j = 0, 9 do
        obj["DataA" .. (j + 1)] = 0
        obj["DataB" .. (j + 1)] = 1 * val * j
        obj["DataC" .. (j + 1)] = 0
        obj["DataD" .. (j + 1)] = 1
    end
    table.insert(
        tempData,
        {
            HLUA_SLK_KEYS.ATTR_INT_GREEN_ADD,
            val,
            obj:get_id(),
            "int"
        }
    )
    -- #负智力
    obj = slk.ability.Aamk:new("attr_int_green_sub_" .. i)
    obj.EditorSuffix = "#h-lua"
    obj.Name = "属性系统#智力-" .. val
    obj.Art = ""
    obj.hero = 0
    obj.race = "other"
    obj.item = 1
    obj.levels = 10
    for j = 0, 9 do
        obj["DataA" .. (j + 1)] = 0
        obj["DataB" .. (j + 1)] = -1 * val * j
        obj["DataC" .. (j + 1)] = 0
        obj["DataD" .. (j + 1)] = 1
    end
    table.insert(
        tempData,
        {
            HLUA_SLK_KEYS.ATTR_INT_GREEN_SUB,
            val,
            obj:get_id(),
            "int"
        }
    )
    -- #绿攻击力
    obj = slk.ability.AItg:new("attr_attack_green_add_" .. i)
    obj.EditorSuffix = "#h-lua"
    obj.Name = "属性系统#绿字攻击力+" .. val
    obj.Art = ""
    obj.levels = 10
    for j = 0, 9 do
        obj["DataA" .. (j + 1)] = 1 * val * j
    end
    table.insert(
        tempData,
        {
            HLUA_SLK_KEYS.ATTR_ATTACK_GREEN_ADD,
            val,
            obj:get_id(),
            "int"
        }
    )
    -- #负绿攻击力
    obj = slk.ability.AItg:new("attr_attack_green_sub_" .. i)
    obj.EditorSuffix = "#h-lua"
    obj.Name = "属性系统#绿字攻击力-" .. val
    obj.Art = ""
    obj.levels = 10
    for j = 0, 9 do
        obj["DataA" .. (j + 1)] = -1 * val * j
    end
    table.insert(
        tempData,
        {
            HLUA_SLK_KEYS.ATTR_ATTACK_GREEN_SUB,
            val,
            obj:get_id(),
            "int"
        }
    )
    -- #白攻击力
    obj = slk.ability.AIaa:new("attr_attack_white_add_" .. i)
    obj.EditorSuffix = "#h-lua"
    obj.Name = "属性系统#白字攻击力+" .. val
    obj.Art = ""
    obj.levels = 1
    obj.DataA1 = 1 * val
    obj.CasterArt = ""
    obj.Casterattach = ""
    table.insert(
        tempData,
        {
            HLUA_SLK_KEYS.ATTR_ATTACK_WHITE_ADD,
            val,
            obj:get_id(),
            "int"
        }
    )
    -- #白攻击力(书)
    local iid = obj:get_id()
    obj = slk.item.manh:new("attr_item_attack_white_add_" .. i)
    obj.abilList = iid
    obj.Name = "属性系统#白字攻击力+" .. val
    obj.Description = "#h-lua"
    obj.Tip = ""
    obj.Ubertip = ""
    obj.Art = ""
    obj.scale = 0.10
    obj.file = ".mdl"
    obj.goldcost = 0
    obj.stockRegen = 0
    obj.cooldownID = ""
    table.insert(
        tempData,
        {
            HLUA_SLK_KEYS.ATTR_ITEM_ATTACK_WHITE_ADD,
            val,
            obj:get_id(),
            "int"
        }
    )
    -- #负白攻击力
    obj = slk.ability.AIaa:new("attr_attack_white_sub_" .. i)
    obj.EditorSuffix = "#h-lua"
    obj.Name = "属性系统#白字攻击力-" .. val
    obj.Art = ""
    obj.levels = 1
    obj.DataA1 = -1 * val
    obj.CasterArt = ""
    obj.Casterattach = ""
    table.insert(
        tempData,
        {
            HLUA_SLK_KEYS.ATTR_ATTACK_WHITE_SUB,
            val,
            obj:get_id(),
            "int"
        }
    )
    -- #负白攻击力(书)
    iid = obj:get_id()
    obj = slk.item.manh:new("attr_item_attack_white_sub_" .. i)
    obj.abilList = iid
    obj.Name = "属性系统#白字攻击力-" .. val
    obj.Description = "#h-lua"
    obj.Tip = ""
    obj.Ubertip = ""
    obj.Art = ""
    obj.scale = 0.10
    obj.file = ".mdl"
    obj.goldcost = 0
    obj.stockRegen = 0
    obj.cooldownID = ""
    table.insert(
        tempData,
        {
            HLUA_SLK_KEYS.ATTR_ITEM_ATTACK_WHITE_SUB,
            val,
            obj:get_id(),
            "int"
        }
    )
    -- #攻击速度
    obj = slk.ability.AIsx:new("attr_attack_speed_add_" .. i)
    obj.EditorSuffix = "#h-lua"
    obj.Name = "属性系统#攻击速度+" .. val
    obj.Art = ""
    obj.levels = 10
    for j = 0, 9 do
        obj["DataA" .. (j + 1)] = 0.01 * val * j
    end
    table.insert(
        tempData,
        {
            HLUA_SLK_KEYS.ATTR_ATTACK_SPEED_ADD,
            val,
            obj:get_id(),
            "int"
        }
    )
    -- #负攻击速度
    obj = slk.ability.AIsx:new("attr_attack_speed_sub_" .. i)
    obj.EditorSuffix = "#h-lua"
    obj.Name = "属性系统#攻击速度-" .. val
    obj.Art = ""
    obj.levels = 10
    for j = 0, 9 do
        obj["DataA" .. (j + 1)] = -0.01 * val * j
    end
    table.insert(
        tempData,
        {
            HLUA_SLK_KEYS.ATTR_ATTACK_SPEED_SUB,
            val,
            obj:get_id(),
            "int"
        }
    )
    -- #护甲
    obj = slk.ability.AId1:new("attr_defend_add_" .. i)
    obj.EditorSuffix = "#h-lua"
    obj.Name = "属性系统#护甲+" .. val
    obj.Art = ""
    obj.levels = 10
    for j = 0, 9 do
        obj["DataA" .. (j + 1)] = 1 * val * j
    end
    table.insert(
        tempData,
        {
            HLUA_SLK_KEYS.ATTR_DEFEND_ADD,
            val,
            obj:get_id(),
            "int"
        }
    )
    -- #负护甲
    obj = slk.ability.AId1:new("attr_defend_sub_" .. i)
    obj.EditorSuffix = "#h-lua"
    obj.Name = "属性系统#护甲-" .. val
    obj.Art = ""
    obj.levels = 10
    for j = 0, 9 do
        obj["DataA" .. (j + 1)] = -1 * val * j
    end
    table.insert(
        tempData,
        {
            HLUA_SLK_KEYS.ATTR_DEFEND_SUB,
            val,
            obj:get_id(),
            "int"
        }
    )
    -- #魔法
    obj = slk.ability.AImv:new("attr_mana_add_" .. i)
    obj.EditorSuffix = "#h-lua"
    obj.Name = "属性系统#魔法+" .. val
    obj.Art = ""
    obj.levels = 2
    obj["DataA1"] = 0
    obj["DataA2"] = -1 * val
    table.insert(
        tempData,
        {
            HLUA_SLK_KEYS.ATTR_MANA_ADD,
            val,
            obj:get_id(),
            "int"
        }
    )
    -- #负魔法
    obj = slk.ability.AImv:new("attr_mana_sub_" .. i)
    obj.EditorSuffix = "#h-lua"
    obj.Name = "属性系统#魔法-" .. val
    obj.Art = ""
    obj.levels = 2
    obj["DataA1"] = 0
    obj["DataA2"] = 1 * val
    table.insert(
        tempData,
        {
            HLUA_SLK_KEYS.ATTR_MANA_SUB,
            val,
            obj:get_id(),
            "int"
        }
    )
    -- #生命
    obj = slk.ability.AIlf:new("attr_life_add_" .. i)
    obj.EditorSuffix = "#h-lua"
    obj.Name = "属性系统#生命+" .. val
    obj.Art = ""
    obj.levels = 2
    obj["DataA1"] = 0
    obj["DataA2"] = -1 * val
    table.insert(
        tempData,
        {
            HLUA_SLK_KEYS.ATTR_LIFE_ADD,
            val,
            obj:get_id(),
            "int"
        }
    )
    -- #负生命
    obj = slk.ability.AIlf:new("attr_life_sub_" .. i)
    obj.EditorSuffix = "#h-lua"
    obj.Name = "属性系统#生命-" .. val
    obj.Art = ""
    obj.levels = 2
    obj["DataA1"] = 0
    obj["DataA2"] = 1 * val
    table.insert(
        tempData,
        {
            HLUA_SLK_KEYS.ATTR_LIFE_SUB,
            val,
            obj:get_id(),
            "int"
        }
    )
end

-- #回避
obj = slk.ability.AIlf:new("attr_avoid_add")
obj.EditorSuffix = "#h-lua"
obj.Name = "属性系统#回避+"
obj.Art = ""
obj.levels = 2
obj.DataA1 = 0
obj.DataA2 = -10000000
table.insert(
    tempData,
    {
        HLUA_SLK_KEYS.COMMON,
        HLUA_SLK_KEYS.ATTR_AVOID_ADD,
        obj:get_id(),
        "int"
    }
)
obj = slk.ability.AIlf:new("attr_avoid_sub")
obj.EditorSuffix = "#h-lua"
obj.Name = "属性系统#回避-"
obj.Art = ""
obj.levels = 2
obj.DataA1 = 0
obj.DataA2 = 10000000
table.insert(
    tempData,
    {
        HLUA_SLK_KEYS.COMMON,
        HLUA_SLK_KEYS.ATTR_AVOID_SUB,
        obj:get_id(),
        "int"
    }
)

-- #视野
local sightBase = { 1, 2, 3, 4, 5 }
local i = 1
while (i <= 10000) do
    for _, v in ipairs(sightBase) do
        v = math.floor(v * i)
        -- #正视野
        obj = slk.ability.AIsi:new("attr_sight_add_" .. v)
        obj.EditorSuffix = "#h-lua"
        obj.Name = "属性系统#视野+" .. v
        obj.Art = ""
        obj.levels = 1
        obj["DataA1"] = 1 * v
        table.insert(
            tempData,
            {
                HLUA_SLK_KEYS.ATTR_SIGHT_ADD,
                v,
                obj:get_id(),
                "int"
            }
        )
        -- #负视野
        obj = slk.ability.AIsi:new("attr_sight_sub_" .. v)
        obj.EditorSuffix = "#h-lua"
        obj.Name = "属性系统#视野-" .. v
        obj.Art = ""
        obj.levels = 1
        obj["DataA1"] = -1 * v
        table.insert(
            tempData,
            {
                HLUA_SLK_KEYS.ATTR_SIGHT_SUB,
                v,
                obj:get_id(),
                "int"
            }
        )
    end
    i = i * 10
end

-- #随机环境Env
local envs = {
    { Name = "fire", file = "Doodads\\Cinematic\\FirePillarMedium\\FirePillarMedium.mdl" }, -- 火焰
    { Name = "fireblue", file = "Doodads\\Cinematic\\TownBurningFireEmitterBlue\\TownBurningFireEmitterBlue.mdl" }, --蓝色火焰
    { Name = "firetrap", file = "Doodads\\Cinematic\\FireTrapUp\\FireTrapUp.mdl" }, -- 火焰陷阱
    { Name = "firetrapblue", file = "Doodads\\Cinematic\\FrostTrapUp\\FrostTrapUp.mdl" }, -- 蓝色火焰陷阱
    { Name = "lightningbolt", file = "Doodads\\Cinematic\\Lightningbolt\\Lightningbolt.mdl" }, -- 季风闪电
    { Name = "snowman", file = "Doodads\\Icecrown\\Props\\SnowMan\\SnowMan.mdl" }, -- 雪人
    { Name = "bubble_geyser", file = "Doodads\\Ruins\\Water\\BubbleGeyser\\BubbleGeyser.mdl" }, -- 泡沫
    { Name = "bubble_geyser_steam", file = "Doodads\\Icecrown\\Water\\BubbleGeyserSteam\\BubbleGeyserSteam.mdl" }, -- 带蒸汽泡沫
    { Name = "fish_school", file = "Doodads\\Ruins\\Water\\FishSchool\\FishSchool.mdl" }, -- 小鱼群
    { Name = "fish", file = "Doodads\\Ashenvale\\Water\\Fish\\Fish.mdl" }, -- 鱼
    { Name = "fish_green", file = "Doodads\\Ruins\\Water\\FishTropical\\FishTropical.mdl" }, -- 绿色的鱼
    { Name = "fire_hole", file = "Doodads\\Dungeon\\Rocks\\Cave_FieryCrator\\Cave_FieryCrator.mdl" }, -- 火焰弹坑
    { Name = "bird", file = "Doodads\\Ashenvale\\Props\\Bird\\Bird.mdl" }, -- 鸟
    { Name = "bats", file = "Doodads\\Northrend\\Props\\Bats\\Bats.mdl" }, -- 蝙蝠
    { Name = "flies", file = "Doodads\\LordaeronSummer\\Props\\Flies\\Flies.mdl" }, -- 苍蝇
    { Name = "burn_build", file = "Doodads\\Cityscape\\Structures\\CityBuildingLarge_0_BaseRuin\\CityBuildingLarge_0_BaseRuin.mdl" }, --焚烧毁坏建筑
    { Name = "ice0", file = "Doodads\\Icecrown\\Rocks\\IceBlock\\IceBlock0.mdl" }, -- 冰块
    { Name = "ice1", file = "Doodads\\Icecrown\\Rocks\\IceBlock\\IceBlock1.mdl" },
    { Name = "ice2", file = "Doodads\\Icecrown\\Rocks\\IceBlock\\IceBlock2.mdl" },
    { Name = "ice3", file = "Doodads\\Icecrown\\Rocks\\IceBlock\\IceBlock3.mdl" },
    { Name = "seaweed0", file = "Doodads\\Ruins\\Water\\Seaweed0\\Seaweed00.mdl" }, -- 海藻
    { Name = "seaweed1", file = "Doodads\\Ruins\\Water\\Seaweed0\\Seaweed01.mdl" },
    { Name = "seaweed2", file = "Doodads\\Ruins\\Water\\Seaweed0\\Seaweed02.mdl" },
    { Name = "seaweed3", file = "Doodads\\Ruins\\Water\\Seaweed0\\Seaweed03.mdl" },
    { Name = "seaweed4", file = "Doodads\\Ruins\\Water\\Seaweed0\\Seaweed04.mdl" },
    { Name = "break_column0", file = "Doodads\\Ashenvale\\Structures\\AshenBrokenColumn\\AshenBrokenColumn0.mdl" }, --断裂的圆柱
    { Name = "break_column1", file = "Doodads\\Ashenvale\\Structures\\AshenBrokenColumn\\AshenBrokenColumn1.mdl" },
    { Name = "break_column2", file = "Doodads\\Ruins\\Props\\RuinsTrash\\RuinsTrash0.mdl" },
    { Name = "break_column3", file = "Doodads\\Ruins\\Props\\RuinsTrash\\RuinsTrash1.mdl" },
    { Name = "burn_body0", file = "Doodads\\Ashenvale\\Props\\ScorchedRemains\\ScorchedRemains0.mdl" }, -- 焚烧尸体
    { Name = "burn_body1", file = "Doodads\\Ashenvale\\Props\\ScorchedRemains\\ScorchedRemains1.mdl" },
    { Name = "burn_body2", file = "Doodads\\Ashenvale\\Props\\ScorchedRemains\\ScorchedRemains2.mdl" },
    { Name = "impaled_body0", file = "Doodads\\LordaeronSummer\\Props\\ImpaledBody\\ImpaledBody0.mdl" }, -- 叉着的尸体
    { Name = "impaled_body1", file = "Doodads\\LordaeronSummer\\Props\\ImpaledBody\\ImpaledBody1.mdl" },
    { Name = "rune0", file = "Doodads\\BlackCitadel\\Props\\RuneArt\\RuneArt0.mdl" }, --血色符文
    { Name = "rune1", file = "Doodads\\BlackCitadel\\Props\\RuneArt\\RuneArt1.mdl" },
    { Name = "rune2", file = "Doodads\\BlackCitadel\\Props\\RuneArt\\RuneArt2.mdl" },
    { Name = "rune3", file = "Doodads\\BlackCitadel\\Props\\RuneArt\\RuneArt3.mdl" },
    { Name = "rune4", file = "Doodads\\BlackCitadel\\Props\\RuneArt\\RuneArt4.mdl" },
    { Name = "rune5", file = "Doodads\\BlackCitadel\\Props\\RuneArt\\RuneArt5.mdl" },
    { Name = "rune6", file = "Doodads\\BlackCitadel\\Props\\RuneArt\\RuneArt6.mdl" },
    { Name = "glowing_rune0", file = "Doodads\\Cinematic\\GlowingRunes\\GlowingRunes0.mdl" }, --发光符文
    { Name = "glowing_rune1", file = "Doodads\\Cinematic\\GlowingRunes\\GlowingRunes1.mdl" },
    { Name = "glowing_rune2", file = "Doodads\\Cinematic\\GlowingRunes\\GlowingRunes2.mdl" },
    { Name = "glowing_rune3", file = "Doodads\\Cinematic\\GlowingRunes\\GlowingRunes3.mdl" },
    { Name = "glowing_rune4", file = "Doodads\\Cinematic\\GlowingRunes\\GlowingRunes4.mdl" },
    { Name = "glowing_rune5", file = "Doodads\\Cinematic\\GlowingRunes\\GlowingRunes5.mdl" },
    { Name = "glowing_rune6", file = "Doodads\\Cinematic\\GlowingRunes\\GlowingRunes6.mdl" },
    { Name = "glowing_rune7", file = "Doodads\\Cinematic\\GlowingRunes\\GlowingRunes7.mdl" },
    { Name = "glowing_rune8", file = "Doodads\\Cinematic\\GlowingRunes\\GlowingRunes8.mdl" },
    { Name = "bone0", file = "Doodads\\Barrens\\Props\\Barrens_Bones\\Barrens_Bones0.mdl" }, -- 岩石
    { Name = "bone1", file = "Doodads\\Barrens\\Props\\Barrens_Bones\\Barrens_Bones1.mdl" },
    { Name = "bone2", file = "Doodads\\Barrens\\Props\\Barrens_Bones\\Barrens_Bones2.mdl" },
    { Name = "bone3", file = "Doodads\\Barrens\\Props\\Barrens_Bones\\Barrens_Bones3.mdl" },
    { Name = "bone4", file = "Doodads\\Barrens\\Props\\Barrens_Bones\\Barrens_Bones4.mdl" },
    { Name = "bone5", file = "Doodads\\Barrens\\Props\\Barrens_Bones\\Barrens_Bones5.mdl" },
    { Name = "bone6", file = "Doodads\\Barrens\\Props\\Barrens_Bones\\Barrens_Bones6.mdl" },
    { Name = "bone7", file = "Doodads\\Barrens\\Props\\Barrens_Bones\\Barrens_Bones7.mdl" },
    { Name = "bone8", file = "Doodads\\Barrens\\Props\\Barrens_Bones\\Barrens_Bones8.mdl" },
    { Name = "bone9", file = "Doodads\\Barrens\\Props\\Barrens_Bones\\Barrens_Bones9.mdl" },
    { Name = "bone_ice0", file = "Doodads\\Barrens\\Props\\North_Bones\\North_Bones0.mdl" }, -- 冬天岩石
    { Name = "bone_ice1", file = "Doodads\\Barrens\\Props\\North_Bones\\North_Bones1.mdl" },
    { Name = "bone_ice2", file = "Doodads\\Barrens\\Props\\North_Bones\\North_Bones2.mdl" },
    { Name = "bone_ice3", file = "Doodads\\Barrens\\Props\\North_Bones\\North_Bones3.mdl" },
    { Name = "bone_ice4", file = "Doodads\\Barrens\\Props\\North_Bones\\North_Bones4.mdl" },
    { Name = "bone_ice5", file = "Doodads\\Barrens\\Props\\North_Bones\\North_Bones5.mdl" },
    { Name = "bone_ice6", file = "Doodads\\Barrens\\Props\\North_Bones\\North_Bones6.mdl" },
    { Name = "bone_ice7", file = "Doodads\\Barrens\\Props\\North_Bones\\North_Bones7.mdl" },
    { Name = "bone_ice8", file = "Doodads\\Barrens\\Props\\North_Bones\\North_Bones8.mdl" },
    { Name = "bone_ice9", file = "Doodads\\Barrens\\Props\\North_Bones\\North_Bones9.mdl" },
    { Name = "stone0", file = "Doodads\\LordaeronSummer\\Rocks\\Lords_Rock\\Lords_Rock0.mdl" }, -- 岩石2
    { Name = "stone1", file = "Doodads\\LordaeronSummer\\Rocks\\Lords_Rock\\Lords_Rock1.mdl" },
    { Name = "stone2", file = "Doodads\\LordaeronSummer\\Rocks\\Lords_Rock\\Lords_Rock2.mdl" },
    { Name = "stone3", file = "Doodads\\LordaeronSummer\\Rocks\\Lords_Rock\\Lords_Rock3.mdl" },
    { Name = "stone4", file = "Doodads\\LordaeronSummer\\Rocks\\Lords_Rock\\Lords_Rock4.mdl" },
    { Name = "stone5", file = "Doodads\\LordaeronSummer\\Rocks\\Lords_Rock\\Lords_Rock5.mdl" },
    { Name = "stone6", file = "Doodads\\LordaeronSummer\\Rocks\\Lords_Rock\\Lords_Rock6.mdl" },
    { Name = "stone7", file = "Doodads\\LordaeronSummer\\Rocks\\Lords_Rock\\Lords_Rock7.mdl" },
    { Name = "stone8", file = "Doodads\\LordaeronSummer\\Rocks\\Lords_Rock\\Lords_Rock8.mdl" },
    { Name = "stone9", file = "Doodads\\LordaeronSummer\\Rocks\\Lords_Rock\\Lords_Rock9.mdl" },
    { Name = "stone_show0", file = "Doodads\\Icecrown\\Rocks\\Ice_SnowRock\\Ice_SnowRock0.mdl" }, -- 雪岩石
    { Name = "stone_show1", file = "Doodads\\Icecrown\\Rocks\\Ice_SnowRock\\Ice_SnowRock1.mdl" },
    { Name = "stone_show2", file = "Doodads\\Icecrown\\Rocks\\Ice_SnowRock\\Ice_SnowRock2.mdl" },
    { Name = "stone_show3", file = "Doodads\\Icecrown\\Rocks\\Ice_SnowRock\\Ice_SnowRock3.mdl" },
    { Name = "stone_show4", file = "Doodads\\Icecrown\\Rocks\\Ice_SnowRock\\Ice_SnowRock4.mdl" },
    { Name = "stone_show5", file = "Doodads\\Icecrown\\Rocks\\Ice_SnowRock\\Ice_SnowRock5.mdl" },
    { Name = "stone_show6", file = "Doodads\\Icecrown\\Rocks\\Ice_SnowRock\\Ice_SnowRock6.mdl" },
    { Name = "stone_show7", file = "Doodads\\Icecrown\\Rocks\\Ice_SnowRock\\Ice_SnowRock7.mdl" },
    { Name = "stone_show8", file = "Doodads\\Icecrown\\Rocks\\Ice_SnowRock\\Ice_SnowRock8.mdl" },
    { Name = "stone_show9", file = "Doodads\\Icecrown\\Rocks\\Ice_SnowRock\\Ice_SnowRock9.mdl" },
    { Name = "mushroom0", file = "Doodads\\Felwood\\Plants\\FelwoodShrooms\\FelwoodShrooms0.mdl" }, -- 蘑菇
    { Name = "mushroom1", file = "Doodads\\Felwood\\Plants\\FelwoodShrooms\\FelwoodShrooms1.mdl" },
    { Name = "mushroom2", file = "Doodads\\Felwood\\Plants\\FelwoodShrooms\\FelwoodShrooms2.mdl" },
    { Name = "mushroom3", file = "Doodads\\Felwood\\Plants\\FelwoodShrooms\\FelwoodShrooms3.mdl" },
    { Name = "mushroom4", file = "Doodads\\Felwood\\Plants\\FelwoodShrooms\\FelwoodShrooms4.mdl" },
    { Name = "mushroom5", file = "Doodads\\Felwood\\Plants\\FelwoodShrooms\\FelwoodShrooms5.mdl" },
    { Name = "mushroom6", file = "Doodads\\Ruins\\Plants\\Ruins_Shroom\\Ruins_Shroom0.mdl" },
    { Name = "mushroom7", file = "Doodads\\Ruins\\Plants\\Ruins_Shroom\\Ruins_Shroom1.mdl" },
    { Name = "mushroom8", file = "Doodads\\Ruins\\Plants\\Ruins_Shroom\\Ruins_Shroom2.mdl" },
    { Name = "mushroom9", file = "Doodads\\Ruins\\Plants\\Ruins_Shroom\\Ruins_Shroom3.mdl" },
    { Name = "mushroom10", file = "Doodads\\Ruins\\Plants\\Ruins_Shroom\\Ruins_Shroom4.mdl" },
    { Name = "mushroom11", file = "Doodads\\Ruins\\Plants\\Ruins_Shroom\\Ruins_Shroom5.mdl" },
    { Name = "flower0", file = "Doodads\\Ruins\\Plants\\Ruins_Flower\\Ruins_Flower0.mdl" }, -- 鲜花
    { Name = "flower1", file = "Doodads\\Ruins\\Plants\\Ruins_Flower\\Ruins_Flower1.mdl" },
    { Name = "flower2", file = "Doodads\\Ruins\\Plants\\Ruins_Flower\\Ruins_Flower2.mdl" },
    { Name = "flower3", file = "Doodads\\Ruins\\Plants\\Ruins_Flower\\Ruins_Flower3.mdl" },
    { Name = "flower4", file = "Doodads\\Ruins\\Plants\\Ruins_Flower\\Ruins_Flower4.mdl" },
    { Name = "typha0", file = "Doodads\\Ruins\\Plants\\Ruins_Rush\\Ruins_Rush0.mdl" }, -- 香蒲
    { Name = "typha1", file = "Doodads\\Ruins\\Plants\\Ruins_Rush\\Ruins_Rush1.mdl" },
    { Name = "lilypad0", file = "Doodads\\LordaeronSummer\\Plants\\LilyPad\\LilyPad0.mdl" }, -- 睡莲
    { Name = "lilypad1", file = "Doodads\\LordaeronSummer\\Plants\\LilyPad\\LilyPad1.mdl" },
    { Name = "lilypad2", file = "Doodads\\LordaeronSummer\\Plants\\LilyPad\\LilyPad2.mdl" },
    { Name = "coral0", file = "Doodads\\Ruins\\Water\\Coral\\Coral0.mdl" }, -- 珊瑚
    { Name = "coral1", file = "Doodads\\Ruins\\Water\\Coral\\Coral1.mdl" },
    { Name = "coral2", file = "Doodads\\Ruins\\Water\\Coral\\Coral2.mdl" },
    { Name = "coral3", file = "Doodads\\Ruins\\Water\\Coral\\Coral3.mdl" },
    { Name = "coral4", file = "Doodads\\Ruins\\Water\\Coral\\Coral4.mdl" },
    { Name = "coral5", file = "Doodads\\Ruins\\Water\\Coral\\Coral5.mdl" },
    { Name = "coral6", file = "Doodads\\Ruins\\Water\\Coral\\Coral6.mdl" },
    { Name = "coral7", file = "Doodads\\Ruins\\Water\\Coral\\Coral7.mdl" },
    { Name = "coral8", file = "Doodads\\Ruins\\Water\\Coral\\Coral8.mdl" },
    { Name = "coral9", file = "Doodads\\Ruins\\Water\\Coral\\Coral9.mdl" },
    { Name = "shells0", file = "Doodads\\Ruins\\Props\\Ruins_Shells\\Ruins_Shells0.mdl" }, -- 贝壳
    { Name = "shells1", file = "Doodads\\Ruins\\Props\\Ruins_Shells\\Ruins_Shells1.mdl" },
    { Name = "shells2", file = "Doodads\\Ruins\\Props\\Ruins_Shells\\Ruins_Shells2.mdl" },
    { Name = "shells3", file = "Doodads\\Ruins\\Props\\Ruins_Shells\\Ruins_Shells3.mdl" },
    { Name = "shells4", file = "Doodads\\Ruins\\Props\\Ruins_Shells\\Ruins_Shells4.mdl" },
    { Name = "shells5", file = "Doodads\\Ruins\\Props\\Ruins_Shells\\Ruins_Shells5.mdl" },
    { Name = "shells6", file = "Doodads\\Ruins\\Props\\Ruins_Shells\\Ruins_Shells6.mdl" },
    { Name = "shells7", file = "Doodads\\Ruins\\Props\\Ruins_Shells\\Ruins_Shells7.mdl" },
    { Name = "shells8", file = "Doodads\\Ruins\\Props\\Ruins_Shells\\Ruins_Shells8.mdl" },
    { Name = "shells9", file = "Doodads\\Ruins\\Props\\Ruins_Shells\\Ruins_Shells9.mdl" },
    { Name = "skull_pile0", file = "Doodads\\LordaeronSummer\\Props\\SkullPile\\SkullPile0.mdl" }, -- 头骨
    { Name = "skull_pile1", file = "Doodads\\LordaeronSummer\\Props\\SkullPile\\SkullPile1.mdl" },
    { Name = "skull_pile2", file = "Doodads\\LordaeronSummer\\Props\\SkullPile\\SkullPile2.mdl" },
    { Name = "skull_pile3", file = "Doodads\\LordaeronSummer\\Props\\SkullPile\\SkullPile3.mdl" },
    { Name = "river_rushes0", file = "Doodads\\LordaeronSummer\\Plants\\RiverRushes\\RiverRushes0.mdl" }, -- 河草
    { Name = "river_rushes1", file = "Doodads\\LordaeronSummer\\Plants\\RiverRushes\\RiverRushes1.mdl" },
    { Name = "river_rushes2", file = "Doodads\\LordaeronSummer\\Plants\\RiverRushes\\RiverRushes2.mdl" },
    { Name = "river_rushes3", file = "Doodads\\LordaeronSummer\\Plants\\RiverRushes\\RiverRushes3.mdl" }
}
local envsLen = 0
for k, v in ipairs(envs) do
    envsLen = envsLen + 1
    obj = slk.unit.nban:new("env_model_" .. v.Name)
    obj.EditorSuffix = "#h-lua"
    obj.Name = "环境系统 " .. v.Name
    obj.tilesets = 1
    obj.special = 1
    obj.hostilePal = 0
    obj.abilList = "Avul,Aloc"
    obj.upgrade = ""
    obj.collision = 20.00 --接触体积
    obj.unitSound = ""
    obj.modelScale = 0.50
    obj.file = v.file
    obj.scale = 0.10
    obj.red = 255
    obj.blue = 255
    obj.green = 255
    obj.unitShadow = ""
    obj.shadowH = 50.00
    obj.shadowW = 50.00
    obj.shadowX = 50.00
    obj.shadowY = 50.00
    obj.Art = ""
    obj.movetp = ""
    obj.spd = 0
    obj.turnRate = 0.1
    obj.weapsOn = 0
    obj.race = "other"
    obj.fused = 0
    obj.sight = 0
    obj.nsight = 0
    obj.hideOnMinimap = 1
    table.insert(
        tempData,
        {
            HLUA_SLK_KEYS.ENV_MODEL_NAME,
            k,
            v.Name,
            "str"
        }
    )
    table.insert(
        tempData,
        {
            HLUA_SLK_KEYS.ENV_MODEL,
            k,
            obj:get_id(),
            "int"
        }
    )
end
table.insert(
    tempData,
    {
        HLUA_SLK_KEYS.COMMON,
        HLUA_SLK_KEYS.ENV_MODEL,
        envsLen,
        "int"
    }
)

-- #变身演示
local re = slkHelper.shapeshift(
    {
        fromUnitId = "Obla", --来自
        toName = "变身演示To",
        toArt = "ReplaceableTextures\\CommandButtons\\BTNChaosBlademaster.blp",
        toFile = "units\\demon\\HeroChaosBladeMaster\\HeroChaosBladeMaster.mdl"
    }
)
table.insert(
    tempData,
    {
        HLUA_SLK_KEYS.EX_SHAPESHIFT,
        1,
        re.toUnitId,
        "int"
    }
)
table.insert(
    tempData,
    {
        HLUA_SLK_KEYS.EX_SHAPESHIFT,
        2,
        re.toAbilityId,
        "int"
    }
)
table.insert(
    tempData,
    {
        HLUA_SLK_KEYS.EX_SHAPESHIFT,
        3,
        re.backAbilityId,
        "int"
    }
)
