--- buff系统
---buff是一种状态，可被创建和删除
---当buff被删除时，将会
hbuff = {
    DEFAULT_BUFF_KEY = '_h_lua',
}

--- 创建一个buff概念物
--- 成功创建时会返回一个值，用于删除buff
--- 失败会返回nil
---@param handleUnit userdata
---@param buffKey string|'global' buff集合key，用于自主分类和搜索
---@param purpose function 目的期望的操作
---@param rollback function 回到原来状态的操作
---@return any|nil
hbuff.create = function(handleUnit, buffKey, purpose, rollback)
    if (handleUnit == nil or purpose == nil or rollback == nil) then
        return
    end
    if (his.deleted(handleUnit)) then
        return
    end
    buffKey = buffKey or hbuff.DEFAULT_BUFF_KEY
end

--- 删除一个buff
--- buff被删除时会回到原来的状态
---@param handleUnit userdata
---@param buffKey string|'global' buff集合key，用于自主分类和搜索
hbuff.delete = function(handleUnit, buffKey)
    if (handleUnit == nil) then
        return
    end
    if (his.deleted(handleUnit)) then
        return
    end
    buffKey = buffKey or hbuff.DEFAULT_BUFF_KEY
    if (hRuntime.buff[handleUnit] ~= nil and hRuntime.buff[handleUnit][buffKey] ~= nil) then

    end
end