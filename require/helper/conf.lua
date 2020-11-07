
---@public slkHelper默认配置项
slkHelper.conf = {
    -- 是否自动启用影子物品
    itemAutoShadow = false,
    -- 信使技能-名称、热键、图标位置、冷却
    courierSkill = {
        blink = {
            Ubertip = "可以闪烁到任何地方",
            Art = "ReplaceableTextures\\CommandButtons\\BTNBlink.blp",
            Hotkey = 'Q',
            Buttonpos1 = 0,
            Buttonpos2 = 2,
            Cool1 = 10
        },
        rangePickUp = {
            Ubertip = "将附近地上的物品拾取到身上",
            Art = "ReplaceableTextures\\CommandButtons\\BTNPickUpItem.blp",
            Hotkey = 'W',
            Buttonpos1 = 1,
            Buttonpos2 = 2,
            Cool1 = 3
        },
        separate = {
            Ubertip = "将合成或重叠的物品拆分成零件",
            Art = "ReplaceableTextures\\CommandButtons\\BTNRepair.blp",
            Hotkey = 'E',
            Buttonpos1 = 2,
            Buttonpos2 = 2,
            Cool1 = 3
        },
        deliver = {
            Ubertip = "将所有物品依照顺序传送给英雄，当你的英雄没有空余物品位置，物品会返回给信使",
            Art = "ReplaceableTextures\\CommandButtons\\BTNLoadPeon.blp",
            Hotkey = 'R',
            Buttonpos1 = 3,
            Buttonpos2 = 2,
            Cool1 = 3
        },
    },
    -- 一般单位白天视野默认值
    unitSight = 1400,
    -- 一般单位黑夜视野默认值
    unitNSight = 800,
    -- 英雄单位白天视野默认值
    heroSight = 1800,
    -- 英雄单位黑夜视野默认值
    heroNSight = 800,
    -- 商店单位白天视野默认值
    shopSight = 1200,
    -- 商店单位黑夜视野默认值
    shopNSight = 1200,
    -- 描述文本颜色,需要配置 hColor 里拥有的颜色函数名
    color = {
        -- 热键
        hotKey = "gold",
        -- 物品主动
        itemActive = "yellow",
        -- 物品被动
        itemPassive = "seaLight",
        -- 物品冷却时间
        itemCoolDown = "skyLight",
        -- 物品属性
        itemAttr = "green",
        -- 物品叠加
        itemOverlie = "purple",
        -- 物品重量
        itemWeight = "purpleLight",
        -- 物品描述
        itemDesc = "greyDeep",
        -- 物品合成品
        itemProfit = "orangeLight",
        -- 物品零部件
        itemFragment = "orange",
        -- 技能主动
        abilityActive = "yellow",
        -- 技能被动
        abilityPassive = "seaLight",
        -- 技能冷却时间
        abilityCoolDown = "skyLight",
        -- 技能属性
        abilityAttr = "green",
        -- 技能描述
        abilityDesc = "grey",
        -- 光环范围
        ringArea = "seaLight",
        -- 光环作用目标
        ringTarget = "seaLight",
        -- 光环描述
        abilityRingDesc = "white",
        -- 英雄攻击武器类型
        heroWeapon = "red",
        -- 英雄基础攻击
        heroAttack = "redLight",
        -- 英雄攻击范围
        heroRange = "seaLight",
        -- 英雄主属性
        heroPrimary = "yellow",
        -- 英雄主属性
        heroSecondary = "yellowLight",
        -- 英雄移动
        heroMove = "greenLight",
    },
}
