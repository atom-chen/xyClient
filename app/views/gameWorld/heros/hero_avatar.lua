--
-- Author: Wu Hengmin
-- Date: 2015-07-07 14:11:09
--

local hero_avatar = class("hero_avatar")

function hero_avatar:ctor(icon)
	-- body
	self:_initData()

	local visibleSize = cc.Director:getInstance():getVisibleSize()
	
	self._rootNode = icon
	self._rootNode:setContentSize(visibleSize)
    ccui.Helper:doLayout(self._rootNode)
    self:_registUIEvent()
end

function hero_avatar:_initData()
	-- body
end

function hero_avatar:_registUIEvent()
	-- body
end

function hero_avatar:update(data)
	-- body
	self._rootNode:getChildByName("icon"):loadTexture("ui_image/heros/avatar/heroicon3_big.png", ccui.TextureResType.localType)
end

return hero_avatar