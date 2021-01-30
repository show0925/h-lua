hRuntime = {
    event = {
        -- 核心注册
        register = {},
        -- 池
        pool = {},
    },
    skill = {
        silentUnits = {},
        silentTrigger = nil,
        unarmUnits = {},
        unarmTrigger = nil,
    },
    attributeGroup = {
        life_back = {},
        mana_back = {},
        punish = {}
    },
    multiBoard = {},
    buff = {},
}

hRuntime.clear = function(handle)
    if (handle == nil) then
        return
    end
    if (hRuntime.event[handle] ~= nil) then
        hRuntime.event[handle] = nil
    end
    if (hRuntime.event.register[handle] ~= nil) then
        hRuntime.event.register[handle] = nil
    end
    if (hRuntime.event.pool[handle] ~= nil) then
        for _, p in ipairs(hRuntime.event.pool[handle]) do
            local key = p.key
            local poolIndex = p.poolIndex
            hevent.POOL[key][poolIndex].stock = hevent.POOL[key][poolIndex].stock - 1
            -- 起码利用红线1/4允许归零
            if (hevent.POOL[key][poolIndex].stock == 0
                and hevent.POOL[key][poolIndex].count > 0.25 * hevent.POOL_RED_LINE) then
                cj.DisableTrigger(hevent.POOL[key][poolIndex].trigger)
                cj.DestroyTrigger(hevent.POOL[key][poolIndex].trigger)
                hevent.POOL[key][poolIndex] = -1
            end
            local e = 0
            for _, v in ipairs(hevent.POOL[key]) do
                if (v == -1) then
                    e = e + 1
                end
            end
            if (e == #hevent.POOL[key]) then
                hevent.POOL[key] = nil
            end
        end
        hRuntime.event.pool[handle] = nil
    end
    if (hRuntime.skill[handle] ~= nil) then
        hRuntime.skill[handle] = nil
        if (table.includes(hRuntime.skill.silentUnits, handle)) then
            table.delete(hRuntime.skill.silentUnits, handle)
        end
        if (table.includes(hRuntime.skill.unarmUnits, handle)) then
            table.delete(hRuntime.skill.unarmUnits, handle)
        end
    end
    if (hRuntime.multiBoard[handle] ~= nil) then
        hRuntime.multiBoard[handle] = nil
    end
    if (hRuntime.buff[handle] ~= nil) then
        hRuntime.buff[handle] = nil
    end
end

