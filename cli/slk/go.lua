SLK_GO = {}
SLK_ID_ALREADY = {}

SLK_GO_INI = function(ini)
    local iniJson = json.parse(ini)
    for _, v in pairs(iniJson) do
        SLK_ID_ALREADY[v] = true
    end
end

SLK_GO_SET = function(data)
    for k, v in pairs(data) do
        if (type(v) == "function") then
            data[k] = nil
        end
    end
    table.insert(SLK_GO, data)
end

local idPrefix = {
    ability = "K",
    item = "I",
    unit = "V",
    upgrade = "U",
}

local idLimit = 46655 -- zzz

SLK_ID_COUNT = {}
SLK_ID = function(class, setId)
    -- 如果自定义的ID可用，返回设定的ID
    if (setId ~= nil and string.len(setId) == 4 and false == SLK_ID_ALREADY[setId]) then
        SLK_ID_ALREADY[setId] = true
        return setId
    end
    local prefix = idPrefix[class]
    if (prefix == nil) then
        prefix = "X"
    end
    if (SLK_ID_COUNT[prefix] == nil) then
        SLK_ID_COUNT[prefix] = 0
    end
    local sid
    while (true) do
        local id = string.convert(SLK_ID_COUNT[prefix], 36)
        SLK_ID_COUNT[prefix] = SLK_ID_COUNT[prefix] + 1
        if (SLK_ID_COUNT[prefix] > idLimit) then
            sid = "ZZZZ"
            break
        end
        if string.len(id) == 1 then
            id = "00" .. id
        elseif string.len(id) == 2 then
            id = "0" .. id
        end
        sid = prefix .. id
        if true ~= SLK_ID_ALREADY[sid] then
            SLK_ID_ALREADY[sid] = true
            break
        end
    end
    return sid
end

SLK_GO_JSON = function()
    return json.stringify(SLK_GO)
end