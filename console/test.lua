--- 自启动调试
DEBUGGING = true
JassRuntime = require "jass.runtime"
JassRuntime.console = true
JassRuntime.sleep = false
JassRuntime.debugger = 4279
JassRuntime.error_handle = function(msg)
    print("========lua-err========")
    print(tostring(msg))
    print_stack()
    print("=========================")
end
JassDebug = require "jass.debug"
JassConsole = require "jass.console"

local hPrint = print
print = function(...)
    hPrint(...)
end

--- 打印栈
print_stack = function(...)
    local out = { "[TRACE]" }
    local n = select("#", ...)
    for i = 1, n, 1 do
        local v = select(i, ...)
        out[#out + 1] = tostring(v)
    end
    out[#out + 1] = "\n"
    out[#out + 1] = debug.traceback("", 2)
    print(table.concat(out, " "))
end

--- 打印utf8->ansi编码,此方法可以打印出中文
print_mb = function(...)
    JassConsole.write(...)
end

--- 错误调试
print_err = function(val)
    print("========h-lua-err========")
    if (type(val) == "table") then
        print_mbr(val)
    else
        print_mb(val)
    end
    print_stack()
    print("=========================")
end

--- 打印对象table
---@param showDetail boolean
print_r = function(t, printMethod, showDetail)
    local print_r_cache = {}
    printMethod = printMethod or print
    if (showDetail == nil) then
        showDetail = true
    end
    local function sub_print_r(tt, indent)
        if (print_r_cache[tostring(tt)]) then
            printMethod(indent .. "*" .. tostring(tt))
        else
            print_r_cache[tostring(tt)] = true
            if (type(tt) == "table") then
                for pos, val in pairs(tt) do
                    if (type(pos) == "userdata") then
                        pos = "userdata"
                    end
                    if (type(val) == "table") then
                        printMethod(indent .. "[" .. pos .. "](" .. table.len(val) .. ") => " .. tostring(tt) .. " {")
                        sub_print_r(val, indent .. string.rep(" ", string.len(pos) + 8))
                        printMethod(indent .. string.rep(" ", string.len(pos) + 6) .. "}")
                    elseif (showDetail == true) then
                        if (type(val) == "string") then
                            printMethod(indent .. "[" .. pos .. '] => <string>"' .. val .. '"')
                        else
                            printMethod(indent .. "[" .. pos .. "] => " .. "<" .. type(val) .. ">" .. tostring(val))
                        end
                    end
                end
            else
                printMethod(indent .. "<" .. type(tt) .. ">" .. tostring(tt))
            end
        end
    end
    if (type(t) == "table") then
        printMethod(tostring(t) .. "(" .. table.len(t) .. ") {")
        sub_print_r(t, "  ")
        print("}")
    else
        sub_print_r(t, "  ")
    end
    print()
end

--- 打印对象table,此方法可以打印出中文
print_mbr = function(t)
    print_r(t, print_mb, true)
end
