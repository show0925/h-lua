---@class henemy 敌人模块
henemy = {
    -- 充当敌人的玩家
    players = {},
    --- 充当敌人的玩家调用次数，初始 0
    numbers = {},
    --- 充当敌人的玩家调用次数上限，达到就全体归0
    numberLimit = 100,
    --- 敌军名称
    name = "敌军",
    --- 敌人颜色
    color = cj.ConvertPlayerColor(12),
    --- 是否与玩家共享视野
    shareSight = false,
}

--- 设置敌人的名称
---@param name string
henemy.setName = function(name)
    henemy.name = name
end

--- 获取敌人的名称
---@return string
henemy.getName = function()
    return henemy.name
end

--- 设置敌人的颜色
---@param color userdata cj.ConvertPlayerColor(1~12)
henemy.setColor = function(color)
    henemy.color = color
end

--- 获取敌人的颜色
---@return userdata
henemy.getColor = function()
    return henemy.color
end

--- 设置敌人是否共享视野
---@param b boolean
henemy.setShareSight = function(b)
    henemy.shareSight = b
end

--- 获取敌人是否共享视野
---@return boolean
henemy.isShareSight = function()
    if (type(henemy.shareSight) == 'boolean') then
        return henemy.shareSight
    end
    return false
end

--- 将某个玩家位置设定为敌人，同时将他名字设定为全局的emptyName，颜色调节为黑色ConvertPlayerColor(12)
---@param whichPlayer userdata
henemy.setPlayer = function(whichPlayer)
    if (table.includes(whichPlayer, henemy.players)) then
        return
    end
    table.insert(henemy.players, whichPlayer)
    local index = hplayer.index(whichPlayer)
    if (henemy.numbers[#henemy.players] == nil) then
        henemy.numbers[#henemy.players] = 0
    end
    cj.SetPlayerName(whichPlayer, henemy.name)
    cj.SetPlayerColor(whichPlayer, henemy.getColor())
end

--- 将一组玩家位置设定为敌人
---@param playerArray table
henemy.setPlayers = function(playerArray)
    if (#playerArray < 1) then
        return
    end
    for _, whichPlayer in ipairs(playerArray) do
        henemy.setPlayer(whichPlayer)
    end
end

--- 最优化自动获取一个敌人玩家
---@param createQty number 可设定创建单位数，更精准调用，默认权重 1
---@return userdata 敌人玩家
henemy.getPlayer = function(createQty)
    local p
    if (createQty == nil) then
        createQty = 1
    else
        createQty = math.floor(createQty)
    end
    local tagI = 0
    for i = 1, #henemy.players, 1 do
        if (tagI == 0) then
            tagI = i
        elseif (henemy.numbers[i] < henemy.numbers[tagI]) then
            tagI = i
        end
    end
    henemy.numbers[tagI] = henemy.numbers[tagI] + createQty
    if (henemy.numbers[tagI] > henemy.numberLimit) then
        for i = 1, #henemy.players, 1 do
            henemy.numbers[i] = 0
        end
    end
    return henemy.players[tagI]
end

--[[
    创建敌人单位/单位组
    @return 最后创建单位/单位组
    {
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
        isOpenPunish = false, --是否开启硬直系统，可选
        isShadow = false, --是否影子，可选
        isUnSelectable = false, --是否可鼠标选中，可选
        isInvulnerable = false, --是否无敌，可选
        attr = nil, --自定义属性，可选
    }
]]
henemy.create = function(options)
    options.whichPlayer = henemy.getPlayer(options.qty or 1)
    options.isShareSight = henemy.isShareSight()
    return hunit.create(options)
end
