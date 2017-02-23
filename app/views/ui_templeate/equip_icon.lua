--
-- Author: LiYang
-- Date: 2015-07-15 10:58:16
-- 装备icon图标

EQUIP_ICON_HELPER = {}

--[[
params.bgImg 背景图片控件
params.iconImg icon图片控件
params.equipTempleateID 装备模板ID
]]
function EQUIP_ICON_HELPER:updateIcon( params )
	local resdata = EquipConfig[params.equipTempleateID];
	if resdata ~= nil and ResIDConfig:getConfig_equipicon(resdata.Icon) then
		params.iconImg:loadTexture(ResIDConfig:getConfig_equipicon(resdata.Icon).icon, ccui.TextureResType.plistType)
	else
		params.iconImg:loadTexture("icon/equip/equip_10001.png", ccui.TextureResType.plistType)
	end
	
	if resdata ~= nil and ResIDConfig:getConfig_cardframe(resdata.quality) then
		params.bgImg:loadTexture(ResIDConfig:getConfig_cardframe(resdata.quality).smallFrameImage, ccui.TextureResType.plistType)
		params.guide:loadTexture(ResIDConfig:getConfig_cardframe(resdata.quality).smallFrameImageGuide, ccui.TextureResType.plistType)
	else
		params.bgImg:loadTexture("icon/heros/cardframe_gray_small.png", ccui.TextureResType.plistType)
	end
end

local equip_icon = class("equip_icon")

local RESOURCE_FILENAME = "ui_templeate/icon/equip_icon.csb"
function equip_icon:ctor(params)
	if params == nil then		
		self.resourceNode_ = UIManager.equipModel:getChildByName("main_layout"):clone()
		self._rootNode = self.resourceNode_
	else
		self.resourceNode_ = params.resourceNode:getChildByName("main_layout")
		self._rootNode = params.resourceNode
	end
	
	--背景图标
	self.bgimage = self.resourceNode_:getChildByName("bg");
	--图标
	self.iconimage = self.resourceNode_:getChildByName("icon");
	--数量
	self.count = self.resourceNode_:getChildByName("count");
	self.count:setVisible(false);

	self.guide = self.resourceNode_:getChildByName("Image_1")

	-- local visibleSize = cc.Director:getInstance():getVisibleSize()

	-- self._rootNode = node:setContentSize(visibleSize)
 --    ccui.Helper:doLayout(self._rootNode)

 	--大小
 	self.width = self.resourceNode_:getContentSize().width;
 	self.height = self.resourceNode_:getContentSize().height;

end

function equip_icon:getResourceNode()
	-- body
	return self.resourceNode_
end


function equip_icon:getRootNode()
	return self._rootNode
end



--[[设置显示数据
]]
function equip_icon:setAvatarByID(id)
	self.showData = id
	EQUIP_ICON_HELPER:updateIcon(
		{
			bgImg = self.bgimage,
			iconImg = self.iconimage,
			equipTempleateID = id,
			guide = self.guide
		}
	)
end

function equip_icon:setCount( count )
	self.count:setString(count);
	self.count:setVisible(true);
end


return equip_icon
 