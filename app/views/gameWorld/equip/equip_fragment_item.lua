--
-- Author: Wu Hengmin
-- Date: 2015-07-20 13:52:06
--

local equip_fragment_item = class("equip_fragment_item")


function equip_fragment_item:ctor(node)
	-- body

	local visibleSize = cc.Director:getInstance():getVisibleSize()
	
	self._rootNode = node
	self._rootNode:setContentSize(visibleSize)
    ccui.Helper:doLayout(self._rootNode)

    self:init()
    self:_registUIEvent()
end

function equip_fragment_item:init()
	-- body
	self._rootNode:setCascadeOpacityEnabled(true)
	self._rootNode:getChildByName("bg"):setSwallowTouches(false)
end

function equip_fragment_item:getResourceNode()
	-- body
	return self._rootNode
end

function equip_fragment_item:_registUIEvent()
	-- body
	self.modelNode = self._rootNode

	local button = self.modelNode:getChildByName("button_hecheng")
	local function touchEvent(sender,eventType)
		if eventType == ccui.TouchEventType.began then
			sender:loadTexture("ui_image/equip/button_hecheng_1.png", ccui.TextureResType.plistType)
			globalTouchEvent(sender,eventType)
		elseif eventType == ccui.TouchEventType.moved then
			sender:loadTexture("ui_image/equip/button_hecheng_0.png", ccui.TextureResType.plistType)
			globalTouchEvent(sender,eventType)
		elseif eventType == ccui.TouchEventType.ended then
			sender:loadTexture("ui_image/equip/button_hecheng_0.png", ccui.TextureResType.plistType)
			if globalTouchEvent(sender,eventType) then
	        	-- dispatchGlobaleEvent("goods_ctrl", "clickSubTitleList", {sender=sender, eventType=eventType})
	        	print("合成")
	        	gameTcp:SendMessage(MSG_C2MS_EQUIPS_UNITE, {self.data.id})
		    end
    	end
    end
    button:setSwallowTouches(false)
	button:addTouchEventListener(touchEvent)
end


function equip_fragment_item:update(data)
	-- body
	self.data = data
	self.modelNode:getChildByName("name"):setString(EquipConfig[data.id].name)
	-- self.modelNode:getChildByName("lv"):setString(data.curLv)

	self.modelNode:getChildByName("count"):setString(data.count.."/"..EquipConfig[data.id].tile_need)

	-- 更新头像
	local iconNode = self.modelNode:getChildByName("icon_node")
	iconNode:removeAllChildren()
	iconNode:setCascadeOpacityEnabled(true)
	local icon = UIManager:CreateDropOutFrame(
			"装备",
			data.id
		):getResourceNode()
	if icon then
		icon:setCascadeOpacityEnabled(true)
		icon:setPosition(50, 50)
		iconNode:addChild(icon)
	end

end

return equip_fragment_item

