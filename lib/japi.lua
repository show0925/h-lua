hjapi = {}

---@private
---@param methods table<string>
---@param trueAction function
---@return boolean
hjapi.check = function(methods, trueAction)
    if (japi == nil) then
        return false
    end
    if (type(methods) ~= 'table') then
        return false
    end
    local lose = {}
    for _, m in ipairs(methods) do
        if (japi[m] == nil) then
            table.insert(lose, m)
            break
        end
    end
    if (#lose > 0) then
        if (type(trueAction) == 'function') then
            print("JAPI Method not exist: " .. string.implode(', ', lose))
        end
        return false
    end
    if (type(trueAction) == 'function') then
        trueAction()
    end
    return true
end

--- [JAPI]设置单位的基础攻击（白字）
---@param whichUnit userdata
---@param value number
---@return boolean
hjapi.setUnitAttackWhite = function(whichUnit, value)
    return hjapi.check({ 'SetUnitState' }, function()
        japi.SetUnitState(whichUnit, cj.ConvertUnitState(0x12), value)
    end)
end

--- [JAPI]设置单位的附加攻击（白字）
---@param whichUnit userdata
---@param value number
---@return boolean
hjapi.setUnitAttackGreen = function(whichUnit, value)
    return hjapi.check({ 'SetUnitState' }, function()
        japi.SetUnitState(whichUnit, cj.ConvertUnitState(0x13), value)
    end)
end

--- [JAPI]设置单位的攻击范围
---@param whichUnit userdata
---@param value number
---@return boolean
hjapi.setUnitAttackRange = function(whichUnit, value)
    return hjapi.check({ 'SetUnitState' }, function()
        japi.SetUnitState(whichUnit, cj.ConvertUnitState(0x16), value)
    end)
end

--- [JAPI]设置单位的攻击速度
---@param whichUnit userdata
---@param value number
---@return boolean
hjapi.setUnitAttackSpeed = function(whichUnit, value)
    return hjapi.check({ 'SetUnitState' }, function()
        japi.SetUnitState(whichUnit, cj.ConvertUnitState(0x51), value)
    end)
end

--- [JAPI]设置单位的攻击间隔
---@param whichUnit userdata
---@param value number
---@return boolean
hjapi.setUnitAttackSpace = function(whichUnit, value)
    return hjapi.check({ 'SetUnitState' }, function()
        japi.SetUnitState(whichUnit, cj.ConvertUnitState(0x25), value)
    end)
end

--- [JAPI]设置单位的护甲
---@param whichUnit userdata
---@param value number
---@return boolean
hjapi.setUnitDefendWhite = function(whichUnit, value)
    return hjapi.check({ 'SetUnitState' }, function()
        local defend_green = hattribute.get(whichUnit, 'defend_green') or 0
        japi.SetUnitState(whichUnit, cj.ConvertUnitState(0x20), value + defend_green)

    end)
end

--- [JAPI]设置单位的最大生命值
---@param whichUnit userdata
---@param value number
---@return boolean
hjapi.setUnitMaxLife = function(whichUnit, value)
    return hjapi.check({ 'SetUnitState' }, function()
        local cur = math.max(0, hunit.getCurLife(whichUnit))
        local max = hunit.getMaxLife(whichUnit)
        if (max <= 0) then
            japi.SetUnitState(whichUnit, UNIT_STATE_MAX_LIFE, value)
            japi.SetUnitState(whichUnit, UNIT_STATE_LIFE, value)
        else
            local percent = math.min(1, math.round(cur / max))
            japi.SetUnitState(whichUnit, UNIT_STATE_MAX_LIFE, value)
            japi.SetUnitState(whichUnit, UNIT_STATE_LIFE, value * percent)
        end
    end)
end

--- [JAPI]设置单位的最大魔法值
---@param whichUnit userdata
---@param value number
---@return boolean
hjapi.setUnitMaxMana = function(whichUnit, value)
    return hjapi.check({ 'SetUnitState' }, function()
        local cur = math.max(0, hunit.getCurMana(whichUnit))
        local max = hunit.getMaxMana(whichUnit)
        if (max <= 0) then
            japi.SetUnitState(whichUnit, UNIT_STATE_MAX_MANA, value)
            japi.SetUnitState(whichUnit, UNIT_STATE_MANA, value)
        else
            local percent = math.min(1, math.round(cur / max))
            japi.SetUnitState(whichUnit, UNIT_STATE_MAX_MANA, value)
            japi.SetUnitState(whichUnit, UNIT_STATE_MANA, value * percent)
        end
    end)
end

--- [JAPI]设置单位某个技能的冷却时间
---@param whichUnit userdata
---@param abilityID string|number
---@param cooldown number
---@return boolean
hjapi.setUnitAbilityCooldown = function(whichUnit, abilityID, cooldown)
    return hjapi.check({ 'EXSetAbilityState', 'EXGetUnitAbility' }, function()
        if (type(abilityID) == 'string') then
            abilityID = string.char2id(abilityID)
        end
        japi.EXSetAbilityState(japi.EXGetUnitAbility(whichUnit, abilityID), 1, cooldown)
    end)
end