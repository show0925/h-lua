H_AID = {
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
}

-- 属性系统
for i = 1, 9 do
    local v = math.floor(10 ^ (i - 1))
    table.insert(H_AID.ablis_gradient, v)
    H_AID.str_green.add[v] = string.char2id(hslk.n2i("H_LUA_A_STR_G_ADD_" .. v))
    H_AID.str_green.sub[v] = string.char2id(hslk.n2i("H_LUA_A_STR_G_SUB_" .. v))
    H_AID.agi_green.add[v] = string.char2id(hslk.n2i("H_LUA_A_AGI_G_ADD_" .. v))
    H_AID.agi_green.sub[v] = string.char2id(hslk.n2i("H_LUA_A_AGI_G_SUB_" .. v))
    H_AID.int_green.add[v] = string.char2id(hslk.n2i("H_LUA_A_INT_G_ADD_" .. v))
    H_AID.int_green.sub[v] = string.char2id(hslk.n2i("H_LUA_A_INT_G_SUB_" .. v))
    H_AID.attack_green.add[v] = string.char2id(hslk.n2i("H_LUA_A_ACK_G_ADD_" .. v))
    H_AID.attack_green.sub[v] = string.char2id(hslk.n2i("H_LUA_A_ACK_G_SUB_" .. v))
    H_AID.attack_white.add[v] = string.char2id(hslk.n2i("H_LUA_A_ACK_W_ADD_" .. v))
    H_AID.attack_white.sub[v] = string.char2id(hslk.n2i("H_LUA_A_ACK_W_SUB_" .. v))
    H_AID.item_attack_white.add[v] = string.char2id(hslk.n2i("H_LUA_A_ACK_IT_W_ADD_" .. v))
    H_AID.item_attack_white.sub[v] = string.char2id(hslk.n2i("H_LUA_A_ACK_IT_W_SUB_" .. v))
    table.insert(H_AID.item_attack_white.items, H_AID.item_attack_white.add[v])
    table.insert(H_AID.item_attack_white.items, H_AID.item_attack_white.sub[v])
    H_AID.attack_speed.add[v] = string.char2id(hslk.n2i("H_LUA_A_ACK_SPD_ADD_" .. v))
    H_AID.attack_speed.sub[v] = string.char2id(hslk.n2i("H_LUA_A_ACK_SPD_SUB_" .. v))
    H_AID.defend.add[v] = string.char2id(hslk.n2i("H_LUA_A_DEF_ADD_" .. v))
    H_AID.defend.sub[v] = string.char2id(hslk.n2i("H_LUA_A_DEF_SUB_" .. v))
    H_AID.life.add[v] = string.char2id(hslk.n2i("H_LUA_A_LIFE_ADD_" .. v))
    H_AID.life.sub[v] = string.char2id(hslk.n2i("H_LUA_A_LIFE_SUB_" .. v))
    H_AID.mana.add[v] = string.char2id(hslk.n2i("H_LUA_A_MANA_ADD_" .. v))
    H_AID.mana.sub[v] = string.char2id(hslk.n2i("H_LUA_A_MANA_SUB_" .. v))
end
-- 属性系统 回避
H_AID.avoid.add = string.char2id(hslk.n2i("H_LUA_A_AVOID_ADD"))
H_AID.avoid.sub = string.char2id(hslk.n2i("H_LUA_A_AVOID_SUB"))
-- 属性系统 视野
local sightBase = { 1, 2, 3, 4, 5 }
local si = 1
while (si <= 10000) do
    for _, v in ipairs(sightBase) do
        v = math.floor(v * si)
        table.insert(H_AID.sight_gradient, v)
        H_AID.sight.add[v] = string.char2id(hslk.n2i("H_LUA_A_SIGHT_ADD_" .. v))
        H_AID.sight.sub[v] = string.char2id(hslk.n2i("H_LUA_A_SIGHT_SUB_" .. v))
    end
    si = si * 10
end
table.sort(H_AID.sight_gradient, function(a, b)
    return a > b
end)