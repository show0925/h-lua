---@class hattributeSetter 属性配置法
hattributeSetter = {
    smart = {
        attack_space = "attack_space_origin",
        attack = "attack_green",
        defend = "defend_green",
        str = "str_green",
        agi = "agi_green",
        int = "int_green",
        sight_day = "sight",
        sight_night = "sight",
    },
}

--- @private
hattributeSetter.getDecimalTemporaryStorage = function(whichUnit, attr)
    local diff = hcache.get(whichUnit, CONST_CACHE.ATTR_DEC_TEM, {})
    return diff[attr] or 0
end

--- @private
hattributeSetter.setDecimalTemporaryStorage = function(whichUnit, attr, value)
    local diff = hcache.get(whichUnit, CONST_CACHE.ATTR_DEC_TEM, {})
    diff[attr] = math.round(value)
    hcache.set(whichUnit, CONST_CACHE.ATTR_DEC_TEM, diff)
end

--- 为单位注册属性系统所需要的基础技能
--- hslk.attr
---@private
hattributeSetter.relyRegister = function(whichUnit)
    for _, v in ipairs(HL_ID.ablis_gradient) do
        -- 绿字攻击
        cj.UnitAddAbility(whichUnit, HL_ID.attack_green.add[v])
        cj.UnitRemoveAbility(whichUnit, HL_ID.attack_green.add[v])
        cj.UnitAddAbility(whichUnit, HL_ID.attack_green.sub[v])
        cj.UnitRemoveAbility(whichUnit, HL_ID.attack_green.sub[v])
        -- 绿色属性
        cj.UnitAddAbility(whichUnit, HL_ID.str_green.add[v])
        cj.UnitRemoveAbility(whichUnit, HL_ID.str_green.add[v])
        cj.UnitAddAbility(whichUnit, HL_ID.str_green.sub[v])
        cj.UnitRemoveAbility(whichUnit, HL_ID.str_green.sub[v])
        cj.UnitAddAbility(whichUnit, HL_ID.agi_green.add[v])
        cj.UnitRemoveAbility(whichUnit, HL_ID.agi_green.add[v])
        cj.UnitAddAbility(whichUnit, HL_ID.agi_green.sub[v])
        cj.UnitRemoveAbility(whichUnit, HL_ID.agi_green.sub[v])
        cj.UnitAddAbility(whichUnit, HL_ID.int_green.add[v])
        cj.UnitRemoveAbility(whichUnit, HL_ID.int_green.add[v])
        cj.UnitAddAbility(whichUnit, HL_ID.int_green.sub[v])
        cj.UnitRemoveAbility(whichUnit, HL_ID.int_green.sub[v])
        -- 防御
        cj.UnitAddAbility(whichUnit, HL_ID.defend.add[v])
        cj.UnitRemoveAbility(whichUnit, HL_ID.defend.add[v])
        cj.UnitAddAbility(whichUnit, HL_ID.defend.sub[v])
        cj.UnitRemoveAbility(whichUnit, HL_ID.defend.sub[v])
    end
    for _, v in ipairs(HL_ID.sight_gradient) do
        -- 视野
        cj.UnitAddAbility(whichUnit, HL_ID.sight.add[v])
        cj.UnitRemoveAbility(whichUnit, HL_ID.sight.add[v])
        cj.UnitAddAbility(whichUnit, HL_ID.sight.sub[v])
        cj.UnitRemoveAbility(whichUnit, HL_ID.sight.sub[v])
    end
end

--- hSlk形式的设置最大生命值
---@private
hattributeSetter.setUnitMaxLife = function(whichUnit, currentVal, futureVal, diff)
    if (futureVal >= 999999999) then
        futureVal = 999999999
    elseif (futureVal < 1) then
        futureVal = 1
    end
    local cur = math.max(0, hunit.getCurLife(whichUnit))
    local max = hunit.getMaxLife(whichUnit)
    if (max <= 0) then
        hjapi.SetUnitState(whichUnit, UNIT_STATE_MAX_LIFE, futureVal)
        hjapi.SetUnitState(whichUnit, UNIT_STATE_LIFE, futureVal)
    else
        local percent = math.min(1, math.round(cur / max))
        hjapi.SetUnitState(whichUnit, UNIT_STATE_MAX_LIFE, futureVal)
        hjapi.SetUnitState(whichUnit, UNIT_STATE_LIFE, futureVal * percent)
    end
end

--- hSlk形式的设置最大魔法值
---@private
hattributeSetter.setUnitMaxMana = function(whichUnit, currentVal, futureVal, diff)
    if (futureVal >= 999999999) then
        futureVal = 999999999
    elseif (futureVal < 1) then
        futureVal = 1
    end
    local cur = math.max(0, hunit.getCurMana(whichUnit))
    local max = hunit.getMaxMana(whichUnit)
    if (max <= 0) then
        hjapi.SetUnitState(whichUnit, UNIT_STATE_MAX_MANA, futureVal)
        hjapi.SetUnitState(whichUnit, UNIT_STATE_MANA, futureVal)
    else
        local percent = math.min(1, math.round(cur / max))
        hjapi.SetUnitState(whichUnit, UNIT_STATE_MAX_MANA, futureVal)
        hjapi.SetUnitState(whichUnit, UNIT_STATE_MANA, futureVal * percent)
    end
end

--- hSlk形式的设置白字攻击
---@private
hattributeSetter.setUnitAttackWhite = function(whichUnit, futureVal, diff)
    local max = 100000000
    if (futureVal > max) then
        futureVal = max
        diff = 0
    elseif (futureVal < -max) then
        futureVal = -max
        diff = 0
    end
    hjapi.SetUnitState(whichUnit, UNIT_STATE_ATTACK_WHITE, futureVal)
end

--- hSlk形式的设置绿字攻击
---@private
hattributeSetter.setUnitAttackGreen = function(whichUnit, futureVal)
    if (futureVal < -99999999) then
        futureVal = -99999999
    elseif (futureVal > 99999999) then
        futureVal = 99999999
    end
    for _, grad in ipairs(HL_ID.ablis_gradient) do
        if (cj.GetUnitAbilityLevel(whichUnit, HL_ID.attack_green.add[grad]) > 1) then
            cj.SetUnitAbilityLevel(whichUnit, HL_ID.attack_green.add[grad], 1)
        end
        if (cj.GetUnitAbilityLevel(whichUnit, HL_ID.attack_green.sub[grad]) > 1) then
            cj.SetUnitAbilityLevel(whichUnit, HL_ID.attack_green.sub[grad], 1)
        end
    end
    local tempVal = math.floor(math.abs(futureVal))
    local max = 100000000
    if (tempVal ~= 0) then
        while (max >= 1) do
            local level = math.floor(tempVal / max)
            tempVal = math.floor(tempVal - level * max)
            if (futureVal > 0) then
                if (cj.GetUnitAbilityLevel(whichUnit, HL_ID.attack_green.add[max]) < 1) then
                    cj.UnitAddAbility(whichUnit, HL_ID.attack_green.add[max])
                end
                cj.SetUnitAbilityLevel(whichUnit, HL_ID.attack_green.add[max], level + 1)
            else
                if (cj.GetUnitAbilityLevel(whichUnit, HL_ID.attack_green.sub[max]) < 1) then
                    cj.UnitAddAbility(whichUnit, HL_ID.attack_green.sub[max])
                end
                cj.SetUnitAbilityLevel(whichUnit, HL_ID.attack_green.sub[max], level + 1)
            end
            max = math.floor(max / 10)
        end
    end
end

--- JAPI形式的设置攻击范围
---@private
hattributeSetter.setUnitAttackRange = function(whichUnit, futureVal)
    if (futureVal < 0) then
        futureVal = 0
    elseif (futureVal > 9999) then
        futureVal = 9999
    end
    return hjapi.SetUnitState(whichUnit, UNIT_STATE_ATTACK_RANGE, futureVal)
end

--- JAPI形式的设置攻击间隔
---@private
hattributeSetter.setUnitAttackSpace = function(whichUnit, futureVal)
    if (futureVal > 30) then
        futureVal = 30.00
    elseif (futureVal < 0.1) then
        futureVal = 0.1
    end
    hjapi.SetUnitState(whichUnit, UNIT_STATE_ATTACK_SPACE, futureVal)
end

--- JAPI+hSlk设置单位的攻击速度
---@private
hattributeSetter.setUnitAttackSpeed = function(whichUnit, futureVal)
    if (futureVal > 400) then
        futureVal = 400
    elseif (futureVal < -80) then
        futureVal = -80
    end
    hjapi.SetUnitState(whichUnit, UNIT_STATE_ATTACK_SPEED, 1 + futureVal * 0.01)
end

--- JAPI形式的设置白字护甲
---@private
hattributeSetter.setUnitDefendWhite = function(whichUnit, futureVal)
    if (futureVal < -99999999) then
        futureVal = -99999999
    elseif (futureVal > 99999999) then
        futureVal = 99999999
    end
    local defend_green = hattribute.get(whichUnit, 'defend_green')
    hjapi.SetUnitState(whichUnit, UNIT_STATE_DEFEND_WHITE, futureVal + defend_green)
end

--- hSlk形式的设置绿字护甲
---@private
hattributeSetter.setUnitDefendGreen = function(whichUnit, futureVal)
    if (futureVal < -99999999) then
        futureVal = -99999999
    elseif (futureVal > 99999999) then
        futureVal = 99999999
    end
    for _, grad in ipairs(HL_ID.ablis_gradient) do
        local ab = HL_ID.defend.add[grad]
        if (cj.GetUnitAbilityLevel(whichUnit, ab) > 1) then
            cj.SetUnitAbilityLevel(whichUnit, ab, 1)
        end
        ab = HL_ID.defend.sub[grad]
        if (cj.GetUnitAbilityLevel(whichUnit, ab) > 1) then
            cj.SetUnitAbilityLevel(whichUnit, ab, 1)
        end
    end
    local tempVal = math.floor(math.abs(futureVal))
    local max = 100000000
    if (tempVal ~= 0) then
        while (max >= 1) do
            local level = math.floor(tempVal / max)
            tempVal = math.floor(tempVal - level * max)
            if (futureVal > 0) then
                if (cj.GetUnitAbilityLevel(whichUnit, HL_ID.defend.add[max]) < 1) then
                    cj.UnitAddAbility(whichUnit, HL_ID.defend.add[max])
                end
                cj.SetUnitAbilityLevel(whichUnit, HL_ID.defend.add[max], level + 1)
            else
                if (cj.GetUnitAbilityLevel(whichUnit, HL_ID.defend.sub[max]) < 1) then
                    cj.UnitAddAbility(whichUnit, HL_ID.defend.sub[max])
                end
                cj.SetUnitAbilityLevel(whichUnit, HL_ID.defend.sub[max], level + 1)
            end
            max = math.floor(max / 10)
        end
    end
end

--- hSlk形式的设置视野
---@private
hattributeSetter.setUnitSight = function(whichUnit, futureVal)
    for _, gradient in ipairs(HL_ID.sight_gradient) do
        cj.UnitRemoveAbility(whichUnit, HL_ID.sight.add[gradient])
        cj.UnitRemoveAbility(whichUnit, HL_ID.sight.sub[gradient])
    end
    local tempVal = math.floor(math.abs(futureVal))
    local sight_gradient = table.clone(HL_ID.sight_gradient)
    if (tempVal ~= 0) then
        while (true) do
            local found = false
            for _, v in ipairs(sight_gradient) do
                if (tempVal >= v) then
                    tempVal = math.floor(tempVal - v)
                    table.delete(sight_gradient, v)
                    if (futureVal > 0) then
                        cj.UnitAddAbility(whichUnit, HL_ID.sight.add[v])
                    else
                        cj.UnitAddAbility(whichUnit, HL_ID.sight.sub[v])
                    end
                    found = true
                    break
                end
            end
            if (found == false) then
                break
            end
        end
    end
end

--- hSlk形式的设置白绿三围属性
---@private
hattributeSetter.setUnitThree = function(whichUnit, futureVal, attr, diff)
    if (false == his.hero(whichUnit)) then
        return
    end
    local thumb = string.sub(attr, 1, 3)
    if (attr == "str_white") then
        cj.SetHeroStr(whichUnit, math.floor(futureVal), true)
    elseif (attr == "agi_white") then
        cj.SetHeroAgi(whichUnit, math.floor(futureVal), true)
    elseif (attr == "int_white") then
        cj.SetHeroInt(whichUnit, math.floor(futureVal), true)
    else
        if (futureVal < -99999999) then
            futureVal = -99999999
        elseif (futureVal > 99999999) then
            futureVal = 99999999
        end
        for _, grad in ipairs(HL_ID.ablis_gradient) do
            local ab = HL_ID[attr].add[grad]
            if (cj.GetUnitAbilityLevel(whichUnit, ab) > 1) then
                cj.SetUnitAbilityLevel(whichUnit, ab, 1)
            end
            ab = HL_ID[attr].sub[grad]
            if (cj.GetUnitAbilityLevel(whichUnit, ab) > 1) then
                cj.SetUnitAbilityLevel(whichUnit, ab, 1)
            end
        end
        local tempVal = math.floor(math.abs(futureVal))
        local max = 100000000
        if (tempVal ~= 0) then
            while (max >= 1) do
                local level = math.floor(tempVal / max)
                tempVal = math.floor(tempVal - level * max)
                if (futureVal > 0) then
                    if (cj.GetUnitAbilityLevel(whichUnit, HL_ID[attr].add[max]) < 1) then
                        cj.UnitAddAbility(whichUnit, HL_ID[attr].add[max])
                    end
                    cj.SetUnitAbilityLevel(whichUnit, HL_ID[attr].add[max], level + 1)
                else
                    if (cj.GetUnitAbilityLevel(whichUnit, HL_ID[attr].sub[max]) < 1) then
                        cj.UnitAddAbility(whichUnit, HL_ID[attr].sub[max])
                    end
                    cj.SetUnitAbilityLevel(whichUnit, HL_ID[attr].sub[max], level + 1)
                end
                max = math.floor(max / 10)
            end
        end
    end
end

---@private
hattributeSetter.relation = function(whichUnit, attr, diff)
    local three --三围标志
    if (table.includes({ "str_white", "agi_white", "int_white", "str_green", "agi_green", "int_green" }, attr)) then
        three = string.sub(attr, 1, 3)
    end
    if (three ~= nil and his.hero(whichUnit)) then
        -- 主属性影响(<= 0自动忽略)
        if (hattribute.RELATION.primary > 0) then
            if (string.upper(three) == hhero.getPrimary(whichUnit)) then
                hattribute.set(whichUnit, 0, { attack_white = "+" .. diff * hattribute.RELATION.primary })
            end
        end
        -- 三围影响
        if (hattribute.RELATION[three] ~= nil) then
            for _, d in ipairs(table.obj2arr(hattribute.RELATION[three], CONST_ATTR_KEYS)) do
                local tempV = diff * d.value
                if (tempV < 0) then
                    hattribute.set(whichUnit, 0, { [d.key] = "-" .. math.abs(tempV) })
                elseif (tempV > 0) then
                    hattribute.set(whichUnit, 0, { [d.key] = "+" .. tempV })
                end
            end
        end
    end
    -- 自定义属性影响
    if (type(hattribute.RELATION[attr]) == "table") then
        for _, d in ipairs(table.obj2arr(hattribute.RELATION[attr], CONST_ATTR_KEYS)) do
            local tempV = diff * d.value
            if (tempV < 0) then
                hattribute.set(whichUnit, 0, { [d.key] = "-" .. math.abs(tempV) })
            elseif (tempV > 0) then
                hattribute.set(whichUnit, 0, { [d.key] = "+" .. tempV })
            end
        end
    end
end