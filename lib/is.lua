---@class his 判断
his = {}

--- 是否夜晚
---@return boolean
his.night = function()
    return (cj.GetFloatGameState(GAME_STATE_TIME_OF_DAY) <= 6.00 or cj.GetFloatGameState(GAME_STATE_TIME_OF_DAY) >= 18.00)
end

--- 是否白天
---@return boolean
his.day = function()
    return (cj.GetFloatGameState(GAME_STATE_TIME_OF_DAY) > 6.00 and cj.GetFloatGameState(GAME_STATE_TIME_OF_DAY) < 18.00)
end

--- 是否电脑(如果位置为电脑玩家或无玩家，则为true)
--- 常用来判断电脑AI是否开启
---@param whichPlayer userdata
---@return boolean
his.computer = function(whichPlayer)
    return cj.GetPlayerController(whichPlayer) == MAP_CONTROL_COMPUTER
        or cj.GetPlayerSlotState(whichPlayer) ~= PLAYER_SLOT_STATE_PLAYING
end

--- 是否玩家位置(如果位置为真实玩家或为空，则为true；而如果选择了电脑玩家补充，则为false)
--- 常用来判断该是否玩家可填补位置
---@param whichPlayer userdata
---@return boolean
his.playerSite = function(whichPlayer)
    return cj.GetPlayerController(whichPlayer) == MAP_CONTROL_USER
end

--- 是否正在游戏
---@param whichPlayer userdata
---@return boolean
his.playing = function(whichPlayer)
    return cj.GetPlayerSlotState(whichPlayer) == PLAYER_SLOT_STATE_PLAYING
end

--- 是否中立玩家（包括中立敌对 中立被动 中立受害 中立特殊）
---@param whichPlayer userdata
---@return boolean
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

--- 是否在某玩家真实视野内
---@param whichUnit userdata
---@return boolean
his.detected = function(whichUnit, whichPlayer)
    local flag = false
    if (whichUnit == nil or whichPlayer == nil) then
        flag = false
    elseif (cj.IsUnitDetected(whichUnit, whichPlayer) == true) then
        flag = true
    end
    return flag
end

--- 是否拥有物品栏
--- 经测试(1.27a)单位物品栏（各族）等价物英雄物品栏，等级为1，即使没有科技
--- RPG应去除多余的物品栏，确保判定的准确性
---@param whichUnit userdata
---@param slotId number
---@return boolean
his.hasSlot = function(whichUnit, slotId)
    if (slotId == nil) then
        slotId = hitem.DEFAULT_SKILL_ITEM_SLOT
    end
    return cj.GetUnitAbilityLevel(whichUnit, slotId) >= 1
end

--- 是否死亡
---@param whichUnit userdata
---@return boolean
his.dead = function(whichUnit)
    return cj.GetUnitState(whichUnit, UNIT_STATE_LIFE) <= 0
end

--- 是否生存
---@param whichUnit userdata
---@return boolean
his.alive = function(whichUnit)
    return cj.GetUnitState(whichUnit, UNIT_STATE_LIFE) > 0
end

--- 单位是否已被删除
---@param whichUnit userdata
---@return boolean
his.deleted = function(whichUnit)
    return cj.GetUnitName(whichUnit) == nil
end

--- 是否无敌
---@param whichUnit userdata
---@return boolean
his.invincible = function(whichUnit)
    return cj.GetUnitAbilityLevel(whichUnit, hskill.BUFF_INVULNERABLE) > 0
end

--- 是否隐身中
---@param whichUnit userdata
---@return boolean
his.invisible = function(whichUnit)
    return cj.GetUnitAbilityLevel(whichUnit, hskill.SKILL_INVISIBLE) > 0
end

--- 是否英雄
--- UNIT_TYPE_HERO是对应平衡常数的英雄列表
--- hero和courier_hero是对应slkHelper里面的UNIT_TYPE，是本框架固有用法
---@param whichUnit userdata
---@return boolean
his.hero = function(whichUnit)
    local uid = hunit.getId(whichUnit)
    return cj.IsUnitType(whichUnit, UNIT_TYPE_HERO)
        or table.includes(hslk.unit_type_ids.hero, uid) == true
        or table.includes(hslk.unit_type_ids.courier_hero, uid) == true
end

--- 是否建筑
---@param whichUnit userdata
---@return boolean
his.structure = function(whichUnit)
    return cj.IsUnitType(whichUnit, UNIT_TYPE_STRUCTURE)
end

--- 是否镜像
---@param whichUnit userdata
---@return boolean
his.illusion = function(whichUnit)
    return cj.IsUnitIllusion(whichUnit)
end

--- 是否地面单位
---@param whichUnit userdata
---@return boolean
his.ground = function(whichUnit)
    return cj.IsUnitType(whichUnit, UNIT_TYPE_GROUND)
end

--- 是否空中单位
---@param whichUnit userdata
---@return boolean
his.air = function(whichUnit)
    return cj.IsUnitType(whichUnit, UNIT_TYPE_FLYING)
end

--- 是否近战
---@param whichUnit userdata
---@return boolean
his.melee = function(whichUnit)
    return cj.IsUnitType(whichUnit, UNIT_TYPE_MELEE_ATTACKER)
end

--- 是否远程
---@param whichUnit userdata
---@return boolean
his.ranged = function(whichUnit)
    return cj.IsUnitType(whichUnit, UNIT_TYPE_MELEE_ATTACKER)
end

--- 是否召唤
---@param whichUnit userdata
---@return boolean
his.summoned = function(whichUnit)
    return cj.IsUnitType(whichUnit, UNIT_TYPE_SUMMONED)
end

--- 是否机械
---@param whichUnit userdata
---@return boolean
his.mechanical = function(whichUnit)
    return cj.IsUnitType(whichUnit, UNIT_TYPE_MECHANICAL)
end

--- 是否古树
---@param whichUnit userdata
---@return boolean
his.ancient = function(whichUnit)
    return cj.IsUnitType(whichUnit, UNIT_TYPE_ANCIENT)
end

--- 是否自爆工兵
---@param whichUnit userdata
---@return boolean
his.sapper = function(whichUnit)
    return cj.IsUnitType(whichUnit, UNIT_TYPE_SAPPER)
end

--- 是否蝗虫
---@param whichUnit userdata
---@return boolean
his.locust = function(whichUnit)
    return cj.GetUnitAbilityLevel(whichUnit, string.char2id("Aloc")) > 0
end

--- 是否被眩晕
---@param whichUnit userdata
---@return boolean
his.swim = function(whichUnit)
    return hcache.get(whichUnit, "isSwim", false)
end

--- 是否被硬直
---@param whichUnit userdata
---@return boolean
his.punish = function(whichUnit)
    return hcache.get(whichUnit, "isPunishing", false)
end

--- 是否被沉默
---@param whichUnit userdata
---@return boolean
his.silent = function(whichUnit)
    return hcache.get(whichUnit, "isSilent", false)
end

--- 是否被缴械
---@param whichUnit userdata
---@return boolean
his.unarm = function(whichUnit)
    return hcache.get(whichUnit, "isUnArm", false)
end

--- 是否被击飞
---@param whichUnit userdata
---@return boolean
his.crackFly = function(whichUnit)
    return hcache.get(whichUnit, "isCrackFly", false)
end

--- 是否正在受伤
---@param whichUnit userdata
---@return boolean
his.beDamaging = function(whichUnit)
    return hcache.get(whichUnit, "isBeDamaging", false)
end

--- 是否正在造成伤害
---@param whichUnit userdata
---@return boolean
his.damaging = function(whichUnit)
    return hcache.get(whichUnit, "isDamaging", false)
end

--- 是否处在水面
---@param whichUnit userdata
---@return boolean
his.water = function(whichUnit)
    return cj.IsTerrainPathable(hunit.x(whichUnit), hunit.y(whichUnit), PATHING_TYPE_FLOATABILITY) == false
end

--- 是否处于地面
---@param whichUnit userdata
---@return boolean
his.floor = function(whichUnit)
    return cj.IsTerrainPathable(hunit.x(whichUnit), hunit.y(whichUnit), PATHING_TYPE_FLOATABILITY) == true
end

--- 是否某个特定单位
---@param whichUnit userdata
---@param otherUnit userdata
---@return boolean
his.unit = function(whichUnit, otherUnit)
    return cj.IsUnit(whichUnit, otherUnit)
end

--- 是否敌人单位
---@param whichUnit userdata
---@param otherUnit userdata
---@return boolean
his.enemy = function(whichUnit, otherUnit)
    return cj.IsUnitEnemy(whichUnit, hunit.getOwner(otherUnit))
end

--- 是否友军单位
---@param whichUnit userdata
---@param otherUnit userdata
---@return boolean
his.ally = function(whichUnit, otherUnit)
    return cj.IsUnitAlly(whichUnit, hunit.getOwner(otherUnit))
end

--- 判断两个单位是否背对着
---@param u1 userdata
---@param u2 userdata
---@param maxDistance number 最大相对距离
---@return number
his.behind = function(u1, u2, maxDistance)
    if (his.alive(u1) == false or his.alive(u2) == false) then
        return false
    end
    maxDistance = maxDistance or 99999
    if (math.getDistanceBetweenUnit(u1, u2) > maxDistance) then
        return false
    end
    local fac1 = hunit.getFacing(u1)
    local fac2 = hunit.getFacing(u2)
    return math.abs(fac1 - fac2) <= 50
end

--- 判断两个单位是否正对着
---@param u1 userdata
---@param u2 userdata
---@param maxDistance number 最大相对距离
---@return number
his.face = function(u1, u2, maxDistance)
    if (his.alive(u1) == false or his.alive(u2) == false) then
        return false
    end
    maxDistance = maxDistance or 99999
    if (math.getDistanceBetweenUnit(u1, u2) > maxDistance) then
        return false
    end
    local fac1 = hunit.getFacing(u1)
    local fac2 = hunit.getFacing(u2)
    return math.abs((math.abs(fac1 - fac2) - 180)) <= 50
end

--- 是否敌人玩家
---@param whichUnit userdata
---@param whichPlayer userdata
---@return boolean
his.enemyPlayer = function(whichUnit, whichPlayer)
    return cj.IsUnitEnemy(whichUnit, whichPlayer)
end

--- 是否友军玩家
---@param whichUnit userdata
---@param whichPlayer userdata
---@return boolean
his.allyPlayer = function(whichUnit, whichPlayer)
    return cj.IsUnitAlly(whichUnit, whichPlayer)
end

--- 是否在区域内
his.inRect = function(whichRect, x, y)
    return (x < cj.GetRectMaxX(whichRect) and x > cj.GetRectMinX(whichRect) and y < cj.GetRectMaxY(whichRect) and y > cj.GetRectMinY(whichRect))
end

--- 是否超出区域边界
---@param whichRect userdata
---@param x number
---@param y number
---@return boolean
his.borderRect = function(whichRect, x, y)
    local flag = false
    if (x >= cj.GetRectMaxX(whichRect) or x <= cj.GetRectMinX(whichRect)) then
        flag = true
    end
    if (y >= cj.GetRectMaxY(whichRect) or y <= cj.GetRectMinY(whichRect)) then
        return true
    end
    return flag
end

--- 是否超出地图边界
---@param x number
---@param y number
---@return boolean
his.borderMap = function(x, y)
    return his.borderRect(hrect.MAP_INITIAL_PLAYABLE_AREA, x, y)
end

--- 是否超出镜头边界
---@param x number
---@param y number
---@return boolean
his.borderCamera = function(x, y)
    return his.borderRect(his.MAP_CAMERA_AREA, x, y)
end

--- 物品是否已被销毁
---@param whichItem userdata
---@return boolean
his.destroy = function(whichItem)
    return cj.GetItemTypeId(whichItem) == 0
end

--- 是否身上有某种物品
---@param whichUnit userdata
---@param whichItemId number|string
---@return boolean
his.hasItem = function(whichUnit, whichItemId)
    local f = false
    if (type(whichItemId) == "string") then
        whichItemId = string.char2id(whichItemId)
    end
    for i = 0, 5, 1 do
        local it = cj.UnitItemInSlot(whichUnit, i)
        if (it ~= nil and cj.GetItemTypeId(it) == whichItemId) then
            f = true
            break
        end
    end
    return f
end
