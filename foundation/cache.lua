---@class cache
hcache = { _c_ = {} }

---@protected
---@return number
hcache.len = function()
    return table.len(hcache._c_)
end

---@param handle any
---@param key any
---@return boolean
hcache.exist = function(handle, key)
    if (handle == nil) then
        return true
    end
    if (hcache._c_[handle] == nil) then
        return true
    end
    if (key ~= nil and hcache._c_[handle][key] == nil) then
        return true
    end
    return false
end

---@param handle any
hcache.alloc = function(handle)
    if (handle == nil) then
        print_stack()
        return
    end
    if (hcache._c_[handle] == nil) then
        hcache._c_[handle] = {}
    end
end

---@param handle any
---@param key any
hcache.free = function(handle, key)
    if (handle == nil) then
        return
    end
    if (hcache._c_[handle] ~= nil) then
        if (key ~= nil) then
            hcache._c_[handle][key] = nil
        else
            hcache._c_[handle] = nil
        end
    end
end

---@param handle any
---@param key any
---@param value any|nil
hcache.set = function(handle, key, value)
    if (handle == nil) then
        print_stack()
        return
    end
    if (hcache._c_[handle] ~= nil) then
        hcache._c_[handle][key] = value
    end
end

---@param handle any
---@param key any
---@param default any|nil
hcache.get = function(handle, key, default)
    if (handle == nil) then
        print_stack()
        return
    end
    if (hcache._c_[handle] == nil) then
        return default
    end
    return hcache._c_[handle][key] or default
end