---@class hquest 任务探索
hquest = {}

--- 删除任务
---@param q userdata
---@param delay number
hquest.del = function(q, delay)
    if (delay == nil or delay <= 0) then
        cj.DestroyQuest(q)
    else
        htime.setTimeout(delay, function(t)
            htime.delTimer(t)
            cj.DestroyQuest(q)
        end)
    end
end

--[[
    创建一个任务
    options = {
        side = "left", --位置，默认left
        title = "", --标题
        content = "", --内容，你可以设置一个string或一个table，table会自动便利附加|n（换行）
        icon = "ReplaceableTextures\\CommandButtons\\BTNTomeOfRetraining.blp", --图标
        during = nil, --持续时间，默认为nil，不计时
    }
]]
---@param options pilotQuestCreate
---@return userdata
hquest.create = function(options)
    local side = options.side or "left"
    local title = options.title
    local content = options.content
    local isFinish = options.isFinish
    if (title == nil) then
        return
    end
    if (type(options.content) == "table") then
        content = string.implode("|n", options.content)
    end
    if (content == nil) then
        return
    end
    local questType = bj_QUESTTYPE_REQ_DISCOVERED
    if (side == "right") then
        questType = bj_QUESTTYPE_OPT_DISCOVERED
    end
    local icon = options.icon or "ReplaceableTextures\\CommandButtons\\BTNTomeOfRetraining.blp"
    local required = questType == bj_QUESTTYPE_REQ_DISCOVERED or questType == bj_QUESTTYPE_REQ_UNDISCOVERED
    local discovered = questType == bj_QUESTTYPE_REQ_DISCOVERED or questType == bj_QUESTTYPE_OPT_DISCOVERED
    local q = cj.CreateQuest()
    cj.QuestSetTitle(q, title)
    cj.QuestSetDescription(q, content)
    cj.QuestSetIconPath(q, icon)
    cj.QuestSetRequired(q, required)
    cj.QuestSetDiscovered(q, discovered)
    if (isFinish == true) then
        cj.QuestSetCompleted(q, true)
    else
        cj.QuestSetCompleted(q, false)
    end
    if (options.during ~= nil and options.during > 0) then
        hquest.del(q, options.during)
    end
    return q
end

--- 令F9按钮闪烁
hquest.flash = function()
    cj.FlashQuestDialogButton()
end

--- 设置任务为完成
---@param q userdata
hquest.setCompleted = function(q)
    cj.QuestSetCompleted(q, true)
end

--- 设置任务为失败
---@param q userdata
hquest.setFailed = function(q)
    cj.QuestSetFailed(q, true)
end

--- 设置任务为被发现
---@param q userdata
hquest.setDiscovered = function(q)
    cj.QuestSetDiscovered(q, true)
end
