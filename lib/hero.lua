---@class hhero 英雄相关
hhero = {
    player_allow_qty = {}, -- 玩家最大单位数量,默认1
    player_heroes = {}, -- 玩家当前英雄
    build_token = hslk.unit_hero_tavern_token,
    --- 英雄出生地
    bornX = 0,
    bornY = 0,
    --- 英雄选择池
    selectorPool = {},
    --- 英雄选择清理池
    selectorClearPool = {},
}

--- 获取英雄的类型（STR AGI INT）
--- 先会判断SLK中是否存在，如果没有会将英雄当前的白字属性视为主属性
--- 如果两个白字属性相等，则以力->敏->智的优先级返回
---@param whichHero userdata
---@return string STR|AGI|INT
hhero.getPrimary = function(whichHero)
    local slk = hunit.getSlk(whichHero)
    local primary = slk.Primary
    if (primary == nil) then
        primary = "STR"
        if (slk.AGI > slk.STR) then
            primary = "AGI"
        end
        if (slk.INT > slk.STR and slk.INT > slk.AGI) then
            primary = "INT"
        end
    end
    return string.upper(primary)
end

--- 获取英雄的类型文本
---@param whichHero userdata
---@return string 力量|敏捷|智力
hhero.getPrimaryLabel = function(whichHero)
    return CONST_HERO_PRIMARY[hhero.getPrimary(whichHero)]
end

--- 设置英雄之前的等级
---@protected
---@param whichHero userdata
---@param lv number
hhero.setPrevLevel = function(whichHero, lv)
    if (hRuntime.hero[whichHero] == nil) then
        hRuntime.hero[whichHero] = {}
    end
    hRuntime.hero[whichHero].prevLevel = lv
end

--- 获取英雄之前的等级
---@protected
---@param whichHero userdata
---@return number
hhero.getPrevLevel = function(whichHero)
    if (hRuntime.hero[whichHero] == nil) then
        hRuntime.hero[whichHero] = {}
    end
    return hRuntime.hero[whichHero].prevLevel or 0
end

--- 获取英雄当前等级
---@param whichHero userdata
---@return number
hhero.getCurLevel = function(whichHero)
    return cj.GetHeroLevel(whichHero) or 1
end
--- 设置英雄当前的等级
---@paramu userdata
---@param newLevel number
---@param showEffect boolean
hhero.setCurLevel = function(whichHero, newLevel, showEffect)
    if (type(showEffect) ~= "boolean") then
        showEffect = false
    end
    local oldLevel = cj.GetHeroLevel(whichHero)
    if (newLevel > oldLevel) then
        cj.SetHeroLevel(whichHero, newLevel, showEffect)
    elseif (newLevel < oldLevel) then
        cj.UnitStripHeroLevel(whichHero, oldLevel - newLevel)
    else
        return
    end
    hhero.setPrevLevel(whichHero, newLevel)
end

--- 获取英雄的黄金消耗
---@param whichHero userdata
---@return string STR|AGI|INT
hhero.getSlkGoldcost = function(whichHero)
    local slk = hhero.getSlk(whichHero)
    return slk.goldcost or 0
end

--- 设置玩家最大英雄数量,支持1 - 7
--- 超过7会有很多魔兽原生问题，例如英雄不会复活，左侧图标无法查看等
---@param whichPlayer userdata
---@param max number
hhero.setPlayerAllowQty = function(whichPlayer, max)
    max = math.floor(max)
    if (max < 1) then
        max = 1
    end
    if (max > 7) then
        max = 7
    end
    local index = hplayer.index(whichPlayer)
    hhero.player_allow_qty[index] = max
end
--- 获取玩家最大英雄数量
---@param whichPlayer userdata
---@return number
hhero.getPlayerAllowQty = function(whichPlayer)
    local index = hplayer.index(whichPlayer)
    return hhero.player_allow_qty[index] or 0
end

-- 设定选择英雄的出生地
hhero.setBornXY = function(x, y)
    hhero.bornX = x
    hhero.bornY = y
end

--- 设置一组ID，这组ID会拥有英雄判定
--- 当设置[一般单位]为[英雄]时，框架自动屏蔽[力量|敏捷|智力]等不属于一般单位的属性，以避免引起崩溃报错
--- 设定后 his.hero 方法会认为ID对应的单位类型为英雄，同时属性系统也会认定它为英雄
---@param ids table <number, string>
hhero.setHeroIds = function(ids)
    if (type(ids) == "table" and #ids > 0) then
        -- 这个[.hero]是对应slkHelper里面的UNIT_TYPE的
        hRuntime.unit_type_ids.hero = ids
    end
end

--- 在某XY坐标复活英雄,只有英雄能被复活,只有调用此方法会触发复活事件
---@param whichHero userdata
---@param delay number
---@param invulnerable number 复活后的无敌时间
---@param x number
---@param y number
---@param showDialog boolean 是否显示倒计时窗口
hhero.rebornAtXY = function(whichHero, delay, invulnerable, x, y, showDialog)
    if (his.hero(whichHero)) then
        if (delay < 0.3 and his.deleted(whichHero) == false) then
            cj.ReviveHero(whichHero, x, y, true)
            hattr.resetAttrGroups(whichHero)
            if (invulnerable > 0) then
                hskill.invulnerable(whichHero, invulnerable)
            end
            -- @触发复活事件
            hevent.triggerEvent(
                whichHero,
                CONST_EVENT.reborn,
                {
                    triggerUnit = whichHero
                }
            )
        else
            local title
            if (showDialog == true) then
                title = hunit.getName(whichHero)
            end
            htime.setTimeout(
                delay,
                function(t)
                    htime.delTimer(t)
                    if (his.deleted(whichHero) == false) then
                        if (his.alive(whichHero)) then
                            return
                        end
                        cj.ReviveHero(whichHero, x, y, true)
                        if (invulnerable > 0) then
                            hskill.invulnerable(whichHero, invulnerable)
                        end
                        -- @触发复活事件
                        hevent.triggerEvent(
                            whichHero,
                            CONST_EVENT.reborn,
                            {
                                triggerUnit = whichHero
                            }
                        )
                    end
                end,
                title
            )
        end
    end
end

--- 在某点复活英雄,只有英雄能被复活,只有调用此方法会触发复活事件
---@param whichHero userdata
---@param delay number
---@param invulnerable number 复活后的无敌时间
---@param loc userdata
---@param showDialog boolean 是否显示倒计时窗口
hhero.rebornAtLoc = function(whichHero, delay, invulnerable, loc)
    hhero.rebornAtXY(whichHero, delay, invulnerable, cj.GetLocationX(loc), cj.GetLocationY(loc), showDialog)
end

--- 开始构建英雄选择
---@param options table
hhero.buildSelector = function(options)
    --[[
        options = {
            heroes = {"H001","H002"}, -- (可选)供选的单位ID数组，默认是全局的 hRuntime.unit_type_ids.hero
            during = -1, -- 选择持续时间，默认无限（特殊情况哦）;如果有持续时间但是小于30，会被设置为30秒，超过这段时间未选择的玩家会被剔除出游戏
            type = string, "tavern" | "click"
            buildX = 0, -- 构建点X
            buildY = 0, -- 构建点Y
            buildDistance = 256, -- 构建距离，例如两个酒馆间，两个单位间
            buildRowQty = 4, -- 每行构建的最大数目，例如一行最多4个酒馆
            tavernId = nil, -- 酒馆模式下，你可以自定义酒馆单位是哪一个(建议使用slkHelper创建酒馆，这样自动就有出售单位等必备技能)
            tavernUnitQty = 10, -- 酒馆模式下，一个酒馆最多拥有几种单位
            onUnitSell = function, -- 酒馆模式时，购买单位的动作，默认是系统pickHero事件，你可自定义
            direct = {1,1}, -- 生成方向，默认左上角开始到右下角结束
        }
    ]]
    local heroIds = options.heroes
    if (heroIds == nil or #heroIds <= 0) then
        heroIds = hRuntime.unit_type_ids.hero or {}
    end
    if (#heroIds <= 0) then
        return
    end
    local during = options.during or -1
    local xType = options.type or "tavern"
    local buildX = options.buildX or 0
    local buildY = options.buildY or 0
    local direct = options.direct or { 1, 1 }
    local buildDistanceX = direct[1] * (options.buildDistance or 256)
    local buildDistanceY = direct[2] * (options.buildDistance or 256)
    local buildRowQty = options.buildRowQty or 4
    if (options.during ~= -1 and options.during < 30) then
        during = 30
    end
    local totalRow = 1
    local currentRowQty = 0
    local x = buildX
    local y = buildY
    if (xType == "click") then
        for _, heroId in ipairs(heroIds) do
            if (currentRowQty >= buildRowQty) then
                currentRowQty = 0
                totalRow = totalRow + 1
                x = buildX
                y = y - buildDistanceY
            else
                x = buildX + currentRowQty * buildDistanceX
            end
            local whichHero = hunit.create(
                {
                    whichPlayer = cj.Player(PLAYER_NEUTRAL_PASSIVE),
                    unitId = heroId,
                    x = x,
                    y = y,
                    isInvulnerable = true,
                    isPause = true
                }
            )
            hRuntime.hero[whichHero] = {
                selector = { x, y },
            }
            table.insert(hhero.selectorClearPool, whichHero)
            table.insert(hhero.selectorPool, whichHero)
            currentRowQty = currentRowQty + 1
        end
        for i = 1, hplayer.qty_max, 1 do
            hevent.onSelection(hplayer.players[i], 2, function(evtData)
                local p = evtData.triggerPlayer
                local whichHero = evtData.triggerUnit
                if (table.includes(whichHero, hhero.selectorClearPool) == false) then
                    return
                end
                if (hunit.getOwner(whichHero) ~= cj.Player(PLAYER_NEUTRAL_PASSIVE)) then
                    return
                end
                local pIndex = hplayer.index(p)
                if (#hhero.player_heroes[pIndex] >= hhero.player_allow_qty[pIndex]) then
                    echo("|cffffff80你已经选够了|r", p)
                    return
                end
                table.delete(whichHero, hhero.selectorPool)
                table.delete(whichHero, hhero.selectorClearPool)
                hunit.setInvulnerable(whichHero, false)
                cj.SetUnitOwner(whichHero, p, true)
                hunit.portal(whichHero, hhero.bornX, hhero.bornY)
                cj.PauseUnit(whichHero, false)
                table.insert(hhero.player_heroes[pIndex], whichHero)
                -- 触发英雄被选择事件(全局)
                hevent.triggerEvent(
                    "global",
                    CONST_EVENT.pickHero,
                    {
                        triggerPlayer = p,
                        triggerUnit = whichHero
                    }
                )
                if (#hhero.player_heroes[pIndex] >= hhero.player_allow_qty[pIndex]) then
                    echo("您选择了 " .. "|cffffff80" .. cj.GetUnitName(whichHero) .. "|r,已挑选完毕", p)
                else
                    echo("您选择了 |cffffff80" .. cj.GetUnitName(whichHero) .. "|r,还要选 " ..
                        math.floor(hhero.player_allow_qty[pIndex] - #hhero.player_heroes[pIndex]) .. " 个", p
                    )
                end
            end)
        end
    elseif (xType == "tavern") then
        local tavernUnitQty = options.tavernUnitQty or 10
        local currentTavernQty = 0
        local tavern
        for _, heroId in ipairs(heroIds) do
            if (tavern == nil or currentTavernQty >= tavernUnitQty) then
                currentTavernQty = 0
                if (currentRowQty >= buildRowQty) then
                    currentRowQty = 0
                    totalRow = totalRow + 1
                    x = buildX
                    y = y - buildDistanceY
                else
                    x = buildX + currentRowQty * buildDistanceX
                end
                tavern = hunit.create(
                    {
                        whichPlayer = cj.Player(PLAYER_NEUTRAL_PASSIVE),
                        unitId = options.tavernId or hslk.unit_hero_tavern,
                        x = x,
                        y = y,
                    }
                )
                table.insert(hhero.selectorClearPool, tavern)
                cj.SetUnitTypeSlots(tavern, tavernUnitQty)
                if (type(options.onUnitSell) == "function") then
                    hevent.onUnitSell(tavern, function(evtData)
                        options.onUnitSell(evtData)
                    end)
                else
                    hevent.onUnitSell(tavern, function(evtData)
                        local p = hunit.getOwner(evtData.buyingUnit)
                        local soldUnit = evtData.soldUnit
                        local soldUid = cj.GetUnitTypeId(soldUnit)
                        hunit.del(soldUnit, 0)
                        local pIndex = hplayer.index(p)
                        if (#hhero.player_heroes[pIndex] >= hhero.player_allow_qty[pIndex]) then
                            echo("|cffffff80你已经选够~|r", p)
                            cj.AddUnitToStock(tavern, soldUid, 1, 1)
                            return
                        end
                        cj.RemoveUnitFromStock(tavern, soldUid)
                        local whichHero = hunit.create(
                            {
                                whichPlayer = p,
                                unitId = soldUid,
                                x = hhero.bornX,
                                y = hhero.bornY,
                            }
                        )
                        table.insert(hhero.player_heroes[pIndex], whichHero)
                        table.delete(string.id2char(soldUid), hhero.selectorPool)
                        local tips = "您选择了 |cffffff80" .. cj.GetUnitName(whichHero) .. "|r"
                        if (#hhero.player_heroes[pIndex] >= hhero.player_allow_qty[pIndex]) then
                            echo(tips .. ",已挑选完毕", p)
                        else
                            echo(tips .. "还差 " .. (hhero.player_allow_qty[pIndex] - #hhero.player_heroes[pIndex]) .. " 个", p)
                        end
                        hRuntime.hero[whichHero] = {
                            selector = evtData.triggerUnit,
                        }
                        -- 触发英雄被选择事件(全局)
                        hevent.triggerEvent(
                            "global",
                            CONST_EVENT.pickHero,
                            {
                                triggerPlayer = p,
                                triggerUnit = whichHero
                            }
                        )
                    end)
                end
                currentRowQty = currentRowQty + 1
            end
            currentTavernQty = currentTavernQty + 1
            cj.AddUnitToStock(tavern, string.char2id(heroId), 1, 1)
            hRuntime.hero[heroId] = tavern
            table.insert(hhero.selectorPool, heroId)
        end
    end
    if (during > 0) then
        -- 视野token
        for i = 1, hplayer.qty_max, 1 do
            local p = cj.Player(i - 1)
            local whichHero = hunit.create(
                {
                    whichPlayer = p,
                    unitId = hhero.build_token,
                    x = buildX + buildRowQty * buildDistanceX * 0.5,
                    y = buildY - math.floor(#heroIds / buildRowQty) * buildDistanceY * 0.5,
                    isInvulnerable = true,
                    isPause = true
                }
            )
            table.insert(hhero.selectorClearPool, whichHero)
        end
        -- 还剩10秒给个选英雄提示
        htime.setTimeout(
            during - 10.0,
            function(t)
                local x2 = buildX + buildRowQty * buildDistanceX * 0.5
                local y2 = buildY - math.floor(#heroIds / buildRowQty) * buildDistanceY * 0.5
                htime.delTimer(t)
                hhero.selectorPool = {}
                echo("还剩 10 秒，还未选择的玩家尽快啦～")
                cj.PingMinimapEx(x2, y2, 8, 255, 0, 0, true)
            end
        )
        -- 逾期不选赶出游戏
        -- 对于可以选择多个的玩家，有选即可，不要求全选
        htime.setTimeout(during - 0.5, function(t)
            htime.delTimer(t)
            for _, hero in ipairs(hhero.selectorClearPool) do
                hunit.del(hero)
            end
            hhero.selectorClearPool = {}
            for i = 1, hplayer.qty_max, 1 do
                if (his.playing(hplayer.players[i]) and #hhero.player_heroes[i] <= 0) then
                    hplayer.defeat(hplayer.players[i], "未选英雄")
                end
            end
        end, "英雄选择")
    end
end
