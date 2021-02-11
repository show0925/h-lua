cliData = {}
local cliDataSet = function(dataJson)
    if (type(dataJson) == "string" and string.len(dataJson) > 0) then
        local data = json.parse(dataJson)
        if (data and data._id and data._class) then
            cliData[data._id] = data
        end
    end
end