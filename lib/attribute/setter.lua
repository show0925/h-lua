---@class hattributeSetter 属性配置法
hattributeSetter = {
    DEFAULT_SKILL_ITEM_SLOT = string.char2id("AInv"), -- 默认物品栏技能（英雄6格那个）默认认定这个技能为物品栏
}

--- @private
hattributeSetter.getDecimalTemporaryStorage = function(whichUnit, attr)
    local diff = hunit.get(whichUnit, 'decimalTemporaryStorage', {})
    return diff[attr] or 0
end

--- @private
hattributeSetter.setDecimalTemporaryStorage = function(whichUnit, attr, value)
    local diff = hunit.get(whichUnit, 'decimalTemporaryStorage', {})
    diff[attr] = math.round(value)
    hunit.set(whichUnit, 'decimalTemporaryStorage', diff)
end

--- 为单位注册属性系统所需要的基础技能
--- hslk.attr
---@private
hattributeSetter.relyRegister = function(whichUnit)
    for _, v in ipairs(hslk.attr.ablis_gradient) do
        if (false == hjapi.check()) then
            -- 生命
            cj.UnitAddAbility(whichUnit, hslk.attr.life.add[v])
            cj.UnitRemoveAbility(whichUnit, hslk.attr.life.add[v])
            cj.UnitAddAbility(whichUnit, hslk.attr.life.sub[v])
            cj.UnitRemoveAbility(whichUnit, hslk.attr.life.sub[v])
            -- 魔法
            cj.UnitAddAbility(whichUnit, hslk.attr.mana.add[v])
            cj.UnitRemoveAbility(whichUnit, hslk.attr.mana.add[v])
            cj.UnitAddAbility(whichUnit, hslk.attr.mana.sub[v])
            cj.UnitRemoveAbility(whichUnit, hslk.attr.mana.sub[v])
            -- 攻击速度
            cj.UnitAddAbility(whichUnit, hslk.attr.attack_speed.add[v])
            cj.UnitRemoveAbility(whichUnit, hslk.attr.attack_speed.add[v])
            cj.UnitAddAbility(whichUnit, hslk.attr.attack_speed.sub[v])
            cj.UnitRemoveAbility(whichUnit, hslk.attr.attack_speed.sub[v])
        end
        -- 绿字攻击
        cj.UnitAddAbility(whichUnit, hslk.attr.attack_green.add[v])
        cj.UnitRemoveAbility(whichUnit, hslk.attr.attack_green.add[v])
        cj.UnitAddAbility(whichUnit, hslk.attr.attack_green.sub[v])
        cj.UnitRemoveAbility(whichUnit, hslk.attr.attack_green.sub[v])
        -- 绿色属性
        cj.UnitAddAbility(whichUnit, hslk.attr.str_green.add[v])
        cj.UnitRemoveAbility(whichUnit, hslk.attr.str_green.add[v])
        cj.UnitAddAbility(whichUnit, hslk.attr.str_green.sub[v])
        cj.UnitRemoveAbility(whichUnit, hslk.attr.str_green.sub[v])
        cj.UnitAddAbility(whichUnit, hslk.attr.agi_green.add[v])
        cj.UnitRemoveAbility(whichUnit, hslk.attr.agi_green.add[v])
        cj.UnitAddAbility(whichUnit, hslk.attr.agi_green.sub[v])
        cj.UnitRemoveAbility(whichUnit, hslk.attr.agi_green.sub[v])
        cj.UnitAddAbility(whichUnit, hslk.attr.int_green.add[v])
        cj.UnitRemoveAbility(whichUnit, hslk.attr.int_green.add[v])
        cj.UnitAddAbility(whichUnit, hslk.attr.int_green.sub[v])
        cj.UnitRemoveAbility(whichUnit, hslk.attr.int_green.sub[v])
        -- 防御
        cj.UnitAddAbility(whichUnit, hslk.attr.defend.add[v])
        cj.UnitRemoveAbility(whichUnit, hslk.attr.defend.add[v])
        cj.UnitAddAbility(whichUnit, hslk.attr.defend.sub[v])
        cj.UnitRemoveAbility(whichUnit, hslk.attr.defend.sub[v])
    end
    for _, v in ipairs(hslk.attr.sight_gradient) do
        -- 视野
        cj.UnitAddAbility(whichUnit, hslk.attr.sight.add[v])
        cj.UnitRemoveAbility(whichUnit, hslk.attr.sight.add[v])
        cj.UnitAddAbility(whichUnit, hslk.attr.sight.sub[v])
        cj.UnitRemoveAbility(whichUnit, hslk.attr.sight.sub[v])
    end
end

--- 为单位添加N个同样的生命魔法技能 1级设0 2级设负 负减法（搜[卡血牌bug]，了解原理）
---@private
hattributeSetter.relyLifeMana = function(u, abilityId, qty)
    if (qty <= 0) then
        return
    end
    local i = 1
    while (i <= qty) do
        cj.UnitAddAbility(u, abilityId)
        cj.SetUnitAbilityLevel(u, abilityId, 2)
        cj.UnitRemoveAbility(u, abilityId)
        i = i + 1
    end
end

--- 为单位添加N个同样的攻击之书
---@private
hattributeSetter.relyAttackWhite = function(u, itemId, qty)
    if (u == nil or itemId == nil or qty <= 0) then
        return
    end
    if (his.alive(u) == true) then
        local i = 1
        local it
        local hasSlot = (cj.GetUnitAbilityLevel(u, hattributeSetter.DEFAULT_SKILL_ITEM_SLOT) >= 1)
        if (hasSlot == false) then
            cj.UnitAddAbility(u, hattributeSetter.DEFAULT_SKILL_ITEM_SLOT)
        end
        while (i <= qty) do
            it = cj.CreateItem(itemId, 0, 0)
            cj.UnitAddItem(u, it)
            cj.SetWidgetLife(it, 10.00)
            cj.RemoveItem(it)
            it = nil
            i = i + 1
        end
        if (hasSlot == false) then
            cj.UnitRemoveAbility(u, hattributeSetter.DEFAULT_SKILL_ITEM_SLOT)
        end
    else
        local per = 3.00
        local limit = 60.0 / per -- 一般不会超过1分钟复活
        htime.setInterval(
            per,
            function(t)
                limit = limit - 1
                if (limit < 0) then
                    htime.delTimer(t)
                elseif (his.alive(u) == true) then
                    htime.delTimer(t)
                    local i = 1
                    local it
                    local hasSlot = (cj.GetUnitAbilityLevel(u, hattributeSetter.DEFAULT_SKILL_ITEM_SLOT) >= 1)
                    if (hasSlot == false) then
                        cj.UnitAddAbility(u, hattributeSetter.DEFAULT_SKILL_ITEM_SLOT)
                    end
                    while (i <= qty) do
                        it = cj.CreateItem(itemId, 0, 0)
                        cj.UnitAddItem(u, it)
                        cj.SetWidgetLife(it, 10.00)
                        cj.RemoveItem(it)
                        i = i + 1
                    end
                    if (hasSlot == false) then
                        cj.UnitRemoveAbility(u, hattributeSetter.DEFAULT_SKILL_ITEM_SLOT)
                    end
                end
            end
        )
    end
end

--- hSlk形式的设置最大生命值
---@private
hattributeSetter.setUnitMaxLife = function(whichUnit, currentVal, futureVal)
    local diff = 0
    local level = 0
    if (futureVal >= 999999999) then
        if (currentVal >= 999999999) then
            diff = 0
        else
            diff = 999999999 - currentVal
        end
    elseif (futureVal <= 1) then
        if (currentVal <= 1) then
            diff = 0
        else
            diff = 1 - currentVal
        end
    end
    local tempVal = math.floor(math.abs(diff))
    local max = 100000000
    if (tempVal ~= 0) then
        while (max >= 1) do
            level = math.floor(tempVal / max)
            tempVal = math.floor(tempVal - level * max)
            if (diff > 0) then
                hattributeSetter.relyLifeMana(whichUnit, hslk.attr.life.add[max], level)
            else
                hattributeSetter.relyLifeMana(whichUnit, hslk.attr.life.sub[max], level)
            end
            max = math.floor(max / 10)
        end
    end
end

--- hSlk形式的设置最大魔法值
---@private
hattributeSetter.setUnitMaxMana = function(whichUnit, currentVal, futureVal)
    local diff = 0
    local level = 0
    if (futureVal >= 999999999) then
        if (currentVal >= 999999999) then
            diff = 0
        else
            diff = 999999999 - currentVal
        end
    elseif (futureVal <= 1) then
        if (currentVal <= 1) then
            diff = 0
        else
            diff = 1 - currentVal
        end
    end
    local tempVal = math.floor(math.abs(diff))
    local max = 100000000
    if (tempVal ~= 0) then
        while (max >= 1) do
            level = math.floor(tempVal / max)
            tempVal = math.floor(tempVal - level * max)
            if (diff > 0) then
                hattributeSetter.relyLifeMana(whichUnit, hslk.attr.mana.add[max], level)
            else
                hattributeSetter.relyLifeMana(whichUnit, hslk.attr.mana.sub[max], level)
            end
            max = math.floor(max / 10)
        end
    end
end

--- hSlk形式的设置白字攻击
---@private
hattributeSetter.setUnitAttackWhite = function(whichUnit, futureVal)
    local max = 100000000
    local diff = 0
    if (futureVal > max or futureVal < -max) then
        diff = 0
    end
    local tempVal = math.floor(math.abs(diff))
    if (tempVal ~= 0) then
        while (max >= 1) do
            local level = math.floor(tempVal / max)
            tempVal = math.floor(tempVal - level * max)
            if (diff > 0) then
                hattributeSetter.relyAttackWhite(whichUnit, hslk.attr.item_attack_white.add[max], level)
            else
                hattributeSetter.relyAttackWhite(whichUnit, hslk.attr.item_attack_white.sub[max], level)
            end
            max = math.floor(max / 10)
        end
    end
end