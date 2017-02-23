--
-- Author: Wu Hengmin
-- Date: 2015-08-27 11:24:46
--


local vip_view = class("vip_view")

local class_item = import("app.views.gameWorld.market2.vip_item.lua")

function vip_view:ctor(node)
	-- body

	local visibleSize = cc.Director:getInstance():getVisibleSize()
	
	self._rootNode = node
	self._rootNode:setContentSize(visibleSize)
    ccui.Helper:doLayout(self._rootNode)

    self:init()
    self:_registUIEvent()

    self.itemModel = cc.CSLoader:createNode("ui_instance/market2/vip_item.csb")
    self.itemModel:retain()

end

function vip_view:init()
	-- body
	self._rootNode:setCascadeOpacityEnabled(true)
	self.items = {}
end

function vip_view:getResourceNode()
	-- body
	return self._rootNode
end

function vip_view:_registUIEvent()
	-- body

end

function vip_view:update(data)
	-- body
	local ListView = self._rootNode:getChildByName("ListView_1")

	for i=#self.items+1,#data do
		self.items[i] = class_item.new(
				self.itemModel:getChildByName("Panel_1"):clone()
			)
		self.items[i]:update(data[i])
		ListView:pushBackCustomItem(self.items[i]:getResourceNode())
	end

	ListView:refreshView()

	print("当前vip:"..USER.player:getBaseAttr():getVIPLv())
	if USER.player:getBaseAttr():getVIPLv() > 0 then

		ListView:scrollToPercentVertical(100*((USER.player:getBaseAttr():getVIPLv()-1)/(#VipConfig-1)), 1, true)
	else

	end

end

return vip_view
