--
-- Author: Wu Hengmin
-- Date: 2015-08-27 11:42:32
--


local vip_item = class("vip_item")

function vip_item:ctor(node)
	-- body

	-- local visibleSize = cc.Director:getInstance():getVisibleSize()
	
	self._rootNode = node
	-- self._rootNode:setContentSize(visibleSize)
	-- ccui.Helper:doLayout(self._rootNode)

	self:init()

	self:_registUIEvent()

end

function vip_item:init()
	-- body
	self._rootNode:setCascadeOpacityEnabled(true)
end

function vip_item:getResourceNode()
	-- body
	return self._rootNode
end

function vip_item:_registUIEvent()
	-- body

end

function vip_item:update(data)
	-- body
	self.data = data
	self._rootNode:getChildByName("Text_1"):setString(table.indexof(VipConfig, data))
	self._rootNode:getChildByName("Text_2"):setString(data.info)

end


return vip_item
