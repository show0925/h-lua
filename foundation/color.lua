---@class hColor
hColor = {}

---@private
---@param str string
---@param color string hex
---@return string
hColor.hex = function(str, color)
    if (str == nil or color == nil) then
        print_stack()
        return str
    end
    return "|cff" .. color .. str .. "|r"
end

---@private
---@param str string
---@param color string|function
---@return string
hColor.mixed = function(str, color)
    if (str == nil or color == nil) then
        print_stack()
        return str
    end
    if (type(color) == 'string') then
        return "|cff" .. color .. str .. "|r"
    elseif (type(color) == 'function') then
        return color(str)
    end
    return str
end

--- 耀金
---@public
---@param str string
---@return string
hColor.gold = function(str)
    return hColor.hex(str, "ffcc00")
end

--- 纯白
---@public
---@param str string
---@return string
hColor.white = function(str)
    return hColor.hex(str, "ffffff")
end

--- 纯黑
---@public
---@param str string
---@return string
hColor.black = function(str)
    return hColor.hex(str, "000000")
end

--- 浅灰
---@public
---@param str string
---@return string
hColor.grey = function(str)
    return hColor.hex(str, "c0c0c0")
end

--- 深灰
---@public
---@param str string
---@return string
hColor.greyDeep = function(str)
    return hColor.hex(str, "969696")
end

--- 亮红
---@public
---@param str string
---@return string
hColor.redLight = function(str)
    return hColor.hex(str, "ff8080")
end

--- 大红
---@public
---@param str string
---@return string
hColor.red = function(str)
    return hColor.hex(str, "ff3939")
end

--- 浅绿
---@public
---@param str string
---@return string
hColor.greenLight = function(str)
    return hColor.hex(str, "ccffcc")
end

--- 深绿
---@public
---@param str string
---@return string
hColor.green = function(str)
    return hColor.hex(str, "80ff00")
end

--- 浅黄
---@public
---@param str string
---@return string
hColor.yellowLight = function(str)
    return hColor.hex(str, "ffffcc")
end

--- 亮黄
---@public
---@param str string
---@return string
hColor.yellow = function(str)
    return hColor.hex(str, "ffff00")
end

--- 浅橙
---@public
---@param str string
---@return string
hColor.orangeLight = function(str)
    return hColor.hex(str, "ffd88c")
end

--- 橙色
---@public
---@param str string
---@return string
hColor.orange = function(str)
    return hColor.hex(str, "ffc24b")
end

--- 天空蓝
---@public
---@param str string
---@return string
hColor.skyLight = function(str)
    return hColor.hex(str, "ccffff")
end

--- 青空蓝
---@public
---@param str string
---@return string
hColor.sky = function(str)
    return hColor.hex(str, "80ffff")
end

--- 浅海蓝
---@public
---@param str string
---@return string
hColor.seaLight = function(str)
    return hColor.hex(str, "99ccff")
end

--- 深海蓝
---@public
---@param str string
---@return string
hColor.sea = function(str)
    return hColor.hex(str, "00ccff")
end

--- 浅紫
---@public
---@param str string
---@return string
hColor.purpleLight = function(str)
    return hColor.hex(str, "ee82ee")
end

--- 亮紫
---@public
---@param str string
---@return string
hColor.purple = function(str)
    return hColor.hex(str, "ff59ff")
end
