--
-- Author: Liyang
-- Date: 2015-06-26 17:28:09
-- 战斗系统 Ui界面

--[[发送全局事件名预览
eventModleName: zhanyi_ctrl -- 战役界面内部控制
eventName: 
	choose_zhanyi 选择战役
	zhanyi_ctrl_choose_zhanyilevel 选择战役关卡
	zhanyi_ctrl_zhanyilevel_refresh 战役关卡刷新
]]

--[[监听全局事件名预览
eventModleName: battlefield
eventName:
	ui_initialize --战斗初始化界面
	create_result -- 创建战斗结果

]]

local control_zhandouui = class("control_zhandouui")

local class_result = import(".ui.UI_BattleResult")

--信息显示

--挂机结果
local class_result_onhook = import(".ui.UI_BattleResult_Onhook")

function control_zhandouui:ctor(target)

	self.target_ = target;

	self.registerConfig = {
		--初始化数据
		{"battlefield","ui_initialize",1},
		{"battlefield","create_result",1},--创建战斗结果
		{"battlefield","exit",1},--退出战斗界面

		{"battlefieldui","updata_bout",1},--更新战场回合数
		{"battlefieldui","updata_info",1},--更新战场信息
	}
	self:register_event();

	self.CurrentScheduleMark = 0;

end

--注册事件
function control_zhandouui:register_event(  )
	local defaultCallbacks = {
		battlefield_ui_initialize = handler(self, self.event_create),
		battlefield_create_result = handler(self, self.event_create_result),
		battlefield_exit = handler(self, self.event_exit),

		battlefieldui_updata_bout = handler(self, self.event_updata_bout),
		battlefieldui_updata_info = handler(self, self.event_updata_info),
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

function control_zhandouui:addExecuteEvent( eventname )
	if not eventname then
		return;
	end
	for i,v in ipairs(eventname) do
		table.insert(self.registerConfig, 1, eventname)
	end
	
end

--初始化数据
function control_zhandouui:event_create( event )
	--战斗关卡信息
	self.ui_fightInfo = createViewWithCSB("ui_instance/battlefield/battle_ui_info.csb");
	self.info_des = self.ui_fightInfo:getChildByName("back"):getChildByName("Text_1");
	self.ui_fightInfo:setPosition(cc.p( -display.width / 2, display.height / 2));
	--添加到显示界面
	dispatchGlobaleEvent( "battleshowlayer" ,"event_addshowobject" ,{self.ui_fightInfo, 4 ,1});
	--战斗回合信息
	self.ui_fightBout = createViewWithCSB("ui_instance/battlefield/battle_ui_bout.csb");
	self.ui_fightBout:setPosition(cc.p( 0, display.height / 2));

	self.info_bout = self.ui_fightBout:getChildByName("main_layout"):getChildByName("bout");
	--添加到显示界面
	dispatchGlobaleEvent( "battleshowlayer" ,"event_addshowobject" ,{self.ui_fightBout, 4 ,1});
end



--[[创建战斗结果显示

]]
function control_zhandouui:event_create_result( event )
	--类型
	local battletype = event._usedata[1];
	--结果数据
	local resultData = event._usedata[2]
	print("control_zhandouui:event_create_result",battletype)
	if battletype == Data_Battle.CONST_BATTLE_TYPE_ONHOOK then
		self.zhandouResult = class_result_onhook.new();
		--设置结果数据
		self.zhandouResult:refreshView( resultData );
		self.zhandouResult:setPosition(cc.p(-640 ,-360))
		--设置战斗结果效果
		-- APP:getCurScene():addChildToLayer(LAYER_ID_NOTICE, self.zhandouResult)
		dispatchGlobaleEvent( "battleshowlayer" ,"event_addshowobject" ,{self.zhandouResult, 4 ,0});
		GLOBAL_COMMON_ACTION:popupOut({node = self.zhandouResult.rootNode,
				shadowNode = self.zhandouResult.shadowNode,
			});
	elseif battletype == Data_Battle.CONST_BATTLE_TYPE_BOSS then
		--todo
		local view = class_result.new(resultData);
		--设置结果数据
		--设置战斗结果效果
		APP:getCurScene():addChildToLayer(LAYER_ID_NOTICE, view)
		GLOBAL_COMMON_ACTION:popupOut({node = view.rootNode,
				shadowNode = view.shadowNode,
			});

		--重新恢复挂机
		dispatchGlobaleEvent( "challengeboss" ,"over");

	elseif battletype == Data_Battle.CONST_BATTLE_TYPE_QIYU then

		UIManager:QiyuDisplay()
		print("重新恢复挂机")
		dispatchGlobaleEvent( "qiyu" ,"over");
	end
	
end

function control_zhandouui:event_exit( event )
	if self.zhandouResult then
		self.zhandouResult:removeFromParent();
	end
	self.zhandouResult = nil;
	-- self:remove_event();
end

--更新回合数
function control_zhandouui:event_updata_bout( event )
	local bout = event._usedata[1];
	self.info_bout:setString(bout);
end

--更新描述信息
function control_zhandouui:event_updata_info( event )
	local des = event._usedata[1];
	self.info_des:setString(des);
end

----------------------------一些逻辑事件---------------------------

--创建boss挑战Ui
function control_zhandouui:CreateBattleUI_Boss(  )
	--隐藏挂机UI
	--添加关闭ui
	self.boss_CloseButton = createViewWithCSB("ui_instance/battlefield/battle_ui_close.csb");
	-- self.info_des = self.ui_fightInfo:getChildByName("back"):getChildByName("Text_1");
	self.boss_CloseButton:setPosition(cc.p( display.width / 2 - 50, -display.height / 2 + 50));
	--添加到显示界面
	dispatchGlobaleEvent( "battleshowlayer" ,"event_addshowobject" ,{self.boss_CloseButton, 4 ,1});

	--注册事件 close
	local buttonclose = self.boss_CloseButton:getChildByName("close");
	local function exitClicked(sender)
        print("退出战斗 隐藏战斗")
        dispatchGlobaleEvent( "battleshowlayer" ,"event_hide" );
    end
    buttonclose:addClickEventListener(exitClicked)
end

function control_zhandouui:CloseBattleUI_Boss(  )
	self.boss_CloseButton:removeFromParent();
end


--注册关闭事件
function control_zhandouui:remove_event(  )
	--清除事件监听
	for k,v in pairs(self.eventlisen) do
		GLOBAL_EVENT_DISPTACHER:removeEventListener(v);
	end
end

function control_zhandouui:getInstance(  )
    if control_zhandouui.instance == nil then
        control_zhandouui.instance = control_zhandouui.new()
    end
    return control_zhandouui.instance
end

Control_BattleUI= control_zhandouui.getInstance( );

return control_zhandouui;
