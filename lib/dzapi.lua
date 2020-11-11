hdzapi = {
    enable = (cg.HLUA_DZAPI_FLAG == true),
    tips_showed = false,
    commandHashCache = {},
    mallItemCheater = {},
    tallocStatus = {
        index = 0,
        queue = {},
    },
    ---@private
    commandHash = function(command)
        if (hdzapi.commandHashCache[command] == nil) then
            hdzapi.commandHashCache[command] = cj.StringHash(command)
        end
        return hdzapi.commandHashCache[command]
    end,
    ---@private
    talloc = function()
        local index = -1
        local i = hdzapi.tallocStatus.index + 1
        if (i > cg.Hlua_DzAPI_Tgr_count) then
            i = 1
        end
        if (hdzapi.tallocStatus.queue[i] == nil) then
            hdzapi.tallocStatus.queue[i] = {
                status = false,
                result = nil
            }
        end
        if (hdzapi.tallocStatus.queue[i].status == false) then
            index = i
        else
            for j = 1, cg.Hlua_DzAPI_Tgr_count do
                if (hdzapi.tallocStatus.queue[j].status == false) then
                    index = j
                    break
                end
            end
        end
        if (index == -1) then
            print_err("Need more DZapi trigger")
            return
        end
        hdzapi.tallocStatus.queue[index].status = true
        hdzapi.tallocStatus.queue[index].result = nil
        return cg['Hlua_DzAPI_Tgr_' .. index], index
    end,
    ---@private
    exec = function(command, ...)
        if (hdzapi.enable ~= true) then
            if (hdzapi.tips_showed == false) then
                print("Copy ./plugin/dzapi.v2.jass For Dzapi.lua")
                hdzapi.tips_showed = true
            end
            return
        end
        local whichPlayer = select("1", ...)
        local key = select("2", ...)
        local data = select("3", ...)
        if (whichPlayer ~= nil and his.playing(whichPlayer) == false) then
            return
        end
        local tgr, tIndex = hdzapi.talloc()
        local tid = cj.GetHandleId(tgr)
        cj.SaveStr(cg.hash_hlua_dzapi, tid, cg.HLDK_COMMAND, command)
        if (whichPlayer ~= nil) then
            cj.SavePlayerHandle(cg.hash_hlua_dzapi, tid, cg.HLDK_PLAYER, whichPlayer)
        end
        if (key ~= nil) then
            cj.SaveStr(cg.hash_hlua_dzapi, tid, cg.HLDK_KEY, key)
        end
        if (data ~= nil) then
            cj.SaveStr(cg.hash_hlua_dzapi, tid, cg.HLDK_DATA, data)
        end
        cj.TriggerExecute(tgr)
        local res = cj.LoadStr(cg.hash_hlua_dzapi, tid, cg.HLDK_RESULT)
        hdzapi.tallocStatus.queue[tIndex].status = false
        hdzapi.tallocStatus.queue[tIndex].command = command
        hdzapi.tallocStatus.queue[tIndex].result = res
        if (type(res) == "string") then
            return res
        end
    end
}

--- 是否红V
---@param whichPlayer userdata
---@return boolean
hdzapi.isVipRed = function(whichPlayer)
    return hdzapi.exec("IsRedVIP", whichPlayer) == "1"
end

--- 是否蓝V
---@param whichPlayer userdata
---@return boolean
hdzapi.isVipBlue = function(whichPlayer)
    return hdzapi.exec("IsBlueVIP", whichPlayer) == "1"
end

--- 获取地图等级
---@param whichPlayer userdata
---@return number
hdzapi.mapLv = function(whichPlayer)
    local lv = hdzapi.exec("GetMapLevel", whichPlayer)
    if (lv == nil or lv == "") then
        lv = 1
    else
        lv = math.floor(lv)
    end
    if (lv < 1) then
        lv = 1
    end
    return lv
end

--- 是否有商城道具,由于官方设置的key必须大写，所以这里自动转换
---@param whichPlayer userdata
---@param key string
---@return boolean
hdzapi.hasMallItem = function(whichPlayer, key)
    if (whichPlayer == nil or key == nil) then
        return false
    end
    if (hdzapi.mallItemCheater[whichPlayer] == true) then
        return true
    end
    key = string.upper(key)
    return hdzapi.exec("HasMallItem", whichPlayer, key) == "1"
end

--- 设置一个玩家为特殊商城人员，可以获得所有的道具
---@param whichPlayer userdata
hdzapi.setMallItemCheater = function(whichPlayer)
    if (whichPlayer == nil) then
        return
    end
    hdzapi.mallItemCheater[whichPlayer] = true
end

-- 服务器存档
hdzapi.server = {}

--- 读取服务器存档是否成功，没有开通或这服务器崩了返回false
---@param whichPlayer userdata
---@return boolean
hdzapi.server.ready = function(whichPlayer)
    return hdzapi.exec("GetPlayerServerValueSuccess", whichPlayer) == "1"
end

--- 设置房间数据
---@param whichPlayer userdata
---@param key string
---@param text string
hdzapi.setRoomStat = function(whichPlayer, key, text)
    if (hdzapi.server.ready(whichPlayer) == true) then
        hdzapi.exec("Stat_SetStat", whichPlayer, tostring(key), tostring(text))
    end
end

---@private
hdzapi.server.save = function(whichPlayer, key, data)
    if (data == nil) then
        return
    end
    if (hdzapi.server.ready(whichPlayer) == true) then
        hdzapi.exec("SaveServerValue", whichPlayer, key, tostring(data))
    end
end

---@private
hdzapi.server.load = function(whichPlayer, key)
    if (hdzapi.server.ready(whichPlayer) == true) then
        return hdzapi.exec("GetServerValue", whichPlayer, key)
    end
end

--- 清理服务器存档数据
---@param whichPlayer userdata
---@param key string
hdzapi.server.clear = {
    int = function(whichPlayer, key)
        hdzapi.server.save(whichPlayer, "I" .. key, "")
    end,
    real = function(whichPlayer, key)
        hdzapi.server.save(whichPlayer, "R" .. key, "")
    end,
    bool = function(whichPlayer, key)
        hdzapi.server.save(whichPlayer, "B" .. key, "")
    end,
    str = function(whichPlayer, key)
        hdzapi.server.save(whichPlayer, "S" .. key, "")
    end,
    unit = function(whichPlayer, key)
        hdzapi.server.save(whichPlayer, "S" .. key, "")
    end,
    item = function(whichPlayer, key)
        hdzapi.server.save(whichPlayer, "S" .. key, "")
    end
}

--- 封装的服务器存档 get / set
hdzapi.server.set = {
    int = function(whichPlayer, key, data)
        hdzapi.server.save(whichPlayer, "I" .. key, data or 0)
    end,
    real = function(whichPlayer, key, data)
        hdzapi.server.save(whichPlayer, "R" .. key, data or 0)
    end,
    bool = function(whichPlayer, key, data)
        local b = "0"
        if (data == true) then
            b = "1"
        end
        hdzapi.server.save(whichPlayer, "B" .. key, b)
    end,
    str = function(whichPlayer, key, data)
        hdzapi.server.save(whichPlayer, "S" .. key, data)
    end,
    unit = function(whichPlayer, key, data)
        hdzapi.server.save(whichPlayer, "S" .. key, hunit.getId(data))
    end,
    item = function(whichPlayer, key, data)
        hdzapi.server.save(whichPlayer, "S" .. key, hitem.getId(data))
    end
}
hdzapi.server.get = {
    int = function(whichPlayer, key)
        local val = hdzapi.server.load(whichPlayer, "I" .. key) or 0
        if (val == "") then
            val = 0
        end
        return math.floor(val)
    end,
    real = function(whichPlayer, key)
        local val = hdzapi.server.load(whichPlayer, "R" .. key) or 0
        if (val == "") then
            val = 0
        end
        return math.round(val)
    end,
    bool = function(whichPlayer, key)
        local b = hdzapi.server.load(whichPlayer, "B" .. key)
        if (b == "1") then
            return true
        end
        return false
    end,
    str = function(whichPlayer, key)
        return hdzapi.server.load(whichPlayer, "S" .. key) or ""
    end,
    unit = function(whichPlayer, key)
        local id = hdzapi.server.load(whichPlayer, "S" .. key) or ""
        if (string.len(id) > 0) then
            return string.char2id(id)
        end
        return nil
    end,
    item = function(whichPlayer, key)
        local id = hdzapi.server.load(whichPlayer, "S" .. key) or ""
        if (string.len(id) > 0) then
            return string.char2id(id)
        end
        return nil
    end
}
