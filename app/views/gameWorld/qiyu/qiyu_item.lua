--
-- Author: Wu Hengmin
-- Date: 2015-08-26 11:20:26
--


local qiyu_item = class("qiyu_item")

function qiyu_item:ctor(node)
	-- body

	-- local visibleSize = cc.Director:getInstance():getVisibleSize()
	
	self._rootNode = node
	-- self._rootNode:setContentSize(visibleSize)
	-- ccui.Helper:doLayout(self._rootNode)

	self:init()

	self:_registUIEvent()

end

function qiyu_item:init()
	-- body
	self._rootNode:setCascadeOpacityEnabled(true)
end

function qiyu_item:getResourceNode()
	-- body
	return self._rootNode
end

function qiyu_item:_registUIEvent()
	-- body
	local button1 = self._rootNode:getChildByName("Image_1")
	local function button_1Clicked(sender, eventType)
		-- body
		if eventType == ccui.TouchEventType.began then
	        globalTouchEvent(sender,eventType)
	    elseif eventType == ccui.TouchEventType.moved then
	        globalTouchEvent(sender,eventType)
	    elseif eventType == ccui.TouchEventType.ended then
	        if globalTouchEvent(sender,eventType) then
		        if self.mode == 1 then
		        	if Qiyu_Type_OddConfig[self.data.id].botton1.result == 8 or Qiyu_Type_OddConfig[self.data.id].botton1.result == 9 then
		        		print("进入战斗")
			        	control_Battlefield:addRequestData( {
			        			mode = 1,
			        			battletype = Data_Battle.CONST_BATTLE_TYPE_QIYU, -- 战场类型
								buykey = table.indexof(MAIN_PLAYER.marketManager.qiyu, self.data),--购买序号
								operkey = 1,--操作序号
								teamdex = 1,
								isexecute = true,--是否马上执行
			        		} )
			        	dispatchGlobaleEvent("controler_mainpage_zhanyi1_layer", "zhanyi_touched")
			        	dispatchGlobaleEvent("qiyu_ctrl", "close")
			        else
			            gameTcp:SendMessage(MSG_C2MS_OPERATION_QIYU, {table.indexof(MAIN_PLAYER.marketManager.qiyu, self.data), 1})
			        end
			    elseif self.mode == 2 then
			    	control_Battlefield:addRequestData( {
			    			mode = 2,
		        			battletype = Data_Battle.CONST_BATTLE_TYPE_QIYU, -- 战场类型
							buykey = table.indexof(MAIN_PLAYER.marketManager.fuchou, self.data),--购买序号
							operkey = 1,--操作序号
							teamdex = 1,
							isexecute = true,--是否马上执行
		        		} )
		        	dispatchGlobaleEvent("controler_mainpage_zhanyi1_layer", "zhanyi_touched")
		        	dispatchGlobaleEvent("qiyu_ctrl", "close")
			    end
	        end
	    elseif eventType == ccui.TouchEventType.canceled then

	    end
	end
	button1:addTouchEventListener(button_1Clicked)

	local button2 = self._rootNode:getChildByName("Image_1_0")
	local function button_2Clicked(sender, eventType)
		-- body
		if eventType == ccui.TouchEventType.began then
	        globalTouchEvent(sender,eventType)
	    elseif eventType == ccui.TouchEventType.moved then
	        globalTouchEvent(sender,eventType)
	    elseif eventType == ccui.TouchEventType.ended then
	        if globalTouchEvent(sender,eventType) then
	        	if self.mode == 1 then
		        	if Qiyu_Type_OddConfig[self.data.id].botton2.result == 8 or Qiyu_Type_OddConfig[self.data.id].botton2.result == 9 then
			        	print("进入战斗")
			        	control_Battlefield:addRequestData( {
			        			battletype = Data_Battle.CONST_BATTLE_TYPE_QIYU, --战场类型
								buykey = table.indexof(MAIN_PLAYER.marketManager.qiyu, self.data),--购买序号
								operkey = 2,--操作序号
								teamdex = 1,
								isexecute = true,--是否马上执行
			        		} )
			        	dispatchGlobaleEvent("controler_mainpage_zhanyi1_layer", "zhanyi_touched")
			        	dispatchGlobaleEvent("qiyu_ctrl", "close")
			        else
			        	print("放弃")
			            gameTcp:SendMessage(MSG_C2MS_OPERATION_QIYU, {table.indexof(MAIN_PLAYER.marketManager.qiyu, self.data), 2})
			        end
			    elseif self.mode == 2 then
			    	gameTcp:SendMessage(MSG_C2MS_OPERATION_FUCHOU, {table.indexof(MAIN_PLAYER.marketManager.qiyu, self.data), 2})
			    end
	        end
	    elseif eventType == ccui.TouchEventType.canceled then

	    end
	end
	button2:addTouchEventListener(button_2Clicked)

end

function qiyu_item:update(data, mode)
	-- body
	self.data = data
	self.mode = mode
	if mode == 1 then
		print(Qiyu_Type_OddConfig[data.id].shuoming)
		local str = string.gsub(Qiyu_Type_OddConfig[data.id].shuoming, "$J", tostring(data.count))
		str = string.gsub(str, "$R", tostring(data.name))
		self._rootNode:getChildByName("Text_1_0"):setString(str)

		self._rootNode:getChildByName("Image_1"):getChildByName("Text_1"):setString(Qiyu_Type_OddConfig[data.id].botton1.chat)

		self._rootNode:getChildByName("Image_1_0"):getChildByName("Text_1"):setString(Qiyu_Type_OddConfig[data.id].botton2.chat)
	elseif mode == 2 then
		local str = string.gsub(Fuchou_Info_config[1].shuoming, "$R", tostring(data.name))
		self._rootNode:getChildByName("Text_1_0"):setString(str)

		self._rootNode:getChildByName("Image_1"):getChildByName("Text_1"):setString(Fuchou_Info_config[1].botton1.chat)

		self._rootNode:getChildByName("Image_1_0"):getChildByName("Text_1"):setString(Fuchou_Info_config[1].botton2.chat)
	end

	
--[[ 确认复仇操作
*
* int 序号
* int 操作的序号
* int 当前队伍的编号
*
]]
-- MSG_C2MS_OPERATION_FUCHOU

end


return qiyu_item
