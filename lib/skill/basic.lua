--- 回避
---@param whichUnit userdata
hskill.avoid = function(whichUnit)
    cj.UnitAddAbility(whichUnit, hskill.SKILL_AVOID_PLUS)
    cj.SetUnitAbilityLevel(whichUnit, hskill.SKILL_AVOID_PLUS, 2)
    cj.UnitRemoveAbility(whichUnit, hskill.SKILL_AVOID_PLUS)
    htime.setTimeout(0, function(t)
        htime.delTimer(t)
        cj.UnitAddAbility(whichUnit, hskill.SKILL_AVOID_MIUNS)
        cj.SetUnitAbilityLevel(whichUnit, hskill.SKILL_AVOID_MIUNS, 2)
        cj.UnitRemoveAbility(whichUnit, hskill.SKILL_AVOID_MIUNS)
    end)
end

--- 无敌
---@param whichUnit userdata
---@param during number
---@param effect string
hskill.invulnerable = function(whichUnit, during, effect)
    if (whichUnit == nil) then
        return
    end
    if (during < 0) then
        during = 0.00 -- 如果设置持续时间错误，则0秒无敌，跟回避效果相同
    end
    cj.UnitAddAbility(whichUnit, hskill.BUFF_INVULNERABLE)
    if (during > 0 and effect ~= nil) then
        heffect.bindUnit(effect, whichUnit, "origin", during)
    end
    htime.setTimeout(during, function(t)
        htime.delTimer(t)
        cj.UnitRemoveAbility(whichUnit, hskill.BUFF_INVULNERABLE)
    end)
end

--- 范围群体无敌
---@param x number
---@param y number
---@param radius number
---@param filter function
---@param during number
---@param effect string
hskill.invulnerableRange = function(x, y, radius, filter, during, effect)
    if (x == nil or y == nil or filter == nil) then
        return
    end
    if (during < 0) then
        during = 0.00 -- 如果设置持续时间错误，则0秒无敌，跟回避效果相同
    end
    local g = hgroup.createByXY(x, y, radius, filter)
    hgroup.forEach(g, function(eu)
        hunit.setInvulnerable(eu, true)
        if (during > 0 and effect ~= nil) then
            heffect.bindUnit(effect, eu, "origin", during)
        end
    end)
    htime.setTimeout(during, function(t)
        htime.delTimer(t)
        hgroup.forEach(g, function(eu)
            hunit.setInvulnerable(eu, false)
        end)
        g = nil
    end)
end

--- 暂停效果
---@param whichUnit userdata
---@param during number
---@param pauseColor string | "'black'" | "'blue'" | "'red'" | "'green'"
hskill.pause = function(whichUnit, during, pauseColor)
    if (whichUnit == nil) then
        return
    end
    if (during < 0) then
        during = 0.01 -- 假如没有设置时间，默认打断效果
    end
    local rgba
    if (pauseColor == "black") then
        rgba = { 30, 30, 30 }
    elseif (pauseColor == "blue") then
        rgba = { 30, 30, 220 }
    elseif (pauseColor == "red") then
        rgba = { 220, 30, 30 }
    elseif (pauseColor == "green") then
        rgba = { 30, 220, 30 }
    end
    local prevTimer = hskill.get(whichUnit, "pauseTimer")
    local prevTimeRemaining = 0
    if (prevTimer ~= nil) then
        prevTimeRemaining = htime.getRemainTime(prevTimer)
        if (prevTimeRemaining > 0) then
            htime.delTimer(prevTimer)
            hskill.set(whichUnit, "pauseTimer", nil)
        else
            prevTimeRemaining = 0
        end
    end
    local colorBuff
    if (rgba) then
        colorBuff = hunit.setRGBA(whichUnit, rgba[1], rgba[2], rgba[3])
    end
    cj.SetUnitTimeScale(whichUnit, 0.00)
    cj.PauseUnit(whichUnit, true)
    hskill.set(
        whichUnit,
        "pauseTimer",
        htime.setTimeout(during + prevTimeRemaining, function(t)
            htime.delTimer(t)
            cj.PauseUnit(whichUnit, false)
            if (colorBuff ~= nil) then
                hunit.delRGBA(whichUnit, colorBuff)
            end
            cj.SetUnitTimeScale(whichUnit, 1)
        end)
    )
end

--- 隐身
---@param whichUnit userdata
---@param during number
---@param transition number
---@param effect string
hskill.invisible = function(whichUnit, during, transition, effect)
    if (whichUnit == nil or during == nil or during <= 0) then
        return
    end
    if (his.dead(whichUnit)) then
        return
    end
    transition = transition or 0
    if (effect ~= nil) then
        heffect.toUnit(effect, whichUnit, 0)
    end
    if (transition > 0) then
        htime.setTimeout(transition, function(t)
            htime.delTimer(t)
            hskill.add(whichUnit, hskill.SKILL_INVISIBLE, during)
        end)
    else
        hskill.add(whichUnit, hskill.SKILL_INVISIBLE, during)
    end
end

--- 现形
---@param whichUnit userdata
---@param during number
---@param transition number
---@param effect string
hskill.visible = function(whichUnit, during, transition, effect)
    if (whichUnit == nil or during == nil or during <= 0) then
        return
    end
    if (his.dead(whichUnit)) then
        return
    end
    transition = transition or 0
    if (effect ~= nil) then
        heffect.toUnit(effect, whichUnit, 0)
    end
    if (transition > 0) then
        htime.setTimeout(transition, function(t)
            htime.delTimer(t)
            hskill.del(whichUnit, hskill.SKILL_INVISIBLE, during)
        end)
    else
        hskill.del(whichUnit, hskill.SKILL_INVISIBLE, during)
    end
end

--- 为单位添加效果只限技能类(一般使用物品技能<攻击之爪>模拟)一段时间
---@param whichUnit userdata
---@param whichAbility number
---@param abilityLevel number
---@param during number
hskill.modelEffect = function(whichUnit, whichAbility, abilityLevel, during)
    if (whichUnit ~= nil and whichAbility ~= nil and during > 0.03) then
        cj.UnitAddAbility(whichUnit, whichAbility)
        cj.UnitMakeAbilityPermanent(whichUnit, true, whichAbility)
        if (abilityLevel > 0) then
            cj.SetUnitAbilityLevel(whichUnit, whichAbility, abilityLevel)
        end
        htime.setTimeout(during, function(t)
            htime.delTimer(t)
            cj.UnitRemoveAbility(whichUnit, whichAbility)
        end)
    end
end

--- 自定义技能 - 对单位/对XY/对点
---@param options table
hskill.diy = function(options)
    --[[
        自定义技能 - 对单位/对XY/对点
        options = {
            whichPlayer,
            skillId,
            orderString,
            x,y 创建位置
            targetX,targetY 对XY时可选
            targetLoc, 对点时可选
            targetUnit, 对单位时可选
            life, 马甲生命周期
        }
    ]]
    if (options.whichPlayer == nil or options.skillId == nil or options.orderString == nil) then
        return
    end
    if (options.x == nil or options.y == nil) then
        return
    end
    local life = options.life
    if (options.life == nil or options.life < 2.00) then
        life = 2.00
    end
    local token = cj.CreateUnit(options.whichPlayer, hskill.SKILL_TOKEN, x, y, bj_UNIT_FACING)
    cj.UnitAddAbility(token, options.skillId)
    if (options.targetUnit ~= nil) then
        cj.IssueTargetOrderById(token, options.orderId, options.targetUnit)
    elseif (options.targetX ~= nil and options.targetY ~= nil) then
        cj.IssuePointOrder(token, options.orderString, options.targetX, options.targetY)
    elseif (options.targetLoc ~= nil) then
        cj.IssuePointOrderLoc(token, options.orderString, options.targetLoc)
    else
        cj.IssueImmediateOrder(token, options.orderString)
    end
    hunit.del(token, life)
end
