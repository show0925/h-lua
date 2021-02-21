henvData = {
    --- 单位装饰模型
    unit = {
        fire = string.char2id(hslk.n2i("H_LUA_ENV_FIRE")), -- 火焰
        fireblue = string.char2id(hslk.n2i("H_LUA_ENV_FIREBLUE")), --蓝色火焰
        firetrap = string.char2id(hslk.n2i("H_LUA_ENV_FIRETRAP")), -- 火焰陷阱
        firetrapblue = string.char2id(hslk.n2i("H_LUA_ENV_FIRETRAPBLUE")), -- 蓝色火焰陷阱
        lightningbolt = string.char2id(hslk.n2i("H_LUA_ENV_LIGHTNINGBOLT")), -- 季风闪电
        snowman = string.char2id(hslk.n2i("H_LUA_ENV_SNOWMAN")), -- 雪人
        bubble_geyser = string.char2id(hslk.n2i("H_LUA_ENV_BUBBLE_GEYSER")), -- 泡沫
        bubble_geyser_steam = string.char2id(hslk.n2i("H_LUA_ENV_BUBBLE_GEYSER_STEam")), -- 带蒸汽泡沫
        fish_school = string.char2id(hslk.n2i("H_LUA_ENV_FISH_SCHOOL")), -- 小鱼群
        fish = string.char2id(hslk.n2i("H_LUA_ENV_FISH")), -- 鱼
        fish_green = string.char2id(hslk.n2i("H_LUA_ENV_FISH_GREEN")), -- 绿色的鱼
        fire_hole = string.char2id(hslk.n2i("H_LUA_ENV_FIRE_HOLE")), -- 火焰弹坑
        bird = string.char2id(hslk.n2i("H_LUA_ENV_BIRD")), -- 鸟
        bats = string.char2id(hslk.n2i("H_LUA_ENV_BATS")), -- 蝙蝠
        flies = string.char2id(hslk.n2i("H_LUA_ENV_FLIES")), -- 苍蝇
        burn_build = string.char2id(hslk.n2i("H_LUA_ENV_BURN_BUILD")), --焚烧毁坏建筑
        ice0 = string.char2id(hslk.n2i("H_LUA_ENV_ICE0")), -- 冰块
        ice1 = string.char2id(hslk.n2i("H_LUA_ENV_ICE1")),
        ice2 = string.char2id(hslk.n2i("H_LUA_ENV_ICE2")),
        ice3 = string.char2id(hslk.n2i("H_LUA_ENV_ICE3")),
        seaweed0 = string.char2id(hslk.n2i("H_LUA_ENV_SEAWEED0")), -- 海藻
        seaweed1 = string.char2id(hslk.n2i("H_LUA_ENV_SEAWEED1")),
        seaweed2 = string.char2id(hslk.n2i("H_LUA_ENV_SEAWEED2")),
        seaweed3 = string.char2id(hslk.n2i("H_LUA_ENV_SEAWEED3")),
        seaweed4 = string.char2id(hslk.n2i("H_LUA_ENV_SEAWEED4")),
        break_column0 = string.char2id(hslk.n2i("H_LUA_ENV_BREAK_COLUMN0")), --断裂的圆柱
        break_column1 = string.char2id(hslk.n2i("H_LUA_ENV_BREAK_COLUMN1")),
        break_column2 = string.char2id(hslk.n2i("H_LUA_ENV_BREAK_COLUMN2")),
        break_column3 = string.char2id(hslk.n2i("H_LUA_ENV_BREAK_COLUMN3")),
        burn_body0 = string.char2id(hslk.n2i("H_LUA_ENV_BURN_BODY0")), -- 焚烧尸体
        burn_body1 = string.char2id(hslk.n2i("H_LUA_ENV_BURN_BODY1")),
        burn_body2 = string.char2id(hslk.n2i("H_LUA_ENV_BURN_BODY2")),
        impaled_body0 = string.char2id(hslk.n2i("H_LUA_ENV_IMPALED_BODY0")), -- 叉着的尸体
        impaled_body1 = string.char2id(hslk.n2i("H_LUA_ENV_IMPALED_BODY1")),
        rune0 = string.char2id(hslk.n2i("H_LUA_ENV_RUNE0")), --血色符文
        rune1 = string.char2id(hslk.n2i("H_LUA_ENV_RUNE1")),
        rune2 = string.char2id(hslk.n2i("H_LUA_ENV_RUNE2")),
        rune3 = string.char2id(hslk.n2i("H_LUA_ENV_RUNE3")),
        rune4 = string.char2id(hslk.n2i("H_LUA_ENV_RUNE4")),
        rune5 = string.char2id(hslk.n2i("H_LUA_ENV_RUNE5")),
        rune6 = string.char2id(hslk.n2i("H_LUA_ENV_RUNE6")),
        glowing_rune0 = string.char2id(hslk.n2i("H_LUA_ENV_GLOWING_RUNE0")), --发光符文
        glowing_rune1 = string.char2id(hslk.n2i("H_LUA_ENV_GLOWING_RUNE1")),
        glowing_rune2 = string.char2id(hslk.n2i("H_LUA_ENV_GLOWING_RUNE2")),
        glowing_rune3 = string.char2id(hslk.n2i("H_LUA_ENV_GLOWING_RUNE3")),
        glowing_rune4 = string.char2id(hslk.n2i("H_LUA_ENV_GLOWING_RUNE4")),
        glowing_rune5 = string.char2id(hslk.n2i("H_LUA_ENV_GLOWING_RUNE5")),
        glowing_rune6 = string.char2id(hslk.n2i("H_LUA_ENV_GLOWING_RUNE6")),
        glowing_rune7 = string.char2id(hslk.n2i("H_LUA_ENV_GLOWING_RUNE7")),
        glowing_rune8 = string.char2id(hslk.n2i("H_LUA_ENV_GLOWING_RUNE8")),
        bone0 = string.char2id(hslk.n2i("H_LUA_ENV_BONE0")), -- 岩石
        bone1 = string.char2id(hslk.n2i("H_LUA_ENV_BONE1")),
        bone2 = string.char2id(hslk.n2i("H_LUA_ENV_BONE2")),
        bone3 = string.char2id(hslk.n2i("H_LUA_ENV_BONE3")),
        bone4 = string.char2id(hslk.n2i("H_LUA_ENV_BONE4")),
        bone5 = string.char2id(hslk.n2i("H_LUA_ENV_BONE5")),
        bone6 = string.char2id(hslk.n2i("H_LUA_ENV_BONE6")),
        bone7 = string.char2id(hslk.n2i("H_LUA_ENV_BONE7")),
        bone8 = string.char2id(hslk.n2i("H_LUA_ENV_BONE8")),
        bone9 = string.char2id(hslk.n2i("H_LUA_ENV_BONE9")),
        bone_ice0 = string.char2id(hslk.n2i("H_LUA_ENV_BONE_ICE0")), -- 冬天岩石
        bone_ice1 = string.char2id(hslk.n2i("H_LUA_ENV_BONE_ICE1")),
        bone_ice2 = string.char2id(hslk.n2i("H_LUA_ENV_BONE_ICE2")),
        bone_ice3 = string.char2id(hslk.n2i("H_LUA_ENV_BONE_ICE3")),
        bone_ice4 = string.char2id(hslk.n2i("H_LUA_ENV_BONE_ICE4")),
        bone_ice5 = string.char2id(hslk.n2i("H_LUA_ENV_BONE_ICE5")),
        bone_ice6 = string.char2id(hslk.n2i("H_LUA_ENV_BONE_ICE6")),
        bone_ice7 = string.char2id(hslk.n2i("H_LUA_ENV_BONE_ICE7")),
        bone_ice8 = string.char2id(hslk.n2i("H_LUA_ENV_BONE_ICE8")),
        bone_ice9 = string.char2id(hslk.n2i("H_LUA_ENV_BONE_ICE9")),
        stone0 = string.char2id(hslk.n2i("H_LUA_ENV_STONE0")), -- 岩石2
        stone1 = string.char2id(hslk.n2i("H_LUA_ENV_STONE1")),
        stone2 = string.char2id(hslk.n2i("H_LUA_ENV_STONE2")),
        stone3 = string.char2id(hslk.n2i("H_LUA_ENV_STONE3")),
        stone4 = string.char2id(hslk.n2i("H_LUA_ENV_STONE4")),
        stone5 = string.char2id(hslk.n2i("H_LUA_ENV_STONE5")),
        stone6 = string.char2id(hslk.n2i("H_LUA_ENV_STONE6")),
        stone7 = string.char2id(hslk.n2i("H_LUA_ENV_STONE7")),
        stone8 = string.char2id(hslk.n2i("H_LUA_ENV_STONE8")),
        stone9 = string.char2id(hslk.n2i("H_LUA_ENV_STONE9")),
        stone_show0 = string.char2id(hslk.n2i("H_LUA_ENV_STONE_SHOW0")), -- 雪岩石
        stone_show1 = string.char2id(hslk.n2i("H_LUA_ENV_STONE_SHOW1")),
        stone_show2 = string.char2id(hslk.n2i("H_LUA_ENV_STONE_SHOW2")),
        stone_show3 = string.char2id(hslk.n2i("H_LUA_ENV_STONE_SHOW3")),
        stone_show4 = string.char2id(hslk.n2i("H_LUA_ENV_STONE_SHOW4")),
        stone_show5 = string.char2id(hslk.n2i("H_LUA_ENV_STONE_SHOW5")),
        stone_show6 = string.char2id(hslk.n2i("H_LUA_ENV_STONE_SHOW6")),
        stone_show7 = string.char2id(hslk.n2i("H_LUA_ENV_STONE_SHOW7")),
        stone_show8 = string.char2id(hslk.n2i("H_LUA_ENV_STONE_SHOW8")),
        stone_show9 = string.char2id(hslk.n2i("H_LUA_ENV_STONE_SHOW9")),
        mushroom0 = string.char2id(hslk.n2i("H_LUA_ENV_MUSHROOM0")), -- 蘑菇
        mushroom1 = string.char2id(hslk.n2i("H_LUA_ENV_MUSHROOM1")),
        mushroom2 = string.char2id(hslk.n2i("H_LUA_ENV_MUSHROOM2")),
        mushroom3 = string.char2id(hslk.n2i("H_LUA_ENV_MUSHROOM3")),
        mushroom4 = string.char2id(hslk.n2i("H_LUA_ENV_MUSHROOM4")),
        mushroom5 = string.char2id(hslk.n2i("H_LUA_ENV_MUSHROOM5")),
        mushroom6 = string.char2id(hslk.n2i("H_LUA_ENV_MUSHROOM6")),
        mushroom7 = string.char2id(hslk.n2i("H_LUA_ENV_MUSHROOM7")),
        mushroom8 = string.char2id(hslk.n2i("H_LUA_ENV_MUSHROOM8")),
        mushroom9 = string.char2id(hslk.n2i("H_LUA_ENV_MUSHROOM9")),
        mushroom10 = string.char2id(hslk.n2i("H_LUA_ENV_MUSHROOM10")),
        mushroom11 = string.char2id(hslk.n2i("H_LUA_ENV_MUSHROOM11")),
        flower0 = string.char2id(hslk.n2i("H_LUA_ENV_FLOWER0")), -- 鲜花
        flower1 = string.char2id(hslk.n2i("H_LUA_ENV_FLOWER1")),
        flower2 = string.char2id(hslk.n2i("H_LUA_ENV_FLOWER2")),
        flower3 = string.char2id(hslk.n2i("H_LUA_ENV_FLOWER3")),
        flower4 = string.char2id(hslk.n2i("H_LUA_ENV_FLOWER4")),
        typha0 = string.char2id(hslk.n2i("H_LUA_ENV_TYPHA0")), -- 香蒲
        typha1 = string.char2id(hslk.n2i("H_LUA_ENV_TYPHA1")),
        lilypad0 = string.char2id(hslk.n2i("H_LUA_ENV_LILYPAD0")), -- 睡莲
        lilypad1 = string.char2id(hslk.n2i("H_LUA_ENV_LILYPAD1")),
        lilypad2 = string.char2id(hslk.n2i("H_LUA_ENV_LILYPAD2")),
        coral0 = string.char2id(hslk.n2i("H_LUA_ENV_CORAL0")), -- 珊瑚
        coral1 = string.char2id(hslk.n2i("H_LUA_ENV_CORAL1")),
        coral2 = string.char2id(hslk.n2i("H_LUA_ENV_CORAL2")),
        coral3 = string.char2id(hslk.n2i("H_LUA_ENV_CORAL3")),
        coral4 = string.char2id(hslk.n2i("H_LUA_ENV_CORAL4")),
        coral5 = string.char2id(hslk.n2i("H_LUA_ENV_CORAL5")),
        coral6 = string.char2id(hslk.n2i("H_LUA_ENV_CORAL6")),
        coral7 = string.char2id(hslk.n2i("H_LUA_ENV_CORAL7")),
        coral8 = string.char2id(hslk.n2i("H_LUA_ENV_CORAL8")),
        coral9 = string.char2id(hslk.n2i("H_LUA_ENV_CORAL9")),
        shells0 = string.char2id(hslk.n2i("H_LUA_ENV_SHELLS0")), -- 贝壳
        shells1 = string.char2id(hslk.n2i("H_LUA_ENV_SHELLS1")),
        shells2 = string.char2id(hslk.n2i("H_LUA_ENV_SHELLS2")),
        shells3 = string.char2id(hslk.n2i("H_LUA_ENV_SHELLS3")),
        shells4 = string.char2id(hslk.n2i("H_LUA_ENV_SHELLS4")),
        shells5 = string.char2id(hslk.n2i("H_LUA_ENV_SHELLS5")),
        shells6 = string.char2id(hslk.n2i("H_LUA_ENV_SHELLS6")),
        shells7 = string.char2id(hslk.n2i("H_LUA_ENV_SHELLS7")),
        shells8 = string.char2id(hslk.n2i("H_LUA_ENV_SHELLS8")),
        shells9 = string.char2id(hslk.n2i("H_LUA_ENV_SHELLS9")),
        skull_pile0 = string.char2id(hslk.n2i("H_LUA_ENV_SKULL_PILE0")), -- 头骨
        skull_pile1 = string.char2id(hslk.n2i("H_LUA_ENV_SKULL_PILE1")),
        skull_pile2 = string.char2id(hslk.n2i("H_LUA_ENV_SKULL_PILE2")),
        skull_pile3 = string.char2id(hslk.n2i("H_LUA_ENV_SKULL_PILE3")),
        river_rushes0 = string.char2id(hslk.n2i("H_LUA_ENV_RIVER_RUSHES0")), -- 河草
        river_rushes1 = string.char2id(hslk.n2i("H_LUA_ENV_RIVER_RUSHES1")),
        river_rushes2 = string.char2id(hslk.n2i("H_LUA_ENV_RIVER_RUSHES2")),
        river_rushes3 = string.char2id(hslk.n2i("H_LUA_ENV_RIVER_RUSHES3"))
    },
    --- 装饰物
    doodad = {
        block = {
            string.char2id("LTba")
        },
        cage = {
            string.char2id("LOcg")
        },
        bucket = {
            string.char2id("LTbr"),
            string.char2id("LTbx"),
            string.char2id("LTbs")
        },
        bucketBrust = {
            string.char2id("LTex")
        },
        box = {
            string.char2id("LTcr")
        },
        supportColumn = {
            string.char2id("BTsc")
        },
        stone = {
            string.char2id("LTrc")
        },
        stoneRed = {
            string.char2id("DTrc")
        },
        stoneIce = {
            string.char2id("ITcr")
        },
        ice = {
            string.char2id("ITf1"),
            string.char2id("ITf2"),
            string.char2id("ITf3"),
            string.char2id("ITf4"),
        },
        spiderEggs = {
            string.char2id("DTes")
        },
        volcano = {
            -- 火山
            string.char2id("Volc")
        },
        treeSummer = {
            string.char2id("LTlt")
        },
        treeAutumn = {
            string.char2id("FTtw")
        },
        treeWinter = {
            string.char2id("WTtw")
        },
        treeWinterShow = {
            string.char2id("WTst")
        },
        treeDark = {
            -- 枯枝
            string.char2id("NTtw")
        },
        treeDarkUmbrella = {
            -- 伞
            string.char2id("NTtc")
        },
        treePoor = {
            -- 贫瘠
            string.char2id("BTtw")
        },
        treePoorUmbrella = {
            -- 伞
            string.char2id("BTtc")
        },
        treeRuins = {
            -- 遗迹
            string.char2id("ZTtw")
        },
        treeRuinsUmbrella = {
            -- 伞
            string.char2id("ZTtc")
        },
        treeUnderground = {
            -- 地下城
            string.char2id("DTsh"),
            string.char2id("GTsh")
        }
    },
    --- 地表纹理
    ground = {
        summer = string.char2id("Lgrs"), -- 洛丹伦 - 夏 - 草地
        autumn = string.char2id("LTlt"), -- 洛丹伦 - 秋 - 草地
        winter = string.char2id("Iice"), -- 冰封王座 - 冰
        winterDeep = string.char2id("Iice"), -- 冰封王座 - 冰
        poor = string.char2id("Ldrt"), -- 洛丹伦 - 夏- 泥土
        ruins = string.char2id("Ldro"), -- 洛丹伦 - 夏- 烂泥土（坑洼的泥土）
        fire = string.char2id("Dlvc"), -- 地下城 - 岩浆碎片
        underground = string.char2id("Clvg"), -- 费尔伍德 - 叶子
        sea = nil, -- 无地表
        dark = nil, -- 无地表
        river = nil, -- 无地表
    },
}
henv = {
    --- 删除可破坏物
    --- * 当可破坏物被破坏时删除会引起游戏崩溃
    delDestructable = function(whichDestructable, delay)
        delay = delay or 0.5
        if (delay == nil or delay <= 0) then
            cj.RemoveDestructable(whichDestructable)
            whichDestructable = nil
        else
            htime.setTimeout(delay, function(t)
                htime.delTimer(t)
                cj.RemoveDestructable(whichDestructable)
                whichDestructable = nil
            end)
        end
    end,
    --- 清理可破坏物
    _clearDestructable = function()
        cj.RemoveDestructable(cj.GetEnumDestructable())
    end
}

--- 设置迷雾状态
---@param enable boolean 战争迷雾
---@param enableMark boolean 黑色阴影
henv.setFogStatus = function(enable, enableMark)
    cj.FogEnable(enable)
    cj.FogMaskEnable(enableMark)
end

--- 随机构建时的装饰物(参考默认例子)
---@param doodads table
henv.setDoodad = function(doodads)
    henvData.doodad = doodads
end

--- 随机构建时的地表纹理(参考默认例子)
--- 这是附着的额外地形，应当在地形编辑器控制主要地形
---@param grounds table
henv.setGround = function(grounds)
    henvData.ground = grounds
end

--- 清空一片区域的可破坏物
henv.clearDestructable = function(whichRect)
    cj.EnumDestructablesInRect(whichRect, nil, henv._clearDestructable)
end

--- 构建区域装饰
---@param whichRect userdata
---@param typeStr string
---@param isInvulnerable boolean 可破坏物是否无敌
---@param isDestroyRect boolean
---@param ground number
---@param doodad userdata
---@param units table
henv.build = function(whichRect, typeStr, isInvulnerable, isDestroyRect, ground, doodad, units)
    if (whichRect == nil or typeStr == nil) then
        return
    end
    if (doodad == nil or units == nil) then
        return
    end
    if (false == hcache.exist(whichRect)) then
        hcache.alloc(whichRect)
    end
    -- 清理装饰单位
    local rectUnits = hcache.get(whichRect, CONST_CACHE.ENV_RECT_UNITS)
    if (rectUnits == nil) then
        rectUnits = {}
        hcache.set(whichRect, CONST_CACHE.ENV_RECT_UNITS, rectUnits)
    end
    if (#rectUnits > 0) then
        for _, u in ipairs(rectUnits) do
            hunit.del(u)
        end
    end
    rectUnits = {}
    -- 清理装饰物
    henv.clearDestructable(whichRect)
    local rectStartX = hrect.getStartX(whichRect)
    local rectStartY = hrect.getStartY(whichRect)
    local rectEndX = hrect.getEndX(whichRect)
    local rectEndY = hrect.getEndY(whichRect)
    local indexX = 0
    local indexY = 0
    local doodads = {}
    for _, v in ipairs(doodad) do
        for _, vv in ipairs(v) do
            table.insert(doodads, vv)
        end
    end
    local randomM = 2
    htime.setInterval(0.01, function(t)
        local x = rectStartX + indexX * 80
        local y = rectStartY + indexY * 80
        local buildType = math.random(1, randomM)
        if (indexX == -1 or indexY == -1) then
            htime.delTimer(t)
            if (isDestroyRect) then
                hrect.del(whichRect)
            end
            return
        end
        randomM = randomM + math.random(1, 3)
        if (randomM > 180) then
            randomM = 2
        end
        if (x > rectEndX) then
            indexY = 1 + indexY
            indexX = -1
        end
        if (y > rectEndY) then
            indexY = -1
        end
        indexX = 1 + indexX
        --- 一些特殊的地形要处理一下
        if (typeStr == "sea") then
            --- 海洋 - 深水不处理
            if (cj.IsTerrainPathable(x, y, PATHING_TYPE_WALKABILITY) == true) then
                return
            end
        end
        if (#units > 0 and (buildType == 1 or buildType == 40 or (#doodads <= 0 and buildType == 51))) then
            local tempUnit = cj.CreateUnit(
                cj.Player(PLAYER_NEUTRAL_PASSIVE),
                units[math.random(1, #units)],
                x,
                y,
                bj_UNIT_FACING
            )
            table.insert(rectUnits, tempUnit)
            if (ground ~= nil and math.random(1, 3) == 2) then
                cj.SetTerrainType(x, y, ground, -1, 1, 0)
            end
        elseif (#doodads > 0 and buildType == 16) then
            local dest = cj.CreateDestructable(
                doodads[math.random(1, #doodads)],
                x,
                y,
                math.random(0, 360),
                math.random(0.5, 1.1),
                0
            )
            if (isInvulnerable == true) then
                cj.SetDestructableInvulnerable(dest, true)
            end
            if (ground ~= nil) then
                cj.SetTerrainType(x, y, ground, -1, 1, 0)
            end
        end
    end)
end

--- 随机构建区域装饰
---@param whichRect userdata
---@param typeStr string
---@param isInvulnerable boolean 可破坏物是否无敌
---@param isDestroyRect boolean
henv.random = function(whichRect, typeStr, isInvulnerable, isDestroyRect)
    local ground
    local doodad = {}
    local unit = {}
    if (whichRect == nil or typeStr == nil) then
        return
    end
    if (typeStr == "summer") then
        ground = henvData.ground.summer
        doodad = {
            henvData.doodad.treeSummer,
            henvData.doodad.block,
            henvData.doodad.stone,
            henvData.doodad.bucket
        }
        unit = {
            henvData.unit.flower0,
            henvData.unit.flower1,
            henvData.unit.flower2,
            henvData.unit.flower3,
            henvData.unit.flower4,
            henvData.unit.bird
        }
    elseif (typeStr == "autumn") then
        ground = henvData.ground.autumn
        doodad = {
            henvData.doodad.treeAutumn,
            henvData.doodad.box,
            henvData.doodad.stoneRed,
            henvData.doodad.bucket,
            henvData.doodad.cage,
            henvData.doodad.supportColumn
        }
        unit = {
            henvData.unit.flower0,
            henvData.unit.typha0,
            henvData.unit.typha1
        }
    elseif (typeStr == "winter") then
        ground = henvData.ground.winter
        doodad = {
            henvData.doodad.treeWinter,
            henvData.doodad.treeWinterShow,
            henvData.doodad.stoneIce
        }
        unit = {
            henvData.unit.stone0,
            henvData.unit.stone1,
            henvData.unit.stone2,
            henvData.unit.stone3,
            henvData.unit.stone_show0,
            henvData.unit.stone_show1,
            henvData.unit.stone_show2,
            henvData.unit.stone_show3,
            henvData.unit.stone_show4
        }
    elseif (typeStr == "winterDeep") then
        ground = henvData.ground.winterDeep
        doodad = {
            henvData.doodad.treeWinterShow,
            henvData.doodad.stoneIce
        }
        unit = {
            henvData.unit.stone_show5,
            henvData.unit.stone_show6,
            henvData.unit.stone_show7,
            henvData.unit.stone_show8,
            henvData.unit.stone_show9,
            henvData.unit.ice0,
            henvData.unit.ice1,
            henvData.unit.ice2,
            henvData.unit.ice3,
            henvData.unit.bubble_geyser_steam,
            henvData.unit.snowman
        }
    elseif (typeStr == "dark") then
        ground = henvData.ground.dark
        doodad = {
            henvData.doodad.treeDark,
            henvData.doodad.treeDarkUmbrella,
            henvData.doodad.cage
        }
        unit = {
            henvData.unit.rune0,
            henvData.unit.rune1,
            henvData.unit.rune2,
            henvData.unit.rune3,
            henvData.unit.rune4,
            henvData.unit.rune5,
            henvData.unit.rune6,
            henvData.unit.impaled_body0,
            henvData.unit.impaled_body1
        }
    elseif (typeStr == "poor") then
        ground = henvData.ground.poor
        doodad = {
            henvData.doodad.treePoor,
            henvData.doodad.treePoorUmbrella,
            henvData.doodad.cage,
            henvData.doodad.box
        }
        unit = {
            henvData.unit.bone0,
            henvData.unit.bone1,
            henvData.unit.bone2,
            henvData.unit.bone3,
            henvData.unit.bone4,
            henvData.unit.bone5,
            henvData.unit.bone6,
            henvData.unit.bone7,
            henvData.unit.bone8,
            henvData.unit.bone9,
            henvData.unit.flies,
            henvData.unit.burn_body0,
            henvData.unit.burn_body1,
            henvData.unit.burn_body3,
            henvData.unit.bats
        }
    elseif (typeStr == "ruins") then
        ground = henvData.ground.ruins
        doodad = {
            henvData.doodad.treeRuins,
            henvData.doodad.treeRuinsUmbrella,
            henvData.doodad.cage
        }
        unit = {
            henvData.unit.break_column0,
            henvData.unit.break_column1,
            henvData.unit.break_column2,
            henvData.unit.break_column3,
            henvData.unit.skull_pile0,
            henvData.unit.skull_pile1,
            henvData.unit.skull_pile2,
            henvData.unit.skull_pile3
        }
    elseif (typeStr == "fire") then
        ground = henvData.ground.fire
        doodad = {
            henvData.doodad.volcano,
            henvData.doodad.stoneRed
        }
        unit = {
            henvData.unit.fire_hole,
            henvData.unit.burn_body0,
            henvData.unit.burn_body1,
            henvData.unit.burn_body2,
            henvData.unit.firetrap,
            henvData.unit.fire,
            henvData.unit.burn_build
        }
    elseif (typeStr == "underground") then
        ground = henvData.ground.underground
        doodad = {
            henvData.doodad.treeUnderground,
            henvData.doodad.spiderEggs
        }
        unit = {
            henvData.unit.mushroom0,
            henvData.unit.mushroom1,
            henvData.unit.mushroom2,
            henvData.unit.mushroom3,
            henvData.unit.mushroom4,
            henvData.unit.mushroom5,
            henvData.unit.mushroom6,
            henvData.unit.mushroom7,
            henvData.unit.mushroom8,
            henvData.unit.mushroom9,
            henvData.unit.mushroom10,
            henvData.unit.mushroom11
        }
    elseif (typeStr == "sea") then
        ground = henvData.ground.sea
        doodad = {}
        unit = {
            henvData.unit.seaweed0,
            henvData.unit.seaweed1,
            henvData.unit.seaweed2,
            henvData.unit.seaweed3,
            henvData.unit.seaweed4,
            henvData.unit.fish,
            henvData.unit.fish_school,
            henvData.unit.fish_green,
            henvData.unit.bubble_geyser,
            henvData.unit.bubble_geyser_steam,
            henvData.unit.coral0,
            henvData.unit.coral1,
            henvData.unit.coral2,
            henvData.unit.coral3,
            henvData.unit.coral4,
            henvData.unit.coral5,
            henvData.unit.coral6,
            henvData.unit.coral7,
            henvData.unit.coral8,
            henvData.unit.coral9,
            henvData.unit.shells0,
            henvData.unit.shells1,
            henvData.unit.shells2,
            henvData.unit.shells3,
            henvData.unit.shells4,
            henvData.unit.shells5,
            henvData.unit.shells6,
            henvData.unit.shells7,
            henvData.unit.shells8,
            henvData.unit.shells9
        }
    elseif (typeStr == "river") then
        ground = henvData.ground.river
        doodad = {
            henvData.doodad.stone
        }
        unit = {
            henvData.unit.fish,
            henvData.unit.fish_school,
            henvData.unit.fish_green,
            henvData.unit.lilypad0,
            henvData.unit.lilypad1,
            henvData.unit.lilypad2,
            henvData.unit.river_rushes0,
            henvData.unit.river_rushes1,
            henvData.unit.river_rushes2,
            henvData.unit.river_rushes3
        }
    else
        return
    end
    henv.build(whichRect, typeStr, isInvulnerable, isDestroyRect, ground, doodad, unit)
end
