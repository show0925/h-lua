-- 物品池
hitemPool = {}

---@private
hitemPool.poolName = function(poolName)
    return '@' .. poolName
end

--- 将物品添加到物品池
---@param poolName string
---@param whichItem userdata
hitemPool.insert = function(poolName, whichItem)
    if (poolName == nil or whichItem == nil) then
        return
    end
    poolName = hitemPool.poolName(poolName)
    if (hRuntime.itemPool[poolName] == nil) then
        hRuntime.itemPool[poolName] = {}
    end
    if (false == table.includes(whichItem, hRuntime.itemPool[poolName])) then
        table.insert(hRuntime.itemPool[poolName], whichItem)
    end
end

--- 将物品从物品池删除
---@param poolName string
---@param whichItem userdata
hitemPool.delete = function(poolName, whichItem)
    if (poolName == nil or whichItem == nil) then
        return
    end
    poolName = hitemPool.poolName(poolName)
    if (hRuntime.itemPool[poolName] == nil) then
        return
    end
    if (table.includes(whichItem, hRuntime.itemPool[poolName])) then
        table.delete(hRuntime.itemPool[poolName], whichItem, 1)
    end
end

--- 遍历物品池
---@alias ItemPoolForEach fun(enumItem: userdata, idx: number):void
---@param poolName string
---@param action ItemPoolForEach | "function(enumItem, idx) end"
hitemPool.forEach = function(poolName, action)
    if (poolName == nil) then
        return
    end
    poolName = hitemPool.poolName(poolName)
    if (hRuntime.itemPool[poolName] == nil) then
        return
    end
    if (type(action) == "function") then
        for idx, it in ipairs(hRuntime.itemPool[poolName]) do
            action(it, idx)
        end
    end
end