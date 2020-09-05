hRuntime = {
    -- 注册runtime的数据
    register = {
        unit = function(json)
            hslk_global.id2Value.unit[json.UNIT_ID] = json
            hslk_global.name2Value.unit[json.Name] = json
            if (json.CLASS_GROUP ~= nil) then
                if (hslk_global.class_group.unit[json.CLASS_GROUP] == nil) then
                    hslk_global.class_group.unit[json.CLASS_GROUP] = {}
                end
                table.insert(hslk_global.class_group.unit[json.CLASS_GROUP], json.UNIT_ID)
            end
        end,
        item = function(json)
            hslk_global.id2Value.item[json.ITEM_ID] = json
            hslk_global.name2Value.item[json.Name] = json
            if (json.CLASS_GROUP ~= nil) then
                if (hslk_global.class_group.item[json.CLASS_GROUP] == nil) then
                    hslk_global.class_group.item[json.CLASS_GROUP] = {}
                end
                table.insert(hslk_global.class_group.item[json.CLASS_GROUP], json.ITEM_ID)
            end
            if (json.cooldownID ~= nil) then
                hslk_global.item_cooldown_ids[json.cooldownID] = json.ITEM_ID
            end
        end,
        ability = function(json)
            hslk_global.id2Value.ability[json.ABILITY_ID] = json
            hslk_global.name2Value.ability[json.Name] = json
            if (json.CLASS_GROUP ~= nil) then
                if (hslk_global.class_group.ability[json.CLASS_GROUP] == nil) then
                    hslk_global.class_group.ability[json.CLASS_GROUP] = {}
                end
                table.insert(hslk_global.class_group.ability[json.CLASS_GROUP], json.ABILITY_ID)
            end
        end,
        technology = function(json)
            hslk_global.id2Value.technology[json.TECHNOLOGY_ID] = json
            hslk_global.name2Value.technology[json.Name] = json
            if (json.CLASS_GROUP ~= nil) then
                if (hslk_global.class_group.technology[json.CLASS_GROUP] == nil) then
                    hslk_global.class_group.technology[json.CLASS_GROUP] = {}
                end
                table.insert(hslk_global.class_group.technology[json.CLASS_GROUP], json.TECHNOLOGY_ID)
            end
        end,
        synthesis = function(json)
            -- 数据格式化
            for k, v in ipairs(json.fragment) do
                json.fragment[k][2] = math.floor(v[2])
            end
            if (hslk_global.synthesis.profit[json.profit[1]] == nil) then
                hslk_global.synthesis.profit[json.profit[1]] = {}
            end
            table.insert(hslk_global.synthesis.profit[json.profit[1]], {
                qty = json.profit[2],
                fragment = json.fragment,
            })
            local profitIndex = #hslk_global.synthesis.profit[json.profit[1]]
            for _, f in ipairs(json.fragment) do
                if (hslk_global.synthesis.fragment[f[1]] == nil) then
                    hslk_global.synthesis.fragment[f[1]] = {}
                end
                if (hslk_global.synthesis.fragment[f[1]][f[2]] == nil) then
                    hslk_global.synthesis.fragment[f[1]][f[2]] = {}
                end
                table.insert(hslk_global.synthesis.fragment[f[1]][f[2]], {
                    profit = json.profit[1],
                    index = profitIndex,
                })
            end
        end,
    },
    env = {},
    event = {
        -- 核心注册
        register = {},
        -- 池
        pool = {},
    },
    textTag = {},
    rect = {},
    player = {},
    unit = {},
    group = {}, -- 单位选择器
    hero = {},
    ring = {},
    unit_type_ids = { --单位类型ID集
        hero = {},
        courier_hero = {},
    },
    heroBuildSelection = {},
    skill = {
        silentUnits = {},
        silentTrigger = nil,
        unarmUnits = {},
        unarmTrigger = nil,
    },
    attributeGroup = {
        life_back = {},
        mana_back = {},
        punish = {}
    },
    item = {},
    itemPickPool = {},
    leaderBoard = {},
    multiBoard = {},
    dialog = {}
}

hRuntime.clear = function(handle)
    if (handle == nil) then
        return
    end
    if (hRuntime.env[handle] ~= nil) then
        hRuntime.env[handle] = nil
    end
    if (hRuntime.event[handle] ~= nil) then
        hRuntime.event[handle] = nil
    end
    if (hRuntime.event.register[handle] ~= nil) then
        hRuntime.event.register[handle] = nil
    end
    if (hRuntime.event.pool[handle] ~= nil) then
        for _, p in ipairs(hRuntime.event.pool[handle]) do
            local key = p.key
            local poolIndex = p.poolIndex
            hevent.POOL[key][poolIndex].stock = hevent.POOL[key][poolIndex].stock - 1
            -- 起码利用红线1/4允许归零
            if (hevent.POOL[key][poolIndex].stock == 0
                and hevent.POOL[key][poolIndex].count > 0.25 * hevent.POOL_RED_LINE) then
                cj.DisableTrigger(hevent.POOL[key][poolIndex].trigger)
                cj.DestroyTrigger(hevent.POOL[key][poolIndex].trigger)
                hevent.POOL[key][poolIndex] = -1
            end
            local e = 0
            for _, v in ipairs(hevent.POOL[key]) do
                if (v == -1) then
                    e = e + 1
                end
            end
            if (e == #hevent.POOL[key]) then
                hevent.POOL[key] = nil
            end
        end
        hRuntime.event.pool[handle] = nil
    end
    if (hRuntime.textTag[handle] ~= nil) then
        hRuntime.textTag[handle] = nil
    end
    if (hRuntime.rect[handle] ~= nil) then
        hRuntime.rect[handle] = nil
    end
    if (hRuntime.unit[handle] ~= nil) then
        hRuntime.unit[handle] = nil
    end
    if (table.includes(handle, hRuntime.group)) then
        table.delete(handle, hRuntime.group)
    end
    if (hRuntime.hero[handle] ~= nil) then
        hRuntime.hero[handle] = nil
    end
    if (hRuntime.heroBuildSelection[handle] ~= nil) then
        hRuntime.heroBuildSelection[handle] = nil
    end
    if (hRuntime.skill[handle] ~= nil) then
        hRuntime.skill[handle] = nil
        if (table.includes(handle, hRuntime.skill.silentUnits)) then
            table.delete(handle, hRuntime.skill.silentUnits)
        end
        if (table.includes(handle, hRuntime.skill.unarmUnits)) then
            table.delete(handle, hRuntime.skill.unarmUnits)
        end
    end
    if (hRuntime.item[handle] ~= nil) then
        hRuntime.item[handle] = nil
    end
    if (hRuntime.leaderBoard[handle] ~= nil) then
        hRuntime.leaderBoard[handle] = nil
    end
    if (hRuntime.multiBoard[handle] ~= nil) then
        hRuntime.multiBoard[handle] = nil
    end
    if (hRuntime.dialog[handle] ~= nil) then
        hRuntime.dialog[handle] = nil
    end
end

