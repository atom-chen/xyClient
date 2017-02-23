--
-- Author: LiYang
-- Date: 2015-07-15 10:58:16
-- 道具icon图标

local goods_icon = class("goods_icon")

local RESOURCE_FILENAME = "ui_templeate/icon/goods_icon.csb"

--params.resourceNode 已经创建好的资源节点
function goods_icon:ctor(params)
	if params == nil then		
		self.resourceNode_ = UIManager.goodsModel:getChildByName("main_layout"):clone()
	else
		self.resourceNode_ = params.resourceNode
	end
	--图标
	self.iconimage = self.resourceNode_:getChildByName("icon")
	--数量
	self.count = self.resourceNode_:getChildByName("count")

	self.bgimage = self.resourceNode_:getChildByName("bg")

	self.guide = self.resourceNode_:getChildByName("Image_1")
	self.guide:setVisible(false)
	self.count:setVisible(false);

	-- local visibleSize = cc.Director:getInstance():getVisibleSize()

	-- self._rootNode = node:setContentSize(visibleSize)
 --    ccui.Helper:doLayout(self._rootNode)

 	--大小
 	self.width = self.resourceNode_:getContentSize().width;
 	self.height = self.resourceNode_:getContentSize().height;

end

function goods_icon:getResourceNode()
	-- body
	return self.resourceNode_
end

--[[设置显示数据
]]
function goods_icon:setAvatarByID(id)
	self.showData = id
	local resdata = getItemDisplayConfig(id)
	if resdata then
		self.iconimage:loadTexture(ResIDConfig:getConfig_daoju(resdata.res_id).icon, ccui.TextureResType.plistType)
		self.bgimage:setVisible(true)
		self.bgimage:loadTexture(ResIDConfig:getConfig_cardframe(resdata.quality).smallFrameImage, ccui.TextureResType.plistType)
		self.guide:setVisible(true)
		self.guide:loadTexture(ResIDConfig:getConfig_cardframe(resdata.quality).smallFrameImageGuide, ccui.TextureResType.plistType)
	end
end

function goods_icon:setCount( count )
	self.count:setString("x"..count)
	self.count:setVisible(true)
end


return goods_icon
 