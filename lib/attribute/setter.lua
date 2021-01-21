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
hattributeSetter.regAllAbility = function(whichUnit)
    for _, v in ipairs(hslk.attr.ablis_gradient) do
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
        -- 攻击速度
        if (false == hjapi.check()) then
            cj.UnitAddAbility(whichUnit, hslk.attr.attack_speed.add[v])
            cj.UnitRemoveAbility(whichUnit, hslk.attr.attack_speed.add[v])
            cj.UnitAddAbility(whichUnit, hslk.attr.attack_speed.sub[v])
            cj.UnitRemoveAbility(whichUnit, hslk.attr.attack_speed.sub[v])
        end
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
hattributeSetter.abilityLifeMana = function(u, abilityId, qty)
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
hattributeSetter.abilityAttackWhite = function(u, itemId, qty)
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