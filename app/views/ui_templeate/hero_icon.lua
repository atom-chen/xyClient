--
-- Author: LiYang
-- Date: 2015-07-15 10:58:16
-- 英雄icon图标

HERO_ICON_HELPER = {}

--[[
params.bgImg 背景图片控件
params.iconImg icon图片控件
params.heroTempleateID 英雄模板ID
]]
function HERO_ICON_HELPER:updateIcon( params )
	local herodata = heroConfig[params.heroTempleateID]
	if herodata ~= nil then
		params.bgImg:loadTexture(ResIDConfig:getConfig_cardframe(herodata.star).smallFrameImage, ccui.TextureResType.plistType)
		params.iconImg:loadTexture(ResIDConfig:getConfig_role(herodata.bigID).smelliconImage, ccui.TextureResType.plistType)
		params.guideImg:loadTexture(ResIDConfig:getConfig_cardframe(herodata.star).smallFrameImageGuide, ccui.TextureResType.plistType)
	else
		params.bgImg:loadTexture("icon/heros/cardframe_gray_small.png", ccui.TextureResType.plistType)
		params.iconImg:loadTexture("icon/heros/heroicon0_small.png", ccui.TextureResType.plistType)
	end
end

local hero_icon = class("hero_icon")

local RESOURCE_FILENAME = "ui_templeate/icon/hero_icon.csb"

--params.resourceNode 已经创建好的资源节点
function hero_icon:ctor(params)

	if params == nil then		
		self.resourceNode_ = UIManager.avatarModel:getChildByName("main_layout"):clone()
		self._rootNode = self.resourceNode_
	else
		self._rootNode = params.resourceNode
		self.resourceNode_ = params.resourceNode:getChildByName("main_layout")
	end
	--背景图标
	self.bgimage = self.resourceNode_:getChildByName("bg");
	--图标
	self.iconimage = self.resourceNode_:getChildByName("icon");
	--数量
	self.count = self.resourceNode_:getChildByName("count");
	self.guide = self.resourceNode_:getChildByName("guide")
	self.count:setVisible(false);

	self.suipiansign = self.resourceNode_:getChildByName("Image_1")
	self.suipiansign:setVisible(false)

	-- local visibleSize = cc.Director:getInstance():getVisibleSize()

	-- self._rootNode = node:setContentSize(visibleSize)
 --    ccui.Helper:doLayout(self._rootNode)

 	--大小
 	self.width = self.resourceNode_:getContentSize().width;
 	self.height = self.resourceNode_:getContentSize().height;
end

function hero_icon:getResourceNode()
	-- body
	return self.resourceNode_
end

function hero_icon:getRootNode()
	return self._rootNode
end

--[[设置显示数据
	
]]
function hero_icon:setAvatarByHeroID(id)
	self.id = id
	HERO_ICON_HELPER:updateIcon(
		{
			bgImg = self.bgimage,
			iconImg = self.iconimage,
			guideImg = self.guide,
			heroTempleateID = id
		}
	)
	-- local herodata = heroConfig[id]
	-- if herodata ~= nil then
	-- 	self.bgimage:loadTexture(ResIDConfig:getConfig_cardframe(herodata.star).smallFrameImage, ccui.TextureResType.plistType)
	-- 	self.iconimage:loadTexture(ResIDConfig:getConfig_role(herodata.bigID).smelliconImage, ccui.TextureResType.plistType)
	-- else
	-- 	self.bgimage:loadTexture("icon/heros/cardframe_gray_small.png", ccui.TextureResType.plistType)
	-- 	self.iconimage:loadTexture("icon/heros/heroicon0_small.png", ccui.TextureResType.plistType)
	-- end
end

function hero_icon:setCount( count )
	self.count:setString("x"..count);
	self.count:setVisible(true);
end

function hero_icon:isFragment(bool)
	-- body
	print(bool)
	self.suipiansign:setVisible(bool)
end


return hero_icon
 