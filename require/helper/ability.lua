
--- 组装空白被动技能的说明
---@private
slkHelper.abilityEmptyUbertip = function(v)
    local d = {}
    if (v.PASSIVE ~= nil) then
        table.insert(d, hColor[slkHelper.conf.color.abilityPassive]("被动：" .. v.PASSIVE))
    end
    if (v.ATTR ~= nil) then
        table.sort(v.ATTR)
        table.insert(d, hColor[slkHelper.conf.color.abilityAttr](slkHelper.attrDesc(v.ATTR, "|n")))
    end
    if (v.Desc ~= nil and v.Desc ~= "") then
        table.insert(d, hColor[slkHelper.conf.color.abilityDesc](v.Desc))
    end
    return string.implode("|n", d)
end

--- 组装光环技能的说明
---@private
slkHelper.abilityRingUbertip = function(v)
    local d = {}
    if (v.RING.radius ~= nil) then
        table.insert(d, hColor[slkHelper.conf.color.ringArea]("光环范围：" .. v.RING.radius))
    end
    if (type(v.RING.target) == 'table' and #v.RING.target > 0) then
        local labels = {}
        for _, t in ipairs(v.RING.target) do
            table.insert(labels, CONST_TARGET_LABEL[t])
        end
        table.insert(d, hColor[slkHelper.conf.color.ringTarget]("光环目标：" .. string.implode(',', labels)))
        labels = nil
    end
    if (v.RING.attr ~= nil) then
        table.insert(d, hColor[slkHelper.conf.color.ringTarget]("光环效果：|n" .. slkHelper.attrDesc(v.RING.attr, "|n", ' - ')))
        table.sort(v.RING.attr)
    end
    if (v.ATTR ~= nil) then
        table.insert(d, hColor[slkHelper.conf.color.abilityAttr]("独占效果："))
        table.sort(v.ATTR)
        table.insert(d, hColor[slkHelper.conf.color.abilityAttr](slkHelper.attrDesc(v.ATTR, "|n", ' - ')))
        table.insert(d, "|n")
    end
    if (v.Desc ~= nil and v.Desc ~= "") then
        table.insert(d, hColor[slkHelper.conf.color.abilityRingDesc](v.Desc))
    end
    return string.implode("|n", d)
end

slkHelper.ability = {
    --- 创建一个空白的被动技能
    --- 设置的CUSTOM_DATA数据会自动传到数据中
    ---@public
    ---@param v table
    empty = function(v)
        slkHelper.count = slkHelper.count + 1
        local Name = v.Name or "空白被动-" .. slkHelper.count
        local Art = v.Art or "ReplaceableTextures\\PassiveButtons\\PASBTNStatUp.blp"
        v.Buttonpos1 = v.Buttonpos1 or 0
        v.Buttonpos2 = v.Buttonpos2 or 0
        if (v.Hotkey ~= nil) then
            v.Buttonpos1 = CONST_HOTKEY_ABILITY_KV[v.Hotkey].Buttonpos1 or 0
            v.Buttonpos2 = CONST_HOTKEY_ABILITY_KV[v.Hotkey].Buttonpos2 or 0
            v.Tip = Name .. "[" .. hColor[slkHelper.conf.color.hotKey](v.Hotkey) .. "]"
            Name = Name .. v.Hotkey
        else
            v.Tip = Name
        end
        local obj = slk.ability.Aamk:new("slk_ability_empty_" .. Name)
        obj.Hotkey = v.Hotkey or ""
        obj.Name = Name
        obj.Tip = v.Tip
        obj.Ubertip = slkHelper.abilityEmptyUbertip(v)
        obj.Buttonpos1 = v.Buttonpos1
        obj.Buttonpos2 = v.Buttonpos2
        obj.hero = 0
        obj.levels = 1
        obj.DataA1 = 0
        obj.DataB1 = 0
        obj.DataC1 = 0
        obj.race = v.race or "other"
        obj.Art = Art
        local id = obj:get_id()
        table.insert(slkHelperHashData, {
            type = "ability",
            data = {
                CUSTOM_DATA = v.CUSTOM_DATA or {},
                CLASS_GROUP = v.CLASS_GROUP or nil,
                ABILITY_ID = id,
                ABILITY_TYPE = "empty",
                ATTR = v.ATTR,
                Name = v.Name,
                Art = Art,
            }
        })
        return id
    end,
    --- 创建一个空白的光环技能
    --- 设置的CUSTOM_DATA数据会自动传到数据中
    ---@public
    ---@param v table
    ring = function(v)
        slkHelper.count = slkHelper.count + 1
        local Name = v.Name or "空白光环-" .. slkHelper.count
        local Art = v.Art or "ReplaceableTextures\\PassiveButtons\\PASBTNStatUp.blp"
        v.Buttonpos1 = v.Buttonpos1 or 0
        v.Buttonpos2 = v.Buttonpos2 or 0
        if (v.Hotkey ~= nil) then
            v.Buttonpos1 = CONST_HOTKEY_ABILITY_KV[v.Hotkey].Buttonpos1 or 0
            v.Buttonpos2 = CONST_HOTKEY_ABILITY_KV[v.Hotkey].Buttonpos2 or 0
            v.Tip = Name .. "[" .. hColor[slkHelper.conf.color.hotKey](v.Hotkey) .. "]"
            Name = Name .. v.Hotkey
        else
            v.Tip = Name
        end
        if (v.RING == nil) then
            return
        else
            v.RING.effectTarget = v.RING.effectTarget or "Abilities\\Spells\\Other\\GeneralAuraTarget\\GeneralAuraTarget.mdl"
            v.RING.attach = v.RING.attach or "origin"
            v.RING.attachTarget = v.RING.attachTarget or "origin"
            v.RING.radius = v.RING.radius or 600
            -- target请参考物编的目标允许
            local target
            if (type(v.RING.target) == 'table' and #v.RING.target > 0) then
                target = v.RING.target
            elseif (type(v.RING.target) == 'string' and string.len(v.RING.target) > 0) then
                target = string.explode(',', v.RING.target)
            else
                target = { 'air', 'ground', 'friend', 'self', 'vuln', 'invu' }
            end
            v.RING.target = target
        end
        local obj = slk.ability.Aamk:new("slk_ability_ring_" .. Name)
        obj.Hotkey = v.Hotkey or ""
        obj.Name = Name
        obj.Tip = v.Tip
        obj.Ubertip = slkHelper.abilityRingUbertip(v)
        obj.Buttonpos1 = v.Buttonpos1
        obj.Buttonpos2 = v.Buttonpos2
        obj.hero = 0
        obj.levels = 1
        obj.DataA1 = 0
        obj.DataB1 = 0
        obj.DataC1 = 0
        obj.race = v.race or "other"
        obj.Art = Art
        local id = obj:get_id()
        table.insert(slkHelperHashData, {
            type = "ability",
            data = {
                CUSTOM_DATA = v.CUSTOM_DATA or {},
                CLASS_GROUP = v.CLASS_GROUP or nil,
                ABILITY_ID = id,
                ABILITY_TYPE = "ring",
                ATTR = v.ATTR,
                RING = v.RING,
                Name = v.Name,
                Art = Art,
            }
        })
        return id
    end,
}
