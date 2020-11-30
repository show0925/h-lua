-- 物品系统

--[[
    每个英雄最大支持使用6件物品
    支持满背包合成
    物品存在重量，背包有负重，超过负重即使存在合成关系，也会被暂时禁止合成
]]
hitem = {
    DEFAULT_SKILL_ITEM_SLOT = string.char2id("AInv"), -- 默认物品栏技能（英雄6格那个）默认全部认定这个技能为物品栏，如有需要自行更改
    POSITION_TYPE = {
        --物品位置类型
        COORDINATE = "coordinate", --坐标
        UNIT = "unit" --单位
    },
    FLEETING_IDS = {
        GOLD = hslk.item_fleeting[1], -- 默认金币（模型）
        LUMBER = hslk.item_fleeting[2], -- 默认木头
        BOOK_YELLOW = hslk.item_fleeting[3], -- 技能书系列
        BOOK_GREEN = hslk.item_fleeting[4],
        BOOK_PURPLE = hslk.item_fleeting[5],
        BOOK_BLUE = hslk.item_fleeting[6],
        BOOK_RED = hslk.item_fleeting[7],
        RUNE = hslk.item_fleeting[8], -- 神符（紫色符文）
        RELIEF = hslk.item_fleeting[9], -- 浮雕（橙色像块炭）
        EGG = hslk.item_fleeting[10], -- 蛋
        FRAGMENT = hslk.item_fleeting[11], -- 碎片（蓝色石头）
        QUESTION = hslk.item_fleeting[12], -- 问号
        GRASS = hslk.item_fleeting[13], -- 荧光草
        DOTA2_GOLD = hslk.item_fleeting[14], -- Dota2赏金符
        DOTA2_DAMAGE = hslk.item_fleeting[15], -- Dota2伤害符
        DOTA2_CURE = hslk.item_fleeting[16], -- Dota2恢复符
        DOTA2_SPEED = hslk.item_fleeting[17], -- Dota2极速符
        DOTA2_VISION = hslk.item_fleeting[18], -- Dota2幻象符
        DOTA2_INVISIBLE = hslk.item_fleeting[19], -- Dota2隐身符
    },
}

-- 单位嵌入到物品到框架系统
---@protected
hitem.embed = function(u)
    if (hRuntime.unit[u] == nil) then
        -- 未注册unit直接跳过
        return
    end
    -- 如果单位的玩家是真人
    if (his.computer(hunit.getOwner(u)) == false) then
        -- 拾取
        hevent.pool(u, hevent_default_actions.item.pickup, function(tgr)
            cj.TriggerRegisterUnitEvent(tgr, u, EVENT_UNIT_PICKUP_ITEM)
        end)
        -- 丢弃
        hevent.pool(u, hevent_default_actions.item.drop, function(tgr)
            cj.TriggerRegisterUnitEvent(tgr, u, EVENT_UNIT_DROP_ITEM)
        end)
        -- 抵押
        hevent.pool(u, hevent_default_actions.item.pawn, function(tgr)
            cj.TriggerRegisterUnitEvent(tgr, u, EVENT_UNIT_PAWN_ITEM)
        end)
        -- 使用
        hevent.pool(u, hevent_default_actions.item.use, function(tgr)
            cj.TriggerRegisterUnitEvent(tgr, u, EVENT_UNIT_USE_ITEM)
        end)
        hevent.pool(u, hevent_default_actions.item.use_s, function(tgr)
            cj.TriggerRegisterUnitEvent(tgr, u, EVENT_UNIT_SPELL_EFFECT)
        end)
    end
end

--- 令单位的物品在runtime内存中释放
---@protected
hitem.clearUnitCache = function(whichUnit)
    if (hRuntime.unit[whichUnit] ~= nil) then
        for i = 0, 5, 1 do
            local it = cj.UnitItemInSlot(whichUnit, i)
            if (it ~= nil) then
                hRuntime.clear(it)
            end
            it = nil
        end
    end
end

--- match done
---@param whichUnit userdata
---@param whichItem userdata
---@param triggerData table
hitem.used = function(whichUnit, whichItem, triggerData)
    local isTrigger = false
    triggerData = triggerData or {}
    triggerData.triggerUnit = whichUnit
    triggerData.triggerItem = whichItem
    if (triggerData.targetLoc ~= nil) then
        triggerData.targetX = cj.GetLocationX(triggerData.targetLoc)
        triggerData.targetY = cj.GetLocationY(triggerData.targetLoc)
        triggerData.targetZ = cj.GetLocationZ(triggerData.targetLoc)
        cj.RemoveLocation(triggerData.targetLoc)
        triggerData.targetLoc = nil
    end
    if (#hmatcher.ITEM_MATCHER > 0) then
        local itemName = cj.GetItemName(whichItem)
        for _, m in ipairs(hmatcher.ITEM_MATCHER) do
            local s, e = string.find(itemName, m[1])
            if (s ~= nil and e ~= nil) then
                local isPowerUp = hitem.getIsPowerUp(whichItem)
                local isPerishable = hitem.getIsPerishable(whichItem)
                local useCharged = 1
                if (isPowerUp == true and isPerishable == true) then
                    useCharged = hitem.getCharges(whichItem)
                end
                for _ = 1, useCharged, 1 do
                    m[2](triggerData)
                    hevent.triggerEvent(
                        whichUnit,
                        CONST_EVENT.itemUsed,
                        triggerData
                    )
                    isTrigger = true
                end
            end
        end
    end
    if (isTrigger == false) then
        hevent.triggerEvent(
            whichUnit,
            CONST_EVENT.itemUsed,
            triggerData
        )
    end
end

--- 删除物品，可延时
---@param it userdata
---@param delay number
hitem.del = function(it, delay)
    delay = delay or 0
    if (delay <= 0 and it ~= nil) then
        hitem.setPositionType(it, nil)
        cj.SetWidgetLife(it, 1.00)
        cj.RemoveItem(it)
        hRuntime.clear(it)
    else
        htime.setTimeout(
            delay,
            function(t)
                htime.delTimer(t)
                hitem.setPositionType(it, nil)
                hRuntime.clear(it)
                cj.SetWidgetLife(it, 1.00)
                cj.RemoveItem(it)
            end
        )
    end
end

--- 根据物品名称获取物品ID字符串
---@param name string
---@return string
hitem.n2i = function(name)
    if (hslk.n2v.item[name]) then
        return hslk.n2v.item[name]._id or nil
    end
    return nil
end

--- 获取物品ID字符串
---@param itOrId userdata|number|string
---@return string|nil
hitem.getId = function(itOrId)
    local id
    if (type(itOrId) == 'userdata') then
        id = string.id2char(cj.GetItemTypeId(itOrId))
    elseif (type(itOrId) == 'number') then
        id = string.id2char(itOrId)
    elseif (type(itOrId) == 'string') then
        id = itOrId
    end
    return id
end

--- 获取物品名称
---@param itOrId userdata|string|number
---@return string
hitem.getName = function(itOrId)
    if (type(itOrId) == 'userdata') then
        return cj.GetItemName(itOrId)
    elseif (type(itOrId) == 'string' or type(itOrId) == 'number') then
        local slk = hitem.getSlk(itOrId)
        if (slk ~= nil) then
            return slk.Name;
        end
    end
    return ''
end

-- 获取物品位置类型
---@param it userdata
---@return string|nil
hitem.getPositionType = function(it)
    if (hRuntime.item[it] == nil) then
        return
    end
    return hRuntime.item[it].positionType
end

-- 设置物品位置类型
---@param it userdata
---@param type string
hitem.setPositionType = function(it, type)
    if (it == nil or cj.GetItemName(it) == nil) then
        return
    end
    if (type == nil) then
        table.delete(it, hRuntime.itemPickPool)
        return
    end
    if (hRuntime.item[it] ~= nil) then
        hRuntime.item[it].positionType = type
        --如果位置是在坐标轴上，将物品加入拾取池
        if (type == hitem.POSITION_TYPE.COORDINATE) then
            table.insert(hRuntime.itemPickPool, it)
        end
    end
end

--- 数值键值是根据地图编辑器作为标准的，所以大小写也是与之一致
---@param itOrId userdata|string|number
---@return table|nil
hitem.getSlk = function(itOrId)
    local id = hitem.getId(itOrId)
    return slk.item[id]
end

--- 获取单位的 _hslk 自定义数据
---@param itOrId userdata|string|number
---@return table|nil
hitem.getHSlk = function(itOrId)
    local id = hitem.getId(itOrId)
    if (hslk.i2v.item[id]) then
        return hslk.i2v.item[id]
    end
    return {}
end

-- 获取物品的图标路径
---@param itOrId userdata|string|number
---@return string
hitem.getArt = function(itOrId)
    local s = hitem.getSlk(itOrId)
    return s.Art
end

--- 获取物品的模型路径
---@param itOrId userdata|string|number
---@return string
hitem.getFile = function(itOrId)
    local s = hitem.getSlk(itOrId)
    return s.file
end

--- 获取物品的分类
---@param itOrId userdata|string|number
---@return string
hitem.getClass = function(itOrId)
    local s = hitem.getSlk(itOrId)
    return s.class
end

--- 获取物品所需的金币
---@param itOrId userdata|string|number
---@return number
hitem.getGoldCost = function(itOrId)
    local s = hitem.getSlk(itOrId)
    return math.floor(s.goldcost)
end

--- 获取物品所需的木头
---@param itOrId userdata|string|number
---@return number
hitem.getLumberCost = function(itOrId)
    local s = hitem.getSlk(itOrId)
    return math.floor(s.lumbercost)
end

--- 获取物品是否可以使用
---@param itOrId userdata|string|number
---@return boolean
hitem.getIsUsable = function(itOrId)
    local s = hitem.getSlk(itOrId)
    return s.usable == "1"
end

--- 获取物品是否自动使用
---@param itOrId userdata|string|number
---@return boolean
hitem.getIsPowerUp = function(itOrId)
    local s = hitem.getSlk(itOrId)
    return s.powerup == "1"
end

--- 获取物品是否使用后自动消失
---@param itOrId userdata|string|number
---@return boolean
hitem.getIsPerishable = function(itOrId)
    local s = hitem.getSlk(itOrId)
    return s.perishable == "1"
end

--- 获取物品是否可卖
---@param itOrId userdata|string|number
---@return boolean
hitem.getIsSellAble = function(itOrId)
    local s = hitem.getSlk(itOrId)
    return s.sellable == "1"
end

--- 获取物品的最大叠加数(默认是1个,此系统以使用次数作为数量使用)
---@param itOrId userdata|string|number
---@return number
hitem.getOverlie = function(itOrId)
    local s = hitem.getHSlk(itOrId)
    return s._overlie or 1
end

--- 获取物品的重量（默认为0）
---@param itOrId userdata|string|number
---@return number
hitem.getWeight = function(itOrId, charges)
    local s = hitem.getHSlk(itOrId)
    if (s ~= nil) then
        if (charges == nil and type(itOrId) == "userdata") then
            -- 如果没有传次数，并且传入的是物品对象，会直接获取物品的次数，请注意
            charges = hitem.getCharges(itOrId)
        else
            charges = 1
        end
        return (s._weight or 0) * charges
    else
        return 0
    end
end
--- 获取物品的属性加成
---@param itOrId userdata|string|number
---@return table
hitem.getAttribute = function(itOrId)
    local s = hitem.getHSlk(itOrId)
    if (s ~= nil) then
        return s._attr or {}
    else
        return {}
    end
end

--- 获取物品的等级
---@param it userdata
---@return number
hitem.getLevel = function(it)
    if (it ~= nil) then
        return cj.GetItemLevel(it)
    end
    return 0
end

--- 获取物品的使用次数
---@param it userdata
---@return number
hitem.getCharges = function(it)
    if (it ~= nil) then
        return cj.GetItemCharges(it)
    else
        return 0
    end
end
--- 设置物品的使用次数
---@param it userdata
---@param charges number
hitem.setCharges = function(it, charges)
    if (it ~= nil and charges > 0) then
        cj.SetItemCharges(it, charges)
    end
end

--- 获取某单位身上某种物品的使用总次数
---@param itemId string|number
---@param whichUnit userdata
---@return number
hitem.getTotalCharges = function(itemId, whichUnit)
    local charges = 0
    local it
    if (type(itemId) == "string") then
        itemId = string.char2id(itemId)
    end
    for i = 0, 5, 1 do
        it = cj.UnitItemInSlot(whichUnit, i)
        if (it ~= nil and cj.GetItemTypeId(it) == itemId) then
            charges = charges + hitem.getCharges(it)
        end
    end
    return charges
end

--- 获取某单位身上空格物品栏数量
---@param whichUnit userdata
---@return number
hitem.getEmptySlot = function(whichUnit)
    local qty = cj.UnitInventorySize(whichUnit)
    local it
    for i = 0, 5, 1 do
        it = cj.UnitItemInSlot(whichUnit, i)
        if (it ~= nil) then
            qty = qty - 1
        end
    end
    return qty
end

--- 循环获取某单位6格物品
---@alias SlotLoop fun(enumUnit: userdata):void
---@param whichUnit userdata
---@param action SlotLoop | "function(slotItem, slotIndex) end"
---@return number
hitem.slotLoop = function(whichUnit, action)
    local it
    for i = 0, 5, 1 do
        it = cj.UnitItemInSlot(whichUnit, i)
        action(it, i)
    end
end

--- 附加单位获得物品后的属性
---@protected
hitem.addProperty = function(whichUnit, itId, charges)
    local attr = hitem.getAttribute(itId)
    attr.weight_current = "+" .. hitem.getWeight(itId, 1)
    hattribute.caleAttribute(CONST_DAMAGE_SRC.item, true, whichUnit, attr, charges)
    for _ = 1, charges, 1 do
        hring.insert(whichUnit, itId)
    end
end
--- 削减单位获得物品后的属性
---@protected
hitem.subProperty = function(whichUnit, itId, charges)
    local attr = hitem.getAttribute(itId)
    attr.weight_current = "+" .. hitem.getWeight(itId, 1)
    hattribute.caleAttribute(CONST_DAMAGE_SRC.item, false, whichUnit, attr, charges)
    for _ = 1, charges, 1 do
        hring.remove(whichUnit, itId)
    end
end

--- 单位合成物品
---@public
---@param whichUnit userdata 目标单位
---@param items nil|userdata|table<userdata> 空|物品|物品数组
---@return table 物品数据数组 {...{id=<string>,charges=<number>,name=<string>}}
hitem.synthesis = function(whichUnit, items)
    if (whichUnit == nil) then
        return {}
    end
    items = items or {}
    if (type(items) == 'userdata') then
        items = { items }
    end
    local itemKinds = {}
    local itemQuantity = {}
    hitem.slotLoop(whichUnit, function(slotItem)
        if (slotItem ~= nil) then
            local itId = hitem.getId(slotItem)
            if (table.includes(itId, itemKinds) == false) then
                table.insert(itemKinds, itId)
            end
            if (itemQuantity[itId] == nil) then
                itemQuantity[itId] = 0
            end
            itemQuantity[itId] = itemQuantity[itId] + (hitem.getCharges(slotItem) or 1)
        end
    end)
    if (#items > 0) then
        for _, it in ipairs(items) do
            local itId = hitem.getId(it)
            if (table.includes(itId, itemKinds) == false) then
                table.insert(itemKinds, itId)
            end
            if (itemQuantity[itId] == nil) then
                itemQuantity[itId] = 0
            end
            itemQuantity[itId] = itemQuantity[itId] + (hitem.getCharges(it) or 1)
            hitem.del(it, 0)
        end
    end
    local matchCount = 1
    while (matchCount > 0) do
        matchCount = 0
        for _, itId in ipairs(itemKinds) do
            if (hslk.synthesis.fragment[itId] ~= nil) then
                for need = #hslk.synthesis.fragment[itId], 1, -1 do
                    if ((itemQuantity[itId] or 0) >= need) then
                        local maybeProfits = hslk.synthesis.fragment[itId][need]
                        for _, mp in ipairs(maybeProfits) do
                            local profitId = mp.profit
                            local profitIndex = mp.index
                            local whichProfit = hslk.synthesis.profit[profitId][profitIndex]
                            local needFragments = whichProfit.fragment
                            local match = true
                            for _, frag in ipairs(needFragments) do
                                if ((itemQuantity[frag[1]] or 0) < frag[2]) then
                                    match = false
                                    break
                                end
                            end
                            if (match == true) then
                                matchCount = matchCount + 1
                                for _, frag in ipairs(needFragments) do
                                    itemQuantity[frag[1]] = itemQuantity[frag[1]] - frag[2]
                                    if (itemQuantity[frag[1]] == 0) then
                                        itemQuantity[frag[1]] = nil
                                        table.delete(frag[1], itemKinds)
                                    end
                                end
                                if (table.includes(profitId, itemKinds) == false) then
                                    table.insert(itemKinds, profitId)
                                end
                                if (itemQuantity[profitId] == nil) then
                                    itemQuantity[profitId] = whichProfit.qty
                                else
                                    itemQuantity[profitId] = itemQuantity[profitId] + whichProfit.qty
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    -- 处理结果物品
    local final = {}
    for _, itId in ipairs(itemKinds) do
        local slk = hslk.i2v.item[itId]
        if (slk ~= nil) then
            local overlie = slk.OVERLIE or 1
            while (itemQuantity[itId] > 0) do
                local charges = 0
                if (overlie >= itemQuantity[itId]) then
                    charges = itemQuantity[itId]
                    itemQuantity[itId] = 0
                else
                    charges = overlie
                    itemQuantity[itId] = itemQuantity[itId] - overlie
                end
                table.insert(final, { id = itId, charges = charges })
            end
        else
            table.insert(final, { id = itId, charges = itemQuantity[itId] })
        end
    end
    -- 先看看现有的物品是否与未来不符，先删掉释放负重
    for i = 1, 6, 1 do
        local slot = i - 1
        local it = cj.UnitItemInSlot(whichUnit, slot)
        if (it ~= nil) then
            local id = hitem.getId(it)
            local fid
            if (final[i] ~= nil) then
                fid = final[i].id
            end
            if (id ~= fid) then
                local charges = hitem.getCharges(it) or 1
                hitem.subProperty(whichUnit, id, charges)
                hitem.del(it, 0)
            end
        end
    end
    local extra = {}
    for i = 1, math.max(6, #final), 1 do
        if (i <= 6) then
            local slot = i - 1
            local it = cj.UnitItemInSlot(whichUnit, slot)
            if (final[i] == nil) then
                if (it ~= nil) then
                    local id = hitem.getId(it)
                    local charges = hitem.getCharges(it) or 1
                    hitem.subProperty(whichUnit, id, charges)
                    hitem.del(it, 0)
                end
            elseif (it == nil) then
                -- 当前无物品
                local synthesisItem = hitem.create({
                    itemId = final[i].id,
                    whichUnit = whichUnit,
                    charges = final[i].charges,
                })
                -- 触发合成事件
                hevent.triggerEvent(
                    whichUnit,
                    CONST_EVENT.itemSynthesis,
                    {
                        triggerUnit = whichUnit,
                        triggerItem = synthesisItem
                    }
                )
            else
                -- 仅仅物品次数差异
                local c = hitem.getCharges(it) or 1
                if (final[i].charges ~= c) then
                    if (final[i].charges > c) then
                        cj.SetItemCharges(it, final[i].charges)
                        hitem.addProperty(whichUnit, final[i].id, final[i].charges - c)
                    else
                        cj.SetItemCharges(it, final[i].charges)
                        hitem.subProperty(whichUnit, final[i].id, c - final[i].charges)
                    end
                end
            end
        else
            table.insert(extra, final[i]);
        end
    end
    return extra
end

--- 拆分物品
--- 物品的xy指的是物品创建时的坐标
--- 当物品在单位身上时，物品的位置并不跟随单位移动，而是创建时候的位置，需要注意
---@public
---@param whichItem userdata 目标物品
---@param separateType string | "'single'" | "'formula'"
---@param whichUnit userdata 触发单位（可选）当拥有持有单位时，拆分的物品会在单位坐标处
---@return nil|string 错误时会返回一个字符串，反馈错误
hitem.separate = function(whichItem, separateType, formulaIndex, whichUnit)
    if (whichItem == nil) then
        return "物品不存在"
    end
    whichUnit = whichUnit or nil
    local x = 0
    local y = 0
    if (whichUnit ~= nil and cj.IsItemOwned(whichItem)) then
        x = cj.GetUnitX(whichUnit)
        y = cj.GetUnitY(whichUnit)
    else
        x = cj.GetItemX(whichItem)
        y = cj.GetItemY(whichItem)
    end
    local id = hitem.getId(whichItem)
    local charges = hitem.getCharges(whichItem)
    separateType = separateType or "single"
    formulaIndex = formulaIndex or 1 -- 默认获取第一条公式拆分
    if (charges <= 1) then
        -- 如果数目小于2，自动切换成公式模式
        separateType = "formula"
    end
    if (separateType == "single") then
        for _ = 1, charges, 1 do
            hitem.create({ itemId = id, charges = 1, x = x, y = y, during = 0 })
        end
    elseif (separateType == "formula") then
        local originHSlk = hslk.i2v.item[id]
        if (originHSlk ~= nil and originHSlk._type == "shadow") then
            id = hslk.i2v.item[originHSlk._shadow_id]._id
        end
        if (hslk.synthesis.profit[id] == nil) then
            return "物品不存在公式，无法拆分"
        end
        local profit = hslk.synthesis.profit[id][formulaIndex] or nil
        if (profit == nil) then
            return "物品找不到公式，无法拆分"
        end
        print_mbr(profit)
        for _ = 1, charges, 1 do
            for _, frag in ipairs(profit.fragment) do
                local flagId = frag[1]
                if (#profit.fragment == 1) then
                    for _ = 1, frag[2], 1 do
                        hitem.create({ itemId = flagId, charges = 1, x = x, y = y, during = 0 })
                    end
                else
                    local qty = frag[2]
                    local slk = hslk.i2v.item[flagId]
                    if (slk ~= nil) then
                        local overlie = slk.OVERLIE or 1
                        while (qty > 0) do
                            if (overlie >= qty) then
                                hitem.create({ itemId = flagId, charges = qty, x = x, y = y, during = 0 })
                                qty = 0
                            else
                                qty = qty - overlie
                                hitem.create({ itemId = flagId, charges = overlie, x = x, y = y, during = 0 })
                            end
                        end
                    else
                        hitem.create({ itemId = flagId, charges = qty, x = x, y = y, during = 0 })
                    end
                end
            end
        end
    end
    hevent.triggerEvent(
        whichItem,
        CONST_EVENT.itemSeparate,
        {
            triggerItem = whichItem,
            type = separateType,
            targetUnit = whichUnit,
        }
    )
    hitem.del(whichItem, 0)
end

--[[
 1 检查单位的负重是否可以承受新的物品
 2 可以承受的话，物品是否有叠加，不能叠加检查是否还有多余的格子
 3 物品数量是否支持合成
 4 根据情况执行原物品叠加、合成等操作
]]
---@private
hitem.detector = function(whichUnit, originItem)
    if (whichUnit == nil or originItem == nil) then
        print_err("detector params nil")
    end
    local newWeight = hattr.get(whichUnit, "weight_current") + hitem.getWeight(originItem)
    if (newWeight > hattr.get(whichUnit, "weight")) then
        local exWeight = math.round(newWeight - hattr.get(whichUnit, "weight"))
        htextTag.style(
            htextTag.create2Unit(whichUnit, "负重超出" .. exWeight .. "kg", 8.00, "ffffff", 1, 1.1, 50.00),
            "scale",
            0,
            0.05
        )
        -- 判断如果是真实物品并且有影子，转为影子物品掉落
        local hs = hitem.getHSlk(originItem)
        if (hs._type ~= "shadow" and hs._shadow_id) then
            local x = cj.GetItemX(originItem)
            local y = cj.GetItemY(originItem)
            local c = cj.GetItemCharges(originItem)
            hitem.del(originItem, 0)
            originItem = hitem.create({
                itemId = hs._shadow_id,
                x = x,
                y = y,
                charges = c,
                during = 0
            })
        else
            hitem.setPositionType(originItem, hitem.POSITION_TYPE.COORDINATE)
        end
        -- 触发超重事件
        hevent.triggerEvent(
            whichUnit,
            CONST_EVENT.itemOverWeight,
            {
                triggerUnit = whichUnit,
                triggerItem = originItem,
                value = exWeight
            }
        )
        return
    end

    local getItem

    -- 判断如果是影子物品，转为真实物品来判断
    local hs = hitem.getHSlk(originItem)
    if (originhsl and hs._type == "shadow" and hs._shadow_id) then
        local realX = cj.GetItemX(originItem)
        local realY = cj.GetItemY(originItem)
        local realCharges = cj.GetItemCharges(originItem)
        hitem.del(originItem, 0)
        getItem = hitem.create({
            autoShadow = false,
            itemId = hs._shadow_id,
            x = realX,
            y = realY,
            charges = realCharges,
            during = 0
        })
        originItem = nil
    else
        getItem = originItem
    end
    local overlie = hitem.getOverlie(getItem)
    if (overlie > 1 and hitem.getIsPowerUp(getItem) ~= true) then
        local isOverlieOver = false
        -- 可能可叠加的情况，先检查单位的各个物品是否还有叠加空位
        local tempIt
        local currentItId = cj.GetItemTypeId(getItem)
        local currentCharges = hitem.getCharges(getItem)
        for si = 0, 5, 1 do
            tempIt = cj.UnitItemInSlot(whichUnit, si)
            if (tempIt ~= nil and currentItId == cj.GetItemTypeId(tempIt)) then
                -- 如果第i格物品和获得的一致
                -- 如果有极限值,并且原有的物品未达上限
                local tempCharges = hitem.getCharges(tempIt)
                if (tempCharges < overlie) then
                    if ((currentCharges + tempCharges) <= overlie) then
                        -- 条件：如果旧物品足以容纳所有的新物品个数
                        -- 使旧物品使用次数增加，新物品删掉
                        cj.SetItemCharges(tempIt, currentCharges + tempCharges)
                        hitem.del(getItem, 0)
                        isOverlieOver = true
                        hitem.addProperty(whichUnit, currentItId, currentCharges)
                        break
                    else
                        -- 否则，如果使用次数大于极限值,旧物品次数满载，新物品数量减少
                        cj.SetItemCharges(tempIt, overlie)
                        cj.SetItemCharges(getItem, currentCharges - (overlie - tempCharges))
                        hitem.addProperty(whichUnit, currentItId, overlie - tempCharges)
                    end
                end
            end
        end
        -- 如果叠加已经全部消化，这里就把物品it设置为nil
        if (isOverlieOver == true) then
            getItem = nil
        end
    end
    -- 如果物品还在~~
    if (getItem ~= nil) then
        local isPowerUp = hitem.getIsPowerUp(getItem)
        local isPerishable = hitem.getIsPerishable(getItem)
        local useCharged = hitem.getCharges(getItem)
        -- 检查物品是否[自动使用]且[使用后消失]
        if (isPowerUp == true and isPerishable == true) then
            hitem.used(whichUnit, getItem)
            hitem.del(getItem, 0)
            return
        elseif (hitem.getEmptySlot(whichUnit) > 0) then
            -- 检查身上是否还有空格子，有就给单位
            hitem.setPositionType(getItem, hitem.POSITION_TYPE.UNIT)
            cj.UnitAddItem(whichUnit, getItem)
            -- 触发获得物品
            hevent.triggerEvent(
                whichUnit,
                CONST_EVENT.itemGet,
                {
                    triggerUnit = whichUnit,
                    triggerItem = getItem
                }
            )
            hitem.addProperty(whichUnit, cj.GetItemTypeId(getItem), useCharged)
            -- 如果是自动使用的物品
            if (isPowerUp == true) then
                hitem.used(whichUnit, getItem)
            end
            getItem = nil
        end
    end
    -- 检查合成
    local extra = {}
    if (getItem ~= nil) then
        extra = hitem.synthesis(whichUnit, getItem)
    else
        extra = hitem.synthesis(whichUnit)
    end
    if (#extra > 0) then
        for _, e in ipairs(extra) do
            local slk = hslk.i2v.item[e.id]
            local id = slk._id
            if (slk._type ~= "shadow" and slk._shadow_id ~= nil) then
                id = slk._shadow_id
            end
            local x = hunit.x(whichUnit)
            local y = hunit.y(whichUnit)
            local charges = e.charges
            local extraIt = hitem.create(
                {
                    itemId = slk._shadow_id,
                    x = x,
                    y = y,
                    charges = charges,
                    during = 0
                }
            )
            hitem.setPositionType(extraIt, hitem.POSITION_TYPE.COORDINATE)
            -- 触发满格事件
            hevent.triggerEvent(
                whichUnit,
                CONST_EVENT.itemOverSlot,
                {
                    triggerUnit = whichUnit,
                    triggerItem = extraIt
                }
            )
        end
    end
end

--[[
    创建物品
    bean = {
        itemId = 'I001', --物品ID
        charges = 1, --物品可使用次数（可选，默认为1）
        whichUnit = nil, --哪个单位（可选）
        whichUnitPosition = nil, --哪个单位的位置（可选，填单位）
        x = nil, --哪个坐标X（可选）
        y = nil, --哪个坐标Y（可选）
        whichLoc = nil, --哪个点（可选，不推荐）
        during = 0, --持续时间（可选，创建给单位要注意powerUp物品的问题）
    }
    !单位模式下，during持续时间是无效的
]]
hitem.create = function(bean)
    if (bean.itemId == nil) then
        print_err("hitem create -it-id")
        return
    end
    if (bean.charges == nil) then
        bean.charges = 1
    end
    if (bean.charges < 1) then
        return
    end
    local charges = bean.charges
    local during = bean.during or 0
    -- 优先级 坐标 > 单位 > 点
    local x, y
    local itemId = bean.itemId
    local posType
    if (bean.x ~= nil and bean.y ~= nil) then
        x = bean.x
        y = bean.y
        posType = hitem.POSITION_TYPE.COORDINATE
    elseif (bean.whichUnitPosition ~= nil) then
        x = hunit.x(bean.whichUnit)
        y = hunit.y(bean.whichUnit)
        posType = hitem.POSITION_TYPE.COORDINATE
    elseif (bean.whichUnit ~= nil) then
        x = hunit.x(bean.whichUnit)
        y = hunit.y(bean.whichUnit)
        posType = hitem.POSITION_TYPE.UNIT
    elseif (bean.whichLoc ~= nil) then
        x = cj.GetLocationX(bean.whichLoc)
        y = cj.GetLocationY(bean.whichLoc)
        posType = hitem.POSITION_TYPE.COORDINATE
    else
        print_err("hitem create -site")
        return
    end
    local it
    if (type(itemId) == "string") then
        it = cj.CreateItem(string.char2id(itemId), x, y)
    else
        it = cj.CreateItem(itemId, x, y)
    end
    cj.SetItemCharges(it, charges)
    if (posType == hitem.POSITION_TYPE.UNIT) then
        hRuntime.item[it] = {}
        hitem.setPositionType(it, posType)
        hitem.detector(bean.whichUnit, it)
    else
        if (type(bean.autoShadow) ~= 'boolean') then
            bean.autoShadow = true
        end
        if (bean.autoShadow == true) then
            -- 默认如果可能的话，自动协助将真实物品转为影子物品(*小心死循环)
            local hs = hitem.getHSlk(it)
            if (hs ~= nil and hs._type ~= "shadow" and hs._shadow_id ~= nil) then
                x = cj.GetItemX(it)
                y = cj.GetItemY(it)
                hitem.del(it, 0)
                it = cj.CreateItem(string.char2id(hs._shadow_id), x, y)
                cj.SetItemCharges(it, charges)
            end
        end
        hRuntime.item[it] = {}
        hitem.setPositionType(it, posType)
        if (during > 0) then
            htime.setTimeout(
                during,
                function(t)
                    htime.delTimer(t)
                    hitem.del(it, 0)
                end
            )
        end
    end
    itemId = nil
    x = nil
    y = nil
    return it
end

--- 创建[瞬逝物]物品
--- 是以单位模拟的物品，进入范围瞬间消失并生效
--- 可以增加玩家的反馈刺激感
--- [type]金币,木材,黄色书,绿色书,紫色书,蓝色书,红色书,神符,浮雕,蛋",碎片,问号,荧光草Dota2赏金符,Dota2伤害符,Dota2恢复符,Dota2极速符,Dota2幻象符,Dota2隐身符
---@param fleetingType number hitem.FLEETING_IDS[n]
---@param x number 坐标X
---@param y number 坐标Y
---@param during number 持续时间（可选，默认30秒）
---@param yourFunc onEnterUnitRange | "function(evtData) end"
---@return userdata item-unit
hitem.fleeting = function(fleetingType, x, y, during, yourFunc)
    if (fleetingType == nil) then
        print_err("hitem fleeting -type")
        return
    end
    if (x == nil or y == nil) then
        return
    end
    during = during or 30
    if (during < 0) then
        return
    end
    local it = hunit.create({
        register = false,
        whichPlayer = hplayer.player_passive,
        unitId = fleetingType,
        x = x,
        y = y,
        during = during,
    })
    if (type(yourFunc) == "function") then
        hevent.onEnterUnitRange(it, 127, yourFunc)
    end
    return it
end

--- 使一个单位的所有物品给另一个单位
---@param origin userdata
---@param target userdata
hitem.give = function(origin, target)
    if (origin == nil or target == nil) then
        return
    end
    for i = 0, 5, 1 do
        local it = cj.UnitItemInSlot(origin, i)
        if (it ~= nil) then
            hitem.create(
                {
                    itemId = hitem.getId(it),
                    charges = hitem.getCharges(it),
                    whichUnit = target
                }
            )
        end
        hitem.del(it, 0)
    end
end

--- 操作物品给一个单位
---@param it userdata
---@param targetUnit userdata
hitem.pick = function(it, targetUnit)
    if (it == nil or targetUnit == nil) then
        return
    end
    cj.UnitAddItem(targetUnit, it)
end

--- 复制一个单位的所有物品给另一个单位
---@param origin userdata
---@param target userdata
hitem.copy = function(origin, target)
    if (origin == nil or target == nil) then
        return
    end
    for i = 0, 5, 1 do
        local it = cj.UnitItemInSlot(origin, i)
        if (it ~= nil) then
            hitem.create(
                {
                    itemId = hitem.getId(it),
                    charges = hitem.getCharges(it),
                    whichUnit = target,
                }
            )
        end
    end
end

--- 令一个单位把物品仍在地上
---@param origin userdata
---@param slot nil|number 物品位置
hitem.drop = function(origin, slot)
    if (origin == nil) then
        return
    end
    if (slot == nil) then
        for i = 0, 5, 1 do
            local it = cj.nitItemInSlot(origin, i)
            if (it ~= nil) then
                hitem.create(
                    {
                        itemId = hitem.getId(it),
                        charges = hitem.getCharges(it),
                        x = hunit.x(origin),
                        x = hunit.y(origin)
                    }
                )
                htime.del(it, 0)
            end
        end
    else
        local it = cj.nitItemInSlot(origin, slot)
        if (it ~= nil) then
            hitem.create(
                {
                    itemId = hitem.getId(it),
                    charges = hitem.getCharges(it),
                    x = hunit.x(origin),
                    x = hunit.y(origin)
                }
            )
            htime.del(it, 0)
        end
    end
end

--- 一键拾取区域(x,y)长宽(w,h)
---@param u userdata
---@param x number
---@param y number
---@param w number
---@param h number
hitem.pickRect = function(u, x, y, w, h)
    for k = #hRuntime.itemPickPool, 1, -1 do
        local xi = cj.GetItemX(hRuntime.itemPickPool[k])
        local yi = cj.GetItemY(hRuntime.itemPickPool[k])
        if (hitem.getEmptySlot(u) > 0) then
            local d = math.getDistanceBetweenXY(x, y, xi, yi)
            local deg = math.getDegBetweenXY(x, y, xi, yi)
            local distance = math.getMaxDistanceInRect(w, h, deg)
            if (d <= distance) then
                hitem.pick(hRuntime.itemPickPool[k], u)
            end
        else
            break
        end
    end
end

-- 一键拾取圆(x,y)半径(r)
---@param u userdata
---@param x number
---@param y number
---@param r number
hitem.pickRound = function(u, x, y, r)
    for k = #hRuntime.itemPickPool, 1, -1 do
        local xi = cj.GetItemX(hRuntime.itemPickPool[k])
        local yi = cj.GetItemY(hRuntime.itemPickPool[k])
        local d = math.getDistanceBetweenXY(x, y, xi, yi)
        if (d <= r and hitem.getEmptySlot(u) > 0) then
            hitem.pick(hRuntime.itemPickPool[k], u)
        else
            break
        end
    end
end