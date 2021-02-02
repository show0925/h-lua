hRuntime = {
    skill = {
        silentUnits = {},
        silentTrigger = nil,
        unarmUnits = {},
        unarmTrigger = nil,
    },
}

hRuntime.clear = function(handle)
    if (handle == nil) then
        return
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
end

