--- buff系统
---buff是一种状态，可被创建和删除
---当buff被删除时，将会
hbuff = {}

--- 创建一个buff概念物
--- 成功创建时会返回一个值，用于删除buff
--- 失败会返回nil
---@param handleUnit userdata
---@param handleKey string|'global'
---@param purpose function 目的期望的操作
---@param rollback function 回到原来状态的操作
---@return any|nil
hbuff.create = function(handleUnit, handleKey, purpose, rollback)
    handleKey = handleKey or 'global'
    if (handleUnit == nil or purpose == nil or rollback == nil) then
        return
    end
end

--- 删除一个buff
--- buff被删除时会回到原来的状态
hbuff.delete = function(handleUnit, handleKey, buffKey)

end