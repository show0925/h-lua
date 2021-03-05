hskill = {}

--- 获取属性加成,需要注册
---@param abilityId string|number
---@return table|nil
hskill.getAttribute = function(abilityId)
    if (type(abilityId) == "number") then
        abilityId = string.id2char(abilityId)
    end
    return hslk.i2v(abilityId, "_attr")
end

--- 附加单位获得技能后的属性
---@protected
hskill.addProperty = function(whichUnit, abilityId)
    hattribute.caleAttribute(CONST_DAMAGE_SRC.skill, true, whichUnit, hskill.getAttribute(abilityId), 1)
    hring.insert(whichUnit, abilityId)
end
--- 削减单位获得技能后的属性
---@protected
hskill.subProperty = function(whichUnit, abilityId)
    hattribute.caleAttribute(CONST_DAMAGE_SRC.skill, false, whichUnit, hskill.getAttribute(abilityId), 1)
    hring.remove(whichUnit, abilityId)
end

--- 添加技能
---@param whichUnit userdata
---@param abilityId string|number
---@param during number
hskill.add = function(whichUnit, abilityId, during)
    local id = abilityId
    if (type(abilityId) == "string") then
        id = string.char2id(id)
    end
    if (during == nil or during <= 0) then
        cj.UnitAddAbility(whichUnit, id)
        cj.UnitMakeAbilityPermanent(whichUnit, true, id)
        hskill.addProperty(whichUnit, id)
    else
        cj.UnitAddAbility(whichUnit, id)
        hskill.addProperty(whichUnit, id)
        htime.setTimeout(during, function(t)
            htime.delTimer(t)
            cj.UnitRemoveAbility(whichUnit, id)
            hskill.subProperty(whichUnit, id)
        end)
    end
end

--- 删除技能
---@param whichUnit userdata
---@param abilityId string|number
---@param delay number
hskill.del = function(whichUnit, abilityId, delay)
    local id = abilityId
    if (type(abilityId) == "string") then
        id = string.char2id(id)
    end
    if (delay == nil or delay <= 0) then
        cj.UnitRemoveAbility(whichUnit, id)
        hskill.subProperty(whichUnit, id)
    else
        cj.UnitRemoveAbility(whichUnit, id)
        hskill.subProperty(whichUnit, id)
        htime.setTimeout(delay, function(t)
            htime.delTimer(t)
            cj.UnitAddAbility(whichUnit, id)
            hskill.addProperty(whichUnit, id)
        end)
    end
end

--- 设置技能的永久使用性
---@param whichUnit userdata
---@param abilityId string|number
hskill.forever = function(whichUnit, abilityId)
    local id = abilityId
    if (type(abilityId) == "string") then
        id = string.char2id(id)
    end
    cj.UnitMakeAbilityPermanent(whichUnit, true, id)
end

--- 是否拥有技能
---@param whichUnit userdata
---@param abilityId string|number
hskill.has = function(whichUnit, abilityId)
    if (whichUnit == nil or abilityId == nil) then
        return false
    end
    local id = abilityId
    if (type(abilityId) == "string") then
        id = string.char2id(id)
    end
    if (cj.GetUnitAbilityLevel(whichUnit, id) >= 1) then
        return true
    end
    return false
end
