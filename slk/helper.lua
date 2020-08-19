--- 四舍五入
---@param decimal number
---@return number
math.round = function(decimal)
    if (decimal == nil) then
        return 0.00
    end
    return math.floor((decimal * 100) + 0.5) * 0.01
end

--- slk hash data
slkHelperHashData = {}

slkHelper = {
    ---@private
    count = 0,
    ---@private
    shapeshiftIndex = 1,
    ---@private
    courierBlink = nil,
    ---@private
    courierPickUp = nil,
}

--[[
    构建变身slk
    options = {
        fromUnitId = "name", --from单位ID
        toName = "name", --to单位名称
        toArt = "art", --to单位图标
        toFire = "fire", --to单位模型路径
    }
    return {
        fromUnitId,
        toUnitId,
        toAbilityId,
        backAbilityId,
    }
]]
slkHelper.shapeshift = function(options)
    local re = {
        fromUnitId = options.fromUnitId
    }
    -- #变身演示
    local obj = slk.unit.Edmm:new("slkh_shapeshift_tu_" .. slkHelper.shapeshiftIndex)
    obj.EditorSuffix = "SLK#变身"
    obj.Name = options.toName
    obj.special = 0
    obj.abilList = ""
    obj.heroAbiList = ""
    obj.Requirescount = 0
    obj.Requires1 = ""
    obj.Requires2 = ""
    obj.file = options.toFire
    obj.Art = options.toArt
    obj.race = "other"
    re.toUnitId = obj:get_id()
    obj = slk.ability.AEme:new("slkh_shapeshift_ta_" .. slkHelper.shapeshiftIndex)
    obj.EditorSuffix = "#h-lua"
    obj.Name = "SLK#变身#T[" .. options.toName .. "]"
    obj.UnitD1 = re.fromUnitId
    obj.DataE1 = 0
    obj.DataA1 = re.toUnitId
    obj.Tip = ""
    obj.Ubertip = ""
    obj.Art = ""
    obj.hero = 0
    obj.race = "other"
    obj.Cool1 = 0.00
    obj.Dur1 = 0.500
    obj.HeroDur1 = 0.001
    obj.Cost1 = 0
    re.toAbilityId = obj:get_id()
    obj = slk.ability.AEme:new("slkh_shapeshift_ba_" .. slkHelper.shapeshiftIndex)
    obj.EditorSuffix = "#h-lua"
    obj.Name = "SLK#变身#B[" .. options.toName .. "]"
    obj.UnitD1 = re.toUnitId
    obj.DataE1 = 0
    obj.DataA1 = re.fromUnitId
    obj.Tip = ""
    obj.Ubertip = ""
    obj.Art = ""
    obj.hero = 0
    obj.race = "other"
    obj.Cool1 = 0.00
    obj.Dur1 = 0.500
    obj.HeroDur1 = 0.001
    obj.Cost1 = 0
    re.backAbilityId = obj:get_id()
    return re
end

--- 属性系统说明构成
---@private
slkHelper.attrDesc = function(attr, sep)
    local str = {}
    local strTable = {}
    sep = sep or "|n"
    for k, v in pairs(attr) do
        -- 附加单位
        if (k == "attack_speed_space") then
            v = v .. "击每秒"
        end
        if (table.includes(k, { "life_back", "mana_back" })) then
            v = v .. "每秒"
        end
        if (table.includes(k, {
            "attack_speed",
            "resistance",
            "avoid",
            "aim",
            "hemophagia",
            "hemophagia_skill",
            "split",
            "luck",
            "invincible",
            "damage_extent",
            "damage_rebound",
            "cure",
            "gold_ratio",
            "lumber_ratio",
            "exp_ratio",
            "sell_ratio"
        }))
        then
            v = v .. "%"
        end
        local s = string.find(k, "oppose")
        local n = string.find(k, "natural")
        if (s ~= nil or n ~= nil) then
            v = v .. "%"
        end
        --
        if (k == "attack_damage_type") then
            local tempStr = (CONST_ATTR[k] or "") .. "："
            local opt = string.sub(v, 1, 1) or "+"
            if (type(v) == "string") then
                v = string.sub(v, 2)
                v = string.explode(",", v)
            end
            local av = {}
            for _, vv in ipairs(v) do
                table.insert(av, CONST_ATTR[vv] or "")
            end
            tempStr = tempStr .. opt .. string.implode(",", av)
            av = nil
            table.insert(str, tempStr)
        elseif (table.includes(k, {
            "attack_buff",
            "attack_debuff",
            "skill_buff",
            "skill_debuff",
            "attack_effect",
            "skill_effect"
        })) then
            table.insert(strTable, (CONST_ATTR[k] or "") .. "：")
            local tempStr = {}
            for _, vv in pairs(v) do
                local odds = vv["odds"] or 0
                local during = vv["during"] or 0
                local val = vv["val"] or 0
                local percent = vv["percent"] or 0
                local qty = vv["qty"] or 0
                local reduce = vv["reduce"] or 0
                local range = vv["range"] or 0
                local distance = vv["distance"] or 0
                local high = vv["high"] or 0
                local temp2 = "　-"
                if (k == "attack_buff" or k == "skill_buff") then
                    temp2 = temp2 .. "有"
                    temp2 = temp2 .. odds .. "%几率"
                    temp2 = temp2 .. "在" .. during .. "秒内"
                    if (val >= 0) then
                        temp2 = temp2 .. "增加自身" .. val
                    else
                        temp2 = temp2 .. "减少自身" .. val
                    end
                    temp2 = temp2 .. CONST_ATTR[vv["attr"]]
                elseif (k == "attack_debuff" or k == "skill_debuff") then
                    temp2 = temp2 .. "有" .. odds .. "%几率"
                    temp2 = temp2 .. "在" .. during .. "秒内"
                    if (vv["val"] >= 0) then
                        temp2 = temp2 .. "减少敌人" .. vv["val"]
                    else
                        temp2 = temp2 .. "增加敌人" .. vv["val"]
                    end
                    temp2 = temp2 .. CONST_ATTR[vv["attr"]]
                elseif (k == "attack_effect" or k == "skill_effect") then
                    if (odds < 100) then
                        temp2 = temp2 .. "有" .. odds .. "%几率"
                    end
                    if (vv["attr"] == "knocking" or vv["attr"] == "violence") then
                        temp2 = temp2 .. "击出额外" .. percent .. "%伤害的" .. CONST_ATTR[vv["attr"]]
                    elseif (vv["attr"] == "split" or vv["attr"] == "bomb") then
                        temp2 = temp2 .. "击出" .. range .. "范围"
                        temp2 = temp2 .. percent .. "%的" .. CONST_ATTR[vv["attr"]] .. "伤害"
                    elseif (vv["attr"] == "swim" or vv["attr"] == "silent" or vv["attr"] == "unarm" or vv["attr"] == "fetter")
                    then
                        temp2 = temp2 .. CONST_ATTR[vv["attr"]] .. "目标" .. during .. "秒"
                        if (val > 0) then
                            temp2 = temp2 .. ",并造成" .. val .. "点伤害"
                        end
                    elseif (vv["attr"] == "broken") then
                        temp2 = temp2 .. CONST_ATTR[vv["attr"]] .. "目标"
                        if (val > 0) then
                            temp2 = temp2 .. ",并造成" .. val .. "点伤害"
                        end
                    elseif (vv["attr"] == "lightning_chain") then
                        temp2 = temp2 .. "对最多" .. qty .. "个目标"
                        temp2 = temp2 .. "发动" .. val .. "伤害的" .. CONST_ATTR[vv["attr"]]
                        if (reduce > 0) then
                            temp2 = temp2 .. ",每次击中伤害渐强" .. reduce .. "%"
                        elseif (reduce < 0) then
                            temp2 = temp2 .. ",每次击中伤害衰减" .. reduce .. "%"
                        end
                    elseif (vv["attr"] == "crack_fly") then
                        temp2 = temp2 .. CONST_ATTR[vv["attr"]] .. "目标高达" .. high .. "高度"
                        if (val > 0) then
                            temp2 = temp2 .. ",并击退" .. distance .. "范围"
                        end
                        if (val > 0) then
                            temp2 = temp2 .. ",同时造成" .. val .. "伤害"
                        end
                    end
                end
                table.insert(tempStr, temp2)
            end
            table.insert(strTable, string.implode(sep, tempStr))
        else
            table.insert(str, (CONST_ATTR[k] or "") .. "：" .. v)
        end
    end
    return string.implode(sep, table.merge(str, strTable))
end

--- 属性系统说明构成
---@private
slkHelper.attrTableDesc = function(attr, sep)
    local str = ""
    sep = sep or "|n"
    for k, v in pairs(attr) do
        if (table.includes(k, {
            "attack_buff",
            "attack_debuff",
            "skill_buff",
            "skill_debuff",
            "attack_effect",
            "skill_effect"
        })) then
            str = str .. (CONST_ATTR[k] or "") .. "："
            local temp = ""
            for kk, vv in pairs(v) do
                temp = temp .. (CONST_ATTR[kk] or "")
                local odds = vv["odds"] or 0
                local during = vv["during"] or 0
                local val = vv["val"] or 0
                local percent = vv["percent"] or 0
                local qty = vv["qty"] or 0
                local reduce = vv["reduce"] or 0
                local range = vv["range"] or 0
                local distance = vv["distance"] or 0
                local high = vv["high"] or 0
                local temp2 = "|n　-"
                if (k == "attack_buff" or k == "skill_buff") then
                    temp2 = temp2 .. "有"
                    temp2 = temp2 .. odds .. "%几率"
                    temp2 = temp2 .. "在" .. during .. "秒内"
                    if (val >= 0) then
                        temp2 = temp2 .. "增加自身" .. val
                    else
                        temp2 = temp2 .. "减少自身" .. val
                    end
                    temp2 = temp2 .. CONST_ATTR[vv["attr"]]
                elseif (k == "attack_debuff" or k == "skill_debuff") then
                    temp2 = temp2 .. "有" .. odds .. "%几率"
                    temp2 = temp2 .. "在" .. during .. "秒内"
                    if (vv["val"] >= 0) then
                        temp2 = temp2 .. "减少敌人" .. vv["val"]
                    else
                        temp2 = temp2 .. "增加敌人" .. vv["val"]
                    end
                    temp2 = temp2 .. CONST_ATTR[vv["attr"]]
                elseif (k == "attack_effect" or k == "skill_effect") then
                    if (odds < 100) then
                        temp2 = temp2 .. "有" .. odds .. "%几率"
                    end
                    if (vv["attr"] == "knocking" or vv["attr"] == "violence") then
                        temp2 = temp2 .. "击出额外" .. percent .. "%伤害的" .. CONST_ATTR[vv["attr"]]
                    elseif (vv["attr"] == "split" or vv["attr"] == "bomb") then
                        temp2 = temp2 .. "击出" .. range .. "范围"
                        temp2 = temp2 .. percent .. "%的" .. CONST_ATTR[vv["attr"]] .. "伤害"
                    elseif (vv["attr"] == "swim" or vv["attr"] == "silent" or vv["attr"] == "unarm" or vv["attr"] == "fetter")
                    then
                        temp2 = temp2 .. CONST_ATTR[vv["attr"]] .. "目标" .. during .. "秒"
                        if (val > 0) then
                            temp2 = temp2 .. ",并造成" .. val .. "点伤害"
                        end
                    elseif (vv["attr"] == "broken") then
                        temp2 = temp2 .. CONST_ATTR[vv["attr"]] .. "目标"
                        if (val > 0) then
                            temp2 = temp2 .. ",并造成" .. val .. "点伤害"
                        end
                    elseif (vv["attr"] == "lightning_chain") then
                        temp2 = temp2 .. "对最多" .. qty .. "个目标"
                        temp2 = temp2 .. "发动" .. val .. "伤害的" .. CONST_ATTR[vv["attr"]]
                        if (reduce > 0) then
                            temp2 = temp2 .. ",每次击中伤害渐强" .. reduce .. "%"
                        elseif (reduce < 0) then
                            temp2 = temp2 .. ",每次击中伤害衰减" .. reduce .. "%"
                        end
                    elseif (vv["attr"] == "crack_fly") then
                        temp2 = temp2 .. CONST_ATTR[vv["attr"]] .. "目标高达" .. high .. "高度"
                        if (val > 0) then
                            temp2 = temp2 .. ",并击退" .. distance .. "范围"
                        end
                        if (val > 0) then
                            temp2 = temp2 .. ",同时造成" .. val .. "伤害"
                        end
                    end
                end
                temp = temp .. temp2
            end
            str = str .. temp .. sep
        end
    end
    return str
end

--- 组装物品的描述
---@private
slkHelper.itemDesc = function(v)
    local d = {}
    if (v.ACTIVE ~= nil) then
        table.insert(d, "主动：" .. v.ACTIVE)
    end
    if (v.PASSIVE ~= nil) then
        table.insert(d, "被动：" .. v.PASSIVE)
    end
    if (v.ATTR ~= nil) then
        table.sort(v.ATTR)
        table.insert(d, slkHelper.attrDesc(v.ATTR, ";"))
    end
    -- 仅文本无效果，适用于例如技能书这类的物品
    if (v.ATTR_TXT ~= nil) then
        table.sort(v.ATTR_TXT)
        table.insert(d, slkHelper.attrDesc(v.ATTR_TXT, ";"))
    end
    local overlie = v.OVERLIE or 1
    local weight = v.WEIGHT or 0
    weight = tostring(math.round(weight))
    table.insert(d, "叠加：" .. overlie .. "|n重量：" .. weight .. "Kg")
    if (v.Desc ~= nil and v.Desc ~= "") then
        table.insert(d, v.Desc)
    end
    return string.implode("|n", d)
end

--- 组装物品的说明
---@private
slkHelper.itemUbertip = function(v)
    local d = {}
    if (v.ACTIVE ~= nil) then
        table.insert(d, hColor.yellow("主动：" .. v.ACTIVE))
        if (v.cooldown ~= nil and v.cooldown > 0) then
            table.insert(d, hColor.skyLight("冷却：" .. v.cooldown .. "秒"))
        end
    end
    if (v.PASSIVE ~= nil) then
        table.insert(d, hColor.seaLight("被动：" .. v.PASSIVE))
    end
    if (v.ATTR ~= nil) then
        table.sort(v.ATTR)
        table.insert(d, hColor.green(slkHelper.attrDesc(v.ATTR, "|n")))
    end
    -- 仅文本无效果，适用于例如技能书这类的物品
    if (v.ATTR_TXT ~= nil) then
        table.sort(v.ATTR_TXT)
        table.insert(d, hColor.green(slkHelper.attrDesc(v.ATTR_TXT, "|n")))
    end
    local overlie = v.OVERLIE or 1
    local weight = v.WEIGHT or 0
    weight = tostring(math.round(weight))
    table.insert(d, hColor.purpleLight("叠加：" .. overlie .. "|n重量：" .. weight .. "Kg"))
    if (v.Desc ~= nil and v.Desc ~= "") then
        table.insert(d, hColor.grey(v.Desc))
    end
    return string.implode("|n", d)
end

--- 组装空白被动技能的说明
---@private
slkHelper.abilityEmptyUbertip = function(v)
    local d = {}
    if (v.PASSIVE ~= nil) then
        table.insert(d, hColor.seaLight("被动：" .. v.PASSIVE))
    end
    if (v.ATTR ~= nil) then
        table.sort(v.ATTR)
        table.insert(d, hColor.green(slkHelper.attrDesc(v.ATTR, "|n")))
    end
    if (v.Desc ~= nil and v.Desc ~= "") then
        table.insert(d, hColor.grey(v.Desc))
    end
    return string.implode("|n", d)
end

--- 组装光环技能的说明
---@private
slkHelper.abilityRingUbertip = function(v)
    local d = {}
    if (v.Area1 ~= nil) then
        table.insert(d, hColor.seaLight("光环范围：" .. v.Area1))
    end
    if (v.targs1 ~= nil) then
        local targs1 = string.explode(',', v.targs1)
        local labels = {}
        for _, t in ipairs(targs1) do
            table.insert(labels, CONST_TARGET_LABEL[t])
        end
        table.insert(d, hColor.seaLight("作用目标：" .. string.implode(',', labels)))
        labels = nil
    end
    if (v.RING ~= nil) then
        table.sort(v.RING)
        table.insert(d, hColor.green(slkHelper.attrDesc(v.RING, "|n")))
    end
    if (v.Desc ~= nil and v.Desc ~= "") then
        table.insert(d, v.Desc)
    end
    return string.implode("|n", d)
end

--- 创建一件物品的冷却技能
---@private
slkHelper.itemCooldown0ID = nil
slkHelper.itemCooldownID0 = function()
    if (slkHelper.itemCooldown0ID == nil) then
        local oobTips = "ITEMS_DEFCD_ID_#0"
        local oob = slk.ability.AIgo:new("items_default_cooldown_#0")
        oob.Effectsound = ""
        oob.Name = oobTips
        oob.Tip = oobTips
        oob.Ubertip = oobTips
        oob.Art = ""
        oob.TargetArt = ""
        oob.Targetattach = ""
        oob.DataA1 = 0
        oob.Art = ""
        oob.CasterArt = ""
        oob.Cool = 0
        slkHelper.itemCooldown0ID = oob:get_id()
    end
    return slkHelper.itemCooldown0ID
end

--- 创建一件物品的冷却技能
---@private
slkHelper.itemCooldownID = function(v)
    if (v.cooldown == nil) then
        return "AIat"
    end
    if (v.cooldown < 0) then
        v.cooldown = 0
    end
    if (v.cooldown == 0) then
        return slkHelper.itemCooldownID0()
    end
    local oobTips = "ITEMS_DEFCD_ID_" .. v.Name
    local oob = slk.ability.AIgo:new("items_default_cooldown_" .. v.Name)
    oob.Effectsound = ""
    oob.Name = oobTips
    oob.Tip = oobTips
    oob.Ubertip = oobTips
    oob.Art = ""
    oob.TargetArt = ""
    oob.Targetattach = ""
    oob.DataA1 = 0
    oob.Art = ""
    oob.CasterArt = v.CasterArt or ""
    oob.Cool = v.cooldown
    return oob:get_id()
end

slkHelper.item = {
    --- 创建一件物品
    --- 设置的CUSTOM_DATA数据会自动传到数据中
    ---@public
    ---@param v table
    normal = function(v)
        slkHelper.count = slkHelper.count + 1
        local cd = slkHelper.itemCooldownID(v)
        local abilList = ""
        local usable = 0
        local uses = v.uses or 1
        local OVERLIE = v.OVERLIE or 1
        local ignoreCD = 0
        if (cd ~= "AIat") then
            abilList = cd
            usable = 1
            if (v.perishable == nil) then
                v.perishable = 1
            end
            v.class = "Charged"
            if (cd == slkHelper.itemCooldown0ID) then
                ignoreCD = 1
            end
        else
            if (v.perishable == nil) then
                v.perishable = 0
            end
            v.class = "Permanent"
        end
        local lv = 1
        v.goldcost = v.goldcost or 0
        v.lumbercost = v.lumbercost or 0
        lv = math.floor((v.goldcost + v.lumbercost) / 500)
        if (lv < 1) then
            lv = 1
        end
        v.Name = v.Name or "未命名" .. slkHelper.count
        v.Art = v.Art or "ReplaceableTextures\\CommandButtons\\BTNSelectHeroOn.blp"
        v.file = v.file or "Objects\\InventoryItems\\TreasureChest\\treasurechest.mdl"
        v.powerup = v.powerup or 0
        v.perishable = v.perishable or 0
        v.sellable = v.sellable or 1
        v.pawnable = v.pawnable or 1
        v.dropable = v.dropable or 1
        local WEIGHT = v.WEIGHT or 0
        local obj = slk.item.rat9:new("items_" .. v.Name)
        obj.Name = v.Name
        obj.Description = slkHelper.itemDesc(v)
        obj.Ubertip = slkHelper.itemUbertip(v)
        obj.goldcost = v.goldcost or 1000000
        obj.lumbercost = v.lumbercost or 1000000
        obj.class = v.class
        obj.Level = lv
        obj.oldLevel = lv
        obj.Art = v.Art
        obj.file = v.file
        obj.prio = v.prio or 0
        obj.cooldownID = cd
        obj.abilList = abilList
        obj.ignoreCD = ignoreCD
        obj.drop = v.drop or 0
        obj.perishable = v.perishable
        obj.usable = usable
        obj.powerup = v.powerup
        obj.sellable = v.sellable
        obj.pawnable = v.pawnable
        obj.droppable = v.dropable
        obj.pickRandom = v.pickRandom or 1
        obj.stockStart = v.stockStart or 0 -- 库存开始
        obj.stockRegen = v.stockRegen or 0 -- 进货周期
        obj.stockMax = v.stockMax or 1 -- 最大库存
        obj.uses = uses
        if (v.HotKey ~= nil) then
            obj.HotKey = v.HotKey
            v.Buttonpos1 = CONST_HOTKEY_FULL_KV[v.HotKey].Buttonpos1 or 0
            v.Buttonpos2 = CONST_HOTKEY_FULL_KV[v.HotKey].Buttonpos2 or 0
            obj.Tip = "获得" .. v.Name .. "(" .. hColor.gold(v.HotKey) .. ")"
        else
            obj.Buttonpos1 = v.Buttonpos1 or 0
            obj.Buttonpos2 = v.Buttonpos2 or 0
            obj.Tip = "获得" .. v.Name
        end
        local id = obj:get_id()
        table.insert(slkHelperHashData, {
            type = "item",
            data = {
                CUSTOM_DATA = v.CUSTOM_DATA or {},
                ID_ARRAY = v.ID_ARRAY or nil,
                ITEM_ID = id,
                Name = v.Name,
                class = v.class,
                Art = v.Art,
                file = v.file,
                goldcost = v.goldcost,
                lumbercost = v.lumbercost,
                usable = usable,
                powerup = v.powerup,
                perishable = v.perishable,
                sellable = v.sellable,
                OVERLIE = OVERLIE,
                WEIGHT = WEIGHT,
                ATTR = v.ATTR,
            }
        })
        return id
    end,
}

slkHelper.unit = {
    --- 创建一个单位
    --- 设置的CUSTOM_DATA数据会自动传到数据中
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
        v.def = v.def or 0
        v.rangeN1 = v.rangeN1 or 100
        v.sight = v.sight or 1400
        v.nsight = v.nsight or 800
        local acquire = v.acquire or (v.rangeN1 + 100) -- 警戒范围
        if (acquire < (v.rangeN1 + 100)) then
            acquire = v.rangeN1 + 100
        end
        --
        local obj = slk.unit.ogru:new("slk_units_" .. v.Name)
        if (v.HotKey ~= nil) then
            obj.HotKey = v.HotKey
            v.Buttonpos1 = CONST_HOTKEY_FULL_KV[v.HotKey].Buttonpos1 or 0
            v.Buttonpos2 = CONST_HOTKEY_FULL_KV[v.HotKey].Buttonpos2 or 0
            obj.Tip = "选择：" .. v.Name .. "(" .. hColor.gold(v.HotKey) .. ")"
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
        obj.collision = 32 --接触体积
        obj.def = v.def or 0.00 -- 护甲
        obj.sight = v.sight or 1000 -- 白天视野
        obj.nsight = v.nsight or 1000 -- 夜晚视野
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
        obj.dmgplus1 = v.dmgplus1 or 10 -- 基础攻击
        obj.showUI1 = v.showUI1 or 1 -- 显示攻击按钮
        obj.goldcost = v.goldcost
        obj.lumbercost = v.lumbercost
        obj.HP = v.HP or 100
        obj.mana0 = v.mana0 or 0
        obj.weapsOn = v.weapsOn or 0
        obj.Sellitems = v.Sellitems or ""
        local id = obj:get_id()
        table.insert(slkHelperHashData, {
            type = "unit",
            data = {
                CUSTOM_DATA = v.CUSTOM_DATA or {},
                ID_ARRAY = v.ID_ARRAY or nil,
                UNIT_ID = id,
                UNIT_TYPE = "normal",
                Name = v.Name,
                Art = v.Art,
                file = v.file,
                goldcost = v.goldcost,
                lumbercost = v.lumbercost,
                cool1 = v.cool1,
                def = v.def,
                rangeN1 = v.rangeN1,
                sight = v.sight,
                nsight = v.nsight,
            }
        })
        return id
    end,
    --- 创建一个英雄
    --- 设置的CUSTOM_DATA数据会自动传到数据中
    ---@public
    ---@param v table
    hero = function(v)
        slkHelper.count = slkHelper.count + 1
        v.Name = v.Name or "英雄-" .. slkHelper.count
        local Primary = v.Primary or "STR"
        local Ubertip = ""
        Ubertip = Ubertip .. hColor.red("攻击类型：" .. CONST_WEAPON_TYPE[v.weapTp1].label .. "(" .. v.cool1 .. "秒/击)")
        Ubertip = Ubertip .. "|n" .. hColor.redLight("基础攻击：" .. v.dmgplus1)
        Ubertip = Ubertip .. "|n" .. hColor.seaLight("攻击范围：" .. v.rangeN1)
        if (Primary == "STR") then
            Ubertip = Ubertip .. "|n" .. hColor.yellow("力量：" .. v.STR .. "(+" .. v.STRplus .. ")")
        else
            Ubertip = Ubertip .. "|n" .. hColor.yellowLight("力量：" .. v.STR .. "(+" .. v.STRplus .. ")")
        end
        if (Primary == "AGI") then
            Ubertip = Ubertip .. "|n" .. hColor.yellow("敏捷：" .. v.AGI .. "(+" .. v.AGIplus .. ")")
        else
            Ubertip = Ubertip .. "|n" .. hColor.yellowLight("敏捷：" .. v.AGI .. "(+" .. v.AGIplus .. ")")
        end
        if (Primary == "INT") then
            Ubertip = Ubertip .. "|n" .. hColor.yellow("智力：" .. v.INT .. "(+" .. v.INTplus .. ")")
        else
            Ubertip = Ubertip .. "|n" .. hColor.yellowLight("智力：" .. v.INT .. "(+" .. v.INTplus .. ")")
        end
        Ubertip = Ubertip .. "|n" .. hColor.greenLight("移动：" .. v.spd .. " " .. CONST_MOVE_TYPE[v.movetp].label)
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
        v.def = v.def or 0
        v.rangeN1 = v.rangeN1 or 100
        v.sight = v.sight or 1800
        v.nsight = v.nsight or 800
        local acquire = v.acquire or v.rangeN1 -- 警戒范围
        if (acquire < 1000) then
            acquire = 1000
        end
        --
        local obj = slk.unit.Hpal:new("slk_hero_" .. v.Name)
        if (v.HotKey ~= nil) then
            obj.HotKey = v.HotKey
            v.Buttonpos1 = CONST_HOTKEY_FULL_KV[v.HotKey].Buttonpos1 or 0
            v.Buttonpos2 = CONST_HOTKEY_FULL_KV[v.HotKey].Buttonpos2 or 0
            obj.Tip = "选择：" .. v.Name .. "(" .. hColor.gold(v.HotKey) .. ")"
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
        obj.collision = 32 --接触体积
        obj.def = v.def -- 护甲
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
        obj.def = v.def
        obj.armor = v.armor or "Flesh" -- 被击声音
        obj.targType = v.targType or "ground" --作为目标类型
        obj.weapTp1 = v.weapTp1 --攻击类型
        obj.dmgplus1 = v.dmgplus1 or 10 -- 基础攻击
        obj.showUI1 = v.showUI1 or 1 -- 显示攻击按钮
        obj.STR = v.STR
        obj.AGI = v.AGI
        obj.INT = v.INT
        obj.STRplus = v.STRplus
        obj.AGIplus = v.AGIplus
        obj.INTplus = v.INTplus
        obj.goldcost = v.goldcost
        obj.lumbercost = v.lumbercost
        local id = obj:get_id()
        table.insert(slkHelperHashData, {
            type = "unit",
            data = {
                CUSTOM_DATA = v.CUSTOM_DATA or {},
                ID_ARRAY = v.ID_ARRAY or nil,
                UNIT_ID = id,
                UNIT_TYPE = "hero",
                Primary = Primary,
                STR = v.STR,
                AGI = v.AGI,
                INT = v.INT,
                STRplus = v.STRplus,
                AGIplus = v.AGIplus,
                INTplus = v.INTplus,
                Name = v.Name,
                Art = v.Art,
                file = v.file,
                goldcost = v.goldcost,
                lumbercost = v.lumbercost,
                cool1 = v.cool1,
                def = v.def,
                rangeN1 = v.rangeN1,
                sight = v.sight,
                nsight = v.nsight,
            }
        })
        return id
    end,
    --- 创建一个商店
    --- 设置的CUSTOM_DATA数据会自动传到数据中
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
        obj.modelScale = v.modelScale or 1.00
        obj.scale = v.scale or 1.00
        obj.HP = v.HP or 99999
        obj.sight = v.sight or 800
        obj.nsight = v.nsight or 800
        obj.unitSound = v.unitSound or ""
        obj.unitShadow = v.unitShadow or ""
        obj.buildingShadow = v.buildingShadow or ""
        obj.Makeitems = v.Makeitems
        obj.Sellitems = v.Sellitems
        obj.UberSplat = ""
        obj.race = v.race or "other"
        local id = obj:get_id()
        table.insert(slkHelperHashData, {
            type = "unit",
            data = {
                CUSTOM_DATA = v.CUSTOM_DATA or {},
                ID_ARRAY = v.ID_ARRAY or nil,
                UNIT_ID = id,
                UNIT_TYPE = "shop",
                Name = v.Name,
                Art = v.Art,
                file = v.file,
                sight = v.sight,
                nsight = v.nsight,
                Makeitems = v.Makeitems,
                Sellitems = v.Sellitems,
            }
        })
        return id
    end,
    --- 创建一个信使
    --- 设置的CUSTOM_DATA数据会自动传到数据中
    ---@public
    ---@param v table
    courier = function(v)
        if (slkHelper.courierBlink == nil) then
            local obj = slk.ability.AEbl:new("slk_courier_blink")
            local Name = "闪烁"
            local Tip = "闪烁(" .. hColor.gold("Q") .. ")"
            obj.Name = Name
            obj.Tip = Tip
            obj.Hotkey = "Q"
            obj.Ubertip = "可以闪烁到任何地方"
            obj.Buttonpos1 = 0
            obj.Buttonpos2 = 2
            obj.hero = 0
            obj.levels = 1
            obj.DataA1 = 99999
            obj.DataB1 = 0
            obj.Cool1 = 10
            obj.Cost1 = 0
            obj.Art = "ReplaceableTextures\\CommandButtons\\BTNBlink.blp"
            obj.SpecialArt = "Abilities\\Spells\\NightElf\\Blink\\BlinkCaster.mdl"
            obj.Areaeffectart = "Abilities\\Spells\\NightElf\\Blink\\BlinkTarget.mdl"
            obj.race = v.race or "other"
            slkHelper.courierBlink = obj:get_id()
        end
        if (slkHelper.courierPickUp == nil) then
            local obj = slk.ability.ANcl:new("slk_courier_pickup")
            local Name = "拾取"
            local Tip = "拾取(" .. hColor.gold("W") .. ")"
            obj.Order = "manaburn"
            obj.DataF1 = "manaburn"
            obj.Name = Name
            obj.Tip = Tip
            obj.Hotkey = "W"
            obj.Ubertip = "将附近地上的物品拾取到身上"
            obj.Buttonpos1 = 1
            obj.Buttonpos2 = 2
            obj.hero = 0
            obj.levels = 1
            obj.DataA1 = 0
            obj.DataB1 = 0
            obj.DataC1 = 1
            obj.DataD1 = 0.01
            obj.Cool1 = 1
            obj.Cost1 = 0
            obj.Art = "ReplaceableTextures\\CommandButtons\\BTNPickUpItem.blp"
            obj.CasterArt = ""
            obj.EffectArt = ""
            obj.TargetArt = ""
            obj.race = v.race or "other"
            slkHelper.courierPickUp = obj:get_id()
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
        v.def = v.def or 0
        v.rangeN1 = v.rangeN1 or 100
        v.sight = v.sight or 1800
        v.nsight = v.nsight or 800
        v.dmgplus1 = v.dmgplus1 or 0
        v.movetp = v.movetp or "foot"
        v.moveHeight = v.moveHeight or 0
        v.spd = v.spd or 100
        local abl = { "AInv", slkHelper.courierBlink, slkHelper.courierPickUp }
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
        if (v.HotKey ~= nil) then
            v.Buttonpos1 = CONST_HOTKEY_FULL_KV[v.HotKey].Buttonpos1 or 0
            v.Buttonpos2 = CONST_HOTKEY_FULL_KV[v.HotKey].Buttonpos2 or 0
            Tip = "选择：" .. Name .. "(" .. hColor.gold(v.HotKey) .. ")"
        else
            v.Buttonpos1 = v.Buttonpos1 or 0
            v.Buttonpos2 = v.Buttonpos2 or 0
            Tip = "选择：" .. Name
        end
        local UNIT_TYPE = "courier"
        if (v.isHero == 1) then
            UNIT_TYPE = "courier_hero"
            --- 如果是英雄型信使
            Primary = v.Primary or "STR"
            Ubertip = hColor.greenLight("移动：" .. v.spd .. " " .. CONST_MOVE_TYPE[v.movetp].label)
            if (v.weapsOn == 1) then
                Ubertip = Ubertip .. "|n" .. hColor.red("攻击类型：" .. CONST_WEAPON_TYPE[v.weapTp1].label .. "(" .. v.cool1 .. "秒/击)")
                Ubertip = Ubertip .. "|n" .. hColor.redLight("基础攻击：" .. v.dmgplus1)
                Ubertip = Ubertip .. "|n" .. hColor.seaLight("攻击范围：" .. v.rangeN1)
            end
            if (Primary == "STR") then
                Ubertip = Ubertip .. "|n" .. hColor.yellow("力量：" .. v.STR .. "(+" .. v.STRplus .. ")")
            else
                Ubertip = Ubertip .. "|n" .. hColor.yellowLight("力量：" .. v.STR .. "(+" .. v.STRplus .. ")")
            end
            if (Primary == "AGI") then
                Ubertip = Ubertip .. "|n" .. hColor.yellow("敏捷：" .. v.AGI .. "(+" .. v.AGIplus .. ")")
            else
                Ubertip = Ubertip .. "|n" .. hColor.yellowLight("敏捷：" .. v.AGI .. "(+" .. v.AGIplus .. ")")
            end
            if (Primary == "INT") then
                Ubertip = Ubertip .. "|n" .. hColor.yellow("智力：" .. v.INT .. "(+" .. v.INTplus .. ")")
            else
                Ubertip = Ubertip .. "|n" .. hColor.yellowLight("智力：" .. v.INT .. "(+" .. v.INTplus .. ")")
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
            obj.dmgplus1 = v.dmgplus1
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
        obj.collision = 0.00
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
        obj.collision = 0 --接触体积
        obj.def = v.def -- 护甲
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
        table.insert(slkHelperHashData, {
            type = "unit",
            data = {
                CUSTOM_DATA = v.CUSTOM_DATA or {},
                ID_ARRAY = v.ID_ARRAY or nil,
                UNIT_ID = id,
                UNIT_TYPE = UNIT_TYPE,
                Name = Name,
                Art = v.Art,
                file = v.file,
                sight = v.sight,
                nsight = v.nsight,
                goldcost = v.goldcost,
                lumbercost = v.lumbercost,
                cool1 = v.cool1,
                def = v.def,
                rangeN1 = v.rangeN1,
                -- hero
                Primary = Primary,
                STR = v.STR,
                AGI = v.AGI,
                INT = v.INT,
                STRplus = v.STRplus,
                AGIplus = v.AGIplus,
                INTplus = v.INTplus,
            }
        })
        return id
    end,
    --- 创建一个酒馆模版
    --- 设置的CUSTOM_DATA数据会自动传到数据中
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
        obj.sight = v.sight or 800
        obj.nsight = v.nsight or 800
        obj.unitSound = v.unitSound or ""
        obj.uberSplat = ""
        obj.teamColor = 12
        obj.race = v.race or "other"
        local id = obj:get_id()
        table.insert(slkHelperHashData, {
            type = "unit",
            data = {
                CUSTOM_DATA = v.CUSTOM_DATA or {},
                ID_ARRAY = v.ID_ARRAY or nil,
                UNIT_ID = id,
                UNIT_TYPE = "tavern",
                Name = v.Name,
                Art = v.Art,
                file = v.file,
                sight = v.sight,
                nsight = v.nsight,
                Sellunits = v.Sellunits,
            }
        })
        return id
    end,
}

slkHelper.ability = {
    --- 创建一个空白的被动技能
    --- 设置的CUSTOM_DATA数据会自动传到数据中
    ---@public
    ---@param v table
    empty = function(v)
        slkHelper.count = slkHelper.count + 1
        local Name = v.Name or "空白被动-" .. slkHelper.count
        local Art = v.Art or "ReplaceableTextures\\PassiveButtons\\PASBTNStatUp.blp"
        v.Buttonpos1 = v.Buttonpos1 or 0
        v.Buttonpos2 = v.Buttonpos2 or 0
        if (v.HotKey ~= nil) then
            v.Buttonpos1 = CONST_HOTKEY_ABILITY_KV[v.HotKey].Buttonpos1 or 0
            v.Buttonpos2 = CONST_HOTKEY_ABILITY_KV[v.HotKey].Buttonpos2 or 0
            v.Tip = Name .. "[" .. hColor.gold(v.HotKey) .. "]"
            Name = Name .. v.HotKey
        else
            v.Tip = Name
        end
        local obj = slk.ability.Aamk:new("slk_ability_empty_" .. Name)
        obj.HotKey = v.HotKey or ""
        obj.Name = Name
        obj.Tip = v.Tip
        obj.Ubertip = slkHelper.abilityEmptyUbertip(v)
        obj.Buttonpos1 = v.Buttonpos1
        obj.Buttonpos2 = v.Buttonpos2
        obj.hero = 0
        obj.levels = 1
        obj.DataA1 = 0
        obj.DataB1 = 0
        obj.DataC1 = 0
        obj.race = v.race or "other"
        obj.Art = Art
        local id = obj:get_id()
        table.insert(slkHelperHashData, {
            type = "ability",
            data = {
                CUSTOM_DATA = v.CUSTOM_DATA or {},
                ID_ARRAY = v.ID_ARRAY or nil,
                ABILITY_ID = id,
                ABILITY_TYPE = "empty",
                ATTR = v.ATTR,
                Name = v.Name,
                Art = Art,
            }
        })
        return id
    end,
    --- 创建一个空白的光环技能
    --- 设置的CUSTOM_DATA数据会自动传到数据中
    ---@public
    ---@param v table
    ring = function(v)
        slkHelper.count = slkHelper.count + 1
        local Name = v.Name or "空白光环-" .. slkHelper.count
        local BuffName = "[BUFF]" .. (v.Name or "空白光环-" .. slkHelper.count)
        local Art = v.Art or "ReplaceableTextures\\PassiveButtons\\PASBTNStatUp.blp"
        local Area1 = v.Area1 or 900
        v.targs1 = v.targs1 or "air,ground,friend,self,vuln,invu"
        -- buff
        local buffObj = slk.buff.BHad:new("slk_ringbuff_" .. BuffName)
        buffObj.BuffTip = Name
        buffObj.BuffuberTip = "此单位正处于" .. Name .. "的作用之下"
        buffObj.Buffart = Art
        buffObj.TargetArt = v.BuffTargetArt or "Abilities\\Spells\\Other\\GeneralAuraTarget\\GeneralAuraTarget.mdl"
        buffObj.Targetattach = v.Targetattach or "origin"
        --
        v.Buttonpos1 = v.Buttonpos1 or 0
        v.Buttonpos2 = v.Buttonpos2 or 0
        if (v.HotKey ~= nil) then
            v.Buttonpos1 = CONST_HOTKEY_ABILITY_KV[v.HotKey].Buttonpos1 or 0
            v.Buttonpos2 = CONST_HOTKEY_ABILITY_KV[v.HotKey].Buttonpos2 or 0
            v.Tip = Name .. "[" .. hColor.gold(v.HotKey) .. "] "
            Name = Name .. v.HotKey
        else
            v.Tip = Name
        end
        local obj = slk.ability.AHad:new("slk_ability_ring_ " .. Name)
        obj.BuffID1 = buffObj:get_id()
        obj.HotKey = v.HotKey or " "
        obj.Name = Name
        obj.Tip = v.Tip
        obj.Ubertip = slkHelper.abilityRingUbertip(v) .. "|n|n" .. hColor.grey(" * 同一种光环仅有一个有效")
        obj.Buttonpos1 = v.Buttonpos1
        obj.Buttonpos2 = v.Buttonpos2
        obj.TargetArt = v.TargetArt or ""
        obj.Area1 = Area1
        obj.hero = 0
        obj.levels = 1
        obj.DataA1 = 0
        obj.DataB1 = 0
        obj.DataC1 = 0
        obj.race = v.race or "other"
        obj.Art = Art
        obj.targs1 = v.targs1
        local id = obj:get_id()
        table.insert(slkHelperHashData, {
            type = "ability",
            data = {
                CUSTOM_DATA = v.CUSTOM_DATA or {},
                ID_ARRAY = v.ID_ARRAY or nil,
                ABILITY_ID = id,
                ABILITY_TYPE = "ring",
                ATTR = v.ATTR,
                Name = v.Name,
                Art = Art,
                Area1 = Area1,
                targs1 = string.explode(",", v.targs1),
            }
        })
        return id
    end,
}

