-- 附魔
henchant = {
    -- 固有加成（10%）
    -- 附魔属性存在时的固有加成，如火攻击对无火抵抗的自带10%伤害
    INTRINSIC_ADDITION = 10, --(%)
    -- 是否开启着身附魔后果
    APPEND_OPEN = false,
}

--- 设置附魔的底层固有加成
henchant.setIntrinsicAddition = function(percent)
    henchant.INTRINSIC_ADDITION = math.round(percent)
end

--- 开启着身附魔
henchant.openAppend = function()
    henchant.APPEND_OPEN = true
end

--- 关闭着身附魔
henchant.closeAppend = function()
    henchant.APPEND_OPEN = false
end

--- 给目标单位添加附魔属性
---@param targetUnit userdata
---@param enchants table
---@param during number
henchant.append = function(targetUnit, enchants, during)
    if (henchant.APPEND_OPEN ~= true or targetUnit == nil) then
        return
    end
    if (type(enchants) ~= 'table' or during <= 0) then
        print_err("henchant append -enchants -during")
        return
    end
    hattribute.set(targetUnit, during, {
        append_enchant = "+" .. string.implode(',', enchants)
    })
end

--- 消除目标单位的附魔属性
---@param targetUnit userdata
---@param enchants table
---@param delay number 延时
henchant.dissipate = function(targetUnit, enchants, delay)
    if (henchant.APPEND_OPEN ~= true or targetUnit == nil) then
        return
    end
    if (type(enchants) ~= 'table') then
        print_err("henchant dissipate -enchants -during")
        return
    end
    delay = delay or 0
    if (delay <= 0) then
        hattribute.set(targetUnit, during, {
            append_enchant = "-" .. string.implode(',', enchants)
        })
    else
        htime.setTimeout(delay, function(curTimer)
            htime.delTimer(curTimer)
            hattribute.set(targetUnit, during, {
                append_enchant = "-" .. string.implode(',', enchants)
            })
        end)
    end
end

