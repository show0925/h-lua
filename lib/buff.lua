--- buff系统
---buff是一种状态，可被创建和删除
---当buff被删除时，将会
hbuff = {
    UNIQUE_KEY = 0,
    DEFAULT_BUFF_KEY = '_h_lua',
    DEFAULT_GROUP_KEYS = {
        ATTR_PLUS = 'A+',
        ATTR_MINUS = 'A-',
        ATTR_EQUAL = 'A=',
        ENCHANT_PLUS = {
            attack_enchant = 'EA+',
            append_enchant = 'EP+',
        },
        ENCHANT_MINUS = {
            attack_enchant = 'EA-',
            append_enchant = 'EP-',
        },
    }
}

---@private
hbuff.uniqueKey = function()
    hbuff.uniqueKey = hbuff.uniqueKey + 1
    if (hbuff.uniqueKey >= 1000000) then
        hbuff.uniqueKey = 1
    end
    return hbuff.uniqueKey
end

--- 创建一个buff概念物
--- 成功创建时会返回一个key，用于删除buff
--- 失败会返回nil
---@param during number > 0
---@param handleUnit userdata
---@param groupKey string|'global' buff集合key，用于自主分类和搜索
---@param purpose function 目的期望的操作
---@param rollback function 回到原来状态的操作
---@return string|nil
hbuff.create = function(during, handleUnit, groupKey, purpose, rollback)
    if (handleUnit == nil or purpose == nil or rollback == nil) then
        return
    end
    during = during or 0
    if (during <= 0) then
        return
    end
    if (his.deleted(handleUnit)) then
        return
    end
    groupKey = groupKey or hbuff.DEFAULT_BUFF_KEY
    purpose()
    if (hRuntime.buff[handleUnit] == nil) then
        hRuntime.buff[handleUnit] = {}
    end
    if (hRuntime.buff[handleUnit][groupKey] == nil) then
        hRuntime.buff[handleUnit][groupKey] = {}
    end
    if (hRuntime.buff[handleUnit][groupKey].log == nil) then
        hRuntime.buff[handleUnit][groupKey].log = {}
    end
    local uk = hbuff.uniqueKey()
    hRuntime.buff[handleUnit][groupKey][uk] = rollback
    table.insert(hRuntime.buff[handleUnit][groupKey].log, uk)
    htime.setTimeout(during, function(curTimer)
        htime.delTimer(curTimer)
        if (false == his.deleted(handleUnit) and hRuntime.buff[handleUnit][groupKey][uk] ~= nil) then
            rollback()
            hRuntime.buff[handleUnit][groupKey][uk] = nil
            table.delete(uk, hRuntime.buff[handleUnit][groupKey].log)
        end
    end)
    return string.implode('|', { groupKey, hbuff.uniqueKey() })
end

--- 删除一个buff
--- buff被删除时会回到原来的状态
---@param handleUnit userdata
---@param buffKey string 由 groupKey|uniqueKey 组成,如果没有uniqueKey则清空所有groupKey下的buff
hbuff.delete = function(handleUnit, buffKey)
    if (handleUnit == nil or buffKey == nil) then
        return
    end
    if (his.deleted(handleUnit)) then
        return
    end
    local ebk = string.explode('|', buffKey)
    local groupKey = ebk[1] or nil
    local uk = ebk[2] or nil
    if (groupKey == nil) then
        return
    end
    if (hRuntime.buff[handleUnit] ~= nil) then
        if (hRuntime.buff[handleUnit].log ~= nil) then
            if (uk == nil) then
                -- 删除group下所有buff
                for _, _uk in ipairs(hRuntime.buff[handleUnit].log) do
                    if (hRuntime.buff[handleUnit][groupKey][_uk] ~= nil) then
                        hRuntime.buff[handleUnit][groupKey][_uk]() --rollback
                    end
                end
                hRuntime.buff[handleUnit][groupKey] = nil
            else
                -- 删除uk指向buff
                if (hRuntime.buff[handleUnit][groupKey][uk] ~= nil) then
                    hRuntime.buff[handleUnit][groupKey][uk]() --rollback
                    hRuntime.buff[handleUnit][groupKey][uk] = nil
                    table.delete(uk, hRuntime.buff[handleUnit][groupKey].log)
                end
            end
        end
    end
end