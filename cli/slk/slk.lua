--- 默认配置项
SLK_CONF = {
    itemAutoShadow = false, -- 是否自动启用影子物品
    courierSkill = {
        -- 信使技能-名称、热键、图标位置、冷却
        blink = {
            Ubertip = "闪烁到任何地方", Art = "ReplaceableTextures\\CommandButtons\\BTNBlink.blp",
            Hotkey = 'Q', Buttonpos1 = 0, Buttonpos2 = 2, Cool1 = 10
        },
        rangePickUp = {
            Ubertip = "将附近地上的物品拾取到身上", Art = "ReplaceableTextures\\CommandButtons\\BTNPickUpItem.blp",
            Hotkey = 'W', Buttonpos1 = 1, Buttonpos2 = 2, Cool1 = 5
        },
        separate = {
            Ubertip = "将合成或重叠的物品拆分成零件", Art = "ReplaceableTextures\\CommandButtons\\BTNRepair.blp",
            Hotkey = 'E', Buttonpos1 = 2, Buttonpos2 = 2, Cool1 = 5
        },
        deliver = {
            Ubertip = "将所有物品依照顺序传送给英雄，当你的英雄没有空余物品位置，物品会返回给信使", Art = "ReplaceableTextures\\CommandButtons\\BTNLoadPeon.blp",
            Hotkey = 'R', Buttonpos1 = 3, Buttonpos2 = 2, Cool1 = 5
        },
    },
    unitSight = 1400, -- 一般单位白天视野默认值
    unitNSight = 800, -- 一般单位黑夜视野默认值
    heroSight = 1800, -- 英雄单位白天视野默认值
    heroNSight = 800, -- 英雄单位黑夜视野默认值
    shopSight = 1200, -- 商店单位白天视野默认值
    shopNSight = 1200, -- 商店单位黑夜视野默认值
    -- 描述文本颜色,可配置 hcolor 里拥有的颜色函数，也可以配置 hex 6位颜色码
    color = {
        hotKey = "ffcc00", -- 热键
        itemActive = "fae470", -- 物品主动
        itemPassive = "6ab2f6", -- 物品被动
        itemCoolDown = "ccffff", -- 物品冷却时间
        itemAttr = "b0f26e", -- 物品属性
        itemOverlie = "ff59ff", -- 物品叠加
        itemWeight = "ee82ee", -- 物品重量
        itemRemarks = "969696", -- 物品备注
        itemProfit = "ffd88c", -- 物品合成品
        itemFragment = hcolor.orange, -- 物品零部件
        abilityDesc = "fae470", -- 技能描述
        abilityCoolDown = "ccffff", -- 技能冷却时间
        abilityAttr = "b0f26e", -- 技能属性
        ringArea = "99ccff", -- 光环范围
        ringTarget = "99ccff", -- 光环作用目标
        ringDesc = hcolor.white, -- 光环描述
        heroWeapon = "ff3939", -- 英雄攻击武器类型
        heroAttack = "ff8080", -- 英雄基础攻击
        heroRange = "99ccff", -- 英雄攻击范围
        heroPrimary = "ffff00", -- 英雄主属性
        heroSecondary = "ffffcc", -- 英雄主属性
        heroMove = "ccffcc", -- 英雄移动
    },
}

--- 物品合成公式数组，只支持slkHelper创建的注册物品
---例子1 "小刀割大树=小刀+大树" 2个不一样的合1个
---例子2 "三头地狱犬的神识=地狱狗头x3" 3个一样的合1个
---例子3 "精灵神水x2=精灵的眼泪x50" 50个一样的合一种,但得到2个
---例子4 {{"小刀割大树",1},{"小刀",1},{"大树",1}} 对象型配置，第一项为结果物品(适合物品名称包含特殊字符的物品，如+/=影响公式的符号)
hslk_item_synthesis = function(formula)
    F6V_I_SYNTHESIS(formula)
end

---@param _v{abiList: "主动技能ID列表",Requires: "科技树",Requiresamount: "科技树",Name: "物品名称",Description: "物品描述",Tip: "物品描述标题",Ubertip: "物品在地上时说明",Hotkey: "热键",Art: "图标",scale: "模型大小",file: "模型路径",Buttonpos1: "商店X坐标",Buttonpos2: "商店Y坐标",selSize: "选择圈大小",colorR: "颜色R",colorG: "颜色G",colorB: "颜色B",armor: "装甲类型",Level: "等级",oldLevel: "等级(旧)",class: "物品分类",goldcost: "黄金",lumbercost: "木头",HP: "生命",stockStart: "开始库存",stockRegen: "补货周期",stockMax: "最大库存",prio: "优先权",morph: "有效的物品转换目标",drop: "死亡时掉落",powerup: "捡到时自动使用",sellable: "可以出售",pawnable: "可以抵押",droppable: "可以丢弃",pickRandom: "可以作为随机物品",uses: "使用次数",perishable: "使用后完全消失",usable: "主动使用",_id:"物编ID",_type:"slk数据归类","_parent:"模版物编ID","_overlie:"叠加","_weight:"重量",_active:"主动",_passive:"被动","_attr:"属性","_attr_txt":"属性(无效)","_ring:"光环","_cooldown:"冷却时间",_shadow:"强制使用影子物品"}
hslk_item = function(_v)
    _v = F6V_I(_v)
    _v._id = SLK_ID(_v._class, _v._id)
    SLK_GO_SET(_v)
end

hslk_ability = function(_v)
    _v = F6V_A(_v)
    _v._id = SLK_ID(_v._class, _v._id)
    SLK_GO_SET(_v)
end

hslk_ability_empty = function(_v)
    _v = F6V_A_E(_v)
    _v._id = SLK_ID(_v._class, _v._id)
    SLK_GO_SET(_v)
end

hslk_unit = function(_v)
    _v = F6V_U(_v)
    _v._id = SLK_ID(_v._class, _v._id)
    SLK_GO_SET(_v)
end