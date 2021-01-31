henvData = {
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
            htime.setTimeout(
                delay,
                function(t)
                    htime.delTimer(t)
                    cj.RemoveDestructable(whichDestructable)
                    whichDestructable = nil
                end
            )
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
    htime.setInterval(
        0.01,
        function(t)
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
        end
    )
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
            hslk.env_model.flower0,
            hslk.env_model.flower1,
            hslk.env_model.flower2,
            hslk.env_model.flower3,
            hslk.env_model.flower4,
            hslk.env_model.bird
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
            hslk.env_model.flower0,
            hslk.env_model.typha0,
            hslk.env_model.typha1
        }
    elseif (typeStr == "winter") then
        ground = henvData.ground.winter
        doodad = {
            henvData.doodad.treeWinter,
            henvData.doodad.treeWinterShow,
            henvData.doodad.stoneIce
        }
        unit = {
            hslk.env_model.stone0,
            hslk.env_model.stone1,
            hslk.env_model.stone2,
            hslk.env_model.stone3,
            hslk.env_model.stone_show0,
            hslk.env_model.stone_show1,
            hslk.env_model.stone_show2,
            hslk.env_model.stone_show3,
            hslk.env_model.stone_show4
        }
    elseif (typeStr == "winterDeep") then
        ground = henvData.ground.winterDeep
        doodad = {
            henvData.doodad.treeWinterShow,
            henvData.doodad.stoneIce
        }
        unit = {
            hslk.env_model.stone_show5,
            hslk.env_model.stone_show6,
            hslk.env_model.stone_show7,
            hslk.env_model.stone_show8,
            hslk.env_model.stone_show9,
            hslk.env_model.ice0,
            hslk.env_model.ice1,
            hslk.env_model.ice2,
            hslk.env_model.ice3,
            hslk.env_model.bubble_geyser_steam,
            hslk.env_model.snowman
        }
    elseif (typeStr == "dark") then
        ground = henvData.ground.dark
        doodad = {
            henvData.doodad.treeDark,
            henvData.doodad.treeDarkUmbrella,
            henvData.doodad.cage
        }
        unit = {
            hslk.env_model.rune0,
            hslk.env_model.rune1,
            hslk.env_model.rune2,
            hslk.env_model.rune3,
            hslk.env_model.rune4,
            hslk.env_model.rune5,
            hslk.env_model.rune6,
            hslk.env_model.impaled_body0,
            hslk.env_model.impaled_body1
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
            hslk.env_model.bone0,
            hslk.env_model.bone1,
            hslk.env_model.bone2,
            hslk.env_model.bone3,
            hslk.env_model.bone4,
            hslk.env_model.bone5,
            hslk.env_model.bone6,
            hslk.env_model.bone7,
            hslk.env_model.bone8,
            hslk.env_model.bone9,
            hslk.env_model.flies,
            hslk.env_model.burn_body0,
            hslk.env_model.burn_body1,
            hslk.env_model.burn_body3,
            hslk.env_model.bats
        }
    elseif (typeStr == "ruins") then
        ground = henvData.ground.ruins
        doodad = {
            henvData.doodad.treeRuins,
            henvData.doodad.treeRuinsUmbrella,
            henvData.doodad.cage
        }
        unit = {
            hslk.env_model.break_column0,
            hslk.env_model.break_column1,
            hslk.env_model.break_column2,
            hslk.env_model.break_column3,
            hslk.env_model.skull_pile0,
            hslk.env_model.skull_pile1,
            hslk.env_model.skull_pile2,
            hslk.env_model.skull_pile3
        }
    elseif (typeStr == "fire") then
        ground = henvData.ground.fire
        doodad = {
            henvData.doodad.volcano,
            henvData.doodad.stoneRed
        }
        unit = {
            hslk.env_model.fire_hole,
            hslk.env_model.burn_body0,
            hslk.env_model.burn_body1,
            hslk.env_model.burn_body2,
            hslk.env_model.firetrap,
            hslk.env_model.fire,
            hslk.env_model.burn_build
        }
    elseif (typeStr == "underground") then
        ground = henvData.ground.underground
        doodad = {
            henvData.doodad.treeUnderground,
            henvData.doodad.spiderEggs
        }
        unit = {
            hslk.env_model.mushroom0,
            hslk.env_model.mushroom1,
            hslk.env_model.mushroom2,
            hslk.env_model.mushroom3,
            hslk.env_model.mushroom4,
            hslk.env_model.mushroom5,
            hslk.env_model.mushroom6,
            hslk.env_model.mushroom7,
            hslk.env_model.mushroom8,
            hslk.env_model.mushroom9,
            hslk.env_model.mushroom10,
            hslk.env_model.mushroom11
        }
    elseif (typeStr == "sea") then
        ground = henvData.ground.sea
        doodad = {}
        unit = {
            hslk.env_model.seaweed0,
            hslk.env_model.seaweed1,
            hslk.env_model.seaweed2,
            hslk.env_model.seaweed3,
            hslk.env_model.seaweed4,
            hslk.env_model.fish,
            hslk.env_model.fish_school,
            hslk.env_model.fish_green,
            hslk.env_model.bubble_geyser,
            hslk.env_model.bubble_geyser_steam,
            hslk.env_model.coral0,
            hslk.env_model.coral1,
            hslk.env_model.coral2,
            hslk.env_model.coral3,
            hslk.env_model.coral4,
            hslk.env_model.coral5,
            hslk.env_model.coral6,
            hslk.env_model.coral7,
            hslk.env_model.coral8,
            hslk.env_model.coral9,
            hslk.env_model.shells0,
            hslk.env_model.shells1,
            hslk.env_model.shells2,
            hslk.env_model.shells3,
            hslk.env_model.shells4,
            hslk.env_model.shells5,
            hslk.env_model.shells6,
            hslk.env_model.shells7,
            hslk.env_model.shells8,
            hslk.env_model.shells9
        }
    elseif (typeStr == "river") then
        ground = henvData.ground.river
        doodad = {
            henvData.doodad.stone
        }
        unit = {
            hslk.env_model.fish,
            hslk.env_model.fish_school,
            hslk.env_model.fish_green,
            hslk.env_model.lilypad0,
            hslk.env_model.lilypad1,
            hslk.env_model.lilypad2,
            hslk.env_model.river_rushes0,
            hslk.env_model.river_rushes1,
            hslk.env_model.river_rushes2,
            hslk.env_model.river_rushes3
        }
    else
        return
    end
    henv.build(whichRect, typeStr, isInvulnerable, isDestroyRect, ground, doodad, unit)
end
