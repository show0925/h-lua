-- 伤害漂浮字
local _damageTtgQty = 0
local _damageTtg = function(targetUnit, damage, fix, color)
    _damageTtgQty = _damageTtgQty + 1
    local during = 1.0
    local offx = -0.05 - _damageTtgQty * 0.013
    local offy = 0.05 + _damageTtgQty * 0.013
    htextTag.style(
        htextTag.create2Unit(targetUnit, fix .. math.floor(damage), 6.00, color, 1, during, 12.00),
        "toggle", offx, offy
    )
    htime.setTimeout(
        during,
        function(t)
            htime.delTimer(t)
            _damageTtgQty = _damageTtgQty - 1
        end
    )
end

--- 造成伤害
--[[
    options = {
        sourceUnit = nil, --伤害来源(可选)
        targetUnit = nil, --目标单位
        damage = 0, --实际伤害
        damageString = "", --伤害漂浮字颜色
        damageStringColor = "", --伤害漂浮字颜色
        effect = nil, --伤害特效
        damageSrc = "unknown", --伤害来源请查看 CONST_DAMAGE_SRC
        damageType = { "common" }, --伤害类型请查看 CONST_DAMAGE_TYPE
        breakArmorType = {} --破防(无视防御)类型请查看 CONST_BREAK_ARMOR_TYPE
        isFixed = false, --是否固定伤害，伤害在固定下(无视类型、护甲、魔抗、自然、增幅、减伤)不计算，而自然虽然不影响伤害，但会有自然效果
    }
]]
hskill.damage = function(options)
    local sourceUnit = options.sourceUnit
    local targetUnit = options.targetUnit
    local damage = options.damage or 0
    if (damage < 0.125) then
        return
    end
    if (targetUnit == nil) then
        return
    end
    if (his.alive(options.targetUnit) == false or his.deleted(targetUnit)) then
        return
    end
    if (his.deleted(targetUnit)) then
        return
    end
    if (his.deleted(sourceUnit)) then
        return
    end
    if (options.damageSrc == nil) then
        options.damageSrc = CONST_DAMAGE_SRC.unknown
    end
    --双方attr get
    local targetUnitAttr = hattr.get(targetUnit)
    local sourceUnitAttr = {}
    if (targetUnitAttr == nil) then
        print("targetUnit unregister")
        return
    end
    if (sourceUnit ~= nil) then
        sourceUnitAttr = hattr.get(sourceUnit)
        if (sourceUnitAttr == nil) then
            print("sourceUnit unregister")
            return
        end
    end
    local damageSrc = options.damageSrc
    local damageType = options.damageType
    if (damageType == nil) then
        if (damageSrc == CONST_DAMAGE_SRC.attack and sourceUnit ~= nil) then
            damageType = hattr.get(sourceUnit, "attack_damage_type")
        else
            damageType = CONST_DAMAGE_TYPE.common
        end
    end
    --常规伤害判定
    if (damageType == nil or #damageType <= 0) then
        damageType = { CONST_DAMAGE_TYPE.common }
    end
    -- 最终伤害
    local lastDamage = 0
    local lastDamagePercent = 0.0
    -- 僵直计算
    local punishEffectRatio = 0
    -- 是否固伤
    local isFixed = false
    if (type(options.isFixed) == 'boolean') then
        isFixed = options.isFixed
    end
    -- 文本显示
    local breakArmorType = options.breakArmorType or {}
    local damageString = options.damageString or ""
    local damageStringColor = options.damageStringColor or "d9d9d9"
    local effect = options.effect
    -- 判断伤害方式
    if (damageSrc == CONST_DAMAGE_SRC.attack) then
        if (his.unarm(sourceUnit) == true) then
            return
        end
    elseif (damageSrc == CONST_DAMAGE_SRC.skill) then
        if (his.silent(sourceUnit) == true) then
            return
        end
    elseif (damageSrc == CONST_DAMAGE_SRC.item) then
        if (his.silent(sourceUnit) == true) then
            return
        end
    else
        damageSrc = CONST_DAMAGE_SRC.unknown
    end
    -- 计算单位是否无敌（无敌属性为百分比计算，被动触发抵挡一次）
    if (his.invincible(targetUnit) == true or math.random(1, 100) < targetUnitAttr.invincible) then
        if (table.includes(CONST_BREAK_ARMOR_TYPE.invincible.value, breakArmorType) == false) then
            return
        end
    end
    -- 攻击者的攻击里各种类型的占比
    local dmgRatio = 1 / #damageType
    local typeRatio = {}
    for _, d in ipairs(damageType) do
        if (typeRatio[d] == nil) then
            typeRatio[d] = 0
        end
        typeRatio[d] = typeRatio[d] + dmgRatio
    end
    -- 计算硬直抵抗
    punishEffectRatio = 0.99
    if (targetUnitAttr.punish_oppose > 0) then
        punishEffectRatio = punishEffectRatio - targetUnitAttr.punish_oppose * 0.01
        if (punishEffectRatio < 0.100) then
            punishEffectRatio = 0.100
        end
    end
    if (isFixed == false) then
        -- 判断无视装甲类型
        if (breakArmorType ~= nil and #breakArmorType > 0) then
            damageString = damageString .. "无视"
            if (table.includes(CONST_BREAK_ARMOR_TYPE.defend.value, breakArmorType)) then
                if (targetUnitAttr.defend > 0) then
                    targetUnitAttr.defend = 0
                end
                damageString = damageString .. CONST_BREAK_ARMOR_TYPE.defend.label
                damageStringColor = "f97373"
            end
            if (table.includes(CONST_BREAK_ARMOR_TYPE.resistance.value, breakArmorType)) then
                if (targetUnitAttr.resistance > 0) then
                    targetUnitAttr.resistance = 0
                end
                damageString = damageString .. CONST_BREAK_ARMOR_TYPE.resistance.label
                damageStringColor = "6fa8dc"
            end
            if (table.includes(CONST_BREAK_ARMOR_TYPE.avoid.value, breakArmorType)) then
                if (targetUnitAttr.avoid > 0) then
                    targetUnitAttr.avoid = 0
                end
                damageString = damageString .. CONST_BREAK_ARMOR_TYPE.avoid.label
                damageStringColor = "76a5af"
            end
            if (table.includes(CONST_BREAK_ARMOR_TYPE.invincible.value, breakArmorType)) then
                if (targetUnitAttr.avoid > 0) then
                    targetUnitAttr.avoid = 0
                end
                damageString = damageString .. CONST_BREAK_ARMOR_TYPE.invincible.label
                damageStringColor = "ff4500"
            end
            -- @触发无视防御事件
            hevent.triggerEvent(
                sourceUnit,
                CONST_EVENT.breakArmor,
                {
                    triggerUnit = sourceUnit,
                    targetUnit = targetUnit,
                    breakType = breakArmorType
                }
            )
            -- @触发被无视防御事件
            hevent.triggerEvent(
                targetUnit,
                CONST_EVENT.beBreakArmor,
                {
                    triggerUnit = targetUnit,
                    sourceUnit = sourceUnit,
                    breakType = breakArmorType
                }
            )
        end
        -- *重要* 地图平衡常数必须设定护甲因子为0，这里为了修正魔兽负护甲依然因子保持0.06的bug
        -- 当护甲x为负时，最大-20,公式2-(1-a)^abs(x)
        if (targetUnitAttr.defend < 0 and targetUnitAttr.defend >= -20) then
            damage = damage / (2 - cj.Pow(0.94, math.abs(targetUnitAttr.defend)))
        elseif (targetUnitAttr.defend < 0 and targetUnitAttr.defend < -20) then
            damage = damage / (2 - cj.Pow(0.94, 20))
        end
    end
    -- 开始神奇的伤害计算
    lastDamage = damage
    -- 自身暴击计算，自身暴击触发下，回避几率减少一半
    local isKnocking = false
    if (isFixed == false and lastDamage > 0 and sourceUnitAttr.knocking_odds > 0 and sourceUnitAttr.knocking_extent > 0) then
        local targetKnockingOppose = hattr.get(targetUnit, "knocking_oppose")
        sourceUnitAttr.knocking_odds = sourceUnitAttr.knocking_odds - targetKnockingOppose
        if (math.random(1, 100) <= sourceUnitAttr.knocking_odds) then
            isKnocking = true
            damageString = "暴击!" .. damageString
            damageStringColor = "ff0000"
            lastDamagePercent = lastDamagePercent + sourceUnitAttr.knocking_extent * 0.01
            if (targetUnitAttr.avoid > 0) then
                targetUnitAttr.avoid = targetUnitAttr.avoid * 0.5
            end
            heffect.toUnit("war3mapImported\\eff_crit.mdl", targetUnit, 0.5)
        end
    end
    -- 计算回避 X 命中
    if (damageSrc == CONST_DAMAGE_SRC.attack and targetUnitAttr.avoid - (sourceUnitAttr.aim or 0) > 0 and math.random(1, 100) <= targetUnitAttr.avoid - (sourceUnitAttr.aim or 0)) then
        lastDamage = 0
        htextTag.style(htextTag.create2Unit(targetUnit, "回避", 6.00, "5ef78e", 10, 1.00, 10.00), "scale", 0, 0.2)
        -- @触发回避事件
        hevent.triggerEvent(
            targetUnit,
            CONST_EVENT.avoid,
            {
                triggerUnit = targetUnit,
                attacker = sourceUnit
            }
        )
        -- @触发被回避事件
        hevent.triggerEvent(
            sourceUnit,
            CONST_EVENT.beAvoid,
            {
                triggerUnit = sourceUnit,
                attacker = sourceUnit,
                targetUnit = targetUnit
            }
        )
    end
    if (lastDamage > 0) then
        -- 计算自然属性
        local tempNatural = {}
        for _, natural in ipairs(CONST_DAMAGE_TYPE_NATURE) do
            tempNatural[natural] = 10 + (sourceUnitAttr["natural_" .. natural] or 0) - targetUnitAttr["natural_" .. natural .. "_oppose"]
            if (tempNatural[natural] < -100) then
                tempNatural[natural] = -100
            end
            if (table.includes(natural, damageType) and tempNatural[natural] ~= 0) then
                if (isFixed == false) then
                    lastDamagePercent = lastDamagePercent + typeRatio[natural] * tempNatural[natural] * 0.01
                end
                damageString = damageString .. CONST_DAMAGE_TYPE_MAP[natural].label
                damageStringColor = CONST_DAMAGE_TYPE_MAP[natural].color
            end
        end
        if (isFixed == false) then
            -- 计算护甲
            if (targetUnitAttr.defend ~= 0 and typeRatio[CONST_DAMAGE_TYPE.physical] ~= nil) then
                local defendPercent = 0
                if (targetUnitAttr.defend > 0) then
                    defendPercent = targetUnitAttr.defend / (targetUnitAttr.defend + 200)
                else
                    local dfd = math.abs(targetUnitAttr.defend)
                    defendPercent = -dfd / (dfd * 0.33 + 100)
                end
                defendPercent = defendPercent * typeRatio[CONST_DAMAGE_TYPE.physical]
                lastDamagePercent = lastDamagePercent - defendPercent
            end
            -- 计算魔抗
            if (targetUnitAttr.resistance ~= 0 and typeRatio[CONST_DAMAGE_TYPE.magic] ~= nil) then
                local resistancePercent = 0
                if (targetUnitAttr.resistance >= 100) then
                    resistancePercent = -1
                else
                    resistancePercent = -targetUnitAttr.resistance * 0.01
                end
                resistancePercent = resistancePercent * typeRatio[CONST_DAMAGE_TYPE.magic]
                lastDamagePercent = lastDamagePercent - resistancePercent
            end
            -- 计算伤害增幅
            if (lastDamage > 0 and sourceUnit ~= nil and sourceUnitAttr.damage_extent ~= 0) then
                lastDamagePercent = lastDamagePercent + sourceUnitAttr.damage_extent * 0.01
            end
        end
        -- 合计 lastDamagePercent
        lastDamage = lastDamage * (1 + lastDamagePercent)
        if (isFixed == false) then
            -- 计算减伤
            local resistance = 0
            -- 固定值减少
            if (targetUnitAttr.damage_reduction > 0) then
                resistance = resistance + targetUnitAttr.damage_reduction
            end
            -- 百分比减少
            if (targetUnitAttr.damage_decrease > 0) then
                resistance = resistance + lastDamage * targetUnitAttr.damage_decrease * 0.01
            end
            if (resistance > 0) then
                if (resistance >= lastDamage) then
                    --@当减伤100%以上时触发事件,触发极限减伤抵抗事件
                    hevent.triggerEvent(
                        targetUnit,
                        CONST_EVENT.damageResistance,
                        {
                            triggerUnit = targetUnit,
                            sourceUnit = sourceUnit,
                            resistance = resistance,
                        }
                    )
                    lastDamage = 0
                else
                    lastDamage = lastDamage - resistance
                end
            end
        end
    end
    -- 上面都是先行计算
    if (lastDamage > 0.125 and his.deleted(targetUnit) == false) then
        -- 设置单位正在受伤
        local isBeDamagingTimer = hunit.get(targetUnit, "isBeDamagingTimer", nil)
        if (isBeDamagingTimer ~= nil) then
            htime.delTimer(isBeDamagingTimer)
            hunit.set(targetUnit, "isBeDamagingTimer", nil)
        end
        hunit.set(targetUnit, "isBeDamaging", true)
        hunit.set(targetUnit, "isBeDamagingTimer", htime.setTimeout(
            3.5,
            function(t)
                htime.delTimer(t)
                hunit.set(targetUnit, "isBeDamagingTimer", nil)
                hunit.set(targetUnit, "isBeDamaging", false)
            end
        ))
        if (sourceUnit ~= nil and his.deleted(sourceUnit) == false) then
            local isDamagingTimer = hunit.get(sourceUnit, "isDamagingTimer", nil)
            if (isDamagingTimer ~= nil) then
                htime.delTimer(isDamagingTimer)
                hunit.set(sourceUnit, "isDamagingTimer", nil)
            end
            hunit.set(sourceUnit, "isDamaging", true)
            hunit.set(targetUnit, "isBeDamagingTimer", htime.setTimeout(
                3.5,
                function(t)
                    htime.delTimer(t)
                    hunit.set(sourceUnit, "isDamagingTimer", nil)
                    hunit.set(sourceUnit, "isDamaging", false)
                end
            ))
            hevent.setLastDamageUnit(targetUnit, sourceUnit)
            hplayer.addDamage(hunit.getOwner(sourceUnit), lastDamage)
        end
        -- 造成伤害及漂浮字
        _damageTtg(targetUnit, lastDamage, damageString, damageStringColor)
        --
        hplayer.addBeDamage(hunit.getOwner(targetUnit), lastDamage)
        hunit.subCurLife(targetUnit, lastDamage)
        if (type(effect) == "string" and string.len(effect) > 0) then
            heffect.toXY(effect, hunit.x(targetUnit), hunit.y(targetUnit), 0)
        end
        -- @触发伤害事件
        if (sourceUnit ~= nil) then
            hevent.triggerEvent(
                sourceUnit,
                CONST_EVENT.damage,
                {
                    triggerUnit = sourceUnit,
                    targetUnit = targetUnit,
                    sourceUnit = sourceUnit,
                    damage = lastDamage,
                    damageSrc = damageSrc,
                    damageType = damageType
                }
            )
        end
        -- @触发被伤害事件
        hevent.triggerEvent(
            targetUnit,
            CONST_EVENT.beDamage,
            {
                triggerUnit = targetUnit,
                sourceUnit = sourceUnit,
                damage = lastDamage,
                damageSrc = damageSrc,
                damageType = damageType
            }
        )
        if (damageSrc == CONST_DAMAGE_SRC.attack) then
            if (sourceUnit ~= nil) then
                -- @触发攻击事件
                hevent.triggerEvent(
                    sourceUnit,
                    CONST_EVENT.attack,
                    {
                        triggerUnit = sourceUnit,
                        attacker = sourceUnit,
                        targetUnit = targetUnit,
                        damage = lastDamage,
                        damageSrc = damageSrc,
                        damageType = damageType
                    }
                )
            end
            -- @触发被攻击事件
            hevent.triggerEvent(
                targetUnit,
                CONST_EVENT.beAttack,
                {
                    triggerUnit = targetUnit,
                    attacker = sourceUnit,
                    targetUnit = targetUnit,
                    damage = lastDamage,
                    damageSrc = damageSrc,
                    damageType = damageType
                }
            )
        end
        -- 本体暴击
        if (isKnocking == true) then
            --@触发物理暴击事件
            hevent.triggerEvent(sourceUnit, CONST_EVENT.knocking, {
                triggerUnit = sourceUnit,
                targetUnit = targetUnit,
                damage = lastDamage,
                odds = sourceUnitAttr.knocking_odds,
                percent = sourceUnitAttr.knocking_extent
            })
            --@触发被物理暴击事件
            hevent.triggerEvent(targetUnit, CONST_EVENT.beKnocking, {
                triggerUnit = sourceUnit,
                sourceUnit = targetUnit,
                damage = lastDamage,
                odds = sourceUnitAttr.knocking_odds,
                percent = sourceUnitAttr.knocking_extent
            })
        end
        -- 吸血
        if (sourceUnit ~= nil and damageSrc == CONST_DAMAGE_SRC.attack) then
            local hemophagia = sourceUnitAttr.hemophagia - targetUnitAttr.hemophagia_oppose
            if (hemophagia > 0) then
                hunit.addCurLife(sourceUnit, lastDamage * hemophagia * 0.01)
                heffect.bindUnit(
                    "Abilities\\Spells\\Undead\\VampiricAura\\VampiricAuraTarget.mdl",
                    sourceUnit,
                    "origin",
                    1.00
                )
                -- @触发吸血事件
                hevent.triggerEvent(
                    sourceUnit,
                    CONST_EVENT.hemophagia,
                    {
                        triggerUnit = sourceUnit,
                        targetUnit = targetUnit,
                        value = lastDamage * hemophagia * 0.01,
                        percent = hemophagia,
                    }
                )
                -- @触发被吸血事件
                hevent.triggerEvent(
                    targetUnit,
                    CONST_EVENT.beHemophagia,
                    {
                        triggerUnit = targetUnit,
                        sourceUnit = sourceUnit,
                        value = lastDamage * hemophagia * 0.01,
                        percent = hemophagia,
                    }
                )
            end
        end
        -- 技能吸血
        if (sourceUnit ~= nil and damageSrc == CONST_DAMAGE_SRC.skill) then
            local hemophagiaSkill = sourceUnitAttr.hemophagia_skill - targetUnitAttr.hemophagia_skill_oppose
            if (hemophagiaSkill > 0) then
                hunit.addCurLife(sourceUnit, lastDamage * hemophagiaSkill * 0.01)
                heffect.bindUnit(
                    "Abilities\\Spells\\Items\\HealingSalve\\HealingSalveTarget.mdl",
                    sourceUnit,
                    "origin",
                    1.80
                )
                -- @触发技能吸血事件
                hevent.triggerEvent(
                    sourceUnit,
                    CONST_EVENT.skillHemophagia,
                    {
                        triggerUnit = sourceUnit,
                        targetUnit = targetUnit,
                        value = lastDamage * hemophagiaSkill * 0.01,
                        percent = hemophagiaSkill
                    }
                )
                -- @触发被技能吸血事件
                hevent.triggerEvent(
                    targetUnit,
                    CONST_EVENT.beSkillHemophagia,
                    {
                        triggerUnit = targetUnit,
                        sourceUnit = sourceUnit,
                        value = lastDamage * hemophagiaSkill * 0.01,
                        percent = hemophagiaSkill
                    }
                )
            end
        end
        -- 硬直
        local punish_during = 5.00
        if (lastDamage > 1 and his.alive(targetUnit) and his.punish(targetUnit) == false and hunit.isOpenPunish(targetUnit)) then
            hattr.set(targetUnit, 0, {
                punish_current = "-" .. lastDamage
            })
            if (targetUnitAttr.punish_current - lastDamage <= 0 and his.deleted(targetUnit) == false) then
                hunit.set(targetUnit, "isPunishing", true)
                htime.setTimeout(
                    punish_during + 1.00,
                    function(t)
                        htime.delTimer(t)
                        hunit.set(targetUnit, "isPunishing", false)
                    end
                )
                local punishEffectAttackSpeed = (100 + targetUnitAttr.attack_speed) * punishEffectRatio
                local punishEffectMove = targetUnitAttr.move * punishEffectRatio
                if (punishEffectAttackSpeed < 1) then
                    punishEffectAttackSpeed = 1.00
                end
                if (punishEffectMove < 1) then
                    punishEffectMove = 1.00
                end
                hattr.set(targetUnit, punish_during, {
                    attack_speed = "-" .. punishEffectAttackSpeed,
                    move = "-" .. punishEffectMove
                })
                htextTag.style(
                    htextTag.create2Unit(targetUnit, "僵硬", 6.00, "c0c0c0", 0, punish_during, 50.00),
                    "scale",
                    0,
                    0
                )
                -- @触发硬直事件
                hevent.triggerEvent(
                    targetUnit,
                    CONST_EVENT.heavy,
                    {
                        triggerUnit = targetUnit,
                        sourceUnit = sourceUnit,
                        percent = punishEffectRatio * 100,
                        during = punish_during
                    }
                )
            end
        end
        -- 反伤
        if (sourceUnit ~= nil and his.invincible(sourceUnit) == false) then
            local targetUnitDamageRebound = targetUnitAttr.damage_rebound - sourceUnitAttr.damage_rebound_oppose
            if (targetUnitDamageRebound > 0) then
                local ldr = math.round(lastDamage * targetUnitDamageRebound * 0.01)
                if (ldr > 0.01) then
                    hevent.setLastDamageUnit(sourceUnit, targetUnit)
                    hunit.subCurLife(sourceUnit, ldr)
                    htextTag.style(
                        htextTag.create2Unit(sourceUnit, "反伤" .. ldr, 12.00, "f8aaeb", 10, 1.00, 10.00),
                        "shrink",
                        0.05,
                        0
                    )
                    -- @触发反伤事件
                    hevent.triggerEvent(
                        targetUnit,
                        CONST_EVENT.rebound,
                        {
                            triggerUnit = targetUnit,
                            sourceUnit = sourceUnit,
                            damage = ldr
                        }
                    )
                    -- @触发被反伤事件
                    hevent.triggerEvent(
                        sourceUnit,
                        CONST_EVENT.beRebound,
                        {
                            triggerUnit = sourceUnit,
                            sourceUnit = targetUnit,
                            damage = ldr
                        }
                    )
                end
            end
        end
    end
end

--- 多频多段伤害
--- 特别适用于例如中毒，灼烧等效果
--[[
    options = {
        targetUnit = [unit], --受伤单位（必须有）
        frequency = 0, --伤害频率（必须有）
        times = 0, --伤害次数（必须有）
        extraInfluence = [function],
        -- 其他的和伤害函数一致，例如：
        effect = "", --特效（可选）
        damage = 0, --单次伤害（大于0）
        sourceUnit = [unit], --伤害来源单位（可选）
        damageSrc = CONST_DAMAGE_SRC, --伤害的种类（可选）
        damageType = CONST_DAMAGE_TYPE, --伤害的类型,注意是table（可选）
        isFixed = false, --是否固伤（可选）
    }
]]
hskill.damageStep = function(options)
    local times = options.times or 0
    local frequency = options.frequency or 0
    options.damage = options.damage or 0
    if (options.targetUnit == nil) then
        print_err("hskill.damageStep:-targetUnit")
        return
    end
    if (times <= 0 or options.damage <= 0) then
        print_err("hskill.damageStep:-times -damage")
        return
    end
    if (times > 1 and frequency <= 0) then
        print_err("hskill.damageStep:-frequency")
        return
    end
    if (times <= 1) then
        hskill.damage(options)
        if (type(options.extraInfluence) == "function") then
            options.extraInfluence(options.targetUnit)
        end
    else
        local ti = 0
        htime.setInterval(
            frequency,
            function(t)
                ti = ti + 1
                if (ti > times) then
                    htime.delTimer(t)
                    return
                end
                hskill.damage(options)
                if (type(options.extraInfluence) == "function") then
                    options.extraInfluence(options.targetUnit)
                end
            end
        )
    end
end

--- 范围持续伤害
--[[
    options = {
        radius = 0, --半径范围（必须有）
        frequency = 0, --伤害频率（必须有）
        times = 0, --伤害次数（必须有）
        effect = "", --特效（可选）
        effectSingle = "", --单体特效（可选）
        filter = [function], --必须有
        whichUnit = [unit], --中心单位的位置（可选）
        whichLoc = [location], --目标点（可选）
        x = [point], --目标坐标X（可选）
        y = [point], --目标坐标Y（可选）
        damage = 0, --伤害（可选，但是这里可以等于0）
        sourceUnit = [unit], --伤害来源单位（可选）
        damageSrc = CONST_DAMAGE_SRC, --伤害的种类（可选）
        damageType = CONST_DAMAGE_TYPE, --伤害的类型,注意是table（可选）
        isFixed = false, --是否固伤（可选）
        extraInfluence = [function],
    }
]]
hskill.damageRange = function(options)
    local radius = options.radius or 0
    local times = options.times or 0
    local frequency = options.frequency or 0
    local damage = options.damage or 0
    if (radius <= 0 or times <= 0) then
        print_err("hskill.damageRange:-radius -times")
        return
    end
    if (times > 1 and frequency <= 0) then
        print_err("hskill.damageRange:-frequency")
        return
    end
    local x, y
    if (options.x ~= nil or options.y ~= nil) then
        x = options.x
        y = options.y
    elseif (options.whichUnit ~= nil) then
        x = hunit.x(options.whichUnit)
        y = hunit.y(options.whichUnit)
    elseif (options.whichLoc ~= nil) then
        x = cj.GetLocatonX(options.whichLoc)
        y = cj.GetLocatonY(options.whichLoc)
    end
    if (x == nil or y == nil) then
        print_err("hskill.damageRange:-x -y")
        return
    end
    local filter = options.filter
    if (type(filter) ~= "function") then
        print_err("filter must be function")
        return
    end
    if (options.effect ~= nil) then
        heffect.toXY(options.effect, x, y, 0.25 + (times * frequency))
    end
    if (times <= 1) then
        local g = hgroup.createByXY(x, y, radius, filter)
        if (g == nil) then
            return
        end
        if (hgroup.count(g) <= 0) then
            return
        end
        hgroup.loop(
            g,
            function(eu)
                hskill.damage(
                    {
                        sourceUnit = options.sourceUnit,
                        targetUnit = eu,
                        effect = options.effectSingle,
                        damage = damage,
                        damageSrc = options.damageSrc,
                        damageType = options.damageType,
                        isFixed = options.isFixed,
                    }
                )
                if (type(options.extraInfluence) == "function") then
                    options.extraInfluence(eu)
                end
            end,
            true
        )
    else
        local ti = 0
        htime.setInterval(
            frequency,
            function(t)
                ti = ti + 1
                if (ti > times) then
                    htime.delTimer(t)
                    return
                end
                local g = hgroup.createByXY(x, y, radius, filter)
                if (g == nil) then
                    return
                end
                if (hgroup.count(g) <= 0) then
                    return
                end
                hgroup.loop(
                    g,
                    function(eu)
                        hskill.damage(
                            {
                                sourceUnit = options.sourceUnit,
                                targetUnit = eu,
                                effect = options.effectSingle,
                                damage = damage,
                                damageSrc = options.damageSrc,
                                damageType = options.damageType,
                                isFixed = options.isFixed,
                            }
                        )
                        if (type(options.extraInfluence) == "function") then
                            options.extraInfluence(eu)
                        end
                    end,
                    true
                )
            end
        )
    end
end

--[[
    单位组持续伤害
    options = {
        frequency = 0, --伤害频率（必须有）
        times = 0, --伤害次数（必须有）
        effect = "", --伤害特效（可选）
        whichGroup = [group], --单位组（必须有）
        damage = 0, --伤害（可选，但是这里可以等于0）
        sourceUnit = [unit], --伤害来源单位（可选）
        damageSrc = CONST_DAMAGE_SRC, --伤害的种类（可选）
        damageType = CONST_DAMAGE_TYPE, --伤害的类型,注意是table（可选）
        isFixed = false, --是否固伤（可选）
        extraInfluence = [function],
    }
]]
hskill.damageGroup = function(options)
    local times = options.times or 0
    local frequency = options.frequency or 0
    local damage = options.damage or 0
    if (options.whichGroup == nil) then
        print_err("hskill.damageGroup:-whichGroup")
        return
    end
    if (times <= 0 or frequency < 0) then
        print_err("hskill.damageGroup:-times -frequency")
        return
    end
    if (times <= 1) then
        hgroup.loop(
            options.whichGroup,
            function(eu)
                hskill.damage(
                    {
                        sourceUnit = options.sourceUnit,
                        targetUnit = eu,
                        effect = options.effect,
                        damage = damage,
                        damageSrc = options.damageSrc,
                        damageType = options.damageType,
                        isFixed = options.isFixed,
                    }
                )
                if (type(options.extraInfluence) == "function") then
                    options.extraInfluence(eu)
                end
            end
        )
    else
        local ti = 0
        htime.setInterval(
            frequency,
            function(t)
                ti = ti + 1
                if (ti > times) then
                    htime.delTimer(t)
                    return
                end
                hgroup.loop(
                    options.whichGroup,
                    function(eu)
                        hskill.damage(
                            {
                                sourceUnit = options.sourceUnit,
                                targetUnit = eu,
                                effect = options.effect,
                                damage = damage,
                                damageSrc = options.damageSrc,
                                damageType = options.damageType,
                                isFixed = options.isFixed,
                            }
                        )
                        if (type(options.extraInfluence) == "function") then
                            options.extraInfluence(eu)
                        end
                    end
                )
            end
        )
    end
end
