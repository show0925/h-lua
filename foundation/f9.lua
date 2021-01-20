-- h-lua 系统提醒（F9任务）
hLuaF9 = function(allow)
    if (#allow < 1) then
        return
    end
    if (table.includes(allow, 'all') or table.includes(allow, 'hlua')) then
        hquest.create({
            side = "right",
            title = "h-lua",
            icon = "ReplaceableTextures\\CommandButtons\\BTNTomeOfRetraining.blp",
            content = {
                "h-lua完全独立，支持使用lua的平台运行，不依赖其他API（如JAPI、DzApi）",
                "包含多样丰富的属性系统，可以轻松做出平时难以甚至不能做出的地图效果",
                "内置多达几十种以上的自定义事件，轻松实现神奇的主动和被动效果",
                "自带物品合成，免去自行编写的困惑。丰富的自定义技能模板",
                "镜头、单位组、过滤器、背景音乐、天气等也应有尽有",
                "想要了解更多，官方QQ群：325338043 官网教程：hlua.book.hunzsig.org",
            },
        })
    end
    -- apm提示
    if (table.includes(allow, 'all') or table.includes(allow, 'apm') then
        hquest.create({
            side = "right",
            title = "查看你的APM数值",
            icon = "ReplaceableTextures\\CommandButtons\\BTNTomeOfRetraining.blp",
            content = "-apm 查看你的APM数值"
        })
    end
    -- 视距提示
    if (table.includes(allow, 'all') or table.includes(allow, 'sight')) then
        hquest.create({
            side = "right",
            title = "调整你的视距",
            icon = "ReplaceableTextures\\CommandButtons\\BTNTomeOfRetraining.blp",
            content = {
                "+[number] 增加视距",
                "-[number] 减少视距",
                " ! 视距自动设置上下限，请放心设置"
            }
        })
    end
    -- 特效开关提示
    if (table.includes(allow, 'all') or table.includes(allow, 'eff')) then
        hquest.create({
            side = "right",
            title = "开关特效[单人]",
            icon = "ReplaceableTextures\\CommandButtons\\BTNTomeOfRetraining.blp",
            content = {
                "-eff 开关特效",
                "这个命令只有在单人时有效，可关闭大部分的特效",
            }
        })
    end
    -- 英雄选择提示
    if (table.includes(allow, 'all') or table.includes(allow, 'hero')) then
        hquest.create({
            side = "right",
            title = "选择英雄指令",
            icon = "ReplaceableTextures\\CommandButtons\\BTNTomeOfRetraining.blp",
            content = {
                "当地图可以自主选择英雄时：",
                "-random 随机选择",
                "-repick 重新选择",
            }
        })
    end
    -- 自动转换黄金为木头提示
    if (table.includes(allow, 'all') or table.includes(allow, 'apc') then
        hquest.create({
            side = "right",
            title = "设定自动转金为木",
            icon = "ReplaceableTextures\\CommandButtons\\BTNTomeOfRetraining.blp",
            content = {
                "-apc 设定是否自动转换黄金为木头",
                "-获得黄金超过100万时，自动按照比率转换多余的部分为木头",
                "-如果超过时没有开启，会寄存下来，待开启再转换(上限1000万)",
                "-n转换需要额外超过限度才生效",
            }
        })
    end
end
