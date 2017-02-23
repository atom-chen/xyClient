--
-- Author: Wu Hengmin
-- Date: 2015-08-05 15:58:40
--

local huodong_qiandao_item = class("huodong_qiandao_item")

function huodong_qiandao_item:ctor(node)
	-- body

	local visibleSize = cc.Director:getInstance():getVisibleSize()
	
	self._rootNode = node
	self._rootNode:setContentSize(visibleSize)
    -- ccui.Helper:doLayout(self._rootNode)

    self:init()


end

function huodong_qiandao_item:init()
	-- body
	self._rootNode:setCascadeOpacityEnabled(true)
end

function huodong_qiandao_item:getResourceNode()
	-- body
	return self._rootNode
end

function huodong_qiandao_item:update(data)
	-- body

	self.data = data[1]
	
	-- 更新头像
	local iconNode = self._rootNode:getChildByName("icon_node")
	iconNode:removeAllChildren()
	iconNode:setCascadeOpacityEnabled(true)

	local icon = UIManager:CreateDropOutFrame(
			self.data.obj_type,
			self.data.obj_id
		):getResourceNode()
	if icon then
		icon:setCascadeOpacityEnabled(true)
		icon:setPosition(50, 50)
		iconNode:addChild(icon)
	end

	-- 更新数量
	local count = self._rootNode:getChildByName("count")
	count:setString("x"..self.data.obj_num)
	
end

return huodong_qiandao_item