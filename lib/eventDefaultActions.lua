--- 框架默认事件动作
--- default event actions
hevent_default_actions = {
    player = {
        esc = cj.Condition(function()
            hevent.triggerEvent(
                cj.GetTriggerPlayer(),
                CONST_EVENT.esc,
                {
                    triggerPlayer = cj.GetTriggerPlayer()
                }
            )
        end),
        deSelection = cj.Condition(function()
            hevent.triggerEvent(
                cj.GetTriggerPlayer(),
                CONST_EVENT.deSelection,
                {
                    triggerPlayer = cj.GetTriggerPlayer(),
                    triggerUnit = cj.GetTriggerUnit()
                }
            )
        end),
        constructStart = cj.Condition(function()
            hevent.triggerEvent(
                hunit.getOwner(cj.GetTriggerUnit()),
                CONST_EVENT.constructStart,
                {
                    triggerUnit = cj.GetTriggerUnit()
                }
            )
        end),
        constructCancel = cj.Condition(function()
            hevent.triggerEvent(
                hunit.getOwner(cj.GetTriggerUnit()),
                CONST_EVENT.constructCancel,
                {
                    triggerUnit = cj.GetCancelledStructure()
                }
            )
        end),
        constructFinish = cj.Condition(function()
            hevent.triggerEvent(
                hunit.getOwner(cj.GetTriggerUnit()),
                CONST_EVENT.constructFinish,
                {
                    triggerUnit = cj.GetConstructedStructure()
                }
            )
        end),
        apm = cj.Condition(function()
            local p = hunit.getOwner(cj.GetTriggerUnit())
            if (his.playing(p) == true and his.playerSite(p) == true and his.computer(p) == false) then
                hplayer.set(p, "apm", hplayer.get(p, "apm", 0) + 1)
            end
        end),
        command = function()
            local p = cj.GetTriggerPlayer()
            local str = string.lower(cj.GetEventPlayerChatString())
            if (str == "-apc") then
                if (hplayer.getIsAutoConvert(p) == true) then
                    hplayer.setIsAutoConvert(p, false)
                    echo("|cffffcc00已关闭|r自动换算", p)
                else
                    hplayer.setIsAutoConvert(p, true)
                    echo("|cffffcc00已开启|r自动换算", p)
                end
            elseif (str == "-apm") then
                echo("您的apm为:" .. hplayer.getApm(p), p)
            elseif (str == "-eff") then
                if (hplayer.qty_current == 1) then
                    if (heffect.enable == true) then
                        heffect.enable = false
                        hlightning.enable = false
                        echo("|cffffcc00已关闭|r大部分特效", p)
                    else
                        heffect.enable = true
                        hlightning.enable = true
                        echo("|cffffcc00已开启|r大部分特效", p)
                    end
                else
                    echo("此命令仅在单人时有效", p)
                end
            elseif (str == "-gg") then
                hplayer.defeat(p, "GG")
            elseif (str == "-random") then
                if (#hhero.selectorPool <= 0 or hplayer.getAllowCommandPick(p) ~= true) then
                    echo("-random命令被禁用", p)
                    return
                end
                local pIndex = hplayer.index(p)
                if (#hhero.player_heroes[pIndex] >= hhero.player_allow_qty[pIndex]) then
                    echo("|cffffff80你已经选够了|r", p)
                    return
                end
                local txt = ""
                local qty = 0
                while (true) do
                    local one = table.random(hhero.selectorPool)
                    table.delete(one, hhero.selectorPool)
                    local u = one
                    if (type(one) == 'string') then
                        u = hunit.create(
                            {
                                whichPlayer = p,
                                unitId = one,
                                x = hhero.bornX,
                                y = hhero.bornY
                            }
                        )
                        hRuntime.hero[u] = {
                            selector = hRuntime.hero[one],
                        }
                        cj.RemoveUnitFromStock(hRuntime.hero[one], string.char2id(one))
                    else
                        table.delete(one, hhero.selectorClearPool)
                        hunit.setInvulnerable(u, false)
                        cj.SetUnitOwner(u, p, true)
                        hunit.portal(u, hhero.bornX, hhero.bornY)
                        cj.PauseUnit(u, false)
                    end
                    table.insert(hhero.player_heroes[pIndex], u)
                    -- 触发英雄被选择事件(全局)
                    hevent.triggerEvent(
                        "global",
                        CONST_EVENT.pickHero,
                        {
                            triggerPlayer = p,
                            triggerUnit = u
                        }
                    )
                    txt = txt .. " " .. cj.GetUnitName(u)
                    qty = qty + 1
                    if (#hhero.player_heroes[pIndex] >= hhero.player_allow_qty[pIndex]) then
                        break
                    end
                end
                echo("已为您 |cffffff80random|r 挑选了 " .. "|cffffff80" .. math.floor(qty) .. "|r 个：|cffffff80" .. txt .. "|r", p)
            elseif (str == "-repick") then
                if (#hhero.selectorPool <= 0 or hplayer.getAllowCommandPick(p) ~= true) then
                    echo("-repick命令被禁用", p)
                    return
                end
                local pIndex = hplayer.index(p)
                if (#hhero.player_heroes[pIndex] <= 0) then
                    echo("|cffffff80你还没有选过任何单位|r", p)
                    return
                end
                local qty = #hhero.player_heroes[pIndex]
                for _, u in ipairs(hhero.player_heroes[pIndex]) do
                    if (type(hRuntime.hero[u].selector) == "userdata") then
                        table.insert(hhero.selectorPool, hunit.getId(u))
                        cj.AddUnitToStock(hRuntime.hero[u].selector, cj.GetUnitTypeId(u), 1, 1)
                    else
                        local new = hunit.create(
                            {
                                whichPlayer = cj.Player(PLAYER_NEUTRAL_PASSIVE),
                                unitId = cj.GetUnitTypeId(u),
                                x = hRuntime.hero[u].selector[1],
                                y = hRuntime.hero[u].selector[2],
                                isInvulnerable = true,
                                isPause = true
                            }
                        )
                        hRuntime.hero[new] = {
                            selector = { hRuntime.hero[u].selector[1], hRuntime.hero[u].selector[2] },
                        }
                        table.insert(hhero.selectorClearPool, new)
                        table.insert(hhero.selectorPool, new)
                    end
                    hunit.del(u, 0)
                end
                hhero.player_heroes[pIndex] = {}
                echo("已为您 |cffffff80repick|r 了 " .. "|cffffff80" .. qty .. "|r 个单位", p)
            else
                local first = string.sub(str, 1, 1)
                if (first == "+" or first == "-") then
                    --视距
                    local v = string.sub(str, 2, string.len(str))
                    v = tonumber(v)
                    if (v == nil) then
                        return
                    else
                        local val = math.abs(v)
                        if (first == "+") then
                            hcamera.changeDistance(p, val)
                        elseif (first == "-") then
                            hcamera.changeDistance(p, -val)
                        end
                    end
                end
            end
        end,
        leave = cj.Condition(function()
            local p = cj.GetTriggerPlayer()
            hplayer.set(p, "status", hplayer.player_status.leave)
            echo(cj.GetPlayerName(p) .. "离开了游戏～")
            hplayer.clearUnit(p)
            hplayer.qty_current = hplayer.qty_current - 1
            -- 触发玩家离开事件(全局)
            hevent.triggerEvent(
                "global",
                CONST_EVENT.playerLeave,
                {
                    triggerPlayer = p
                }
            )
        end),
        selection = cj.Condition(function()
            local triggerPlayer = cj.GetTriggerPlayer()
            local triggerUnit = cj.GetTriggerUnit()
            local click = hplayer.get(triggerPlayer, 'click', nil)
            if (click == nil) then
                click = 0
            end
            hplayer.set(triggerPlayer, 'click', click + 1)
            htime.setTimeout(
                0.3,
                function(ct)
                    htime.delTimer(ct)
                    hplayer.set(triggerPlayer, 'click', hplayer.get(triggerPlayer, 'click') - 1)
                end
            )
            for qty = 1, 10 do
                if (hplayer.get(triggerPlayer, 'click') >= qty) then
                    hevent.triggerEvent(
                        triggerPlayer,
                        CONST_EVENT.selection .. "#" .. qty,
                        {
                            triggerPlayer = triggerPlayer,
                            triggerUnit = triggerUnit,
                            qty = qty
                        }
                    )
                end
            end
        end),
    },
    unit = {
        attackDetect = cj.Condition(function()
            hevent.triggerEvent(
                cj.GetTriggerUnit(),
                CONST_EVENT.attackDetect,
                {
                    triggerUnit = cj.GetTriggerUnit(),
                    targetUnit = cj.GetEventTargetUnit()
                }
            )
        end),
        attackGetTarget = cj.Condition(function()
            hevent.triggerEvent(
                cj.GetTriggerUnit(),
                CONST_EVENT.attackGetTarget,
                {
                    triggerUnit = cj.GetTriggerUnit(),
                    targetUnit = cj.GetEventTargetUnit()
                }
            )
        end),
        beAttackReady = cj.Condition(function()
            hevent.triggerEvent(
                cj.GetTriggerUnit(),
                CONST_EVENT.beAttackReady,
                {
                    triggerUnit = cj.GetTriggerUnit(),
                    targetUnit = cj.GetAttacker(),
                    attacker = cj.GetAttacker()
                }
            )
        end),
        skillStudy = cj.Condition(function()
            hevent.triggerEvent(
                cj.GetTriggerUnit(),
                CONST_EVENT.skillStudy,
                {
                    triggerUnit = cj.GetTriggerUnit(),
                    triggerSkill = cj.GetLearnedSkill()
                }
            )
        end),
        skillReady = cj.Condition(function()
            hevent.triggerEvent(
                cj.GetTriggerUnit(),
                CONST_EVENT.skillReady,
                {
                    triggerUnit = cj.GetTriggerUnit(),
                    triggerSkill = cj.GetSpellAbilityId(),
                    targetUnit = cj.GetSpellTargetUnit(),
                    targetLoc = cj.GetSpellTargetLoc()
                }
            )
        end),
        skillCast = cj.Condition(function()
            hevent.triggerEvent(
                cj.GetTriggerUnit(),
                CONST_EVENT.skillCast,
                {
                    triggerUnit = cj.GetTriggerUnit(),
                    triggerSkill = cj.GetSpellAbilityId(),
                    targetUnit = cj.GetSpellTargetUnit(),
                    targetLoc = cj.GetSpellTargetLoc()
                }
            )
        end),
        skillStop = cj.Condition(function()
            hevent.triggerEvent(
                cj.GetTriggerUnit(),
                CONST_EVENT.skillStop,
                {
                    triggerUnit = cj.GetTriggerUnit(),
                    triggerSkill = cj.GetSpellAbilityId()
                }
            )
        end),
        skillEffect = cj.Condition(function()
            hevent.triggerEvent(
                cj.GetTriggerUnit(),
                CONST_EVENT.skillEffect,
                {
                    triggerUnit = cj.GetTriggerUnit(),
                    triggerSkill = cj.GetSpellAbilityId(),
                    targetUnit = cj.GetSpellTargetUnit(),
                    targetLoc = cj.GetSpellTargetLoc()
                }
            )
        end),
        skillFinish = cj.Condition(function()
            hevent.triggerEvent(
                cj.GetTriggerUnit(),
                CONST_EVENT.skillFinish,
                {
                    triggerUnit = cj.GetTriggerUnit(),
                    triggerSkill = cj.GetSpellAbilityId()
                }
            )
        end),
        upgradeStart = cj.Condition(function()
            hevent.triggerEvent(
                cj.GetTriggerUnit(),
                CONST_EVENT.upgradeStart,
                {
                    triggerUnit = cj.GetTriggerUnit(),
                }
            )
        end),
        upgradeCancel = cj.Condition(function()
            hevent.triggerEvent(
                cj.GetTriggerUnit(),
                CONST_EVENT.upgradeCancel,
                {
                    triggerUnit = cj.GetTriggerUnit(),
                }
            )
        end),
        upgradeFinish = cj.Condition(function()
            hevent.triggerEvent(
                cj.GetTriggerUnit(),
                CONST_EVENT.upgradeFinish,
                {
                    triggerUnit = cj.GetTriggerUnit(),
                }
            )
        end),
        damaged = cj.Condition(function()
            local sourceUnit = cj.GetEventDamageSource()
            local targetUnit = cj.GetTriggerUnit()
            local damage = cj.GetEventDamage()
            local curLife = hunit.getCurLife(targetUnit)
            local isLethal = curLife <= damage
            if (damage > 0.125) then
                local changeLife = math.floor(damage) + 1
                if (isLethal == true) then
                    cj.SetUnitInvulnerable(targetUnit, true)
                else
                    hattr.set(targetUnit, 0, { life = "+" .. changeLife })
                end
                htime.setTimeout(
                    0,
                    function(t)
                        htime.delTimer(t)
                        if (isLethal == true) then
                            cj.SetUnitInvulnerable(targetUnit, false)
                        else
                            hattr.set(targetUnit, 0, { life = "-" .. changeLife })
                            hunit.setCurLife(targetUnit, curLife)
                        end
                        hskill.damage(
                            {
                                sourceUnit = sourceUnit,
                                targetUnit = targetUnit,
                                damage = damage,
                                damageKind = "attack"
                            }
                        )
                    end
                )
            end
        end),
        death = cj.Condition(function()
            local u = cj.GetTriggerUnit()
            local killer = hevent.getLastDamageUnit(u)
            if (killer ~= nil) then
                hplayer.addKill(hunit.getOwner(killer), 1)
            end
            -- @触发死亡事件
            hevent.triggerEvent(
                u,
                CONST_EVENT.dead,
                {
                    triggerUnit = u,
                    killer = killer
                }
            )
            -- @触发击杀事件
            hevent.triggerEvent(
                killer,
                CONST_EVENT.kill,
                {
                    triggerUnit = killer,
                    killer = killer,
                    targetUnit = u
                }
            )
        end),
        sell = cj.Condition(function()
            local u = cj.GetSoldUnit()
            hunit.embed(u)
            hevent.triggerEvent(
                cj.GetSellingUnit(),
                CONST_EVENT.unitSell,
                {
                    triggerUnit = cj.GetSellingUnit(),
                    soldUnit = u,
                    buyingUnit = cj.GetBuyingUnit(),
                }
            )
        end),
    },
    hero = {
        levelUp = cj.Condition(function()
            local u = cj.GetTriggerUnit()
            local diffLv = cj.GetHeroLevel(u) - hhero.getPrevLevel(u)
            if (diffLv < 1) then
                return
            end
            hhero.setPrevLevel(u, cj.GetHeroLevel(u))
            hattr.set(u, 0, {
                str_white = "=" .. cj.GetHeroStr(u, false),
                agi_white = "=" .. cj.GetHeroAgi(u, false),
                int_white = "=" .. cj.GetHeroInt(u, false)
            })
            -- @触发升级事件
            hevent.triggerEvent(
                u,
                CONST_EVENT.levelUp,
                {
                    triggerUnit = u,
                    value = diffLv
                }
            )
        end)
    },
    dialog = {
        click = cj.Condition(function()
            local clickedDialog = cj.GetClickedDialog()
            local clickedButton = cj.GetClickedButton()
            local val
            for _, b in ipairs(hRuntime.dialog[clickedDialog].buttons) do
                if (b.button == clickedButton) then
                    val = b.value
                end
            end
            if (type(hRuntime.dialog[clickedDialog].action) == 'function') then
                hRuntime.dialog[clickedDialog].action(val)
            end
            hdialog.del(clickedDialog)
        end)
    },
    item = {
        pickup = cj.Condition(function()
            local it = cj.GetManipulatedItem()
            local itId = string.id2char(cj.GetItemTypeId(it))
            if (hslk_global.id2Value.item[itId] == nil) then
                -- 排除掉没有注册进hslk_global的物品
                return
            end
            if (hRuntime.item[it] ~= nil and hRuntime.item[it].positionType == hitem.POSITION_TYPE.UNIT) then
                -- 排除掉runtime内已创建给unit的物品
                return
            end
            local u = cj.GetTriggerUnit()
            local charges = cj.GetItemCharges(it)
            local shadowItId = hitem.getShadowMappingId(itId)
            if (shadowItId == nil) then
                if (hitem.getIsPowerUp(itId) == true) then
                    --触发使用物品事件
                    hevent.triggerEvent(
                        u,
                        CONST_EVENT.itemUsed,
                        {
                            triggerUnit = u,
                            triggerItem = it
                        }
                    )
                    --检测是否有匹配使用
                    if (#hitem.MATCH_ITEM_USED > 0) then
                        local itemName = cj.GetItemName(it)
                        for _, m in ipairs(hitem.MATCH_ITEM_USED) do
                            local s, e = string.find(itemName, m[1])
                            if (s ~= nil and e ~= nil) then
                                m[2]({ triggerUnit = u, triggerItem = it })
                            end
                        end
                    end
                else
                    --这里删除重建是为了实现地上物品的过期重置
                    hitem.del(it, 0)
                    hitem.create(
                        {
                            itemId = itId,
                            whichUnit = u,
                            charges = charges,
                            during = 0
                        }
                    )
                end
            else
                --注意，系统内此处先获得了face物品，此物品100%是PowerUp的
                --这里删除重建是为了实现地上物品的过期重置
                hitem.del(it, 0)
                --这里是实现神符满格的关键
                hitem.create(
                    {
                        itemId = shadowItId,
                        whichUnit = u,
                        charges = charges,
                        during = 0
                    }
                )
            end
        end),
        drop = cj.Condition(function()
            local u = cj.GetTriggerUnit()
            local it = cj.GetManipulatedItem()
            local itId = string.id2char(cj.GetItemTypeId(it))
            local faceId = hitem.getShadowMappingId(itId)
            local orderId = cj.OrderId("dropitem")
            local charges = cj.GetItemCharges(it)
            if (cj.GetUnitCurrentOrder(u) == orderId) then
                if (hRuntime.item[it] ~= nil) then
                    if (faceId ~= nil) then
                        htime.setTimeout(
                            0,
                            function(t)
                                htime.delTimer(t)
                                local x = cj.GetItemX(it)
                                local y = cj.GetItemX(it)
                                hitem.del(it, 0)
                                --这里是实现表面物品的关键
                                it = hitem.create(
                                    {
                                        itemId = faceId,
                                        x = x,
                                        y = y,
                                        charges = charges,
                                        during = 0
                                    }
                                )
                            end
                        )
                    else
                        hitem.setPositionType(it, hitem.POSITION_TYPE.COORDINATE)
                    end
                end
                hitem.subAttribute(u, itId, charges)
                --触发丢弃物品事件
                hevent.triggerEvent(
                    u,
                    CONST_EVENT.itemDrop,
                    {
                        triggerUnit = u,
                        triggerItem = it,
                        targetUnit = cj.GetOrderTargetUnit(),
                    }
                )
            end
        end),
        pawn = cj.Condition(function()
            --[[
                抵押物品的原理，首先默认是设定：物品售卖为50%，也就是地图的默认设置
                根据玩家的sellRatio，额外的减少或增加玩家的收入
                从而实现玩家的售卖率提升，至于物品的价格是根据slk获取
                所以如果无法获取slk的属性时，此方法自动无效
            ]]
            local u = cj.GetTriggerUnit()
            local it = cj.GetSoldItem()
            local goldcost = hitem.getGoldCost(it)
            local lumbercost = hitem.getLumberCost(it)
            local soldGold = 0
            local soldLumber = 0
            hRuntime.clear(it)
            if (goldcost ~= 0 or lumbercost ~= 0) then
                local p = hunit.getOwner(u)
                local sellRatio = hplayer.getSellRatio(u)
                if (sellRatio ~= 50) then
                    if (sellRatio < 0) then
                        sellRatio = 0
                    elseif (sellRatio > 1000) then
                        sellRatio = 1000
                    end
                    local tempRatio = sellRatio - 50.0
                    soldGold = math.floor(goldcost * tempRatio * 0.01)
                    soldLumber = math.floor(lumbercost * tempRatio * 0.01)
                    if (goldcost ~= 0 and soldGold ~= 0) then
                        hplayer.addGold(p, soldGold)
                    end
                    if (lumbercost ~= 0 and soldLumber ~= 0) then
                        hplayer.addLumber(p, soldLumber)
                    end
                end
            end
            --触发抵押物品事件
            hevent.triggerEvent(
                u,
                CONST_EVENT.itemPawn,
                {
                    triggerUnit = u,
                    soldItem = it,
                    buyingUnit = cj.GetBuyingUnit(),
                    soldGold = soldGold,
                    soldLumber = soldLumber,
                }
            )
        end),
        use = cj.Condition(function()
            local u = cj.GetTriggerUnit()
            local it = cj.GetManipulatedItem()
            local itId = cj.GetItemTypeId(it)
            local perishable = hitem.getIsPerishable(itId)
            --检测是否使用后自动消失，如果不是，次数补回1
            if (perishable == false) then
                hitem.setCharges(it, hitem.getCharges(it) + 1)
            else
                hitem.subAttribute(u, itId, 1)
            end
            --触发使用物品事件
            hevent.triggerEvent(
                u,
                CONST_EVENT.itemUsed,
                {
                    triggerUnit = u,
                    triggerItem = it
                }
            )
            --检测是否有匹配使用
            if (#hitem.MATCH_ITEM_USED > 0) then
                local itemName = cj.GetItemName(it)
                for _, m in ipairs(hitem.MATCH_ITEM_USED) do
                    local s, e = string.find(itemName, m[1])
                    if (s ~= nil and e ~= nil) then
                        m[2]({ triggerUnit = u, triggerItem = it })
                    end
                end
            end
            --消失的清理cache
            if (perishable == true and hitem.getCharges(it) <= 0) then
                hitem.del(it)
            end
        end),
        sell = cj.Condition(function()
            hevent.triggerEvent(
                cj.GetSellingUnit(),
                CONST_EVENT.itemSell,
                {
                    triggerUnit = cj.GetSellingUnit(),
                    soldItem = cj.GetSoldItem(),
                    buyingUnit = cj.GetBuyingUnit()
                }
            )
        end),
        destroy = cj.Condition(function()
            hevent.triggerEvent(
                cj.GetManipulatedItem(),
                CONST_EVENT.itemDestroy,
                {
                    triggerItem = cj.GetManipulatedItem(),
                    triggerUnit = cj.GetKillingUnit()
                }
            )
        end),
        separate = cj.Condition(function()
            local u = cj.GetTriggerUnit()
            local it = cj.GetManipulatedItem()
            if (it ~= nil and cj.GetSpellAbilityId() == hitem.DEFAULT_SKILL_ITEM_SEPARATE) then
                print_err("拆分物品尚未完成")
            end
        end),
    },
    destructable = {
        destroy = cj.Condition(function()
            hevent.triggerEvent(
                cj.GetTriggerDestructable(),
                CONST_EVENT.destructableDestroy,
                {
                    triggerDestructable = cj.GetTriggerDestructable()
                }
            )
        end)
    }
}