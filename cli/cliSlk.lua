--- cli 构造的数据
local jass_slk = nil
local hslk_cli_ids = {}
local hslk_cli_synthesis = {}
HSLK_CLI_H_IDI = 1
HSLK_CLI_H_IDS = {}
HSLK_CLI_DATA = {}
HSLK_I2V = {}
HSLK_N2V = {}
HSLK_N2I = {}
HSLK_ICD = {}
HSLK_CLASS_IDS = {}
HSLK_TYPE_IDS = {}
HSLK_SYNTHESIS = {
    profit = {},
    fragment = {},
    fragmentNeeds = {},
}

hslk_init = function()
    if (jass_slk == nil) then
        jass_slk = require "jass.slk"
    end
    -- 处理物编数据
    if (#hslk_cli_ids > 0) then
        for _, id in ipairs(hslk_cli_ids) do
            HSLK_I2V[id] = HSLK_CLI_DATA[id] or {}
            HSLK_I2V[id]._id = id
            HSLK_I2V[id]._type = HSLK_I2V[id]._type or "slk"
            if (jass_slk.item[id] ~= nil) then
                HSLK_I2V[id]._class = HSLK_I2V[id]._class or "item"
                for _, slkKey in ipairs(CONST_SLK.item) do
                    if (jass_slk.item[id][slkKey] ~= nil) then
                        HSLK_I2V[id][slkKey] = jass_slk.item[id][slkKey]
                    end
                end
                if (HSLK_I2V[id].cooldownID) then
                    HSLK_ICD[HSLK_I2V[id].cooldownID] = HSLK_I2V[id]._id
                end
            elseif (jass_slk.unit[id] ~= nil) then
                HSLK_I2V[id]._class = HSLK_I2V[id]._class or "unit"
                for _, slkKey in ipairs(CONST_SLK.unit) do
                    if (jass_slk.unit[id][slkKey] ~= nil) then
                        HSLK_I2V[id][slkKey] = jass_slk.unit[id][slkKey]
                    end
                end
            elseif (jass_slk.ability[id] ~= nil) then
                HSLK_I2V[id]._class = HSLK_I2V[id]._class or "ability"
                for _, slkKey in ipairs(CONST_SLK.ability) do
                    if (jass_slk.ability[id][slkKey] ~= nil) then
                        HSLK_I2V[id][slkKey] = jass_slk.ability[id][slkKey]
                    end
                end
            elseif (jass_slk.technology[id] ~= nil) then
                HSLK_I2V[id] = jass_slk.technology[id]
                HSLK_I2V[id]._class = HSLK_I2V[id]._class or "technology"
            end
            -- 处理_class
            if (HSLK_I2V[id]._class) then
                if (HSLK_CLASS_IDS[HSLK_I2V[id]._class] == nil) then
                    HSLK_CLASS_IDS[HSLK_I2V[id]._class] = {}
                end
                table.insert(HSLK_CLASS_IDS[HSLK_I2V[id]._class], id)
            end
            -- 处理_type
            if (HSLK_I2V[id]._type) then
                if (HSLK_TYPE_IDS[HSLK_I2V[id]._type] == nil) then
                    HSLK_TYPE_IDS[HSLK_I2V[id]._type] = {}
                end
                table.insert(HSLK_TYPE_IDS[HSLK_I2V[id]._type], id)
            end
            -- 处理N2V
            if (HSLK_I2V[id].Name ~= nil) then
                local n = HSLK_I2V[id].Name
                if (HSLK_N2V[n] == nil) then
                    HSLK_N2I[n] = {}
                    HSLK_N2V[n] = {}
                end
                table.insert(HSLK_N2I, id)
                table.insert(HSLK_N2V, HSLK_I2V[id])
            end
        end
    end
    -- 处理合成公式
    if (#hslk_cli_synthesis > 0) then
        for _, data in ipairs(hslk_cli_synthesis) do
            -- 数据格式化
            -- 碎片名称转ID
            local jsonFragment = {}
            for k, v in ipairs(data._fragment) do
                data._fragment[k][2] = math.floor(v[2])
                local fragmentId = HSLK_N2V[v[1]][1]._id or nil
                if (fragmentId ~= nil) then
                    table.insert(jsonFragment, { fragmentId, v[2] })
                end
            end
            local profitId = HSLK_N2V[data._profit[1]][1]._id or nil
            if (profitId == nil) then
                return
            end
            if (HSLK_SYNTHESIS.profit[profitId] == nil) then
                HSLK_SYNTHESIS.profit[profitId] = {}
            end
            table.insert(HSLK_SYNTHESIS.profit[profitId], {
                qty = data._profit[2],
                fragment = jsonFragment,
            })
            local profitIndex = #HSLK_SYNTHESIS.profit[profitId]
            for _, f in ipairs(jsonFragment) do
                if (HSLK_SYNTHESIS.fragment[f[1]] == nil) then
                    HSLK_SYNTHESIS.fragment[f[1]] = {}
                end
                if (HSLK_SYNTHESIS.fragment[f[1]][f[2]] == nil) then
                    HSLK_SYNTHESIS.fragment[f[1]][f[2]] = {}
                end
                table.insert(HSLK_SYNTHESIS.fragment[f[1]][f[2]], {
                    profit = profitId,
                    index = profitIndex,
                })
                if (table.includes(HSLK_SYNTHESIS.fragmentNeeds, f[2]) == false) then
                    table.insert(HSLK_SYNTHESIS.fragmentNeeds, f[2])
                end
            end
        end
    end
end

local hslk_cli_set = function(_v)
    HSLK_CLI_DATA[HSLK_CLI_H_IDS[HSLK_CLI_H_IDI]] = _v
    HSLK_CLI_H_IDI = HSLK_CLI_H_IDI + 1
end

hslk_item_synthesis = function(formula)
    hslk_cli_synthesis = F6V_I_SYNTHESIS(formula)
end

hslk_item = function(_v)
    hslk_cli_set(F6V_I(_v))
end

hslk_ability = function(_v)
    hslk_cli_set(F6V_A(_v))
end

hslk_ability_empty = function(_v)
    hslk_cli_set(F6V_A_E(_v))
end

hslk_unit = function(_v)
    hslk_cli_set(F6V_U(_v))
end