--
-- Author: Wu Hengmin
-- Date: 2015-08-13 10:56:11
--

--[[
params.bgImg 背景图片控件
params.iconImg icon图片控件
params.heroTempleateID 英雄模板ID
]]
HERO_ICON_LARGE_HELPER = {}
function HERO_ICON_LARGE_HELPER:updateIcon( params )
	local herodata = heroConfig[params.heroTempleateID]
	if herodata ~= nil then
		params.bgImg:loadTexture(ResIDConfig:getConfig_cardframe(herodata.star).frameImage, ccui.TextureResType.localType)
		params.iconImg:loadTexture(ResIDConfig:getConfig_role(herodata.bigID).bigiconImage, ccui.TextureResType.localType)
	else
		params.bgImg:loadTexture("icon/heros_big/cardframe_blue_big.png", ccui.TextureResType.localType)
		params.iconImg:loadTexture("icon/heros_big/heroicon4_big.png", ccui.TextureResType.localType)
	end
end


local hero_icon_large = class("hero_icon_large")

--params.resourceNode 已经创建好的资源节点
function hero_icon_large:ctor(params)

	if params == nil then		
		self.resourceNode_ = UIManager.avatarLargeModel:getChildByName("main_layout"):clone()
		self._rootNode = self.resourceNode_
	else
		self._rootNode = params.resourceNode
		self.resourceNode_ = params.resourceNode:getChildByName("main_layout")
	end
	--背景图标
	self.bgimage = self.resourceNode_:getChildByName("bg")
	--图标
	self.iconimage = self.resourceNode_:getChildByName("icon")

end

function hero_icon_large:getResourceNode()
	-- body
	return self.resourceNode_
end

function hero_icon_large:getRootNode()
	return self._rootNode
end

--[[设置显示数据
	
]]
function hero_icon_large:setAvatarByHeroID(id)
	self.id = id;

	HERO_ICON_LARGE_HELPER:updateIcon(
		{
			bgImg = self.bgimage,
			iconImg = self.iconimage,
			heroTempleateID = self.id
		}
	)
end

return hero_icon_large
 