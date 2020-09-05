hskill = {
    SKILL_TOKEN = hslk_global.unit_token,
    -- SKILL_LEAP的token模式，需要导入https://github.com/hunzsig-warcraft3/assets-models/blob/master/interface/interface_token.mdx
    SKILL_LEAP = hslk_global.unit_token_leap,
    SKILL_BREAK = hslk_global.skill_break, --table[0.05~0.5]
    SKILL_SWIM_UNLIMIT = hslk_global.skill_swim_unlimit,
    SKILL_INVISIBLE = hslk_global.skill_invisible,
    SKILL_AVOID_PLUS = hslk_global.attr.avoid.add,
    SKILL_AVOID_MIUNS = hslk_global.attr.avoid.sub,
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

--- 获取SLK数据集,需要注册
---@param abilId string|number
---@return table|nil
hskill.getSlk = function(abilId)
    if (abilId == nil) then
        return
    end
    local slk
    local abilityId = abilId
    if (type(abilId) == "number") then
        abilityId = string.id2char(abilId)
    end
    if (hslk_global.id2Value.ability[abilityId] ~= nil) then
        slk = hslk_global.id2Value.ability[abilityId]
    end
    return slk
end

--- 获取属性加成,需要注册
---@param abilId string|number
---@return table|nil
hskill.getAttribute = function(abilId)
    local slk = hskill.getSlk(abilId)
    if (slk ~= nil) then
        return slk.ATTR
    else
        return nil
    end
end

--- 附加单位获得技能后的属性
---@protected
hskill.addProperty = function(whichUnit, abilId)
    hattribute.caleAttribute(true, whichUnit, hskill.getAttribute(abilId), 1)
end
--- 削减单位获得技能后的属性
---@protected
hskill.subProperty = function(whichUnit, abilId)
    hattribute.caleAttribute(false, whichUnit, hskill.getAttribute(abilId), 1)
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


-- 初始化一些方法

-- 沉默
hRuntime.skill.silentTrigger = cj.CreateTrigger()
cj.TriggerAddAction(
    hRuntime.skill.silentTrigger,
    function()
        local u1 = cj.GetTriggerUnit()
        if (table.includes(u1, hRuntime.skill.silentUnits)) then
            cj.IssueImmediateOrder(u1, "stop")
        end
    end
)
-- 缴械
hRuntime.skill.unarmTrigger = cj.CreateTrigger()
cj.TriggerAddAction(
    hRuntime.skill.unarmTrigger,
    function()
        local u1 = cj.GetAttacker()
        if (table.includes(u1, hRuntime.skill.unarmUnits) == true) then
            cj.IssueImmediateOrder(u1, "stop")
        end
    end
)
for i = 1, bj_MAX_PLAYERS, 1 do
    cj.TriggerRegisterPlayerUnitEvent(hRuntime.skill.silentTrigger, cj.Player(i - 1), EVENT_PLAYER_UNIT_SPELL_CHANNEL, nil)
    cj.TriggerRegisterPlayerUnitEvent(hRuntime.skill.unarmTrigger, cj.Player(i - 1), EVENT_PLAYER_UNIT_ATTACKED, nil)
end