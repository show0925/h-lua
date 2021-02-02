hskill = {
    SKILL_TOKEN = hslk.unit_token,
    SKILL_LEAP = hslk.unit_token_leap, --leap的token模式，需导入模型：https://github.com/hunzsig-warcraft3/assets-models/blob/master/interface/interface_token.mdx
    SKILL_BREAK = hslk.skill_break, --table[0.05~0.5]
    SKILL_SWIM_UNLIMIT = hslk.skill_swim_unlimit,
    SKILL_INVISIBLE = hslk.skill_invisible,
    SKILL_AVOID_PLUS = hslk.attr.avoid.add,
    SKILL_AVOID_MIUNS = hslk.attr.avoid.sub,
    BUFF_SWIM = string.char2id("BPSE"),
    BUFF_INVULNERABLE = string.char2id("Avul")
}

---@private
hskill.set = function(handle, key, val)
    if (handle == nil or key == nil) then
        return
    end
    if (hRuntime.skill[handle] == nil) then
        hRuntime.skill[handle] = {}
    end
    hRuntime.skill[handle][key] = val
end

---@private
hskill.get = function(handle, key, defaultVal)
    if (handle == nil or key == nil) then
        return defaultVal
    end
    if (hRuntime.skill[handle] == nil or hRuntime.skill[handle][key] == nil) then
        return defaultVal
    end
    return hRuntime.skill[handle][key]
end

--- 获取原生SLK数据集
---@param abilityId string|number
---@return table|nil
hskill.getSlk = function(abilityId)
    if (abilityId == nil) then
        return
    end
    if (type(abilityId) == "number") then
        abilityId = string.id2char(abilityId)
    end
    return slk.ability[abilityId]
end

--- 获取HSLK数据集
---@param idOrName string|number
---@return table|nil
hskill.getHSlk = function(idOrName)
    if (idOrName == nil) then
        return
    end
    local id = idOrName
    if (type(idOrName) == "number") then
        id = string.id2char(idOrName)
    end
    if (hslk.i2v.ability[id]) then
        return hslk.i2v.ability[id]
    elseif (hslk.n2v.ability[id]) then
        return hslk.n2v.ability[id]
    end
    return nil
end

--- 获取属性加成,需要注册
---@param abilityId string|number
---@return table|nil
hskill.getAttribute = function(abilityId)
    if (type(abilityId) == "number") then
        abilityId = string.id2char(abilityId)
    end
    local slk = hslk.i2v.ability[abilityId]
    if (slk ~= nil) then
        return slk._attr
    else
        return nil
    end
end

--- 根据技能名称获取技能ID字符串
---@param name string
---@return string
hskill.n2i = function(name)
    if (hslk.n2v.ability[name] ~= nil) then
        return hslk.n2v.ability[name]._id
    end
    return nil
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
        htime.setTimeout(
            during,
            function(t)
                cj.UnitRemoveAbility(whichUnit, id)
                hskill.subProperty(whichUnit, id)
            end
        )
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
        htime.setTimeout(
            delay,
            function(t)
                cj.UnitAddAbility(whichUnit, id)
                hskill.addProperty(whichUnit, id)
            end
        )
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
