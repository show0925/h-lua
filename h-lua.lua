-- 加载YDWE库
cj = require "jass.common"
cg = require "jass.globals"
slk = require "jass.slk"

-- 加载blizzard
require "foundation.blizzard_c"
require "foundation.blizzard_b"

-- 加载const
require "const.enchant"
require "const.attribute"
require "const.attributeXtras"
require "const.breakArmorType"
require "const.damageSource"
require "const.damageType"
require "const.hero"
require "const.hotKey"
require "const.item"
require "const.unit"
require "const.playerColor"
require "const.event"
require "const.hSlkKeys"
require "const.abilityTarget"

-- 加载foundation
-- 加载debug
require "foundation.debug"
-- 加载json
require "foundation.json"
-- 加载md5
require "foundation.md5"
-- 加载runtime
require "foundation.runtime"
-- 加载math
require "foundation.math"
-- 加载string
require "foundation.string"
-- 加载table
require "foundation.table"
-- 加载color
require "foundation.color"
-- 加载h-lua自带的slk数据
require "foundation.hslk"
-- 加载h-lua的F9
require "foundation.f9"
-- 加载echo
require "foundation.echo"

-- 加载Dzapi库
-- 需要编辑器支持网易平台的DZAPI
-- 如果在lua中无法找到Dzapi，你需要检查下面的部分：
-- 1. YDWE——配置——魔兽插件——[勾上]LUA引擎——[勾上]Dzapi（不行就做第2步）
-- 2. 打开触发窗口（F4），创建一个不运行的触发（无事件），在条件及动作补充你需要的Dzapi
require "lib.dzapi"

-- 加载h-lua库
require "lib.time"
require "lib.is"
require "lib.sound"
require "lib.texture"
require "lib.effect"
require "lib.lightning"
require "lib.weather"
require "lib.env"
require "lib.camera"
require "lib.event"
require "lib.eventDefaultActions"
require "lib.textTag"
require "lib.rect"
require "lib.player"
require "lib.award"
require "lib.unit"
require "lib.enemy"
require "lib.group"
require "lib.hero"
require "lib.courier"
require "lib.skill.index"
require "lib.skill.basic"
require "lib.skill.damage"
require "lib.skill.complex"
require "lib.skill.ring"
require "lib.enchant"
require "lib.attribute.index"
require "lib.attribute.xtras"
require "lib.item"
require "lib.dialog"
require "lib.leaderBoard"
require "lib.multiBoard"
require "lib.quest"
require "lib.matcher"
require "lib.shop"
-- 别称 alias
httg = htextTag
hattr = hattribute

require "lib.initialization"
