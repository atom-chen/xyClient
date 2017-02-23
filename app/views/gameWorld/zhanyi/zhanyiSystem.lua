--
-- Author: Liyang
-- Date: 2015-06-26 17:28:09
-- 战役系统

--[[发送全局事件名预览
eventModleName: zhanyi_ctrl -- 战役界面内部控制
eventName: 
	choose_zhanyi 选择战役
	zhanyi_ctrl_choose_zhanyilevel 选择战役关卡
	zhanyi_ctrl_zhanyilevel_refresh 战役关卡刷新
]]

--[[监听全局事件名预览
eventModleName: mainpage_popup_buttons2
eventName:
	zhandou_touched -- 点击任务按钮
]]

local zhanyiSystem = class("zhanyiSystem")

local class_zhanyi = import(".UI_zhanyi")
local class_zhanyiitem = import(".UI_zhanyi_item")
local class_zhanyilevel = import(".UI_zhanyilevel")
local class_zhanyilevelitem = import(".UI_zhanyilevel_item")
local class_zhanyilevel_operation = import(".UI_zhanyilevel_operation");
function zhanyiSystem:ctor(target)

	self.target_ = target;

	-- self.registerConfig = {
	-- 	--初始化数据
	-- 	{"controler_mainpage_zhanyi1_layer","zhanyi_touched",1},
	-- 	{"zhanyi_ctrl","choose_zhanyi",1},--选择战役
	-- 	{"zhanyi_ctrl","choose_zhanyilevel",1},--选择战役
	-- 	{"zhanyi_ctrl","zhanyilevel_refresh",1},--战役关卡刷新
	-- 	{"zhanyi_ctrl","challenge",1},--挑战事件
	-- 	{"zhanyi_ctrl","challenge_result",1},--挑战结果显示刷新
	-- 	{"zhanyi_ctrl","exit",1},--战役退出
	-- }
	-- self:register_event();

	self.CurrentScheduleMark = 0;

end

--注册事件
function zhanyiSystem:register_event(  )
	local defaultCallbacks = {
		controler_mainpage_zhanyi1_layer_zhanyi_touched = handler(self, self.event_create),
		zhanyi_ctrl_choose_zhanyi = handler(self, self.event_choose_zhanyi),
		zhanyi_ctrl_choose_zhanyilevel = handler(self, self.event_choose_zhanyilevel),
		zhanyi_ctrl_zhanyilevel_refresh = handler(self, self.event_zhanyilevel_refresh),
		zhanyi_ctrl_challenge = handler(self, self.event_challenge),
		zhanyi_ctrl_challenge_result = handler(self, self.event_challenge_result),
		zhanyi_ctrl_exit = handler(self, self.event_exit),
    }
    self.eventlisen = {};
	for i,v in ipairs(self.registerConfig) do
		local eventname = createGlobaleEventName( v[1], v[2] )
		print("注册事件",eventname);
		if defaultCallbacks[eventname] then
			createGlobalEventListener( v[1], v[2], defaultCallbacks[eventname], v[3] )
		end
	end
end

function zhanyiSystem:addExecuteEvent( eventname )
	if not eventname then
		return;
	end
	for i,v in ipairs(eventname) do
		table.insert(self.registerConfig, 1, eventname)
	end
	
end

--初始化数据
function zhanyiSystem:event_create( event )
	--数据显示
	--创建战役列表
	local scene = MainPageSystemInstance.scene
	self.zhanyiView = class_zhanyi:new()
	self.scene = APP:getCurScene()
	scene:addChildToLayer(LAYER_ID_UI, self.zhanyiView)

	dispatchGlobaleEvent("controler_mainPage_ui_layer", "setUIVisible", {visibleType="hideAll"})
    dispatchGlobaleEvent("controler_mainpage_top_layer", "setUIVisible", {visibleType="showAll"})

	-- popupOut(shiji)

	--加载地图
	--得到地图宽高
	local mapsize = self.zhanyiView.zhanyiMap:getMapSize();
	print("================Map:",mapsize.width ,mapsize.height )
	local _TilePixelSize = self.zhanyiView.zhanyiMap:getTileSize();
	self.MapWidth = _TilePixelSize.width * mapsize.width;
	self.MapHeight = _TilePixelSize.height * mapsize.height;
	print("================Map size:",self.MapWidth ,self.MapHeight);
	print("================Map _TilePixelSize:",_TilePixelSize.width ,_TilePixelSize.height )
	
	--显示的背景色
	-- self.layerMap = {};
	-- self.layerMap[1] = self.TiledMap:layerNamed("back1");
	-- self.layerMap[2] = self.TiledMap:layerNamed("back2");
	-- self.layerMap[3] = self.TiledMap:layerNamed("back3");

	--初始化敌方角色数据
	local pObjects=self.zhanyiView.zhanyiMap:getObjectGroup("item");--获取对象成
	local ObjectsArray=pObjects:getObjects();
	
	local sum=table.nums(ObjectsArray);
	print("================Map sum:",sum );
	self.ShowSumItem = 0;
	self.CarbonView = {};
	for i=1,sum do
		local data = pObjects:getObject("city_"..i);
		local name = data["name"] --data:valueForKey("name"):getCString();
		local x = data["x"] --data:valueForKey("x"):intValue();
		local y = data["y"] --data:valueForKey("y"):intValue();
		local groupType = data["type"] --data:valueForKey("type"):getCString();
		
		print(data,i,name,x,y,groupType);
		--得到关卡数据
		local carbonData = get_instancing_group( tonumber(groupType) );
		if carbonData then
			--判断开启状态
			if self.CurrentScheduleMark == 0 then
				if carbonData.CarbonState and carbonData.CarbonState == 1 then
					self.CurrentScheduleMark = i;
				end
			end
			--创建战场关卡
			local carbonview = self:CreateZhanyiItem( carbonData);
			self.zhanyiView.rootNode:addChild(carbonview , 2);
			carbonview:setPosition(cc.p(x, y)); -- 63 56
			-- carbonview:update( carbonData ,self.chooseIndex ,self.ShowSumItem + 1);
			self.CarbonView[i] = carbonview;
			self.ShowSumItem = self.ShowSumItem + 1;
		end
	end
	--创建当前挑战关卡
	if self.CurrentScheduleMark == 0 then
		self.CurrentScheduleMark = 1;
	end
	self:CreateZhanyiScheduleMark();
end

--创建数据
function zhanyiSystem:CreateZhanyiItem( itemData)
    local zhanyiItem = class_zhanyiitem.new();
    zhanyiItem:UpdateShowData( itemData );
    return zhanyiItem;
end

--[[创建战役进度标示
	sender 作用对象
]]
function zhanyiSystem:CreateZhanyiScheduleMark(  )
	ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("animation/zhanyi/zhanyimark.ExportJson")
    self.ScheduleMark = ccs.Armature:create("zhanyimark")
    self.ScheduleMark:getAnimation():play("Animation1")
    self.zhanyiView.rootNode:addChild(self.ScheduleMark,3)
    local bind = self.CarbonView[self.CurrentScheduleMark];
    if bind then
    	bind:setCityColor( true );
    	local x , y = bind:getPosition();
    	self.ScheduleMark:setPosition(cc.p(x ,y + 50));
    end
end


--[[创建关卡显示
	chooselevel 选择的关卡
]]
function zhanyiSystem:event_choose_zhanyi( event )
	print("zhanyiSystem:event_choose_zhanyi");
	local chooseData = event._usedata.sender.showData
	self.ChooseZhanyiData = chooseData;
	self.ChooseZhanYiItem = event._usedata.sender;
	
	self.zhanyiLevel = class_zhanyilevel.new();
	local scene = MainPageSystemInstance.scene
	scene:addChildToLayer(LAYER_ID_POPUP, self.zhanyiLevel)

	--加载地图
	local levelmap = cc.TMXTiledMap:create("map/zhanyi/"..chooseData.map_id..".tmx");
	self.zhanyiLevel.mapNode:addChild(levelmap);
	levelmap:setScaleX(1.4);
	levelmap:setScaleY(1.1);
	
	--初始化敌方角色数据
	local pObjects=levelmap:getObjectGroup("object");--获取对象成
	local ObjectsArray=pObjects:getObjects();
	
	local sum=table.nums(ObjectsArray);
	print("================Map sum:",sum );
	-- self.ShowSumItem = 0;
	self.CarbonLevelView = {};
	for i=1,sum do
		local data = pObjects:getObject("city_"..i);
		local name = data["name"];
		local x = data["x"];
		local y = data["y"];
		local groupType = data["type"];
		
		
		--得到关卡数据
		local levelData = get_instancing_level( chooseData.CarbonLevelList[i] );
		print(data,i,name,x,y,groupType,chooseData.CarbonLevelList[i]);
		if levelData then
			--判断开启状态
			-- if self.CurrentScheduleMark == 0 then
			-- 	if levelData.CarbonState and levelData.CarbonState == 1 then
			-- 		self.CurrentScheduleMark = i;
			-- 	end
			-- end
			--创建战场关卡
			local levelview = self:CreateZhanyiLevelItem( levelData);
			self.zhanyiLevel.mapNode:addChild(levelview , 2);
			levelview:setPosition(cc.p(x * 1.4, y * 1.1)); -- 63 56
			self.CarbonLevelView[i] = levelview;
			-- self.ShowSumItem = self.ShowSumItem + 1;
		end
	end

	GLOBAL_COMMON_ACTION:popupOut({node = self.zhanyiLevel});
end

--创建数据
function zhanyiSystem:CreateZhanyiLevelItem( itemData)
    local zhanyilevelItem = class_zhanyilevelitem.new();
    zhanyilevelItem:UpdateShowData( itemData );
    return zhanyilevelItem;
end

--选择战役关卡
function zhanyiSystem:event_choose_zhanyilevel( event )
	print("zhanyiSystem:event_choose_zhanyilevel")
	local chooseData = event._usedata.sender.showData
	self.ChooseZhanYiLevelItem = event._usedata.sender;
	self.zhanyilevelOperation = class_zhanyilevel_operation.new();
	self.zhanyilevelOperation:refreshShowData(chooseData);
	local scene = MainPageSystemInstance.scene
	scene:addChildToLayer(LAYER_ID_POPUP, self.zhanyilevelOperation)
end

--挑战事件
function zhanyiSystem:event_challenge( event )
	--得到挑战数据
	local chooseData = event._usedata.sender.showData;
	self.ChooseZhanyiLevelData = chooseData;
	
	--得到助阵者在阵型中的位置
	local helperpos = MAIN_PLAYER.helperManager.HelperExchangePos;
	local helperType = 0;
	local helperGUID = nil;

	--记录战斗前体力 和精力数据
	-- user.player:ExecuteRecordData(  );--执行记录数据
	if helperpos ~= 10 and MAIN_PLAYER.helperManager.ChooseHelper then
		helperType = helperpos;
		helperGUID = MAIN_PLAYER.helperManager.ChooseHelper.GUID;
		-- user.player.helperManager:removeAlreadyUse();
	end
	-- BattleManager.RecordHelperPos = helperpos;
	-- BattleManager.RecordHelperData = user.player.helperManager.ChooseHelper;

	--设置战斗记录数据
	-- Data_Battle:SetRecordValuse( "helperData" , user.player.helperManager.ChooseHelper );--助阵者数据
	Data_Battle:SetRecordValuse( "zhanyikey" , self.ChooseZhanyiData.Key );--战役key
	Data_Battle:SetRecordValuse( "zhanyilevelkey" , self.ChooseZhanyiLevelData.Key );--战役关卡key

	--设置战斗类型
	Data_Battle.BattleType = 1;

	-- print(Uniquify_Carbon.ChooseCarbonSort.Key,
	-- 	Uniquify_Carbon.ChooseCarbon.Key ,Uniquify_Carbon.chooseLevel.Key,user.player.myTeamManager.curSelTeamIdx
	-- 	,helperType,helperGUID)
	-- printInfo("数据更新日志 %s","发送心跳包:MSG_C2MS_HEARTBEAT")
	-- gameTcp:SendMessage(MSG_C2MS_HEARTBEAT )
	--发送挑战消息
	printInfo("网络日志 %s","发送开始一个副本消息：MSG_C2MS_INSTANCING_BEGIN")
	gameTcp:SendMessage(MSG_C2MS_INSTANCING_BEGIN ,{
		2, --副本种类
		self.ChooseZhanyiData.Key, -- 副本
		self.ChooseZhanyiLevelData.Key, -- 关卡
		1, --团队
		helperType,
		helperGUID,
	} )
	--开启资源加载界面
	ManagerBattle:createLoadBattleRes();
end

--挑战刷新
function zhanyiSystem:event_challenge_result( event )
	--刷新关卡数据
	if self.ChooseZhanYiLevelItem then
		self.ChooseZhanYiLevelItem:UpdateShowData( self.ChooseZhanyiLevelData );
	end
	--刷新战役数据
	if self.ChooseZhanYiItem then
		self.ChooseZhanYiItem:UpdateShowData( self.ChooseZhanyiData );
	end
end

--战役退出
function zhanyiSystem:event_exit( event )
	dispatchGlobaleEvent("controler_mainPage_ui_layer", "setUIVisible", {visibleType="showAll"})
    dispatchGlobaleEvent("controler_mainpage_top_layer", "setUIVisible", {visibleType="showAll"})

    self.zhanyiView:removeFromParent();
    --销毁资源
end


--注册关闭事件
function zhanyiSystem:remove_event(  )
	--清除事件监听
	for k,v in pairs(self.eventlisen) do
		GLOBAL_EVENT_DISPTACHER:removeEventListener(v);
	end
end

return zhanyiSystem;
