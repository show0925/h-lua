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
        if (table.includes(k, {
            "attack_speed",
            "resistance",
            "avoid",
            "aim",
            "hemophagia",
            "hemophagia_skill",
            "split",
            "luck",
            "invincible",
            "knocking_odds",
            "knocking_extent",
            "damage_extent",
            "damage_decrease",
            "damage_rebound",
            "cure",
            "gold_ratio",
            "lumber_ratio",
            "exp_ratio",
            "sell_ratio",
        }))
        then
            v = v .. "%"
        end
        local s = string.find(k, "oppose")
        local n = string.find(k, "natural")
        if (s ~= nil or n ~= nil) then
            v = v .. "%"
        end
        --
        if (k == "attack_damage_type") then
            local tempStr = (CONST_ATTR[k] or "") .. "："
            local opt = string.sub(v, 1, 1) or "+"
            if (type(v) == "string") then
                v = string.sub(v, 2)
                v = string.explode(",", v)
            end
            local av = {}
            for _, vv in ipairs(v) do
                table.insert(av, CONST_ATTR[vv] or "")
            end
            tempStr = tempStr .. opt .. string.implode(",", av)
            av = nil
            table.insert(str, tempStr)
        elseif (k == "xtras") then
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
                    local dur = vv["dur"] or 0
                    local val = vv["val"] or 0
                    local percent = vv["percent"] or 0
                    local qty = vv["qty"] or 0
                    local rate = vv["rate"] or 0
                    local radius = vv["radius"] or 0
                    local distance = vv["distance"] or 0
                    local height = vv["height"] or 0

                    --上色
                    target = hColor.greenLight(target)
                    actionFieldLabel = hColor.greenLight(actionFieldLabel)

                    if (odds > 0 and dur > 0 and percent ~= 0 and val ~= 0) then

                        -- 拼凑文本
                        local temp2 = "　- " .. CONST_EVENT_LABELS[on] .. '时,'
                        temp2 = temp2 .. "有"
                        temp2 = temp2 .. odds .. "%几率"
                        temp2 = temp2 .. "在" .. dur .. "秒内"

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
                                valLabel = math.round(percent * 0.01 * val)
                            elseif (unitLabel == "倍") then
                                valLabel = math.round(percent * val)
                            elseif (unitLabel == '') then
                                valLabel = '随机' .. math.round(percent[1] * 0.01 * val) .. '到' .. math.round(percent[2] * 0.01 * val)
                            end
                        elseif (type(val) == 'string') then
                            if (val == 'damage') then
                                valLabel = "[" .. percent .. unitLabel .. "当前伤害]"
                            else
                                local valAttr = string.explode('.', val)
                                if (#valAttr == 2) then
                                    local au = CONST_EVENT_TARGET_LABELS[on][valAttr[1]]
                                    local aa = valAttr[2]
                                    if (aa == 'level') then
                                        valLabel = "[" .. percent .. unitLabel .. au .. "的当前等级]"
                                    elseif (aa == 'gold') then
                                        valLabel = "[" .. percent .. unitLabel .. au .. "的当前黄金量]"
                                    elseif (aa == 'lumber') then
                                        valLabel = "[" .. percent .. unitLabel .. au .. "的当前木头量]"
                                    else
                                        valLabel = "[" .. percent .. unitLabel .. au .. '的' .. CONST_ATTR[aa] .. "]"
                                    end
                                end
                            end
                        end

                        -- 对象名称修正
                        if (target == '己') then
                            if (actionType == 'attr') then
                                target = '自己'
                            end
                        else
                            if (actionType == 'attr') then
                                target = '敌人'
                            end
                        end

                        if (valLabel ~= nil) then
                            valLabel = hColor.yellowLight(valLabel)
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
                                        .. "对" .. target .. "造成" .. valLabel .. "的" .. actionFieldLabel
                                elseif (vv["attr"] == "split") then
                                    temp2 = temp2
                                        .. actionFieldLabel .. "攻击" .. radius .. "范围的"
                                        .. target .. "方，造成" .. actionFieldLabel .. "的额外伤害"
                                elseif (vv["attr"] == "bomb") then
                                    temp2 = temp2
                                        .. actionFieldLabel .. radius .. "范围的" .. actionFieldLabel
                                    temp2 = temp2 .. "造成" .. actionFieldLabel .. "的额外伤害"
                                elseif (vv["attr"] == "swim" or vv["attr"] == "silent" or vv["attr"] == "unarm" or vv["attr"] == "fetter") then
                                    temp2 = temp2 .. actionFieldLabel .. "目标" .. dur .. "秒"
                                    if (val > 0) then
                                        temp2 = temp2 .. ",并造成" .. val .. "点伤害"
                                    end
                                elseif (vv["attr"] == "broken") then
                                    temp2 = temp2 .. actionFieldLabel .. "目标"
                                    if (val > 0) then
                                        temp2 = temp2 .. ",并造成" .. val .. "点伤害"
                                    end
                                elseif (vv["attr"] == "lightning_chain") then
                                    temp2 = temp2 .. "对最多" .. qty .. "个目标"
                                    temp2 = temp2 .. "发动" .. val .. "伤害的" .. actionFieldLabel
                                    if (reduce > 0) then
                                        temp2 = temp2 .. ",每次击中伤害渐强" .. reduce .. "%"
                                    elseif (reduce < 0) then
                                        temp2 = temp2 .. ",每次击中伤害衰减" .. reduce .. "%"
                                    end
                                elseif (vv["attr"] == "crack_fly") then
                                    temp2 = temp2 .. actionFieldLabel .. "目标高达" .. high .. "高度"
                                    if (val > 0) then
                                        temp2 = temp2 .. ",并击退" .. distance .. "距离"
                                    end
                                    if (val > 0) then
                                        temp2 = temp2 .. ",同时造成" .. val .. "伤害"
                                    end
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
