--- 固定配置项
local F6_CONF = {
    autoShadow = false, -- 是否自动启用影子物品
}

---@private
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
        table.insert(formulas, { _profit = profit, _fragment = fragment })
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
    _v._type = "common"
    if (_v._parent == nil) then
        _v._parent = "ANcl"
    end
    return _v
end

F6V_A_E = function(_v)
    _v._parent = "Aamk"
    _v._type = "empty"
    return F6V_A(_v)
end

F6V_A_R = function(_v)
    _v._parent = "Aamk"
    _v._type = "ring"
    F6_RING(_v)
    return F6V_A(_v)
end

F6V_U = function(_v)
    _v._class = "unit"
    _v._type = "common"
    if (_v._parent == nil) then
        _v._parent = "hpea"
    end
    return _v
end

F6V_I_SHADOW = function(_v)
    _v._parent = "gold"
    _v._class = "item"
    _v._type = "shadow"
    return _v
end

F6V_I = function(_v)
    _v._class = "item"
    _v._type = "common"
    if (_v._parent == nil) then
        if (_v.class == "Charged") then
            _v._parent = "hlst"
        elseif (_v.class == "PowerUp") then
            _v._parent = "gold"
        else
            _v._parent = "rat9"
        end
    end
    -- 处理 _shadow
    if (type(_v._shadow) ~= 'boolean') then
        _v._shadow = (F6_CONF.autoShadow == true and _v.powerup == 0)
    end
    -- 处理 _ring光环
    F6_RING(_v)
    if (_v._overlie == nil or _v._overlie < (_v.uses or 1)) then
        _v._overlie = _v.uses or 1
    end
    return _v
end

F6V_UP = function(_v)
    _v._class = "upgrade"
    _v._type = "common"
    return _v
end