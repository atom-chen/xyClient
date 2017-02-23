--
-- Author: LiYang
-- Date: 2015-07-07 15:00:08
-- 战场显示管理
--[[
	次逻辑代码
	主要处理游戏显示对象的遮罩关系
]]

--[[监听全局事件名预览
eventModleName: mainpage_popup_buttons2
eventName:
	zhandou_touched -- 点击主线按钮
]]

local battleShowLayerManager = class("battleShowLayerManager");

function battleShowLayerManager:ctor(target)
	self.target_ = target;

	self.registerConfig = {
		{"controler_mainpage_zhanyi1_layer","zhanyi_touched",1},
		{"battleshowlayer","event_addshowobject",1},--添加显示对象
		{"battleshowlayer","event_removeshowobject",1},--删除显示对象
		{"battleshowlayer","event_createmap",1},--创建地图
		{"battleshowlayer","event_addlogicbject",1},--添加逻辑对象
		{"battleshowlayer","event_hide",1},--隐藏战斗显示
		{"battleshowlayer","event_show",1},--显示
		{"battleshowlayer","event_cut",1},--切换
		{"battlefield","event_create",1}, --战场创建
		{"battlefield","exit",1},--退出战斗界面
		{"battlefield","shake",1},--战场震动
		{"battlefield","focus",1},--战场聚焦
	}

	--添加对象
	--删除对象

	--地图对象
	self.map = nil;
	--管理对象池
	self.objectPool = {};
	--战场显示状态 0 不显示 1 显示
	self.battleShowState = false;

	-- self:register_event_createmap( nil );

	self:register_event(  );
end


--注册事件
function battleShowLayerManager:register_event(  )
	local defaultCallbacks = {
		controler_mainpage_zhanyi1_layer_zhanyi_touched = handler(self, self.register_event_show),
		battlefield_event_create = handler(self, self.register_event_create),
        battleshowlayer_event_addshowobject = handler(self, self.register_event_addshowobject),
        battleshowlayer_event_addlogicbject = handler(self, self.register_event_addLogicbject),
        battleshowlayer_event_removeshowobject = handler(self, self.register_event_removeshowobject),
        battleshowlayer_event_createmap = handler(self, self.register_event_createmap),
        battleshowlayer_event_hide = handler(self, self.register_event_hide),
        battleshowlayer_event_show = handler(self, self.register_event_show),
        battleshowlayer_event_cut = handler(self, self.register_event_cut),
        battlefield_exit = handler(self, self.register_event_exit),
        battlefield_shake = handler(self, self.register_event_shake),
        battlefield_focus = handler(self, self.register_event_focus),
    }
    self.eventlisen = {};
	for i,v in ipairs(self.registerConfig) do
		local eventname = createGlobaleEventName( v[1], v[2] )
		if defaultCallbacks[eventname] then
			print("注册事件:",eventname)
			self.eventlisen[eventname] = createGlobalEventListener( v[1], v[2], defaultCallbacks[eventname], v[3] )
		end
	end
end

function battleShowLayerManager:addExecuteEvent( eventname )
	if not eventname then
		return;
	end
	for i,v in ipairs(eventname) do
		table.insert(self.registerConfig, 1, eventname)
	end
end

--注册关闭事件
function battleShowLayerManager:register_event_close(  )
	printInfo("PromptOperate")
	--清除事件监听
	for k,v in pairs(self.eventlisen) do
		GLOBAL_EVENT_DISPTACHER:removeEventListener(v);
	end
	-- self.target_:removeFromParent();
end


--创建战斗界面
function battleShowLayerManager:register_event_create( event )
	--开始游戏按钮
	local battleisshow = event._usedata[1];--是否显示
    local screenSize = cc.Director:getInstance():getWinSize()
    print("screenSize:",screenSize.width,screenSize.height)
    --添加战场显示
    self.target_ = require("app.views.battlefield.battleshowLayer").new();
    self.scene = APP:getCurScene()
    local scene = MainPageSystemInstance.scene
	scene:addChildToLayer(LAYER_ID_UI, self.target_)
    self.target_:setPosition(cc.p(display.cx,display.cy));

    --创建Ui
    dispatchGlobaleEvent( "battlefield" ,"ui_initialize");
    
    --判读是否显示
    if battleisshow then
    	self:register_event_show();
    else
    	self:register_event_hide();
    end
    

    --添加ui
    -- self.battleUI_b = cc.CSLoader:createNode("ui_instance/battlefield/battle_ui_bottom.csb")
    -- self:addChildToLayer(LAYER_ID_UI, self.battleUI_b)

    -- control_Combat:doEvent("event_initialize","testcjcj");

    -- local delay_1 = cc.DelayTime:create(1);
    -- local callfun = cc.CallFunc:create(function (  )
    --     control_Combat:doEvent("event_entrance");
    -- end)
    -- self.target_:runAction(cc.Sequence:create(delay_1,callfun));
end

--创建地图
function battleShowLayerManager:register_event_createmap( event )
	local mapinfo = event._usedata;
	-- self.map = require("app.views.battlefield.map.battlefieldmap").new();
	-- self.target_.mapLayer:addChild(self.map);
	-- self.map:setPosition(cc.p(display.cx - self.map.width / 2 ,display.cy - self.map.height / 2));
	-- --设置map 数据
	-- Data_Battle.mapData.mapStartPos_x = 0;
	-- Data_Battle.mapData.mapStartPos_y = display.cy + self.map.height / 2;

	--更新地图
	self.target_.map:updateMapShow( mapinfo );
end

--隐藏
function battleShowLayerManager:register_event_hide( event )
	print("battleShowLayerManager:register_event_hide",self.target_)
	self.battleShowState = false;
	dispatchGlobaleEvent("controler_mainPage_ui_layer", "setUIVisible", {visibleType="showAll"})
    dispatchGlobaleEvent("controler_mainpage_top_layer", "setUIVisible", {visibleType="showAll"})
    dispatchGlobaleEvent("model_playerBaseAttr", "setUIVisible", {visibleType="showAll"})
    self.target_:setVisible(false);
    self.target_:hide();
    -- self.target_:setPosition(cc.p(display.cx, -2000))
end

--显示
function battleShowLayerManager:register_event_show( event )
	print("battleShowLayerManager:register_event_show",self.target_)
	self.battleShowState = true;
	dispatchGlobaleEvent("controler_mainPage_ui_layer", "setUIVisible", {visibleType="hideAll"})
    dispatchGlobaleEvent("controler_mainpage_top_layer", "setUIVisible", {visibleType="hideAll"})
    dispatchGlobaleEvent("model_playerBaseAttr", "setUIVisible", {visibleType="hideAll"})
    self.target_:setVisible(true);
    self.target_:show();
    -- self.target_:setPosition(cc.p(display.cx, display.cy));
end

--战役切换
function battleShowLayerManager:register_event_cut( event )
	local operation = event._usedata[1];
	print("battleShowLayerManager:register_event_cut",operation);
	if operation == 1 then
		self.target_:show();
	elseif operation == 0 then
		self.target_:hide();
	elseif operation == 2 then
		self.target_:cut();
	end
	
end

--添加对象
function battleShowLayerManager:register_event_addshowobject( event )
	local object = event._usedata[1];
	local layer = event._usedata[2];
	local zorder = event._usedata[3];
	print("register_event_addshowobject:",object,layer,zorder)
	if zorder then
		object:setLocalZOrder(zorder);
	end
	-- print("==========",object.mark)
	self.objectPool[object] = object;
	if layer == 0 then
		self.target_.effectLayer_0:addChild(object)
	elseif layer == 1 then
		self.target_.effectLayer_1:addChild(object)
	elseif layer == 2 then
		self.target_.effectLayer_2:addChild(object)
	elseif layer == 3 then
		self.target_.effectLayer_3:addChild(object)
	elseif layer == 4 then
		print("register_event_addshowobject",object,layer,zorder,self.target_.uiLayer)
		--ui层
		self.target_.uiLayer:addChild(object);
	elseif layer == 5 then
		--全屏效果层
		self.target_.effect_screen:addChild(object);
	end
end

function battleShowLayerManager:register_event_addLogicbject( event )
	print("register_event_addLogicbject",tostring(event._usedata))
	self.target_.LogicNode:addChild(event._usedata)
end

function battleShowLayerManager:addLogicbject( objece )
	print("register_event_addLogicbject",tostring(objece))
	self.target_.LogicNode:addChild(objece)
end

function battleShowLayerManager:register_event_removeshowobject( object )
	if self.objectPool[object] then
		self.objectPool[object]:removeFromParent();
		self.objectPool[object] = nil;
	end
end

function battleShowLayerManager:register_event_shake( event )
	local time = event._usedata[1];
	--添加全屏震动效果
	if not self.ShakeEffect then
		self.ShakeEffect = require("app.effect.effectpiece.Effect_Shake").new();
		self.target_.LogicNode:addChild(self.ShakeEffect);
		self.ShakeEffect:setData({
			view = self.target_.showList,
			offset = 10,--偏移量
			runtime = time,
			finishCallBack = nil,
			});
	else
		self.ShakeEffect:setShackeTime( time );
	end
end

--聚焦效果
function battleShowLayerManager:register_event_focus( event )
	local action = event._usedata[1];
	self.target_.BottomLayer:runAction(action);
end

--清理战场
function battleShowLayerManager:register_event_exit( event )
	--清理效果 0 1 2 3
	self.target_.effectLayer_0:removeAllChildren();
	self.target_.effectLayer_1:removeAllChildren();
	self.target_.effectLayer_2:removeAllChildren();
	self.target_.effectLayer_3:removeAllChildren();
	self.objectPool = {};
	--结束战场聚焦效果
	self:UpdataAnchorPoint(  0, 0 )
	self.target_.BottomLayer:setScale(1, 1);
	self.target_.BottomLayer:setPosition(cc.p(0,0));
	-- self.target_ = nil;
end

function battleShowLayerManager:updateShowOrderLogic()
	for i,v in pairs(self.objectPool) do
		--遮罩关系 x + y
		-- local order = v.map_x + v.map_y;
		if v then
			v:setLocalZOrder(v.map_x + v.map_y)
		end
	end
end

function battleShowLayerManager:isShow(  )
	
	return self.battleShowState;
end

--[[修改焦点 battleShowManager:UpdataAnchorPoint(  300 , 300 );
]]
function battleShowLayerManager:UpdataAnchorPoint(  x , y )
	self.Focus_x = x;
	self.Focus_y = y;
	local pos_x = 0;
	local pos_y = 0;
	if x == 0 then
		pos_x = 0;
	else
		pos_x = -x;
	end

	if y == 0 then
		pos_y = 0;
	else
		pos_y = -y;
	end
	self.target_.FocusControl:setPosition(cc.p(pos_x, pos_y));
	self.target_.BottomLayer:setPosition(cc.p(x, y));
end

function battleShowLayerManager:getInstance(  )
    if battleShowLayerManager.instance == nil then
        battleShowLayerManager.instance = battleShowLayerManager.new()
    end
    return battleShowLayerManager.instance
end

battleShowManager = battleShowLayerManager.getInstance( );

return battleShowLayerManager;
