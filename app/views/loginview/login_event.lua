--
-- Author: Liyang
-- Date: 2015-06-26 17:28:09
-- 登录逻辑事件

local login_event = class("login_event")

local _classloginaccount = require("app.views.loginview.UI_LoginAccount");
local _classRegister = require("app.views.loginview.UI_Register");
function login_event:ctor(target)
	--登陆操作判断 1 正常登陆 2 账号切换 3 账号注册
	-- Logic_Operation = 1;
	self.target_ = target;

	self.registerConfig = {
		--初始化数据
		{"login","event_invidata",1},
		{"login","event_start",1},
		{"login","event_createloginview",1},
		{"login","event_loginAccount",1},
		{"login","event_loginAccountsucceed",1},
		{"login","event_createregister",1},
		{"login","event_registeraccount",1},
		{"login","event_registercancel",1},
		{"login","event_registersucceed",1},--注册成功
		{"login","event_chooseserver",1},--选择服务器
	}
end

--注册事件
function login_event:register_event(  )
	local defaultCallbacks = {
		login_event_invidata = handler(self, self.event_invidata),
        login_event_start = handler(self, self.event_login),
        login_event_createloginview = handler(self, self.event_CreateloginView),
        login_event_loginAccount = handler(self, self.event_loginAccount),
        login_event_loginAccountsucceed = handler(self, self.event_loginAccountsucceed),
        login_event_createregister = handler(self, self.event_createRegister),
        login_event_registeraccount = handler(self, self.event_registerAccount),
        login_event_registercancel = handler(self, self.event_registerCancel),
        login_event_registersucceed = handler(self, self.event_registersucceed),
        login_event_chooseserver = handler(self, self.event_chooseserver),
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

function login_event:addExecuteEvent( eventname )
	if not eventname then
		return;
	end
	for i,v in ipairs(eventname) do
		table.insert(self.registerConfig, 1, eventname)
	end
	
end

--初始化数据
function login_event:event_invidata( event )
	--数据显示
	 --执行登陆状态初始化
    if Data_Login.account and string.len(Data_Login.account) > 4 then
        self.target_.loginass:setTitleText("注销");
    else
        self.target_.loginass:setTitleText("登陆账号");
    end
    self.target_.loginass:setVisible(true);
end

--登录事件
function login_event:event_login(  )
	if Data_Login.account and string.len(Data_Login.account) > 4  then
		--创建账号登陆
	else
		self:event_CreateloginView(  );
		return;
	end
	
	if Data_Login.Logic_Operation == 2 then
		--连接游戏服务器
		Msg_Logic.ConnectMS_Logic();
	else
		-- 连接登陆服务器
		Data_Login.Logic_Operation = 1;
		Msg_Logic.ConnectLS_Logic();
	end
	--记录选择的服务
	Data_Login:RecordChooseServer(  )
	--保存数据
	Data_Login:saveToLocal();
	--创建连接等待
	UIManager:CreatePrompt_Wait({
		mark = "loginwait",
		content = "请稍等正在拼命连接中",
		})
end

--创建登录界面
function login_event:event_CreateloginView(  )
	--创建提示界面
	UIManager:CreatePrompt_Operate( {
			mark = "logoutoper",
	        title = "注销",
	        content = "\n    是否注销当前账户？",
	        listenButton = function ( result )
				if result == 1 then
					self.target_.loginass:setVisible(false);
					self.rootnode_loginaccount =_classloginaccount.new();
				    self.target_:addChildToLayer(LAYER_ID_POPUP, self.rootnode_loginaccount)
				    self.rootnode_loginaccount:setPosition(cc.p(display.cx - 640,display.cy - 360))
				end
			end
		} )

	
end

--登录账号
function login_event:event_loginAccount( event )
	print("event_loginAccount 1")
	self.account = event._usedata[1];
	self.password = event._usedata[2];
	
	--[[
		1.账号大于6，账号必须是邮箱，账号长度不能超过30
		2.密码大于6，密码不能超过20
	]]
	if self.account and (string.len(self.account) < 6 or string.len(self.account) >= 20)   then
		--账号长度大小在6~30之间
		--创建提示
		UIManager:CreatePrompt_Bar( {
			content = "账号长度大小在6~20之间",
			} )
	-- elseif not string.find(user.account,"@") then
	-- 	--不是邮箱
	-- 	self.rootNode.errorText:setString("账号必须是邮箱");
	elseif self.password and (string.len(self.password) < 6 or string.len(self.password) >= 20) then
		--密码长度大小在6~20之间
		UIManager:CreatePrompt_Bar( {
			content = "密码长度大小在6~20之间",
			} )
	else
		-- 发送验证消息
		Data_Login.Logic_Operation = 2; -- 账号切换操作
		-- self.password = crypto.md5(self.password);
		Data_Login.account = self.account;
		Data_Login.password = self.password;
		Msg_Logic.ConnectLS_Logic();
	end
end

--登陆账号成功
function login_event:event_loginAccountsucceed( event )
	--关闭登陆界面
	self.rootnode_loginaccount:removeFromParent();
	self.rootnode_loginaccount = nil;
	--更新登陆名称
	self.target_.loginass:setTitleText("注销");
	self.target_.loginass:setVisible(true);
	-- 保存账号数据
	Data_Login:saveToLocal();
end

--创建注册界面
function login_event:event_createRegister( event )
	-- if event._usedata and event._usedata.target then
	--  	event._usedata.target:removeFromParent();
	-- end 
	self.rootnode_Register =_classRegister.new();
    self.target_:addChildToLayer(LAYER_ID_POPUP, self.rootnode_Register)
    self.rootnode_Register:setPosition(cc.p(display.cx - 640,display.cy - 360))
end

--注册账户
function login_event:event_registerAccount( event )
	print("event_registerAccount 1",event._usedata)
	-- 登陆
	local account = event._usedata[1];
	local password = event._usedata[2];
	local againpassword = event._usedata[3];
	--[[
		1.账号大于6，账号必须是邮箱，账号长度不能超过30
		2.密码大于6，密码不能超过20
	]]
	if account and (string.len(account) < 6 or string.len(account) >= 20)   then
		--账号长度大小在6~30之间
		UIManager:CreatePrompt_Bar( {
			content = "账号长度大小在6~20之间",
			} )
	-- elseif not string.find(account,"@") then
	-- 	--不是邮箱
	-- 	self.rootNode.errorText:setString("账号必须是邮箱");
	elseif password and (string.len(password) < 6 or string.len(password) >= 20) then
		--密码长度大小在6~20之间
		UIManager:CreatePrompt_Bar( {
			content = "密码长度大小在6~20之间",
			} )
	elseif password ~= againpassword then
		UIManager:CreatePrompt_Bar( {
			content = "两次输入密码不一样",
			} )
	else
		-- 发送账号注册消息
		Data_Login.account = account;
		Data_Login.password = password;--crypto.md5(password);
		Data_Login.Logic_Operation = 3;--注册账户
		Msg_Logic.ConnectLS_Logic();
	end
end

--取消账户注册
function login_event:event_registerCancel( event )
	-- if event._usedata and event._usedata.target then
	--  	event._usedata.target:removeFromParent();
	-- end 
	self.rootnode_loginaccount =_classloginaccount.new();
    self.target_:addChildToLayer(LAYER_ID_POPUP, self.rootnode_loginaccount)
    self.rootnode_loginaccount:setPosition(cc.p(display.cx - 640,display.cy - 360))
end

--注册成功
function login_event:event_registersucceed( event )
	--关闭注册界面
	self.rootnode_Register:removeFromParent();
	self.rootnode_Register = nil;
	--更新登陆名称
	self.target_.loginass:setTitleText("注销");
	self.target_.loginass:setVisible(true);
	-- 保存账号数据
	Data_Login:saveToLocal();
end

--选择服务器
function login_event:event_chooseserver( event )
	--关闭选择服务器器界面
	--更新选择的服务器
	Data_Login.chooseserver = event._usedata;
	self.target_:execute_UpdateChooseServer();
end

--注册关闭事件
function login_event:remove_event(  )
	--清除事件监听
	for k,v in pairs(self.eventlisen) do
		GLOBAL_EVENT_DISPTACHER:removeEventListener(v);
	end
end

return login_event;
