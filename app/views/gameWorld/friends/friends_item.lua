--
-- Author: Wu Hengmin
-- Date: 2015-07-03 11:53:03
--

local friends_item = class("friends_item")


function friends_item:ctor(node)
	-- body

	local visibleSize = cc.Director:getInstance():getVisibleSize()
	
	self._rootNode = node
	self._rootNode:setContentSize(visibleSize)
    ccui.Helper:doLayout(self._rootNode)

    self:init()

end

function friends_item:init()
	-- body
	self._rootNode:setCascadeOpacityEnabled(true)
	self._rootNode:getChildByName("bg"):setSwallowTouches(false)
end

function friends_item:getResourceNode()
	-- body
	return self._rootNode
end


function friends_item:update(data)
	-- body
	self.data = data

	self._rootNode:getChildByName("name"):setColor(cc.c3b(200, 150, 50))
	self._rootNode:getChildByName("name"):setString(data.Name)

	self._rootNode:getChildByName("dengji"):setString("Lv: "..data.grade)

	self._rootNode:getChildByName("zhanli"):setColor(cc.c3b(200, 150, 50))
	self._rootNode:getChildByName("zhanli"):setString("战力:"..data.strength)

	self._rootNode:getChildByName("juntuan"):setColor(cc.c3b(200, 150, 50))
	self._rootNode:getChildByName("juntuan"):setString("军团:"..data.societyName)

	if data.mark_online == 0 then
		self._rootNode:getChildByName("stat"):setColor(cc.c3b(171, 40, 20))
		self._rootNode:getChildByName("stat"):setString("离线")
	else
		self._rootNode:getChildByName("stat"):setColor(cc.c3b(38, 117, 0))
		self._rootNode:getChildByName("stat"):setString("在线")
	end

	local iconNode = self._rootNode:getChildByName("icon_node")
	iconNode:removeAllChildren()
	iconNode:setCascadeOpacityEnabled(true)
	if data.captainhero and heroConfig[data.captainhero.ID] then
		local icon = UIManager:CreateDropOutFrame(
				"卡片",
				data.captainhero.ID
			):getResourceNode()
		if icon then
			icon:setPosition(50, 50)
			iconNode:addChild(icon)
		end
	else
		local icon = UIManager:CreateDropOutFrame(
				"卡片",
				0
			):getResourceNode()
		if icon then
			icon:setPosition(50, 50)
			iconNode:addChild(icon)
		end
	end


end

return friends_item
