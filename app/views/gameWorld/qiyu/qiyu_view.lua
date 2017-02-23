--
-- Author: Wu Hengmin
-- Date: 2015-08-26 11:08:49
--

local qiyu_view = class("qiyu_view")

local class_item = import("app.views.gameWorld.qiyu.qiyu_item.lua")

function qiyu_view:ctor(node)
	-- body

	local visibleSize = cc.Director:getInstance():getVisibleSize()
	
	self._rootNode = node
	self._rootNode:setContentSize(visibleSize)
    ccui.Helper:doLayout(self._rootNode)

    self:init()
    self:_registUIEvent()

    self.itemModel = cc.CSLoader:createNode("ui_instance/qiyu/qiyu_item.csb")
    self.itemModel:retain()

end

function qiyu_view:init()
	-- body
	self._rootNode:setCascadeOpacityEnabled(true)
	self.items = {}
end

function qiyu_view:getResourceNode()
	-- body
	return self._rootNode
end

function qiyu_view:_registUIEvent()
	-- body

end

function qiyu_view:update(data, mode)
	-- body
	local listview = self._rootNode:getChildByName("ListView_1")


	for i=#self.items+1,#data do
		self.items[i] = class_item.new(
				self.itemModel:getChildByName("Panel_1"):clone()
			)
		listview:pushBackCustomItem(self.items[i]:getResourceNode())
	end

	for i=#data+1,#self.items do
		listview:removeLastItem()
		table.remove(self.items, #self.items) -- 因为一次只删除一项,所以这样做不会有问题
	end

	for i=1,#self.items do
		self.items[i]:update(data[i], mode)
	end



end

return qiyu_view
