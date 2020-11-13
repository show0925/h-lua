--- 属性系统，事件密切的功能扩展支持的事件
hattribute.xtrasSupportEvents = {
    CONST_EVENT.attack, CONST_EVENT.beAttack,
    CONST_EVENT.skill, CONST_EVENT.beSkill,
    CONST_EVENT.item, CONST_EVENT.beItem,
    CONST_EVENT.damage, CONST_EVENT.beDamage,
    CONST_EVENT.attackDetect, CONST_EVENT.attackGetTarget, CONST_EVENT.attackReady, CONST_EVENT.beAttackReady,
    CONST_EVENT.killStudy, CONST_EVENT.skillReady, CONST_EVENT.skillCast, CONST_EVENT.skillEffect, CONST_EVENT.skillStop, CONST_EVENT.skillFinish,
    CONST_EVENT.itemUsed, CONST_EVENT.itemSell, CONST_EVENT.unitSell, CONST_EVENT.itemDrop, CONST_EVENT.itemPawn, CONST_EVENT.itemGet,
    CONST_EVENT.itemSynthesis, CONST_EVENT.itemSeparate, CONST_EVENT.itemOverWeight, CONST_EVENT.itemOverSlot,
    CONST_EVENT.damageResistance,
    CONST_EVENT.avoid, CONST_EVENT.beAvoid, CONST_EVENT.breakArmor, CONST_EVENT.beBreakArmor,
    CONST_EVENT.swim, CONST_EVENT.beSwim, CONST_EVENT.broken, CONST_EVENT.beBroken,
    CONST_EVENT.silent, CONST_EVENT.beSilent, CONST_EVENT.unarm, CONST_EVENT.beUnarm, CONST_EVENT.fetter, CONST_EVENT.beFetter,
    CONST_EVENT.bomb, CONST_EVENT.beBomb,
    CONST_EVENT.lightningChain, CONST_EVENT.beLightningChain,
    CONST_EVENT.crackFly, CONST_EVENT.beCrackFly,
    CONST_EVENT.rebound, CONST_EVENT.beRebound,
    CONST_EVENT.noAvoid, CONST_EVENT.beNoAvoid,
    CONST_EVENT.knocking, CONST_EVENT.beKnocking, CONST_EVENT.violence, CONST_EVENT.beViolence, CONST_EVENT.spilt, CONST_EVENT.beSpilt,
    CONST_EVENT.hemophagia, CONST_EVENT.beHemophagia, CONST_EVENT.skillHemophagia, CONST_EVENT.beSkillHemophagia,
    CONST_EVENT.punish, CONST_EVENT.dead, CONST_EVENT.kill, CONST_EVENT.reborn, CONST_EVENT.levelUp,
    CONST_EVENT.moveStart, CONST_EVENT.moving, CONST_EVENT.moveStop, CONST_EVENT.holdOn, CONST_EVENT.stop,
}

--- 属性系统，事件密切的功能扩展
--- 以事件的handle作为主引导，例如attack事件的引导就是攻击者，而beDamage事件的引导就是受伤者
--- action为字符串分三段：
--- triggerUnit.attr.attack_speed
--- [ 作用目标 ].[类型].[ 效果参数 ]
--- | - [作用目标] 范围是 hevent 回调时 evtData 相关单位
--- | - [类型] 暂分为 attr(属性改动，攻速攻击等) 和 spec(特别效果，暴击击飞等)
--- | - [效果参数] 如attr时，可以填attack_speed改攻速，而effect时可以填knocking触发暴击
--- | - [其他参数] odds(几率>0)/val(值|伤害~=0)/dur(持续时间>0)/effect(特效字串)
--- | - [其他参数] percent(程度>0)/radius(半径范围>0)/qty(数量>0)/reduce(衰减)/distance(距离)/height(高度)
--- 惯用例子：
--- hattr.set(unit, 0, {
--        xtras = {
--            add = {
--                { on = CONST_EVENT.attack, action = "triggerUnit.attr.attack_speed", odds = 20.0, val = 1.5, dur = 3.0, effect = nil },
--                { on = CONST_EVENT.attack, action = "attack.attr.attack_speed", odds = 20.0, val = 1.5, dur = 3.0, effect = nil },
--                { on = CONST_EVENT.skill, action = "attack.attr.attack_green", odds = 20.0, val = 2, dur = 3.0, effect = nil },
--                { on = CONST_EVENT.attack, action = "targetUnit.spec.knocking", odds = 100, percent = 100, effect = nil },
--                { on = CONST_EVENT.skill, action = "targetUnit.spec.violence", odds = 100, percent = 100, effect = nil },
--                { on = CONST_EVENT.attack, action = "targetUnit.spec.split", odds = 100, percent = 30, radius = 250 },
--                { on = CONST_EVENT.attack, action = "targetUnit.spec.swim",odds = 0.0, val = 0.0, dur = 0.0, effect = nil},
--                { on = CONST_EVENT.attack, action = "targetUnit.spec.broken",odds = 0.0, val = 0.0, dur = 0.0, effect = nil},
--                { on = CONST_EVENT.attack, action = "targetUnit.spec.silent",odds = 0.0, val = 0.0, dur = 0.0, effect = nil},
--                { on = CONST_EVENT.attack, action = "targetUnit.spec.unarm",odds = 0.0, val = 0.0, dur = 0.0, effect = nil},
--                { on = CONST_EVENT.attack, action = "targetUnit.spec.fetter",odds = 0.0, val = 0.0, dur = 0.0, effect = nil},
--                { on = CONST_EVENT.attack, action = "targetUnit.spec.bomb",odds = 0.0, radius = 0.0, val = 0.0, dur = 0.0, effect = nil},
--                { on = CONST_EVENT.damage, action = "targetUnit.spec.lightning_chain", odds = 50, val = 100, qty = 0, reduce = 0.0 },
--                { on = CONST_EVENT.beDamage, action = "sourceUnit.spec.crack_fly", odds = 50, val = 100, distance = 300, height = 200, dur = 0.5 },
--            }
--        },
--  })
---@private
hattribute.xtras = function(handleUnit, key, evtData)
    if (handleUnit == nil or key == nil or evtData == nil) then
        return
    end
    -- 排除不支持的事件
    if (table.includes(key, hattribute.xtrasSupportEvents) == false) then
        return
    end
    -- 排除非单位
    if (hunit.getName(handleUnit) == nil) then
        return
    end
    -- 排除死亡单位，删除单位
    if (his.dead(handleUnit) or his.deleted(handleUnit)) then
        return
    end
    -- 获取属性
    local xtras = hattribute.get(handleUnit, 'xtras')
    if (xtras == nil or type(xtras) ~= 'table') then
        return
    end
    for _, xtra in ipairs(xtras) do
        local x = xtra.table
        if (x.on == key and type(x.action) == 'string') then
            local actions = string.explode('.', x.action)
            if (#actions == 3) then
                local target = actions[1]
                local actionType = actions[2]
                if (table.includes(actionType, { 'attr', 'spec' }) ~= false) then
                    if (evtData[target] ~= nil and hunit.getName(evtData[target]) ~= nil) then
                        if (his.alive(evtData[target]) and his.deleted(evtData[target]) == false) then
                            local targetUnit = evtData[target]
                            local actionField = actions[3]
                            if (actionType == 'attr') then
                                if (x.val ~= 0 and x.dur > 0 and math.random(1, 1000) <= x.odds * 10) then
                                    -- 判断是否buff/debuff(判断基准就是判断val是否大于/小于0)
                                    -- buff时，要计算目标单位的buff阻碍（如:可以设计一个boss造成强化阻碍，影响玩家的被动加成）
                                    -- debuff时，要计算目标单位的debuff抵抗（如:可以设计一个物品抵抗debuff，减少影响）
                                    -- 以上两个都是大于0才有效
                                    if (x.val > 0) then
                                        -- buff; > 0
                                        local buff_oppose = hattribute.get(targetUnit, 'buff_oppose')
                                        if (buff_oppose > 0) then
                                            x.val = x.val * (1 - 0.01 * buff_oppose)
                                        end
                                        if (x.val > 0) then
                                            hattr.set(targetUnit, x.dur, { [actionField] = "+" .. x.val })
                                            if (type(x.effect) == "string" and string.len(x.effect) > 0) then
                                                heffect.bindUnit(x.effect, targetUnit, "origin", x.dur)
                                            end
                                        end
                                    else
                                        -- debuff; < 0
                                        local debuff_oppose = hattribute.get(targetUnit, 'debuff_oppose')
                                        if (debuff_oppose > 0) then
                                            x.val = x.val * (1 - 0.01 * debuff_oppose)
                                        end
                                        if (x.val < 0) then
                                            hattr.set(targetUnit, x.dur, { [actionField] = tostring(x.val) })
                                            if (type(x.effect) == "string" and string.len(x.effect) > 0) then
                                                heffect.bindUnit(x.effect, targetUnit, "origin", x.dur)
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end