---@class hslk slk专用管理
hslk = {
    _yd = {},
    _yd_slk = {},
    _m = {}
}

--- 获取yd-slk数据（当hslk凉凉时会自动调用，不建议手动使用）
---@protected
---@param id string|number
---@return table|nil
hslk.yd = function(id)
    if (hslk._yd == nil) then
        hslk._yd = require "jass.slk"
    end
    if (hslk._yd_slk[id] == nil) then
        if (hslk._yd.item[id] ~= nil) then
            hslk._yd_slk[id] = hslk._yd.item[id]
            hslk._yd_slk[id]._class = "item"
        elseif (hslk._yd.unit[id] ~= nil) then
            hslk._yd_slk[id] = hslk._yd.unit[id]
            hslk._yd_slk[id]._class = "unit"
        elseif (hslk._yd.ability[id] ~= nil) then
            hslk._yd_slk[id] = hslk._yd.ability[id]
            hslk._yd_slk[id]._class = "ability"
        end
    end
    return hslk._yd_slk[id]
end

--- 获取slk数据（包含原生的slk和hslk）
--- 原生的slk数值键值是根据地图编辑器作为标准的，所以大小写也是与之一致
--- 原生的slk不会全部获取，只获取部分有用的key，具体可查看 CONST_SLK
---@param id string|number
---@return table|nil
hslk.get = function(id)
    if (type(id) == "number") then
        id = string.id2char(id)
    end
    if (hslk._m[id] == nil) then
        local yd = hslk.yd(id)
        if (yd == nil or yd._class == nil) then
            return
        end
        if (hslk_cli_data[id] == nil) then
            hslk._m[id] = {}
            hslk._m[id]._id = id
            hslk._m[id]._class = yd._class
            hslk._m[id]._type = "common"
            yd._class = nil
        else
            hslk._m[id] = hslk_cli_data[id]
        end
        hslk._m[id]._slk = yd or {}
    end
    return hslk._m[id]
end
