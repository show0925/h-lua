--- 合并table pairs
---@vararg table
---@return table
table.merge_pairs = function(...)
    local tempTable = {}
    local tables = { ... }
    if (tables == nil) then
        return {}
    end
    for _, tn in ipairs(tables) do
        if (type(tn) == "table") then
            for k, v in pairs(tn) do
                tempTable[k] = v
            end
        end
    end
    return tempTable
end