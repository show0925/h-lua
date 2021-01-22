---@class hattribute 属性系统
hattribute = {
    VAL_TYPE = {
        PLAYER = { "gold_ratio", "lumber_ratio", "exp_ratio", "sell_ratio" },
        INTEGER = {
            "life", "mana", "move", "attack_white", "attack_green",
            "attack_range", "attack_range_acquire",
            "sight", "defend_white", "defend_green",
            "str_white", "agi_white", "int_white", "str_green", "agi_green", "int_green", "punish"
        },
    },
    THREE_BUFF = {
        -- 每一点三围对属性的影响，默认会写一些，可以通过 hattr.setThreeBuff 方法来改变系统构成
        -- 需要注意的是三围只能影响common内的大部分参数，natural及effect是无效的
        primary = 1, -- 每点主属性提升1点白字攻击（默认例子，这是模拟原生平衡性常数，需要设置平衡性常数为0）
        str = {
            life = 19, -- 每点力量提升10生命（默认例子）
            life_back = 0.05 -- 每点力量提升0.05生命恢复（默认例子）
        },
        agi = {
            defend_green = 0.01 -- 每点敏捷提升0.01护甲（默认例子）
        },
        int = {
            mana = 6, -- 每点智力提升6魔法（默认例子）
            mana_back = 0.05 -- 每点力量提升0.05生命恢复（默认例子）
        }
    },
}

-- 处理部分设置
for _, con in ipairs(CONST_ENCHANT) do
    table.insert(hattribute.VAL_TYPE.INTEGER, "e_" .. con.value .. "_attack")
    table.insert(hattribute.VAL_TYPE.INTEGER, "e_" .. con.value .. "_append")
end

--- 判断是否某种类型的数值设定
---@param field string attribute
---@param valType table VAL_TYPE.?
---@return boolean
hattribute.isValType = function(field, valType)
    if (field == nil or valType == nil) then
        return false
    end
    if (table.includes(valType, field)) then
        return true
    end
    return false
end

--- 设置三围的影响
---@param buff table
hattribute.setThreeBuff = function(buff)
    if (type(buff) == "table") then
        hattribute.THREE_BUFF = buff
    end
end

--- 为单位初始化属性系统的对象数据
--- @private
hattribute.init = function(whichUnit)
    if (whichUnit == nil or his.deleted(whichUnit)) then
        return false
    end
    -- init
    local uSlk = hunit.getSlk(whichUnit)
    local attribute = {
        primary = uSlk.Primary or "STR",
        life = cj.GetUnitState(whichUnit, UNIT_STATE_MAX_LIFE),
        mana = cj.GetUnitState(whichUnit, UNIT_STATE_MAX_MANA),
        move = cj.GetUnitDefaultMoveSpeed(whichUnit),
        defend_white = 0,
        defend_green = 0,
        attack_speed = 0.0,
        attack_white = 0.0,
        attack_green = 0.0,
        attack_range = 100,
        attack_range_acquire = 100,
        attack_speed_space_origin = 0,
        sight = 1800,
        str_green = 0.0,
        agi_green = 0.0,
        int_green = 0.0,
        str_white = 0,
        agi_white = 0,
        int_white = 0,
        life_back = 0.0,
        mana_back = 0.0,
        avoid = 0.0,
        aim = 0.0,
        punish = 0.0,
        punish_current = 0.0,
        hemophagia = 0.0,
        hemophagia_skill = 0.0,
        invincible = 0.0,
        weight = 0.0,
        weight_current = 0.0,
        damage_extent = 0.0,
        damage_reduction = 0.0,
        damage_decrease = 0.0,
        damage_rebound = 0.0,
        cure = 0.0,
        knocking_odds = 0.0,
        knocking_extent = 0.0,
        knocking_oppose = 0.0,
        violence_oppose = 0.0,
        hemophagia_oppose = 0.0,
        hemophagia_skill_oppose = 0.0,
        buff_oppose = 0.0,
        debuff_oppose = 0.0,
        split_oppose = 0.0,
        punish_oppose = 0.0,
        damage_rebound_oppose = 0.0,
        swim_oppose = 0.0,
        heavy_oppose = 0.0,
        broken_oppose = 0.0,
        unluck_oppose = 0.0,
        silent_oppose = 0.0,
        unarm_oppose = 0.0,
        fetter_oppose = 0.0,
        bomb_oppose = 0.0,
        lightning_chain_oppose = 0.0,
        crack_fly_oppose = 0.0,
        --
        xtras = {},
    }
    for _, v in ipairs(CONST_ENCHANT) do
        attribute["e_" .. v.value] = 0.0
        attribute["e_" .. v.value .. '_oppose'] = 0.0
        attribute["e_" .. v.value .. '_attack'] = 0
        attribute["e_" .. v.value .. '_append'] = 0
    end
    if (uSlk.dmgplus1) then
        attribute.attack_white = math.floor(uSlk.dmgplus1)
    end
    if (uSlk.rangeN1) then
        attribute.attack_range = math.floor(uSlk.rangeN1)
    end
    if (uSlk.acquire) then
        attribute.attack_range_acquire = math.floor(uSlk.acquire)
    end
    if (uSlk.attack_speed_space_origin) then
        attribute.attack_speed_space_origin = math.round(uSlk.cool1)
    end
    if (uSlk.def) then
        attribute.defend_white = math.round(uSlk.def)
    end
    if (uSlk.sight) then
        attribute.sight = math.floor(uSlk.sight)
    end
    -- 初始化数据
    hunit.set(whichUnit, 'attribute', attribute)
    return true
end

-- 设定属性
--[[
    白字攻击 绿字攻击
    攻速 视野 警示范围
    力敏智 力敏智(绿)
    护甲 魔抗
    生命 魔法 +恢复
    硬直
    物暴 术暴 分裂 回避 移动力 力量 敏捷 智力 救助力 吸血 负重 各率
    type(data) == table
    data = { 支持 加/减/乘/除/等
        life = '+100',
        mana = '-100',
        life_back = '*100',
        mana_back = '/100',
        move = '=100',
    }
    during = 0.0 大于0生效；小于等于0时无限持续时间
]]
--- @private
--- @return nil|string buffKey
hattribute.setHandle = function(whichUnit, attr, opr, val, during)
    local valType = type(val)
    local params = hattr.get(whichUnit)
    if (params == nil) then
        return
    end
    local buffKey
    if (valType == "number") then
        local diff = 0
        if (opr == "+") then
            diff = val
        elseif (opr == "-") then
            diff = -val
        elseif (opr == "*") then
            diff = params[attr] * val - params[attr]
        elseif (opr == "/" and val ~= 0) then
            diff = params[attr] / val - params[attr]
        elseif (opr == "=") then
            diff = val - params[attr]
        end
        --部分属性取整处理，否则失真
        if (hattribute.isValType(attr, hattribute.VAL_TYPE.INTEGER) and diff ~= 0) then
            local dts = hattributeSetter.getDecimalTemporaryStorage(whichUnit, attr)
            local diffI, diffF = math.modf(diff)
            local dtsI, dtsF = math.modf(dts)
            diff = diffI + dtsI
            dts = dtsF + diffF
            if (dts < 0) then
                -- 归0补正
                dts = 1 + dts
                diff = diff - 1
            elseif (math.abs(dts) >= 1) then
                -- 破1退1
                dtsI, dtsF = math.modf(dts)
                diff = diffI + dtsI
                dts = dtsF
            end
            hattributeSetter.setDecimalTemporaryStorage(whichUnit, attr, dts)
        end
        if (diff ~= 0) then
            local currentVal = params[attr]
            local futureVal = params[attr] + diff
            if (during > 0) then
                local groupKey = 'attr.' .. attr .. '+'
                if (diff < 0) then
                    groupKey = 'attr.' .. attr .. '-'
                end
                buffKey = hbuff.create(during, whichUnit, groupKey,
                    function()
                        params[attr] = futureVal
                    end,
                    function()
                        hattribute.setHandle(whichUnit, attr, "-", diff, 0)
                    end
                )
            else
                params[attr] = futureVal
            end
            -- ability
            local tempVal = 0
            local level = 0
            if (attr == "life" or attr == "mana") then
                -- 生命 | 魔法
                if (futureVal >= 999999999) then
                    futureVal = 999999999
                    if (currentVal >= 999999999) then
                        diff = 0
                    else
                        diff = 999999999 - currentVal
                    end
                elseif (futureVal <= 1) then
                    futureVal = 1
                    if (currentVal <= 1) then
                        diff = 0
                    else
                        diff = 1 - currentVal
                    end
                end
                local method
                if (attr == "life") then
                    method = hjapi.setUnitMaxLife
                elseif (attr == "mana") then
                    method = hjapi.setUnitMaxMana
                end
                if (false == method(whichUnit, futureVal)) then
                    print("hlua")
                    tempVal = math.floor(math.abs(diff))
                    local max = 100000000
                    if (tempVal ~= 0) then
                        while (max >= 1) do
                            level = math.floor(tempVal / max)
                            tempVal = math.floor(tempVal - level * max)
                            if (diff > 0) then
                                hattributeSetter.relyLifeMana(whichUnit, hslk.attr[attr].add[max], level)
                            else
                                hattributeSetter.relyLifeMana(whichUnit, hslk.attr[attr].sub[max], level)
                            end
                            max = math.floor(max / 10)
                        end
                    end
                end
            elseif (attr == "move") then
                -- 移动
                if (futureVal < 0) then
                    cj.SetUnitMoveSpeed(whichUnit, 0)
                else
                    cj.SetUnitMoveSpeed(whichUnit, math.min(math.floor(futureVal), 522))
                end
            elseif (attr == "attack_speed_space") then
                if (futureVal > 10.00) then
                    futureVal = 10.00
                elseif (futureVal < 0) then
                    futureVal = 0
                end
                hjapi.setUnitAttackSpace(whichUnit, futureVal)
            elseif (attr == "attack_white") then
                -- 白字攻击
                local max = 100000000
                if (futureVal > max or futureVal < -max) then
                    diff = 0
                end
                tempVal = math.floor(math.abs(diff))
                if (tempVal ~= 0) then
                    while (max >= 1) do
                        level = math.floor(tempVal / max)
                        tempVal = math.floor(tempVal - level * max)
                        if (diff > 0) then
                            hattributeSetter.relyAttackWhite(whichUnit, hslk.attr.item_attack_white.add[max], level)
                        else
                            hattributeSetter.relyAttackWhite(whichUnit, hslk.attr.item_attack_white.sub[max], level)
                        end
                        max = math.floor(max / 10)
                    end
                end
            elseif (attr == "attack_range") then
                -- 攻击范围[JAPI]
                if (futureVal < 0) then
                    futureVal = 0
                elseif (futureVal > 9999) then
                    futureVal = 9999
                end
                hjapi.setUnitAttackRange(whichUnit, futureVal)
            elseif (attr == "attack_range_acquire") then
                -- 主动攻击范围
                if (futureVal < 0) then
                    futureVal = 0
                elseif (futureVal > 9999) then
                    futureVal = 9999
                end
                cj.SetUnitAcquireRange(whichUnit, futureVal * 1.1)
            elseif (attr == "sight") then
                -- 视野
                for _, gradient in ipairs(hslk.attr.sight_gradient) do
                    cj.UnitRemoveAbility(whichUnit, hslk.attr.sight.add[gradient])
                    cj.UnitRemoveAbility(whichUnit, hslk.attr.sight.sub[gradient])
                end
                tempVal = math.floor(math.abs(futureVal))
                local sight_gradient = table.clone(hslk.attr.sight_gradient)
                if (tempVal ~= 0) then
                    while (true) do
                        local isFound = false
                        for _, v in ipairs(sight_gradient) do
                            if (tempVal >= v) then
                                tempVal = math.floor(tempVal - v)
                                table.delete(sight_gradient, v)
                                if (futureVal > 0) then
                                    cj.UnitAddAbility(whichUnit, hslk.attr.sight.add[v])
                                else
                                    cj.UnitAddAbility(whichUnit, hslk.attr.sight.sub[v])
                                end
                                isFound = true
                                break
                            end
                        end
                        if (isFound == false) then
                            break
                        end
                    end
                end
            elseif ("attack_speed" == attr) then
                hjapi.setUnitAttackSpeed()
            elseif (table.includes({ "attack_green", "attack_speed", "defend_green" }, attr)) then
                -- 绿字攻击 攻击速度 绿字护甲
                if (futureVal < -99999999) then
                    futureVal = -99999999
                elseif (futureVal > 99999999) then
                    futureVal = 99999999
                end
                for _, grad in ipairs(hslk.attr.ablis_gradient) do
                    local ab = hslk.attr[attr].add[grad]
                    if (cj.GetUnitAbilityLevel(whichUnit, ab) > 1) then
                        cj.SetUnitAbilityLevel(whichUnit, ab, 1)
                    end
                    ab = hslk.attr[attr].sub[grad]
                    if (cj.GetUnitAbilityLevel(whichUnit, ab) > 1) then
                        cj.SetUnitAbilityLevel(whichUnit, ab, 1)
                    end
                end
                tempVal = math.floor(math.abs(futureVal))
                local max = 100000000
                if (tempVal ~= 0) then
                    while (max >= 1) do
                        level = math.floor(tempVal / max)
                        tempVal = math.floor(tempVal - level * max)
                        if (futureVal > 0) then
                            if (cj.GetUnitAbilityLevel(whichUnit, hslk.attr[attr].add[max]) < 1) then
                                cj.UnitAddAbility(whichUnit, hslk.attr[attr].add[max])
                            end
                            cj.SetUnitAbilityLevel(whichUnit, hslk.attr[attr].add[max], level + 1)
                        else
                            if (cj.GetUnitAbilityLevel(whichUnit, hslk.attr[attr].sub[max]) < 1) then
                                cj.UnitAddAbility(whichUnit, hslk.attr[attr].sub[max])
                            end
                            cj.SetUnitAbilityLevel(whichUnit, hslk.attr[attr].sub[max], level + 1)
                        end
                        max = math.floor(max / 10)
                    end
                end
            elseif (his.hero(whichUnit) and table.includes({ "str_green", "agi_green", "int_green" }, attr)) then
                -- 绿字力量 绿字敏捷 绿字智力
                if (futureVal < -99999999) then
                    futureVal = -99999999
                elseif (futureVal > 99999999) then
                    futureVal = 99999999
                end
                for _, grad in ipairs(hslk.attr.ablis_gradient) do
                    local ab = hslk.attr[attr].add[grad]
                    if (cj.GetUnitAbilityLevel(whichUnit, ab) > 1) then
                        cj.SetUnitAbilityLevel(whichUnit, ab, 1)
                    end
                    ab = hslk.attr[attr].sub[grad]
                    if (cj.GetUnitAbilityLevel(whichUnit, ab) > 1) then
                        cj.SetUnitAbilityLevel(whichUnit, ab, 1)
                    end
                end
                tempVal = math.floor(math.abs(futureVal))
                local max = 100000000
                if (tempVal ~= 0) then
                    while (max >= 1) do
                        level = math.floor(tempVal / max)
                        tempVal = math.floor(tempVal - level * max)
                        if (futureVal > 0) then
                            if (cj.GetUnitAbilityLevel(whichUnit, hslk.attr[attr].add[max]) < 1) then
                                cj.UnitAddAbility(whichUnit, hslk.attr[attr].add[max])
                            end
                            cj.SetUnitAbilityLevel(whichUnit, hslk.attr[attr].add[max], level + 1)
                        else
                            if (cj.GetUnitAbilityLevel(whichUnit, hslk.attr[attr].sub[max]) < 1) then
                                cj.UnitAddAbility(whichUnit, hslk.attr[attr].sub[max])
                            end
                            cj.SetUnitAbilityLevel(whichUnit, hslk.attr[attr].sub[max], level + 1)
                        end
                        max = math.floor(max / 10)
                    end
                end
                local subAttr = string.gsub(attr, "_green", "")
                -- 主属性影响(<= 0自动忽略)
                if (hattribute.THREE_BUFF.primary > 0) then
                    if (string.upper(subAttr) == hhero.getPrimary(whichUnit)) then
                        hattribute.set(whichUnit, 0, { attack_white = "+" .. diff * hattribute.THREE_BUFF.primary })
                    end
                end
                -- 三围影响
                local three = table.obj2arr(hattribute.THREE_BUFF[subAttr], CONST_ATTR_KEYS)
                for _, d in ipairs(three) do
                    local tempV = diff * d.value
                    if (tempV < 0) then
                        hattribute.set(whichUnit, 0, { [d.key] = "-" .. math.abs(tempV) })
                    elseif (tempV > 0) then
                        hattribute.set(whichUnit, 0, { [d.key] = "+" .. tempV })
                    end
                end
            elseif (his.hero(whichUnit) and table.includes({ "str_white", "agi_white", "int_white" }, attr)) then
                -- 白字力量 敏捷 智力
                if (attr == "str_white") then
                    cj.SetHeroStr(whichUnit, math.floor(futureVal), true)
                elseif (attr == "agi_white") then
                    cj.SetHeroAgi(whichUnit, math.floor(futureVal), true)
                elseif (attr == "int_white") then
                    cj.SetHeroInt(whichUnit, math.floor(futureVal), true)
                end
                local subAttr = string.gsub(attr, "_white", "")
                -- 主属性影响(<= 0自动忽略)
                if (hattribute.THREE_BUFF.primary > 0) then
                    if (string.upper(subAttr) == hhero.getPrimary(whichUnit)) then
                        hattribute.set(whichUnit, 0, { attack_white = "+" .. diff * hattribute.THREE_BUFF.primary })
                    end
                end
                -- 三围影响
                local three = table.obj2arr(hattribute.THREE_BUFF[subAttr], CONST_ATTR_KEYS)
                for _, d in ipairs(three) do
                    local tempV = diff * d.value
                    if (tempV < 0) then
                        hattribute.set(whichUnit, 0, { [d.key] = "-" .. math.abs(tempV) })
                    elseif (tempV > 0) then
                        hattribute.set(whichUnit, 0, { [d.key] = "+" .. tempV })
                    end
                end
            elseif (attr == "life_back" or attr == "mana_back") then
                -- 生命,魔法恢复
                if (math.abs(futureVal) > 0.02 and table.includes(hRuntime.attributeGroup[attr], whichUnit) == false) then
                    table.insert(hRuntime.attributeGroup[attr], whichUnit)
                elseif (math.abs(futureVal) < 0.02) then
                    table.delete(hRuntime.attributeGroup[attr], whichUnit)
                end
            elseif (attr == "punish" and hunit.isOpenPunish(whichUnit)) then
                -- 硬直
                if (currentVal > 0) then
                    local punishCurrent = hattribute.get(whichUnit, 'punish_current')
                    if (punishCurrent > futureVal) then
                        hattribute.set(whichUnit, 0, {
                            punish_current = futureVal
                        })
                    end
                else
                    hattribute.set(whichUnit, 0, {
                        punish_current = futureVal
                    })
                end
            elseif (attr == "punish_current" and hunit.isOpenPunish(whichUnit)) then
                -- 硬直(current)
                local punish = hattribute.get(whichUnit, 'punish')
                if (punish > 0 and (futureVal > punish or futureVal <= 0)) then
                    hattribute.set(whichUnit, 0, {
                        punish_current = punish
                    })
                end
            end
        end
    elseif (valType == "table") then
        -- table类型只有+-没有别的
        if (opr == "+") then
            local _k = string.attrBuffKey(val)
            if (during > 0) then
                buffKey = hbuff.create(during, whichUnit, 'attr.' .. attr .. '+',
                    function()
                        table.insert(params[attr], { _k = _k, _t = val })
                    end,
                    function()
                        hattribute.setHandle(whichUnit, attr, "-", val, 0)
                    end
                )
            else
                table.insert(params[attr], { _k = _k, _t = val })
            end
        elseif (opr == "-") then
            local _k = string.attrBuffKey(val)
            local hasKey = false
            for k, v in ipairs(params[attr]) do
                if (v._k == _k) then
                    table.remove(params[attr], k)
                    hasKey = true
                    break
                end
            end
            if (hasKey == true) then
                if (during > 0) then
                    buffKey = hbuff.create(during, whichUnit, 'attr.' .. attr .. '-',
                        function()
                        end,
                        function()
                            hattribute.setHandle(whichUnit, attr, "+", val, 0)
                        end
                    )
                end
            end
        end
    elseif (valType == "string") then
        -- string类型只有+-=
        if (opr == "+") then
            local valArr = string.explode(",", val)
            if (during > 0) then
                buffKey = hbuff.create(
                    during, whichUnit, 'attr.' .. attr .. '+',
                    function()
                        params[attr] = table.merge(params[attr], valArr)
                    end,
                    function()
                        hattribute.setHandle(whichUnit, attr, "-", val, 0)
                    end
                )
            else
                params[attr] = table.merge(params[attr], valArr)
            end
        elseif (opr == "-") then
            local valArr = string.explode(",", val)
            if (during > 0) then
                buffKey = hbuff.create(
                    during, whichUnit, 'attr.' .. attr .. '-',
                    function()
                        for _, v in ipairs(valArr) do
                            if (table.includes(params[attr], v)) then
                                table.delete(params[attr], v, 1)
                            end
                        end
                    end,
                    function()
                        hattribute.setHandle(whichUnit, attr, "+", val, 0)
                    end
                )
            else
                for _, v in ipairs(valArr) do
                    if (table.includes(params[attr], v)) then
                        table.delete(params[attr], v, 1)
                    end
                end
            end
        elseif (opr == "=") then
            local old = table.clone(params[attr])
            if (during > 0) then
                buffKey = hbuff.create(
                    during, whichUnit, 'attr.' .. attr .. '=',
                    function()
                        params[attr] = string.explode(",", val)
                    end,
                    function()
                        hattribute.setHandle(whichUnit, attr, "=", string.implode(",", old), 0)
                    end
                )
            else
                params[attr] = string.explode(",", val)
            end
        end
    end
    return buffKey
end

--- 设置单位属性
---@param whichUnit userdata
---@param during number 0表示无限
---@param data any
---@return nil|table buffKeys，返回buff keys，如果一个buff都没有，返回nil
hattribute.set = function(whichUnit, during, data)
    if (whichUnit == nil) then
        -- 例如有时造成伤害之前把单位删除就捕捉不到这个伤害来源了
        -- 虽然这里直接返回不执行即可，但是提示下可以帮助完善业务的构成~
        print_stack("whichUnit is nil")
        return
    end
    local attribute = hattribute.get(whichUnit)
    if (attribute == nil) then
        return
    end
    -- 处理data
    if (type(data) ~= "table") then
        print_err("data must be table")
        return
    end
    local buffKeys = {}
    for _, arr in ipairs(table.obj2arr(data, CONST_ATTR_KEYS)) do
        local attr = arr.key
        local v = arr.value
        local buffKey
        if (attribute[attr] ~= nil) then
            if (type(v) == "string") then
                local opr = string.sub(v, 1, 1)
                v = string.sub(v, 2, string.len(v))
                local val = tonumber(v)
                if (val == nil) then
                    val = v
                end
                buffKey = hattribute.setHandle(whichUnit, attr, opr, val, during)
            elseif (type(v) == "table") then
                -- table型，如 xtras
                if (v.add ~= nil and type(v.add) == "table") then
                    for _, set in ipairs(v.add) do
                        if (set == nil) then
                            print_err("table effect loss[set]!")
                            print_stack()
                            break
                        end
                        if (type(set) ~= "table") then
                            print_err("add type(set) must be a table!")
                            print_stack()
                            break
                        end
                        buffKey = hattribute.setHandle(whichUnit, attr, "+", set, during)
                    end
                elseif (v.sub ~= nil and type(v.sub) == "table") then
                    for _, set in ipairs(v.sub) do
                        if (set == nil) then
                            print_err("table effect loss[set]!")
                            print_stack()
                            break
                        end
                        if (type(set) ~= "table") then
                            print_err("sub type(set) must be a table!")
                            print_stack()
                            break
                        end
                        buffKey = hattribute.setHandle(whichUnit, attr, "-", set, during)
                    end
                end
            end
        end
        if (buffKey ~= nil) then
            table.insert(buffKeys, buffKey)
        end
    end
    if (#buffKeys > 0) then
        return buffKeys
    end
end

--- 通用get
---@param whichUnit userdata
---@param attr string
---@return any
hattribute.get = function(whichUnit, attr)
    if (whichUnit == nil) then
        return nil
    end
    local attribute = hunit.get(whichUnit, 'attribute', nil)
    if (attribute == nil) then
        return nil
    elseif (attribute == -1) then
        if (hattribute.init(whichUnit) == false) then
            return nil
        end
        attribute = hunit.get(whichUnit, 'attribute')
    end
    attribute.attack = hunit.getAttackSides(whichUnit) + attribute.attack_white or 0 + attribute.attack_green or 0
    attribute.attack_speed_space = math.round(attribute.attack_speed_space_origin / (1 + math.min(math.max(attribute.attack_speed, -80), 400) * 0.01))
    attribute.str = (attribute.str_white or 0) + (attribute.str_green or 0)
    attribute.agi = (attribute.agi_white or 0) + (attribute.agi_green or 0)
    attribute.int = (attribute.int_white or 0) + (attribute.int_green or 0)
    if (attr == nil) then
        return attribute
    end
    return attribute[attr]
end

--- 计算单位的属性浮动影响
---@private
hattribute.caleAttribute = function(damageSrc, isAdd, whichUnit, attr, times)
    if (isAdd == nil) then
        isAdd = true
    end
    if (attr == nil) then
        return
    end
    damageSrc = damageSrc or CONST_DAMAGE_SRC.unknown
    times = times or 1
    local diff = {}
    local diffPlayer = {}
    for _, arr in ipairs(table.obj2arr(attr, CONST_ATTR_KEYS)) do
        local k = arr.key
        local v = arr.value
        local typev = type(v)
        local tempDiff
        if (typev == "string") then
            local opt = string.sub(v, 1, 1)
            local nv = times * tonumber(string.sub(v, 2))
            if (isAdd == false) then
                if (opt == "+") then
                    opt = "-"
                else
                    opt = "+"
                end
            end
            tempDiff = opt .. nv
        elseif (typev == "number") then
            if ((v > 0 and isAdd == true) or (v < 0 and isAdd == false)) then
                tempDiff = "+" .. (v * times)
            elseif (v < 0) then
                tempDiff = "-" .. (v * times)
            end
        elseif (typev == "table") then
            local tempTable = {}
            for _ = 1, times do
                for _, vv in ipairs(v) do
                    vv.damageSrc = damageSrc
                    table.insert(tempTable, vv)
                end
            end
            local opt = "add"
            if (isAdd == false) then
                opt = "sub"
            end
            tempDiff = {
                [opt] = tempTable
            }
        end
        if (hattribute.isValType(k, hattribute.VAL_TYPE.PLAYER)) then
            table.insert(diffPlayer, { k, tonumber(tempDiff) })
        else
            diff[k] = tempDiff
        end
    end
    hattr.set(whichUnit, 0, diff)
    if (#diffPlayer > 0) then
        local p = hunit.getOwner(whichUnit)
        for _, dp in ipairs(diffPlayer) do
            local pk = dp[1]
            local pv = dp[2]
            if (pv ~= 0) then
                if (pk == "gold_ratio") then
                    hplayer.addGoldRatio(p, pv, 0)
                elseif (pk == "lumber_ratio") then
                    hplayer.addLumberRatio(p, pv, 0)
                elseif (pk == "exp_ratio") then
                    hplayer.addExpRatio(p, pv, 0)
                elseif (pk == "sell_ratio") then
                    hplayer.addSellRatio(p, pv, 0)
                end
            end
        end
    end
end