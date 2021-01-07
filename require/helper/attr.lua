--- 属性系统目标文本修正
slkHelper.attrTargetLabel = function(target, actionType, actionField)
    if (actionType == 'spec' and table.includes(actionField, { 'split', 'bomb', 'lightning_chain' })) then
        if (target == '己') then
            target = '友军'
        else
            target = '敌军'
        end
    else
        if (target == '己') then
            target = '自己'
        else
            target = '敌人'
        end
    end
    return target
end

--- 键值是否百分比数据
---@private
slkHelper.attrIsPercent = function(key)
    if (table.includes(key, {
        "attack_speed", "avoid", "aim",
        "hemophagia", "hemophagia_skill",
        "invincible",
        "knocking_odds", "knocking_extent",
        "damage_extent", "damage_decrease", "damage_rebound",
        "cure",
        "gold_ratio", "lumber_ratio", "exp_ratio", "sell_ratio",
        "knocking", "split",
    }))
    then
        return true
    end
    local s = string.find(key, "_oppose")
    local n = string.find(key, "e_")
    if (s ~= nil or n == 1) then
        return true
    end
    return false
end

--- 键值是否层级数据
---@private
slkHelper.attrIsLevel = function(key)
    local a = string.find(key, "_attack")
    local p = string.find(key, "_append")
    local n = string.find(key, "e_")
    if ((a ~= nil or p ~= nil) and n == 1) then
        return true
    end
    return false
end

--- 属性系统说明构成
---@private
slkHelper.attrDesc = function(attr, sep, indent)
    indent = indent or ""
    local str = {}
    local strTable = {}
    sep = sep or "|n"
    for _, arr in ipairs(table.obj2arr(attr, CONST_ATTR_KEYS)) do
        local k = arr.key
        local v = arr.value
        -- 附加单位
        if (k == "attack_speed_space") then
            v = v .. "击每秒"
        end
        if (table.includes(k, { "life_back", "mana_back" })) then
            v = v .. "每秒"
        end
        if (slkHelper.attrIsPercent(k) == true) then
            v = v .. "%"
        end
        if (slkHelper.attrIsLevel(k) == true) then
            v = v .. "层"
        end
        --
        if (k == "xtras") then
            table.insert(strTable, (CONST_ATTR[k] or "") .. "：")
            local tempStr = {}
            for _, vv in ipairs(v) do
                local on = vv["on"]
                local actions = string.explode('.', vv["action"] or '')
                if (CONST_EVENT_LABELS[on] ~= nil and table.len(actions) == 3) then
                    local target = CONST_EVENT_TARGET_LABELS[on][actions[1]]
                    local actionType = actions[2]
                    local actionField = actions[3]
                    local actionFieldLabel = CONST_ATTR[actionField]
                    local odds = vv["odds"] or 0
                    local during = vv["during"] or 0
                    local val = vv["val"] or 0
                    local percent = vv["percent"] or 100
                    local qty = vv["qty"] or 0
                    local rate = vv["rate"] or 0
                    local radius = vv["radius"] or 0
                    local distance = vv["distance"] or 0
                    local height = vv["height"] or 0
                    --
                    if (odds > 0 and percent ~= nil and val ~= nil) then
                        -- 拼凑文本
                        local temp2 = "　- " .. CONST_EVENT_LABELS[on] .. '时,'
                        temp2 = temp2 .. "有"
                        temp2 = temp2 .. odds .. "%几率"
                        if (during > 0) then
                            temp2 = temp2 .. "在" .. during .. "秒内"
                        end

                        -- 拼凑值
                        local valLabel
                        local unitLabel = "%"
                        if (type(percent) == 'table') then
                            unitLabel = ''
                        elseif (percent % 100 == 0) then
                            unitLabel = "倍"
                            percent = math.floor(percent / 100)
                        end
                        if (type(val) == 'number') then
                            if (unitLabel == "%") then
                                valLabel = math.round(percent * 0.01 * math.abs(val))
                            elseif (unitLabel == "倍") then
                                valLabel = math.round(percent * math.abs(val))
                            elseif (unitLabel == '') then
                                valLabel = '随机' .. math.round(percent[1] * math.abs(val)) .. '~' .. math.round(percent[2] * 0.01 * math.abs(val))
                            end
                        elseif (type(val) == 'string') then
                            if (unitLabel == '') then
                                percent = '随机' .. percent[1] .. '%~' .. percent[2] .. '%'
                            end
                            if (val == 'damage') then
                                valLabel = percent .. unitLabel .. "当前伤害"
                            else
                                local valAttr = string.explode('.', val)
                                if (table.len(valAttr) == 2
                                    and CONST_EVENT_TARGET_LABELS[on]
                                    and CONST_EVENT_TARGET_LABELS[on][valAttr[1]]
                                ) then
                                    local au = CONST_EVENT_TARGET_LABELS[on][valAttr[1]]
                                    au = slkHelper.attrTargetLabel(au, actionType, actionField)
                                    local aa = valAttr[2]
                                    if (aa == 'level') then
                                        valLabel = percent .. unitLabel .. au .. "当前等级"
                                    elseif (aa == 'gold') then
                                        valLabel = percent .. unitLabel .. au .. "当前黄金量"
                                    elseif (aa == 'lumber') then
                                        valLabel = percent .. unitLabel .. au .. "当前木头量"
                                    else
                                        valLabel = percent .. unitLabel .. au .. (CONST_ATTR[aa] or '不明属性') .. ""
                                    end
                                end
                            end
                        end
                        -- 补正百分号
                        if (type(val) == 'number' and slkHelper.attrIsPercent(actionField) == true) then
                            valLabel = valLabel .. "%"
                        end
                        -- 对象名称修正
                        target = slkHelper.attrTargetLabel(target, actionType, actionField)
                        if (valLabel ~= nil) then
                            if (actionType == 'attr') then
                                if (val > 0) then
                                    temp2 = temp2 .. "提升" .. target
                                elseif (val < 0) then
                                    temp2 = temp2 .. "减少" .. target
                                end
                                temp2 = temp2 .. valLabel .. "的" .. actionFieldLabel
                            elseif (actionType == 'spec') then
                                if (actionField == "knocking") then
                                    temp2 = temp2
                                        .. "对" .. target .. "造成" .. valLabel .. "的" .. actionFieldLabel .. "伤害"
                                elseif (actionField == "split") then
                                    temp2 = temp2
                                        .. actionFieldLabel .. "攻击" .. radius .. "范围的"
                                        .. target .. ",造成" .. valLabel .. "伤害"
                                elseif (actionField == "bomb") then
                                    temp2 = temp2
                                        .. actionFieldLabel .. radius .. "范围的" .. target
                                        .. ",造成" .. valLabel .. "伤害"
                                elseif (table.includes(actionField, { "swim", "silent", "unarm", "fetter" })) then
                                    temp2 = temp2
                                        .. actionFieldLabel .. "目标" .. during .. "秒"
                                        .. ",并造成" .. valLabel .. "点伤害"
                                elseif (actionField == "broken") then
                                    temp2 = temp2
                                        .. actionFieldLabel .. "目标" .. ",并造成" .. valLabel .. "点伤害"
                                elseif (actionField == "lightning_chain") then
                                    temp2 = temp2
                                        .. "对最多" .. qty .. "个目标"
                                        .. "发动" .. valLabel .. "伤害的" .. actionFieldLabel
                                    if (rate > 0) then
                                        temp2 = temp2 .. ",每次跳跃渐强" .. rate .. "%"
                                    elseif (rate < 0) then
                                        temp2 = temp2 .. ",每次跳跃衰减" .. rate .. "%"
                                    end
                                elseif (actionField == "crack_fly") then
                                    temp2 = temp2
                                        .. actionFieldLabel .. "目标达" .. height .. "高度并击退" .. distance .. "距离"
                                        .. ",同时造成" .. valLabel .. "伤害"
                                end
                            end
                            table.insert(tempStr, indent .. temp2)
                        end
                    end
                end
            end
            table.insert(strTable, string.implode(sep, tempStr))
        else
            table.insert(str, indent .. (CONST_ATTR[k] or "") .. "：" .. v)
        end
    end
    return string.implode(sep, table.merge(str, strTable))
end
