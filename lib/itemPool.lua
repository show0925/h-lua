-- 物品池
hitemPool = {}

--- 将物品添加到物品池
---@param poolName string
---@param whichItem userdata
hitemPool.insert = function(poolName, whichItem)
    if (poolName == nil or whichItem == nil) then
        return
    end
    poolName = '#' .. poolName
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
    poolName = '#' .. poolName
    if (hRuntime.itemPool[poolName] == nil) then
        return
    end
    if (table.includes(whichItem, hRuntime.itemPool[poolName])) then
        table.delete(hRuntime.itemPool[poolName], whichItem, 1)
    end
end