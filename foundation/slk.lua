---@class hslk slk专用管理
hslk = {
    _yd = {},
    _yd_slk = {},
    _yd_keys = {

    },
    _m = {}
}

--- 获取yd-slk数据（当hslk凉凉时会自动调用，不建议手动使用）
---@protected
---@param id string|number
---@return table
hslk.yd = function(id)
    if (hslk._yd == nil) then
        hslk._yd = require "jass.slk"
    end
    if (hslk._yd_slk[id] == nil) then
        if (hslk._yd.item[id] ~= nil) then
            hslk._yd_slk[id] = hslk._yd.item[id]
        elseif (hslk._yd.unit[id] ~= nil) then
            hslk._yd_slk[id] = hslk._yd.unit[id]
        elseif (hslk._yd.ability[id] ~= nil) then
            hslk._yd_slk[id] = hslk._yd.ability[id]
        else
            hslk._yd_slk[id] = {}
        end
    end
    return hslk._yd_slk[id]
end

--- 获取slk数据（包含原生的slk和hslk）
--- 原生的slk数值键值是根据地图编辑器作为标准的，所以大小写也是与之一致
---@param id string|number
---@return table|nil
hslk.get = function(id)
    if (type(id) == "number") then
        id = string.id2char(id)
    end
    if (hslk._m[id] == nil) then
        if (slk.item[id] ~= nil) then
            hslk._m[id] = slk.item[id]
        elseif (slk.unit[id] ~= nil) then
            hslk._m[id] = slk.unit[id]
        elseif (slk.ability[id] ~= nil) then
            hslk._m[id] = slk.ability[id]
        end
    end
    return hslk._m[id]
end
