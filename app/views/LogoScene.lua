--
-- Author: lipeng
-- Date: 2015-06-11 14:56:30
-- Logo场景


local LogoScene = class("LogoScene", cc.load("mvc").ViewBase)

LogoScene.RESOURCE_FILENAME = "common_scene.csb"
function LogoScene:onCreate()
    -- add game over text
    -- local text = "Hello LogoScene!"
    -- cc.Label:createWithSystemFont(text, "Arial", 96)
    --     :align(display.CENTER, display.center)
    --     :addTo(self)
    cc.bind(self, "layerManager")


    -- self:registerScriptHandler(
    -- 	handler(self, self.onNodeEvent)
    -- )
    -- self.rootnode = cc.CSLoader:createNode("Nodetest.csb") --testlayer
    -- self:addChild(self.rootnode)
    -- self:addChildToLayer(LAYER_ID_UI, self.rootnode)

    -- local function touchEvent(sender,eventType)
    --     if eventType == ccui.TouchEventType.began then
    --         -- self._displayValueLabel:setString("Touch Down")
    --         print("Touch Down")
    --     elseif eventType == ccui.TouchEventType.moved then
    --         -- self._displayValueLabel:setString("Touch Move")
    --         print("Touch Move")
    --     elseif eventType == ccui.TouchEventType.ended then
    --         -- self._displayValueLabel:setString("Touch Up")
    --         print("Touch Up")
    --         -- self:execute_ServerShow(  );
    --     elseif eventType == ccui.TouchEventType.canceled then
    --         -- self._displayValueLabel:setString("Touch Cancelled")
    --         print("Touch Cancelled")
    --     end
    -- end
    -- local imageConltr = self.rootnode:getChildByName("Image_1");
    -- imageConltr:addTouchEventListener(touchEvent);
    local function clickevent( sender )
        print("clickevent")
    end
    local layout_1 = self.rootnode:getChildByName("Image_1");--Panel_1
    
    layout_1:addClickEventListener(clickevent);
    -- self.rootnode:setT
    
end

function LogoScene:_onNodeEvent( tag )
	if tag == "enterTransitionFinish" then
        self.schedulerHandler = GLOBAL_SCHEDULER:scheduleScriptFunc(
	    	handler(self, self._toLoginScene),
	    	1.0, false
	    )
    end
end


function LogoScene:_toLoginScene(dt)
	GLOBAL_SCHEDULER:unscheduleScriptEntry(self.schedulerHandler)
    APP:toScene(SCENE_ID_LOGIN)
end



return LogoScene


