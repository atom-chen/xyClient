--
-- Author: Wu Hengmin
-- Date: 2015-08-12 11:09:27
--


local backpack_goods_sale_dialog = class("backpack_goods_sale_dialog", cc.load("mvc").ViewBase)

backpack_goods_sale_dialog.RESOURCE_FILENAME = "ui_instance/backpack/backpack_goods_sale_dialog.csb"

function backpack_goods_sale_dialog:onCreate()
	-- body

	GLOBAL_COMMON_ACTION:popupOut({
			node = self.resourceNode_:getChildByName("main_layout"),
			shadowNode = self.resourceNode_:getChildByName("shadow_layout"),
		})

	-- 退出按钮
	local exit = self.resourceNode_:getChildByName("main_layout"):getChildByName("Button_16")
	local function exitClicked(sender)
		self:close()
	end
	exit:addClickEventListener(exitClicked)

	-- 出售按钮
	local sale = self.resourceNode_:getChildByName("main_layout"):getChildByName("Panel_16"):getChildByName("Button_6")
	local function saleClicked(sender)
		gameTcp:SendMessage(MSG_C2MS_ITEMS_SELL, {1, self.data.id, self.count})
		self:close()
	end
	sale:addClickEventListener(saleClicked)

	-- 减少
	self.reduc = self.resourceNode_:getChildByName("main_layout"):getChildByName("Panel_16"):getChildByName("Image_2")
	local function touchreduc(sender, eventType)
		-- body
		if eventType == ccui.TouchEventType.began then
			self:run(sender)
			sender.Record_pos = sender:convertToWorldSpace(cc.p(0, 0))
        elseif eventType == ccui.TouchEventType.moved then
        	if not sender.MarkIsMove then
		    	local pos = sender:convertToWorldSpace(cc.p(0, 0))
		    	if cc.pGetLength(cc.p(pos.x - sender.Record_pos.x, pos.y - sender.Record_pos.y)) > 10 then
		    		sender:stopAllActions()
		    	end
		    end
        elseif eventType == ccui.TouchEventType.ended then
            sender:stopAllActions()
            self.count = self.count - 1
            if self.count < 0 then
            	self.count = 0
            end
            self:check()
        end
	end
	self.reduc:addTouchEventListener(touchreduc)

	-- 增加
	self.plus = self.resourceNode_:getChildByName("main_layout"):getChildByName("Panel_16"):getChildByName("Image_2_0")
	local function touchreduc(sender, eventType)
		-- body
		if eventType == ccui.TouchEventType.began then
			self:run(sender)
			sender.Record_pos = sender:convertToWorldSpace(cc.p(0, 0))
        elseif eventType == ccui.TouchEventType.moved then
        	if not sender.MarkIsMove then
		    	local pos = sender:convertToWorldSpace(cc.p(0, 0))
		    	if cc.pGetLength(cc.p(pos.x - sender.Record_pos.x, pos.y - sender.Record_pos.y)) > 5 then
		    		sender:stopAllActions()
		    	end
		    end
        elseif eventType == ccui.TouchEventType.ended then
            sender:stopAllActions()
            self.count = self.count + 1
            if self.count > self.data.count then
            	self.count = self.data.count
            end
            self:check()
        end
	end
	self.plus:addTouchEventListener(touchreduc)

	-- 最大值
	local max = self.resourceNode_:getChildByName("main_layout"):getChildByName("Panel_16"):getChildByName("Button_7_0_0")
	local function maxClicked(sender)
		if self.count == self.data.count then
			self.count = 0
		else
			self.count = self.data.count
		end
		self:check()
	end
	max:addClickEventListener(maxClicked)

	-- 更新卖出数量
	self.count = 0
	self:check()
end

function backpack_goods_sale_dialog:update(data)
	-- body
	-- icon
	self.data = data

	-- 名字
	local name = self.resourceNode_:getChildByName("main_layout"):getChildByName("Panel_16"):getChildByName("Text_6")
	name:setString(ItemsConfig[data.id].name)

	-- 数量
	local count = self.resourceNode_:getChildByName("main_layout"):getChildByName("Panel_16"):getChildByName("Text_7_0")
	count:setString(data.count)

end

function backpack_goods_sale_dialog:close()
	-- body
    GLOBAL_COMMON_ACTION:popupBack({
            node = self.resourceNode_:getChildByName("main_layout"),
            shadowNode = self.resourceNode_:getChildByName("shadow_layout"),
            callback = function ()
                -- body
                self:removeFromParent(true)
            end
        })
end

function backpack_goods_sale_dialog:run(obj, delay)
	-- body
	local time = delay or 0.5
	local delay = cc.DelayTime:create(time)
	local runc = cc.CallFunc:create(function ()
		-- body
		local tmp = 1
		if time < 0.01 then
			tmp = 21
		elseif time < 0.05 then
			tmp = 5
		elseif time < 0.1 then
			tmp = 4
		elseif time < 0.5 then
			tmp = 2
		end
		if obj == self.reduc then
			if self.count - tmp >= 0 then
				self.count = self.count - tmp
			elseif self.count == 0 then
				return
			else
				self.count = 0
			end
			self:check()
		elseif obj == self.plus then
			if self.count + tmp <= self.data.count then
				self.count = self.count + tmp
			elseif self.count == self.data.count then
				return
			else
				self.count = self.data.count
			end
			self:check()
		end
		self:run(obj, time*0.8)
	end)
	obj:runAction(cc.Sequence:create(delay, runc))
end

function backpack_goods_sale_dialog:check()
	-- body
	self.resourceNode_:getChildByName("main_layout"):getChildByName("Panel_16"):getChildByName("Text_7_2"):setString(self.count)
	-- 更新价格
	if self.data then
		self.resourceNode_:getChildByName("main_layout"):getChildByName("Panel_16"):getChildByName("Text_7_1_0"):setString(ItemsConfig[self.data.id].price*self.count)
	else
		self.resourceNode_:getChildByName("main_layout"):getChildByName("Panel_16"):getChildByName("Text_7_1_0"):setString(0)
	end
end

return backpack_goods_sale_dialog
