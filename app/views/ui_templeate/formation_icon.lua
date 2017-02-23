--
-- Author: lipeng
-- Date: 2015-07-23 10:30:55
-- 阵型icon

local formation_icon = class("formation_icon")

local RESOURCE_FILENAME = "ui_templeate/icon/equip_icon.csb"
local imgFilePath = "icon/formations/"

function formation_icon:ctor()
	self._view = nil
	self._formationID = 1
end

function formation_icon:setView( view )
	self._view = view
end

function formation_icon:createView()
	return cc.CSLoader:createNode(RESOURCE_FILENAME)
end

function formation_icon:setFormationID( id )
	self._formationID = id
	self:_updateView()
end

function formation_icon:_updateView()
	self._view:getChildByName("img"):loadTexture(
		self:_getImageName(self._formationID), 
		ccui.TextureResType.plistType
	)
end

function formation_icon:_getImageName( formationID )
	return "icon/formations/"..formationConfig_getImageName(self._formationID)
end


return formation_icon
