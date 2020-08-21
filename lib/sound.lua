---@class hsound 声音
hsound = {
    BREAK_DELAY = 3
}

--- 播放音效
---@param s userdata F5设定音效
hsound.sound = function(s)
    if (s ~= nil) then
        cj.StartSound(s)
    end
end
--- 播放音效对某个玩家
---@param s userdata
---@param whichPlayer userdata
hsound.sound2Player = function(s, whichPlayer)
    if (s ~= nil and cj.GetLocalPlayer() == whichPlayer) then
        cj.StartSound(s)
    end
end
--- 绑定单位音效
---@param s userdata
---@param volumePercent number %
---@param u userdata
hsound.sound2Unit = function(s, volumePercent, u)
    if (s ~= nil) then
        cj.AttachSoundToUnit(s, u)
        cj.SetSoundVolume(s, math.floor(volumePercent * 127 * 0.01))
        cj.StartSound(s)
    end
end
--- 绑定坐标音效
---@param s userdata
---@param x number
---@param y number
---@param z number
hsound.sound2XYZ = function(s, x, y, z)
    if (s ~= nil) then
        cj.SetSoundPosition(s, x, y, z)
    end
end

--- 绑定区域音效
---@param s userdata
---@param whichRect userdata
---@param during number 0=unLimit
hsound.sound2Rect = function(s, whichRect, during)
    if (s ~= nil) then
        during = during or 0
        local width = cj.GetRectMaxX(whichRect) - cj.GetRectMinX(whichRect)
        local height = cj.GetRectMaxY(whichRect) - cj.GetRectMinY(whichRect)
        cj.SetSoundPosition(s, cj.GetRectCenterX(whichRect), cj.GetRectCenterY(whichRect), 0)
        cj.RegisterStackedSound(s, true, width, height)
        if (during > 0) then
            htime.setTimeout(during, function(curTimer)
                htime.delTimer(curTimer)
                cj.UnregisterStackedSound(s, true, width, height)
            end)
        end
    end
end

--- 停止BGM
---@param whichPlayer userdata|nil
hsound.bgmStop = function(whichPlayer)
    if (whichPlayer == nil) then
        for i = 1, bj_MAX_PLAYER_SLOTS, 1 do
            hplayer.set(hplayer.players[i], 'bgmCurrent', nil)
        end
        cj.StopMusic(true)
    else
        hplayer.set(whichPlayer, 'bgmCurrent', nil)
        if (cj.GetLocalPlayer() == whichPlayer) then
            cj.StopMusic(true)
        end
    end
end

--- 播放BGM
--- 当whichPlayer为nil时代表对全员操作
--- 如果背景音乐无法循环播放，尝试格式工厂转wav再转回mp3
--- 由于音乐快速切换会卡顿，所以有[BREAK_DELAY]秒的延时（延时间切换BGM之前的会自动失效，只认延时后的最后一首）
--- 延时是每个玩家独立时间，当切换的BGM为同一首时，切换不会进行
---@param musicFileName string
---@param whichPlayer userdata|nil
hsound.bgm = function(musicFileName, whichPlayer)
    if (musicFileName ~= nil and string.len(musicFileName) > 0) then
        if (whichPlayer ~= nil) then
            local bgmCurrent = hplayer.get(whichPlayer, 'bgmCurrent', nil)
            local bgmDelayTimer = hplayer.get(whichPlayer, 'bgmDelayTimer', nil)
            if (bgmCurrent == musicFileName) then
                return
            end
            if (bgmDelayTimer ~= nil) then
                htime.delTimer(bgmDelayTimer)
                hplayer.set(whichPlayer, 'bgmDelayTimer', nil)
            end
            hsound.bgmStop(whichPlayer)
            hplayer.set(whichPlayer, 'bgmCurrent', musicFileName)
            hplayer.set(whichPlayer, 'bgmDelayTimer', htime.setTimeout(
                hsound.BREAK_DELAY,
                function(t)
                    htime.delTimer(t)
                    hplayer.set(whichPlayer, 'bgmDelayTimer', nil)
                    if (cj.GetLocalPlayer() == whichPlayer) then
                        cj.PlayMusic(bgmCurrent)
                    end
                end
            ))
        else
            hsound.bgmStop()
            for i = 1, bj_MAX_PLAYERS, 1 do
                local bgmCurrent = hplayer.get(hplayer.players[i], 'bgmCurrent', nil)
                local bgmDelayTimer = hplayer.get(hplayer.players[i], 'bgmDelayTimer', nil)
                if (bgmCurrent ~= musicFileName) then
                    if (bgmDelayTimer ~= nil) then
                        htime.delTimer(bgmDelayTimer)
                        hplayer.set(hplayer.players[i], 'bgmDelayTimer', nil)
                    end
                    hplayer.set(hplayer.players[i], 'bgmCurrent', musicFileName)
                    hplayer.set(whichPlayer, 'bgmDelayTimer', htime.setTimeout(
                        hsound.BREAK_DELAY,
                        function(t)
                            htime.delTimer(t)
                            hplayer.set(hplayer.players[i], 'bgmDelayTimer', nil)
                            if (cj.GetLocalPlayer() == hplayer.players[i]) then
                                cj.PlayMusic(musicFileName)
                            end
                        end
                    ))
                end
            end
        end
    end
end
