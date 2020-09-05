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