-- 附魔
henchant = {
    -- 固有加成（10%）
    -- 附魔属性存在时的固有加成，如火攻击对无火抵抗的自带10%伤害
    INTRINSIC_ADDITION = 10, --(%)
    -- 是否开启着身附魔后果
    STATUS = false,
    -- 开启着身附魔后,默认附身时间(秒)
    APPEND_DURING = 5.0,
    -- 附魔环境附着特效
    ENV_APPEND_EFFECT = {},
    -- 附魔环境反应
    ENV_REACTION = {},
}

--- 设置附魔的底层固有加成
---@param percent number 加成比例(%)
henchant.setIntrinsicAddition = function(percent)
    if (type(percent) == 'number') then
        henchant.INTRINSIC_ADDITION = math.round(percent)
    end
end

--- 设置着身附魔
---@param status boolean 开关附魔
henchant.setAppend = function(status)
    if (type(status) == 'boolean') then
        henchant.STATUS = status
    end
end

--- 设置单位附着附魔特效
---@param whichEnchant string CONST_ENCHANT 对应的附魔
---@param effects table|nil 特效绑定的多个位置，如 {{attach = 'origin',effect = 'Abilities\\Spells\\Other\\BreathOfFire\\BreathOfFireDamage.mdl'}}
---@param rgb table|nil 单位三原色变色，如 {255,255,255}
henchant.setAppendAttachEffect = function(whichEnchant, effects, rgb)
    if (type(whichEnchant) ~= 'string') then
        return
    end
    if (effects ~= nil and type(effects) ~= 'table') then
        return
    end
    if (rgb ~= nil and type(rgb) ~= 'table') then
        return
    end
    henchant.ENV_APPEND_EFFECT[whichEnchant] = {
        effects = effects,
        rgb = rgb,
    }
end

--- 设置环境附魔反应
---@alias setReaction fun(evtData: {type:"附魔触发类型",level:"附魔触发等级",sourceUnit:"来自单位",targetUnit:"目标单位"}):void
---@param onEnchant string CONST_ENCHANT [运行时]单位附着的新的附魔
---@param toEnchant string CONST_ENCHANT [运行时]单位已有的目标附着附魔
---@param reaction setReaction  | "function(evtData) end" 新->旧 [运行时]化学反应，反应后该两个类型的附魔都将消失
henchant.setEnvReaction = function(onEnchant, toEnchant, reaction)
    if (type(onEnchant) ~= 'string' or type(toEnchant) ~= 'string' or type(reaction) ~= 'function') then
        return
    end
    if (henchant.ENV_REACTION[onEnchant] == nil) then
        henchant.ENV_REACTION[onEnchant] = {}
    end
    henchant.ENV_REACTION[onEnchant][toEnchant] = reaction
end

--- 给目标单位添加附魔属性
---@param options table
henchant.append = function(options)
    --[[
        options = {
            targetUnit = userdata,
            sourceUnit = userdata,
            enchants = {'fire','water'} | "fire,water", 建议用table
            during = 5,
        }
    ]]
    local targetUnit = options.targetUnit
    local sourceUnit = options.sourceUnit
    local enchants = options.enchants
    local during = options.during or henchant.APPEND_DURING
    if (during < 0) then
        during = 0
    end
    if (henchant.STATUS ~= true) then
        return
    end
    if (targetUnit == nil or his.deleted(targetUnit)) then
        return
    end
    if (sourceUnit == nil or his.deleted(sourceUnit)) then
        return
    end
    if (type(enchants) == 'string') then
        enchants = string.explode(',', enchants)
    end
    if (type(enchants) ~= 'table' or #enchants <= 0) then
        return
    end
    print_r(enchants)
    -- 整合
    local curEnchant = hattribute.get(targetUnit, 'append_enchant') -- 目标单位当前的附魔
    local addEnchant = {}  -- 增添的附魔
    local subEnchant = {}  -- 消逝的附魔
    for _, e in ipairs(enchants) do
        local hasReaction = false -- 判断反应结果
        if (henchant.ENV_REACTION[e] ~= nil) then
            for _, con in ipairs(CONST_ENCHANT) do
                -- 判断所有种类的附魔，如果之前有附魔过
                if (curEnchant[con.value] > 0) then
                    if (henchant.ENV_REACTION[e][con.value] ~= nil) then
                        -- 如果有反应式
                        henchant.ENV_REACTION[e][con.value]({
                            type = con.value,
                            level = curEnchant[con.value],
                            sourceUnit = sourceUnit,
                            targetUnit = targetUnit,
                        })
                        for _ = 1, curEnchant[con.value], 1 do
                            table.insert(subEnchant, con.value)
                        end
                        hasReaction = true
                    end
                end
            end
        end
        -- 如果有对应的反应，那么删除增添的附魔和身上的附魔状态
        -- 如果没有反应，那么增加一个着身附魔
        if (hasReaction == true) then
            -- 这里不需要删除新附魔，什么都不做就行了，消失了
        else
            table.insert(addEnchant, e)
        end
    end
    if (#addEnchant > 0) then
        hattribute.set(targetUnit, during, {
            append_enchant = "+" .. string.implode(',', addEnchant)
        })
    end
    if (#subEnchant > 0) then
        hattribute.set(targetUnit, during, {
            append_enchant = "-" .. string.implode(',', subEnchant)
        })
    end
end

henchant.env = function(options)

end
