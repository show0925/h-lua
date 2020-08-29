hevent = {
    POOL = {},
    POOL_RED_LINE = 1000,
}

--- set
---@private
hevent.set = function(handle, key, value)
    if (handle == nil) then
        print_stack()
        return
    end
    if (hRuntime.event[handle] == nil) then
        hRuntime.event[handle] = {}
    end
    hRuntime.event[handle][key] = value
end

--- get
---@private
hevent.get = function(handle, key)
    if (handle == nil) then
        print_stack()
        return
    end
    if (hRuntime.event[handle] == nil) then
        hRuntime.event[handle] = {}
    end
    return hRuntime.event[handle][key]
end

--- 触发池
--- 使用一个handle，以不同的conditionAction累计计数
--- 分配触发到回调注册
--- 触发池的action是不会被同一个handle注册两次的，与on事件并不相同
---@protected
hevent.pool = function(handle, conditionAction, regEvent)
    if (type(regEvent) ~= 'function') then
        return
    end
    local key = cj.GetHandleId(conditionAction)
    -- 如果这个handle已经注册过此动作，则不重复注册
    if (hRuntime.event.pool[handle] ~= nil) then
        local isInPool = false
        for _, p in ipairs(hRuntime.event.pool[handle]) do
            if p.key == key then
                isInPool = true
                break
            end
        end
        if (isInPool) then
            return
        end
    end
    if (hevent.POOL[key] == nil) then
        hevent.POOL[key] = {}
    end
    local poolIndex = #hevent.POOL[key]
    if (poolIndex <= 0 or hevent.POOL[key][poolIndex].count >= hevent.POOL_RED_LINE) then
        local tgr = cj.CreateTrigger()
        table.insert(hevent.POOL[key], {
            stock = 0,
            count = 0,
            trigger = tgr
        })
        cj.TriggerAddCondition(tgr, conditionAction)
        poolIndex = #hevent.POOL[key]
    end
    if (hRuntime.event.pool[handle] == nil) then
        hRuntime.event.pool[handle] = {}
    end
    table.insert(hRuntime.event.pool[handle], {
        key = key,
        poolIndex = poolIndex,
    })
    hevent.POOL[key][poolIndex].count = hevent.POOL[key][poolIndex].count + 1
    hevent.POOL[key][poolIndex].stock = hevent.POOL[key][poolIndex].stock + 1
    regEvent(hevent.POOL[key][poolIndex].trigger)
end

--- set最后一位伤害的单位
---@protected
hevent.setLastDamageUnit = function(whichUnit, lastUnit)
    if (whichUnit == nil and lastUnit == nil) then
        return
    end
    hevent.set(whichUnit, "lastDamageUnit", lastUnit)
end

--- 最后一位伤害的单位
---@protected
hevent.getLastDamageUnit = function(whichUnit)
    return hevent.get(whichUnit, "lastDamageUnit")
end

--- 注册事件，会返回一个event_id（私有通用）
---@protected
hevent.registerEvent = function(handle, key, callFunc)
    if (hRuntime.event.register[handle] == nil) then
        hRuntime.event.register[handle] = {}
    end
    if (hRuntime.event.register[handle][key] == nil) then
        hRuntime.event.register[handle][key] = {}
    end
    table.insert(hRuntime.event.register[handle][key], callFunc)
    return #hRuntime.event.register[handle][key]
end

--- 触发事件（私有通用）
---@protected
hevent.triggerEvent = function(handle, key, triggerData)
    if (handle == nil) then
        return
    end
    if (hRuntime.event.register[handle] == nil or hRuntime.event.register[handle][key] == nil) then
        return
    end
    if (#hRuntime.event.register[handle][key] <= 0) then
        return
    end
    -- 处理数据
    triggerData = triggerData or {}
    if (triggerData.triggerSkill ~= nil and type(triggerData.triggerSkill) == "number") then
        triggerData.triggerSkill = string.id2char(triggerData.triggerSkill)
    end
    if (triggerData.targetLoc ~= nil) then
        triggerData.targetX = cj.GetLocationX(triggerData.targetLoc)
        triggerData.targetY = cj.GetLocationY(triggerData.targetLoc)
        triggerData.targetZ = cj.GetLocationZ(triggerData.targetLoc)
        cj.RemoveLocation(triggerData.targetLoc)
        triggerData.targetLoc = nil
    end
    for _, callFunc in ipairs(hRuntime.event.register[handle][key]) do
        callFunc(triggerData)
    end
end

--- 删除事件（需要event_id）
---@param handle userdata
---@param key string
---@param eventId any
hevent.deleteEvent = function(handle, key, eventId)
    if (handle == nil or key == nil or eventId == nil) then
        print_stack()
        return
    end
    if (hRuntime.event.register[handle] == nil or hRuntime.event.register[handle][key] == nil) then
        return
    end
    table.remove(hRuntime.event.register[handle], eventId)
end

--- 注意到攻击目标
---@alias onAttackDetect fun(evtData: {triggerUnit:"触发单位",targetUnit:"目标单位"}):void
---@param whichUnit userdata
---@param callFunc onAttackDetect | "function(evtData) end"
---@return any
hevent.onAttackDetect = function(whichUnit, callFunc)
    hevent.pool(whichUnit, hevent_default_actions.unit.attackDetect, function(tgr)
        cj.TriggerRegisterUnitEvent(tgr, whichUnit, EVENT_UNIT_ACQUIRED_TARGET)
    end)
    return hevent.registerEvent(whichUnit, CONST_EVENT.attackDetect, callFunc)
end

--- 获取攻击目标
---@alias onAttackGetTarget fun(evtData: {triggerUnit:"触发单位",targetUnit:"目标单位"}):void
---@param whichUnit userdata
---@param callFunc onAttackGetTarget | "function(evtData) end"
---@return any
hevent.onAttackGetTarget = function(whichUnit, callFunc)
    hevent.pool(whichUnit, hevent_default_actions.unit.attackGetTarget, function(tgr)
        cj.TriggerRegisterUnitEvent(tgr, whichUnit, EVENT_UNIT_TARGET_IN_RANGE)
    end)
    return hevent.registerEvent(whichUnit, CONST_EVENT.attackGetTarget, callFunc)
end

--- 准备被攻击
---@alias onBeAttackReady fun(evtData: {triggerUnit:"被攻击单位",targetUnit:"攻击单位",attacker:"攻击单位"}):void
---@param whichUnit userdata
---@param callFunc onBeAttackReady | "function(evtData) end"
---@return any
hevent.onBeAttackReady = function(whichUnit, callFunc)
    hevent.pool(whichUnit, hevent_default_actions.unit.beAttackReady, function(tgr)
        cj.TriggerRegisterUnitEvent(tgr, whichUnit, EVENT_UNIT_ATTACKED)
    end)
    return hevent.registerEvent(whichUnit, CONST_EVENT.beAttackReady, callFunc)
end

--- 造成攻击
---@alias onAttack fun(evtData: {triggerUnit:"攻击单位",targetUnit:"被攻击单位",attacker:"攻击单位",damage:"伤害",damageKind:"伤害方式",damageType:"伤害类型"}):void
---@param whichUnit userdata
---@param callFunc onAttack | "function(evtData) end"
---@return any
hevent.onAttack = function(whichUnit, callFunc)
    return hevent.registerEvent(whichUnit, CONST_EVENT.attack, callFunc)
end

--- 承受攻击
---@alias onBeAttack fun(evtData: {triggerUnit:"被攻击单位",targetUnit:"被攻击单位",attacker:"攻击来源",damage:"伤害",damageKind:"伤害方式",damageType:"伤害类型"}):void
---@param whichUnit userdata
---@param callFunc onBeAttack | "function(evtData) end"
---@return any
hevent.onBeAttack = function(whichUnit, callFunc)
    return hevent.registerEvent(whichUnit, CONST_EVENT.beAttack, callFunc)
end

--- 学习技能
---@alias onSkillStudy fun(evtData: {triggerUnit:"学习单位",triggerSkill:"学习技能ID字符串"}):void
---@param whichUnit userdata
---@param callFunc onSkillStudy | "function(evtData) end"
---@return any
hevent.onSkillStudy = function(whichUnit, callFunc)
    hevent.pool(whichUnit, hevent_default_actions.unit.skillStudy, function(tgr)
        cj.TriggerRegisterUnitEvent(tgr, whichUnit, EVENT_UNIT_HERO_SKILL)
    end)
    return hevent.registerEvent(whichUnit, CONST_EVENT.skillStudy, callFunc)
end

--- 准备施放技能
---@alias onSkillReady fun(evtData: {triggerUnit:"施放单位",triggerSkill:"施放技能ID字符串",targetUnit:"获取目标单位",targetX:"获取施放目标点X",targetY:"获取施放目标点Y",targetZ:"获取施放目标点Z"}):void
---@param whichUnit userdata
---@param callFunc onSkillReady | "function(evtData) end"
---@return any
hevent.onSkillReady = function(whichUnit, callFunc)
    hevent.pool(whichUnit, hevent_default_actions.unit.skillReady, function(tgr)
        cj.TriggerRegisterUnitEvent(tgr, whichUnit, EVENT_UNIT_SPELL_CHANNEL)
    end)
    return hevent.registerEvent(whichUnit, CONST_EVENT.skillReady, callFunc)
end

--- 开始施放技能
---@alias onSkillCast fun(evtData: {triggerUnit:"施放单位",triggerSkill:"施放技能ID字符串",targetUnit:"获取目标单位",targetX:"获取施放目标点X",targetY:"获取施放目标点Y",targetZ:"获取施放目标点Z"}):void
---@param whichUnit userdata
---@param callFunc onSkillCast | "function(evtData) end"
---@return any
hevent.onSkillCast = function(whichUnit, callFunc)
    hevent.pool(whichUnit, hevent_default_actions.unit.skillCast, function(tgr)
        cj.TriggerRegisterUnitEvent(tgr, whichUnit, EVENT_UNIT_SPELL_CAST)
    end)
    return hevent.registerEvent(whichUnit, CONST_EVENT.skillCast, callFunc)
end

--- 停止施放技能
---@alias onSkillStop fun(evtData: {triggerUnit:"施放单位",triggerSkill:"施放技能ID字符串"}):void
---@param whichUnit userdata
---@param callFunc onSkillStop | "function(evtData) end"
---@return any
hevent.onSkillStop = function(whichUnit, callFunc)
    hevent.pool(whichUnit, hevent_default_actions.unit.skillStop, function(tgr)
        cj.TriggerRegisterUnitEvent(tgr, whichUnit, EVENT_UNIT_SPELL_ENDCAST)
    end)
    return hevent.registerEvent(whichUnit, CONST_EVENT.skillStop, callFunc)
end

--- 发动技能效果
---@alias onSkillEffect fun(evtData: {triggerUnit:"施放单位",triggerSkill:"施放技能ID字符串",targetUnit:"获取目标单位",targetX:"获取施放目标点X",targetY:"获取施放目标点Y",targetZ:"获取施放目标点Z"}):void
---@param whichUnit userdata
---@param callFunc onSkillEffect | "function(evtData) end"
---@return any
hevent.onSkillEffect = function(whichUnit, callFunc)
    hevent.pool(whichUnit, hevent_default_actions.unit.skillEffect, function(tgr)
        cj.TriggerRegisterUnitEvent(tgr, whichUnit, EVENT_UNIT_SPELL_EFFECT)
    end)
    return hevent.registerEvent(whichUnit, CONST_EVENT.skillEffect, callFunc)
end

--- 施放技能结束
---@alias onSkillFinish fun(evtData: {triggerUnit:"施放单位",triggerSkill:"施放技能ID字符串"}):void
---@param whichUnit userdata
---@param callFunc onSkillFinish | "function(evtData) end"
---@return any
hevent.onSkillFinish = function(whichUnit, callFunc)
    hevent.pool(whichUnit, hevent_default_actions.unit.skillFinish, function(tgr)
        cj.TriggerRegisterUnitEvent(tgr, whichUnit, EVENT_UNIT_SPELL_FINISH)
    end)
    return hevent.registerEvent(whichUnit, CONST_EVENT.skillFinish, callFunc)
end

--- 单位使用物品
---@alias onItemUsed fun(evtData: {triggerUnit:"触发单位",triggerItem:"触发物品"}):void
---@param whichUnit userdata
---@param callFunc onItemUsed | "function(evtData) end"
---@return any
hevent.onItemUsed = function(whichUnit, callFunc)
    return hevent.registerEvent(whichUnit, CONST_EVENT.itemUsed, callFunc)
end

--- 丢弃(传递)物品
---@alias onItemDrop fun(evtData: {triggerUnit:"丢弃单位",targetUnit:"获得单位（如果有）",triggerItem:"触发物品"}):void
---@param whichUnit userdata
---@return any
hevent.onItemDrop = function(whichUnit, callFunc)
    return hevent.registerEvent(whichUnit, CONST_EVENT.itemDrop, callFunc)
end

--- 获得物品
---@alias onItemGet fun(evtData: {triggerUnit:"触发单位",triggerItem:"触发物品"}):void
---@param whichUnit userdata
---@param callFunc onItemGet | "function(evtData) end"
---@return any
hevent.onItemGet = function(whichUnit, callFunc)
    return hevent.registerEvent(whichUnit, CONST_EVENT.itemGet, callFunc)
end

--- 抵押物品（玩家把物品扔给商店）
---@alias onItemPawn fun(evtData: {triggerUnit:"触发单位",soldItem:"抵押物品",buyingUnit:"抵押商店",soldGold:"抵押获得黄金",soldLumber:"抵押获得木头"}):void
---@param whichUnit userdata
---@param callFunc onItemPawn | "function(evtData) end"
---@return any
hevent.onItemPawn = function(whichUnit, callFunc)
    return hevent.registerEvent(whichUnit, CONST_EVENT.itemPawn, callFunc)
end

--- 出售物品(商店卖给玩家)
---@alias onItemSell fun(evtData: {triggerUnit:"售卖单位",soldItem:"售卖物品",buyingUnit:"购买单位"}):void
---@param whichUnit userdata
---@param callFunc onItemSell | "function(evtData) end"
---@return any
hevent.onItemSell = function(whichUnit, callFunc)
    hevent.pool(whichUnit, hevent_default_actions.item.sell, function(tgr)
        cj.TriggerRegisterUnitEvent(tgr, whichUnit, EVENT_UNIT_SELL_ITEM)
    end)
    return hevent.registerEvent(whichUnit, CONST_EVENT.itemSell, callFunc)
end

--- 出售单位(商店卖给玩家)
---@alias onUnitSell fun(evtData: {triggerUnit:"商店单位",soldUnit:"被售卖单位",buyingUnit:"购买单位"}):void
---@param whichUnit userdata
---@param callFunc onUnitSell | "function(evtData) end"
---@return any
hevent.onUnitSell = function(whichUnit, callFunc)
    hevent.pool(whichUnit, hevent_default_actions.unit.sell, function(tgr)
        cj.TriggerRegisterUnitEvent(tgr, whichUnit, EVENT_UNIT_SELL)
    end)
    return hevent.registerEvent(whichUnit, CONST_EVENT.unitSell, callFunc)
end

--- 物品被破坏
---@alias onItemDestroy fun(evtData: {triggerUnit:"触发单位",triggerItem:"触发物品"}):void
---@param whichItem userdata
---@param callFunc onItemDestroy | "function(evtData) end"
---@return any
hevent.onItemDestroy = function(whichItem, callFunc)
    hevent.pool(whichItem, hevent_default_actions.item.destroy, function(tgr)
        cj.TriggerRegisterDeathEvent(tgr, whichItem)
    end)
    return hevent.registerEvent(whichItem, CONST_EVENT.itemDestroy, callFunc)
end

--- 合成物品
---@alias onItemMixed fun(evtData: {triggerUnit:"触发单位",triggerItem:"合成物品"}):void
---@param whichUnit userdata
---@param callFunc onItemMixed | "function(evtData) end"
---@return any
hevent.onItemMixed = function(whichUnit, callFunc)
    return hevent.registerEvent(whichUnit, CONST_EVENT.itemMixed, callFunc)
end

--- 拆分物品
---@alias onItemSeparate fun(evtData: {triggerUnit:"触发单位",triggerItemId:"被拆分物品ID字符串",type:"拆分的类型:simple(多次数)|mixed(合成物)"}):void
---@param whichUnit userdata
---@param callFunc onItemSeparate | "function(evtData) end"
---@return any
hevent.onItemSeparate = function(whichUnit, callFunc)
    return hevent.registerEvent(whichUnit, CONST_EVENT.itemSeparate, callFunc)
end

--- 物品超重
---@alias onItemOverWeight fun(evtData: {triggerUnit:"触发单位",triggerItem:"得到的物品",value:"超出的重量(kg)"}):void
---@param whichUnit userdata
---@param callFunc onItemOverWeight | "function(evtData) end"
---@return any
hevent.onItemOverWeight = function(whichUnit, callFunc)
    return hevent.registerEvent(whichUnit, CONST_EVENT.itemOverWeight, callFunc)
end

--- 单位满格
---@alias onItemOverSlot fun(evtData: {triggerUnit:"触发单位",triggerItem:"触发的物品"}):void
---@param whichUnit userdata
---@param callFunc onItemOverSlot | "function(evtData) end"
---@return any
hevent.onItemOverSlot = function(whichUnit, callFunc)
    return hevent.registerEvent(whichUnit, CONST_EVENT.itemOverSlot, callFunc)
end

--- 造成伤害
---@alias onDamage fun(evtData: {triggerUnit:"伤害来源",targetUnit:"被伤害单位",sourceUnit:"伤害来源",damage:"伤害",damageKind:"伤害方式",damageType:"伤害类型"}):void
---@param whichUnit userdata
---@param callFunc onDamage | "function(evtData) end"
---@return any
hevent.onDamage = function(whichUnit, callFunc)
    return hevent.registerEvent(whichUnit, CONST_EVENT.damage, callFunc)
end

--- 承受伤害
---@alias onBeDamage fun(evtData: {triggerUnit:"被伤害单位",sourceUnit:"伤害来源",damage:"伤害",damageKind:"伤害方式",damageType:"伤害类型"}):void
---@param whichUnit userdata
---@param callFunc onBeDamage | "function(evtData) end"
---@return any
hevent.onBeDamage = function(whichUnit, callFunc)
    return hevent.registerEvent(whichUnit, CONST_EVENT.beDamage, callFunc)
end

--- 回避攻击成功
---@alias onAvoid fun(evtData: {triggerUnit:"触发单位",attacker:"攻击单位"}):void
---@param whichUnit userdata
---@param callFunc onAvoid | "function(evtData) end"
---@return any
hevent.onAvoid = function(whichUnit, callFunc)
    return hevent.registerEvent(whichUnit, CONST_EVENT.avoid, callFunc)
end

--- 攻击被回避
---@alias onBeAvoid fun(evtData: {triggerUnit:"攻击单位",attacker:"攻击单位",targetUnit:"回避的单位"}):void
---@param whichUnit userdata
---@param callFunc onBeAvoid | "function(evtData) end"
---@return any
hevent.onBeAvoid = function(whichUnit, callFunc)
    return hevent.registerEvent(whichUnit, CONST_EVENT.beAvoid, callFunc)
end

--- 破防（护甲/魔抗）成功
---@alias onBreakArmor fun(evtData: {breakType:"无视类型",triggerUnit:"触发无视单位",targetUnit:"目标单位",value:"破防的数值"}):void
---@param whichUnit userdata
---@param callFunc onBreakArmor | "function(evtData) end"
---@return any
hevent.onBreakArmor = function(whichUnit, callFunc)
    return hevent.registerEvent(whichUnit, CONST_EVENT.breakArmor, callFunc)
end

--- 被破防（护甲/魔抗）成功
---@alias onBeBreakArmor fun(evtData: {breakType:"无视类型",triggerUnit:"被破甲单位",sourceUnit:"来源单位",value:"破防的数值"}):void
---@param whichUnit userdata
---@param callFunc onBeBreakArmor | "function(evtData) end"
---@return any
hevent.onBeBreakArmor = function(whichUnit, callFunc)
    return hevent.registerEvent(whichUnit, CONST_EVENT.beBreakArmor, callFunc)
end

--- 眩晕成功
---@alias onSwim fun(evtData: {triggerUnit:"触发单位",targetUnit:"被眩晕单位",odds:"几率百分比",during:"持续时间（秒）",damage:"伤害"}):void
---@param whichUnit userdata
---@param callFunc onSwim | "function(evtData) end"
---@return any
hevent.onSwim = function(whichUnit, callFunc)
    return hevent.registerEvent(whichUnit, CONST_EVENT.swim, callFunc)
end

--- 被眩晕
---@alias onBeSwim fun(evtData: {triggerUnit:"触发单位",sourceUnit:"来源单位",odds:"几率百分比",during:"持续时间（秒）",damage:"伤害"}):void
---@param whichUnit userdata
---@param callFunc onBeSwim | "function(evtData) end"
---@return any
hevent.onBeSwim = function(whichUnit, callFunc)
    return hevent.registerEvent(whichUnit, CONST_EVENT.beSwim, callFunc)
end

--- 打断成功
---@alias onBroken fun(evtData: {triggerUnit:"触发单位",targetUnit:"被打断单位",odds:"几率百分比",damage:"伤害"}):void
---@param whichUnit userdata
---@param callFunc onBroken | "function(evtData) end"
---@return any
hevent.onBroken = function(whichUnit, callFunc)
    return hevent.registerEvent(whichUnit, CONST_EVENT.broken, callFunc)
end

--- 被打断
---@alias onBeBroken fun(evtData: {triggerUnit:"触发单位",sourceUnit:"来源单位",odds:"几率百分比",damage:"伤害"}):void
---@param whichUnit userdata
---@param callFunc onBeBroken | "function(evtData) end"
---@return any
hevent.onBeBroken = function(whichUnit, callFunc)
    return hevent.registerEvent(whichUnit, CONST_EVENT.beBroken, callFunc)
end

--- 沉默成功
---@alias onSilent fun(evtData: {triggerUnit:"触发单位",targetUnit:"被沉默单位",odds:"几率百分比",during:"持续时间（秒）",damage:"伤害"}):void
---@param whichUnit userdata
---@param callFunc onSilent | "function(evtData) end"
---@return any
hevent.onSilent = function(whichUnit, callFunc)
    return hevent.registerEvent(whichUnit, CONST_EVENT.silent, callFunc)
end

--- 被沉默
---@alias onBeSilent fun(evtData: {triggerUnit:"触发单位",sourceUnit:"来源单位",odds:"几率百分比",during:"持续时间（秒）",damage:"伤害"}):void
---@param whichUnit userdata
---@param callFunc onBeSilent | "function(evtData) end"
---@return any
hevent.onBeSilent = function(whichUnit, callFunc)
    return hevent.registerEvent(whichUnit, CONST_EVENT.beSilent, callFunc)
end

--- 缴械成功
---@alias onUnarm fun(evtData: {triggerUnit:"触发单位",targetUnit:"被缴械单位",odds:"几率百分比",during:"持续时间（秒）",damage:"伤害"}):void
---@param whichUnit userdata
---@param callFunc onUnarm | "function(evtData) end"
---@return any
hevent.onUnarm = function(whichUnit, callFunc)
    return hevent.registerEvent(whichUnit, CONST_EVENT.unarm, callFunc)
end

--- 被缴械
---@alias onBeUnarm fun(evtData: {triggerUnit:"触发单位",sourceUnit:"来源单位",odds:"几率百分比",during:"持续时间（秒）",damage:"伤害"}):void
---@param whichUnit userdata
---@param callFunc onBeUnarm | "function(evtData) end"
---@return any
hevent.onBeUnarm = function(whichUnit, callFunc)
    return hevent.registerEvent(whichUnit, CONST_EVENT.beUnarm, callFunc)
end

--- 缚足成功
---@alias onFetter fun(evtData: {triggerUnit:"触发单位",targetUnit:"被缚足单位",odds:"几率百分比",during:"持续时间（秒）",damage:"伤害"}):void
---@param whichUnit userdata
---@param callFunc onFetter | "function(evtData) end"
---@return any
hevent.onFetter = function(whichUnit, callFunc)
    return hevent.registerEvent(whichUnit, CONST_EVENT.fetter, callFunc)
end

--- 被缚足
---@alias onBeFetter fun(evtData: {triggerUnit:"触发单位",sourceUnit:"来源单位",odds:"几率百分比",during:"持续时间（秒）",damage:"伤害"}):void
---@param whichUnit userdata
---@param callFunc onBeFetter | "function(evtData) end"
---@return any
hevent.onBeFetter = function(whichUnit, callFunc)
    return hevent.registerEvent(whichUnit, CONST_EVENT.beFetter, callFunc)
end

--- 爆破成功
---@alias onBomb fun(evtData: {triggerUnit:"触发单位",targetUnit:"被爆破单位",odds:"几率百分比",range:"爆破范围",damage:"伤害"}):void
---@param whichUnit userdata
---@param callFunc onBomb | "function(evtData) end"
---@return any
hevent.onBomb = function(whichUnit, callFunc)
    return hevent.registerEvent(whichUnit, CONST_EVENT.bomb, callFunc)
end

--- 被爆破
---@alias onBeBomb fun(evtData: {triggerUnit:"触发单位",sourceUnit:"来源单位",odds:"几率百分比",range:"爆破范围",damage:"伤害"}):void
---@param whichUnit userdata
---@param callFunc onBeBomb | "function(evtData) end"
---@return any
hevent.onBeBomb = function(whichUnit, callFunc)
    return hevent.registerEvent(whichUnit, CONST_EVENT.beBomb, callFunc)
end

--- 闪电链成功
---@alias onLightningChain fun(evtData: {triggerUnit:"触发单位",targetUnit:"被闪电链单位",odds:"几率百分比",range:"闪电链范围",damage:"伤害",index:"是第几个被电到的"}):void
---@param whichUnit userdata
---@param callFunc onLightningChain | "function(evtData) end"
---@return any
hevent.onLightningChain = function(whichUnit, callFunc)
    return hevent.registerEvent(whichUnit, CONST_EVENT.lightningChain, callFunc)
end

--- 被闪电链
---@alias onBeLightningChain fun(evtData: {triggerUnit:"触发单位",sourceUnit:"来源单位",odds:"几率百分比",range:"闪电链范围",damage:"伤害",index:"是第几个被电到的"}):void
---@param whichUnit userdata
---@param callFunc onBeLightningChain | "function(evtData) end"
---@return any
hevent.onBeLightningChain = function(whichUnit, callFunc)
    return hevent.registerEvent(whichUnit, CONST_EVENT.beLightningChain, callFunc)
end

--- 击飞成功
---@alias onCrackFly fun(evtData: {triggerUnit:"触发单位",targetUnit:"被击飞单位",odds:"几率百分比",damage:"伤害",high:"击飞高度",distance:"击飞距离"}):void
---@param whichUnit userdata
---@param callFunc onCrackFly | "function(evtData) end"
---@return any
hevent.onCrackFly = function(whichUnit, callFunc)
    return hevent.registerEvent(whichUnit, CONST_EVENT.crackFly, callFunc)
end

--- 被击飞
---@alias onBeCrackFly fun(evtData: {triggerUnit:"触发单位",sourceUnit:"来源单位",odds:"几率百分比",damage:"伤害",high:"击飞高度",distance:"击飞距离"}):void
---@param whichUnit userdata
---@param callFunc onBeCrackFly | "function(evtData) end"
---@return any
hevent.onBeCrackFly = function(whichUnit, callFunc)
    return hevent.registerEvent(whichUnit, CONST_EVENT.beCrackFly, callFunc)
end

--- 反伤时
---@alias onRebound fun(evtData: {triggerUnit:"触发单位",sourceUnit:"来源单位",damage:"反伤伤害"}):void
---@param whichUnit userdata
---@param callFunc onRebound | "function(evtData) end"
---@return any
hevent.onRebound = function(whichUnit, callFunc)
    return hevent.registerEvent(whichUnit, CONST_EVENT.rebound, callFunc)
end

--- 被反伤时
---@alias onBeRebound fun(evtData: {triggerUnit:"触发单位",sourceUnit:"来源单位",damage:"反伤伤害"}):void
---@param whichUnit userdata
---@param callFunc onBeRebound | "function(evtData) end"
---@return any
hevent.onBeRebound = function(whichUnit, callFunc)
    return hevent.registerEvent(whichUnit, CONST_EVENT.beRebound, callFunc)
end

--- 造成无法回避的伤害时
---@alias onNoAvoid fun(evtData: {triggerUnit:"触发单位",targetUnit:"目标单位",damage:"伤害"}):void
---@param whichUnit userdata
---@param callFunc onNoAvoid | "function(evtData) end"
---@return any
hevent.onNoAvoid = function(whichUnit, callFunc)
    return hevent.registerEvent(whichUnit, CONST_EVENT.noAvoid, callFunc)
end

--- 被造成无法回避的伤害时
---@alias onBeNoAvoid fun(evtData: {triggerUnit:"触发单位",sourceUnit:"来源单位",damage:"伤害"}):void
---@param whichUnit userdata
---@param callFunc onBeNoAvoid | "function(evtData) end"
---@return any
hevent.onBeNoAvoid = function(whichUnit, callFunc)
    return hevent.registerEvent(whichUnit, CONST_EVENT.beNoAvoid, callFunc)
end

--- 物理暴击时
---@alias onKnocking fun(evtData: {triggerUnit:"触发单位",targetUnit:"目标单位",damage:"伤害",odds:"几率百分比",percent:"增幅百分比"}):void
---@param whichUnit userdata
---@param callFunc onKnocking | "function(evtData) end"
---@return any
hevent.onKnocking = function(whichUnit, callFunc)
    return hevent.registerEvent(whichUnit, CONST_EVENT.knocking, callFunc)
end

--- 承受物理暴击时
---@alias onBeKnocking fun(evtData: {triggerUnit:"触发单位",sourceUnit:"来源单位",damage:"伤害",odds:"几率百分比",percent:"增幅百分比"}):void
---@param whichUnit userdata
---@param callFunc onBeKnocking | "function(evtData) end"
---@return any
hevent.onBeKnocking = function(whichUnit, callFunc)
    return hevent.registerEvent(whichUnit, CONST_EVENT.beKnocking, callFunc)
end

--- 魔法暴击时
---@alias onViolence fun(evtData: {triggerUnit:"触发单位",targetUnit:"目标单位",damage:"伤害",odds:"几率百分比",percent:"增幅百分比"}):void
---@param whichUnit userdata
---@param callFunc onViolence | "function(evtData) end"
---@return any
hevent.onViolence = function(whichUnit, callFunc)
    return hevent.registerEvent(whichUnit, CONST_EVENT.violence, callFunc)
end

--- 承受魔法暴击时
---@alias onBeViolence fun(evtData: {triggerUnit:"触发单位",sourceUnit:"来源单位",damage:"伤害",odds:"几率百分比",percent:"增幅百分比"}):void
---@param whichUnit userdata
---@param callFunc onBeViolence | "function(evtData) end"
---@return any
hevent.onBeViolence = function(whichUnit, callFunc)
    return hevent.registerEvent(whichUnit, CONST_EVENT.beViolence, callFunc)
end

--- 分裂时
---@alias onSpilt fun(evtData: {triggerUnit:"触发单位",targetUnit:"目标单位",damage:"伤害",range:"分裂范围",percent:"增幅百分比"}):void
---@param whichUnit userdata
---@param callFunc onSpilt | "function(evtData) end"
---@return any
hevent.onSpilt = function(whichUnit, callFunc)
    return hevent.registerEvent(whichUnit, CONST_EVENT.spilt, callFunc)
end

--- 承受分裂时
---@alias onBeSpilt fun(evtData: {triggerUnit:"触发单位",sourceUnit:"来源单位",damage:"伤害",range:"分裂范围",percent:"增幅百分比"}):void
---@param whichUnit userdata
---@param callFunc onBeSpilt | "function(evtData) end"
---@return any
hevent.onBeSpilt = function(whichUnit, callFunc)
    return hevent.registerEvent(whichUnit, CONST_EVENT.beSpilt, callFunc)
end

--- 极限减伤抵抗（减伤不足以抵扣）
---@alias onLimitToughness fun(evtData: {triggerUnit:"触发单位",sourceUnit:"来源单位"}):void
---@param whichUnit userdata
---@param callFunc onLimitToughness | "function(evtData) end"
---@return any
hevent.onLimitToughness = function(whichUnit, callFunc)
    return hevent.registerEvent(whichUnit, CONST_EVENT.limitToughness, callFunc)
end

--- 吸血时
---@alias onHemophagia fun(evtData: {triggerUnit:"触发单位",targetUnit:"目标单位",value:"吸血值",percent:"吸血百分比"}):void
---@param whichUnit userdata
---@param callFunc onHemophagia | "function(evtData) end"
---@return any
hevent.onHemophagia = function(whichUnit, callFunc)
    return hevent.registerEvent(whichUnit, CONST_EVENT.hemophagia, callFunc)
end

--- 被吸血时
---@alias onBeHemophagia fun(evtData: {triggerUnit:"触发单位",sourceUnit:"来源单位",value:"吸血值",percent:"吸血百分比"}):void
---@param whichUnit userdata
---@param callFunc onBeHemophagia | "function(evtData) end"
---@return any
hevent.onBeHemophagia = function(whichUnit, callFunc)
    return hevent.registerEvent(whichUnit, CONST_EVENT.beHemophagia, callFunc)
end

--- 技能吸血时
---@alias onSkillHemophagia fun(evtData: {triggerUnit:"触发单位",targetUnit:"目标单位",value:"吸血值",percent:"吸血百分比"}):void
---@param whichUnit userdata
---@param callFunc onSkillHemophagia | "function(evtData) end"
---@return any
hevent.onSkillHemophagia = function(whichUnit, callFunc)
    return hevent.registerEvent(whichUnit, CONST_EVENT.skillHemophagia, callFunc)
end

--- 被技能吸血时
---@alias onBeHemophagia fun(evtData: {triggerUnit:"触发单位",sourceUnit:"来源单位",value:"吸血值",percent:"吸血百分比"}):void
---@param whichUnit userdata
---@param callFunc onBeHemophagia | "function(evtData) end"
---@return any
hevent.onBeSkillHemophagia = function(whichUnit, callFunc)
    return hevent.registerEvent(whichUnit, CONST_EVENT.beSkillHemophagia, callFunc)
end

--- 硬直时
---@alias onPunish fun(evtData: {triggerUnit:"触发单位",sourceUnit:"来源单位",during:"持续时间",percent:"硬直程度百分比"}):void
---@param whichUnit userdata
---@param callFunc onPunish | "function(evtData) end"
---@return any
hevent.onPunish = function(whichUnit, callFunc)
    return hevent.registerEvent(whichUnit, ONST_EVENT.punish, callFunc)
end

--- 死亡时
---@alias onDead fun(evtData: {triggerUnit:"触发单位",killer:"凶手单位"}):void
---@param whichUnit userdata
---@param callFunc onDead | "function(evtData) end"
---@return any
hevent.onDead = function(whichUnit, callFunc)
    return hevent.registerEvent(whichUnit, CONST_EVENT.dead, callFunc)
end

--- 击杀时
---@alias onKill fun(evtData: {triggerUnit:"触发单位",killer:"凶手单位",targetUnit:"获取死亡单位"}):void
---@param whichUnit userdata
---@param callFunc onKill | "function(evtData) end"
---@return any
hevent.onKill = function(whichUnit, callFunc)
    return hevent.registerEvent(whichUnit, CONST_EVENT.kill, callFunc)
end

--- 复活时(必须使用 hunit.reborn 方法才能嵌入到事件系统)
---@alias onReborn fun(evtData: {triggerUnit:"触发单位"}):void
---@param whichUnit userdata
---@param callFunc onReborn | "function(evtData) end"
---@return any
hevent.onReborn = function(whichUnit, callFunc)
    return hevent.registerEvent(whichUnit, CONST_EVENT.reborn, callFunc)
end

--- 提升等级时
---@alias onLevelUp fun(evtData: {triggerUnit:"触发单位",value:"获取提升了多少级"}):void
---@param whichUnit userdata
---@param callFunc onLevelUp | "function(evtData) end"
---@return any
hevent.onLevelUp = function(whichUnit, callFunc)
    return hevent.registerEvent(whichUnit, CONST_EVENT.levelUp, callFunc)
end

--- 建筑升级开始时
---@alias onUpgradeStart fun(evtData: {triggerUnit:"触发单位"}):void
---@param whichUnit userdata
---@param callFunc onUpgradeStart | "function(evtData) end"
---@return any
hevent.onUpgradeStart = function(whichUnit, callFunc)
    hevent.pool(whichUnit, hevent_default_actions.unit.upgradeStart, function(tgr)
        cj.TriggerRegisterUnitEvent(tgr, whichUnit, EVENT_UNIT_UPGRADE_START)
    end)
    return hevent.registerEvent(whichUnit, CONST_EVENT.upgradeStart, callFunc)
end

--- 建筑升级取消时
---@alias onUpgradeCancel fun(evtData: {triggerUnit:"触发单位"}):void
---@param whichUnit userdata
---@param callFunc onUpgradeCancel | "function(evtData) end"
---@return any
hevent.onUpgradeCancel = function(whichUnit, callFunc)
    hevent.pool(whichUnit, hevent_default_actions.unit.upgradeCancel, function(tgr)
        cj.TriggerRegisterUnitEvent(tgr, whichUnit, EVENT_UNIT_UPGRADE_CANCEL)
    end)
    return hevent.registerEvent(whichUnit, CONST_EVENT.upgradeCancel, callFunc)
end

--- 建筑升级完成时
---@alias onUpgradeFinish fun(evtData: {triggerUnit:"触发单位"}):void
---@param whichUnit userdata
---@param callFunc onUpgradeFinish | "function(evtData) end"
---@return any
hevent.onUpgradeFinish = function(whichUnit, callFunc)
    hevent.pool(whichUnit, hevent_default_actions.unit.upgradeFinish, function(tgr)
        cj.TriggerRegisterUnitEvent(tgr, whichUnit, EVENT_UNIT_UPGRADE_FINISH)
    end)
    return hevent.registerEvent(whichUnit, CONST_EVENT.upgradeFinish, callFunc)
end

--- 进入某单位（whichUnit）范围内
---@alias onEnterUnitRange fun(evtData: {centerUnit:"被进入范围的中心单位",enterUnit:"进入范围的单位",range:"设定范围"}):void
---@param whichUnit userdata
---@param range number
---@param callFunc onEnterUnitRange | "function(evtData) end"
---@return any
hevent.onEnterUnitRange = function(whichUnit, range, callFunc)
    local key = CONST_EVENT.enterUnitRange
    if (hRuntime.unit[whichUnit] == nil) then
        hRuntime.unit[whichUnit] = {}
    end
    if (hRuntime.unit[whichUnit]["onEnterUnitRangeAction" .. range] == nil) then
        hRuntime.unit[whichUnit]["onEnterUnitRangeAction" .. range] = function()
            hevent.triggerEvent(
                whichUnit,
                key,
                {
                    centerUnit = whichUnit,
                    enterUnit = cj.GetTriggerUnit(),
                    range = range
                }
            )
        end
    end
    hevent.pool(
        whichUnit,
        cj.Condition(hRuntime.unit[whichUnit]["onEnterUnitRangeAction" .. range]),
        function(tgr)
            cj.TriggerRegisterUnitInRange(tgr, whichUnit, range, nil)
        end
    )
    return hevent.registerEvent(whichUnit, key, callFunc)
end

--- 进入某区域
---@alias onEnterRect fun(evtData: {triggerRect:"被进入的矩形区域",triggerUnit:"进入矩形区域的单位"}):void
---@param whichRect userdata
---@param callFunc onEnterRect | "function(evtData) end"
---@return any
hevent.onEnterRect = function(whichRect, callFunc)
    local key = CONST_EVENT.enterRect
    if (hRuntime.rect[whichRect] == nil) then
        hRuntime.rect[whichRect] = {}
    end
    if (hRuntime.rect[whichRect].onEnterRectAction == nil) then
        hRuntime.rect[whichRect].onEnterRectAction = function()
            hevent.triggerEvent(
                whichRect,
                key,
                {
                    triggerRect = whichRect,
                    triggerUnit = cj.GetTriggerUnit()
                }
            )
        end
    end
    hevent.pool(
        whichRect,
        cj.Condition(hRuntime.rect[whichRect].onEnterRectAction),
        function(tgr)
            local rectRegion = cj.CreateRegion()
            cj.RegionAddRect(rectRegion, whichRect)
            cj.TriggerRegisterEnterRegion(tgr, rectRegion, nil)
        end
    )
    return hevent.registerEvent(whichRect, key, callFunc)
end

--- 离开某区域
---@alias onLeaveRect fun(evtData: {triggerRect:"被离开的矩形区域",triggerUnit:"离开矩形区域的单位"}):void
---@param whichRect userdata
---@param callFunc onLeaveRect | "function(evtData) end"
---@return any
hevent.onLeaveRect = function(whichRect, callFunc)
    local key = CONST_EVENT.leaveRect
    if (hRuntime.rect[whichRect] == nil) then
        hRuntime.rect[whichRect] = {}
    end
    if (hRuntime.rect[whichRect].onLeaveRectAction == nil) then
        hRuntime.rect[whichRect].onLeaveRectAction = function()
            hevent.triggerEvent(
                whichRect,
                key,
                {
                    triggerRect = whichRect,
                    triggerUnit = cj.GetTriggerUnit()
                }
            )
        end
    end
    hevent.pool(
        whichRect,
        cj.Condition(hRuntime.rect[whichRect].onLeaveRectAction),
        function(tgr)
            local rectRegion = cj.CreateRegion()
            cj.RegionAddRect(rectRegion, whichRect)
            cj.TriggerRegisterLeaveRegion(tgr, rectRegion, nil)
        end
    )
    return hevent.registerEvent(whichRect, key, callFunc)
end

--- 任意建筑建造开始时
---@alias onConstructStart fun(evtData: {triggerUnit:"触发单位"}):void
---@param whichPlayer userdata
---@param callFunc onConstructStart | "function(evtData) end"
---@return any
hevent.onConstructStart = function(whichPlayer, callFunc)
    hevent.pool(whichPlayer, hevent_default_actions.player.constructStart, function(tgr)
        cj.TriggerRegisterPlayerUnitEvent(tgr, whichPlayer, EVENT_PLAYER_UNIT_CONSTRUCT_START, nil)
    end)
    return hevent.registerEvent(whichPlayer, CONST_EVENT.constructStart, callFunc)
end

--- 任意建筑建造取消时
---@alias onConstructCancel fun(evtData: {triggerUnit:"触发单位"}):void
---@param whichPlayer userdata
---@param callFunc onConstructCancel | "function(evtData) end"
---@return any
hevent.onConstructCancel = function(whichPlayer, callFunc)
    hevent.pool(whichPlayer, hevent_default_actions.player.constructCancel, function(tgr)
        cj.TriggerRegisterPlayerUnitEvent(tgr, whichPlayer, EVENT_PLAYER_UNIT_CONSTRUCT_CANCEL, nil)
    end)
    return hevent.registerEvent(whichPlayer, CONST_EVENT.constructCancel, callFunc)
end

--- 任意建筑建造完成时
---@alias onConstructFinish fun(evtData: {triggerUnit:"触发单位"}):void
---@param whichPlayer userdata
---@param callFunc onConstructFinish | "function(evtData) end"
---@return any
hevent.onConstructFinish = function(whichPlayer, callFunc)
    hevent.pool(whichPlayer, hevent_default_actions.player.constructFinish, function(tgr)
        cj.TriggerRegisterPlayerUnitEvent(tgr, whichPlayer, EVENT_PLAYER_UNIT_CONSTRUCT_FINISH, nil)
    end)
    return hevent.registerEvent(whichPlayer, CONST_EVENT.constructFinish, callFunc)
end

--- 当聊天时
---@alias onChat fun(evtData: {triggerPlayer:"聊天的玩家",chatString:"聊天的内容",matchedString:"匹配命中的内容"}):void
---@param whichPlayer userdata
---@param chatStr string
---@param matchAll boolean
---@param callFunc onChat | "function(evtData) end"
---@return any
hevent.onChat = function(whichPlayer, chatStr, matchAll, callFunc)
    local key = CONST_EVENT.chat .. chatStr .. '|F'
    if (matchAll) then
        key = CONST_EVENT.chat .. chatStr .. '|T'
    end
    local condition = hplayer.get(whichPlayer, key, nil)
    if (condition == nil) then
        condition = function()
            hevent.triggerEvent(
                cj.GetTriggerPlayer(),
                key,
                {
                    triggerPlayer = cj.GetTriggerPlayer(),
                    chatString = cj.GetEventPlayerChatString(),
                    matchedString = cj.GetEventPlayerChatStringMatched()
                }
            )
        end
        hplayer.set(whichPlayer, key, condition)
    end
    hevent.pool(whichPlayer, cj.Condition(condition), function(tgr)
        cj.TriggerRegisterPlayerChatEvent(tgr, whichPlayer, chatStr, matchAll)
    end)
    return hevent.registerEvent(whichPlayer, key, callFunc)
end

--- 按ESC
---@alias onEsc fun(evtData: {triggerPlayer:"触发玩家"}):void
---@param whichPlayer userdata
---@param callFunc onEsc | "function(evtData) end"
---@return any
hevent.onEsc = function(whichPlayer, callFunc)
    hevent.pool(whichPlayer, hevent_default_actions.player.esc, function(tgr)
        cj.TriggerRegisterPlayerEvent(tgr, whichPlayer, EVENT_PLAYER_END_CINEMATIC)
    end)
    return hevent.registerEvent(whichPlayer, CONST_EVENT.esc, callFunc)
end

--- 玩家选择单位(点击了qty次)
---@alias onSelection fun(evtData: {triggerPlayer:"触发玩家",triggerUnit:"触发单位"}):void
---@param whichPlayer userdata
---@param qty number
---@param callFunc onSelection | "function(evtData) end"
---@return any
hevent.onSelection = function(whichPlayer, qty, callFunc)
    return hevent.registerEvent(whichPlayer, CONST_EVENT.selection .. "#" .. qty, callFunc)
end

--- 玩家取消选择单位
---@alias onDeSelection fun(evtData: {triggerPlayer:"触发玩家",triggerUnit:"触发单位"}):void
---@param whichPlayer userdata
---@param callFunc onDeSelection | "function(evtData) end"
---@return any
hevent.onDeSelection = function(whichPlayer, callFunc)
    hevent.pool(whichPlayer, hevent_default_actions.player.deSelection, function(tgr)
        cj.TriggerRegisterPlayerUnitEvent(tgr, whichPlayer, EVENT_PLAYER_UNIT_DESELECTED, nil)
    end)
    return hevent.registerEvent(whichPlayer, CONST_EVENT.deSelection, callFunc)
end

--- 玩家离开游戏事件(注意这是全局事件)
---@alias onPlayerLeave fun(evtData: {triggerPlayer:"触发玩家"}):void
---@param callFunc onPlayerLeave | "function(evtData) end"
---@return any
hevent.onPlayerLeave = function(callFunc)
    return hevent.registerEvent("global", CONST_EVENT.playerLeave, callFunc)
end

--- 任意单位经过hero方法被玩家所挑选为英雄时(注意这是全局事件)
---@alias onPickHero fun(evtData: {triggerPlayer:"触发玩家",triggerUnit:"触发单位"}):void
---@param callFunc onPickHero | "function(evtData) end"
---@return any
hevent.onPickHero = function(callFunc)
    return hevent.registerEvent("global", CONST_EVENT.pickHero, callFunc)
end

--- 可破坏物死亡
---@alias onDestructableDestroy fun(evtData: {triggerDestructable:"被破坏的可破坏物"}):void
---@param whichDestructable userdata
---@param callFunc onDestructableDestroy | "function(evtData) end"
---@return any
hevent.onDestructableDestroy = function(whichDestructable, callFunc)
    hevent.pool(whichDestructable, hevent_default_actions.destructable.destroy, function(tgr)
        cj.TriggerRegisterDeathEvent(tgr, whichDestructable)
    end)
    return hevent.registerEvent(whichDestructable, CONST_EVENT.destructableDestroy, callFunc)
end

--- 全图当前可破坏物死亡
---@alias onMapDestructableDestroy fun(evtData: {triggerDestructable:"被破坏的可破坏物"}):void
---@param whichDestructable userdata
---@param callFunc onMapDestructableDestroy | "function(evtData) end"
---@return any
hevent.onMapDestructableDestroy = function(callFunc)
    local tgr = cj.CreateTrigger()
    cj.TriggerAddCondition(tgr, cj.Condition(function()
        callFunc({ triggerDestructable = cj.GetTriggerDestructable() })
    end))
    cj.EnumDestructablesInRect(hrect.MAP_INITIAL_PLAYABLE_AREA, nil, function()
        cj.TriggerRegisterDeathEvent(tgr, cj.GetEnumDestructable())
    end)
end