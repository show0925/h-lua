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

--- [JAPI]设置单位的最大生命值
---@param whichUnit userdata
---@param value number
---@return boolean
hjapi.setUnitMaxLife = function(whichUnit, value)
    return hjapi.check({ 'SetUnitState' }, function()
        japi.SetUnitState(whichUnit, UNIT_STATE_MAX_LIFE, value)
    end)
end

--- [JAPI]设置单位的最大魔法值
---@param whichUnit userdata
---@param value number
---@return boolean
hjapi.setUnitMaxMana = function(whichUnit, value)
    return hjapi.check({ 'SetUnitState' }, function()
        japi.SetUnitState(whichUnit, UNIT_STATE_MAX_MANA, value)
    end)
end