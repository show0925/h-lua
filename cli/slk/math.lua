--- 数字四舍五入，位数截断
---@param decimal number
---@param n number 默认2位
---@return number
math.round = function(decimal, n)
    n = math.floor(n or 2)
    if (n < 1) then
        return math.floor(decimal)
    end
    return tonumber(string.format('%.' .. n .. 'f', decimal))
end

--- 数字格式化
---@param value number
---@return string
math.numberFormat = function(value)
    if (value > 10000 * 100000000) then
        return string.format("%.2f", value / 10000 * 100000000) .. "T"
    elseif (value > 10 * 100000000) then
        return string.format("%.2f", value / 10 * 100000000) .. "B"
    elseif (value > 100 * 10000) then
        return string.format("%.2f", value / 100 * 10000) .. "M"
    elseif (value > 1000) then
        return string.format("%.2f", value / 1000) .. "K"
    else
        return string.format("%.2f", value)
    end
end

--- 整型格式化
---@param value number
---@return string
math.integerFormat = function(value)
    if (value > 10000 * 100000000) then
        return math.floor(value / 10000 * 100000000) .. "T"
    elseif (value > 10 * 100000000) then
        return math.floor(value / 10 * 100000000) .. "B"
    elseif (value > 100 * 10000) then
        return math.floor(value / 100 * 10000) .. "M"
    elseif (value > 1000) then
        return math.floor(value / 1000) .. "K"
    else
        return tostring(math.floor(value))
    end
end
