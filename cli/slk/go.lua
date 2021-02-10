SLK_GO = {}
SLK_INI = {}

SLK_GO_INI = function(ini)
    local iniJson = json.parse(ini)
    for _, v in pairs(iniJson) do
        SLK_INI[v] = true
    end
end

local idPrefix = {
    item = "I",
    item_shadow = "I",
}

local idLimit = 46655 -- zzz
local hex36 = string.split("0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ", 1)
local to36 = function(num)
    if (num == 0) then
        return "0"
    end
    local numStr = ""
    while (num ~= 0) do
        local yu = (num % 36) + 1
        numStr = hex36[yu] + numStr
        num = num / 36
    end
    return string.upper(numStr)
end

SLK_ID_COUNT = {}
SLK_ID = function(class)
    local prefix = idPrefix[class]
    if (prefix == nil) then
        prefix = "X"
    end
    if (SLK_ID_COUNT[prefix] == nil) then
        SLK_ID_COUNT[prefix] = 0
    end
    local sid
    while (true) do
        local id = to36(SLK_ID_COUNT[prefix])
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
        if true ~= SLK_INI[sid] then
            SLK_INI[sid] = true
            break
        end
    end
    return sid
end

SLK_GO_JSON = function()
    return json.stringify(SLK_GO)
end