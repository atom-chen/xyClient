--
-- Author: LiYang
-- Date: 2015-07-07 11:31:04
-- 战场地图

local battlefieldmap_1 = class("battlefieldmap_1", cc.load("mvc").ViewBase)

function battlefieldmap_1:ctor(  )
	self.rootnode = cc.CSLoader:createNode("ui_instance/battlefield/battle_map_0.csb") --testlayer
    self:addChild(self.rootnode , 1);
    self.width = self.rootnode:getContentSize().width;
    self.height = self.rootnode:getContentSize().height;
    print("battlefieldmap_1 ===========>",self.width,self.height)

    local function onNodeEvent(event)
            if "enter" == event then
                print("onNodeEvent:","enter");
                
            elseif "exit" == event then
                print("onNodeEvent:","exit");
            elseif "enterTransitionFinish" == event then
                print("enterTransitionFinish:","enterTransitionFinish");
                self:openAnimationEffect(  );
            end
        end
    self:registerScriptHandler(onNodeEvent)
end

--设置开场动画
function battlefieldmap_1:openAnimationEffect()
	-- self.rootnode:setTouchEnabled(true);

    self.mapImage = self.rootnode:getChildByName("Image_1");
	
    local function onTouchBegan(touch, event)
    	local target = event:getCurrentTarget()
        
        local locationInNode = target:convertToNodeSpace(touch:getLocation())
        local s = target:getContentSize()
        print("locationInNode ==>",locationInNode.x,locationInNode.y,s.width,s.height);

    	-- local location = touch:getLocation();
	    -- print("TouchBegan contrl",location.x,location.y ,display.cx ,display.cy)
	    print("===",Data_Battle.mapData:getWorldToMapTransform( locationInNode.x,locationInNode.y)); --,control_Combat:testlogic(  )
        -- print("1",Data_Battle.mapData:getWorldToMapTransform( 1095,544));
        -- print("2",Data_Battle.mapData:getWorldToMapTransform( 1215,620));
        -- print("3",Data_Battle.mapData:getWorldToMapTransform( 1332,690));
        -- print("4",Data_Battle.mapData:getWorldToMapTransform( 944,600));
        -- print("5",Data_Battle.mapData:getWorldToMapTransform( 788,660));

        -- print("6",Data_Battle.mapData:getWorldToMapTransform( 1364,463));
        print("6",Data_Battle.mapData:getWorldToNodeLayerSpace( display.cx,display.cy));
        -- control_Combat:doEvent("event_entrance");
	    return true;
    end
    local listener1 = cc.EventListenerTouchOneByOne:create()
    listener1:setSwallowTouches(false)
    listener1:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN )
    -- listener1:registerScriptHandler(onTouchMoved,cc.Handler.EVENT_TOUCH_MOVED )
    -- listener1:registerScriptHandler(onTouchEnded,cc.Handler.EVENT_TOUCH_ENDED )
    local eventDispatcher = self.rootnode:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener1, self.rootnode)
	-- self.rootnode:addTouchEventListener(touchEvent);
end

function battlefieldmap_1:updateMapShow( mapId )
    if not MapConfig[mapId] then
        return;
    end
    self.mapImage:loadTexture(MapConfig[mapId]);
end

--注册事件
function battlefieldmap_1:registerEvent()
    -- body
end

return battlefieldmap_1;