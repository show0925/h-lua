hslk = {
    env_model = {},
    skill_break = {},
    skill_swim_unlimit = 0,
    skill_hero_tavern_selection = 0,
    unit_token = 0,
    unit_token_leap = 0,
    unit_token_alert_circle = 0,
    unit_hero_tavern = 0, -- 酒馆id
    unit_hero_tavern_token = 0, -- 酒馆选择马甲id（视野）
    unit_hero_death_token = 0,
    japi_delay = 0, --JAPI延迟处理
    i2v = {
        unit = {},
        item = {},
        ability = {},
        technology = {},
        ring = {},
    },
    n2v = {
        unit = {},
        item = {},
        ability = {},
        technology = {},
        ring = {},
    },
    attr = {
        agi_green = {
            add = {},
            sub = {}
        },
        int_green = {
            add = {},
            sub = {}
        },
        str_green = {
            add = {},
            sub = {}
        },
        attack_green = {
            add = {},
            sub = {}
        },
        attack_white = {
            add = {},
            sub = {}
        },
        item_attack_white = {
            add = {},
            sub = {},
            items = {},
        },
        attack_speed = {
            add = {},
            sub = {}
        },
        defend = {
            add = {},
            sub = {}
        },
        life = {
            add = {},
            sub = {}
        },
        mana = {
            add = {},
            sub = {}
        },
        avoid = {
            add = 0,
            sub = 0
        },
        sight = {
            add = {},
            sub = {}
        },
        ablis_gradient = {},
        sight_gradient = {}
    },
    -- 单位类型ID集
    unit_type_ids = {
        hero = {},
        courier_hero = {},
    },
    -- 瞬逝物
    item_fleeting = {},
    -- 冷却技能ID集
    item_cooldown_ids = {},
    -- 合成
    synthesis = {
        profit = {},
        fragment = {},
        fragmentNeeds = {},
    },
}

-- hslk注册数据方法
hslk.register = {
    unit = function(data)
        hslk.i2v.unit[data._id] = data
        hslk.n2v.unit[data._name] = data
        if (hslk.unit_type_ids[data._type] == nil) then
            hslk.unit_type_ids[data._type] = {}
        end
        table.insert(hslk.unit_type_ids[data._type], data._id)
    end,
    item = function(data)
        hslk.i2v.item[data._id] = data
        hslk.n2v.item[data._name] = data
        if (slk.item[data._id] ~= nil and slk.item[data._id].cooldownID ~= nil) then
            hslk.item_cooldown_ids[slk.item[data._id].cooldownID] = data._id
        end
        if (data._ring ~= nil) then
            data._ring._id = data._id
            data._ring._name = data._name
            hslk.i2v.ring[data._ring._id] = data._ring
            hslk.n2v.ring[data._ring._name] = data._ring
        end
    end,
    ability = function(data)
        hslk.i2v.ability[data._id] = data
        hslk.n2v.ability[data._name] = data
        if (data._ring ~= nil) then
            data._ring._id = data._id
            data._ring._name = data._name
            hslk.i2v.ring[data._ring._id] = data._ring
            hslk.n2v.ring[data._ring._name] = data._ring
        end
    end,
    technology = function(data)
        hslk.i2v.technology[data._id] = data
        hslk.n2v.technology[data._name] = data
    end,
    synthesis = function(data)
        -- 数据格式化
        -- 碎片名称转ID
        local jsonFragment = {}
        for k, v in ipairs(data._fragment) do
            data._fragment[k][2] = math.floor(v[2])
            local fragmentId = hslk.n2v.item[v[1]]._id or nil
            if (fragmentId ~= nil) then
                table.insert(jsonFragment, { fragmentId, v[2] })
            end
        end
        local profitId = hslk.n2v.item[data._profit[1]]._id or nil
        if (profitId == nil) then
            return
        end
        if (hslk.synthesis.profit[profitId] == nil) then
            hslk.synthesis.profit[profitId] = {}
        end
        table.insert(hslk.synthesis.profit[profitId], {
            qty = data._profit[2],
            fragment = jsonFragment,
        })
        local profitIndex = #hslk.synthesis.profit[profitId]
        for _, f in ipairs(jsonFragment) do
            if (hslk.synthesis.fragment[f[1]] == nil) then
                hslk.synthesis.fragment[f[1]] = {}
            end
            if (hslk.synthesis.fragment[f[1]][f[2]] == nil) then
                hslk.synthesis.fragment[f[1]][f[2]] = {}
            end
            table.insert(hslk.synthesis.fragment[f[1]][f[2]], {
                profit = profitId,
                index = profitIndex,
            })
            if (table.includes(hslk.synthesis.fragmentNeeds, f[2]) == false) then
                table.insert(hslk.synthesis.fragmentNeeds, f[2])
            end
        end
    end,
}

-- skill_break
for during = 1, 10, 1 do
    local swDur = during * 0.05
    hslk.skill_break[swDur] = cj.LoadInteger(cg.hash_hslk, HSLK_KEYS.SKILL_BREAK, during)
end
-- skill_swim_unlimit
hslk.skill_swim_unlimit = cj.LoadInteger(cg.hash_hslk, HSLK_KEYS.COMMON, HSLK_KEYS.SKILL_SWIM_UNLIMIT)
-- skill_invisible
hslk.skill_invisible = cj.LoadInteger(cg.hash_hslk, HSLK_KEYS.COMMON, HSLK_KEYS.SKILL_INVISIBLE)
-- skill_hero_tavern_selection
hslk.skill_hero_tavern_selection = cj.LoadInteger(cg.hash_hslk, HSLK_KEYS.COMMON, HSLK_KEYS.SKILL_HERO_TAVERN_SELECTION)

-- unit_token
hslk.unit_token = cj.LoadInteger(cg.hash_hslk, HSLK_KEYS.COMMON, HSLK_KEYS.UNIT_TOKEN)
-- unit_token_leap
hslk.unit_token_leap = cj.LoadInteger(cg.hash_hslk, HSLK_KEYS.COMMON, HSLK_KEYS.UNIT_TOKEN_LEAP)
-- unit_token_alert_circle
hslk.unit_token_alert_circle = cj.LoadInteger(cg.hash_hslk, HSLK_KEYS.COMMON, HSLK_KEYS.UNIT_TOKEN_ALERT_CIRCLE)
-- unit_tree
hslk.unit_tree = cj.LoadInteger(cg.hash_hslk, HSLK_KEYS.COMMON, HSLK_KEYS.UNIT_TREE)
-- unit_hero_tavern
hslk.unit_hero_tavern = cj.LoadInteger(cg.hash_hslk, HSLK_KEYS.COMMON, HSLK_KEYS.UNIT_HERO_TAVERN)
-- unit_hero_tavern_token
hslk.unit_hero_tavern_token = cj.LoadInteger(cg.hash_hslk, HSLK_KEYS.COMMON, HSLK_KEYS.UNIT_HERO_TAVERN_TOKEN)
-- unit_hero_death_token
hslk.unit_hero_death_token = cj.LoadInteger(cg.hash_hslk, HSLK_KEYS.COMMON, HSLK_KEYS.UNIT_HERO_DEATH_TOKEN)

-- 瞬逝物系统
qty = cj.LoadInteger(cg.hash_hslk, HSLK_KEYS.ITEM_FLEETING, -1)
for i = 1, qty do
    table.insert(hslk.item_fleeting, cj.LoadInteger(cg.hash_hslk, HSLK_KEYS.ITEM_FLEETING, i))
end

-- 环境系统
qty = cj.LoadInteger(cg.hash_hslk, HSLK_KEYS.COMMON, HSLK_KEYS.ENV_MODEL)
for i = 1, qty do
    local key = cj.LoadStr(cg.hash_hslk, HSLK_KEYS.ENV_MODEL_NAME, i)
    local val = cj.LoadInteger(cg.hash_hslk, HSLK_KEYS.ENV_MODEL, i)
    hslk.env_model[key] = val
end

-- JAPI延迟处理
hslk.japi_delay = cj.LoadInteger(cg.hash_hslk, HSLK_KEYS.JAPI_DELAY, 0)

-- 属性系统
for i = 1, 9 do
    local val = math.floor(10 ^ (i - 1))
    table.insert(hslk.attr.ablis_gradient, val)
    hslk.attr.str_green.add[val] = cj.LoadInteger(cg.hash_hslk, HSLK_KEYS.ATTR_STR_GREEN_ADD, val)
    hslk.attr.str_green.sub[val] = cj.LoadInteger(cg.hash_hslk, HSLK_KEYS.ATTR_STR_GREEN_SUB, val)
    hslk.attr.agi_green.add[val] = cj.LoadInteger(cg.hash_hslk, HSLK_KEYS.ATTR_AGI_GREEN_ADD, val)
    hslk.attr.agi_green.sub[val] = cj.LoadInteger(cg.hash_hslk, HSLK_KEYS.ATTR_AGI_GREEN_SUB, val)
    hslk.attr.int_green.add[val] = cj.LoadInteger(cg.hash_hslk, HSLK_KEYS.ATTR_INT_GREEN_ADD, val)
    hslk.attr.int_green.sub[val] = cj.LoadInteger(cg.hash_hslk, HSLK_KEYS.ATTR_INT_GREEN_SUB, val)
    hslk.attr.attack_green.add[val] = cj.LoadInteger(cg.hash_hslk, HSLK_KEYS.ATTR_ATTACK_GREEN_ADD, val)
    hslk.attr.attack_green.sub[val] = cj.LoadInteger(cg.hash_hslk, HSLK_KEYS.ATTR_ATTACK_GREEN_SUB, val)
    hslk.attr.attack_white.add[val] = cj.LoadInteger(cg.hash_hslk, HSLK_KEYS.ATTR_ATTACK_WHITE_ADD, val)
    hslk.attr.attack_white.sub[val] = cj.LoadInteger(cg.hash_hslk, HSLK_KEYS.ATTR_ATTACK_WHITE_SUB, val)
    hslk.attr.item_attack_white.add[val] = cj.LoadInteger(cg.hash_hslk, HSLK_KEYS.ATTR_ITEM_ATTACK_WHITE_ADD, val)
    hslk.attr.item_attack_white.sub[val] = cj.LoadInteger(cg.hash_hslk, HSLK_KEYS.ATTR_ITEM_ATTACK_WHITE_SUB, val)
    table.insert(hslk.attr.item_attack_white.items, hslk.attr.item_attack_white.add[val])
    table.insert(hslk.attr.item_attack_white.items, hslk.attr.item_attack_white.sub[val])
    hslk.attr.attack_speed.add[val] = cj.LoadInteger(cg.hash_hslk, HSLK_KEYS.ATTR_ATTACK_SPEED_ADD, val)
    hslk.attr.attack_speed.sub[val] = cj.LoadInteger(cg.hash_hslk, HSLK_KEYS.ATTR_ATTACK_SPEED_SUB, val)
    hslk.attr.defend.add[val] = cj.LoadInteger(cg.hash_hslk, HSLK_KEYS.ATTR_DEFEND_ADD, val)
    hslk.attr.defend.sub[val] = cj.LoadInteger(cg.hash_hslk, HSLK_KEYS.ATTR_DEFEND_SUB, val)
    hslk.attr.life.add[val] = cj.LoadInteger(cg.hash_hslk, HSLK_KEYS.ATTR_LIFE_ADD, val)
    hslk.attr.life.sub[val] = cj.LoadInteger(cg.hash_hslk, HSLK_KEYS.ATTR_LIFE_SUB, val)
    hslk.attr.mana.add[val] = cj.LoadInteger(cg.hash_hslk, HSLK_KEYS.ATTR_MANA_ADD, val)
    hslk.attr.mana.sub[val] = cj.LoadInteger(cg.hash_hslk, HSLK_KEYS.ATTR_MANA_SUB, val)
end
-- 属性系统 回避
hslk.attr.avoid.add = cj.LoadInteger(cg.hash_hslk, HSLK_KEYS.ATTR_AVOID_ADD, 0)
hslk.attr.avoid.sub = cj.LoadInteger(cg.hash_hslk, HSLK_KEYS.ATTR_AVOID_SUB, 0)
-- 属性系统 视野
local sightBase = { 1, 2, 3, 4, 5 }
local si = 1
while (si <= 10000) do
    for _, v in ipairs(sightBase) do
        v = math.floor(v * si)
        table.insert(hslk.attr.sight_gradient, v)
        hslk.attr.sight.add[v] = cj.LoadInteger(cg.hash_hslk, HSLK_KEYS.ATTR_SIGHT_ADD, v)
        hslk.attr.sight.sub[v] = cj.LoadInteger(cg.hash_hslk, HSLK_KEYS.ATTR_SIGHT_SUB, v)
    end
    si = si * 10
end
table.sort(
    hslk.attr.sight_gradient,
    function(a, b)
        return a > b
    end
)

local qty = cj.LoadInteger(cg.hash_hslk_helper, 1, 0)
if (qty > 0) then
    local checked = {}
    for i = 1, qty do
        local js = cj.LoadStr(cg.hash_hslk_helper, 1, i)
        local data = json.parse(js)
        if (data) then
            checked[i] = 1
            if (data._class == 'item') then
                hslk.register.item(data)
            elseif (data._class == 'unit') then
                hslk.register.unit(data)
            elseif (data._class == 'ability') then
                hslk.register.ability(data)
            elseif (data._class == 'technology') then
                hslk.register.technology(data)
            else
                checked[i] = nil
            end
            data = nil
        end
    end
    for i = 1, qty do
        if (checked[i] ~= 1) then
            local js = cj.LoadStr(cg.hash_hslk_helper, 1, i)
            local data = json.parse(js)
            if (data) then
                if (data._class == 'synthesis') then
                    hslk.register.synthesis(data)
                end
                data = nil
            end
        end
    end
    checked = nil
end

cj.FlushParentHashtable(cg.hash_hslk)
cj.FlushParentHashtable(cg.hash_hslk_helper)
