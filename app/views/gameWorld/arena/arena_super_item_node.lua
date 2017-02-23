--
-- Author: Wu Hengmin
-- Date: 2015-07-30 15:52:11
--

local arena_super_item_node = class("arena_super_item_node", cc.load("mvc").ViewBase)

arena_super_item_node.RESOURCE_FILENAME = "ui_instance/arena/arena_super_item_node.csb"

function arena_super_item_node:onCreate()
	-- body
	
end

function arena_super_item_node:updateDisplay(data)
	-- body
	local name = self.resourceNode_:getChildByName("name")
	name:setString(UIManager:createDropName(data.goods.obj_type, data.goods.obj_id))
	local price = self.resourceNode_:getChildByName("price")
	price:setString(data.price_sjl)
	local button = self.resourceNode_:getChildByName("button")
	local function clickEvent()
		-- body
		print("购买")
		gameTcp:SendMessage(MSG_C2MS_PVP_BUY_GOODS, {data.id})
	end
	button:addClickEventListener(clickEvent)
end

return arena_super_item_node