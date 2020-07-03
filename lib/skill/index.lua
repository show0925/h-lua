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

--- 计算单位加减技能的属性影响
---@private
hskill.caleAttribute = function(isAdd, whichUnit, abilId)
    if (isAdd == nil) then
        isAdd = true
    end
    local attr = hskill.getAttribute(abilId)
    if (attr == nil) then
        return
    end
    local diff = {}
    local diffPlayer = {}
    for _, arr in ipairs(table.obj2arr(attr, CONST_ATTR_KEYS)) do
        local k = arr.key
        local v = arr.value
        local typev = type(v)
        local tempDiff
        if (k == "attack_damage_type") then
            local opt = "+"
            if (isAdd == false) then
                opt = "-"
            end
            local nv
            if (typev == "string") then
                opt = string.sub(v, 1, 1) or "+"
                nv = string.sub(v, 2)
            elseif (typev == "table") then
                nv = string.implode(",", v)
            end
            tempDiff = opt .. nv
        elseif (typev == "string") then
            local opt = string.sub(v, 1, 1)
            local nv = tonumber(string.sub(v, 2))
            if (isAdd == false) then
                if (opt == "+") then
                    opt = "-"
                else
                    opt = "+"
                end
            end
            tempDiff = opt .. nv
        elseif (typev == "number") then
            if ((v > 0 and isAdd == true) or (v < 0 and isAdd == false)) then
                tempDiff = "+" .. v
            elseif (v < 0) then
                tempDiff = "-" .. v
            end
        elseif (typev == "table") then
            local tempTable = {}
            for _, vv in ipairs(v) do
                table.insert(tempTable, vv)
            end
            local opt = "add"
            if (isAdd == false) then
                opt = "sub"
            end
            tempDiff = {
                [opt] = tempTable
            }
        end
        if (table.includes(k, { "gold_ratio", "lumber_ratio", "exp_ratio", "sell_ratio" })) then
            table.insert(diffPlayer, { k, tonumber(tempDiff) })
        else
            diff[k] = tempDiff
        end
    end
    hattr.set(whichUnit, 0, diff)
    if (#diffPlayer > 0) then
        local p = hunit.getOwner(whichUnit)
        for _, dp in ipairs(diffPlayer) do
            local pk = dp[1]
            local pv = dp[2]
            if (pv ~= 0) then
                if (pk == "gold_ratio") then
                    hplayer.addGoldRatio(p, pv, 0)
                elseif (pk == "lumber_ratio") then
                    hplayer.addLumberRatio(p, pv, 0)
                elseif (pk == "exp_ratio") then
                    hplayer.addExpRatio(p, pv, 0)
                elseif (pk == "sell_ratio") then
                    hplayer.addSellRatio(p, pv, 0)
                end
            end
        end
    end
end
--- 附加单位获得物品后的属性
---@protected
hskill.addAttribute = function(whichUnit, abilId)
    hskill.caleAttribute(true, whichUnit, abilId)
end
--- 削减单位获得物品后的属性
---@protected
hskill.subAttribute = function(whichUnit, abilId)
    hskill.caleAttribute(false, whichUnit, abilId)
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
        hskill.addAttribute(whichUnit, id)
    else
        cj.UnitAddAbility(whichUnit, id)
        hskill.addAttribute(whichUnit, id)
        htime.setTimeout(
            during,
            function(t)
                cj.UnitRemoveAbility(whichUnit, id)
                hskill.subAttribute(whichUnit, id)
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
        hskill.subAttribute(whichUnit, id)
    else
        cj.UnitRemoveAbility(whichUnit, id)
        hskill.subAttribute(whichUnit, id)
        htime.setTimeout(
            delay,
            function(t)
                cj.UnitAddAbility(whichUnit, id)
                hskill.addAttribute(whichUnit, id)
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
for i = 1, bj_MAX_PLAYER_SLOTS, 1 do
    cj.TriggerRegisterPlayerUnitEvent(hRuntime.skill.silentTrigger, cj.Player(i - 1), EVENT_PLAYER_UNIT_SPELL_CHANNEL, nil)
    cj.TriggerRegisterPlayerUnitEvent(hRuntime.skill.unarmTrigger, cj.Player(i - 1), EVENT_PLAYER_UNIT_ATTACKED, nil)
end