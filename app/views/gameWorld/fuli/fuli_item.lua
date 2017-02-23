--
-- Author: Wu Hengmin
-- Date: 2015-07-10 15:29:01
--

local fuli_item = class("fuli_item")


function fuli_item:ctor(node)
	-- body

	local visibleSize = cc.Director:getInstance():getVisibleSize()
	
	self._rootNode = node
	self._rootNode:setContentSize(visibleSize)
    ccui.Helper:doLayout(self._rootNode)

    self:init()

end

function fuli_item:init()
	-- body
	self._rootNode:setCascadeOpacityEnabled(true)
	self._rootNode:getChildByName("bg"):setSwallowTouches(false)
end

function fuli_item:getResourceNode()
	-- body
	return self._rootNode
end

function fuli_item:update(vipconf)
	-- body
	print(vipconf.gift_id)
	local goods = packsConfig[vipconf.gift_id]
	self:getResourceNode():getChildByName("name"):setString(goods.name)
	self:getResourceNode():getChildByName("price1"):setString(goods.price2)

	local iconNode = self:getResourceNode():getChildByName("icon_node")
	iconNode:removeAllChildren()
	iconNode:setCascadeOpacityEnabled(true)
	local icon = UIManager:CreateDropOutFrame(
			"道具",
			goods.icon
		):getResourceNode()
	if icon then
		icon:setCascadeOpacityEnabled(true)
		icon:setPosition(43, 43)
		iconNode:addChild(icon)
	end
	
end

return fuli_item
