--
-- Author: Li Yang
-- Date: 2014-10-15 10:18:37
-- 英雄资源释放管理

ManagerHeroRes = {};

ManagerHeroRes.HeroRes = {};--战斗资源容器

--英雄资源使用优先级(从低 -- 到高)
--[[
	1. 临时使用(包括 战斗使用 ，图鉴观看 ，查看其它角色英雄使用)
	2. 玩家拥有的英雄
	3. 队伍英雄
]]
ManagerHeroRes.CONST_HERORES_PRIORITY_1 = 1;


------------------------------资源释放管理--------------------------------
--[[规则
	1.临时资源设置上限，没有达到上限不会释放资源
	2.临时资源设置保留最短时间，在最短时间内不会释放
	3.设置有最小临时资源使用保留机制，即在最小保留数目内的临时资源不会被释放
	4.设置强制保留机制,在强制保留状态下临时资源部不会被释放(比如，抽奖和战斗都是强制保护状态)
]]
--临时英雄释放的峰值
ManagerHeroRes.ReleasePeak = 5;

--资源释放检测开关 
ManagerHeroRes.ReleaseSwitch = true;

--临时资源保留时间
ManagerHeroRes.CONST_RETAINTIME = 60;

--最后保留的资源ID
ManagerHeroRes.LoadLastResID = 0;

--最小保留资源数目
ManagerHeroRes.Min_Retain = 2;

ManagerHeroRes.ListPos = ManagerHeroRes.Min_Retain;

--最后的保留列表
ManagerHeroRes.LstRetainList = {};

ManagerHeroRes.SumRes = 0;

ManagerHeroRes.TempRes = 0;

--添加英雄保留列表
function ManagerHeroRes:addHeroResRetainList( heroResID )
	self.LstRetainList[self.ListPos] = heroResID;
	self.ListPos = self.ListPos - 1;
	if self.ListPos < 1 then
		self.ListPos = self.Min_Retain;
	end
	print("HeroRes", "更新保留影英雄资源:"..heroResID);
end

--是否是保留影响资源
function ManagerHeroRes:IsRetainHeroRes( heroResID )
	for i,v in ipairs(self.LstRetainList) do
		if v and v == heroResID then
			return true;
		end
	end
	return false;
end

--清空英雄保留资源
function ManagerHeroRes:ClearRetainHeroRes(  )
	for i,v in ipairs(self.LstRetainList) do
		if v and v == heroResID then
			self.LstRetainList[i] = 0;
		end
	end
	self.ListPos = self.Min_Retain;
end

------------------------------------------------------------

--[[添加英雄资源ID通过英雄ID
	heroID 英雄ID
	Priority 资源等级
	isLoad 是否加载
	direction 资源方向(1 正面 2 背面)
]]
function ManagerHeroRes:AddHeroResByHeroID( heroID, Priority ,isLoad ,direction)
	local heroConfig = GetHeroTemplate( heroID );
	if not heroConfig then
		logPrint("HeroRes", "添加的英雄资源为nil:"..heroID)
		return;
	end
	--得到英雄资源信息
	local heroresInfo = getFrameShowData( heroConfig.bigID );
	if heroresInfo == nil then
		logPrint("HeroRes", "添加的英雄资源ID为nil:"..heroID)
		return;
	end
	--得到资源编号
	local resindex = heroresInfo.defendfigure;
	if direction == 1 then
		resindex = heroresInfo.attackfigure;
	end
	self:AddHeroRes( {
			HeroResID = resindex,--英雄资源ID
			Priority = Priority or 1,--优先级
			IsLoad = isLoad or false,--是否加载
			Direction = direction or -1,--资源方向
		} )
end

--[[ 添加英雄资源
	params = {
		".plist",--plist图片
		".png",--图片资源
		1,--当前的优先级
	},
	parame = {
		HeroResID = 10003,--英雄资源ID
		Priority = 1,--优先级
		IsLoad = false,--是否加载
		Direction = -1,--资源方向
	}
]]
function ManagerHeroRes:AddHeroRes( params )
	
	print("添加英雄资源:",params.HeroResID)
	if self.HeroRes[params.HeroResID] then
		--优先级判断
		if params.Priority > self.HeroRes[params.HeroResID].Priority then
			self.HeroRes[params.HeroResID].Priority = params.Priority;
		end
		--判断是否加载
		if (not self.HeroRes[params.HeroResID].IsLoad) and params.IsLoad then
			self.HeroRes[params.HeroResID].IsLoad  = params.IsLoad;
			if self.HeroRes[params.HeroResID].Priority == 1 then
				self.TempRes = self.TempRes + 1;
			end
		end
		self.HeroRes[params.HeroResID].time = os.time(); --更新操作时间
		self:addHeroResRetainList( params.HeroResID );--更新保留资源
		return;
	end
	self.HeroRes[params.HeroResID] = params;
	self.HeroRes[params.HeroResID].time = os.time(); --更新操作时间
	-- HeroRes.LoadLastResID = params.HeroResID;
	self:addHeroResRetainList( params.HeroResID );--更新保留资源
	if params.IsLoad and params.Priority == 1 then
		self.TempRes = self.TempRes + 1;
	end
	self.SumRes = self.SumRes + 1;
end

--[[清除特定的英雄资源
]]
-- function removeHeroRes( HeroResID )
-- 	HeroRes[HeroResID] = nil;
-- end

--[[
	清除英雄资源
]]
-- function clearHeroRes(  )
-- 	for k,v in pairs(HeroRes) do
-- 		if v and v.HeroResID then
-- 			HeroRes[k] = nil;
-- 		end
-- 	end
-- end

--设置资源释放开关
function ManagerHeroRes:SetHeroResleasePeakCheckSwitch( params )
	self.ReleaseSwitch = params;
end

--检查英雄添加峰值 并清除
function ManagerHeroRes:HeroResReleasePeak_Logic(  )
	-- print("英雄资源检查",HeroRes.TempRes,HeroRes.ReleaseSwitch)
	--检查临时资源数量
	if self.TempRes < self.ReleasePeak or (not self.ReleaseSwitch) then
		return;
	end
	local nowTime = os.time();
	for k,v in pairs(self.HeroRes) do
		if v and v.Priority == 1 and v.IsLoad then
			if (nowTime - v.time) >= self.CONST_RETAINTIME and (not self:IsRetainHeroRes( v.HeroResID ))  then
				--释放资源
				release_ccs_animation( v.HeroResID );
				v.IsLoad = false;
				self.HeroRes[k] = nil;
				self.TempRes = self.TempRes - 1;
				self.SumRes = self.SumRes - 1;
				print("英雄资源检查","释放"..namestr)
			end
		end
	end
end


--检查所有未加载资源 并加载
function ManagerHeroRes:CheckAllHeroResAndLoad(  )
	local resImage = nil;
	local resplist = nil;
	printInfo("HeroRes %s", "调用 CheckAllHeroResAndLoad");
	for k,v in pairs(self.HeroRes) do
		if v and v.HeroResID and (not v.IsLoad) then
			ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(v.HeroResID)
			v.IsLoad = true;
			if v.Priority == 1 then
				self.TempRes = self.TempRes + 1;
			end
		end
	end
end

--检查所有未加载资源 并异步加载
function ManagerHeroRes:CheckAllHeroResAndAsyncLoad( finishcall )
	local resImage = nil;
	local resplist = nil;
	printInfo("HeroRes %s", "调用 CheckAllHeroResAndLoad");
	local rescount = 0;
	--得到加载数量
	for k,v in pairs(self.HeroRes) do
		if v and type(v) == "table" and v.HeroResID and (not v.IsLoad) then
			rescount = rescount + 1;
		end
	end
	
	for k,v in pairs(self.HeroRes) do
		if v and type(v) == "table" and v.HeroResID and (not v.IsLoad) then
			GLOBAL_ARMATURE_MANAGER:addArmatureFileInfoAsync(v.HeroResID ,function (  )
				rescount = rescount - 1;
				if rescount < 1 then
					finishcall();
				end
			end)
			v.IsLoad = true;
			if v.Priority == 1 then
				self.TempRes = self.TempRes + 1;
			end
		end
	end
	return rescount;
end


--[[加载英雄资源
	heroResID 英雄资源ID
	Priority 优先级
	direction 资源方向(1 正面 2 背面)
]]
function ManagerHeroRes:LoadHeroRes( heroResID , Priority ,direction)
	--判断是否有次英雄
	local heroresInfo = getFrameShowData( heroResID );
	if heroresInfo == nil then
		printInfo("HeroRes", "添加的英雄资源ID为nil:"..heroResID)
		return;
	end
	--得到资源编号
	local resindex = heroresInfo.defendfigure.idle;
	if direction == 1 then
		resindex = heroresInfo.attackfigure.idle;
	end
	--判断是否加载
	if self.HeroRes[resindex] and self.HeroRes[resindex].IsLoad then
		if self.HeroRes[resindex].Priority < Priority then
			self.HeroRes[resindex].Priority = Priority;
		end
		print("英雄已经加载:",resindex)
		self.HeroRes[resindex].time = os.time(); --更新操作时间
		-- HeroRes.LoadLastResID = heroResID;--记录最后资源
		self:addHeroResRetainList( resindex );--更新保留资源
		return;
	end
	ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(resindex)
	self:AddHeroRes( {
			HeroResID = resindex,--英雄ID
			Priority = Priority,--优先级
			IsLoad = true,--是否加载
			Direction = direction,
	} );
end

--得到角色动画资源
function ManagerHeroRes:getHeroArmature( templeID ,camp )
	-- print(templeID);
	local data = ResFrameIcon[heroConfig[templeID].bigID];

	if not data then
		printInfo("错误日志 找不到角色形象资源 ： %s", templeID)
		data = ResFrameIcon[20000];
	end
	local index = data.actionlist;
	-- if camp == Data_Battle.CONST_CAMP_ENEMY then
	-- 	index = data.defendfigure;
	-- end
	return index;
end

--得到角色动画资源
function ManagerHeroRes:getHeroArmature_1( templeID ,camp ,dir)
	local data = ResFrameIcon[templeID];
	local index = data.actionlist;
	-- if camp == Data_Battle.CONST_CAMP_ENEMY then
	-- 	index = data.defendfigure;
	-- end
	return index[dir];
end

--清除临时使用的英雄资源
function ManagerHeroRes:RemoveTemporaryHeroRes(  )
	local resImage = nil;
	local resplist = nil;
	for k,v in pairs(self.HeroRes) do
		if v and v.HeroResID and v.Priority == 1 then
			release_ccs_animation( v.HeroResID );
			v.IsLoad = false;
			self.HeroRes[k] = nil;
			self.TempRes = self.TempRes - 1;
			self.SumRes = self.SumRes - 1;
			print("英雄资源减少:",self.TempRes)
		end
	end
	self:ClearRetainHeroRes();--清空保留的资源
end

