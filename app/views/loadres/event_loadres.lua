--
-- Author: Liyang
-- Date: 2015-06-26 17:28:09
-- 更新逻辑

local event_inithero = class("event_inithero")

function event_inithero:ctor(target)
	self.target_ = target;

	self.registerConfig = {
		{"models_loadres","create",1},--创建加载资源
		{"models_loadres","update_logic_schedule",1},--更新逻辑进度
		{"models_loadres","finish",1},--加载完成
		-- {"models_loadres","updatename",1},--更新角色名称
		-- {"models_loadres","random_name",1},--随机名称
	}
	self.nameList = {};

	--单位长度
    self.Unit_Change_Lenth = 947 / 100;

    --当前的长度
    self.Current_Len = 0;

    AMSOUND = 0;
    
    --进度显示值
    self.schedule_Showvaluse = 1;

    --当前资源加载逻辑进度
    self.schedule_Logicvaluse = 1;

    self.executeRun = 0;

    --单位改变值
    self.Unit_Change = 0.3;

    --进度条改变时间
    self.ActionTime = 0.2;
   
end

--注册事件
function event_inithero:register_event(  )
	local defaultCallbacks = {
        models_loadres_create = handler(self, self.register_event_create),
        models_loadres_update_logic_schedule = handler(self, self.register_event_update_logic_schedule),
        models_loadres_finish = handler(self, self.register_event_finish),
        -- models_loadres_updatename = handler(self, self.register_event_updatename),
        -- models_loadres_random_name = handler(self, self.register_event_random_name),
    }
    self.eventlisen = {};
    --createGlobalEventListener( modelName, eventName, callBack, fixedPriority )
	for i,v in ipairs(self.registerConfig) do
		local eventname = createGlobaleEventName( v[1], v[2] )
		if defaultCallbacks[eventname] then
			self.eventlisen[eventname] = createGlobalEventListener( v[1], v[2], defaultCallbacks[eventname], v[3] )
		end
	end
end

function event_inithero:addExecuteEvent( eventname )
	if not eventname then
		return;
	end
	for i,v in ipairs(eventname) do
		table.insert(self.registerConfig, 1, eventname)
	end
	
end

--关闭事件
function event_inithero:register_event_close(  )
	printInfo("register_event_close %s", "event")
	--清除事件监听
	for k,v in pairs(self.eventlisen) do
		GLOBAL_EVENT_DISPTACHER:removeEventListener(v);
	end
	--执行完成回调
	if self.target_.ShowData.fininshCallBack then
		self.target_.ShowData.fininshCallBack();
	end
	self.target_:removeFromParent();
end

--[[检查结果处理
	0 更新失败
	1 更新成功
	2 下载进度提示
	3 更新文件大小
]]
function event_inithero:register_event_create( event )
    --back
    -- local backImage = cc.Sprite:create("ui_image/login/login_back.jpg");
    -- backImage:setPosition(cc.p(display.cx,display.cy));
    -- self.target_ :addChildToLayer(LAYER_ID_UI, backImage,0)

    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("animation/login/login_e_title_1.ExportJson")

    self.titleView = ccs.Armature:create("login_e_title_1");
    self.titleView:setPosition(cc.p(display.cx,display.cy));
    self.target_ :addChildToLayer(LAYER_ID_UI, self.titleView,1)
    self.titleView:getAnimation():play("Animation2" , -1 ,-1);

	self.loadview = cc.CSLoader:createNode("ui_instance/load/loadview.csb")
	self.loadview:setPosition(cc.p(display.cx,200));
    self.target_ :addChildToLayer(LAYER_ID_UI, self.loadview,1)

    self.loadBar = self.loadview:getChildByName("LoadingBar");

    self.loadview:scheduleUpdateWithPriorityLua(handler(self, self.updateUI),1);
    --请求其他数据
    self:requestMsgData(  );
end

--更新逻辑进度值
function event_inithero:register_event_update_logic_schedule( event )
	self.schedule_Logicvaluse = event._usedata[1];
	--执行进度更新
	self.executeRun = 1;
	self:SetRunConfig( self.schedule_Logicvaluse );
end

--加载完成
function event_inithero:register_event_finish( event )
    print("加载完成")
    self.loadview:unscheduleUpdate();
    --加载完成
    APP:toScene(SCENE_ID_GAMEWORLD);
end

--更新进入
function event_inithero:updateUI( time )
	if self.schedule_Showvaluse >= 100 then
        self:register_event_finish(  );
        return;
	end
	--标示进度
	if self.executeRun == 0 then
		return;	
	end

    print(self.schedule_Showvaluse,time,self.Unit_Change,self.ActionTime)
    --进度条长度设置
    self.schedule_Showvaluse = self.schedule_Showvaluse + time / self.ActionTime * self.Unit_Change;

    self:SetGamePercentage(self.schedule_Showvaluse);

    if self.schedule_Showvaluse > self.schedule_Logicvaluse then
    	self.executeRun = 0;
        --执行下一个
        self:excuteLoadListLogic(  );
    end
  
end

--加载列表萝莉
function event_inithero:excuteLoadListLogic(  )
    --数据接收完成 50 ;
    if self.schedule_Logicvaluse == 50 then
        self:LoadGameRes(  );
    end
end

--请求数据
function event_inithero:requestMsgData(  )
    --得到其他数据
    Msg_Logic.requestData();
end

function event_inithero:LoadGameRes(  )
	ResLoad:setLoadList(
        {
            "icon/heros.png",
            "icon/skills.png",
            -- "ui_image/mainpage/anim/zhanyi/zy2/effect_zhanyi2.png",
            -- "ui_image/mainpage/anim/zhanyi/zy2/zhanyi2_mengban.png",
            -- "ui_image/mainpage/anim/zhanyi/zy3/effect_zhanyi3.png",
            -- "ui_image/mainpage/anim/zhanyi/zy3/effect_zhanyi3_mengban.png"
        }
    )
    ResLoad:LoadRes()
    dispatchGlobaleEvent( "models_loadres" ,"update_logic_schedule",{100});
end

--设置进度运行的参数
function event_inithero:SetRunConfig( valuse)
    self.Unit_Change = valuse - self.schedule_Showvaluse;
end

--设置游戏进度值
function event_inithero:SetGamePercentage( value )
    print(value)
	self.loadBar:setPercent(value)
end



return event_inithero;
