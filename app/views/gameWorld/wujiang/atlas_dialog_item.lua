--
-- Author: Wu Hengmin
-- Date: 2015-09-08 15:47:20
--
local atlas_dialog_item = class("atlas_dialog_item")

function atlas_dialog_item:ctor(node)
	-- body

	local visibleSize = cc.Director:getInstance():getVisibleSize()
	
	self._rootNode = node
	-- self._rootNode:setContentSize(visibleSize)
 --    ccui.Helper:doLayout(self._rootNode)

    self:init()
    self:_registUIEvent()

end

function atlas_dialog_item:init()
	-- body
	self._rootNode:setCascadeOpacityEnabled(true)
end

function atlas_dialog_item:getResourceNode()
	-- body
	return self._rootNode
end


function atlas_dialog_item:_registUIEvent()
	-- body

end


function atlas_dialog_item:update(skillid)
	-- body
	self.skillid = skillid
	local icon = self._rootNode:getChildByName("Image_1")
	icon:loadTexture(ResIDConfig:getConfig_bufframe(SkillConfig[skillid].icon).icon, ccui.TextureResType.plistType)

	local name = self._rootNode:getChildByName("Text_1")
	name:setString(SkillConfig[skillid].name)


	local descrip = self._rootNode:getChildByName("Text_1_0")
	descrip:setString(SkillConfig[skillid].description)
	

end

return atlas_dialog_item
