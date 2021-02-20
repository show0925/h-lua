---@class hslk slk专用管理
hslk = {}

--- 根据ID获取slk数据（包含原生的slk和hslk）
--- 原生的slk数值键值是根据地图编辑器作为标准的，所以大小写也是与之一致
--- 原生的slk不会全部获取，只获取部分有用的key，具体可查看 CONST_SLK
---@param id string|number
---@return table|nil
hslk.i2v = function(id)
    if (type(id) == "number") then
        id = string.id2char(id)
    end
    return HSLK_I2V[id]
end

--- 根据名称获取slk数据（包含原生的slk和hslk）
--- 原生的slk数值键值是根据地图编辑器作为标准的，所以大小写也是与之一致
--- 原生的slk不会全部获取，只获取部分有用的key，具体可查看 CONST_SLK
--- 如果名称冲突，则只能获取到最后设定的数据
---@param name string
---@return table|nil
hslk.n2v = function(name)
    if (type(name) ~= "string") then
        return
    end
    return HSLK_N2V[id]
end

--- 根据名称获取ID
--- 根据名称只对应一个ID，返回string
--- 根据名称只对应多个ID，返回table
---@param name string
---@return string|table|nil
hslk.n2i = function(name)
    if (type(name) ~= "string") then
        return
    end
    if (HSLK_N2I[name] == nil or type(HSLK_N2I[name]) ~= "table") then
        return
    end
    if (#HSLK_N2I[name] == 1) then
        return HSLK_N2I[name][1]
    end
    return HSLK_N2I[name]
end
