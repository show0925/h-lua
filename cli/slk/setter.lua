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
        _cooldown = nil,
    },
    i = {
        abiList = "",
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
        sight = 1400,
        nsight = 800,
        -- 模型相关
        buffRadius = 0,
        buffType = "_",
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
        stockMax = nil,
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
        _active = nil,
        _passive = nil,
        _attr = nil,
        _attr_txt = nil,
        _ring = nil,
        _cooldown = nil,
        _shadow = false,
    },
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

F6V_A_CD_0 = nil
F6V_I_CD_0 = function()
    if (F6V_A_CD_0 == nil) then
        local av = hslk_ability({
            _parent = "AIgo",
            Name = "H_LUA_ICD0",
            Tip = "H_LUA_ICD0",
            Ubertip = "H_LUA_ICD0",
            Effectsound = "",
            Art = "",
            TargetArt = "",
            Targetattach = "",
            DataA1 = 0,
            CasterArt = "",
            Cool = 0,
        })
        print(av)
        F6V_A_CD_0 = av._id
    end
    return F6V_A_CD_0
end

F6V_I_CD = function(_v)
    if (_v._cooldown == nil) then
        return "AIat"
    end
    if (_v._cooldown < 0) then
        _v._cooldown = 0
    end
    if (_v._cooldown == 0) then
        return F6V_I_CD_0()
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
        if (cd == F6V_A_CD_0) then
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