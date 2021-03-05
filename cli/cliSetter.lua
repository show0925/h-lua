string_explode = function(delimeter, str)
    local res = {}
    local start, start_pos, end_pos = 1, 1, 1
    while true do
        start_pos, end_pos = string.find(str, delimeter, start, true)
        if not start_pos then
            break
        end
        table.insert(res, string.sub(str, start, start_pos - 1))
        start = end_pos + 1
    end
    table.insert(res, string.sub(str, start))
    return res
end

string_strpos = function(str, pattern)
    if (str == nil or pattern == nil) then
        return false
    end
    local s = string.find(str, pattern, 0)
    if (type(s) == "number") then
        return s
    else
        return false
    end
end

---@private
F6V_I_SYNTHESIS = function(formula)
    local formulas = {}
    for _, v in ipairs(formula) do
        local profit = ''
        local fragment = {}
        if (type(v) == 'string') then
            local f1 = string_explode('=', v)
            if (string_strpos(f1[1], 'x') == false) then
                profit = { f1[1], 1 }
            else
                local temp = string_explode('x', f1[1])
                temp[2] = math.floor(temp[2])
                profit = temp
            end
            local f2 = string_explode('+', f1[2])
            for _, vv in ipairs(f2) do
                if (string_strpos(vv, 'x') == false) then
                    table.insert(fragment, { vv, 1 })
                else
                    local temp = string_explode('x', vv)
                    temp[2] = math.floor(temp[2])
                    table.insert(fragment, temp)
                end
            end
        elseif (type(v) == 'table') then
            profit = v[1]
            for vi = 2, #v, 1 do
                table.insert(fragment, v[vi])
            end
        end
        table.insert(formulas, { profit = profit, fragment = fragment })
    end
    return formulas
end

local F6_RING = function(_v)
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
end

F6V_A = function(_v)
    _v._class = "ability"
    _v._type = _v._type or "common"
    if (_v._parent == nil) then
        _v._parent = "ANcl"
    end
    -- 处理 _ring光环
    F6_RING(_v)
    return _v
end

F6V_U = function(_v)
    _v._class = "unit"
    _v._type = _v._type or "common"
    if (_v._parent == nil) then
        _v._parent = "hpea"
    end
    return _v
end

local courier_skill_ids
F6V_COURIER_SKILL = function()
    if (courier_skill_ids == nil) then
        courier_skill_ids = {}
        hslk_ability({ _parent = "AEbl", _type = "courier" })
        hslk_ability({ _parent = "ANcl", _type = "courier" })
        hslk_ability({ _parent = "ANtm", _type = "courier" })
        hslk_ability({ _parent = "ANcl", _type = "courier" })
    end
    return courier_skill_ids
end

F6V_I_CD = function(_v)
    if (_v._cooldown < 0) then
        _v._cooldown = 0
    end
    if (_v._cooldown == 0) then
        return "AIat"
    end
    local cdID
    local ad = {}
    if (_v._cooldownTarget == CONST_ABILITY_TARGET.location.value) then
        -- 对点（模版：照明弹）
        ad._parent = "Afla"
        local av = hslk_ability(ad)
        cdID = av._id
    elseif (_v.cooldownTarget == CONST_ABILITY_TARGET.range.value) then
        -- 对点范围（模版：暴风雪）
        ad._parent = "ACbz"
        local av = hslk_ability(ad)
        cdID = av._id
    elseif (_v._cooldownTarget == CONST_ABILITY_TARGET.unit.value) then
        -- 对单位（模版：霹雳闪电）
        ad._parent = "ACfb"
        local av = hslk_ability(ad)
        cdID = av._id
    else
        -- 立刻（模版：金箱子）
        ad._parent = "AIgo"
        local av = hslk_ability(ad)
        cdID = av._id
    end
    return cdID
end

F6V_I_SHADOW = function(_v)
    _v._parent = "gold"
    _v._class = "item"
    _v._type = "shadow"
    return _v
end

F6V_I = function(_v)
    _v._class = "item"
    _v._type = _v._type or "common"
    if (_v._cooldown ~= nil) then
        F6V_I_CD(_v)
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
    -- 处理 _ring光环
    F6_RING(_v)
    if (_v._overlie == nil or _v._overlie < (_v.uses or 1)) then
        _v._overlie = _v.uses or 1
    end
    return _v
end

F6V_B = function(_v)
    _v._class = "buff"
    _v._type = _v._type or "common"
    return _v
end

F6V_UP = function(_v)
    _v._class = "upgrade"
    _v._type = _v._type or "common"
    return _v
end
