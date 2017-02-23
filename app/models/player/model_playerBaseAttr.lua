--
-- Author: lipeng
-- Date: 2015-07-01 13:58:16
-- 玩家基本属性

local model_playerBaseAttr = class("model_playerBaseAttr")

--[[发送全局事件名预览
eventModleName: model_playerBaseAttr
eventName: 
	nameChange --玩家名字改变
	goldChange --银两改变
	yuanBaoChange --元宝改变
	tiLiChange --体力改变
	jingLiChange --精力改变
	expChange  --经验改变
	vipLvChange --VIP等级改变
]]

--[[监听全局事件名预览
eventModleName: netMsg
eventName:
	tostring(MSG_MS2C_ROLE_UPDATA_GOLD)
]]


function model_playerBaseAttr:ctor()
	self._name = ""
	self._tiLi = 0 --体力
	self._jingLi = 0 --精力
	self._name = "" --名字
	self._gold = 0 --银两
	self._yuanBao = 0 --元宝
	self._exp = 0 --当前经验
	self._vipLv = 0 --vip等级
	self._guid = "" --guid
	self._numID = 1 --数字id
	self._jianghun = 1 --将魂
	self._jingyanchi = 0 --存储武将经验的经验池
	self._lv = 0 -- 角色等级
	self._Title = 0 -- 角色爵位
	self._TitleExp = 0 -- 角色爵位经验
	self._AtkTime = 0 -- 进攻次数
	self._AtkTimeBuy = 0 -- 购买进攻次数
	self._ronglianzhi = 0 -- 熔炼值

	self:_registGlobalEventListeners()
end

function model_playerBaseAttr:setGUID( guid )
	self._guid = guid
end

function model_playerBaseAttr:getGUID()
	return self._guid
end


function model_playerBaseAttr:getLv()
	return self._lv
end

function model_playerBaseAttr:setName( name )
	self._name = name
	dispatchGlobaleEvent("model_playerBaseAttr", "nameChange", {name=self._name})
end

function model_playerBaseAttr:getName()
	return self._name
end

function model_playerBaseAttr:setGold( gold )
	self._gold = gold
	dispatchGlobaleEvent("model_playerBaseAttr", "goldChange", {gold=self._gold})
end

function model_playerBaseAttr:getGold()
	return self._gold
end


function model_playerBaseAttr:setYuanBao( yuanBao )
	self._yuanBao = yuanBao
	dispatchGlobaleEvent("model_playerBaseAttr", "yuanBaoChange", {yuanBao=self._yuanBao})
end

function model_playerBaseAttr:getYuanBao()
	return self._yuanBao
end

function model_playerBaseAttr:setTili( tiLi )
	self._tiLi = tiLi
	dispatchGlobaleEvent("model_playerBaseAttr", "tiLiChange", {tiLi=self._tiLi, maxTiLi=100})
end

function model_playerBaseAttr:getTili()
	return self._tiLi
end

--获取体力上限
function model_playerBaseAttr:getTiliMax()
	return 100
end


function model_playerBaseAttr:setJingLi( jingLi )
	self._jingLi = jingLi
	dispatchGlobaleEvent("model_playerBaseAttr", "jingLiChange", {jingLi=self._jingLi, maxJingLi=100})
end

function model_playerBaseAttr:getJingLi()
	return self._jingLi
end

--获取精力上限
function model_playerBaseAttr:getJingLiMax()
	return 100
end

function model_playerBaseAttr:setExp( exp )
	self._exp = exp
	dispatchGlobaleEvent("model_playerBaseAttr", "expChange", {exp=self._exp, lvUpNeedExp=self:getLvUpNeedExp()})
end

function model_playerBaseAttr:getExp()
	return self._exp
end

--获取当前等级升级所需经验(不算已有经验)
function model_playerBaseAttr:getLvUpNeedExp()
	return Player_GetNeedExp(self._lv)
end

--获取到下一级需要经验(当前级需要经验 - 已有经验)
function model_playerBaseAttr:getToNextLvNeedExp()
	return self:getLvUpNeedExp() - self:getExp()
end

function model_playerBaseAttr:setVIPLv( vipLv )
	self._vipLv = vipLv
	dispatchGlobaleEvent("model_playerBaseAttr", "vipLvChange", {vipLv=self._vipLv})
end

function model_playerBaseAttr:getVIPLv()
	return self._vipLv
end

function model_playerBaseAttr:setJingyanchi( jingyanchi )
	self._jingyanchi = jingyanchi
	dispatchGlobaleEvent("model_playerBaseAttr", "jingyanchiChangejingyanchiChange", {jingyanchi=self._jingyanchi})
end

function model_playerBaseAttr:setJianghun( jianghun )
	self._jianghun = jianghun
	dispatchGlobaleEvent("model_playerBaseAttr", "jianghunChange", {jingyanchi=self._jianghun})
end

function model_playerBaseAttr:getJianghun()
	return self._jianghun
end

function model_playerBaseAttr:setLevel( level )
	self._lv = level
	dispatchGlobaleEvent("model_playerBaseAttr", "levelChange", {lv=self._lv})
end


function model_playerBaseAttr:isVIP()
	return self._vipLv > 0
end

--检查属性值是否足够
function model_playerBaseAttr:checkeAttrEnough( attrtype , valuse )
	local currentvaluse = 0;
	if attrtype == "体力" then
		currentvaluse = self._tiLi
	elseif conditions then
		--todo
	else
		--todo
	end
	if currentvaluse < valuse then
		return false;
	end
	return true;
end

--注册全局事件监听器
function model_playerBaseAttr:_registGlobalEventListeners()
	self._globalEventListeners = {}
	local configs = {
		{modelName = "netMsg", eventName = tostring(MSG_MS2C_ROLE_UPDATA_GOLD), callBack=handler(self, self._onMSG_MS2C_ROLE_UPDATA_GOLD)},
		{modelName = "netMsg", eventName = tostring(MSG_MS2C_ROLE_UPDATA_HERO_EXP), callBack=handler(self, self._onMSG_MS2C_ROLE_UPDATA_HERO_EXP)},
		{modelName = "netMsg", eventName = tostring(MSG_MS2C_ROLE_UPDATA_YUANBAO), callBack=handler(self, self._onMSG_MS2C_ROLE_UPDATA_YUANBAO)},
		{modelName = "netMsg", eventName = tostring(MSG_MS2C_ROLE_UPDATA_HERO_SOUL), callBack=handler(self, self._onMSG_MS2C_ROLE_UPDATA_HERO_SOUL)},
		{modelName = "netMsg", eventName = tostring(MSG_MS2C_ROLE_UPDATA_LEVEL), callBack=handler(self, self._onMSG_MS2C_ROLE_UPDATA_LEVEL)},
	}
	self._globalEventListeners = createGlobalEventListenerWithConfig(configs)
end


function model_playerBaseAttr:_onMSG_MS2C_ROLE_UPDATA_GOLD( event )
	local eventUseData = event._usedata.msgData
	self:setGold(eventUseData.gold)
end

function model_playerBaseAttr:_onMSG_MS2C_ROLE_UPDATA_YUANBAO( event )
	-- body
	local yuanbao = event._usedata.msgData
	self:setYuanBao(yuanbao)
end

function model_playerBaseAttr:_onMSG_MS2C_ROLE_UPDATA_HERO_EXP( event )
	-- body
	local jingyanchi = event._usedata.msgData
	self:setJingyanchi(jingyanchi)
end

function model_playerBaseAttr:_onMSG_MS2C_ROLE_UPDATA_HERO_SOUL( event )
	-- body
	local jianghun = event._usedata.msgData
	self:setJianghun(jianghun)
end

function model_playerBaseAttr:_onMSG_MS2C_ROLE_UPDATA_LEVEL( event )
	-- body
	local level = event._usedata.msgData
	self:setLevel(level)
end

--获取基本的每日进攻次数
function model_playerBaseAttr:getBaseAtkTime()
	local config = GetVipCfg(self:getVIPLv())
	return config.every_day.map_war_play_num 
end


--获取剩余进攻次数
function model_playerBaseAttr:getAtkRemainTime()
	--基本进攻次数 + 已购买次数 - 已经进攻次数
	return self:getBaseAtkTime() + self._AtkTimeBuy - self._AtkTime
end


--获取爵位
function model_playerBaseAttr:getTitle()
	return self._Title
end


--获取爵位图标
function model_playerBaseAttr:getTitleIcon()
	return string.format("icon/juewei/jw%d.png", self:getTitle())
end


--获取熔炼值
function model_playerBaseAttr:getRongLianZhi()
	return self._ronglianzhi
end


return model_playerBaseAttr

