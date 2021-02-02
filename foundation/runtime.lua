hRuntime = {
    skill = {
    },
}

hRuntime.clear = function(handle)
    if (handle == nil) then
        return
    end
    if (hRuntime.skill[handle] ~= nil) then
        hRuntime.skill[handle] = nil
    end
end

