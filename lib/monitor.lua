--- 监听器是一种工具，用于管理周期性操作
---@class hmonitor 监听器
hmonitor = { monitors = (Mapping.new()) }

---@return number
hmonitor.len = function()
    return hmonitor.monitors.length()
end

--- 创建一个监听器
---@alias monAction fun(object: any):void
---@alias monRemoveFilter fun(object: any):boolean
---@param key string 唯一key
---@param frequency number 周期间隔，每个周期会把受监听对象回调
---@param action monAction | "function(object) end" 监听操作
---@param removeFilter nil|monRemoveFilter | "function(object) end" 移除监听对象的适配条件
hmonitor.create = function(key, frequency, action, removeFilter)
    if (type(key) ~= "string" or type(frequency) ~= "number" or type(action) ~= "function") then
        return
    end
    if (removeFilter ~= nil and type(removeFilter) ~= "function") then
        return
    end
    if (hmonitor.monitors.get(key) ~= nil) then
        return
    end
    local obj = {}
    local timer = htime.setInterval(frequency, function(_)
        for oi, o in ipairs(obj) do
            if (removeFilter == nil or removeFilter(o) == true) then
                action(o)
            else
                table.remove(obj, oi)
                oi = oi - 1
            end
        end
    end)
    hmonitor.monitors.set(key, { object = obj, timer = timer })
end

--- 毁灭一个监听器
---@param key string 唯一key
hmonitor.destroy = function(key)
    local monitor = hmonitor.monitors.get(key)
    if (monitor ~= nil) then
        htime.delTimer(monitor.timer)
        monitor.object = nil
        monitor.timer = nil
        hmonitor.monitors.del(key)
    end
end

--- 检查一个对象是否正在受到监听
---@param key string 唯一key
---@param obj any 监听对象
---@return boolean
hmonitor.isMonitoring = function(key, obj)
    local monitor = hmonitor.monitors.get(key)
    if (monitor ~= nil) then
        return table.includes(monitor.object, obj)
    end
    return false
end

--- 往监听器添加受监听对象
---@param key string 唯一key
---@param obj any 监听对象
hmonitor.insert = function(key, obj)
    local monitor = hmonitor.monitors.get(key)
    if (monitor ~= nil) then
        if (table.includes(monitor.object, obj) == false) then
            table.insert(monitor.object, obj)
        end
    end
end

--- 往监听器剔除受监听对象
---@param key string 唯一key
---@param obj any 监听对象
hmonitor.remove = function(key, obj)
    local monitor = hmonitor.monitors.get(key)
    if (monitor ~= nil) then
        if (table.includes(monitor.object, obj) == false) then
            table.delete(monitor.object, obj)
        end
    end
end