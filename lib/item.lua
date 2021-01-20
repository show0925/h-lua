-- 物品系统

--[[
    每个英雄最大支持使用6件物品
    支持满背包合成
    物品存在重量，背包有负重，超过负重即使存在合成关系，也会被暂时禁止合成
]]
hitem = {
    DEFAULT_SKILL_ITEM_SLOT = string.char2id("AInv"), -- 默认物品栏技能（英雄6格那个）默认全部认定这个技能为物品栏，如有需要自行更改
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
    if (u == nil or hRuntime.unit[u] == nil) then
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
        hitemPool.clear(it)
        cj.SetWidgetLife(it, 1.00)
        cj.RemoveItem(it)
    else
        htime.setTimeout(
            delay,
            function(t)
                htime.delTimer(t)
                hitemPool.clear(it)
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
        return hslk.n2v.item[name]._id
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

--- 数值键值是根据地图编辑器作为标准的，所以大小写也是与之一致
---@param itOrId userdata|string|number
---@return table|nil
hitem.getSlk = function(itOrId)
    local id = hitem.getId(itOrId)
    return slk.item[id]
end

--- 获取单位的 _hslk 自定义数据
---@param itOrIdOrName userdata|string|number
---@return table|nil
hitem.getHSlk = function(itOrIdOrName)
    local id = hitem.getId(itOrIdOrName)
    if (hslk.i2v.item[id]) then
        return hslk.i2v.item[id]
    elseif (hslk.n2v.item[id]) then
        return hslk.n2v.item[id]
    end
    return nil
end

--- 判断一个物品是否影子物品的明面物品
---@param itOrIdOrName userdata|string|number
---@return boolean
hitem.isShadowFront = function(itOrIdOrName)
    local hs = hitem.getHSlk(itOrIdOrName)
    if (hs == nil) then
        return false
    end
    return (hs._shadow_id ~= nil and hs._type == "normal")
end

--- 判断一个物品是否影子物品的暗面物品
---@param itOrIdOrName userdata|string|number
---@return boolean
hitem.isShadowBack = function(itOrIdOrName)
    local hs = hitem.getHSlk(itOrIdOrName)
    if (hs == nil) then
        return false
    end
    return (hs._shadow_id ~= nil and hs._type == "shadow")
end

--- 获取一个物品的影子ID
---@param itOrIdOrName userdata|string|number
---@return string
hitem.shadowID = function(itOrIdOrName)
    local hs = hitem.getHSlk(itOrIdOrName)
    if (hs == nil) then
        print_err("hitem.shadowID")
    end
    if (hs._shadow_id == nil) then
        print_err("hitem.shadowID not shadow item")
    end
    return hs._shadow_id
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
---@alias SlotForEach fun(enumItem: userdata,slotIndex: number):void
---@param whichUnit userdata
---@param action SlotForEach | "function(enumItem, slotIndex) end"
---@return number
hitem.forEach = function(whichUnit, action)
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
    if (true) then
        print(items)
        return {}
    end
    if (whichUnit == nil) then
        return {}
    end
    items = items or {}
    if (type(items) == 'userdata') then
        items = { items }
    end
    local itemKinds = {}
    local itemQuantity = {}
    hitem.forEach(whichUnit, function(slotItem)
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
                for _, need in ipairs(hslk.synthesis.fragmentNeeds) do
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
        local hs = hitem.getHSlk(itId)
        if (hs ~= nil) then
            local overlie = hs._overlie or 1
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
                    local hs = hitem.getHSlk(flagId)
                    if (hs ~= nil) then
                        local overlie = hs._overlie or 1
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
    创建物品
    options = {
        itemId = 'I001', --物品ID
        charges = 1, --物品可使用次数（可选，默认为1）
        whichUnit = nil, --哪个单位（可选）
        x = nil, --哪个坐标X（可选）
        y = nil, --哪个坐标Y（可选）
        during = 0, --持续时间（可选，如果有whichUnit，此项无效）
    }
]]
hitem.create = function(options)
    if (options.itemId == nil) then
        print_err("hitem create -it-id")
        return
    end
    if (options.charges == nil) then
        options.charges = 1
    end
    if (options.charges < 1) then
        return
    end
    local charges = options.charges
    local during = options.during or 0
    -- 优先级 坐标 > 单位
    local x, y
    local itemId = options.itemId
    if (options.x ~= nil and options.y ~= nil) then
        x = options.x
        y = options.y
    elseif (options.whichUnit ~= nil) then
        x = hunit.x(options.whichUnit)
        y = hunit.y(options.whichUnit)
    else
        print_err("hitem create -position")
        return
    end
    if (type(itemId) == "string") then
        itemId = string.char2id(itemId)
    end
    local it
    -- 如果不是创建给单位，又或者单位已经不存在了，直接返回
    if (options.whichUnit == nil or his.deleted(options.whichUnit) or his.dead(options.whichUnit)) then
        -- 如果是shadow物品的明面物品，转成暗面物品再创建
        if (hitem.isShadowFront(itemId)) then
            itemId = hitem.shadowID(itemId)
        end
        -- 掉在地上
        it = cj.CreateItem(itemId, x, y)
        cj.SetItemCharges(it, charges)
        hitemPool.insert("h-lua-pick", it)
        if (options.whichUnit ~= nil and during > 0) then
            htime.setTimeout(during, function(t)
                htime.delTimer(t)
                hitem.del(it, 0)
            end)
        end
    else
        -- 单位流程
        it = cj.CreateItem(itemId, x, y)
        if (hitem.getIsPowerUp(itemId)) then
            -- 如果是powerUp类型，直接给予单位，后续流程交予[hevent_default_actions.item.pickup]事件
            -- 因为shadow物品的暗面物品一定是powerup，所以无需额外处理
            cj.SetItemCharges(it, charges)
            cj.UnitAddItem(options.whichUnit, it)
        elseif (hitem.getEmptySlot(options.whichUnit) > 0) then
            -- 没有满格,单位直接获得，后续流程交予[hevent_default_actions.item.pickup]事件
            cj.SetItemCharges(it, charges)
            cj.UnitAddItem(options.whichUnit, it)
        elseif (hitem.isShadowFront(itemId)) then
            -- 满格了，如果是shadow的明面物品；转shadow再给与单位，后续流程交予[hevent_default_actions.item.pickup]事件
            itemId = hitem.shadowID(itemId)
            hitem.del(it)
            -- 掉在地上
            it = cj.CreateItem(itemId, x, y)
            cj.SetItemCharges(it, charges)
            hitemPool.insert("h-lua-pick", it)
        else
            -- 满格了，如果是一般物品；掉在地上
            cj.SetItemCharges(it, charges)
            hitemPool.insert("h-lua-pick", it)
        end
    end
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
            hitem.create({
                itemId = hitem.getId(it),
                charges = hitem.getCharges(it),
                whichUnit = target
            })
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
            hitem.create({
                itemId = hitem.getId(it),
                charges = hitem.getCharges(it),
                whichUnit = target,
            })
        end
    end
end

--- 令一个单位把物品扔在地上
---@param origin userdata
---@param slot nil|number 物品位置
hitem.drop = function(origin, slot)
    if (origin == nil or his.deleted(origin) or his.dead(origin)) then
        return
    end
    if (slot == nil) then
        for i = 0, 5, 1 do
            local it = cj.UnitItemInSlot(origin, i)
            if (it ~= nil) then
                cj.UnitDropItemPoint(origin, it, hunit.x(origin), hunit.y(origin))
            end
        end
    else
        local it = cj.UnitItemInSlot(origin, slot)
        if (it ~= nil) then
            cj.UnitDropItemPoint(origin, it, hunit.x(origin), hunit.y(origin))
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
    hitemPool.forEach("pick", function(enumItem)
        if (hitem.getEmptySlot(u) > 0) then
            local xi = cj.GetItemX(enumItem)
            local yi = cj.GetItemY(enumItem)
            local d = math.getDistanceBetweenXY(x, y, xi, yi)
            local deg = math.getDegBetweenXY(x, y, xi, yi)
            local distance = math.getMaxDistanceInRect(w, h, deg)
            if (d <= distance) then
                hitem.pick(enumItem, u)
            end
        else
            break
        end
    end)
end

-- 一键拾取圆(x,y)半径(r)
---@param u userdata
---@param x number
---@param y number
---@param r number
hitem.pickRound = function(u, x, y, r)
    hitemPool.forEach("pick", function(enumItem)
        if (hitem.getEmptySlot(u) > 0) then
            local xi = cj.GetItemX(enumItem)
            local yi = cj.GetItemY(enumItem)
            local d = math.getDistanceBetweenXY(x, y, xi, yi)
            if (d <= r) then
                hitem.pick(enumItem, u)
            else
                print("break")
                break
            end
            print("pickRound.forEach")
        end
    end)
end