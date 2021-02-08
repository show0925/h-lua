table.clone = function(org)
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