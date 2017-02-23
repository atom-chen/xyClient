--
-- Author: Wu Hengmin
-- Date: 2015-09-07 16:20:14
--

local skill_item = class("skill_item")

function skill_item:ctor(node)
	-- body

	local visibleSize = cc.Director:getInstance():getVisibleSize()
	
	self._rootNode = node
	-- self._rootNode:setContentSize(visibleSize)
 --    ccui.Helper:doLayout(self._rootNode)

    self:init()
    self:_registUIEvent()

end

function skill_item:init()
	-- body
	self._rootNode:setCascadeOpacityEnabled(true)
end

function skill_item:getResourceNode()
	-- body
	return self._rootNode
end


function skill_item:_registUIEvent()
	-- body

end


function skill_item:update(skillid)
	-- body
	self.skillid = skillid
	local icon = self._rootNode:getChildByName("Image_1")
	icon:loadTexture(ResIDConfig:getConfig_bufframe(SkillConfig[skillid].icon).icon, ccui.TextureResType.plistType)

	local name = self._rootNode:getChildByName("Text_1")
	name:setString(SkillConfig[skillid].name)


	local descrip = self._rootNode:getChildByName("Text_1_0")
	descrip:setString(SkillConfig[skillid].description)
	

end

return skill_item
