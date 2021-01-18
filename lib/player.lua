---@class hplayer
hplayer = {
    --- 用户玩家
    players = {},
    --- 中立敌对
    player_aggressive = cj.Player(PLAYER_NEUTRAL_AGGRESSIVE),
    --- 中立受害
    player_victim = cj.Player(bj_PLAYER_NEUTRAL_VICTIM),
    --- 中立特殊
    player_extra = cj.Player(bj_PLAYER_NEUTRAL_EXTRA),
    --- 中立被动
    player_passive = cj.Player(PLAYER_NEUTRAL_PASSIVE),
    --- 玩家状态
    player_status = {
        none = "无参与",
        gaming = "游戏中",
        leave = "已离开"
    },
    --- 用户玩家最大数量
    qty_max = 12,
    --- 当前玩家数量
    qty_current = 0,
    --- 换算比率，默认：1000000金 -> 1木
    convert_ratio = 1000000
}

---@private
hplayer.set = function(whichPlayer, key, value)
    if (whichPlayer == nil) then
        print_stack()
        return
    end
    local index = hplayer.index(whichPlayer)
    if (hRuntime.player[index] == nil) then
        hRuntime.player[index] = {}
    end
    hRuntime.player[index][key] = value
end

---@private
hplayer.get = function(whichPlayer, key, default)
    if (whichPlayer == nil) then
        print_stack()
        return
    end
    local index = hplayer.index(whichPlayer)
    if (hRuntime.player[index] == nil) then
        hRuntime.player[index] = {}
    end
    return hRuntime.player[index][key] or default
end

---@private
hplayer.adjustPlayerState = function(delta, whichPlayer, whichPlayerState)
    if delta > 0 then
        if whichPlayerState == PLAYER_STATE_RESOURCE_GOLD then
            cj.SetPlayerState(
                whichPlayer,
                PLAYER_STATE_GOLD_GATHERED,
                cj.GetPlayerState(whichPlayer, PLAYER_STATE_GOLD_GATHERED) + delta
            )
        elseif whichPlayerState == PLAYER_STATE_RESOURCE_LUMBER then
            cj.SetPlayerState(
                whichPlayer,
                PLAYER_STATE_LUMBER_GATHERED,
                cj.GetPlayerState(whichPlayer, PLAYER_STATE_LUMBER_GATHERED) + delta
            )
        end
    end
    cj.SetPlayerState(whichPlayer, whichPlayerState, cj.GetPlayerState(whichPlayer, whichPlayerState) + delta)
end

---@private
hplayer.setPlayerState = function(whichPlayer, whichPlayerState, value)
    local oldValue = cj.GetPlayerState(whichPlayer, whichPlayerState)
    hplayer.adjustPlayerState(value - oldValue, whichPlayer, whichPlayerState)
end

--- 遍历玩家
---@alias Handler fun(enumPlayer: userdata, idx: number):void
---@param action Handler | "function(enumPlayer, idx) end"
hplayer.forEach = function(action)
    if (action == nil) then
        return
    end
    if (type(action) == "function") then
        for idx = 1, hplayer.qty_max, 1 do
            action(hplayer.players[idx], idx)
        end
    end
end

--- 设置换算比率
---@param ratio number (%)
hplayer.setConvertRatio = function(ratio)
    hplayer.convert_ratio = ratio
end

--- 获取换算比率
---@return number (%)
hplayer.getConvertRatio = function()
    return hplayer.convert_ratio
end

--- 获取玩家ID
--- 例如：玩家一等于1，玩家三等于3
---@param whichPlayer userdata
---@return number
hplayer.index = function(whichPlayer)
    return cj.GetPlayerId(whichPlayer) + 1
end

--- 获取玩家名称
---@param whichPlayer userdata
---@return string
hplayer.getName = function(whichPlayer)
    return cj.GetPlayerName(whichPlayer)
end

--- 设置玩家名称
---@param whichPlayer userdata
---@param name string
hplayer.setName = function(whichPlayer, name)
    cj.SetPlayerName(whichPlayer, name)
end

--- 获取玩家当前选中的单位
---@param whichPlayer userdata
---@return userdata unit
hplayer.getSelection = function(whichPlayer)
    return hplayer.get(whichPlayer, "selection", nil)
end

--- 获取玩家当前状态
---@param whichPlayer userdata
---@return string
hplayer.getStatus = function(whichPlayer)
    return hplayer.get(whichPlayer, "status", hplayer.player_status.none)
end
--- 设置玩家当前状态
---@param whichPlayer userdata
---@param status string
hplayer.setStatus = function(whichPlayer, status)
    hplayer.set(whichPlayer, "status", status)
end

--- 获取玩家当前称号
---@param whichPlayer userdata
---@return string
hplayer.getPrestige = function(whichPlayer)
    return hplayer.get(whichPlayer, "prestige", "无称号")
end
--- 设置玩家当前称号
---@param whichPlayer userdata
---@param status string
hplayer.setPrestige = function(whichPlayer, prestige)
    hplayer.set(whichPlayer, "prestige", prestige)
end

--- 获取玩家是否支持random/repick命令
---@param whichPlayer userdata
---@return boolean
hplayer.getAllowCommandPick = function(whichPlayer)
    return hplayer.get(whichPlayer, "allowCommandPick", false)
end
--- 设置玩家是否支持random/repick命令
---@param whichPlayer userdata
---@param flag boolean
hplayer.setAllowCommandPick = function(whichPlayer, flag)
    hplayer.set(whichPlayer, "allowCommandPick", flag)
end

--- 获取玩家APM
---@param whichPlayer userdata
---@return number
hplayer.getApm = function(whichPlayer)
    return hplayer.get(whichPlayer, "apm", 0)
end
--- 设置玩家是否允许调节镜头高度
---@param whichPlayer userdata
---@param flag boolean
hplayer.setAllowCameraDistance = function(whichPlayer, flag)
    if (whichPlayer == nil) then
        return
    end
    if (type(flag) ~= "boolean") then
        flag = false
    end
    hplayer.set(whichPlayer, "allowCameraDistance", flag)
end
--- 玩家是否允许调节镜头高度
---@param whichPlayer userdata
---@return boolean
hplayer.getAllowCameraDistance = function(whichPlayer)
    return hplayer.get(whichPlayer, "allowCameraDistance")
end
--- 在所有玩家里获取一个随机的英雄
---@return userdata
hplayer.getRandomHero = function()
    local pi = {}
    for k, v in ipairs(hplayer.players) do
        if (hplayer.setStatus(v) == hplayer.status.gaming) then
            table.insert(pi, k)
        end
    end
    if (#pi <= 0) then
        return nil
    end
    local ri = math.random(1, #pi)
    return hhero.getPlayerUnit(
        hplayer.players[pi[ri]],
        math.random(1, hhero.getPlayerAllowQty(hplayer.players[pi[ri]]))
    )
end
--- 令玩家单位全部隐藏
---@param whichPlayer userdata
hplayer.hideUnit = function(whichPlayer)
    if (whichPlayer == nil) then
        return
    end
    local g = hgroup.createByRect(
        hrect.WORLD_BOUND,
        function(filterUnit)
            return hunit.getOwner(filterUnit) == whichPlayer
        end
    )
    hgroup.forEach(g, function(enumUnit)
        cj.ShowUnit(enumUnit, false)
    end)
    g = nil
end
--- 令玩家单位全部删除
---@param whichPlayer userdata
hplayer.clearUnit = function(whichPlayer)
    if (whichPlayer == nil) then
        return
    end
    local g = hgroup.createByRect(
        hrect.WORLD_BOUND,
        function(filterUnit)
            return hunit.getOwner(filterUnit) == whichPlayer
        end
    )
    hgroup.clear(g, true, true)
end
--- 令玩家失败并退出
---@param whichPlayer userdata
---@param tips string
hplayer.defeat = function(whichPlayer, tips)
    if (whichPlayer == nil) then
        return
    end
    if (tips == "" or tips == nil) then
        tips = "失败"
    end
    hplayer.clearUnit(whichPlayer)
    cj.RemovePlayer(whichPlayer, PLAYER_GAME_RESULT_DEFEAT)
    if hplayer.qty_current > 1 then
        cj.DisplayTimedTextFromPlayer(whichPlayer, 0, 0, 60, cj.GetLocalizedString("PLAYER_DEFEATED"))
    end
    if (cj.GetPlayerController(whichPlayer) == MAP_CONTROL_USER) then
        hdialog.create(whichPlayer, {
            title = tips,
            buttons = { cj.GetLocalizedString("GAMEOVER_QUIT_MISSION") }
        }, function()
            cj.EndGame(true)
        end)
    end
end
--- 令玩家胜利并退出
---@param whichPlayer userdata
---@param tips string
hplayer.victory = function(whichPlayer, tips)
    if (whichPlayer == nil) then
        return
    end
    if (tips == "" or tips == nil) then
        tips = "胜利"
    end
    cj.RemovePlayer(whichPlayer, PLAYER_GAME_RESULT_VICTORY)
    if hplayer.qty_current > 1 then
        cj.DisplayTimedTextFromPlayer(whichPlayer, 0, 0, 60, cj.GetLocalizedString("PLAYER_VICTORIOUS"))
    end
    if (cj.GetPlayerController(whichPlayer) == MAP_CONTROL_USER) then
        cg.bj_changeLevelShowScores = true
        hdialog.create(whichPlayer, {
            title = tips,
            buttons = { cj.GetLocalizedString("GAMEOVER_QUIT_MISSION") }
        }, function()
            cj.EndGame(true)
        end)
    end
end

--- 玩家设置是否自动将{hAwardConvertRatio}黄金换1木头
---@param whichPlayer userdata
---@param b boolean
hplayer.setIsAutoConvert = function(whichPlayer, b)
    hplayer.set(whichPlayer, "isAutoConvert", b)
end
--- 获取玩家是否自动将{hAwardConvertRatio}黄金换1木头
---@param whichPlayer userdata
---@return boolean
hplayer.getIsAutoConvert = function(whichPlayer)
    return hplayer.get(whichPlayer, "isAutoConvert", false)
end

--- 设置玩家镜头是否在震动
---@private
---@param whichPlayer userdata
---@param b boolean
hplayer.setIsShocking = function(whichPlayer, b)
    hplayer.set(whichPlayer, "isShocking", b)
end
--- 获取玩家镜头是否在震动
---@param whichPlayer userdata
---@return boolean
hplayer.getIsShocking = function(whichPlayer)
    return hplayer.get(whichPlayer, "isShocking", false)
end

--- 自动寄存超出的黄金数量，如果满转换数值，则返回对应的整数木头
---@private
hplayer.getExceedLumber = function(whichPlayer, exceedGold)
    local current = hplayer.get(whichPlayer, "exceed_gold", 0)
    local l = 0
    if (current < 0) then
        current = 0
    end
    current = current + exceedGold
    if (current > 10000000) then
        current = 10000000
    end
    -- 如果没有开启，则先寄存着，开启后再换算，但是最多只存1000W
    if (hplayer.getIsAutoConvert(whichPlayer) == true and current >= hplayer.getConvertRatio()) then
        l = math.floor(current / player_convert_ratio)
        current = math.floor(current - l * player_convert_ratio)
    end
    hplayer.set(whichPlayer, "exceed_gold", current)
    return l
end
--- 获取玩家造成的总伤害
---@param whichPlayer userdata
---@return number
hplayer.getDamage = function(whichPlayer)
    return hplayer.get(whichPlayer, "damage", 0)
end
--- 增加玩家造成的总伤害
---@param whichPlayer userdata
---@param val number
hplayer.addDamage = function(whichPlayer, val)
    if (whichPlayer == nil) then
        return
    end
    val = val or 0
    hplayer.set(whichPlayer, "damage", hplayer.getDamage(whichPlayer) + val)
end
--- 获取玩家受到的总伤害
---@param whichPlayer userdata
---@return number
hplayer.getBeDamage = function(whichPlayer)
    return hplayer.get(whichPlayer, "beDamage", 0)
end
--- 增加玩家受到的总伤害
---@param whichPlayer userdata
---@param val number
hplayer.addBeDamage = function(whichPlayer, val)
    if (whichPlayer == nil) then
        return
    end
    val = val or 0
    hplayer.set(whichPlayer, "beDamage", hplayer.getBeDamage(whichPlayer) + val)
end
--- 获取玩家杀敌数
---@param whichPlayer userdata
---@return number
hplayer.getKill = function(whichPlayer)
    return hplayer.get(whichPlayer, "kill", 0)
end
-- 增加玩家杀敌数
---@param whichPlayer userdata
---@param val number
hplayer.addKill = function(whichPlayer, val)
    if (whichPlayer == nil) then
        return
    end
    val = val or 1
    hplayer.set(whichPlayer, "kill", hplayer.getKill(whichPlayer) + val)
end

--- 黄金比率
---@private
hplayer.diffGoldRatio = function(whichPlayer, diff, during)
    if (diff ~= 0) then
        hplayer.set(whichPlayer, "goldRatio", hplayer.get(whichPlayer, "goldRatio") + diff)
        if (during > 0) then
            htime.setTimeout(
                during,
                function(t)
                    htime.delTimer(t)
                    hplayer.set(whichPlayer, "goldRatio", hplayer.get(whichPlayer, "goldRatio") - diff)
                end
            )
        end
    end
end
---@param whichPlayer userdata
---@param val number
---@param during number
hplayer.setGoldRatio = function(whichPlayer, val, during)
    hplayer.diffGoldRatio(whichPlayer, val - hplayer.get(whichPlayer, "goldRatio"), during)
end
---@param whichPlayer userdata
---@param val number
---@param during number
hplayer.addGoldRatio = function(whichPlayer, val, during)
    hplayer.diffGoldRatio(whichPlayer, val, during)
end
---@param whichPlayer userdata
---@param val number
---@param during number
hplayer.subGoldRatio = function(whichPlayer, val, during)
    hplayer.diffGoldRatio(whichPlayer, -val, during)
end
---@param whichPlayer userdata
---@return number %
hplayer.getGoldRatio = function(whichPlayer)
    return hplayer.get(whichPlayer, "goldRatio") or 100
end

--- 木头比率
---@private
hplayer.diffLumberRatio = function(whichPlayer, diff, during)
    if (diff ~= 0) then
        hplayer.set(whichPlayer, "lumberRatio", hplayer.get(whichPlayer, "lumberRatio") + diff)
        if (during > 0) then
            htime.setTimeout(
                during,
                function(t)
                    htime.delTimer(t)
                    hplayer.set(whichPlayer, "lumberRatio", hplayer.get(whichPlayer, "lumberRatio") - diff)
                end
            )
        end
    end
end
---@param whichPlayer userdata
---@param val number
---@param during number
hplayer.setLumberRatio = function(whichPlayer, val, during)
    local index = hplayer.index(whichPlayer)
    hplayer.diffLumberRatio(whichPlayer, val - hplayer.get(whichPlayer, "lumberRatio"), during)
end
---@param whichPlayer userdata
---@param val number
---@param during number
hplayer.addLumberRatio = function(whichPlayer, val, during)
    hplayer.diffLumberRatio(whichPlayer, val, during)
end
---@param whichPlayer userdata
---@param val number
---@param during number
hplayer.subLumberRatio = function(whichPlayer, val, during)
    hplayer.diffLumberRatio(whichPlayer, -val, during)
end
---@param whichPlayer userdata
---@return number %
hplayer.getLumberRatio = function(whichPlayer)
    return hplayer.get(whichPlayer, "lumberRatio")
end

--- 经验比率
---@private
hplayer.diffExpRatio = function(whichPlayer, diff, during)
    if (diff ~= 0) then
        hplayer.set(whichPlayer, "expRatio", hplayer.get(whichPlayer, "expRatio") + diff)
        if (during > 0) then
            htime.setTimeout(
                during,
                function(t)
                    htime.delTimer(t)
                    hplayer.set(whichPlayer, "expRatio", hplayer.get(whichPlayer, "expRatio") - diff)
                end
            )
        end
    end
end
---@param whichPlayer userdata
---@param val number
---@param during number
hplayer.setExpRatio = function(whichPlayer, val, during)
    local index = hplayer.index(whichPlayer)
    hplayer.diffExpRatio(whichPlayer, val - hplayer.get(whichPlayer, "expRatio"), during)
end
---@param whichPlayer userdata
---@param val number
---@param during number
hplayer.addExpRatio = function(whichPlayer, val, during)
    hplayer.diffExpRatio(whichPlayer, val, during)
end
---@param whichPlayer userdata
---@param val number
---@param during number
hplayer.subExpRatio = function(whichPlayer, val, during)
    hplayer.diffExpRatio(whichPlayer, -val, during)
end
---@param whichPlayer userdata
---@return number %
hplayer.getExpRatio = function(whichPlayer)
    return hplayer.get(whichPlayer, "expRatio")
end

--- 售卖比率
---@private
hplayer.diffSellRatio = function(whichPlayer, diff, during)
    if (diff ~= 0) then
        hplayer.set(whichPlayer, "sellRatio", hplayer.get(whichPlayer, "sellRatio") + diff)
        if (during > 0) then
            htime.setTimeout(
                during,
                function(t)
                    htime.delTimer(t)
                    hplayer.set(whichPlayer, "sellRatio", hplayer.get(whichPlayer, "sellRatio") - diff)
                end
            )
        end
    end
end
---@param whichPlayer userdata
---@param val number
---@param during number
hplayer.setSellRatio = function(whichPlayer, val, during)
    local index = hplayer.index(whichPlayer)
    hplayer.diffSellRatio(whichPlayer, val - hplayer.get(whichPlayer, "sellRatio"), during)
end
---@param whichPlayer userdata
---@param val number
---@param during number
hplayer.addSellRatio = function(whichPlayer, val, during)
    hplayer.diffSellRatio(whichPlayer, val, during)
end
---@param whichPlayer userdata
---@param val number
---@param during number
hplayer.subSellRatio = function(whichPlayer, val, during)
    hplayer.diffSellRatio(whichPlayer, -val, during)
end
---@param whichPlayer userdata
---@return number %
hplayer.getSellRatio = function(whichPlayer)
    return hplayer.get(whichPlayer, "sellRatio", 50)
end

--- 玩家总获金量
---@param whichPlayer userdata
---@return number
hplayer.getTotalGold = function(whichPlayer)
    return hplayer.get(whichPlayer, "totalGold")
end
---@param whichPlayer userdata
---@param val number
hplayer.addTotalGold = function(whichPlayer, val)
    return hplayer.set(whichPlayer, "totalGold", hplayer.getTotalGold(whichPlayer) + val)
end
--- 玩家总耗金量
---@param whichPlayer userdata
---@return number
hplayer.getTotalGoldCost = function(whichPlayer)
    return hplayer.get(whichPlayer, "totalGoldCost")
end
---@param whichPlayer userdata
---@param val number
hplayer.addTotalGoldCost = function(whichPlayer, val)
    return hplayer.set(whichPlayer, "totalGoldCost", hplayer.getTotalGoldCost(whichPlayer) + val)
end

--- 玩家总获木量
---@param whichPlayer userdata
---@return number
hplayer.getTotalLumber = function(whichPlayer)
    return hplayer.get(whichPlayer, "totalLumber")
end
---@param whichPlayer userdata
---@param val number
hplayer.addTotalLumber = function(whichPlayer, val)
    return hplayer.set(whichPlayer, "totalLumber", hplayer.getTotalLumber(whichPlayer) + val)
end
--- 玩家总耗木量
---@param whichPlayer userdata
---@return number
hplayer.getTotalLumberCost = function(whichPlayer)
    return hplayer.get(whichPlayer, "totalLumberCost")
end
---@param whichPlayer userdata
---@param val number
hplayer.addTotalLumberCost = function(whichPlayer, val)
    return hplayer.set(whichPlayer, "totalLumberCost", hplayer.getTotalLumberCost(whichPlayer) + val)
end

--- 核算玩家金钱
---@private
hplayer.adjustGold = function(whichPlayer)
    local prvSys = hplayer.get(whichPlayer, "prevGold")
    local relSys = cj.GetPlayerState(whichPlayer, PLAYER_STATE_RESOURCE_GOLD)
    if (prvSys > relSys) then
        hplayer.addTotalGoldCost(whichPlayer, prvSys - relSys)
    elseif (prvSys < relSys) then
        hplayer.addTotalGold(whichPlayer, relSys - prvSys)
    end
    hplayer.set(whichPlayer, "prevGold", relSys)
end
--- 核算玩家木头
---@private
hplayer.adjustLumber = function(whichPlayer)
    local prvSys = hplayer.get(whichPlayer, "prevLumber")
    local relSys = cj.GetPlayerState(whichPlayer, PLAYER_STATE_RESOURCE_LUMBER)
    if (prvSys > relSys) then
        hplayer.addTotalLumberCost(whichPlayer, prvSys - relSys)
    elseif (prvSys < relSys) then
        hplayer.addTotalLumber(whichPlayer, relSys - prvSys)
    end
    hplayer.set(whichPlayer, "prevLumber", relSys)
end

--- 获取玩家实时金钱
---@param whichPlayer userdata
---@return number
hplayer.getGold = function(whichPlayer)
    return cj.GetPlayerState(whichPlayer, PLAYER_STATE_RESOURCE_GOLD)
end
--- 设置玩家实时金钱
---@param whichPlayer userdata
---@param gold number
---@param u userdata|nil 可设置一个单位用于事件回调
hplayer.setGold = function(whichPlayer, gold, u)
    if (whichPlayer == nil) then
        return
    end
    -- 触发英雄资源变动
    hevent.triggerEvent("global", CONST_EVENT.playerResourceChange, {
        triggerPlayer = whichPlayer,
        triggerUnit = u,
        type = 'gold',
        value = gold - hplayer.getGold(whichPlayer),
    })
    local exceedLumber = 0
    -- 满 100W 调用自动换算（至于换不换算，看玩家有没有开转换）
    if (gold > 1000000) then
        exceedLumber = hplayer.getExceedLumber(whichPlayer, gold - 1000000)
        if (hplayer.getIsAutoConvert(whichPlayer) == true) then
            if (exceedLumber > 0) then
                hplayer.adjustPlayerState(exceedLumber, whichPlayer, PLAYER_STATE_RESOURCE_LUMBER)
                hplayer.adjustLumber(whichPlayer)
            end
        end
        gold = 1000000
    end
    hplayer.setPlayerState(whichPlayer, PLAYER_STATE_RESOURCE_GOLD, gold)
    hplayer.adjustGold(whichPlayer)
end
--- 增加玩家金钱
---@param whichPlayer userdata
---@param gold number
---@param u userdata|nil 可设置一个单位用于事件回调
hplayer.addGold = function(whichPlayer, gold, u)
    if (whichPlayer == nil) then
        return
    end
    gold = cj.R2I(gold * hplayer.getGoldRatio(whichPlayer) / 100)
    hplayer.setGold(whichPlayer, hplayer.getGold(whichPlayer) + gold, u)
end
--- 减少玩家金钱
---@param whichPlayer userdata
---@param gold number
---@param u userdata|nil 可设置一个单位用于事件回调
hplayer.subGold = function(whichPlayer, gold, u)
    if (whichPlayer == nil) then
        return
    end
    hplayer.setGold(whichPlayer, hplayer.getGold(whichPlayer) - gold, u)
end

--- 获取玩家实时木头
---@param whichPlayer userdata
---@return number
hplayer.getLumber = function(whichPlayer)
    return cj.GetPlayerState(whichPlayer, PLAYER_STATE_RESOURCE_LUMBER)
end
--- 设置玩家实时木头
---@param whichPlayer userdata
---@param lumber number
---@param u userdata|nil 可设置一个单位用于事件回调
hplayer.setLumber = function(whichPlayer, lumber, u)
    if (whichPlayer == nil) then
        return
    end
    -- 触发英雄资源变动
    hevent.triggerEvent('global', CONST_EVENT.playerResourceChange, {
        triggerPlayer = whichPlayer,
        triggerUnit = u,
        type = 'lumber',
        value = lumber - hplayer.getLumber(whichPlayer),
    })
    hplayer.setPlayerState(whichPlayer, PLAYER_STATE_RESOURCE_LUMBER, lumber)
    hplayer.adjustLumber(whichPlayer)
end
--- 增加玩家木头
---@param whichPlayer userdata
---@param gold number
---@param u userdata|nil 可设置一个单位用于事件回调
hplayer.addLumber = function(whichPlayer, lumber, u)
    if (whichPlayer == nil) then
        return
    end
    lumber = cj.R2I(lumber * hplayer.getLumberRatio(whichPlayer) / 100)
    hplayer.setLumber(whichPlayer, hplayer.getLumber(whichPlayer) + lumber, u)
end
--- 减少玩家木头
---@param whichPlayer userdata
---@param lumber number
---@param u userdata|nil 可设置一个单位用于事件回调
hplayer.subLumber = function(whichPlayer, lumber, u)
    if (whichPlayer == nil) then
        return
    end
    hplayer.setLumber(whichPlayer, hplayer.getLumber(whichPlayer) - lumber, u)
end
