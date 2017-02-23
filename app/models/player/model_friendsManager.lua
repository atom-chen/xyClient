--
-- Author: li Yang
-- Date: 2014-04-08 14:35:59
-- 好友管理

local model_friendsManager = class("model_friendsManager")

--[[发送全局事件名预览
eventModleName: model_goodsManager
eventName: 
	openfriends -- 打开好友界面
]]

--[[监听全局事件名预览
eventModleName: netMsg
eventName:
	tostring(MSG_MS2C_APPLICANT_DATA) -- 获得请求中的好友数据
	tostring(MSG_MS2C_FRIEND_AGREE_RESULT) -- 操作好友请求回复消息
	tostring(MSG_MS2C_FRIEND_DEL_RESULT) -- 删除好友
]]
function model_friendsManager:ctor()
	self.friendsPool = {};

	-- 记录池
	self.recordPool = {};

	--好友验证池
	self.verifyPool = {};

	-- 好友是否更新
	self.IsFriendsUpData = false;

	-- 记录池是否更新
	self.IsFriendsRecordUpData = false;

	-- 好友数量
	self.FriendsNum = 0;

	--好友验证数量
	self.FriendsVerifyNum = 0;

	--已赠送体力好友列表
	self.SendEngList = {};

	--已接收体力好友列表
	self.ReceiveEngList = {};

	--接收体力数量
	self.ReceiveNum = 0;

	--在线好友数量
	self.OnlineNum = 0;
	--领取体力次数
	self.getVigorTime = 30;

	self:_registGlobalEventListeners()
end

function model_friendsManager:_registGlobalEventListeners()
	self._globalEventListeners = {}
	local configs = {
		{modelName = "netMsg", eventName = tostring(MSG_MS2C_APPLICANT_DATA), callBack=handler(self, self._onMSG_MS2C_APPLICANT_DATA)},
		{modelName = "netMsg", eventName = tostring(MSG_MS2C_FRIEND_AGREE_RESULT), callBack=handler(self, self._onMSG_MS2C_FRIEND_AGREE_RESULT)},
		{modelName = "netMsg", eventName = tostring(MSG_MS2C_FRIEND_DEL_RESULT), callBack=handler(self, self._onMSG_MS2C_FRIEND_DEL_RESULT)},
	}
	self._globalEventListeners = createGlobalEventListenerWithConfig(configs)
end


--[[ 添加好友

]]
function model_friendsManager:addFriends( params )
	print("添加好友：",params.GUID)
	self.friendsPool[params.GUID] = params;
end

--添加验证好友
function model_friendsManager:addVerifyFriends( params )
	self.verifyPool[params.GUID] = params;
end

--添加推荐好友
function model_friendsManager:addRecommendFriends( params )
	self.recordPool[params] = params;
end

function model_friendsManager:getFriendsDataByGUID( guid )
	return self.friendsPool[guid];
end

--检查好友
function model_friendsManager:checkFriendsByGUID( guid )
	if self.friendsPool[guid] then
		return true;
	end
	return false;
end

--检查记录推荐好友
function model_friendsManager:checkRecordFriendsByGUID( guid )
	if self.recordPool[guid] then
		return true;
	end
	return false;
end

--[[查找好友
	type 类型 1(通过送体力)
	return 数量 和 数据table
]]
function model_friendsManager:seekFriendsBySort( type )
	local seekData = {};
	local pos = 1;
	-- 首先检验送自己体力的好友
	-- for k,v in pairs(self.friendsPool) do
	-- 	if v.mark_Stamina_get == 1 then
	-- 		seekData[pos] = v;
	-- 		v = v + 1;
	-- 	elseif conditions then
	-- 		--todo
	-- 	end
	-- end
end

--添加好友时重置好友发送标记
-- function model_friendsManager:resetStaminaSendMark( guid )
-- 	if self.SendEngList[guid] and self.SendEngList[guid] == 1 then
-- 		self.friendsPool[guid].mark_Stamina_send = 1;
-- 		return;
-- 	end
-- 	self.friendsPool[guid].mark_Stamina_send = 0;
-- end

-- --[[得到是否可以接收体力标示
-- 	return 0 不能 1 能 2 已接收
-- ]]
-- function model_friendsManager:getFriendsStaminaGetMark( guid )
-- 	if self.ReceiveEngList[guid] and self.ReceiveEngList[guid] ==1 then
-- 		return 0;
-- 	end
-- 	return 0;
-- end

--重置好友接收标示
function model_friendsManager:resetStamina_Receive_Mark( guid )
	if self.ReceiveEngList[guid] and self.ReceiveEngList[guid] == 1 then
		self.friendsPool[guid].mark_Stamina_get = 2;
	else
		self.friendsPool[guid].mark_Stamina_get = 1;
	end
end

--[[更改好友的赠送标示
	guid 好友guid
	mark 赠送标示
]]
function model_friendsManager:UpDataMark_Stamina_send( guid , mark)
	self.SendEngList[guid] = mark;
	if self.friendsPool[guid] then
		self.friendsPool[guid].mark_Stamina_send = mark;
	end
end

--[[更改好友的接收标示
	guid 好友guid
	mark 接受标示 0 没有 1 已送没接收 2 已经接收
]]
function model_friendsManager:UpDataMark_Stamina_Receive( guid , mark)
	if mark == 2 then
		self.ReceiveEngList[guid] = 1;
	end
	if self.friendsPool[guid] then
		self.friendsPool[guid].mark_Stamina_get = mark;
	end
end

--删除好友
function model_friendsManager:RemoveFriends( guid )
	self.friendsPool[guid] = nil;
end

function model_friendsManager:RemoveVerifyFriends( guid )
	self.verifyPool[guid] = nil;
end 

function model_friendsManager:ClearFriendsVerifyPool( )
	self.verifyPool = {};
end

function model_friendsManager:ClearFriendsPool( )
	self.friendsPool = {};
end

function model_friendsManager:getFriendsPoolByGuid(guid)
	return self.friendsPool[guid]
end

function model_friendsManager:_onMSG_MS2C_APPLICANT_DATA()
	-- body
	dispatchGlobaleEvent("model_friendsManager", "openfriends")
end

function model_friendsManager:_onMSG_MS2C_FRIEND_AGREE_RESULT()
	-- body
	dispatchGlobaleEvent("model_friendsManager", "refreshinvite")
end

function model_friendsManager:_onMSG_MS2C_FRIEND_DEL_RESULT()
	-- body
	dispatchGlobaleEvent("model_friendsManager", "refreshfriends")
end

return model_friendsManager;
