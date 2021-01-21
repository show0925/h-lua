--- 组装物品的描述
---@private
slkHelper.itemDesc = function(v)
    local d = {}
    if (v._active ~= nil) then
        table.insert(d, "主动：" .. v._active)
    end
    if (v._passive ~= nil) then
        table.insert(d, "被动：" .. v._passive)
    end
    if (v._attr ~= nil) then
        table.insert(d, slkHelper.attrDesc(v._attr, ";"))
    end
    -- 仅文本无效果，适用于例如技能书这类的物品
    if (v._attr_txt ~= nil) then
        table.insert(d, slkHelper.attrDesc(v._attr_txt, ";"))
    end
    local overlie = v._overlie or 1
    local weight = v._weight or 0
    weight = tostring(math.round(weight))
    table.insert(d, "叠加：" .. overlie .. ";重量：" .. weight .. "Kg")
    if (v._desc ~= nil and v._desc ~= "") then
        table.insert(d, v._desc)
    end
    return string.implode("|n", d)
end

--- 组装物品的说明
---@private
slkHelper.itemUbertip = function(v)
    local d = {}
    if (v._active ~= nil) then
        table.insert(d, hColor.mixed("主动：" .. v._active, slkHelper.conf.color.itemActive))
        if (v.cooldown ~= nil and v.cooldown > 0) then
            table.insert(d, hColor.mixed("冷却：" .. v.cooldown .. "秒", slkHelper.conf.color.itemCoolDown))
        end
    end
    if (v._passive ~= nil) then
        table.insert(d, hColor.mixed("被动：" .. v._passive, slkHelper.conf.color.itemPassive))
    end
    if (v._ring ~= nil) then
        if (v._ring.attr ~= nil and v._ring.radius ~= nil and (type(v._ring.target) == 'table' and #v._ring.target > 0)) then
            local txt = "光环：[" .. v._ring.radius .. 'px]'
            ----目标(物品太长不显示)
            --local labels = {}
            --for _, t in ipairs(v._ring.target) do
            --    table.insert(labels, CONST_TARGET_LABEL[t])
            --end
            --txt = txt .. '[' .. string.implode(',', labels) .. ']'
            txt = txt .. "|n"
            table.insert(d, hColor.mixed(txt .. slkHelper.attrDesc(v._ring.attr, "|n", ' - '), slkHelper.conf.color.ringTarget))
        end
    end
    if (v._attr ~= nil) then
        table.insert(d, hColor.mixed(slkHelper.attrDesc(v._attr, "|n"), slkHelper.conf.color.itemAttr))
    end
    -- 仅文本无效果，适用于例如技能书这类的物品
    if (v._attr_txt ~= nil) then
        table.insert(d, hColor.mixed(slkHelper.attrDesc(v._attr_txt, "|n"), slkHelper.conf.color.itemAttr))
    end
    -- 作为零件
    if (slkHelper.item.synthesisMapping.fragment[v.Name] ~= nil
        and #slkHelper.item.synthesisMapping.fragment[v.Name] > 0) then
        table.insert(d, hColor.mixed("可以合成：" .. string.implode(
            '、',
            slkHelper.item.synthesisMapping.fragment[v.Name]),
            slkHelper.conf.color.itemFragment
        ))
    end
    -- 合成公式
    if (slkHelper.item.synthesisMapping.profit[v.Name] ~= nil) then
        table.insert(d, hColor.mixed("需要零件：" .. slkHelper.item.synthesisMapping.profit[v.Name], slkHelper.conf.color.itemProfit))
    end
    local overlie = v._overlie or 1
    table.insert(d, hColor.mixed("叠加：" .. overlie, slkHelper.conf.color.itemOverlie))
    local weight = v._weight or 0
    weight = tostring(math.round(weight))
    table.insert(d, hColor.mixed("重量：" .. weight .. "Kg", slkHelper.conf.color.itemWeight))
    if (v._desc ~= nil and v._desc ~= "") then
        table.insert(d, hColor.mixed(v._desc, slkHelper.conf.color.itemDesc))
    end
    return string.implode("|n", d)
end

--- 创建一件物品的冷却技能
---@private
slkHelper.itemCooldown0ID = nil
slkHelper.itemCooldownID0 = function()
    if (slkHelper.itemCooldown0ID == nil) then
        local oobTips = "ITEMS_DEFCD_ID_#0"
        local oob = slk.ability.AIgo:new("items_default_cooldown_#0")
        oob.Effectsound = ""
        oob.Name = oobTips
        oob.Tip = oobTips
        oob.Ubertip = oobTips
        oob.Art = ""
        oob.TargetArt = ""
        oob.Targetattach = ""
        oob.DataA1 = 0
        oob.Art = ""
        oob.CasterArt = ""
        oob.Cool = 0
        slkHelper.itemCooldown0ID = oob:get_id()
    end
    return slkHelper.itemCooldown0ID
end

--- 创建一件物品的冷却技能
--- 使用的模版仅仅是模版，并不会有默认的特效和效果
---@private
slkHelper.itemCooldownID = function(v)
    if (v.cooldown == nil) then
        return "AIat"
    end
    if (v.cooldown < 0) then
        v.cooldown = 0
    end
    if (v.cooldown == 0) then
        return slkHelper.itemCooldownID0()
    end
    local oobTips = "ITEMS_DEFCD_ID_" .. v.Name
    local oob
    if (v.cooldownTarget == CONST_ABILITY_TARGET.location.value) then
        -- 对点（模版：照明弹）
        oob = slk.ability.Afla:new("items_default_cooldown_" .. v.Name)
        oob.DataA1 = 0
        oob.EfctID1 = ""
        oob.Dur1 = 0.01
        oob.HeroDur1 = 0.01
        oob.Rng1 = v.Rng1 or 600
        oob.Area1 = 0
        oob.DataA1 = 0
        oob.DataB1 = 0
    elseif (v.cooldownTarget == CONST_ABILITY_TARGET.range.value) then
        -- 对点范围（模版：暴风雪）
        oob = slk.ability.ACbz:new("items_default_cooldown_" .. v.Name)
        oob.BuffID1 = ""
        oob.EfctID1 = ""
        oob.Rng1 = v.Rng1 or 300
        oob.Area1 = v.Area1 or 300
        oob.DataA1 = 0
        oob.DataB1 = 0
        oob.DataC1 = 0
        oob.DataD1 = 0
        oob.DataE1 = 0
        oob.DataF1 = 0
    elseif (v.cooldownTarget == CONST_ABILITY_TARGET.unit.value) then
        -- 对单位（模版：霹雳闪电）
        oob = slk.ability.ACfb:new("items_default_cooldown_" .. v.Name)
        oob.Missileart = v.Missileart or "Abilities\\Weapons\\FireBallMissile\\FireBallMissile.mdl"
        oob.Missilespeed = v.Missilespeed or 1000
        oob.Missilearc = v.Missilearc or 0
        oob.targs1 = v.targs1 or "air,ground,organic,enemy,neutral"
        oob.Rng1 = v.Rng1 or 800
        oob.Area1 = v.Area1 or 0
        oob.DataA1 = 0
        oob.Dur1 = 0.01
        oob.HeroDur1 = 0.01
    else
        -- 立刻（模版：金箱子）
        oob = slk.ability.AIgo:new("items_default_cooldown_" .. v.Name)
        oob.DataA1 = 0
    end
    oob.Effectsound = ""
    oob.Name = oobTips
    oob.Tip = oobTips
    oob.Ubertip = oobTips
    oob.TargetArt = v.TargetArt or ""
    oob.Targetattach = v.Targetattach or ""
    oob.Animnames = v.Animnames or "spell"
    oob.CasterArt = v.CasterArt or ""
    oob.Art = ""
    oob.item = 1
    oob.Cast1 = v.cast or 0
    oob.Cost1 = v.cost or 0
    oob.Cool1 = v.cooldown
    oob.Requires = ""
    oob.Hotkey = ""
    oob.Buttonpos1 = "0"
    oob.Buttonpos2 = "0"
    oob.race = "other"
    return oob:get_id()
end

slkHelper.item = {}

---@private
slkHelper.item.synthesisMapping = {
    profit = {},
    fragment = {},
}

--- 物品合成公式数组，只支持slkHelper创建的注册物品
---例子1 "小刀割大树=小刀+大树" 2个不一样的合1个
---例子2 "三头地狱犬的神识=地狱狗头x3" 3个一样的合1个
---例子3 "精灵神水x2=精灵的眼泪x50" 50个一样的合一种,但得到2个
---例子4 {{"小刀割大树",1},{"小刀",1},{"大树",1}} 对象型配置，第一项为结果物品(适合物品名称包含特殊字符的物品，如+/=影响公式的符号)
slkHelper.item.synthesis = function(formula)
    for _, v in ipairs(formula) do
        local profit = ''
        local fragment = {}
        if (type(v) == 'string') then
            local f1 = string.explode('=', v)
            if (string.strpos(f1[1], 'x') == false) then
                profit = { f1[1], 1 }
            else
                local temp = string.explode('x', f1[1])
                temp[2] = math.floor(temp[2])
                profit = temp
            end
            local f2 = string.explode('+', f1[2])
            for _, vv in ipairs(f2) do
                if (string.strpos(vv, 'x') == false) then
                    table.insert(fragment, { vv, 1 })
                else
                    local temp = string.explode('x', vv)
                    temp[2] = math.floor(temp[2])
                    table.insert(fragment, temp)
                end
            end
        elseif (type(v) == 'table') then
            profit = v[1]
            for vi = 2, table.len(v), 1 do
                table.insert(fragment, v[vi])
            end
        end
        --
        local fmStr = {}
        for _, fm in ipairs(fragment) do
            if (fm[2] <= 1) then
                table.insert(fmStr, fm[1])
            else
                table.insert(fmStr, fm[1] .. 'x' .. fm[2])
            end
            if (slkHelper.item.synthesisMapping.fragment[fm[1]] == nil) then
                slkHelper.item.synthesisMapping.fragment[fm[1]] = {}
            end
            if (table.includes(slkHelper.item.synthesisMapping.fragment[fm[1]], profit[1]) == false) then
                table.insert(slkHelper.item.synthesisMapping.fragment[fm[1]], profit[1])
            end
        end
        slkHelper.item.synthesisMapping.profit[profit[1]] = string.implode('+', fmStr)
        --
        table.insert(slkHelperHashData, {
            _class = "synthesis",
            _profit = profit,
            _fragment = fragment,
        })
    end
end

--- 创建一件影子物品
--- 不主动使用，由normal设置{_shadow = true}自动调用
--- 设置的 _hslk 数据会自动传到数据中
---@private
---@param v table
slkHelper.item.shadow = function(v)
    slkHelper.count = slkHelper.count + 1
    local Name = "　" .. v.Name .. "　"
    local obj = slk.item.rat9:new("itemShadows_" .. v.Name)
    obj.Name = Name
    obj.Description = slkHelper.itemDesc(v)
    obj.Ubertip = slkHelper.itemUbertip(v)
    obj.goldcost = v.goldcost
    obj.lumbercost = v.lumbercost
    obj.class = "Charged"
    obj.Level = v.lv
    obj.oldLevel = v.lv
    obj.Art = v.Art
    obj.file = v.file
    obj.prio = v.prio or 0
    obj.abilList = ""
    obj.ignoreCD = 1
    obj.drop = v.drop or 0
    obj.perishable = 1
    obj.usable = 1
    obj.powerup = 1
    obj.sellable = v.sellable or 1
    obj.pawnable = v.pawnable or 1
    obj.droppable = v.droppable or 1
    obj.pickRandom = v.pickRandom or 1
    obj.stockStart = v.stockStart or 0
    obj.stockRegen = v.stockRegen or 0
    obj.stockMax = v.stockMax or 1
    obj.uses = v.uses
    if (v.Hotkey ~= nil) then
        obj.Hotkey = v.Hotkey
        v.Buttonpos1 = CONST_HOTKEY_FULL_KV[v.Hotkey].Buttonpos1 or 0
        v.Buttonpos2 = CONST_HOTKEY_FULL_KV[v.Hotkey].Buttonpos2 or 0
        obj.Tip = "获得" .. v.Name .. "(" .. hColor.mixed(v.Hotkey, slkHelper.conf.color.hotKey) .. ")"
    else
        obj.Buttonpos1 = v.Buttonpos1 or 0
        obj.Buttonpos2 = v.Buttonpos2 or 0
        obj.Tip = "获得" .. v.Name
    end
    local id = obj:get_id()
    return {
        _class = "item",
        _id = id,
        _name = Name,
        _type = "shadow",
        _overlie = 1,
        _weight = v._weight,
        _attr = v._attr,
        _ring = v._ring,
    }
end

--- 创建一件实体物品
--- 设置的 _hslk 数据会自动传到数据中
--- 默认不会自动协助开启shadow模式（满格拾取/合成）可以设置slkHelper的conf来配置
---@param v table
slkHelper.item.normal = function(v)
    slkHelper.count = slkHelper.count + 1
    local cd = slkHelper.itemCooldownID(v)
    local abilList = ""
    local usable = 0
    local _overlie = v._overlie or 1
    local ignoreCD = 0
    if (cd ~= "AIat") then
        abilList = cd
        usable = 1
        if (v.perishable == nil) then
            v.perishable = 1
        end
        v.class = "Charged"
        if (cd == slkHelper.itemCooldown0ID) then
            ignoreCD = 1
        end
    else
        if (v.perishable == nil) then
            v.perishable = 0
        end
        v.class = "Permanent"
    end
    local lv = 1
    v.goldcost = v.goldcost or 0
    v.lumbercost = v.lumbercost or 0
    v.uses = v.uses or 1
    if (_overlie < v.uses) then
        _overlie = v.uses
    end
    lv = math.floor((v.goldcost + v.lumbercost) / 500)
    if (lv < 1) then
        lv = 1
    end
    v.Name = v.Name or "未命名" .. slkHelper.count
    v.Art = v.Art or "ReplaceableTextures\\CommandButtons\\BTNSelectHeroOn.blp"
    v.file = v.file or "Objects\\InventoryItems\\TreasureChest\\treasurechest.mdl"
    v.powerup = v.powerup or 0
    v.sellable = v.sellable or 1
    v.pawnable = v.pawnable or 1
    v.dropable = v.dropable or 1
    v._weight = v._weight or 0
    -- 处理 _shadow
    local _shadow = (slkHelper.conf.itemAutoShadow == true and v.powerup == 0)
    if (type(v._shadow) == 'boolean') then
        _shadow = v._shadow
    end
    local shadowData = {}
    if (_shadow == true) then
        shadowData = slkHelper.item.shadow(v)
    end
    if (v._ring ~= nil) then
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
    local obj = slk.item.rat9:new("items_" .. v.Name)
    obj.Name = v.Name
    obj.Description = slkHelper.itemDesc(v)
    obj.Ubertip = slkHelper.itemUbertip(v)
    obj.goldcost = v.goldcost or 1000000
    obj.lumbercost = v.lumbercost or 1000000
    obj.class = v.class
    obj.Level = lv
    obj.oldLevel = lv
    obj.Art = v.Art
    obj.file = v.file
    obj.prio = v.prio or 0
    obj.cooldownID = cd
    obj.abilList = abilList
    obj.ignoreCD = ignoreCD
    obj.drop = v.drop or 0
    obj.perishable = v.perishable
    obj.usable = usable
    obj.powerup = v.powerup
    obj.sellable = v.sellable
    obj.pawnable = v.pawnable
    obj.droppable = v.droppable or 1
    obj.pickRandom = v.pickRandom or 1
    obj.stockStart = v.stockStart or 0 -- 库存开始
    obj.stockRegen = v.stockRegen or 0 -- 进货周期
    obj.stockMax = v.stockMax or 1 -- 最大库存
    obj.uses = v.uses --使用次数
    if (v.Hotkey ~= nil) then
        obj.Hotkey = v.Hotkey
        v.Buttonpos1 = CONST_HOTKEY_FULL_KV[v.Hotkey].Buttonpos1 or 0
        v.Buttonpos2 = CONST_HOTKEY_FULL_KV[v.Hotkey].Buttonpos2 or 0
        obj.Tip = "获得" .. v.Name .. "(" .. hColor.mixed(v.Hotkey, slkHelper.conf.color.hotKey) .. ")"
    else
        obj.Buttonpos1 = v.Buttonpos1 or 0
        obj.Buttonpos2 = v.Buttonpos2 or 0
        obj.Tip = "获得" .. v.Name
    end
    local id = obj:get_id()
    if (shadowData._id ~= nil) then
        shadowData._shadow_id = id
        table.insert(slkHelperHashData, shadowData)
    end
    table.insert(slkHelperHashData, table.merge_pairs({
        _class = "item",
        _id = id,
        _name = v.Name,
        _type = "normal",
        _overlie = _overlie,
        _weight = v._weight,
        _attr = v._attr,
        _ring = v._ring,
        _shadow_id = shadowData._id or nil,
    }, (v._hslk or {})))
    return shadowData._id or id
end
