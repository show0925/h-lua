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
    id2Value = {
        unit = {},
        item = {},
        ability = {},
        technology = {},
        ring = {},
    },
    name2Value = {
        unit = {},
        item = {},
        ability = {},
        technology = {},
        ring = {},
    },
    class_group = {
        unit = {},
        item = {},
        ability = {},
        technology = {},
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
    -- 瞬逝物
    item_fleeting = {},
    -- 冷却技能ID集
    item_cooldown_ids = {},
    -- 合成
    synthesis = {
        profit = {},
        fragment = {},
    },
}

-- skill_break
for dur = 1, 10, 1 do
    local swDur = dur * 0.05
    hslk.skill_break[swDur] = cj.LoadInteger(cg.hash_hslk, HSLK_KEYS.SKILL_BREAK, dur)
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

for i = 1, 5 do
    local qty = cj.LoadInteger(cg.hash_hslk_helper, 0, i)
    if (qty > 0) then
        for j = 1, qty do
            local js = cj.LoadStr(cg.hash_hslk_helper, i, j)
            local data = json.parse(js)
            if (data) then
                if (i == 1) then
                    hRuntime.register.item(data)
                elseif (i == 2) then
                    hRuntime.register.unit(data)
                    if (hRuntime.unit_type_ids[data.UNIT_TYPE] == nil) then
                        hRuntime.unit_type_ids[data.UNIT_TYPE] = {}
                    end
                    table.insert(hRuntime.unit_type_ids[data.UNIT_TYPE], data.UNIT_ID)
                elseif (i == 3) then
                    hRuntime.register.ability(data)
                elseif (i == 4) then
                    hRuntime.register.technology(data)
                end
            end
        end
        for j = 1, qty do
            local js = cj.LoadStr(cg.hash_hslk_helper, i, j)
            local data = json.parse(js)
            if (data) then
                if (i == 5) then
                    hRuntime.register.synthesis(data)
                end
            end
        end
    end
end

cj.FlushParentHashtable(cg.hash_hslk)
cj.FlushParentHashtable(cg.hash_hslk_helper)
