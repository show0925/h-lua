hskill = {
    SKILL_TOKEN = string.char2id(hslk.n2i("H_LUA_SKILL_TOKEN")),
    SKILL_LEAP = string.char2id(hslk.n2i("H_LUA_SKILL_LEAP")), --leap的token模式，需导入模型：https://github.com/hunzsig-warcraft3/assets-models/blob/master/interface/interface_token.mdx
    SKILL_BREAK = string.char2id(hslk.n2i("H_LUA_SKILL_BREAK")), --table[0.05~0.5]
    SKILL_SWIM_UNLIMIT = string.char2id(hslk.n2i("H_LUA_SKILL_SWIM_UNLIMIT")),
    SKILL_INVISIBLE = string.char2id(hslk.n2i("H_LUA_SKILL_INVISIBLE")),
    SKILL_AVOID_PLUS = string.char2id(hslk.n2i("H_LUA_SKILL_AVOID_PLUS")),
    SKILL_AVOID_MIUNS = string.char2id(hslk.n2i("H_LUA_SKILL_AVOID_MIUNS")),
    BUFF_SWIM = string.char2id("BPSE"),
    BUFF_INVULNERABLE = string.char2id("Avul")
}

--- 获取属性加成,需要注册
---@param abilityId string|number
---@return table|nil
hskill.getAttribute = function(abilityId)
    if (type(abilityId) == "number") then
        abilityId = string.id2char(abilityId)
    end
    local as = hslk.i2v(abilityId)
    if (as ~= nil) then
        return as._attr
    else
        return nil
    end
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
