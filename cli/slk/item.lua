---@private
local slk_item_synthesisMapping = {
    profit = {},
    fragment = {},
}

---@protected
local hslk_item_SlkDesc = function(_v)
    local d = {}
    if (_v._active ~= nil) then
        table.insert(d, "主动：" .. _v._active)
    end
    if (_v._passive ~= nil) then
        table.insert(d, "被动：" .. _v._passive)
    end
    if (_v._attr ~= nil) then
        table.insert(d, slkHelper.attrDesc(_v._attr, ";"))
    end
    -- 仅文本无效果，适用于例如技能书这类的物品
    if (_v._attr_txt ~= nil) then
        table.insert(d, slkHelper.attrDesc(_v._attr_txt, ";"))
    end
    local overlie = _v._overlie or 1
    local weight = _v._weight or 0
    weight = tostring(math.round(weight))
    table.insert(d, "叠加：" .. overlie .. ";重量：" .. weight .. "Kg")
    if (_v._remarks ~= nil and _v._remarks ~= "") then
        table.insert(d, _v._remarks)
    end
    return string.implode("|n", d)
end

---@protected
local hslk_item_SlkUbertip = function(_v)
    local d = {}
    if (_v._active ~= nil) then
        table.insert(d, hcolor.mixed("主动：" .. _v._active, SLK_CONF.color.itemActive))
        if (_v.cooldown ~= nil and _v.cooldown > 0) then
            table.insert(d, hcolor.mixed("冷却：" .. _v.cooldown .. "秒", SLK_CONF.color.itemCoolDown))
        end
    end
    if (_v._passive ~= nil) then
        table.insert(d, hcolor.mixed("被动：" .. _v._passive, SLK_CONF.color.itemPassive))
    end
    if (_v._ring ~= nil) then
        if (_v._ring.attr ~= nil and _v._ring.radius ~= nil and (type(_v._ring.target) == 'table' and #_v._ring.target > 0)) then
            local txt = "光环：[" .. _v._ring.radius .. "px|n"
            table.insert(d, hcolor.mixed(txt .. slkHelper.attrDesc(_v._ring.attr, "|n", ' - '), SLK_CONF.color.ringTarget))
        end
    end
    if (_v._attr ~= nil) then
        table.insert(d, hcolor.mixed(slkHelper.attrDesc(_v._attr, "|n"), SLK_CONF.color.itemAttr))
    end
    -- 仅文本无效果，适用于例如技能书这类的物品
    if (_v._attr_txt ~= nil) then
        table.insert(d, hcolor.mixed(slkHelper.attrDesc(_v._attr_txt, "|n"), SLK_CONF.color.itemAttr))
    end
    -- 作为零件
    if (slk_item_synthesisMapping.fragment[_v.Name] ~= nil
        and #slk_item_synthesisMapping.fragment[_v.Name] > 0) then
        table.insert(d, hcolor.mixed("可以合成：" .. string.implode(
            '、',
            slk_item_synthesisMapping.fragment[_v.Name]),
            SLK_CONF.color.itemFragment
        ))
    end
    -- 合成公式
    if (slk_item_synthesisMapping.profit[_v.Name] ~= nil) then
        table.insert(d, hcolor.mixed("需要零件：" .. slk_item_synthesisMapping.profit[_v.Name], SLK_CONF.color.itemProfit))
    end
    local overlie = _v._overlie or 1
    table.insert(d, hcolor.mixed("叠加：" .. overlie, SLK_CONF.color.itemOverlie))
    local weight = _v._weight or 0
    weight = tostring(math.round(weight))
    table.insert(d, hcolor.mixed("重量：" .. weight .. "Kg", SLK_CONF.color.itemWeight))
    if (_v._remarks ~= nil and _v._remarks ~= "") then
        table.insert(d, hcolor.mixed(_v._remarks, SLK_CONF.color.itemRemarks))
    end
    return string.implode("|n", d)
end

--- 物品合成公式数组，只支持slkHelper创建的注册物品
---例子1 "小刀割大树=小刀+大树" 2个不一样的合1个
---例子2 "三头地狱犬的神识=地狱狗头x3" 3个一样的合1个
---例子3 "精灵神水x2=精灵的眼泪x50" 50个一样的合一种,但得到2个
---例子4 {{"小刀割大树",1},{"小刀",1},{"大树",1}} 对象型配置，第一项为结果物品(适合物品名称包含特殊字符的物品，如+/=影响公式的符号)
slk_item_synthesis = function(formula)
    for _, v in ipairs(formula) do
        local profit = ''
        local fragment = {}
        if (type(v) == 'string') then
            local f1 = string.explode('=', v)
            if (string.strpos(f1[1], 'x') == false) then
                profit = { f1[1], 1 }
            else
                local temp = string.explode('x', f1[1])
                temp[2] = math.floor(temp[2])
                profit = temp
            end
            local f2 = string.explode('+', f1[2])
            for _, vv in ipairs(f2) do
                if (string.strpos(vv, 'x') == false) then
                    table.insert(fragment, { vv, 1 })
                else
                    local temp = string.explode('x', vv)
                    temp[2] = math.floor(temp[2])
                    table.insert(fragment, temp)
                end
            end
        elseif (type(v) == 'table') then
            profit = v[1]
            for vi = 2, table.len(v), 1 do
                table.insert(fragment, v[vi])
            end
        end
        --
        local fmStr = {}
        for _, fm in ipairs(fragment) do
            if (fm[2] <= 1) then
                table.insert(fmStr, fm[1])
            else
                table.insert(fmStr, fm[1] .. 'x' .. fm[2])
            end
            if (slk_item_synthesisMapping.fragment[fm[1]] == nil) then
                slk_item_synthesisMapping.fragment[fm[1]] = {}
            end
            if (table.includes(slk_item_synthesisMapping.fragment[fm[1]], profit[1]) == false) then
                table.insert(slk_item_synthesisMapping.fragment[fm[1]], profit[1])
            end
        end
        slk_item_synthesisMapping.profit[profit[1]] = string.implode('+', fmStr)
        --
        SLK_GO_SET({
            _class = "synthesis",
            _profit = profit,
            _fragment = fragment,
        })
    end
end

local tpl = {
    abiList = "",
    Requires = "",
    Requiresamount = "",
    Name = nil,
    Description = nil,
    Tip = "",
    Ubertip = nil,
    Hotkey = nil,
    Art = "ReplaceableTextures\\CommandButtons\\BTNSelectHeroOn.blp",
    scale = 1.00,
    file = "Objects\\InventoryItems\\TreasureChest\\treasurechest.mdl",
    Buttonpos1 = 0,
    Buttonpos2 = 0,
    selSize = 0.00,
    colorR = 255,
    colorG = 255,
    colorB = 255,
    armor = "Wood",
    Level = nil,
    oldLevel = nil,
    class = "Permanent",
    goldcost = 1000000,
    lumbercost = 1000000,
    HP = 100,
    stockStart = 0,
    stockRegen = 0,
    stockMax = 1,
    prio = 0,
    cooldownID = "Alat",
    ignoreCD = 0,
    morph = 0,
    drop = 0,
    powerup = 0,
    sellable = 1,
    pawnable = 1,
    droppable = 1,
    pickRandom = 1,
    uses = 1,
    perishable = 0,
    usable = 0,
    _id = nil,
    _type = "common",
    _parent = "rat9",
    _overlie = 1,
    _weight = 0,
    _active = nil,
    _passive = nil,
    _attr = nil,
    _attr_txt = nil,
    _ring = nil,
    _cooldown = nil,
    _shadow = false,
}

---@param _v{abiList: "主动技能ID列表",Requires: "科技树",Requiresamount: "科技树",Name: "物品名称",Description: "物品描述",Tip: "物品描述标题",Ubertip: "物品在地上时说明",Hotkey: "热键",Art: "图标",scale: "模型大小",file: "模型路径",Buttonpos1: "商店X坐标",Buttonpos2: "商店Y坐标",selSize: "选择圈大小",colorR: "颜色R",colorG: "颜色G",colorB: "颜色B",armor: "装甲类型",Level: "等级",oldLevel: "等级(旧)",class: "物品分类",goldcost: "黄金",lumbercost: "木头",HP: "生命",stockStart: "开始库存",stockRegen: "补货周期",stockMax: "最大库存",prio: "优先权",morph: "有效的物品转换目标",drop: "死亡时掉落",powerup: "捡到时自动使用",sellable: "可以出售",pawnable: "可以抵押",droppable: "可以丢弃",pickRandom: "可以作为随机物品",uses: "使用次数",perishable: "使用后完全消失",usable: "主动使用",_id:"物编ID",_type:"slk数据归类","_parent:"模版物编ID","_overlie:"叠加","_weight:"重量",_active:"主动",_passive:"被动","_attr:"属性","_attr_txt":"属性(无效)","_ring:"光环","_cooldown:"冷却时间",_shadow:"强制使用影子物品",_slk:"拓展数据"}
hslk_item = function(_v)
    _v._class = "item"
    for k, v in pairs(tpl) do
        if (_v[k] == nil) then
            _v[k] = v
        end
    end
    -- hslk
    if (_v._id == nil or true == SLK_ID_ALREADY[_v._id]) then
        _v._id = SLK_ID(_v._class)
    end
    if (_v._overlie < _v.uses) then
        _v._overlie = _v.uses
    end
    if (_v._ring ~= nil) then
        _v._ring.effectTarget = _v._ring.effectTarget or "Abilities\\Spells\\Other\\GeneralAuraTarget\\GeneralAuraTarget.mdl"
        _v._ring.attach = _v._ring.attach or "origin"
        _v._ring.attachTarget = _v._ring.attachTarget or "origin"
        _v._ring.radius = _v._ring.radius or 600
        -- target请参考物编的目标允许
        local target
        if (type(_v._ring.target) == 'table' and #_v._ring.target > 0) then
            target = _v._ring.target
        elseif (type(_v._ring.target) == 'string' and string.len(_v._ring.target) > 0) then
            target = string.explode(',', _v._ring.target)
        else
            target = { 'air', 'ground', 'friend', 'self', 'vuln', 'invu' }
        end
        _v._ring.target = target
    end
    -- slk
    if (_v.Description == nil) then
        _v.Description = hslk_item_SlkDesc(_v)
    end
    if (_v.Ubertip == nil) then
        _v.Ubertip = hslk_item_SlkUbertip(_v)
    end
    if (_v.Level == nil) then
        _v.Level = math.floor(((_v.goldcost or tpl.goldcost) + (_v.lumbercost or tpl.lumbercost)) / 500)
    end
    if (_v.oldLevel == nil) then
        _v.oldLevel = _v.Level
    end
    if (_v.Name == nil) then
        _v.Name = "未命名" .. id
    end
    if (_v.Hotkey ~= nil) then
        _v.Buttonpos1 = CONST_HOTKEY_FULL_KV[_v.Hotkey].Buttonpos1 or 0
        _v.Buttonpos2 = CONST_HOTKEY_FULL_KV[_v.Hotkey].Buttonpos2 or 0
        _v.Tip = "获得" .. _v.Name .. "(" .. hcolor.mixed(_v.Hotkey, SLK_CONF.color.hotKey) .. ")"
    else
        _v.Buttonpos1 = _v.Buttonpos1 or 0
        _v.Buttonpos2 = _v.Buttonpos2 or 0
        _v.Tip = "获得" .. _v.Name
    end
    SLK_GO_SET(_v)
end