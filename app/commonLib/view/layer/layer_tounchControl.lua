--
-- Author: lipeng
-- Date: 2015-06-26 13:57:42
--

local touchLayer = class("layer_tounchControl", function ()
	return cc.Layer:create()
end)


function touchLayer:ctor(controledNode)
    local function onTouchBegan(touch, event)
	    --print("TouchBegan contrl",GLOBAL_TOUCH_CONTROL:isControl())
	    return GLOBAL_TOUCH_CONTROL:isControl()
    end

    local listener1 = cc.EventListenerTouchOneByOne:create()
    listener1:setSwallowTouches(true)
    listener1:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN )
    -- listener1:registerScriptHandler(onTouchMoved,cc.Handler.EVENT_TOUCH_MOVED )
    -- listener1:registerScriptHandler(onTouchEnded,cc.Handler.EVENT_TOUCH_ENDED )
    local eventDispatcher = controledNode:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener1, self)
end



return touchLayer
