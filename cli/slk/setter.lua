--- F6 物编
local F6_IDX = 0
local F6_NAME = function(name)
    F6_IDX = F6_IDX + 1
    return (name or "HL-NAME") .. "-" .. F6_IDX
end

local F6V_I_SYNTHESIS_TMP = {
    profit = {},
    fragment = {},
}

local F6S = {}
F6S.txt = function(v, key, txt, sep)
    sep = sep or "|n"
    if (v[key] == nil) then
        v[key] = txt
    else
        v[key] = v[key] .. sep .. txt
    end
end
F6S.a = {
    --- 属性系统目标文本修正
    targetLabel = function(target, actionType, actionField, isValue)
        if (actionType == 'spec' and isValue ~= true and table.includes({ 'split', 'bomb', 'lightning_chain' }, actionField)) then
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
    end,
    --- 键值是否百分比数据
    isPercent = function(key)
        if (table.includes({
            "attack_speed", "avoid", "aim",
            "hemophagia", "hemophagia_skill",
            "invincible",
            "knocking_odds", "knocking_extent",
            "damage_extent", "damage_decrease", "damage_rebound",
            "cure",
            "gold_ratio", "lumber_ratio", "exp_ratio", "sell_ratio",
            "knocking", "split",
        }, key))
        then
            return true
        end
        local s = string.find(key, "_oppose")
        local n = string.find(key, "e_")
        local a = string.find(key, "_attack")
        local p = string.find(key, "_append")
        if (a ~= nil or p ~= nil) then
            return false
        end
        if (s ~= nil or n == 1) then
            return true
        end
        return false
    end,
    --- 键值是否层级数据
    isLevel = function(key)
        local a = string.find(key, "_attack")
        local p = string.find(key, "_append")
        local n = string.find(key, "e_")
        if ((a ~= nil or p ~= nil) and n == 1) then
            return true
        end
        return false
    end,
    --- _attr文本构建
    attr = function(attr, sep, indent)
        indent = indent or ""
        local str = {}
        local strTable = {}
        sep = sep or "|n"
        for _, arr in ipairs(table.obj2arr(attr, CONST_ATTR_KEYS)) do
            local k = arr.key
            local v = arr.value
            -- 附加单位
            if (k == "attack_space") then
                v = v .. "秒"
            end
            if (table.includes({ "life_back", "mana_back" }, k)) then
                v = v .. "每秒"
            end
            if (F6S.a.isPercent(k) == true) then
                v = v .. "%"
            end
            if (F6S.a.isLevel(k) == true) then
                v = v .. "层"
            end
            --
            if (k == "xtras") then
                table.insert(strTable, (CONST_ATTR[k] or "") .. "：")
                local tempStr = {}
                for vvi, vv in ipairs(v) do
                    local on = vv["on"]
                    local actions = string.explode('.', vv["action"] or '')
                    if (CONST_EVENT_LABELS[on] ~= nil and #actions == 3) then
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
                            local temp2 = '　' .. vvi .. '.' .. CONST_EVENT_LABELS[on] .. '时,'
                            temp2 = temp2 .. "有"
                            temp2 = temp2 .. odds .. "%几率"
                            if (during > 0) then
                                temp2 = temp2 .. "在" .. during .. "秒内"
                            end

                            -- 拼凑值
                            local valLabel
                            local unitLabel = "%"
                            local isNegative = false
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
                                isNegative = val < 0
                            elseif (type(val) == 'string') then
                                if (unitLabel == '') then
                                    percent = '随机' .. percent[1] .. '%~' .. percent[2] .. '%'
                                end
                                isNegative = (string.sub(val, 1, 1) == '-')
                                if (isNegative) then
                                    val = string.sub(val, 2)
                                end
                                if (val == 'damage') then
                                    valLabel = percent .. unitLabel .. "当前伤害"
                                else
                                    local valAttr = string.explode('.', val)
                                    if (#valAttr == 2 and CONST_EVENT_TARGET_LABELS[on] and CONST_EVENT_TARGET_LABELS[on][valAttr[1]]) then
                                        local au = CONST_EVENT_TARGET_LABELS[on][valAttr[1]]
                                        au = F6S.a.targetLabel(au, actionType, actionField, true)
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
                            if (type(val) == 'number' and F6S.a.isPercent(actionField) == true) then
                                valLabel = valLabel .. "%"
                            end
                            -- 对象名称修正
                            target = F6S.a.targetLabel(target, actionType, actionField)
                            if (valLabel ~= nil) then
                                if (actionType == 'attr') then
                                    if (isNegative) then
                                        temp2 = temp2 .. "减少" .. target
                                    else
                                        temp2 = temp2 .. "提升" .. target
                                    end
                                    temp2 = temp2 .. valLabel .. "的" .. actionFieldLabel
                                elseif (actionType == 'spec') then
                                    actionFieldLabel = vv["alias"] or actionFieldLabel
                                    if (actionField == "knocking") then
                                        temp2 = temp2
                                            .. "对" .. target .. "造成" .. valLabel .. "的" .. actionFieldLabel .. "的伤害"
                                    elseif (actionField == "split") then
                                        temp2 = temp2
                                            .. actionFieldLabel .. "攻击" .. radius .. "范围的"
                                            .. target .. ",造成" .. valLabel .. "的伤害"
                                    elseif (actionField == "bomb") then
                                        temp2 = temp2
                                            .. actionFieldLabel .. radius .. "范围的" .. target
                                            .. ",造成" .. valLabel .. "的伤害"
                                    elseif (table.includes({ "swim", "silent", "unarm", "fetter" }, actionField)) then
                                        temp2 = temp2
                                            .. actionFieldLabel .. "目标" .. during .. "秒"
                                            .. ",并造成" .. valLabel .. "点伤害"
                                    elseif (actionField == "broken") then
                                        temp2 = temp2
                                            .. actionFieldLabel .. "目标" .. ",并造成" .. valLabel .. "点伤害"
                                    elseif (actionField == "lightning_chain") then
                                        temp2 = temp2
                                            .. "对最多" .. qty .. "个目标"
                                            .. "发动" .. valLabel .. "的伤害的" .. actionFieldLabel
                                        if (rate > 0) then
                                            temp2 = temp2 .. ",每次跳跃渐强" .. rate .. "%"
                                        elseif (rate < 0) then
                                            temp2 = temp2 .. ",每次跳跃衰减" .. rate .. "%"
                                        end
                                    elseif (actionField == "crack_fly") then
                                        temp2 = temp2
                                            .. actionFieldLabel .. "目标达" .. height .. "高度并击退" .. distance .. "距离"
                                            .. ",同时造成" .. valLabel .. "的伤害"
                                    elseif (actionField == "paw") then
                                        temp2 = temp2
                                            .. "向前方击出" .. qty .. "道" .. actionFieldLabel
                                            .. ",对直线" .. radius .. "范围的" .. target .. "造成" .. valLabel .. "的伤害"
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
    end,
    ubertip = {
        attr = function(v)
            if (v._attr ~= nil) then
                F6S.txt(v, "Ubertip", hcolor.mixed(F6S.a.attr(v._attr, "|n"), SLK_CONF.color.abilityAttr))
            end
        end,
        ring = function(v)
            local d = {}
            if (v._ring.radius ~= nil) then
                table.insert(d, hcolor.mixed("光环范围：" .. v._ring.radius, SLK_CONF.color.ringArea))
            end
            if (type(v._ring.target) == 'table' and #v._ring.target > 0) then
                local labels = {}
                for _, t in ipairs(v._ring.target) do
                    table.insert(labels, CONST_TARGET_LABEL[t])
                end
                table.insert(d, hcolor.mixed("光环目标：" .. string.implode(',', labels), SLK_CONF.color.ringTarget))
                labels = nil
            end
            if (v._ring.attr ~= nil) then
                table.insert(d, hcolor.mixed("光环效果：|n" .. F6S.a.attr(v._ring.attr, "|n", ' - '), SLK_CONF.color.ringTarget))
            end
            if (v._attr ~= nil) then
                table.insert(d, hcolor.mixed("独占效果：", SLK_CONF.color.abilityAttr))
                table.insert(d, hcolor.mixed(F6S.a.attr(v._attr, "|n", ' - '), SLK_CONF.color.abilityAttr))
                table.insert(d, "|n")
            end
            if (v._desc ~= nil and v._desc ~= "") then
                table.insert(d, hcolor.mixed(v._desc, SLK_CONF.color.ringDesc))
            end
            return string.implode("|n", d)
        end
    },
}
F6S.i = {
    description = {
        _active = function(v)
            if (v._active ~= nil) then
                F6S.txt(v, "Description", "主动：" .. v._active, ';')
            end
        end,
        _passive = function(v)
            if (v._passive ~= nil) then
                F6S.txt(v, "Description", "被动：" .. v._passive, ';')
            end
        end,
        _attr = function(v)
            if (v._attr ~= nil) then
                F6S.txt(v, "Description", F6S.a.attr(v._attr, ","), ';')
            end
        end,
        _attr_txt = function(v)
            if (v._attr_txt ~= nil) then
                F6S.txt(v, "Description", F6S.a.attr(v._attr_txt, ","), ';')
            end
        end,
        _overlie = function(v)
            if (v._overlie ~= nil and v._overlie > 0) then
                local o = tostring(math.floor(v._overlie))
                F6S.txt(v, "Description", "叠加：" .. o, ';')
            end
        end,
        _weight = function(v)
            if (v._weight ~= nil) then
                local w = tostring(math.round(v._weight))
                F6S.txt(v, "Description", "重量：" .. w .. "Kg", ';')
            end
        end,
        _remarks = function(v)
            if (v._remarks ~= nil and v._remarks ~= "") then
                F6S.txt(v, "Description", v._remarks, ';')
            end
        end,
    },
    ubertip = {
        _active = function(v)
            if (v._active ~= nil) then
                F6S.txt(v, "Ubertip", hcolor.mixed("主动：" .. v._active, SLK_CONF.color.itemActive))
                if (v._cooldown ~= nil and v._cooldown > 0) then
                    F6S.txt(v, "Ubertip", hcolor.mixed("冷却：" .. v._cooldown .. "秒", SLK_CONF.color.itemCoolDown))
                end
            end
        end,
        _passive = function(v)
            if (v._passive ~= nil) then
                F6S.txt(v, "Ubertip", hcolor.mixed("被动：" .. v._passive, SLK_CONF.color.itemPassive))
            end
        end,
        _ring = function(v)
            if (v._ring ~= nil) then
                if (v._ring.attr ~= nil and v._ring.radius ~= nil and (type(v._ring.target) == 'table' and #v._ring.target > 0)) then
                    local txt = "光环：[" .. v._ring.radius .. "px|n"
                    F6S.txt(v, "Ubertip", hcolor.mixed(txt .. F6S.a.attr(v._ring.attr, "|n", ' - '), SLK_CONF.color.ringTarget))
                end
            end
        end,
        _attr = function(v)
            if (v._attr ~= nil) then
                F6S.txt(v, "Ubertip", hcolor.mixed(F6S.a.attr(v._attr, "|n"), SLK_CONF.color.itemAttr))
            end
        end,
        _attr_txt = function(v)
            if (v._attr_txt ~= nil) then
                F6S.txt(v, "Ubertip", hcolor.mixed(F6S.a.attr(v._attr_txt, "|n"), SLK_CONF.color.itemAttr))
            end
        end,
        _fragment = function(v)
            if (F6V_I_SYNTHESIS_TMP.fragment[v.Name] ~= nil and #F6V_I_SYNTHESIS_TMP.fragment[v.Name] > 0) then
                local txt = "可以合成：" .. string.implode('、', F6V_I_SYNTHESIS_TMP.fragment[v.Name])
                F6S.txt(v, "Ubertip", hcolor.mixed(txt, SLK_CONF.color.itemFragment))
            end
        end,
        _profit = function(v)
            if (F6V_I_SYNTHESIS_TMP.profit[v.Name] ~= nil) then
                local txt = "需要零件：" .. F6V_I_SYNTHESIS_TMP.profit[v.Name]
                F6S.txt(v, "Ubertip", hcolor.mixed(txt, SLK_CONF.color.itemProfit))
            end
        end,
        _overlie = function(v)
            if (v._overlie ~= nil and v._overlie > 0) then
                local o = tostring(math.floor(v._overlie))
                F6S.txt(v, "Ubertip", hcolor.mixed("叠加：" .. o, SLK_CONF.color.itemOverlie))
            end
        end,
        _weight = function(v)
            if (v._weight ~= nil) then
                local w = tostring(math.round(v._weight))
                F6S.txt(v, "Ubertip", hcolor.mixed("重量：" .. w .. "Kg", SLK_CONF.color.itemWeight))
            end
        end,
        _remarks = function(v)
            if (v._remarks ~= nil and v._remarks ~= "") then
                F6S.txt(v, "Ubertip", hcolor.mixed(v._remarks, SLK_CONF.color.itemRemarks))
            end
        end,
    },
}
F6S.u = {}

------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------

------@private
F6V_I_SYNTHESIS = function(formula)
    local formulas = {}
    for _, v in ipairs(formula) do
        local profit = ''
        local fragment = {}
        if (type(v) == 'string') then
            local f1 = string.explode('=', v)
            if (string.strpos(f1[1], 'x') == false) then
                profit = { f1[1], 1 }
            else
                local temp = string.explode('x', f1[1])
                temp[2] = math.floor(temp[2])
                profit = temp
            end
            local f2 = string.explode('+', f1[2])
            for _, vv in ipairs(f2) do
                if (string.strpos(vv, 'x') == false) then
                    table.insert(fragment, { vv, 1 })
                else
                    local temp = string.explode('x', vv)
                    temp[2] = math.floor(temp[2])
                    table.insert(fragment, temp)
                end
            end
        elseif (type(v) == 'table') then
            profit = v[1]
            for vi = 2, table.len(v), 1 do
                table.insert(fragment, v[vi])
            end
        end
        --
        local fmStr = {}
        for _, fm in ipairs(fragment) do
            if (fm[2] <= 1) then
                table.insert(fmStr, fm[1])
            else
                table.insert(fmStr, fm[1] .. 'x' .. fm[2])
            end
            if (F6V_I_SYNTHESIS_TMP.fragment[fm[1]] == nil) then
                F6V_I_SYNTHESIS_TMP.fragment[fm[1]] = {}
            end
            if (table.includes(F6V_I_SYNTHESIS_TMP.fragment[fm[1]], profit[1]) == false) then
                table.insert(F6V_I_SYNTHESIS_TMP.fragment[fm[1]], profit[1])
            end
        end
        F6V_I_SYNTHESIS_TMP.profit[profit[1]] = string.implode('+', fmStr)
        --
        table.insert(formulas, { _profit = profit, _fragment = fragment })
    end
    return formulas
end

F6V_A = function(_v)
    _v._class = "ability"
    _v._type = "common"
    if (_v._parent == nil) then
        _v._parent = "ANcl"
    end
    if (_v.Name == nil) then
        _v.Name = F6_NAME("未命名技能")
    end
    if (_v.Hotkey ~= nil) then
        _v.Buttonpos1 = CONST_HOTKEY_ABILITY_KV[_v.Hotkey].Buttonpos1 or 0
        _v.Buttonpos2 = CONST_HOTKEY_ABILITY_KV[_v.Hotkey].Buttonpos2 or 0
        _v.Tip = _v.Tip or (_v.Name .. "[" .. hcolor.mixed(_v.Hotkey, SLK_CONF.color.hotKey) .. "]")
        _v.Name = _v.Name .. _v.Hotkey
    else
        _v.Tip = _v.Tip or (_v.Name)
    end
    F6S.a.ubertip.attr(_v)
    return _v
end

F6V_A_E = function(_v)
    _v._parent = "Aamk"
    _v._type = "empty"
    if (_v.Name == nil) then
        _v.Name = F6_NAME("未命名空被动")
    end
    return F6V_A(_v)
end

F6V_A_R = function(_v)
    _v._parent = "Aamk"
    _v._type = "ring"
    if (_v.Name == nil) then
        _v.Name = F6_NAME("未命名空光环")
    end
    if (_v._ring ~= nil) then
        _v._ring.effect = _v._ring.effect or nil
        _v._ring.effectTarget = _v._ring.effectTarget or "Abilities\\Spells\\Other\\GeneralAuraTarget\\GeneralAuraTarget.mdl"
        _v._ring.attach = _v._ring.attach or "origin"
        _v._ring.attachTarget = _v._ring.attachTarget or "origin"
        _v._ring.radius = _v._ring.radius or 600
        -- target请参考物编的目标允许
        local target
        if (type(_v._ring.target) == 'table' and #_v._ring.target > 0) then
            target = _v._ring.target
        elseif (type(_v._ring.target) == 'string' and string.len(_v._ring.target) > 0) then
            target = string.explode(',', _v._ring.target)
        else
            target = { 'air', 'ground', 'friend', 'self', 'vuln', 'invu' }
        end
        _v._ring.target = target
    end
    return F6V_A(_v)
end

F6V_U = function(_v)
    _v._class = "unit"
    _v._type = "common"
    if (_v._parent == nil) then
        _v._parent = "hpea"
    end
    if (_v.Name == nil) then
        _v.Name = F6_NAME("未命名单位")
    end
    return _v
end

F6V_I_CD = function(_v)
    if (_v._cooldown == nil) then
        return "AIat"
    end
    if (_v._cooldown < 0) then
        _v._cooldown = 0
    end
    if (_v._cooldown == 0) then
        return H_LUA_ABILITY_CD0
    end
    local adTips = "H_LUA_ICD_" .. _v.Name
    local cdID
    local ad = {
        Effectsound = "",
        Name = adTips,
        Tip = adTips,
        Ubertip = adTips,
        TargetArt = _v.TargetArt or "",
        Targetattach = _v.Targetattach or "",
        Animnames = _v.Animnames or "spell",
        CasterArt = _v.CasterArt or "",
        Art = "",
        item = 1,
        Requires = "",
        Hotkey = "",
        Buttonpos1 = 0,
        Buttonpos2 = 0,
        race = "other",
        Cast = { _v._cast or 0 },
        Cost = { _v._cost or 0 },
        Cool = { _v._cooldown },
    }
    if (_v._cooldownTarget == CONST_ABILITY_TARGET.location.value) then
        -- 对点（模版：照明弹）
        ad._parent = "Afla"
        ad.DataA = { 0 }
        ad.EfctID = { "" }
        ad.Dur = { 0.01 }
        ad.HeroDur = { 0.01 }
        ad.Rng = _v.Rng or { 600 }
        ad.Area = { 0 }
        ad.DataA = { 0 }
        ad.DataB = { 0 }
        local av = hslk_ability(ad)
        cdID = av._id
    elseif (_v.cooldownTarget == CONST_ABILITY_TARGET.range.value) then
        -- 对点范围（模版：暴风雪）
        ad._parent = "ACbz"
        ad.BuffID = { "" }
        ad.EfctID = { "" }
        ad.Rng = _v.Rng or { 300 }
        ad.Area = _v.Area or { 300 }
        ad.DataA = { 0 }
        ad.DataB = { 0 }
        ad.DataC = { 0 }
        ad.DataD = { 0 }
        ad.DataE = { 0 }
        ad.DataF = { 0 }
        local av = hslk_ability(ad)
        cdID = av._id
    elseif (_v._cooldownTarget == CONST_ABILITY_TARGET.unit.value) then
        -- 对单位（模版：霹雳闪电）
        ad._parent = "ACfb"
        ad.Missileart = _v.Missileart or "Abilities\\Weapons\\FireBallMissile\\FireBallMissile.mdl"
        ad.Missilespeed = _v.Missilespeed or 1000
        ad.Missilearc = _v.Missilearc or 0
        ad.targs = _v.targs or { "air,ground,organic,enemy,neutral" }
        ad.Rng = _v.Rng or { 800 }
        ad.Area = _v.Area or { 0 }
        ad.DataA = { 0 }
        ad.Dur = { 0.01 }
        ad.HeroDur = { 0.01 }
        local av = hslk_ability(ad)
        cdID = av._id
    else
        -- 立刻（模版：金箱子）
        ad._parent = "AIgo"
        ad.DataA = { 0 }
        local av = hslk_ability(ad)
        cdID = av._id
    end
    return cdID
end

F6V_I_SHADOW = function(_v)
    _v._parent = "gold"
    _v._class = "item"
    _v._type = "shadow"
    _v.Name = "　" .. _v.Name .. "　"
    _v.class = "Charged"
    _v.abilList = ""
    _v.ignoreCD = 1
    _v.perishable = 1
    _v.usable = 1
    _v.powerup = 1
    return _v
end

F6V_I = function(_v)
    _v._class = "item"
    _v._type = "common"
    local cd = F6V_I_CD(_v)
    if (cd ~= "AIat") then
        _v.abilList = cd
        _v.usable = 1
        if (_v.perishable == nil) then
            _v.perishable = 1
        end
        if (_v.powerup == nil) then
            _v.powerup = 0
        end
        if (_v.powerup == 0) then
            _v.class = "Charged"
        else
            _v.class = "PowerUp"
        end
        if (cd == H_LUA_ABILITY_CD0) then
            _v.ignoreCD = 1
        end
    else
        if (_v.perishable == nil) then
            _v.perishable = 0
        end
        _v.class = "Permanent"
    end
    if (_v._parent == nil) then
        if (_v.class == "Charged") then
            _v._parent = "hlst"
        elseif (_v.class == "PowerUp") then
            _v._parent = "gold"
        else
            _v._parent = "rat9"
        end
    end
    if (_v.Name == nil) then
        _v.Name = F6_NAME("未命名物品")
    end
    -- 处理 _shadow
    if (type(_v._shadow) ~= 'boolean') then
        _v._shadow = (SLK_CONF.autoShadow == true and _v.powerup == 0)
    end
    -- 处理 _ring光环
    if (_v._ring ~= nil) then
        _v._ring.effectTarget = _v._ring.effectTarget or "Abilities\\Spells\\Other\\GeneralAuraTarget\\GeneralAuraTarget.mdl"
        _v._ring.attach = _v._ring.attach or "origin"
        _v._ring.attachTarget = _v._ring.attachTarget or "origin"
        _v._ring.radius = _v._ring.radius or 600
        -- target请参考物编的目标允许
        local target
        if (type(_v._ring.target) == 'table' and #_v._ring.target > 0) then
            target = _v._ring.target
        elseif (type(_v._ring.target) == 'string' and string.len(_v._ring.target) > 0) then
            target = string.explode(',', _v._ring.target)
        else
            target = { 'air', 'ground', 'friend', 'self', 'vuln', 'invu' }
        end
        _v._ring.target = target
    end
    F6S.i.description._active(_v)
    F6S.i.description._passive(_v)
    F6S.i.description._attr(_v)
    F6S.i.description._attr_txt(_v)
    F6S.i.description._overlie(_v)
    F6S.i.description._weight(_v)
    F6S.i.description._remarks(_v)
    F6S.i.ubertip._active(_v)
    F6S.i.ubertip._passive(_v)
    F6S.i.ubertip._ring(_v)
    F6S.i.ubertip._attr(_v)
    F6S.i.ubertip._attr_txt(_v)
    F6S.i.ubertip._fragment(_v)
    F6S.i.ubertip._profit(_v)
    F6S.i.ubertip._overlie(_v)
    F6S.i.ubertip._weight(_v)
    F6S.i.ubertip._remarks(_v)
    if (_v.uses == nil) then
        _v.uses = 1
    end
    if (_v._overlie == nil or _v._overlie < _v.uses) then
        _v._overlie = _v.uses
    end
    if (_v.goldcost == nil) then
        _v.goldcost = 1000000
    end
    if (_v.lumbercost == nil) then
        _v.lumbercost = 0
    end
    if (_v.Level == nil) then
        _v.Level = math.floor((_v.goldcost + _v.lumbercost) / 500)
    end
    if (_v.oldLevel == nil) then
        _v.oldLevel = _v.Level
    end
    if (_v.Hotkey ~= nil) then
        _v.Buttonpos_1 = CONST_HOTKEY_FULL_KV[_v.Hotkey].Buttonpos1 or 0
        _v.Buttonpos_2 = CONST_HOTKEY_FULL_KV[_v.Hotkey].Buttonpos2 or 0
        _v.Tip = "获得" .. _v.Name .. "(" .. hcolor.mixed(_v.Hotkey, SLK_CONF.color.hotKey) .. ")"
    else
        _v.Buttonpos_1 = _v.Buttonpos_1 or 0
        _v.Buttonpos_2 = _v.Buttonpos_2 or 0
        _v.Tip = "获得" .. _v.Name
    end
    return _v
end

F6V_UP = function(_v)
    _v._class = "upgrade"
    _v._type = "common"
    if (_v.Name == nil) then
        _v.Name = F6_NAME("未命名科技")
    end
    return _v
end