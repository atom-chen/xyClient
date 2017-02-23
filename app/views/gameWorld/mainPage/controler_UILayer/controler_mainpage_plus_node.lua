--
-- Author: lipeng
-- Date: 2015-07-01 16:34:36
-- 控制器: 加号节点


local controler_mainpage_plus_node = class("controler_mainpage_plus_node")


--[[发送全局事件名预览
eventModleName: controler_mainpage_plus_node
eventName: 
	plus_touched --加号按钮touched
]]



function controler_mainpage_plus_node:ctor(plusNode)
	self:_initModels()

	local visibleSize = cc.Director:getInstance():getVisibleSize()

	self._plusNode = plusNode
	self._plusNode:setContentSize(visibleSize)
    ccui.Helper:doLayout(self._plusNode)

    self:_registUIEvent()
end

--parmas.nameID
function controler_mainpage_plus_node:runAction(parmas)
	print("================>" ,parmas.nameID)
	if parmas.nameID == "animation_leftTurn" then
		self:_runCCSAction_animation_leftTurn(parmas)

	elseif parmas.nameID == "animation_trunBack" then
		self:_runCCSAction_animation_trunBack(parmas)
	end
end


--初始化数据
function controler_mainpage_plus_node:_initModels()
	--旋转状态
	self.curTurnState = "trunBack"
end


--注册UI事件
function controler_mainpage_plus_node:_registUIEvent()
	--加号按钮回调
	local function btn_plusCallback( sender, eventType )
		print("===========================>",self.curTurnState)
		if eventType == ccui.TouchEventType.ended then
			if self.curTurnState == "leftTurn" then
				self:runAction({nameID="animation_trunBack"})
				self.curTurnState = "trunBack"
			else
				self:runAction({nameID="animation_leftTurn"})
				self.curTurnState = "leftTurn"
			end
		end

		dispatchGlobaleEvent("controler_mainpage_plus_node", "plus_touched", {sender=sender, eventType=eventType})
	end
	local btn_plus = self._plusNode:getChildByName("btn_plus")
    btn_plus:addTouchEventListener(btn_plusCallback)
end



function controler_mainpage_plus_node:_createTimeline()
	return cc.CSLoader:createTimeline("ui_instance/mainPage/mainpage_plus_node.csb")
end


--
function controler_mainpage_plus_node:_runCCSAction_animation_leftTurn(parmas)
	self._plusNode:stopAllActions()

	local action = self:_createTimeline()
	self._plusNode:runAction(action)
    action:play("animation_leftTurn", false)
end


--
function controler_mainpage_plus_node:_runCCSAction_animation_trunBack(parmas)
	self._plusNode:stopAllActions()

	local action = self:_createTimeline()
	self._plusNode:runAction(action)
    action:play("animation_trunBack", false)
end




return controler_mainpage_plus_node
