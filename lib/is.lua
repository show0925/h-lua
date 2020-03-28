his = {}

his.set = function(handle, key, val)
    if (handle == nil or key == nil or val == nil) then
        print_stack()
        return
    end
    if (type(val) ~= "boolean") then
        print_err("his.set not boolean")
        return
    end
    if (hRuntime.is[handle] == nil) then
        hRuntime.is[handle] = {}
    end
    hRuntime.is[handle][key] = val
end

his.get = function(handle, key)
    if (handle == nil or key == nil) then
        return false
    end
    if (hRuntime.is[handle] == nil) then
        return false
    end
    if (hRuntime.is[handle][key] == nil) then
        return false
    end
    if (type(hRuntime.is[handle][key]) == "boolean") then
        return hRuntime.is[handle][key]
    else
        return false
    end
end

-- 是否夜晚
his.night = function()
    return (cj.GetTimeOfDay() <= 6.00 or cj.GetTimeOfDay() >= 18.00)
end
-- 是否白天
his.day = function()
    return (cj.GetTimeOfDay() > 6.00 and cj.GetTimeOfDay() < 18.00)
end
-- 是否电脑
his.computer = function(whichPlayer)
    return his.get(whichPlayer, "isComputer")
end
-- 是否自动换算黄金木头
his.autoConvertGoldToLumber = function(whichPlayer)
    return his.get(whichPlayer, "isAutoConvertGoldToLumber")
end
-- 是否玩家位置(如果位置为真实玩家或为空，则为true；而如果选择了电脑玩家补充，则为false)
his.playerSite = function(whichPlayer)
    return cj.GetPlayerController(whichPlayer) == MAP_CONTROL_USER
end
-- 是否正在游戏
his.playing = function(whichPlayer)
    return cj.GetPlayerSlotState(whichPlayer) == PLAYER_SLOT_STATE_PLAYING
end
-- 是否中立玩家（包括中立敌对 中立被动 中立受害 中立特殊）
his.neutral = function(whichPlayer)
    local flag = false
    if (whichPlayer == nil) then
        flag = false
    elseif (whichPlayer == cj.Player(PLAYER_NEUTRAL_AGGRESSIVE)) then
        flag = true
    elseif (whichPlayer == cj.Player(bj_PLAYER_NEUTRAL_VICTIM)) then
        flag = true
    elseif (whichPlayer == cj.Player(bj_PLAYER_NEUTRAL_EXTRA)) then
        flag = true
    elseif (whichPlayer == cj.Player(PLAYER_NEUTRAL_PASSIVE)) then
        flag = true
    end
    return flag
end
-- 是否在某玩家真实视野内
his.detected = function(whichUnit, whichPlayer)
    local flag = false
    if (whichUnit == nil or whichPlayer == nil) then
        flag = false
    elseif (cj.IsUnitDetected(whichUnit, whichPlayer) == true) then
        flag = true
    end
    return flag
end
-- 是否拥有物品栏
-- 经测试(1.27a)单位物品栏（各族）等价物英雄物品栏，等级为1，即使科技明明没有
-- RPG应去除多余的物品栏，确保判定的准确性
his.hasSlot = function(whichUnit, slotId)
    if (slotId == nil) then
        slotId = hitem.DEFAULT_SKILL_ITEM_SLOT
    end
    return cj.GetUnitAbilityLevel(whichUnit, slotId) >= 1
end
-- 是否死亡
his.death = function(whichUnit)
    return cj.GetUnitState(whichUnit, UNIT_STATE_LIFE) <= 0
end
-- 是否生存
his.alive = function(whichUnit)
    return cj.GetUnitState(whichUnit, UNIT_STATE_LIFE) > 0
end
-- 是否已被删除
his.deleted = function(whichUnit)
    return cj.GetUnitName(whichUnit) == nil
end
-- 是否无敌
his.invincible = function(whichUnit)
    return cj.GetUnitAbilityLevel(whichUnit, hskill.BUFF_INVULNERABLE) > 0
end
-- 是否隐身中
his.invisible = function(whichUnit)
    return cj.GetUnitAbilityLevel(whichUnit, hskill.SKILL_INVISIBLE) > 0
end
-- 是否英雄
his.hero = function(whichUnit)
    return cj.IsUnitType(whichUnit, UNIT_TYPE_HERO) or his.get(whichUnit, "isHero") == true
end
-- 是否建筑
his.building = function(whichUnit)
    return cj.IsUnitType(whichUnit, UNIT_TYPE_STRUCTURE)
end
-- 是否镜像
his.illusion = function(whichUnit)
    return cj.IsUnitIllusion(whichUnit)
end
-- 是否地面单位
his.ground = function(whichUnit)
    return cj.IsUnitType(whichUnit, UNIT_TYPE_GROUND)
end
-- 是否空中单位
his.flying = function(whichUnit)
    return cj.IsUnitType(whichUnit, UNIT_TYPE_FLYING)
end
-- 是否近战
his.melee = function(whichUnit)
    return cj.IsUnitType(whichUnit, UNIT_TYPE_MELEE_ATTACKER)
end
-- 是否远程
his.ranged = function(whichUnit)
    return cj.IsUnitType(whichUnit, UNIT_TYPE_MELEE_ATTACKER)
end
-- 是否召唤
his.summoned = function(whichUnit)
    return cj.IsUnitType(whichUnit, UNIT_TYPE_SUMMONED)
end
-- 是否机械
his.mechanical = function(whichUnit)
    return cj.IsUnitType(whichUnit, UNIT_TYPE_MECHANICAL)
end
-- 是否古树
his.ancient = function(whichUnit)
    return cj.IsUnitType(whichUnit, UNIT_TYPE_ANCIENT)
end
-- 是否蝗虫
his.locust = function(whichUnit)
    return cj.GetUnitAbilityLevel(whichUnit, string.char2id("Aloc")) > 0
end
-- 是否被眩晕
his.swim = function(whichUnit)
    return his.get(whichUnit, "isSwim")
end
-- 是否被硬直
his.punish = function(whichUnit)
    return his.get(whichUnit, "isPunishing")
end
-- 是否被沉默
his.silent = function(whichUnit)
    return his.get(whichUnit, "isSilent")
end
-- 是否被缴械
his.unarm = function(whichUnit)
    return his.get(whichUnit, "isUnArm")
end
-- 是否被击飞
his.crackFly = function(whichUnit)
    return his.get(whichUnit, "isCrackFly")
end
-- 是否正在受伤
his.damaging = function(whichUnit)
    return his.get(whichUnit, "isDamaging")
end
-- 是否处在水面
his.water = function(whichUnit)
    return cj.IsTerrainPathable(cj.GetUnitX(whichUnit), cj.GetUnitY(whichUnit), PATHING_TYPE_FLOATABILITY) == false
end
-- 是否处于地面
his.floor = function(whichUnit)
    return cj.IsTerrainPathable(cj.GetUnitX(whichUnit), cj.GetUnitY(whichUnit), PATHING_TYPE_FLOATABILITY) == true
end
-- 是否某个特定单位
his.unit = function(whichUnit, otherUnit)
    return whichUnit == otherUnit
end
-- 是否敌人单位
his.enemy = function(whichUnit, otherUnit)
    return cj.IsUnitEnemy(whichUnit, cj.GetOwningPlayer(otherUnit))
end
-- 是否友军单位
his.ally = function(whichUnit, otherUnit)
    return cj.IsUnitAlly(whichUnit, cj.GetOwningPlayer(otherUnit))
end
-- 是否敌人玩家
his.enemyPlayer = function(whichUnit, whichPlayer)
    return cj.IsUnitEnemy(whichUnit, whichPlayer)
end
-- 是否友军玩家
his.allyPlayer = function(whichUnit, whichPlayer)
    return cj.IsUnitAlly(whichUnit, whichPlayer)
end
-- 是否超出区域边界
his.borderRect = function(r, x, y)
    local flag = false
    if (x >= cj.GetRectMaxX(r) or x <= cj.GetRectMinX(r)) then
        flag = true
    end
    if (y >= cj.GetRectMaxY(r) or y <= cj.GetRectMinY(r)) then
        return true
    end
    return flag
end
-- 是否超出地图边界
his.borderMap = function(x, y)
    return cj.borderRect(cj.GetPlayableMapRect(), x, y)
end
-- 是否身上有某种物品
his.ownItem = function(u, itemId)
    local f = false
    if (type(itemId) == "string") then
        itemId = string.char2id(itemId)
    end
    for i = 0, 5, 1 do
        local it = cj.UnitItemInSlot(u, i)
        if (it ~= nil and cj.GetItemTypeId(it) == itemId) then
            f = true
            break
        end
    end
    return f
end
