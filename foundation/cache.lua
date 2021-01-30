hcache = {}

---@private
---@return boolean
hcache.exist = function(handle, key)
    if (handle == nil) then
        return true
    end
    if (hcache[handle] == nil) then
        return true
    end
    if (key ~= nil and hcache[handle][key] == nil) then
        return true
    end
    return false
end

---@private
hcache.alloc = function(handle)
    if (handle == nil) then
        print_stack()
        return
    end
    if (hcache[handle] == nil) then
        hcache[handle] = {}
    end
end

---@private
hcache.free = function(handle, key)
    if (handle == nil) then
        return
    end
    if (hcache[handle] ~= nil) then
        if (key ~= nil) then
            hcache[handle][key] = nil
        else
            hcache[handle] = nil
        end
    end
end

---@private
hcache.set = function(handle, key, value)
    if (handle == nil) then
        print_stack()
        return
    end
    if (hcache[handle] ~= nil) then
        hcache[handle][key] = value
    end
end

---@private
hcache.get = function(handle, key, default)
    if (handle == nil) then
        print_stack()
        return
    end
    if (hcache[handle] == nil) then
        return default
    end
    return hcache[handle][key] or default
end