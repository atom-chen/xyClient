--
-- Author: LiYang
-- Date: 2015-08-26 14:49:57
-- 数值buf效果

local numericeBufEffect = class("numericeBufEffect",cc.Node)

function numericeBufEffect:ctor()
	
end

function numericeBufEffect:SetBufData( icon )
	self.showInfo = ResIDConfig:getConfig_bufframe( icon );
	local sprite = cc.Sprite:createWithSpriteFrameName("ui_image/battle/battle_ui/"..self.showInfo.icon);
	self:addChild(sprite);
end

return numericeBufEffect;
