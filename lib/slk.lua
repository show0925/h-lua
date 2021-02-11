---@class slk 专用管理
hslk = { _data = {} }

--- 获取slk数据（包含原生的slk和hslk）
--- 原生的slk数值键值是根据地图编辑器作为标准的，所以大小写也是与之一致
---@param id string|number
---@return table|nil
hslk.get = function(id)
    if (type(id) == "number") then
        id = string.id2char(id)
    end
    if (hslk._data[id] == nil) then
        if (slk.item[id] ~= nil) then
            hslk._data[id] = slk.item[id]
        elseif (slk.unit[id] ~= nil) then
            hslk._data[id] = slk.unit[id]
        elseif (slk.ability[id] ~= nil) then
            hslk._data[id] = slk.ability[id]
        end
    end
    return hslk._data[id]
end
