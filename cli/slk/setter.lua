-- 物编 - 物品默认设定
---@protected
F6_DEF = {
    a = {
        checkDep = 1,
        Requires = "",
        Requiresamount = "",
        Effectsound = "",
        Effectsoundlooped = "",
        EditorSuffix = "",
        Name = nil,
        Untip = nil,
        Unubertip = nil,
        Tip = nil,
        Ubertip = nil,
        Researchtip = nil,
        Researchubertip = nil,
        Unorder = nil,
        Orderon = nil,
        Order = nil,
        Orderoff = nil,
        Unhotkey = nil,
        Hotkey = nil,
        Researchhotkey = nil,
        UnButtonpos1 = 0,
        UnButtonpos2 = 0,
        Buttonpos1 = 0,
        Buttonpos2 = 0,
        Researchbuttonpos1 = 0,
        Researchbuttonpos2 = 0,
        Unart = nil,
        Researchart = nil,
        Art = nil,
        SpecialArt = nil,
        Specialattach = nil,
        Missileart = nil,
        Missilespeed = 1000,
        Missilearc = 0,
        MissileHoming = 1,
        LightningEffect = nil,
        EffectArt = nil,
        TargetArt = nil,
        Targetattachcount = 0,
        Targetattach = nil,
        Targetattach1 = nil,
        Targetattach2 = nil,
        Targetattach3 = nil,
        Targetattach4 = nil,
        Targetattach5 = nil,
        Areaeffectart = nil,
        Animnames = "spell",
        CasterArt = nil,
        Casterattachcount = 0,
        Casterattach = nil,
        Casterattach1 = nil,
        hero = 0,
        item = 0,
        race = "other",
        levels = 1,
        reqLevel = 1,
        priority = 0,
        BuffID1 = nil,
        EfctID1 = nil,
        Tip1 = nil,
        Ubertip1 = nil,
        targs1 = "ground,air,friend,vuln,invu",
        DataA1 = 0,
        DataB1 = 0,
        DataC1 = 0,
        DataD1 = 0,
        DataE1 = 0,
        DataF1 = 0,
        Cast1 = nil,
        Cool1 = nil,
        Dur1 = nil,
        HeroDur1 = nil,
        Cost1 = nil,
        Rng1 = nil,
        Area1 = nil,
        _id = nil,
        _class = "ability",
        _type = "common",
        _parent = "auto",
        _desc = nil,
        _attr = nil,
        _attr_txt = nil,
        _ring = nil,
    },
    i = {
        abilList = "",
        Requires = "",
        Requiresamount = "",
        Name = nil,
        Description = nil,
        Tip = "",
        Ubertip = nil,
        Hotkey = nil,
        Art = "ReplaceableTextures\\CommandButtons\\BTNSelectHeroOn.blp",
        scale = 1.00,
        file = "Objects\\InventoryItems\\TreasureChest\\treasurechest.mdl",
        Buttonpos1 = 0,
        Buttonpos2 = 0,
        selSize = 0.00,
        colorR = 255,
        colorG = 255,
        colorB = 255,
        armor = "Wood",
        Level = nil,
        oldLevel = nil,
        class = "Permanent",
        goldcost = 1000000,
        lumbercost = 1000000,
        HP = 100,
        stockStart = 0,
        stockRegen = 0,
        stockMax = 1,
        prio = 0,
        cooldownID = "Alat",
        ignoreCD = 0,
        morph = 0,
        drop = 0,
        powerup = 0,
        sellable = 1,
        pawnable = 1,
        droppable = 1,
        pickRandom = 1,
        uses = 1,
        perishable = 0,
        usable = 0,
        _id = nil,
        _class = "item",
        _type = "common",
        _parent = "rat9",
        _overlie = 1,
        _weight = 0,
        _active = nil,
        _passive = nil,
        _attr = nil,
        _attr_txt = nil,
        _ring = nil,
        _cooldown = nil,
        _cooldownTarget = nil,
        _shadow = false,
    },
    u = {
        -- 主体
        Name = nil,
        Description = "",
        Tip = nil,
        Ubertip = nil,
        Hotkey = nil,
        level = nil,
        race = "other",
        type = nil,
        goldcost = 0,
        lumbercost = 0,
        manaN = 0,
        regenMana = 0,
        mana0 = 0,
        HP = 100,
        regenHP = 0,
        regenType = 0,
        fmade = 0,
        fused = 0,
        stockStart = nil,
        stockRegen = nil,
        stockMax = nil,
        sight = 1400,
        nsight = 800,
        -- 模型相关
        collision = 16,
        modelScale = 1,
        file = "units\\human\\Peasant\\Peasant",
        fileVerFlags = 0,
        scaleBull = 1,
        scale = 1,
        selZ = 0,
        selCircOnWater = 0,
        red = 255,
        green = 255,
        blue = 255,
        occH = 0, -- 闭塞高度
        maxPitch = nil,
        maxRoll = nil,
        impactZ = nil,
        impactSwimZ = nil,
        launchX = nil,
        launchY = nil,
        launchZ = nil,
        launchSwimZ = nil,
        -- 声音相关
        unitSound = "",
        RandomSoundLabel = "",
        MovementSoundLabel = "",
        LoopingSoundFadeOut = 0,
        LoopingSoundFadeIn = 0,
        -- 技能相关
        auto = "_",
        abilList = "",
        -- 商店相关
        Sellitems = "",
        Sellunits = "",
        Markitems = "",
        Builds = "",
        -- 图标
        Buttonpos1 = 0,
        Buttonpos2 = 0,
        Art = nil,
        Specialart = nil,
        -- 阴影相关
        unitShadow = "ShadowFlyer",
        buildingShadow = nil,
        shadowH = nil,
        shadowW = nil,
        shadowX = nil,
        shadowY = nil,
        shadowOnWater = nil,
        -- 死亡相关
        death = nil,
        deathType = 3,
        -- 移动相关
        movetp = "foot",
        moveHeight = 0,
        moveFloor = nil,
        spd = 100,
        maxSpd = nil,
        minSpd = nil,
        turnRate = 0.5,
        -- 攻击相关
        acquire = 500,
        minRange = 0,
        weapsOn = nil,
        -- 攻击1
        Missileart = nil,
        Missilespeed = 1000,
        Missilearc = 0,
        MissileHoming = 1,
        targs1 = "ground,air,structure,debris,item,ward",
        atkType1 = nil,
        weapTp1 = nil,
        weapType1 = nil,
        spillRadius1 = nil,
        spillDist1 = nil,
        damageLoss1 = nil,
        showUI1 = nil,
        backSw1 = nil,
        dmgpt1 = nil,
        rangeN1 = nil,
        RngBuff1 = nil,
        dmgplus1 = nil,
        dmgUp1 = nil,
        sides1 = nil,
        dice1 = nil,
        splashTargs1 = nil,
        cool1 = nil,
        Farea1 = nil,
        targCount1 = nil,
        Qfact1 = nil,
        Qarea1 = nil,
        Hfact1 = nil,
        Harea1 = nil,
        -- 攻击2
        Missileart2 = nil,
        Missilespeed2 = 1000,
        Missilearc2 = 0,
        MissileHoming2 = 1,
        targs2 = "ground,air,structure,debris,item,ward",
        atkType2 = nil,
        weapTp2 = nil,
        weapType2 = nil,
        spillRadius2 = nil,
        spillDist2 = nil,
        damageLoss2 = nil,
        showUI2 = nil,
        backSw2 = nil,
        dmgpt2 = nil,
        rangeN2 = nil,
        RngBuff2 = nil,
        dmgplus2 = nil,
        dmgUp2 = nil,
        sides2 = nil,
        dice2 = nil,
        splashTargs2 = nil,
        cool2 = nil,
        Farea2 = nil,
        targCount2 = nil,
        Qfact2 = nil,
        Qarea2 = nil,
        Hfact2 = nil,
        Harea2 = nil,
        -- 防御相关
        defType = "normal",
        defUp = nil,
        def = 0,
        armor = "Flesh",
        targType = "ground",
        -- 英雄专用
        Propernames = nil,
        nameCount = nil,
        Awakentip = nil,
        Revivetip = nil,
        Primary = "STR",
        STR = 1,
        STRplus = 0,
        AGI = 1,
        AGIplus = 0,
        INT = 1,
        INTplus = 0,
        heroAbilList = nil,
        hideHeroMinimap = nil,
        hideHeroBar = nil,
        hideHeroDeathMsg = nil,
        Requiresacount = nil,
        Requires1 = nil,
        Requires2 = nil,
        Requires3 = nil,
        Requires4 = nil,
        Requires5 = nil,
        Requires6 = nil,
        Requires7 = nil,
        Requires8 = nil,
        Reviveat = nil,
        -- 建筑物专用
        buffRadius = 0,
        buffType = "_",
        Revive = nil,
        Trains = nil,
        Upgrade = nil,
        requirePlace = nil,
        preventPlace = nil,
        requireWaterRadius = nil,
        pathTex = nil,
        uberSplat = nil,
        nbrandom = nil,
        nbmmlcon = nil,
        canBuildOn = nil,
        isBuildOn = nil,
        --
        tilesets = nil,
        special = nil,
        campaign = nil,
        inEditor = nil,
        dropItems = nil,
        hostilePal = nil,
        useClickHelper = nil,
        tilesetSpecific = nil,
        Requires = nil,
        Requiresamount = nil,
        DependencyOr = nil,
        Researches = nil,
        upgrades = nil,
        EditorSuffix = nil,
        Casterupgradename = nil,
        Casterupgradetip = nil,
        Castrerupgradeart = nil,
        ScoreScreenIcon = nil,
        animProps = nil,
        Attachmentanimprops = nil,
        Attachmentlinkprops = nil,
        Boneprops = nil,
        castpt = nil,
        castbsw = nil,
        blend = nil,
        run = nil,
        walk = nil,
        propWin = nil,
        orientInterp = nil,
        teamColor = nil,
        customTeamColor = nil,
        elevPts = nil,
        elevRad = nil,
        fogRad = nil,
        fatLOS = nil,
        repulse = nil,
        repulsePrio = nil,
        repulseParam = nil,
        repulseGroup = nil,
        isbldg = nil,
        bldtm = nil,
        bountyplus = nil,
        bountysides = nil,
        bountydice = nil,
        goldRep = nil,
        lumberRep = nil,
        reptm = nil,
        lumberbountyplus = nil,
        lumberbountysides = nil,
        lumberbountydice = nil,
        cargoSize = nil,
        hideOnMinimap = nil,
        points = nil,
        prio = nil,
        formation = nil,
        canFlee = 1,
        canSleep = 0,
        --
        _id = nil,
        _class = "unit",
        _type = "common",
        _parent = "auto",
        _attr = nil,
    },
}

F6TIPS = {
    abilList = "主动技能ID列表",
    Requires = "科技树",
    Requiresamount = "科技树-需求值",
    Name = "名称",
    Description = "描述",
    Tip = "描述标题",
    Ubertip = "说明",
    Hotkey = "热键",
    Art = "图标",
    scale = "模型大小",
    file = "模型文件路径",
    Buttonpos1 = "X坐标",
    Buttonpos2 = "Y坐标",
    selSize = "选择圈大小",
    colorR = "红",
    colorG = "绿",
    colorB = "蓝",
    armor = "装甲类型",
    Level = "等级",
    oldLevel = "等级(旧)",
    class = "分类",
    goldcost = "黄金",
    lumbercost = "木头",
    HP = "生命",
    stockStart = "开始库存",
    stockRegen = "补货周期",
    stockMax = "最大库存",
    prio = "优先权",
    morph = "有效的物品转换目标",
    drop = "死亡时掉落",
    powerup = "捡到时自动使用",
    sellable = "可以出售",
    pawnable = "可以抵押",
    droppable = "可以丢弃",
    pickRandom = "可以作为随机物品",
    uses = "使用次数",
    perishable = "使用后完全消失",
    usable = "主动使用",
    level = "等级",
    race = "种族",
    type = "类别",
    manaN = "最大魔法值",
    regenMana = "魔法恢复",
    mana0 = "初始魔法",
    regenHP = "生命恢复",
    regenType = "生命恢复类型",
    fmade = "提供人口",
    fused = "占用人口",
    stockStart = "雇佣开始时间",
    stockRegen = "雇佣开始间隔",
    stockMax = "最大库存",
    sight = "白天视野",
    nsight = "夜晚视野",
    collision = "接触体积",
    modelScale = "模型缩放",
    fileVerFlags = "模型文件版本",
    scaleBull = "缩放投射物",
    scale = "选择圈缩放",
    selZ = "选择圈高度",
    selCircOnWater = "选择圈在水面上",
    red = "红",
    green = "绿",
    blue = "蓝",
    occH = "闭塞高度",
    maxPitch = "X轴最大旋转角度",
    maxRoll = "Y轴最大旋转角度",
    impactZ = "射弹碰撞偏移Z",
    impactSwimZ = "射弹碰撞偏移Z深水",
    launchX = "射弹偏移X",
    launchY = "射弹偏移Y",
    launchZ = "射弹偏移Z",
    launchSwimZ = "射弹偏移Z深水",
    unitSound = "单位声音",
    RandomSoundLabel = "声音随机",
    MovementSoundLabel = "声音移动",
    LoopingSoundFadeOut = "声音渐出",
    LoopingSoundFadeIn = "声音渐入",
    auto = "主动自动技能ID",
    Sellitems = "售出物品",
    Sellunits = "售出单位",
    Markitems = "制造物品",
    Builds = "可建造单位",
    Buttonpos1 = "图标X坐标",
    Buttonpos2 = "图标Y坐标",
    Specialart = "特殊效果",
    unitShadow = "单位阴影",
    buildingShadow = "建筑阴影",
    shadowH = "阴影H",
    shadowW = "阴影W",
    shadowX = "阴影X",
    shadowY = "阴影Y",
    shadowOnWater = "深水有阴影",
    death = "死亡时间",
    deathType = "死亡类型",
    movetp = "移动类型",
    moveHeight = "移动高度",
    moveFloor = "最小高度",
    spd = "基础速度",
    maxSpd = "最大速度",
    minSpd = "最小速度",
    turnRate = "转身速率",
    acquire = "主动攻击范围",
    minRange = "最小攻击范围",
    weapsOn = "允许攻击",
    Missileart = "箭矢模型",
    Missilespeed = "箭矢速度",
    Missilearc = "箭矢弧度",
    MissileHoming = "箭矢自导",
    targs1 = "目标允许",
    atkType1 = "攻击类型",
    weapTp1 = "武器类型",
    weapType1 = "武器声音",
    spillRadius1 = "穿透伤害范围",
    spillDist1 = "穿透距离",
    damageLoss1 = "伤害衰减参数",
    showUI1 = "显示攻击UI",
    backSw1 = "攻击后摇",
    dmgpt1 = "攻击前摇",
    rangeN1 = "攻击范围",
    RngBuff1 = "攻击范围缓冲",
    dmgplus1 = "基础伤害",
    dmgUp1 = "攻击科技升级",
    sides1 = "伤害骰子面数",
    dice1 = "伤害骰子数量",
    splashTargs1 = "范围影响目标",
    cool1 = "攻击间隔",
    Farea1 = "全伤害范围",
    targCount1 = "最大目标数",
    Qfact1 = "小伤害参数",
    Qarea1 = "小伤害范围",
    Hfact1 = "中伤害参数",
    Harea1 = "中伤害范围",
    defType = "护甲类型",
    defUp = "护甲科技升级",
    def = "基础护甲",
    armor = "装甲类型（被击声音）",
    targType = "作为目标类型",
    Propernames = "英雄称谓",
    nameCount = "英雄称谓个数",
    Awakentip = "英雄唤醒提示",
    Revivetip = "英雄重生提示",
    Primary = "主属性",
    STR = "力量",
    STRplus = "力量成长",
    AGI = "敏捷",
    AGIplus = "敏捷成长",
    INT = "智力",
    INTplus = "智力成长",
    heroAbilList = "英雄技能ID列表",
    hideHeroMinimap = "隐藏英雄小地图",
    hideHeroBar = "隐藏英雄栏图标",
    hideHeroDeathMsg = "隐藏英雄死亡信息",
    Requiresacount = "科技树-使用等级数",
    Requires1 = "科技树-等级2",
    Reviveat = "指定复活点",
    buffRadius = "路径-AI放置范围",
    buffType = "路径-AI放置类型",
    Revive = "可复活单位",
    Trains = "可训练单位",
    Upgrade = "可升级建筑",
    requirePlace = "路径-放置不允许",
    preventPlace = "路径-放置要求",
    requireWaterRadius = "路径-放置要求距离水的范围",
    pathTex = "路径纹理",
    uberSplat = "建筑地面纹理",
    nbrandom = "中立-可作为随机建筑",
    nbmmlcon = "中立-显示小地图",
    canBuildOn = "能被其他建筑建造",
    isBuildOn = "能建造在其他建筑上",
    tilesets = "大地图-地形设置",
    special = "大地图-分类-特殊",
    campaign = "大地图-分类-战役",
    inEditor = "大地图-可放置",
    dropItems = "大地图-死亡掉落物品",
    hostilePal = "大地图-可作为中立敌对",
    useClickHelper = "大地图-使用点击帮助",
    tilesetSpecific = "大地图-有地形指定数据",
    DependencyOr = "科技树-从属等价物",
    Researches = "科技树-可研究项目",
    upgrades = "使用的科技",
    EditorSuffix = "编辑器后缀",
    Casterupgradename = "魔法升级名字",
    Casterupgradetip = "魔法升级说明",
    Castrerupgradeart = "魔法升级图标",
    ScoreScreenIcon = "图标-记分屏",
    animProps = "要求动画名",
    Attachmentanimprops = "要求动画名-附加动画",
    Attachmentlinkprops = "要求动画名-链接名",
    Boneprops = "要求骨骼名",
    castpt = "动画-施法前摇",
    castbsw = "动画-施法后摇",
    blend = "动画-混合时间（秒）",
    run = "动画-跑步",
    walk = "动画-行走",
    propWin = "动画-转向角度",
    orientInterp = "动画-转向补正",
    teamColor = "队伍颜色",
    customTeamColor = "允许更改队伍颜色",
    elevPts = "高度变化-采样点数量",
    elevRad = "高度变化-采样范围",
    fogRad = "战争迷雾-采样范围",
    fatLOS = "不可见区域显示单位",
    repulse = "组群分离-允许",
    repulsePrio = "组群分离-优先",
    repulseParam = "组群分离-参数",
    repulseGroup = "组群分离-组号",
    isbldg = "是一个建筑",
    bldtm = "建造时间",
    bountyplus = "黄金奖励-值",
    bountysides = "黄金奖励-骰子面数",
    bountydice = "黄金奖励-骰子数量",
    goldRep = "修理黄金消耗",
    lumberRep = "修理木材消耗",
    reptm = "修理时间",
    lumberbountyplus = "木材奖励-值",
    lumberbountysides = "木材奖励-骰子面数",
    lumberbountydice = "木材奖励-骰子数量",
    cargoSize = "运输尺寸",
    hideOnMinimap = "隐藏小地图显示",
    points = "单位附加值",
    prio = "编队优先权",
    formation = "队形排列",
    canFlee = "可以逃跑",
    canSleep = "可以睡眠",
    checkDep = "科技树-检查等价所属",
    Effectsound = "声效-音效",
    Effectsoundlooped = "声效-音效（循环）",
    Researchtip = "学习技能提示",
    Researchubertip = "学习技能描述",
    Unorder = "命令-关闭",
    Orderon = "命令-激活",
    Order = "命令串",
    Orderoff = "命令-取消激活",
    Unhotkey = "热键-关闭",
    Researchhotkey = "热键-学习",
    UnButtonpos1 = "X坐标-关闭",
    UnButtonpos2 = "Y坐标-关闭",
    Researchbuttonpos1 = "X坐标-学习",
    Researchbuttonpos2 = "Y坐标-学习",
    Unart = "图标-关闭",
    Researchart = "图标-学习",
    SpecialArt = "效果-特殊",
    Specialattach = "效果-特殊附加点",
    LightningEffect = "效果-闪电效果",
    EffectArt = "效果-目标点",
    TargetArt = "效果-目标",
    Targetattachcount = "效果-目标-附加数量",
    Targetattach = "效果-目标-附加1",
    Targetattach1 = "效果-目标-附加2",
    Areaeffectart = "效果-区域",
    Animnames = "施法动作",
    CasterArt = "效果-施法者",
    Casterattachcount = "效果-施法者-附加数量",
    Casterattach = "效果-施法者-附加1",
    Casterattach1 = "效果-施法者-附加2",
    hero = "是否英雄技能",
    item = "是否物品技能",
    levels = "等级",
    reqLevel = "等级要求",
    levelSkip = "学习跳等级",
    priority = "魔法偷取优先级",
    BuffID1 = "魔法效果",
    EfctID1 = "区域持续效果",
    DataA1 = "数据A",
    DataB1 = "数据B",
    DataC1 = "数据C",
    DataD1 = "数据D",
    DataE1 = "数据E",
    DataF1 = "数据F",
    Cast1 = "施法时间",
    Cool1 = "冷却时间",
    Dur1 = "持续时间",
    HeroDur1 = "持续时间（英雄）",
    Cost1 = "魔法消耗",
    Rng1 = "施法距离",
    Area1 = "施法范围",
    --
    _id = "物编ID",
    _class = "hslk数据类别",
    _type = "hslk数据形式",
    _parent = "模版物编ID",
    _overlie = "叠加",
    _weight = "重量",
    _desc = "描述",
    _active = "主动",
    _passive = "被动",
    _attr = "属性",
    _attr_txt = "属性(无效)",
    _ring = "光环",
    _cooldown = "冷却时间",
    _cooldownTarget = "冷却技能目标",
    _shadow = "强制使用影子物品"

}

local F6_IDX = 0
local F6_NAME = function(name)
    F6_IDX = F6_IDX + 1
    return (name or "HL-NAME") .. "-" .. F6_IDX
end

local F6V_I_SYNTHESIS_TMP = {
    profit = {},
    fragment = {},
}

local F6S = {}
F6S.a = {
    --- 属性系统目标文本修正
    targetLabel = function(target, actionType, actionField, isValue)
        if (actionType == 'spec' and isValue ~= true and table.includes({ 'split', 'bomb', 'lightning_chain' }, actionField)) then
            if (target == '己') then
                target = '友军'
            else
                target = '敌军'
            end
        else
            if (target == '己') then
                target = '自己'
            else
                target = '敌人'
            end
        end
        return target
    end,
    --- 键值是否百分比数据
    isPercent = function(key)
        if (table.includes({
            "attack_speed", "avoid", "aim",
            "hemophagia", "hemophagia_skill",
            "invincible",
            "knocking_odds", "knocking_extent",
            "damage_extent", "damage_decrease", "damage_rebound",
            "cure",
            "gold_ratio", "lumber_ratio", "exp_ratio", "sell_ratio",
            "knocking", "split",
        }, key))
        then
            return true
        end
        local s = string.find(key, "_oppose")
        local n = string.find(key, "e_")
        local a = string.find(key, "_attack")
        local p = string.find(key, "_append")
        if (a ~= nil or p ~= nil) then
            return false
        end
        if (s ~= nil or n == 1) then
            return true
        end
        return false
    end,
    --- 键值是否层级数据
    isLevel = function(key)
        local a = string.find(key, "_attack")
        local p = string.find(key, "_append")
        local n = string.find(key, "e_")
        if ((a ~= nil or p ~= nil) and n == 1) then
            return true
        end
        return false
    end,
    desc = function(attr, sep, indent)
        indent = indent or ""
        local str = {}
        local strTable = {}
        sep = sep or "|n"
        for _, arr in ipairs(table.obj2arr(attr, CONST_ATTR_KEYS)) do
            local k = arr.key
            local v = arr.value
            -- 附加单位
            if (k == "attack_space") then
                v = v .. "秒"
            end
            if (table.includes({ "life_back", "mana_back" }, k)) then
                v = v .. "每秒"
            end
            if (F6S.a.isPercent(k) == true) then
                v = v .. "%"
            end
            if (F6S.a.isLevel(k) == true) then
                v = v .. "层"
            end
            --
            if (k == "xtras") then
                table.insert(strTable, (CONST_ATTR[k] or "") .. "：")
                local tempStr = {}
                for vvi, vv in ipairs(v) do
                    local on = vv["on"]
                    local actions = string.explode('.', vv["action"] or '')
                    if (CONST_EVENT_LABELS[on] ~= nil and #actions == 3) then
                        local target = CONST_EVENT_TARGET_LABELS[on][actions[1]]
                        local actionType = actions[2]
                        local actionField = actions[3]
                        local actionFieldLabel = CONST_ATTR[actionField]
                        local odds = vv["odds"] or 0
                        local during = vv["during"] or 0
                        local val = vv["val"] or 0
                        local percent = vv["percent"] or 100
                        local qty = vv["qty"] or 0
                        local rate = vv["rate"] or 0
                        local radius = vv["radius"] or 0
                        local distance = vv["distance"] or 0
                        local height = vv["height"] or 0
                        --
                        if (odds > 0 and percent ~= nil and val ~= nil) then
                            -- 拼凑文本
                            local temp2 = '　' .. vvi .. '.' .. CONST_EVENT_LABELS[on] .. '时,'
                            temp2 = temp2 .. "有"
                            temp2 = temp2 .. odds .. "%几率"
                            if (during > 0) then
                                temp2 = temp2 .. "在" .. during .. "秒内"
                            end

                            -- 拼凑值
                            local valLabel
                            local unitLabel = "%"
                            local isNegative = false
                            if (type(percent) == 'table') then
                                unitLabel = ''
                            elseif (percent % 100 == 0) then
                                unitLabel = "倍"
                                percent = math.floor(percent / 100)
                            end
                            if (type(val) == 'number') then
                                if (unitLabel == "%") then
                                    valLabel = math.round(percent * 0.01 * math.abs(val))
                                elseif (unitLabel == "倍") then
                                    valLabel = math.round(percent * math.abs(val))
                                elseif (unitLabel == '') then
                                    valLabel = '随机' .. math.round(percent[1] * math.abs(val)) .. '~' .. math.round(percent[2] * 0.01 * math.abs(val))
                                end
                                isNegative = val < 0
                            elseif (type(val) == 'string') then
                                if (unitLabel == '') then
                                    percent = '随机' .. percent[1] .. '%~' .. percent[2] .. '%'
                                end
                                isNegative = (string.sub(val, 1, 1) == '-')
                                if (isNegative) then
                                    val = string.sub(val, 2)
                                end
                                if (val == 'damage') then
                                    valLabel = percent .. unitLabel .. "当前伤害"
                                else
                                    local valAttr = string.explode('.', val)
                                    if (#valAttr == 2 and CONST_EVENT_TARGET_LABELS[on] and CONST_EVENT_TARGET_LABELS[on][valAttr[1]]) then
                                        local au = CONST_EVENT_TARGET_LABELS[on][valAttr[1]]
                                        au = F6S.a.targetLabel(au, actionType, actionField, true)
                                        local aa = valAttr[2]
                                        if (aa == 'level') then
                                            valLabel = percent .. unitLabel .. au .. "当前等级"
                                        elseif (aa == 'gold') then
                                            valLabel = percent .. unitLabel .. au .. "当前黄金量"
                                        elseif (aa == 'lumber') then
                                            valLabel = percent .. unitLabel .. au .. "当前木头量"
                                        else
                                            valLabel = percent .. unitLabel .. au .. (CONST_ATTR[aa] or '不明属性') .. ""
                                        end
                                    end
                                end
                            end
                            -- 补正百分号
                            if (type(val) == 'number' and F6S.a.isPercent(actionField) == true) then
                                valLabel = valLabel .. "%"
                            end
                            -- 对象名称修正
                            target = F6S.a.targetLabel(target, actionType, actionField)
                            if (valLabel ~= nil) then
                                if (actionType == 'attr') then
                                    if (isNegative) then
                                        temp2 = temp2 .. "减少" .. target
                                    else
                                        temp2 = temp2 .. "提升" .. target
                                    end
                                    temp2 = temp2 .. valLabel .. "的" .. actionFieldLabel
                                elseif (actionType == 'spec') then
                                    actionFieldLabel = vv["alias"] or actionFieldLabel
                                    if (actionField == "knocking") then
                                        temp2 = temp2
                                            .. "对" .. target .. "造成" .. valLabel .. "的" .. actionFieldLabel .. "的伤害"
                                    elseif (actionField == "split") then
                                        temp2 = temp2
                                            .. actionFieldLabel .. "攻击" .. radius .. "范围的"
                                            .. target .. ",造成" .. valLabel .. "的伤害"
                                    elseif (actionField == "bomb") then
                                        temp2 = temp2
                                            .. actionFieldLabel .. radius .. "范围的" .. target
                                            .. ",造成" .. valLabel .. "的伤害"
                                    elseif (table.includes({ "swim", "silent", "unarm", "fetter" }, actionField)) then
                                        temp2 = temp2
                                            .. actionFieldLabel .. "目标" .. during .. "秒"
                                            .. ",并造成" .. valLabel .. "点伤害"
                                    elseif (actionField == "broken") then
                                        temp2 = temp2
                                            .. actionFieldLabel .. "目标" .. ",并造成" .. valLabel .. "点伤害"
                                    elseif (actionField == "lightning_chain") then
                                        temp2 = temp2
                                            .. "对最多" .. qty .. "个目标"
                                            .. "发动" .. valLabel .. "的伤害的" .. actionFieldLabel
                                        if (rate > 0) then
                                            temp2 = temp2 .. ",每次跳跃渐强" .. rate .. "%"
                                        elseif (rate < 0) then
                                            temp2 = temp2 .. ",每次跳跃衰减" .. rate .. "%"
                                        end
                                    elseif (actionField == "crack_fly") then
                                        temp2 = temp2
                                            .. actionFieldLabel .. "目标达" .. height .. "高度并击退" .. distance .. "距离"
                                            .. ",同时造成" .. valLabel .. "的伤害"
                                    elseif (actionField == "paw") then
                                        temp2 = temp2
                                            .. "向前方击出" .. qty .. "道" .. actionFieldLabel
                                            .. ",对直线" .. radius .. "范围的" .. target .. "造成" .. valLabel .. "的伤害"
                                    end
                                end
                                table.insert(tempStr, indent .. temp2)
                            end
                        end
                    end
                end
                table.insert(strTable, string.implode(sep, tempStr))
            else
                table.insert(str, indent .. (CONST_ATTR[k] or "") .. "：" .. v)
            end
        end
        return string.implode(sep, table.merge(str, strTable))
    end,
    ubertip = {
        common = function(v)
            local d = {}
            if (v._desc ~= nil and v._desc ~= "") then
                table.insert(d, hcolor.mixed(v._desc, SLK_CONF.color.abilityDesc))
            end
            if (v._attr ~= nil) then
                table.insert(d, hcolor.mixed(F6S.a.desc(v._attr, "|n"), SLK_CONF.color.abilityAttr))
            end
            return string.implode("|n", d)
        end,
        empty = function(v)
            local d = {}
            if (v._desc ~= nil and v._desc ~= "") then
                table.insert(d, hcolor.mixed(v._desc, SLK_CONF.color.abilityDesc))
            end
            if (v._attr ~= nil) then
                table.insert(d, hcolor.mixed(F6S.a.desc(v._attr, "|n"), SLK_CONF.color.abilityAttr))
            end
            return string.implode("|n", d)
        end,
        ring = function(v)
            local d = {}
            if (v._ring.radius ~= nil) then
                table.insert(d, hcolor.mixed("光环范围：" .. v._ring.radius, SLK_CONF.color.ringArea))
            end
            if (type(v._ring.target) == 'table' and #v._ring.target > 0) then
                local labels = {}
                for _, t in ipairs(v._ring.target) do
                    table.insert(labels, CONST_TARGET_LABEL[t])
                end
                table.insert(d, hcolor.mixed("光环目标：" .. string.implode(',', labels), SLK_CONF.color.ringTarget))
                labels = nil
            end
            if (v._ring.attr ~= nil) then
                table.insert(d, hcolor.mixed("光环效果：|n" .. F6S.a.desc(v._ring.attr, "|n", ' - '), SLK_CONF.color.ringTarget))
            end
            if (v._attr ~= nil) then
                table.insert(d, hcolor.mixed("独占效果：", SLK_CONF.color.abilityAttr))
                table.insert(d, hcolor.mixed(F6S.a.desc(v._attr, "|n", ' - '), SLK_CONF.color.abilityAttr))
                table.insert(d, "|n")
            end
            if (v._desc ~= nil and v._desc ~= "") then
                table.insert(d, hcolor.mixed(v._desc, SLK_CONF.color.ringDesc))
            end
            return string.implode("|n", d)
        end
    },
}
F6S.i = {
    desc = function(_v)
        local d = {}
        if (_v._active ~= nil) then
            table.insert(d, "主动：" .. _v._active)
        end
        if (_v._passive ~= nil) then
            table.insert(d, "被动：" .. _v._passive)
        end
        if (_v._attr ~= nil) then
            table.insert(d, F6S.a.desc(_v._attr, ";"))
        end
        -- 仅文本无效果，适用于例如技能书这类的物品
        if (_v._attr_txt ~= nil) then
            table.insert(d, F6S.a.desc(_v._attr_txt, ";"))
        end
        local overlie = _v._overlie or 1
        local weight = _v._weight or 0
        weight = tostring(math.round(weight))
        table.insert(d, "叠加：" .. overlie .. ";重量：" .. weight .. "Kg")
        if (_v._remarks ~= nil and _v._remarks ~= "") then
            table.insert(d, _v._remarks)
        end
        return string.implode("|n", d)
    end,
    ubertip = function(_v)
        local d = {}
        if (_v._active ~= nil) then
            table.insert(d, hcolor.mixed("主动：" .. _v._active, SLK_CONF.color.itemActive))
            if (_v.cooldown ~= nil and _v.cooldown > 0) then
                table.insert(d, hcolor.mixed("冷却：" .. _v.cooldown .. "秒", SLK_CONF.color.itemCoolDown))
            end
        end
        if (_v._passive ~= nil) then
            table.insert(d, hcolor.mixed("被动：" .. _v._passive, SLK_CONF.color.itemPassive))
        end
        if (_v._ring ~= nil) then
            if (_v._ring.attr ~= nil and _v._ring.radius ~= nil and (type(_v._ring.target) == 'table' and #_v._ring.target > 0)) then
                local txt = "光环：[" .. _v._ring.radius .. "px|n"
                table.insert(d, hcolor.mixed(txt .. F6S.a.desc(_v._ring.attr, "|n", ' - '), SLK_CONF.color.ringTarget))
            end
        end
        if (_v._attr ~= nil) then
            table.insert(d, hcolor.mixed(F6S.a.desc(_v._attr, "|n"), SLK_CONF.color.itemAttr))
        end
        -- 仅文本无效果，适用于例如技能书这类的物品
        if (_v._attr_txt ~= nil) then
            table.insert(d, hcolor.mixed(F6S.a.desc(_v._attr_txt, "|n"), SLK_CONF.color.itemAttr))
        end
        -- 作为零件
        if (F6V_I_SYNTHESIS_TMP.fragment[_v.Name] ~= nil
            and #F6V_I_SYNTHESIS_TMP.fragment[_v.Name] > 0) then
            table.insert(d, hcolor.mixed("可以合成：" .. string.implode(
                '、',
                F6V_I_SYNTHESIS_TMP.fragment[_v.Name]),
                SLK_CONF.color.itemFragment
            ))
        end
        -- 合成公式
        if (F6V_I_SYNTHESIS_TMP.profit[_v.Name] ~= nil) then
            table.insert(d, hcolor.mixed("需要零件：" .. F6V_I_SYNTHESIS_TMP.profit[_v.Name], SLK_CONF.color.itemProfit))
        end
        local overlie = _v._overlie or 1
        table.insert(d, hcolor.mixed("叠加：" .. overlie, SLK_CONF.color.itemOverlie))
        local weight = _v._weight or 0
        weight = tostring(math.round(weight))
        table.insert(d, hcolor.mixed("重量：" .. weight .. "Kg", SLK_CONF.color.itemWeight))
        if (_v._remarks ~= nil and _v._remarks ~= "") then
            table.insert(d, hcolor.mixed(_v._remarks, SLK_CONF.color.itemRemarks))
        end
        return string.implode("|n", d)
    end
}

------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------

------@private
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
        --
        local fmStr = {}
        for _, fm in ipairs(fragment) do
            if (fm[2] <= 1) then
                table.insert(fmStr, fm[1])
            else
                table.insert(fmStr, fm[1] .. 'x' .. fm[2])
            end
            if (F6V_I_SYNTHESIS_TMP.fragment[fm[1]] == nil) then
                F6V_I_SYNTHESIS_TMP.fragment[fm[1]] = {}
            end
            if (table.includes(F6V_I_SYNTHESIS_TMP.fragment[fm[1]], profit[1]) == false) then
                table.insert(F6V_I_SYNTHESIS_TMP.fragment[fm[1]], profit[1])
            end
        end
        F6V_I_SYNTHESIS_TMP.profit[profit[1]] = string.implode('+', fmStr)
        --
        table.insert(formulas, { _profit = profit, _fragment = fragment })
    end
    return formulas
end

F6V_A = function(_v)
    _v._class = "ability"
    for k, v in pairs(F6_DEF.a) do
        if (_v[k] == nil and v ~= nil) then
            _v[k] = v
        end
    end
    if (_v.Name == nil) then
        _v.Name = F6_NAME("未命名技能")
    end
    if (_v.Ubertip == nil) then
        _v.Ubertip = F6S.a.ubertip.common(_v)
    end
    return _v
end

F6V_A_E = function(_v)
    _v._parent = "Aamk"
    _v._type = "empty"
    if (_v.Name == nil) then
        _v.Name = F6_NAME("未命名被动")
    end
    if (_v.Hotkey ~= nil) then
        _v.Buttonpos1 = CONST_HOTKEY_ABILITY_KV[_v.Hotkey].Buttonpos1 or 0
        _v.Buttonpos2 = CONST_HOTKEY_ABILITY_KV[_v.Hotkey].Buttonpos2 or 0
        _v.Tip = _v.Name .. "[" .. hcolor.mixed(_v.Hotkey, SLK_CONF.color.hotKey) .. "]"
        _v.Name = _v.Name .. _v.Hotkey
    else
        _v.Tip = _v.Name
    end
    if (_v.Ubertip == nil) then
        _v.Ubertip = F6S.a.ubertip.empty(_v)
    end
    return F6V_A(_v)
end

F6V_A_R = function(_v)
    _v._parent = "Aamk"
    _v._type = "ring"
    if (_v.Name == nil) then
        _v.Name = F6_NAME("未命名光环")
    end
    if (_v.Hotkey ~= nil) then
        _v.Buttonpos1 = CONST_HOTKEY_ABILITY_KV[_v.Hotkey].Buttonpos1 or 0
        _v.Buttonpos2 = CONST_HOTKEY_ABILITY_KV[_v.Hotkey].Buttonpos2 or 0
        _v.Tip = _v.Name .. "[" .. hcolor.mixed(_v.Hotkey, SLK_CONF.color.hotKey) .. "]"
        _v.Name = _v.Name .. _v.Hotkey
    else
        _v.Tip = _v.Name
    end
    if (_v.Ubertip == nil) then
        _v.Ubertip = F6S.a.ubertip.ring(_v)
    end
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
    return F6V_A(_v)
end

F6V_U = function(_v)
    _v._class = "unit"
    for k, v in pairs(F6_DEF.u) do
        if (_v[k] == nil and v ~= nil) then
            _v[k] = v
        end
    end
    if (_v.Name == nil) then
        _v.Name = F6_NAME("未命名单位")
    end
    return _v
end

F6V_I_CD = function(_v)
    if (_v._cooldown == nil) then
        return "AIat"
    end
    if (_v._cooldown < 0) then
        _v._cooldown = 0
    end
    if (_v._cooldown == 0) then
        return H_LUA_SKILL_CD0
    end
    local adTips = "H_LUA_ICD_" .. _v.Name
    local cdID
    local ad = {
        Effectsound = "",
        Name = adTips,
        Tip = adTips,
        Ubertip = adTips,
        TargetArt = _v.TargetArt or "",
        Targetattach = _v.Targetattach or "",
        Animnames = _v.Animnames or "spell",
        CasterArt = _v.CasterArt or "",
        Art = "",
        item = 1,
        Cast1 = _v._cast or 0,
        Cost1 = _v._cost or 0,
        Cool1 = _v._cooldown,
        Requires = "",
        Hotkey = "",
        Buttonpos1 = "0",
        Buttonpos2 = "0",
        race = "other",
    }
    if (_v._cooldownTarget == CONST_ABILITY_TARGET.location.value) then
        -- 对点（模版：照明弹）
        ad._parent = "Afla"
        ad.DataA1 = 0
        ad.EfctID1 = ""
        ad.Dur1 = 0.01
        ad.HeroDur1 = 0.01
        ad.Rng1 = _v.Rng1 or 600
        ad.Area1 = 0
        ad.DataA1 = 0
        ad.DataB1 = 0
        local av = hslk_ability(ad)
        print(av)
        cdID = av._id
    elseif (_v.cooldownTarget == CONST_ABILITY_TARGET.range.value) then
        -- 对点范围（模版：暴风雪）
        ad._parent = "ACbz"
        ad.BuffID1 = ""
        ad.EfctID1 = ""
        ad.Rng1 = _v.Rng1 or 300
        ad.Area1 = _v.Area1 or 300
        ad.DataA1 = 0
        ad.DataB1 = 0
        ad.DataC1 = 0
        ad.DataD1 = 0
        ad.DataE1 = 0
        ad.DataF1 = 0
        local av = hslk_ability(ad)
        print(av)
        cdID = av._id
    elseif (_v._cooldownTarget == CONST_ABILITY_TARGET.unit.value) then
        -- 对单位（模版：霹雳闪电）
        ad._parent = "ACfb"
        ad.Missileart = _v.Missileart or "Abilities\\Weapons\\FireBallMissile\\FireBallMissile.mdl"
        ad.Missilespeed = _v.Missilespeed or 1000
        ad.Missilearc = _v.Missilearc or 0
        ad.targs1 = _v.targs1 or "air,ground,organic,enemy,neutral"
        ad.Rng1 = _v.Rng1 or 800
        ad.Area1 = _v.Area1 or 0
        ad.DataA1 = 0
        ad.Dur1 = 0.01
        ad.HeroDur1 = 0.01
        local av = hslk_ability(ad)
        print(av)
        cdID = av._id
    else
        -- 立刻（模版：金箱子）
        ad._parent = "AIgo"
        ad.DataA1 = 0
        local av = hslk_ability(ad)
        print(av)
        cdID = av._id
    end
    return cdID
end

F6V_I_SHADOW = function(_v)
    _v._class = "item"
    _v._type = "shadow"
    _v.Name = "　" .. _v.Name .. "　"
    _v.class = "Charged"
    _v.abilList = ""
    _v.ignoreCD = 1
    _v.perishable = 1
    _v.usable = 1
    _v.powerup = 1
    return _v
end

F6V_I = function(_v)
    _v._class = "item"
    local cd = F6V_I_CD(_v)
    if (cd ~= "AIat") then
        _v.abilList = cd
        _v.usable = 1
        if (_v.perishable == nil) then
            _v.perishable = 1
        end
        _v.class = "Charged"
        if (cd == H_LUA_SKILL_CD0) then
            _v.ignoreCD = 1
        end
    else
        if (_v.perishable == nil) then
            _v.perishable = 0
        end
        _v.class = "Permanent"
    end
    for k, v in pairs(F6_DEF.i) do
        if (_v[k] == nil and v ~= nil) then
            _v[k] = v
        end
    end
    if (_v.Name == nil) then
        _v.Name = F6_NAME("未命名物品")
    end
    if (_v._overlie < _v.uses) then
        _v._overlie = _v.uses
    end
    -- 处理 _shadow
    if (type(_v._shadow) ~= 'boolean') then
        _v._shadow = (SLK_CONF.autoShadowItem == true and _v.powerup == 0)
    end
    -- 处理 _ring光环
    if (_v._ring ~= nil) then
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
    if (_v.Description == nil) then
        _v.Description = F6S.i.desc(_v)
    end
    if (_v.Ubertip == nil) then
        _v.Ubertip = F6S.i.ubertip(_v)
    end
    if (_v.Level == nil) then
        _v.Level = math.floor(((_v.goldcost or def.goldcost) + (_v.lumbercost or def.lumbercost)) / 500)
    end
    if (_v.oldLevel == nil) then
        _v.oldLevel = _v.Level
    end
    if (_v.Hotkey ~= nil) then
        _v.Buttonpos1 = CONST_HOTKEY_FULL_KV[_v.Hotkey].Buttonpos1 or 0
        _v.Buttonpos2 = CONST_HOTKEY_FULL_KV[_v.Hotkey].Buttonpos2 or 0
        _v.Tip = "获得" .. _v.Name .. "(" .. hcolor.mixed(_v.Hotkey, SLK_CONF.color.hotKey) .. ")"
    else
        _v.Buttonpos1 = _v.Buttonpos1 or 0
        _v.Buttonpos2 = _v.Buttonpos2 or 0
        _v.Tip = "获得" .. _v.Name
    end
    return _v
end