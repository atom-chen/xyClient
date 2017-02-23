--
-- Author: Wu Hengmin
-- Date: 2015-08-17 14:47:03
--


local chongzhu_view = class("chongzhu_view")

local class_sale_item = import("app.views.gameWorld.ronglian.sale_item.lua")

function chongzhu_view:ctor(node)
	-- body

	local visibleSize = cc.Director:getInstance():getVisibleSize()
	
	self._rootNode = node
	self._rootNode:setContentSize(visibleSize)
    ccui.Helper:doLayout(self._rootNode)

    self:init()
    self:_registUIEvent()


    self:update()
end

function chongzhu_view:init()
	-- body
	self._rootNode:setCascadeOpacityEnabled(true)
end

function chongzhu_view:getResourceNode()
	-- body
	return self._rootNode
end

function chongzhu_view:_registUIEvent()
	-- body
	local refresh = self._rootNode:getChildByName("Button_2")
	local function refreshClicked(sender)
		gameTcp:SendMessage(MSG_C2MS_RUSH_RONGLIAN_SHOP)
	end
	refresh:addClickEventListener(refreshClicked)

end

function chongzhu_view:update()
	-- body
	self._rootNode:getChildByName("pageview"):removeAllChildren()
	self.items = {}
	local x = 140
	local y = 305
	for i=1,#self.items do
		self.items[i]:removeFromParent(true)
	end
	for i=1,8 do
		print("新增")
		self.items[i] = class_sale_item:new()
		self.items[i]:setPosition(x, y)
		self._rootNode:getChildByName("pageview"):addChild(self.items[i])
		self.items[i]:setCascadeOpacityEnabled(true)
		self.items[i]:update(MAIN_PLAYER.marketManager.ronglianShop[i])
		

		if x == 890 then
			x = 140
			y = y - 200
		else
			x = x + 250
		end
	end


	local times = self._rootNode:getChildByName("Text_1")
	if MAIN_PLAYER.marketManager.freetimes then

		times:setString("免费刷新:"..MAIN_PLAYER.marketManager.freetimes.."次")
	end

	local time = self._rootNode:getChildByName("Text_1_0_0")


	local rongzhi = self._rootNode:getChildByName("Panel_53"):getChildByName("Text_1_0")
	rongzhi:setString(MAIN_PLAYER.baseAttr._ronglianzhi)

	if MAIN_PLAYER.marketManager.freetimes and VipConfig[MAIN_PLAYER.baseAttr._vipLv].every_day.refresh_save > MAIN_PLAYER.marketManager.freetimes then
		
		if MAIN_PLAYER.marketManager.freetime then

			self.time = MAIN_PLAYER.marketManager.freetime-os.time()+7200+g_time
			time:setString("恢复时间:"..self:gettime(self.time))
		end
		return true
	else
		time:setString("恢复时间:00:00:00")
		self:stop()
		return false
	end

	

end

function chongzhu_view:start()
	local time = self._rootNode:getChildByName("Text_1_0_0")

	local delay = cc.DelayTime:create(1)
	local runc = cc.CallFunc:create(function ()
		-- body
		if self.time > 0 then
			self.time = self.time - 1
			self:start()
			time:setString("恢复时间:"..self:gettime(self.time))
		else
			self:stop()
			gameTcp:SendMessage(MSG_C2MS_OPEN_RONGLIAN_SHOP)
		end
	end)
	time:runAction(cc.Sequence:create(delay, runc))

end

function chongzhu_view:stop()
	-- body
	local time = self._rootNode:getChildByName("Text_1_0_0")
	time:stopAllActions()
end

function chongzhu_view:gettime(sec)
	-- body
	local result = ""
	if math.floor(sec/3600) == 0 then
		result = result.."00:"
	elseif math.floor(sec/3600) < 10 then
		result = result.."0"..math.floor(sec/3600)..":"
	else
		result = result..math.floor(sec/3600)..":"
	end
	if math.floor(sec%3600/60) == 0 then
		result = result.."00:"
	elseif math.floor(sec%3600/60) < 10 then
		result = result.."0"..math.floor(sec%3600/60)..":"
	else
		result = result..math.floor(sec%3600/60)..":"
	end
	if sec%60 == 0 then
		result = result.."00"
	elseif sec%60 < 10 then
		result = result.."0"..sec%60
	else
		result = result..sec%60
	end
	return result
end

return chongzhu_view
