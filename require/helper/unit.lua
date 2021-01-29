---@private 信使技能缓存
slkHelper.courierBlink = nil
slkHelper.courierRangePickUp = nil
slkHelper.courierSeparate = nil
slkHelper.courierDeliver = nil

--- 获取自动配置的信使技能
slkHelper.courierAutoSkill = function()
    if (slkHelper.courierBlink == nil) then
        local Name = "信使-闪烁"
        local obj = slk.ability.AEbl:new("slk_courier_blink")
        local Tip = Name .. "(" .. hColor.mixed(slkHelper.conf.courierSkill.blink.Hotkey, slkHelper.conf.color.hotKey) .. ")"
        obj.Name = Name
        obj.Tip = Tip
        obj.Hotkey = slkHelper.conf.courierSkill.blink.Hotkey
        obj.Ubertip = slkHelper.conf.courierSkill.blink.Ubertip
        obj.Buttonpos1 = slkHelper.conf.courierSkill.blink.Buttonpos1
        obj.Buttonpos2 = slkHelper.conf.courierSkill.blink.Buttonpos2
        obj.hero = 0
        obj.levels = 1
        obj.DataA1 = 99999
        obj.DataB1 = 0
        obj.Cool1 = slkHelper.conf.courierSkill.blink.Cool1
        obj.Cost1 = 0
        obj.Art = slkHelper.conf.courierSkill.blink.Art
        obj.SpecialArt = "Abilities\\Spells\\NightElf\\Blink\\BlinkCaster.mdl"
        obj.Areaeffectart = "Abilities\\Spells\\NightElf\\Blink\\BlinkTarget.mdl"
        obj.race = "other"
        slkHelper.courierBlink = obj:get_id()
        table.insert(slkHelperHashData, {
            _class = "ability",
            _id = slkHelper.courierBlink,
            _name = Name,
            _type = "courier",
        })
    end
    if (slkHelper.courierRangePickUp == nil) then
        local Name = "信使-拾取"
        local obj = slk.ability.ANcl:new("slk_courier_range_pickup")
        local Tip = Name .. "(" .. hColor.mixed(slkHelper.conf.courierSkill.rangePickUp.Hotkey, slkHelper.conf.color.hotKey) .. ")"
        obj.Order = "manaburn"
        obj.DataF1 = "manaburn"
        obj.Name = Name
        obj.Tip = Tip
        obj.Hotkey = slkHelper.conf.courierSkill.rangePickUp.Hotkey
        obj.Ubertip = slkHelper.conf.courierSkill.rangePickUp.Ubertip
        obj.Buttonpos1 = slkHelper.conf.courierSkill.rangePickUp.Buttonpos1
        obj.Buttonpos2 = slkHelper.conf.courierSkill.rangePickUp.Buttonpos2
        obj.hero = 0
        obj.levels = 1
        obj.DataA1 = 0
        obj.DataB1 = 0
        obj.DataC1 = 1
        obj.DataD1 = 0.01
        obj.Cool1 = slkHelper.conf.courierSkill.rangePickUp.Cool1
        obj.Cost1 = 0
        obj.Art = slkHelper.conf.courierSkill.rangePickUp.Art
        obj.CasterArt = ""
        obj.EffectArt = ""
        obj.TargetArt = ""
        obj.race = "other"
        slkHelper.courierRangePickUp = obj:get_id()
        table.insert(slkHelperHashData, {
            _class = "ability",
            _id = slkHelper.courierRangePickUp,
            _name = Name,
            _type = "courier",
        })
    end
    if (slkHelper.courierSeparate == nil) then
        local Name = "信使-拆分物品"
        local Tip = Name .. "(" .. hColor.mixed(slkHelper.conf.courierSkill.separate.Hotkey, slkHelper.conf.color.hotKey) .. ")"
        local obj = slk.ability.ANtm:new("slk_courier_separate")
        obj.Name = Name
        obj.DataD1 = 0
        obj.DataA1 = 0
        obj.Tip = Tip
        obj.Ubertip = slkHelper.conf.courierSkill.separate.Ubertip
        obj.Art = slkHelper.conf.courierSkill.separate.Art
        obj.Hotkey = slkHelper.conf.courierSkill.separate.Hotkey
        obj.Buttonpos1 = slkHelper.conf.courierSkill.separate.Buttonpos1
        obj.Buttonpos2 = slkHelper.conf.courierSkill.separate.Buttonpos2
        obj.Missileart = ""
        obj.Missilespeed = 99999
        obj.Missilearc = 0.00
        obj.Animnames = ""
        obj.hero = 0
        obj.race = "other"
        obj.BuffID = ""
        obj.Cool1 = slkHelper.conf.courierSkill.separate.Cool1
        obj.targs1 = "item,nonhero"
        obj.Cost1 = 0
        obj.Rng1 = 200.00
        slkHelper.courierSeparate = obj:get_id()
        table.insert(slkHelperHashData, {
            _class = "ability",
            _id = slkHelper.courierSeparate,
            _name = Name,
            _type = "courier",
        })
    end
    if (slkHelper.courierDeliver == nil) then
        local Name = "信使-传递"
        local obj = slk.ability.ANcl:new("slk_courier_deliver")
        local Tip = Name .. "(" .. hColor.mixed(slkHelper.conf.courierSkill.deliver.Hotkey, slkHelper.conf.color.hotKey) .. ")"
        obj.Order = "polymorph"
        obj.DataF1 = "polymorph"
        obj.Name = Name
        obj.Tip = Tip
        obj.Hotkey = slkHelper.conf.courierSkill.deliver.Hotkey
        obj.Ubertip = slkHelper.conf.courierSkill.deliver.Ubertip
        obj.Buttonpos1 = slkHelper.conf.courierSkill.deliver.Buttonpos1
        obj.Buttonpos2 = slkHelper.conf.courierSkill.deliver.Buttonpos2
        obj.hero = 0
        obj.levels = 1
        obj.DataA1 = 0
        obj.DataB1 = 0
        obj.DataC1 = 1
        obj.DataD1 = 0.01
        obj.Cool1 = slkHelper.conf.courierSkill.deliver.Cool1
        obj.Cost1 = 0
        obj.Art = slkHelper.conf.courierSkill.deliver.Art
        obj.CasterArt = ""
        obj.EffectArt = ""
        obj.TargetArt = ""
        obj.race = "other"
        slkHelper.courierDeliver = obj:get_id()
        table.insert(slkHelperHashData, {
            _class = "ability",
            _id = slkHelper.courierDeliver,
            _name = Name,
            _type = "courier",
        })
    end
    return {
        slkHelper.courierBlink, slkHelper.courierRangePickUp,
        slkHelper.courierSeparate, slkHelper.courierDeliver
    }
end

slkHelper.unit = {
    --- 创建一个单位
    --- 设置的_hslk数据会自动传到数据中
    ---@public
    ---@param v table
    normal = function(v)
        slkHelper.count = slkHelper.count + 1
        v.Name = v.Name or "单位-" .. slkHelper.count
        local Ubertip = v.Ubertip or ""
        local targs1 = v.targs1 or "vulnerable,ground,ward,structure,organic,mechanical,debris,air" --攻击目标
        local abl = {}
        if (type(v.abilList) == "string") then
            abl = string.explode(',', v.abilList)
        elseif (type(v.abilList) == "table") then
            for _, t in pairs(v.abilList) do
                table.insert(abl, t)
            end
        end
        v.weapTp1 = v.weapTp1 or "normal"
        v.goldcost = v.goldcost or 0
        v.lumbercost = v.lumbercost or 0
        v.rangeN1 = v.rangeN1 or 100
        v.sight = v.sight or slkHelper.conf.unitSight
        v.nsight = v.nsight or slkHelper.conf.unitNSight
        local acquire = v.acquire or (v.rangeN1 + 100) -- 警戒范围
        if (acquire < (v.rangeN1 + 100)) then
            acquire = v.rangeN1 + 100
        end
        --
        local obj = slk.unit.ogru:new("slk_units_" .. v.Name)
        if (v.Hotkey ~= nil) then
            obj.Hotkey = v.Hotkey
            v.Buttonpos1 = CONST_HOTKEY_FULL_KV[v.Hotkey].Buttonpos1 or 0
            v.Buttonpos2 = CONST_HOTKEY_FULL_KV[v.Hotkey].Buttonpos2 or 0
            obj.Tip = "选择：" .. v.Name .. "(" .. hColor.mixed(v.Hotkey, slkHelper.conf.color.hotKey) .. ")"
        else
            obj.Buttonpos1 = v.Buttonpos1 or 0
            obj.Buttonpos2 = v.Buttonpos2 or 0
            obj.Tip = "选择：" .. v.Name
        end
        obj.Ubertip = Ubertip
        obj.tilesets = "*"
        obj.hostilePal = 0
        obj.Requires = "" --需求,全部无限制，用代码限制
        obj.Requirescount = 1
        obj.Requires1 = ""
        obj.Requires2 = ""
        obj.upgrade = ""
        obj.unitShadow = "ShadowFlyer"
        obj.death = v.death or 1.75
        obj.turnRate = 1.00
        obj.acquire = acquire
        obj.race = v.race or "other"
        obj.deathType = v.deathType or 2
        obj.fused = 0
        obj.sides1 = v.sides1 or 5 --骰子面
        obj.dice1 = v.dice1 or 1 --骰子数量
        obj.regenMana = v.regenMana or 0.00
        obj.regenHP = v.regenHP or 0.00
        obj.regenType = v.regenType or 'none'
        obj.stockStart = v.stockStart or 0 -- 库存开始
        obj.stockRegen = v.stockRegen or 0 -- 进货周期
        obj.stockMax = v.stockMax or 1 -- 最大库存
        obj.collision = v.collision or 32 --接触体积
        obj.def = v.def or 0.00 -- 护甲
        obj.sight = v.sight -- 白天视野
        obj.nsight = v.nsight -- 夜晚视野
        obj.targs1 = targs1
        obj.EditorSuffix = v.EditorSuffix or ""
        obj.abilList = string.implode(",", abl)
        if (v.weapTp1 == "normal") then
            obj.weapType1 = v.weapType1 or "" --攻击声音
            obj.Missileart = ""
            obj.Missilespeed = 0
            obj.Missilearc = 0
        else
            obj.weapType1 = "" --攻击声音
            obj.Missileart = v.Missileart -- 箭矢模型
            obj.Missilespeed = v.Missilespeed or 900 -- 箭矢速度
            obj.Missilearc = v.Missilearc or 0.10
        end
        if (v.weapTp1 == "msplash" or v.weapTp1 == "artillery") then
            --溅射/炮火
            obj.Farea1 = v.Farea1 or 1
            obj.Qfact1 = v.Qfact1 or 0.05
            obj.Qarea1 = v.Qarea1 or 500
            obj.Hfact1 = v.Hfact1 or 0.15
            obj.Harea1 = v.Harea1 or 350
            obj.splashTargs1 = targs1 .. ",enemies"
        elseif (v.weapTp1 == "mbounce") then
            --弹射
            obj.Farea1 = v.Farea1 or 450
            obj.targCount1 = v.targCount1 or 4
            obj.damageLoss1 = v.damageLoss1 or 0.3
            obj.splashTargs1 = targs1 .. ",enemies"
        elseif (v.weapTp1 == "mline") then
            --穿透
            obj.spillRadius = v.spillRadius or 200
            obj.spillDist1 = v.spillDist1 or 450
            obj.damageLoss1 = v.damageLoss1 or 0.3
            obj.splashTargs1 = targs1 .. ",enemies"
        elseif (v.weapTp1 == "aline") then
            --炮火穿透
            obj.Farea1 = v.Farea1 or 1
            obj.Qfact1 = v.Qfact1 or 0.05
            obj.Qarea1 = v.Qarea1 or 500
            obj.Hfact1 = v.Hfact1 or 0.15
            obj.Harea1 = v.Harea1 or 350
            obj.spillRadius = v.spillRadius or 200
            obj.spillDist1 = v.spillDist1 or 450
            obj.damageLoss1 = v.damageLoss1 or 0.3
            obj.splashTargs1 = targs1 .. ",enemies"
        end
        obj.Name = v.Name
        obj.unitSound = v.unitSound or "" -- 声音
        obj.modelScale = v.modelScale or 1.00 --模型缩放
        obj.file = v.file --模型
        obj.fileVerFlags = v.fileVerFlags or 0
        obj.Art = v.Art --头像
        obj.scale = v.scale or 1.00 --选择圈
        obj.movetp = v.movetp or "foot" --移动类型
        obj.moveHeight = v.moveHeight or 0 --移动高度
        obj.moveFloor = math.floor((v.moveHeight or 0) * 0.25) --最低高度
        obj.spd = v.spd or 270
        obj.backSw1 = v.backSw1 or 0.500
        obj.dmgpt1 = v.dmgpt1 or 0.500
        obj.rangeN1 = v.rangeN1 or 100
        obj.cool1 = v.cool1 or 2.00
        obj.armor = v.armor or "Flesh" -- 被击声音
        obj.targType = v.targType or "ground" --作为目标类型
        obj.weapTp1 = v.weapTp1 --攻击类型
        obj.dmgplus1 = v.dmgplus1 or 1 -- 基础攻击
        obj.showUI1 = v.showUI1 or 1 -- 显示攻击按钮
        obj.goldcost = v.goldcost
        obj.lumbercost = v.lumbercost
        obj.HP = v.HP or 100
        obj.mana0 = v.mana0 or 0
        obj.weapsOn = v.weapsOn or 0
        obj.Sellitems = v.Sellitems or ""
        local id = obj:get_id()
        table.insert(slkHelperHashData, table.merge_pairs({
            _class = "unit",
            _id = id,
            _name = v.Name,
            _type = "normal",
        }, (v._hslk or {})))
        return id
    end,
    --- 创建一个英雄
    --- 设置的_hslk数据会自动传到数据中
    ---@public
    ---@param v table
    hero = function(v)
        slkHelper.count = slkHelper.count + 1
        v.Name = v.Name or "英雄-" .. slkHelper.count
        local Primary = v.Primary or "STR"
        local Ubertip = ""
        Ubertip = Ubertip .. hColor.mixed("攻击类型：" .. CONST_WEAPON_TYPE[v.weapTp1].label .. "(" .. v.cool1 .. "秒/击)", slkHelper.conf.color.heroWeapon)
        Ubertip = Ubertip .. "|n" .. hColor.mixed("基础攻击：" .. v.dmgplus1, slkHelper.conf.color.heroAttack)
        Ubertip = Ubertip .. "|n" .. hColor.mixed("攻击范围：" .. v.rangeN1, slkHelper.conf.color.heroRange)
        if (Primary == "STR") then
            Ubertip = Ubertip .. "|n" .. hColor.mixed("力量：" .. v.STR .. "(+" .. v.STRplus .. ")", slkHelper.conf.color.heroPrimary)
        else
            Ubertip = Ubertip .. "|n" .. hColor.mixed("力量：" .. v.STR .. "(+" .. v.STRplus .. ")", slkHelper.conf.color.heroSecondary)
        end
        if (Primary == "AGI") then
            Ubertip = Ubertip .. "|n" .. hColor.mixed("敏捷：" .. v.AGI .. "(+" .. v.AGIplus .. ")", slkHelper.conf.color.heroPrimary)
        else
            Ubertip = Ubertip .. "|n" .. hColor.mixed("敏捷：" .. v.AGI .. "(+" .. v.AGIplus .. ")", slkHelper.conf.color.heroSecondary)
        end
        if (Primary == "INT") then
            Ubertip = Ubertip .. "|n" .. hColor.mixed("智力：" .. v.INT .. "(+" .. v.INTplus .. ")", slkHelper.conf.color.heroPrimary)
        else
            Ubertip = Ubertip .. "|n" .. hColor.mixed("智力：" .. v.INT .. "(+" .. v.INTplus .. ")", slkHelper.conf.color.heroSecondary)
        end
        Ubertip = Ubertip .. "|n" .. hColor.mixed("移动：" .. v.spd .. " " .. CONST_MOVE_TYPE[v.movetp].label, slkHelper.conf.color.heroMove)
        if (v.Ubertip ~= nil) then
            Ubertip = Ubertip .. "|n|n" .. v.Ubertip -- 自定义说明会在最后
        end
        local targs1 = v.targs1 or "vulnerable,ground,ward,structure,organic,mechanical,tree,debris,air" --攻击目标
        local Propernames = v.Propernames or v.Name
        local PropernamesArr = string.explode(',', Propernames)
        local abl = {}
        if (type(v.abilList) == "string") then
            abl = string.explode(',', v.abilList)
        elseif (type(v.abilList) == "table") then
            for _, t in pairs(v.abilList) do
                table.insert(abl, t)
            end
        end
        table.insert(abl, "AInv")
        v.weapTp1 = v.weapTp1 or "normal"
        v.goldcost = v.goldcost or 0
        v.lumbercost = v.lumbercost or 0
        v.cool1 = v.cool1 or 1.50
        v.rangeN1 = v.rangeN1 or 100
        v.sight = v.sight or slkHelper.conf.heroSight
        v.nsight = v.nsight or slkHelper.conf.heroNSight
        local acquire = v.acquire or v.rangeN1 -- 警戒范围
        if (acquire < 1000) then
            acquire = 1000
        end
        --
        local obj = slk.unit.Hpal:new("slk_hero_" .. v.Name)
        if (v.Hotkey ~= nil) then
            obj.Hotkey = v.Hotkey
            v.Buttonpos1 = CONST_HOTKEY_FULL_KV[v.Hotkey].Buttonpos1 or 0
            v.Buttonpos2 = CONST_HOTKEY_FULL_KV[v.Hotkey].Buttonpos2 or 0
            obj.Tip = "选择：" .. v.Name .. "(" .. hColor.mixed(v.Hotkey, slkHelper.conf.color.hotKey) .. ")"
        else
            obj.Buttonpos1 = v.Buttonpos1 or 0
            obj.Buttonpos2 = v.Buttonpos2 or 0
            obj.Tip = "选择：" .. v.Name
        end
        obj.Primary = Primary
        obj.Ubertip = Ubertip
        obj.tilesets = "*"
        obj.hostilePal = 0
        obj.Requires = "" --需求,全部无限制，用代码限制
        obj.Requirescount = 1
        obj.Requires1 = ""
        obj.Requires2 = ""
        obj.upgrade = ""
        obj.unitShadow = "ShadowFlyer"
        obj.death = v.death or 1.75
        obj.turnRate = 1.00
        obj.acquire = acquire
        obj.weapsOn = 1
        obj.race = v.race or "other"
        obj.deathType = v.deathType or 2
        obj.fused = 0
        obj.sides1 = v.sides1 or 3 --骰子面
        obj.dice1 = v.dice1 or 2 --骰子数量
        obj.regenMana = v.regenMana or 0.00
        obj.regenHP = v.regenHP or 0.00
        obj.stockStart = v.stockStart or 0 -- 库存开始
        obj.stockRegen = v.stockRegen or 0 -- 进货周期
        obj.stockMax = v.stockMax or 1 -- 最大库存
        obj.collision = v.collision or 32 --接触体积
        obj.propWin = v.propWin or 60 --转向角度
        obj.sight = v.sight -- 白天视野
        obj.nsight = v.nsight -- 夜晚视野
        obj.targs1 = targs1
        obj.EditorSuffix = v.EditorSuffix or ""
        obj.Propernames = Propernames
        obj.abilList = string.implode(",", abl)
        obj.heroAbilList = v.heroAbilList or ""
        obj.nameCount = v.nameCount or #PropernamesArr
        if (v.weapTp1 == "normal") then
            obj.weapType1 = v.weapType1 or "" --攻击声音
            obj.Missileart = ""
            obj.Missilespeed = 0
            obj.Missilearc = 0
        else
            obj.weapType1 = "" --攻击声音
            obj.Missileart = v.Missileart -- 箭矢模型
            obj.Missilespeed = v.Missilespeed or 1100 -- 箭矢速度
            obj.Missilearc = v.Missilearc or 0.05
        end
        if (v.weapTp1 == "msplash" or v.weapTp1 == "artillery") then
            --溅射/炮火
            obj.Farea1 = v.Farea1 or 1
            obj.Qfact1 = v.Qfact1 or 0.05
            obj.Qarea1 = v.Qarea1 or 500
            obj.Hfact1 = v.Hfact1 or 0.15
            obj.Harea1 = v.Harea1 or 350
            obj.splashTargs1 = targs1 .. ",enemies"
        elseif (v.weapTp1 == "mbounce") then
            --弹射
            obj.Farea1 = v.Farea1 or 450
            obj.targCount1 = v.targCount1 or 4
            obj.damageLoss1 = v.damageLoss1 or 0.3
            obj.splashTargs1 = targs1 .. ",enemies"
        elseif (v.weapTp1 == "mline") then
            --穿透
            obj.spillRadius = v.spillRadius or 200
            obj.spillDist1 = v.spillDist1 or 450
            obj.damageLoss1 = v.damageLoss1 or 0.3
            obj.splashTargs1 = targs1 .. ",enemies"
        elseif (v.weapTp1 == "aline") then
            --炮火穿透
            obj.Farea1 = v.Farea1 or 1
            obj.Qfact1 = v.Qfact1 or 0.05
            obj.Qarea1 = v.Qarea1 or 500
            obj.Hfact1 = v.Hfact1 or 0.15
            obj.Harea1 = v.Harea1 or 350
            obj.spillRadius = v.spillRadius or 200
            obj.spillDist1 = v.spillDist1 or 450
            obj.damageLoss1 = v.damageLoss1 or 0.3
            obj.splashTargs1 = targs1 .. ",enemies"
        end
        obj.Name = v.Name
        obj.Awakentip = "唤醒：" .. v.Name
        obj.Revivetip = "复活：" .. v.Name
        obj.unitSound = v.unitSound or "" -- 声音
        obj.modelScale = v.modelScale or 1.00 --模型缩放
        obj.file = v.file --模型
        obj.fileVerFlags = v.fileVerFlags or 0
        obj.Art = v.Art --头像
        obj.scale = v.scale or 1.00 --选择圈
        obj.movetp = v.movetp or "foot" --移动类型
        obj.moveHeight = v.moveHeight or 0 --移动高度
        obj.moveFloor = math.floor((v.moveHeight or 0) * 0.25) --最低高度
        obj.spd = v.spd or 270
        obj.backSw1 = v.backSw1 or 0.500
        obj.dmgpt1 = v.dmgpt1 or 0.500
        obj.rangeN1 = v.rangeN1
        obj.cool1 = v.cool1
        obj.def = v.def or 0.00 -- 护甲
        obj.armor = v.armor or "Flesh" -- 被击声音
        obj.targType = v.targType or "ground" --作为目标类型
        obj.weapTp1 = v.weapTp1 --攻击类型
        obj.dmgplus1 = v.dmgplus1 or 1 -- 基础攻击
        obj.showUI1 = v.showUI1 or 1 -- 显示攻击按钮
        obj.hideHeroMinimap = v.hideHeroMinimap or 0 -- 隐藏英雄小地图
        obj.hideHeroBar = v.hideHeroBar or 0  -- 隐藏英雄栏图标
        obj.hideHeroDeathMsg = v.hideHeroDeathMsg or 0 -- 隐藏英雄栏死亡信息
        obj.STR = v.STR
        obj.AGI = v.AGI
        obj.INT = v.INT
        obj.STRplus = v.STRplus
        obj.AGIplus = v.AGIplus
        obj.INTplus = v.INTplus
        obj.goldcost = v.goldcost
        obj.lumbercost = v.lumbercost
        local id = obj:get_id()
        table.insert(slkHelperHashData, table.merge_pairs({
            _class = "unit",
            _id = id,
            _name = v.Name,
            _type = "hero",
        }, (v._hslk or {})))
        return id
    end,
    --- 创建一个商店
    --- 设置的_hslk数据会自动传到数据中
    ---@public
    ---@param v table
    shop = function(v)
        slkHelper.count = slkHelper.count + 1
        v.Name = v.Name or "商店-" .. slkHelper.count
        v.Makeitems = v.Makeitems or ""
        v.Sellitems = v.Sellitems or ""
        local obj = slk.unit.ngme:new("slk_shop_" .. v.Name)
        obj.Name = v.Name
        obj.pathTex = v.pathTex or "PathTextures\\8x8Round.tga"
        obj.abilList = v.abilList or "Avul,Apit,Aall"
        obj.file = v.file or "buildings\\other\\FruitStand\\FruitStand"
        obj.Art = v.Art or "ReplaceableTextures\\CommandButtons\\BTNMerchant.blp"
        obj.modelScale = v.modelScale or 1.00
        obj.scale = v.scale or 1.00
        obj.HP = v.HP or 99999
        obj.sight = v.sight or slkHelper.conf.shopSight
        obj.nsight = v.nsight or slkHelper.conf.shopNSight
        obj.unitSound = v.unitSound or ""
        obj.unitShadow = ""
        obj.buildingShadow = v.buildingShadow or ""
        obj.Makeitems = v.Makeitems
        obj.Sellitems = v.Sellitems
        obj.UberSplat = v.UberSplat or ""
        obj.collision = v.collision or 50 --接触体积
        obj.race = v.race or "other"
        local id = obj:get_id()
        table.insert(slkHelperHashData, table.merge_pairs({
            _class = "unit",
            _id = id,
            _name = v.Name,
            _type = "shop",
        }, (v._hslk or {})))
        return id
    end,
    --- 创建一个信使
    --- 设置的_hslk数据会自动传到数据中
    ---@public
    ---@param v table
    courier = function(v)
        local _auto_skill = false
        if (type(v._auto_skill) == 'boolean') then
            _auto_skill = v._auto_skill
        end
        slkHelper.count = slkHelper.count + 1
        local Primary
        local Ubertip
        local obj
        local Name = v.Name or "信使-" .. slkHelper.count
        local Tip
        v.weapsOn = v.weapsOn or 0
        v.goldcost = v.goldcost or 0
        v.lumbercost = v.lumbercost or 0
        v.cool1 = v.cool1 or 1.50
        v.rangeN1 = v.rangeN1 or 100
        v.sight = v.sight or slkHelper.conf.unitSight
        v.nsight = v.nsight or slkHelper.conf.unitNSight
        v.dmgplus1 = v.dmgplus1 or 0
        v.movetp = v.movetp or "foot"
        v.moveHeight = v.moveHeight or 0
        v.spd = v.spd or 100
        local abl = { "AInv" }
        if (_auto_skill == true) then
            abl = table.merge(abl, slkHelper.courierAutoSkill())
        end
        if (type(v.abilList) == "string") then
            local tmpAbl = string.explode(',', v.abilList)
            for _, t in pairs(tmpAbl) do
                table.insert(abl, t)
            end
        elseif (type(v.abilList) == "table") then
            for _, t in pairs(v.abilList) do
                table.insert(abl, t)
            end
        end
        if (v.Hotkey ~= nil) then
            v.Buttonpos1 = CONST_HOTKEY_FULL_KV[v.Hotkey].Buttonpos1 or 0
            v.Buttonpos2 = CONST_HOTKEY_FULL_KV[v.Hotkey].Buttonpos2 or 0
            Tip = "选择：" .. Name .. "(" .. hColor.mixed(v.Hotkey, slkHelper.conf.color.hotKey) .. ")"
        else
            v.Buttonpos1 = v.Buttonpos1 or 0
            v.Buttonpos2 = v.Buttonpos2 or 0
            Tip = "选择：" .. Name
        end
        local _type = "courier"
        if (v.isHero == 1) then
            _type = "courier_hero"
            --- 如果是英雄型信使
            Primary = v.Primary or "STR"
            Ubertip = hColor.mixed("移动：" .. v.spd .. " " .. CONST_MOVE_TYPE[v.movetp].label, slkHelper.conf.color.heroMove)
            if (v.weapsOn == 1) then
                Ubertip = Ubertip .. "|n" .. hColor.mixed("攻击类型：" .. CONST_WEAPON_TYPE[v.weapTp1].label .. "(" .. v.cool1 .. "秒/击)", slkHelper.conf.color.heroWeapon)
                Ubertip = Ubertip .. "|n" .. hColor.mixed("基础攻击：" .. v.dmgplus1, slkHelper.conf.color.heroAttack)
                Ubertip = Ubertip .. "|n" .. hColor.mixed("攻击范围：" .. v.rangeN1, slkHelper.conf.color.heroRange)
                if (Primary == "STR") then
                    Ubertip = Ubertip .. "|n" .. hColor.mixed("力量：" .. v.STR .. "(+" .. v.STRplus .. ")", slkHelper.conf.color.heroPrimary)
                else
                    Ubertip = Ubertip .. "|n" .. hColor.mixed("力量：" .. v.STR .. "(+" .. v.STRplus .. ")", slkHelper.conf.color.heroSecondary)
                end
                if (Primary == "AGI") then
                    Ubertip = Ubertip .. "|n" .. hColor.mixed("敏捷：" .. v.AGI .. "(+" .. v.AGIplus .. ")", slkHelper.conf.color.heroPrimary)
                else
                    Ubertip = Ubertip .. "|n" .. hColor.mixed("敏捷：" .. v.AGI .. "(+" .. v.AGIplus .. ")", slkHelper.conf.color.heroSecondary)
                end
                if (Primary == "INT") then
                    Ubertip = Ubertip .. "|n" .. hColor.mixed("智力：" .. v.INT .. "(+" .. v.INTplus .. ")", slkHelper.conf.color.heroPrimary)
                else
                    Ubertip = Ubertip .. "|n" .. hColor.mixed("智力：" .. v.INT .. "(+" .. v.INTplus .. ")", slkHelper.conf.color.heroSecondary)
                end
            end
            if (v.Ubertip ~= nil) then
                Ubertip = Ubertip .. "|n|n" .. v.Ubertip -- 自定义说明会在最后
            end
            obj = slk.unit.Hpal:new("slk_courier_hero_" .. Name)
            obj.Primary = Primary
            obj.STR = v.STR
            obj.AGI = v.AGI
            obj.INT = v.INT
            obj.STRplus = v.STRplus
            obj.AGIplus = v.AGIplus
            obj.INTplus = v.INTplus
            obj.Awakentip = "唤醒：" .. Name
            obj.Revivetip = "复活：" .. Name
            obj.hideHeroMinimap = v.hideHeroMinimap or 1 -- 隐藏英雄小地图
            obj.hideHeroBar = v.hideHeroBar or 1  -- 隐藏英雄栏图标
            obj.hideHeroDeathMsg = v.hideHeroDeathMsg or 1 -- 隐藏英雄栏死亡信息
        else
            --- 如果是工人型信使
            obj = slk.unit.ogru:new("slk_courier_" .. Name)
            obj.type = "Peon"
            Ubertip = v.Ubertip or ""
        end
        local targs1
        if (v.weapsOn == 1) then
            v.weapTp1 = v.weapTp1 or "normal"
            obj.weapTp1 = v.weapTp1
            obj.cool1 = v.cool1
            obj.rangeN1 = v.rangeN1
            obj.dmgplus1 = v.dmgplus1 or 0 -- 攻击1
            targs1 = v.targs1 or "vulnerable,ground,ward,structure,organic,mechanical,debris,air"
            if (v.weapTp1 == "normal") then
                obj.weapType1 = v.weapType1 or "" --攻击声音
                obj.Missileart = ""
                obj.Missilespeed = 0
                obj.Missilearc = 0
            else
                obj.weapType1 = "" --攻击声音
                obj.Missileart = v.Missileart -- 箭矢模型
                obj.Missilespeed = v.Missilespeed or 1100 -- 箭矢速度
                obj.Missilearc = v.Missilearc or 0.05
            end
            if (v.weapTp1 == "msplash" or v.weapTp1 == "artillery") then
                --溅射/炮火
                obj.Farea1 = v.Farea1 or 1
                obj.Qfact1 = v.Qfact1 or 0.05
                obj.Qarea1 = v.Qarea1 or 500
                obj.Hfact1 = v.Hfact1 or 0.15
                obj.Harea1 = v.Harea1 or 350
                obj.splashTargs1 = targs1 .. ",enemies"
            elseif (v.weapTp1 == "mbounce") then
                --弹射
                obj.Farea1 = v.Farea1 or 450
                obj.targCount1 = v.targCount1 or 4
                obj.damageLoss1 = v.damageLoss1 or 0.3
                obj.splashTargs1 = targs1 .. ",enemies"
            elseif (v.weapTp1 == "mline") then
                --穿透
                obj.spillRadius = v.spillRadius or 200
                obj.spillDist1 = v.spillDist1 or 450
                obj.damageLoss1 = v.damageLoss1 or 0.3
                obj.splashTargs1 = targs1 .. ",enemies"
            elseif (v.weapTp1 == "aline") then
                --炮火穿透
                obj.Farea1 = v.Farea1 or 1
                obj.Qfact1 = v.Qfact1 or 0.05
                obj.Qarea1 = v.Qarea1 or 500
                obj.Hfact1 = v.Hfact1 or 0.15
                obj.Harea1 = v.Harea1 or 350
                obj.spillRadius = v.spillRadius or 200
                obj.spillDist1 = v.spillDist1 or 450
                obj.damageLoss1 = v.damageLoss1 or 0.3
                obj.splashTargs1 = targs1 .. ",enemies"
            end
        else
            targs1 = ""
        end
        obj.Name = Name
        obj.Tip = Tip
        obj.targs1 = targs1
        obj.Ubertip = Ubertip
        obj.upgrades = ""
        obj.weapsOn = v.weapsOn
        obj.Hotkey = ""
        obj.tilesets = "*"
        obj.hostilePal = 0
        obj.Requires = "" --需求,全部无限制，用代码限制
        obj.Requirescount = 1
        obj.Requires1 = ""
        obj.Requires2 = ""
        obj.upgrade = ""
        obj.unitShadow = "ShadowFlyer"
        obj.Buttonpos1 = 0
        obj.Buttonpos2 = 0
        obj.death = v.death or 1.75
        obj.turnRate = 1.00
        obj.acquire = 1000.00
        obj.race = v.race or "other"
        obj.deathType = v.deathType or 2
        obj.fused = 0
        obj.sides1 = 5 --骰子面
        obj.dice1 = 1 --骰子数量
        obj.regenMana = 0.00
        obj.HP = v.HP or 100
        obj.regenHP = v.regenHP or 0
        obj.regenType = v.regenType or 'none'
        obj.goldcost = v.goldcost
        obj.lumbercost = v.lumbercost
        obj.stockStart = 0
        obj.stockRegen = 0
        obj.stockMax = 1
        obj.collision = v.collision or 0 --接触体积
        obj.def = v.def or 0.00 -- 护甲
        obj.sight = v.sight -- 白天视野
        obj.nsight = v.nsight -- 夜晚视野
        obj.unitSound = v.unitSound -- 声音
        obj.modelScale = v.modelScale --模型缩放
        obj.file = v.file --模型
        obj.Art = v.Art --头像
        obj.scale = v.scale --选择圈
        obj.movetp = v.movetp --移动类型
        obj.moveHeight = v.moveHeight --移动高度
        obj.moveFloor = v.moveHeight * 0.25 --最低高度
        obj.spd = v.spd or 522
        obj.armor = v.armor -- 被击声音
        obj.targType = v.targType --作为目标类型
        obj.upgrades = ""
        obj.Builds = ""
        obj.fused = 0
        obj.abilList = string.implode(',', abl)
        obj.Propernames = "信使"
        obj.nameCount = 1
        obj.heroAbilList = v.heroAbilList or ""
        local id = obj:get_id()
        table.insert(slkHelperHashData, table.merge_pairs({
            _class = "unit",
            _id = id,
            _name = v.Name,
            _type = _type,
            _auto_skill = _auto_skill
        }, (v._hslk or {})))
        return id
    end,
    --- 创建一个酒馆模版
    --- 设置的_hslk数据会自动传到数据中
    ---@public
    ---@param v table
    tavern = function(v)
        slkHelper.count = slkHelper.count + 1
        v.Name = v.Name or "酒馆-" .. slkHelper.count
        v.Sellunits = v.Sellunits or ""
        local obj = slk.unit.ntav:new("slk_tavern_" .. v.Name)
        obj.Name = v.Name
        obj.pathTex = v.pathTex or "PathTextures\\8x8Round.tga"
        obj.Art = v.Art or nil
        obj.file = v.file or "buildings\\other\\FruitStand\\FruitStand"
        obj.EditorSuffix = ""
        obj.abilList = v.abilList or "Avul,Asud," .. TAVERN_SELECTION_OBJ_ID
        obj.Sellunits = ""
        obj.collision = ""
        obj.modelScale = v.modelScale or 1.00
        obj.scale = v.scale or 1.00
        obj.HP = v.HP or 99999
        obj.sight = v.sight or slkHelper.conf.shopSight
        obj.nsight = v.nsight or slkHelper.conf.shopNSight
        obj.unitSound = v.unitSound or ""
        obj.uberSplat = ""
        obj.teamColor = 12
        obj.race = v.race or "other"
        local id = obj:get_id()
        table.insert(slkHelperHashData, table.merge_pairs({
            _class = "unit",
            _id = id,
            _name = v.Name,
            _type = "tavern",
        }, (v._hslk or {})))
        return id
    end,
}
