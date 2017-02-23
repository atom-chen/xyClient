--
-- Author: 游戏数据操作管理
-- Date: 2015-06-26 17:47:00
-- 登录数据

local model_Login = class("model_user")

model_Login.GameSaveKey = {
	KEY_LOGIN_ACCOUNT = "key_login_account",
	KEY_LOGIN_PASSWORD = "key_login_password",
	KEY_LOGIN_TOKEN = "key_login_token",
	KEY_LOGIN_FIGURE_ID = "key_login_figure_id",
	KEY_LOGIN_CHOOSE_SERVER = "key_login_choose_server",
	KEY_STATE_SOUND = "key_state_sound",
	KEY_STATE_MUSIC = "key_state_music",
	KEY_GSERVER = "key_recover_server",
}

function model_Login:ctor()
	--保存数据池
	self.SaveDataList = {};

	--登录IP
	self.LS_IP = "120.55.98.203";
	--登录端口
	self.LS_PORT = 10000;

	--登陆操作判断 1 正常登陆 2 账号切换 3 账号注册
	self.Logic_Operation = 1;

	--服务器列表信息
	self.ServerList = {
		[1] = {name = "一区 乱世天下" ,IP="120.55.98.203",Port=12000,state = 4,id=10000,},
	};
	self.chooseserver = 1;

	self.account = "";
	self.password = "";

	self.userID = "";
	self.token = "";
	--账户登录方式
	self.login_type = 0;
	--判断是否是重连状态
	self.ResumeConnect = false;

	--服务器显示类型 1 内网 2 外网
	self.ServerShowType = 1

	self.CurrentVersion = "";
end

function model_Login.getInstance()
	if model_Login.instance == nil then
		model_Login.instance = model_Login.new()
	end
	return model_Login.instance
end

--初始化数据
function model_Login:InviData()
	--读取数据
	self:LoadGameData(  );
	--初始化服务器列表
	UpDataMsLogic( self.ServerShowType );
	for i,v in ipairs(GAME_SERVER_LIST) do
		self.ServerList[i] = v;
	end
	--登陆服务器IP
	self.LS_IP = LS_IP;
	--登陆服务器端口
	self.LS_PORT = LS_PORT;

	--读取存储数据
	self.account = self.SaveDataList[self.GameSaveKey.KEY_LOGIN_ACCOUNT];
	self.password = self.SaveDataList[self.GameSaveKey.KEY_LOGIN_PASSWORD];
	self.chooseserver = self.SaveDataList[self.GameSaveKey.KEY_LOGIN_CHOOSE_SERVER] or 1;
	self.CurrentVersion = GAME_VERSION_INFO_NAME.."."..GAME_CURRENT_VERSION_INFO_NAME;
	print("model_Login:InviData",self.LS_IP,self.LS_PORT,self.account,self.password,self.CurrentVersion)
end


--保存用户数据
function model_Login:saveToLocal()
	--保存账号、密码等
	-- self.SaveDataList[self.GameSaveKey.KEY_LOGIN_ACCOUNT] = user.account;
	-- self.SaveDataList[self.GameSaveKey.KEY_LOGIN_PASSWORD] = user.password;
	-- --保存选择的区
	-- self.SaveDataList[self.GameSaveKey.KEY_LOGIN_CHOOSE_SERVER] = user.chooseserver;
	-- self.SaveDataList[self.GameSaveKey.KEY_STATE_SOUND] = AMSOUND
	-- self.SaveDataList[self.GameSaveKey.KEY_STATE_MUSIC] = AMMUSIC
	-- self.SaveDataList[self.GameSaveKey.KEY_GSERVER.."1"] = RECOVERY_SERVER_LIST[1]
	-- self.SaveDataList[self.GameSaveKey.KEY_GSERVER.."2"] = RECOVERY_SERVER_LIST[2]
	-- self.SaveDataList[self.GameSaveKey.KEY_GSERVER.."3"] = RECOVERY_SERVER_LIST[3]
	print(self.SaveDataList,self.GameSaveKey.KEY_LOGIN_ACCOUNT,self.GameSaveKey.KEY_LOGIN_PASSWORD)
	self.SaveDataList[self.GameSaveKey.KEY_LOGIN_ACCOUNT] = self.account;
	self.SaveDataList[self.GameSaveKey.KEY_LOGIN_PASSWORD] = self.password;
	self.SaveDataList[self.GameSaveKey.KEY_LOGIN_CHOOSE_SERVER] = self.chooseserver;
	local savestring = serialize(self.SaveDataList)
	cc.UserDefault:getInstance():setStringForKey("gamesavedata", savestring);
end

function model_Login:LoadGameData(  )
	
	local datastr = cc.UserDefault:getInstance():getStringForKey("gamesavedata");
	self.SaveDataList = unserialize(datastr);
	if not self.SaveDataList  then
		self.SaveDataList = {};
	end
	for k,v in pairs(self.SaveDataList) do
		printInfo("saveData:%s %s",k,v)
	end
end

--记录选择的服务器
function model_Login:RecordChooseServer(  )
	if not self.SaveDataList[self.GameSaveKey.KEY_GSERVER] then
		self.SaveDataList[self.GameSaveKey.KEY_GSERVER] = {};
	end
	local RecordData = self.SaveDataList[self.GameSaveKey.KEY_GSERVER];
	--记录选择的服务
	for i=1,3 do
		if RecordData[i] == self.chooseserver then
			table.remove(RecordData, i)
			break
		end
	end
	table.insert(RecordData, 1, self.chooseserver)
end

--得到选择服务器信息
function model_Login:getChooseServerData(  )
	local data = self.ServerList[self.chooseserver]
	if not data then
		printInfo("ChooseServerData nil");
	end
	return data.IP ,data.Port;
end

--得到选择服务器信息
function model_Login:getChooseServerDescribe(  )

	local data = self.ServerList[self.chooseserver]
	
	return data;
end

--得到服务器选择的颜色值
function model_Login:getServerStateColour( state )
	local statevaluse = "server_state_"..state;
	return GLOBAL_COLOUR_VALUSE[statevaluse];
end


Data_Login = model_Login.getInstance();

return model_Login;