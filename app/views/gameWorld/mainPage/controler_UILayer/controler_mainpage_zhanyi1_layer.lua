--
-- Author: lipeng
-- Date: 2015-07-02 15:39:31
-- 控制器: 战役1

local controler_mainpage_zhanyi1_layer = class("controler_mainpage_zhanyi1_layer")

function controler_mainpage_zhanyi1_layer:ctor(mainpage_zhanyi1_layer)
	self:_initModels()

	local visibleSize = cc.Director:getInstance():getVisibleSize()

	self._mainpage_zhanyi1_layer = mainpage_zhanyi1_layer

	self._animNode = self._mainpage_zhanyi1_layer:getChildByName("Sprite_1")
	self._clickAnim = self._mainpage_zhanyi1_layer:getChildByName("clickAnim")

    self:_registUIEvent()
    --self:_runAllAction()
end


--初始化数据
function controler_mainpage_zhanyi1_layer:_initModels()

end



--注册UI事件
function controler_mainpage_zhanyi1_layer:_registUIEvent()

	-- local function btn_zhanyiCallback( sender, eventType )
	-- 	if eventType == ccui.TouchEventType.ended then
	-- 		-- self._animNode:setVisible(false)
	-- 		-- local action = cc.CSLoader:createTimeline("ui_instance/mainPage/anim/mainpage_anim_zhan1_click.csb")
	-- 	 --    self._clickAnim:runAction(action)
	-- 	 --    action:play("animation0", false)
	-- 		dispatchGlobaleEvent("controler_mainpage_zhanyi1_layer", "zhanyi_touched", {sender=sender, eventType=eventType})
	-- 	end
	-- end
	-- btn_zhanyi:addTouchEventListener(btn_zhanyiCallback)

	-- local btn_zhanyi = self._mainpage_zhanyi1_layer:getChildByName("Button_1")
 --    btn_zhanyi:addTouchEventListener(handler(self, self._btn_zhanyiCallback) ) 
 --    btn_zhanyi:setSwallowTouches(false)

 	local function btn_zhanyiCallback( sender, eventType )
		if eventType == ccui.TouchEventType.ended then
			dispatchGlobaleEvent("controler_mainpage_zhanyi1_layer", "zhanyi_touched", {sender=sender, eventType=eventType})
		end
	end

	local btn_zhanyi = self._mainpage_zhanyi1_layer:getChildByName("Button_1")
    btn_zhanyi:addTouchEventListener(btn_zhanyiCallback)
    btn_zhanyi:setSwallowTouches(false)
end


function controler_mainpage_zhanyi1_layer:_runAllAction()
    -- local action = cc.CSLoader:createTimeline("ui_instance/mainPage/anim/mainpage_anim_zhan1_click.csb")
    -- self._animNode:runAction(action)
    -- -- action:play("animation0", true)

    local animNode = self._mainpage_zhanyi1_layer:getChildByName("Sprite_1")
    local action = cc.CSLoader:createTimeline("ui_instance/mainPage/mainpage_zhanyi1_layer.csb")
    animNode:runAction(action)
    action:play("animation0", true)
end


function controler_mainpage_zhanyi1_layer:_btn_zhanyiCallback( sender, eventType )
	if eventType == ccui.TouchEventType.ended then
		self._animNode:setVisible(false)

		local clickAnimNode = self:_createClickAnimNode()
		self._clickAnim:addChild(clickAnimNode)

		-- clickAnimNode:getChildByName("ArmatureNode_1"):
		-- 	getAnimation():
		-- 	play("Animation1" , -1, false)
		-- local anim = self._clickAnim:getChildByName("ArmatureNode_1")
		-- self.armatureView:getAnimation():play(id , -1 ,isloop or 1);
		-- local action = cc.CSLoader:createTimeline("ui_instance/mainPage/anim/mainpage_anim_zhan1_click.csb")
	 --    self._clickAnim:runAction(action)
	 --    action:play("animation0", false)
		--dispatchGlobaleEvent("controler_mainpage_zhanyi1_layer", "zhanyi_touched", {sender=sender, eventType=eventType})
	end
end


function controler_mainpage_zhanyi1_layer:_createClickAnimNode()
    return cc.CSLoader:createNode("ui_instance/mainPage/anim/mainpage_anim_zhan1_click.csb")
end


return controler_mainpage_zhanyi1_layer
