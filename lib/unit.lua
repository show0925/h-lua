hunit = {}

---@private
hunit.set = function(whichUnit, key, value)
    if (whichUnit == nil) then
        print_stack()
        return
    end
    if (hRuntime.unit[whichUnit] ~= nil) then
        hRuntime.unit[whichUnit][key] = value
    end
end

---@private
hunit.get = function(whichUnit, key, default)
    if (whichUnit == nil) then
        print_stack()
        return
    end
    if (hRuntime.unit[whichUnit] == nil) then
        return default
    end
    return hRuntime.unit[whichUnit][key] or default
end

--- 数值键值是根据地图编辑器作为标准的，所以大小写也是与之一致
---@param uOrId userdata|string|number
---@return table|nil
hunit.getSlk = function(uOrId)
    local id = hunit.getId(uOrId)
    return slk.unit[id]
end

--- 获取单位的 _hslk 自定义数据
---@param uOrIdOrName userdata|string|number
---@return table|nil
hunit.getHSlk = function(uOrIdOrName)
    local id = hunit.getId(uOrIdOrName)
    if (hslk.i2v.unit[id]) then
        return hslk.i2v.unit[id]
    elseif (hslk.n2v.unit[id]) then
        return hslk.n2v.unit[id]
    end
    return nil
end

--- 获取单位的头像
---@param uOrId userdata|string|number
---@return string
hunit.getAvatar = function(uOrId)
    local s = hunit.getSlk(uOrId)
    return s.Art
end

--- 获取单位的原始攻击间隔
---@param uOrId userdata|string|number
---@return number
hunit.getAttackSpeedSpace = function(uOrId)
    local s = hunit.getSlk(uOrId)
    return math.round(s.cool1)
end

--- 获取单位的浮动攻击
--- 这是根据slk计算的浮动攻击，每次获取到的值可能不一样
---@param uOrId userdata|string|number
---@return number
hunit.getDmgPlus = function(uOrId)
    local s = hunit.getSlk(uOrId)
    local dmgplus1 = s.dmgplus1 or 0
    local sides1 = s.sides1 or 1
    local dice1 = s.dice1 or 0
    dmgplus1 = math.floor(dmgplus1)
    sides1 = math.floor(sides1)
    dice1 = math.floor(dice1)
    if (sides1 < 1) then
        sides1 = 1
    end
    return dmgplus1 + dice1 * math.random(1, sides1)
end

--- 获取单位的最大生命值
---@param u userdata
---@return number
hunit.getMaxLife = function(u)
    return cj.GetUnitState(u, UNIT_STATE_MAX_LIFE)
end
--- 获取单位的当前生命
---@param u userdata
---@return number
hunit.getCurLife = function(u)
    return cj.GetUnitState(u, UNIT_STATE_LIFE)
end
--- 设置单位的当前生命
---@param u userdata
---@param val number
hunit.setCurLife = function(u, val)
    cj.SetUnitState(u, UNIT_STATE_LIFE, val)
end
--- 增加单位的当前生命
---@param u userdata
---@param val number
hunit.addCurLife = function(u, val)
    cj.SetUnitState(u, UNIT_STATE_LIFE, hunit.getCurLife(u) + val)
end
--- 减少单位的当前生命
---@param u userdata
---@param val number
hunit.subCurLife = function(u, val)
    cj.SetUnitState(u, UNIT_STATE_LIFE, hunit.getCurLife(u) - val)
end
--- 获取单位的最大魔法
---@param u userdata
---@return number
hunit.getMaxMana = function(u)
    return cj.GetUnitState(u, UNIT_STATE_MAX_MANA)
end
--- 获取单位的当前魔法
---@param u userdata
---@return number
hunit.getCurMana = function(u)
    return cj.GetUnitState(u, UNIT_STATE_MANA)
end
--- 设置单位的当前魔法
---@param u userdata
---@param val number
hunit.setCurMana = function(u, val)
    cj.SetUnitState(u, UNIT_STATE_MANA, val)
end
--- 增加单位的当前魔法
---@param u userdata
---@param val number
hunit.addCurMana = function(u, val)
    cj.SetUnitState(u, UNIT_STATE_MANA, hunit.getCurMana(u) + val)
end
--- 减少单位的当前魔法
---@param u userdata
---@param val number
hunit.subCurMana = function(u, val)
    cj.SetUnitState(u, UNIT_STATE_MANA, hunit.getCurMana(u) - val)
end

--- 获取单位百分比生命
---@param u userdata
---@return number %
hunit.getCurLifePercent = function(u)
    return math.round(100 * (hunit.getCurLife(u) / hunit.getMaxLife(u)))
end
--- 设置单位百分比生命
---@param u userdata
---@param val number
hunit.setCurLifePercent = function(u, val)
    local max = hunit.getMaxLife(u)
    local life = math.floor(max * val * 0.01)
    if (life < 0) then
        life = 0
    end
    hunit.setCurLife(u, life)
end
--- 获取单位百分比魔法
---@param u userdata
---@return number %
hunit.getCurManaPercent = function(u)
    return math.round(100 * (hunit.getCurMana(u) / hunit.getMaxMana(u)))
end
--- 设置单位百分比魔法
---@param u userdata
---@param val number %
hunit.setCurManaPercent = function(u, val)
    local max = hunit.getMaxMana(u)
    local mana = math.floor(max * val * 0.01)
    if (mana < 0) then
        mana = 0
    end
    hunit.setCurMana(u, mana)
end

--- 增加单位的经验值
---@param u userdata
---@param val number
hunit.addExp = function(u, val, showEffect)
    if (u == nil or val == nil or val <= 0) then
        return
    end
    if (type(showEffect) ~= "boolean") then
        showEffect = false
    end
    val = cj.R2I(val * hplayer.getExpRatio(hunit.getOwner(u)) / 100)
    cj.AddHeroXP(u, val, showEffect)
    -- @触发事件
    hevent.triggerEvent(u, CONST_EVENT.exp, { triggerUnit = u, value = val })
end

--- 设置单位的生命周期
---@param u userdata
---@param life number
hunit.setPeriod = function(u, life)
    cj.UnitApplyTimedLife(u, string.char2id("BTLF"), life)
end

--- 设置单位面向角度
---@param u userdata
---@param facing number
hunit.setFacing = function(u, facing)
    cj.SetUnitFacing(u, facing)
end

--- 获取单位面向角度
---@param u userdata
---@return number
hunit.getFacing = function(u)
    return cj.GetUnitFacing(u)
end

--- 显示单位
---@param u userdata
hunit.show = function(u)
    cj.ShowUnit(u, true)
end

--- 隐藏单位
---@param u userdata
hunit.hide = function(u)
    cj.ShowUnit(u, false)
end

--- 暂停单位
---@param u userdata
hunit.pause = function(u)
    cj.PauseUnit(u, true)
end

--- 恢复暂停单位
---@param u userdata
hunit.resume = function(u)
    cj.PauseUnit(u, false)
end

--- 获取单位X坐标
---@param u userdata
---@return number
hunit.x = function(u)
    return cj.GetUnitX(u)
end

--- 获取单位Y坐标
---@param u userdata
---@return number
hunit.y = function(u)
    return cj.GetUnitY(u)
end

--- 单位是否启用硬直（系统默认不启用）
---@param u userdata
---@return boolean
hunit.isOpenPunish = function(u)
    return table.includes(u, hRuntime.attributeGroup.punish)
end

--- 单位启用硬直（系统默认不启用）
---@param u userdata
hunit.openPunish = function(u)
    if (table.includes(u, hRuntime.attributeGroup.punish) == false) then
        table.insert(hRuntime.attributeGroup.punish, u)
    end
end

--- 单位停用硬直（系统默认不启用）
---@param u userdata
hunit.closePunish = function(u)
    if (table.includes(u, hRuntime.attributeGroup.punish)) then
        table.delete(u, hRuntime.attributeGroup.punish)
    end
end

--- 设置单位无敌
---@param u userdata
---@param flag boolean
hunit.setInvulnerable = function(u, flag)
    if (flag == nil) then
        flag = true
    end
    if (flag == true and cj.GetUnitAbilityLevel(u, hskill.BUFF_INVULNERABLE) < 1) then
        cj.UnitAddAbility(u, hskill.BUFF_INVULNERABLE)
    else
        cj.UnitRemoveAbility(u, hskill.BUFF_INVULNERABLE)
    end
end

--- 设置单位的动画速度[比例尺1.00]
---@param whichUnit userdata
---@param speed number 0.00-1.00
---@param during number
hunit.setAnimateSpeed = function(whichUnit, speed, during)
    if (whichUnit == nil or his.deleted(whichUnit)) then
        return
    end
    during = during or 0
    local prevSpeed = hunit.get(whichUnit, 'animateSpeed', 1.00)
    speed = speed or prevSpeed
    cj.SetUnitTimeScale(whichUnit, speed)
    hunit.set(whichUnit, 'animateSpeed', speed)
    if (during > 0) then
        htime.setTimeout(
            during,
            function(t)
                htime.delTimer(t)
                cj.SetUnitTimeScale(u, prevSpeed)
                hunit.set(whichUnit, 'animateSpeed', prevSpeed)
            end
        )
    end
end

--- 设置单位的三原色，rgb取值0-255
---@param whichUnit userdata
---@param red number 0-255
---@param green number 0-255
---@param blue number 0-255
---@param opacity number 不透明度 0.0-1.0
---@param during number 持续时间
hunit.setRGBA = function(whichUnit, red, green, blue, opacity, during)
    if (whichUnit == nil or his.deleted(whichUnit)) then
        return
    end
    during = during or 0
    local uSlk = hunit.getSlk(whichUnit)
    local rgba = hunit.get(whichUnit, 'rgba')
    if (rgba == nil) then
        rgba = { math.floor(uSlk.red), math.floor(uSlk.green), math.floor(uSlk.blue), 1.0 }
        hunit.set(whichUnit, 'rgba', rgba)
    end
    red = math.max(0, math.min(255, red or rgba[1]))
    green = math.max(0, math.min(255, green or rgba[2]))
    blue = math.max(0, math.min(255, blue or rgba[3]))
    opacity = math.max(0, math.min(1, opacity or rgba[4]))
    return hbuff.create(during, whichUnit, 'rgba',
        function()
            cj.SetUnitVertexColor(whichUnit, red, green, blue, 255 * opacity)
            hunit.set(whichUnit, 'rgba', { red, green, blue, opacity })
        end,
        function()
            if (hRuntime.buff[whichUnit].rgba.log and #hRuntime.buff[whichUnit].rgba.log > 1) then
                local uk = hRuntime.buff[whichUnit].rgba.log[#hRuntime.buff[whichUnit].rgba.log - 1]
                hbuff.purpose(whichUnit, string.implode('|', { 'rgba', uk }))
            else
                cj.SetUnitVertexColor(whichUnit, math.floor(uSlk.red), math.floor(uSlk.green), math.floor(uSlk.blue), 255)
            end
        end
    )
end

--- 根据buffKey删除单位的一次的变色
---@param whichUnit userdata
hunit.delRGBA = function(whichUnit, buffKey)
    hbuff.delete(whichUnit, buffKey)
end

--- 重置单位的三原色
---@param whichUnit userdata
hunit.resetRGBA = function(whichUnit)
    hbuff.delete(whichUnit, 'rgba')
end

--- 获取单位当前归属玩家
---@param whichUnit userdata
---@return userdata ownerPlayer
hunit.getOwner = function(whichUnit)
    if (whichUnit == nil) then
        return
    end
    return cj.GetOwningPlayer(whichUnit)
end

--- 瞬间传送单位到X,Y坐标
---@param whichUnit userdata
---@param x number
---@param y number
---@param facing number|nil
hunit.portal = function(whichUnit, x, y, facing)
    if (whichUnit == nil or x == nil or y == nil) then
        return
    end
    cj.SetUnitPosition(whichUnit, x, y)
    if (facing ~= nil) then
        cj.SetUnitFacing(facing)
    end
end

--- 命令单位做动画动作，如 "attack"
--- 当动作为整型序号时，自动播放对应的序号行为(每种模型的序号并不一致)
---@param whichUnit userdata
---@param animate number | string
hunit.animate = function(whichUnit, animate)
    if (whichUnit == nil or animate == nil) then
        return
    end
    if (type(animate) == "string") then
        cj.SetUnitAnimation(whichUnit, animate)
    elseif (type(animate) == "number") then
        animate = math.floor(animate)
        cj.SetUnitAnimationByIndex(whichUnit, animate)
    end
end

--- 使得单位嵌入框架系统
--- 一般不需要主动使用
--- 但地图放置等这些单位就被忽略了，所以可以试用此方法补回
---@param u userdata
---@param options table
hunit.embed = function(u, options)
    options = options or {}
    if (type(options.registerOrderEvent ~= 'boolean')) then
        options.registerOrderEvent = false
    end
    -- 记入group选择器（不在框架系统内的单位，也不会被group选择到）
    table.insert(hRuntime.group, u)
    -- 记入realtime
    local id = options.unitId
    if (type(id) == 'number') then
        id = string.id2char(id)
    end
    hRuntime.unit[u] = {
        id = id,
        life = options.life or nil,
        during = options.during or nil,
        isShadow = options.isShadow or false,
        animateSpeed = options.timeScale or 1.00,
        attribute = -1,
    }
    -- 单位受伤
    hevent.pool(u, hevent_default_actions.unit.damaged, function(tgr)
        cj.TriggerRegisterUnitEvent(tgr, u, EVENT_UNIT_DAMAGED)
    end)
    -- 单位死亡
    hevent.pool(u, hevent_default_actions.unit.death, function(tgr)
        cj.TriggerRegisterUnitEvent(tgr, u, EVENT_UNIT_DEATH)
    end)
    --[[
        单位指令，如果单位的玩家是真人或者开发者要求嵌入，才会使指令捕捉生效
        因为大部分单位不需要捕捉指令，故做此判断
        开启指令的单位可以开启以下事件：移动相关、停止、驻扎
        开启指令的单位可以开启以下判断：是否正在移动
        * 移动的具体指标请查看event说明
    ]]
    if (his.computer(hunit.getOwner(u)) == false or options.registerOrderEvent == true) then
        hevent.pool(u, hevent_default_actions.unit.order, function(tgr)
            cj.TriggerRegisterUnitEvent(tgr, u, EVENT_UNIT_ISSUED_ORDER)
            cj.TriggerRegisterUnitEvent(tgr, u, EVENT_UNIT_ISSUED_POINT_ORDER)
            cj.TriggerRegisterUnitEvent(tgr, u, EVENT_UNIT_ISSUED_TARGET_ORDER)
        end)
    end
    -- 信使事件
    local slk = hslk.i2v.unit[id]
    if (slk ~= nil) then
        if (slk.UNIT_TYPE == "courier_hero" or slk.UNIT_TYPE == "courier") then
            if (slk.COURIER_AUTO_SKILL == true) then
                hcourier.embed(u)
            end
        end
    end
    -- 物品系统
    if (his.hasSlot(u)) then
        hitem.embed(u)
    elseif (options.isOpenSlot == true) then
        hskill.add(u, hitem.DEFAULT_SKILL_ITEM_SLOT, 0)
        hitem.embed(u)
    end
    -- 如果是英雄，注册事件和计算初次属性
    if (his.hero(u) == true) then
        hhero.setPrevLevel(u, 1)
        hevent.pool(u, hevent_default_actions.hero.levelUp, function(tgr)
            cj.TriggerRegisterUnitEvent(tgr, u, EVENT_UNIT_HERO_LEVEL)
        end)
        hattribute.set(u, 0, {
            str_white = "=" .. cj.GetHeroStr(u, false),
            agi_white = "=" .. cj.GetHeroAgi(u, false),
            int_white = "=" .. cj.GetHeroInt(u, false),
        })
    end
end

--- 创建单位/单位组
---@param options table
---@return userdata|table 最后创建单位|单位组
hunit.create = function(options)
    --[[
        options = {
            register = true, --是否注册进系统
            registerOrderEvent = false, --是否注册系统指令事件，可选
            whichPlayer = nil, --归属玩家
            unitId = nil, --类型id,如'H001'
            x = nil, --创建坐标X，可选
            y = nil, --创建坐标Y，可选
            loc = nil, --创建点，可选
            height = 高度，0，可选
            timeScale = 动作时间比例，1~，可选
            modelScale = 模型缩放比例，1~，可选
            red = 红色，0～255，可选
            green = 绿色，0～255，可选
            blue = 蓝色，0～255，可选
            opacity = 不透明度，0.0～1.0，可选,0不可见
            qty = 1, --数量，可选，可选
            life = nil, --生命周期，到期死亡，可选
            during = nil, --持续时间，到期删除，可选
            facing = nil, --面向角度，可选
            facingX = nil, --面向X，可选
            facingY = nil, --面向Y，可选
            facingLoc = nil, --面向点，可选
            facingUnit = nil, --面向单位，可选
            attackX = nil, --攻击X，可选
            attackY = nil, --攻击Y，可选
            attackLoc = nil, --攻击点，可选
            attackUnit = nil, --攻击单位，可选
            isOpenSlot = false, --是否开启物品栏(自动注册)可选
            isOpenPunish = false, --是否开启硬直系统，可选
            isShadow = false, --是否影子，可选
            isUnSelectable = false, --是否不可鼠标选中，可选
            isPause = false, -- 是否暂停
            isInvulnerable = false, --是否无敌，可选
            isShareSight = false, --是否与所有玩家共享视野，可选
            attr = nil, --自定义属性，可选
        }
    ]]
    if (options.qty == nil) then
        options.qty = 1
    end
    if (options.whichPlayer == nil) then
        print_err("create unit fail -pl")
        return
    end
    if (options.unitId == nil) then
        print_err("create unit fail -id")
        return
    end
    if (options.qty <= 0) then
        print_err("create unit fail -qty")
        return
    end
    if (options.x == nil and options.y == nil and options.loc == nil) then
        print_err("create unit fail -place")
        return
    end
    if (options.unitId == nil) then
        print_err("create unit id")
        return
    end
    if (type(options.unitId) == "string") then
        options.unitId = string.char2id(options.unitId)
    end
    local u
    local facing
    local x
    local y
    local g
    if (options.x ~= nil and options.y ~= nil) then
        x = options.x
        y = options.y
    elseif (options.loc ~= nil) then
        x = cj.GetLocationX(options.loc)
        y = cj.GetLocationY(options.loc)
    end
    if (options.facing ~= nil) then
        facing = options.facing
    elseif (options.facingX ~= nil and options.facingY ~= nil) then
        facing = math.getDegBetweenXY(x, y, options.facingX, options.facingY)
    elseif (options.facingLoc ~= nil) then
        facing = math.getDegBetweenXY(x, y, cj.GetLocationX(options.facingLoc), cj.GetLocationY(options.facingLoc))
    elseif (options.facingUnit ~= nil) then
        facing = math.getDegBetweenXY(x, y, hunit.x(options.facingUnit), hunit.y(options.facingUnit))
    else
        facing = bj_UNIT_FACING
    end
    if (options.qty > 1) then
        g = {}
    end
    for _ = 1, options.qty, 1 do
        if (options.x ~= nil and options.y ~= nil) then
            u = cj.CreateUnit(options.whichPlayer, options.unitId, options.x, options.y, facing)
        elseif (options.loc ~= nil) then
            u = cj.CreateUnitAtLoc(options.whichPlayer, options.unitId, options.loc, facing)
        end
        -- 高度
        if (options.height ~= nil and options.height ~= 0) then
            options.height = math.round(options.height)
            hunit.setCanFly(u)
            cj.SetUnitFlyHeight(u, options.height, 10000)
        end
        -- 动作时间比例 %
        if (options.timeScale ~= nil and options.timeScale > 0) then
            options.timeScale = math.round(options.timeScale * 0.01)
            cj.SetUnitTimeScale(u, options.timeScale)
        end
        -- 模型缩放比例 %
        if (options.modelScale ~= nil and options.modelScale > 0) then
            options.modelScale = math.round(options.modelScale)
            cj.SetUnitScale(u, options.modelScale, options.modelScale, options.modelScale)
        end
        -- RBGA
        if (options.red ~= nil or options.green ~= nil or options.blue ~= nil or options.opacity ~= nil) then
            hunit.setRGBA(u, options.red, options.green, options.blue, options.opacity)
        end
        if (options.attackX ~= nil and options.attackY ~= nil) then
            cj.IssuePointOrder(u, "attack", options.attackX, options.attackY)
        elseif (options.attackLoc ~= nil) then
            cj.IssuePointOrderLoc(u, "attack", options.attackLoc)
        elseif (options.attackUnit ~= nil) then
            cj.IssueTargetOrder(u, "attack", options.attackUnit)
        end
        if (options.qty > 1) then
            hgroup.addUnit(g, u)
        end
        --是否可选
        if (options.isUnSelectable ~= nil and options.isUnSelectable == true) then
            cj.UnitAddAbility(u, string.char2id("Aloc"))
        end
        --是否暂停
        if (options.isPause ~= nil and options.isPause == true) then
            cj.PauseUnit(u, true)
        end
        --是否无敌
        if (options.isInvulnerable ~= nil and options.isInvulnerable == true) then
            hunit.setInvulnerable(u, true)
        end
        --开启硬直，执行硬直计算
        if (options.isOpenPunish ~= nil and options.isOpenPunish == true) then
            hunit.openPunish(u)
        end
        --影子，无敌蝗虫暂停,且不注册系统
        if (options.isShadow ~= nil and options.isShadow == true) then
            cj.UnitAddAbility(u, "Aloc")
            cj.PauseUnit(u, true)
            hunit.setInvulnerable(u, true)
            options.register = false
        end
        --是否与所有玩家共享视野
        if (options.isShareSight ~= nil and options.isShareSight == true) then
            for pi = 0, bj_MAX_PLAYERS - 1, 1 do
                cj.SetPlayerAlliance(options.whichPlayer, cj.Player(pi), ALLIANCE_SHARED_VISION, true)
            end
        end
        -- 注册系统(默认注册)
        if (type(options.register) ~= "boolean") then
            options.register = true
        end
        if (options.register == true) then
            hunit.embed(u, options)
        end
        -- 生命周期 dead
        if (options.life ~= nil and options.life > 0) then
            hunit.setPeriod(u, options.life)
            hunit.del(u, options.life + 1)
        end
        -- 持续时间 delete
        if (options.during ~= nil and options.during >= 0) then
            hunit.del(u, options.during)
        end
        -- attr
        if (options.attr ~= nil and type(options.attr) == "table") then
            hattr.set(u, 0, options.attr)
        end
    end
    if (g ~= nil) then
        return g
    else
        return u
    end
end

--- 获取单位ID字符串
---@param uOrId userdata|number|string
---@return string|nil
hunit.getId = function(uOrId)
    local id
    if (type(uOrId) == 'userdata') then
        id = string.id2char(cj.GetUnitTypeId(uOrId))
    elseif (type(uOrId) == 'number') then
        id = string.id2char(uOrId)
    elseif (type(uOrId) == 'string') then
        id = uOrId
    end
    return id
end

--- 根据名称获取单位ID字符串
---@param name string
---@return string
hunit.n2i = function(name)
    if (hslk.n2v.unit[name]) then
        return hslk.n2v.unit[name]._id or nil
    end
    return nil
end

--- 获取单位的名称
---@param u userdata
---@return string
hunit.getName = function(u)
    return cj.GetUnitName(u)
end
--- 获取单位的自定义值
---@param u userdata
---@return number
hunit.getUserData = function(u)
    return cj.GetUnitUserData(u)
end
--- 设置单位的自定义值
---@param u userdata
---@param val number
---@param during number
hunit.setUserData = function(u, val, during)
    local oldData = hunit.getUserData(u)
    val = math.ceil(val)
    cj.SetUnitUserData(u, val)
    during = during or 0
    if (during > 0) then
        htime.setTimeout(
            during,
            function(t)
                htime.delTimer(t)
                cj.SetUnitUserData(u, oldData)
            end
        )
    end
end

--- 设置单位颜色,color可设置玩家索引[1-16],应用其对应的颜色
---@param u userdata
---@param color any 阵营颜色
hunit.setColor = function(u, color)
    if (type(color) == "string") then
        color = string.upper(color)
        if (CONST_PLAYER_COLOR[color] ~= nil) then
            cj.SetUnitColor(u, CONST_PLAYER_COLOR[color])
        end
    else
        cj.SetUnitColor(u, cj.ConvertPlayerColor(color - 1))
    end
end

--- 删除单位，延时<delay>秒
---@param targetUnit userdata
---@param delay number
hunit.del = function(targetUnit, delay)
    if (delay == nil or delay <= 0) then
        hitem.clearUnitCache(targetUnit)
        hRuntime.clear(targetUnit)
        cj.RemoveUnit(targetUnit)
    else
        htime.setTimeout(
            delay,
            function(t)
                htime.delTimer(t)
                hitem.clearUnitCache(targetUnit)
                hRuntime.clear(targetUnit)
                cj.RemoveUnit(targetUnit)
            end
        )
    end
end
--- 杀死单位，延时<delay>秒
---@param targetUnit userdata
---@param delay number
hunit.kill = function(targetUnit, delay)
    if (delay == nil or delay <= 0) then
        cj.KillUnit(targetUnit)
    else
        htime.setTimeout(
            delay,
            function(t)
                htime.delTimer(t)
                cj.KillUnit(targetUnit)
            end
        )
    end
end
--- 爆毁单位，延时<delay>秒
---@param targetUnit userdata
---@param delay number
hunit.exploded = function(targetUnit, delay)
    if (delay == nil or delay <= 0) then
        cj.SetUnitExploded(targetUnit, true)
        cj.KillUnit(targetUnit)
    else
        htime.setTimeout(
            delay,
            function(t)
                htime.delTimer(t)
                cj.SetUnitExploded(targetUnit, true)
                cj.KillUnit(targetUnit)
            end
        )
    end
end

--- 设置单位可飞，用于设置单位飞行高度之前
---@param u userdata
hunit.setCanFly = function(u)
    cj.UnitAddAbility(u, string.char2id("Arav"))
    cj.UnitRemoveAbility(u, string.char2id("Arav"))
end

--- 设置单位高度，用于设置单位可飞行之后
---@param u userdata
---@param height number
---@param speed number
hunit.setFlyHeight = function(u, height, speed)
    cj.SetUnitFlyHeight(u, height, speed)
end