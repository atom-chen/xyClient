--
-- Author: Wu Hengmin
-- Date: 2015-08-26 11:08:49
--

local qiandao_view = class("qiandao_view")

local class_item = import("app.views.gameWorld.huodong2.qiandao_item.lua")

function qiandao_view:ctor(node)
	-- body

	local visibleSize = cc.Director:getInstance():getVisibleSize()
	
	self._rootNode = node
	self._rootNode:setContentSize(visibleSize)
    ccui.Helper:doLayout(self._rootNode)

    self:init()
    self:_registUIEvent()

    self.itemModel = cc.CSLoader:createNode("ui_instance/huodong2/qiandao_item.csb")
    self.itemModel:retain()

end

function qiandao_view:init()
	-- body
	self._rootNode:setCascadeOpacityEnabled(true)
	self.items = {}
end

function qiandao_view:getResourceNode()
	-- body
	return self._rootNode
end

function qiandao_view:_registUIEvent()
	-- body
	-- 签到
	local qiandao = self._rootNode:getChildByName("Panel_1"):getChildByName("Panel_3"):getChildByName("Button_1")
	local function qiandaoClicked(sender)
		gameTcp:SendMessage(MSG_C2MS_QIANDAO)
	end
	qiandao:addClickEventListener(qiandaoClicked)

	-- 补签
	local buqian = self._rootNode:getChildByName("Panel_1"):getChildByName("Panel_3"):getChildByName("Button_1_0")
	local function buqianClicked(sender)
		gameTcp:SendMessage(MSG_C2MS_BUQIAN)
	end
	buqian:addClickEventListener(buqianClicked)

end

function qiandao_view:update()
	-- body
	for i=#self.items+1,#qiandao_rewardCfg do
		self.items[i] = class_item:new()
		self._rootNode:getChildByName("Panel_1"):addChild(self.items[i])
	end

	local x = 50
	local y = 320
	for i=1,#self.items do
		self.items[i]:update(i)
		self.items[i]:setPosition(x, y)
		self.items[i]:setScale(0.8, 0.8)
		
		if x == 770 then
			x = 50
			y = y - 90
		else
			x = x + 90
		end
	end


	-- 已签到次数
	local yiqiandao = self._rootNode:getChildByName("Panel_1"):getChildByName("Panel_3"):getChildByName("Text_1")
	yiqiandao:setString("已签到次数:"..MAIN_PLAYER.qiandaoManager.leiji)

	-- 可补签次数
	local yiqiandao = self._rootNode:getChildByName("Panel_1"):getChildByName("Panel_3"):getChildByName("Text_1_0_0")
	yiqiandao:setString(MAIN_PLAYER.qiandaoManager.kebuqian)


end

return qiandao_view
