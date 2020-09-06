--- 技能：光环
hring = {
    ACTIVE_TIMER = nil,
}

--- 检查技能ID是否支持光环服务
---@param abilId number|string
hring.check = function(abilId)
    if (#hmatcher.RING_MATCHER <= 0) then
        return false
    end
    local slk = hskill.getSlk(abilId)
    if (slk == nil) then
        return false
    end
    if (slk.ABILITY_TYPE ~= 'ring') then
        return false
    end
    return true
end

---@private
---@param whichUnit userdata
---@param abilId number|string
hring.insert = function(whichUnit, abilId)
    if (hring.check(abilId) == false) then
        return
    end
    table.insert(hRuntime.ring, { whichUnit, abilId })
    if (#hRuntime.ring == 1) then
        if (hring.ACTIVE_TIMER ~= nil) then
            htime.delTimer(hring.ACTIVE_TIMER)
        end
        hring.ACTIVE_TIMER = htime.setInterval(0.5, function(curTimer)
            if (#hRuntime.ring == 0) then
                htime.delTimer(curTimer)
                curTimer = nil
                hring.ACTIVE_TIMER = nil
                return
            end
            local q = 0
            for k, ring in ipairs(hRuntime.ring) do
                local u = ring[1]
                if (his.deleted(u) == true) then
                    table.remove(hRuntime.ring, k)
                    k = k - 1
                end
                if (his.alive(u) == true) then
                    local abid = ring[2]
                    local slk = hskill.getSlk(abid)
                    if (slk ~= nil and slk.ABILITY_TYPE == 'ring') then
                        local name = slk.Name or -1
                        print_mb(name)
                        for _, m in ipairs(hmatcher.RING_MATCHER) do
                            local s, e = string.find(name, m[1])
                            if (s ~= nil and e ~= nil) then
                                local Area1 = slk.Area1 or 0
                                local targs1 = slk.targs1 or nil
                                if (Area1 > 0 and type(targs1) == string) then
                                    local radius = math.floor(Area1)
                                    local targets = string.explode(',', targs1)
                                    local g = hgroup.createByUnit(u, radius, function(filterUnit)
                                        local selector = {
                                            air = false, --空中
                                            ground = false, --地面
                                            structure = false, --建筑
                                            debris = false, --残骸
                                            organic = false, --有机的
                                            mechanical = false, --机械的
                                            vuln = false, --可攻击
                                            invu = false, --无敌
                                            friend = false, --友军
                                            enemies = false, --敌人
                                            allies = false, --联盟
                                            neutral = false, --中立
                                            self = false, --自己
                                            nonself = false, --非自己
                                            alive = false, --存活
                                            dead = false, --死亡
                                            hero = false, --英雄
                                            nonhero = false, --非英雄
                                            ancient = false, --古树
                                            nonancient = false, --非古树
                                            ward = false, --守卫
                                        }
                                        for _, t in ipairs(targets) do
                                            if (selector[t] ~= nil) then
                                                selector[t] = true
                                            end
                                        end

                                        return status and heroStatus
                                    end)
                                    if (#g > 0) then
                                        g = nil
                                    end
                                end
                                m[2]({
                                    centerUnit = u,
                                })
                            end
                        end
                    end
                end
            end
        end)
    end
end

---@private
---@param whichUnit userdata
---@param abilId number|string
hring.remove = function(whichUnit, abilId)
    if (hring.check(abilId) == false) then
        return
    end
    for k, v in ipairs(hRuntime.ring) do
        if (v[1] == whichUnit and v[2] == abilId) then
            table.remove(arr, k)
            k = k - 1
            break
        end
    end
    if (#hRuntime.ring == 0) then
        if (hring.ACTIVE_TIMER ~= nil) then
            htime.delTimer(hring.ACTIVE_TIMER)
            hring.ACTIVE_TIMER = nil
        end
    end
end