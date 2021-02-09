table.mergePairs = function(...)
    local merTable = {}
    local tables = { ... }
    if (tables == nil) then
        return {}
    end
    for _, tn in ipairs(tables) do
        if (type(tn) == "table") then
            for k, v in pairs(tn) do
                merTable[k] = v
            end
        end
    end
    return merTable
end

table.clonePairs = function(org)
    local function copy(org1, res)
        for k, v in pairs(org1) do
            if type(v) ~= "table" then
                res[k] = v
            else
                copy(v, res[k])
            end
        end
    end
    local res = {}
    copy(org, res)
    return res
end