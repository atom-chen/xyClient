--
-- Author: Wu Hengmin
-- Date: 2015-08-26 11:20:26
--


local qiandao_item = class("qiandao_item", cc.load("mvc").ViewBase)

qiandao_item.RESOURCE_FILENAME = "ui_instance/huodong2/qiandao_item.csb"

function qiandao_item:onCreate()
	-- body

	self.resourceNode_:setCascadeOpacityEnabled(true)
end

function qiandao_item:update(id)
	-- body
	self.data = qiandao_rewardCfg[id][1] -- 只有一个物品,有多个物品的话另外处理




	-- 图标层
	local iconNode = self.resourceNode_:getChildByName("Panel_1")
	iconNode:removeAllChildren()
	iconNode:setCascadeOpacityEnabled(true)

	local icon = UIManager:CreateDropOutFrame(
		self.data.obj_type,
		self.data.obj_id
	):getResourceNode()
	if icon then
		icon:setSwallowTouches(false)
		icon:setCascadeOpacityEnabled(true)
		icon:setPosition(43, 43)
		iconNode:addChild(icon)
	end

	-- 数量
	local num = self.resourceNode_:getChildByName("Panel_1_0"):getChildByName("Text_1")
	num:setString("x"..self.data.obj_num)


	-- 是否获得
	local shadow = self.resourceNode_:getChildByName("Panel_1_1")
	if id > MAIN_PLAYER.qiandaoManager.leiji then
		shadow:setVisible(false)
	else
		shadow:setVisible(true)
	end
	
end

return qiandao_item
