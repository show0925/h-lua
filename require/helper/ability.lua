--- 组装空白被动技能的说明
---@private
slkHelper.abilityEmptyUbertip = function(v)
    local d = {}
    if (v._passive ~= nil) then
        table.insert(d, hColor.mixed("被动：" .. v._passive, slkHelper.conf.color.abilityPassive))
    end
    if (v._attr ~= nil) then
        table.sort(v._attr)
        table.insert(d, hColor.mixed(slkHelper.attrDesc(v._attr, "|n"), slkHelper.conf.color.abilityAttr))
    end
    if (v._desc ~= nil and v._desc ~= "") then
        table.insert(d, hColor.mixed(v._desc, slkHelper.conf.color.abilityDesc))
    end
    return string.implode("|n", d)
end

--- 组装光环技能的说明
---@private
slkHelper.abilityRingUbertip = function(v)
    local d = {}
    if (v._ring.radius ~= nil) then
        table.insert(d, hColor.mixed("光环范围：" .. v._ring.radius, slkHelper.conf.color.ringArea))
    end
    if (type(v._ring.target) == 'table' and #v._ring.target > 0) then
        local labels = {}
        for _, t in ipairs(v._ring.target) do
            table.insert(labels, CONST_TARGET_LABEL[t])
        end
        table.insert(d, hColor.mixed("光环目标：" .. string.implode(',', labels), slkHelper.conf.color.ringTarget))
        labels = nil
    end
    if (v._ring.attr ~= nil) then
        table.insert(d, hColor.mixed("光环效果：|n" .. slkHelper.attrDesc(v._ring.attr, "|n", ' - '), slkHelper.conf.color.ringTarget))
        table.sort(v._ring.attr)
    end
    if (v._attr ~= nil) then
        table.insert(d, hColor.mixed("独占效果：", slkHelper.conf.color.abilityAttr))
        table.sort(v._attr)
        table.insert(d, hColor.mixed(slkHelper.attrDesc(v._attr, "|n", ' - '), slkHelper.conf.color.abilityAttr))
        table.insert(d, "|n")
    end
    if (v._desc ~= nil and v._desc ~= "") then
        table.insert(d, hColor.mixed(v._desc, slkHelper.conf.color.abilityRingDesc))
    end
    return string.implode("|n", d)
end

slkHelper.ability = {
    --- 创建一个空白的被动技能
    --- 设置的 _plugins 数据会自动传到数据中
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
            v.Tip = Name .. "[" .. hColor.mixed(v.Hotkey, slkHelper.conf.color.hotKey) .. "]"
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
        table.insert(slkHelperHashData, table.merge_pairs({
            class = "ability",
            _id = id,
            _name = Name,
            _type = "empty",
            _attr = v._attr,
        }, (v._plugins or {})))
        return id
    end,
    --- 创建一个空白的光环技能
    --- 设置的 _plugins 数据会自动传到数据中
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
            v.Tip = Name .. "[" .. hColor.mixed(v.Hotkey, slkHelper.conf.color.hotKey) .. "]"
            Name = Name .. v.Hotkey
        else
            v.Tip = Name
        end
        if (v._ring == nil) then
            return
        else
            v._ring.effectTarget = v._ring.effectTarget or "Abilities\\Spells\\Other\\GeneralAuraTarget\\GeneralAuraTarget.mdl"
            v._ring.attach = v._ring.attach or "origin"
            v._ring.attachTarget = v._ring.attachTarget or "origin"
            v._ring.radius = v._ring.radius or 600
            -- target请参考物编的目标允许
            local target
            if (type(v._ring.target) == 'table' and #v._ring.target > 0) then
                target = v._ring.target
            elseif (type(v._ring.target) == 'string' and string.len(v._ring.target) > 0) then
                target = string.explode(',', v._ring.target)
            else
                target = { 'air', 'ground', 'friend', 'self', 'vuln', 'invu' }
            end
            v._ring.target = target
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
        table.insert(slkHelperHashData, table.merge_pairs({
            class = "ability",
            _id = id,
            _name = Name,
            _type = "ring",
            _attr = v._attr,
            _ring = v._ring,
        }, (v._plugins or {})))
        return id
    end,
}
