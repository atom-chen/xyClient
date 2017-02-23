--
-- Author: Liyang
-- Date: 2015-06-26 17:28:09
-- 更新逻辑

local event_inithero = class("event_inithero")

function event_inithero:ctor(target)
	self.target_ = target;

	self.registerConfig = {
		{"models_inithero","create",1},--创建初始化英雄
		{"models_inithero","choosehero",1},--选择英雄
		{"models_inithero","queding",1},--确定
		{"models_inithero","updatename",1},--更新角色名称
		{"models_inithero","random_name",1},--随机名称
	}
	self.nameList = {};
end

--注册事件
function event_inithero:register_event(  )
	local defaultCallbacks = {
        models_inithero_create = handler(self, self.register_event_create),
        models_inithero_choosehero = handler(self, self.register_event_choosehero),
        models_inithero_queding = handler(self, self.register_event_queding),
        models_inithero_updatename = handler(self, self.register_event_updatename),
        models_inithero_random_name = handler(self, self.register_event_random_name),
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
	--关闭按键控制
	GLOBAL_TOUCH_CONTROL:TounchContrlScheduler(0);
	GLOBAL_TOUCH_CONTROL:TounchContrlScheduler(-10,GLOBAL_TOUCH_CONTROL.CONTROL_TYPE_FOREVER);
	--关闭超时控制
	gameTcp:CloseMsgTimeOutCheck( );
	
	self.inviHeroUI =require("app.views.inithero.UI_InviHero").new();
	self.inviHeroUI:InviHeroList(  );
    self.target_:addChildToLayer(LAYER_ID_UI, self.inviHeroUI)
    self.chooseTemple = heroShowInitialize[1];
    --请求随机名字
    self:register_event_random_name(  );
end

--选择英雄
function event_inithero:register_event_choosehero( event )
	local view = event._usedata[1];
	if self.chooseTemple == view.HeroTemple then
		return;
	end
	self.chooseTemple = view.HeroTemple;

	self.inviHeroUI:updata_choose( view  )
end

--创建角色消息
function event_inithero:register_event_queding( event )
	local intoname = event._usedata[1];
	local charLenth = string.len(intoname);
	if charLenth < 1 then
		UIManager:CreatePrompt_Bar( {
			content = "请输入角色名称",
		} )
		return;
	end
	--检查显示长度大小
  	local checkttf = cc.Label:createWithTTF(intoname,"font/simhei.ttf",20);
	local showLen = checkttf:getContentSize().width;
	print("字符长度:",showLen);
	if showLen < 120 then
		InviHeroName = intoname;
		GLOBAL_TOUCH_CONTROL:TounchContrlScheduler(1,GLOBAL_TOUCH_CONTROL.CONTROL_TYPE_FOREVER);
		--创建角色 heroInitialize
		printInfo("网络日志 %s","发送创建角色信息：MSG_C2MS_ROLE_CREATE_ROLE :"..intoname)
		gameTcp:SendMessage(MSG_C2MS_ROLE_CREATE_ROLE ,{
			self.chooseTemple,
			intoname,
		} )
	else
		UIManager:CreatePrompt_Bar( {
			content = "输入的角色名长度过长",
		} )
	end
	
end

--随机名称
function event_inithero:register_event_random_name( event )
	local count = table.nums(self.nameList)
	if count <= 0 then
		--发送消息
		printInfo("网络日志 发送随机名字消息 MSG_C2MS_ROLE_GET_RANDOM_NAME")
		gameTcp:SendMessage(MSG_C2MS_ROLE_GET_RANDOM_NAME, {10})
	else
		self:displayName();
	end
end

--更新名称
function event_inithero:register_event_updatename( event )
	local name = event._usedata[1];
	self.nameList = name;
	self:displayName();
end

function event_inithero:displayName()
	self.inviHeroUI:updata_name(self.nameList[1])
	table.remove(self.nameList, 1)
end



return event_inithero;
