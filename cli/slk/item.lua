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
    if (_v._desc ~= nil and _v._desc ~= "") then
        table.insert(d, _v._desc)
    end
    return string.implode("|n", d)
end

---@protected
local hslk_item_SlkUbertip = function(_v)
    local d = {}
    if (_v._active ~= nil) then
        table.insert(d, hcolor.mixed("主动：" .. _v._active, slkHelper.conf.color.itemActive))
        if (_v.cooldown ~= nil and _v.cooldown > 0) then
            table.insert(d, hcolor.mixed("冷却：" .. _v.cooldown .. "秒", slkHelper.conf.color.itemCoolDown))
        end
    end
    if (_v._passive ~= nil) then
        table.insert(d, hcolor.mixed("被动：" .. _v._passive, slkHelper.conf.color.itemPassive))
    end
    if (_v._ring ~= nil) then
        if (_v._ring.attr ~= nil and _v._ring.radius ~= nil and (type(_v._ring.target) == 'table' and #_v._ring.target > 0)) then
            local txt = "光环：[" .. _v._ring.radius .. "px|n"
            table.insert(d, hcolor.mixed(txt .. slkHelper.attrDesc(_v._ring.attr, "|n", ' - '), slkHelper.conf.color.ringTarget))
        end
    end
    if (_v._attr ~= nil) then
        table.insert(d, hcolor.mixed(slkHelper.attrDesc(_v._attr, "|n"), slkHelper.conf.color.itemAttr))
    end
    -- 仅文本无效果，适用于例如技能书这类的物品
    if (_v._attr_txt ~= nil) then
        table.insert(d, hcolor.mixed(slkHelper.attrDesc(_v._attr_txt, "|n"), slkHelper.conf.color.itemAttr))
    end
    -- 作为零件
    if (slkHelper.item.synthesisMapping.fragment[_v.Name] ~= nil
        and #slkHelper.item.synthesisMapping.fragment[_v.Name] > 0) then
        table.insert(d, hcolor.mixed("可以合成：" .. string.implode(
            '、',
            slkHelper.item.synthesisMapping.fragment[_v.Name]),
            slkHelper.conf.color.itemFragment
        ))
    end
    -- 合成公式
    if (slkHelper.item.synthesisMapping.profit[_v.Name] ~= nil) then
        table.insert(d, hcolor.mixed("需要零件：" .. slkHelper.item.synthesisMapping.profit[_v.Name], slkHelper.conf.color.itemProfit))
    end
    local overlie = _v._overlie or 1
    table.insert(d, hcolor.mixed("叠加：" .. overlie, slkHelper.conf.color.itemOverlie))
    local weight = _v._weight or 0
    weight = tostring(math.round(weight))
    table.insert(d, hcolor.mixed("重量：" .. weight .. "Kg", slkHelper.conf.color.itemWeight))
    if (_v._desc ~= nil and _v._desc ~= "") then
        table.insert(d, hcolor.mixed(_v._desc, slkHelper.conf.color.itemDesc))
    end
    return string.implode("|n", d)
end

---@protected
local hslk_item_Slk = function(_v)

end

local hslk_item_tpl = {
    abiList = "",
    Requires = "",
    Requiresamount = "",
    Name = "",
    Description = "",
    Tip = "",
    Ubertip = "",
    Hotkey = "",
    Art = "",
    scale = 1.00,
    file = "Objects\\InventoryItems\\TreasureChest\\treasurechest.mdl",
    Buttonpos1 = 0,
    Buttonpos2 = 0,
    selSize = 0.00,
    colorR = 255,
    colorG = 255,
    colorB = 255,
    armor = "Wood",
    Level = 0,
    oldLevel = 0,
    class = "Permanent",
    goldcost = 0,
    lumbercost = 0,
    HP = 100,
    stockStart = 0,
    stockRegen = 0,
    stockMax = 1,
    prio = 100,
    cooldownID = "Alat",
    ignoreCD = 0,
    morph = 0,
    drop = 0,
    powerup = 0,
    sellable = 1,
    pawnable = 1,
    droppable = 1,
    pickRandom = 1,
    uses = 0,
    perishable = 0,
    usable = 0,
}

---@param _v{abiList: "主动技能ID列表",Requires: "科技树",Requiresamount: "科技树",Name: "物品名称",Description: "物品描述",Tip: "物品描述标题",Ubertip: "物品在地上时说明",Hotkey: "热键",Art: "图标",scale: "模型大小",file: "模型路径",Buttonpos1: "商店X坐标",Buttonpos2: "商店Y坐标",selSize: "选择圈大小",colorR: "颜色R",colorG: "颜色G",colorB: "颜色B",armor: "装甲类型",Level: "等级",oldLevel: "等级(旧)",class: "物品分类",goldcost: "黄金",lumbercost: "木头",HP: "生命",stockStart: "开始库存",stockRegen: "补货周期",stockMax: "最大库存",prio: "优先权",morph: "有效的物品转换目标",drop: "死亡时掉落",powerup: "捡到时自动使用",sellable: "可以出售",pawnable: "可以抵押",droppable: "可以丢弃",pickRandom: "可以作为随机物品",uses: "使用次数",perishable: "使用后完全消失",usable: "主动使用"}
hslk_item = function(_v)
    -- 排除合并数值
    for tk, tv in pairs(hslk_item_tpl) do
        for vk, vv in pairs(_v) do
            if (hslk_item_tpl[vk] == nil) then
                _v[vk] = nil
            elseif (vv == nil) then
                _v[tk] = tv
            end
        end
    end
    _v.W2LObject = "dynamic|" .. _v.Name
    _v._parent = "rat9"
    _v._class = "item"
    table.insert(SLK_GO, _v)
end