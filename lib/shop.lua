---@class hshop 商店相关
hshop = {}

--- 给中立商店添加出售物品，只影响有出售物品的单位
---@param whichUnit userdata
---@param itemId number|string
---@param currentStock number
---@param stockMax number
hshop.addItem = function(whichUnit, itemId, currentStock, stockMax)
    if (type(itemId) == "string") then
        itemId = string.char2id(itemId)
    end
    cj.AddItemToStock(whichUnit, itemId, currentStock, stockMax)
end

--- 删除中立商店物品
---@param whichUnit userdata
---@param itemId number|string
hshop.delItem = function(whichUnit, itemId)
    if (type(itemId) == "string") then
        itemId = string.char2id(itemId)
    end
    cj.RemoveItemFromStock(whichUnit, itemId)
end
