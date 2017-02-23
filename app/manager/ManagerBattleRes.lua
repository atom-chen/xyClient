--
-- Author: Li Yang
-- Date: 2014-06-24 10:18:37
-- 战斗资源释放管理

--[[ 战场资源管理
	1.资源.plist
	2.动画资源.ExportJson
	3.单张资源 png
]]
ManagerBattleRes = {};

ManagerBattleRes.BattleRes = {};--战斗资源容器

ManagerBattleRes.BattleArmaturePool = {};--战场动画池

ManagerBattleRes.pos = 1;

--[[ 添加战斗资源
	params = {
		".plist",--plist图片
		".png",--图片资源
	},
	nil 表示未加载
	不为nil 表示加载
]]
function ManagerBattleRes:AddBattleRes( params ,num)

	if self.BattleRes[params] then
		self.BattleRes[params] = self.BattleRes[params] + num;
	else
		self.BattleRes[params] = num;
		self.pos = self.pos + 1;
	end
	-- if self.BattleRes[params] < 1 then
	-- 	self.BattleRes[params] = 0;
	-- end
end

function ManagerBattleRes:AddBattleArmatureRes( params ,num )
	if self.BattleArmaturePool[params] then
		self.BattleArmaturePool[params] = self.BattleArmaturePool[params] + num;
	else
		self.BattleArmaturePool[params] = num;
	end
end

--[[
	清除战斗资源
]]
function ManagerBattleRes:removeBattleRes(  )
	--销毁所有战斗资源
	for i,v in ipairs(self.BattleRes) do
		if v > 0 then
			local imageTexture = GLOBAL_TEXTURE_CACHE:getTextureForKey(i);
			if imageTexture then
				GLOBAL_SPRITE_FRAMES_CACHE:removeSpriteFramesFromTexture(imageTexture);
			end
			GLOBAL_TEXTURE_CACHE:removeTextureForKey(i);
		end
	end
	self.BattleRes = {};
	-- RemoveTemporaryHeroRes(  );--清除使用的临时英雄资源
	-- removeBattleCCSRes(  );--清除使用的战斗效果资源
	-- SetHeroResleasePeakCheckSwitch( true );
	-- self.ResLoadMark = 0;
	-- self.recordUseNeed = {};
	-- BattleInviCCS = {};
end


--解析角色入场动作资源
function ManagerBattleRes:analysisActorActionRes( templeID ,camp , actiontype )
	local reslist = {};
	local armaturelist = {};
	--得到动作资源参数
	local actoractionInfo = ManagerHeroRes:getHeroArmature( templeID ,camp );
	print(templeID ,camp , actiontype,actoractionInfo)
	local actionRes = getEffectConfigById( actoractionInfo[actiontype] ).res;
	-- print(templeID ,camp , actiontype,actoractionInfo,actionRes)
	if actionRes then
		for i,v in ipairs(actionRes) do
			--得到具体资源
			print("      index:",i,v)
			local resInfo = ResConfig[v];
			local path = resInfo.respath;
			local restype = getResSuffixById(resInfo.restype);
			if armaturelist[v] then
				armaturelist[v] = armaturelist[v] + 1;
			else
				armaturelist[v] = 1;
			end
			for j,k in ipairs(resInfo.res) do
				local resname = path..k..restype;
				-- print("             ",j,k,resname)
				if reslist[resname] then
					reslist[resname] = reslist[resname] + 1;
				else
					reslist[resname] = 1;
				end
			end
		end
	end
	print("ManagerBattleRes:analysisActorActionRes",table.nums(armaturelist))
	return reslist,armaturelist;
end

--[[解析技能id资源
	skillid 技能ID
	templeID 模板ID
	camp 阵营
]]
function ManagerBattleRes:analysisSkillIDRes( skillid , templeID ,camp)
	print(skillid)
	local skillInfo = SkillConfig[skillid];
	if not skillInfo then
		return;
	end
	local resInfo = EffectResConfig[skillInfo.CastingEffectID];
	local reslist = {};
	local armaturelist = {};
	if resInfo then
		--先解析动作资源
		local actionRes,armatureres = self:analysisActorActionRes( templeID ,camp ,resInfo.action );
		for i,v in pairs(actionRes) do
			-- print(i,v)
			if reslist[i] then
				reslist[i] = reslist[i] + v;
			else
				reslist[i] = v;
			end
		end
		for k,v in pairs(armatureres) do
			if armaturelist[k] then
				armaturelist[k] = armaturelist[k] + v;
			else
				armaturelist[k] = v;
			end
		end
		--解析效果其他资源
		for i,v in ipairs(resInfo.other) do
			local actionRes = getEffectConfigById( v ).armature;
			local resInfo = ResConfig[actionRes];
			local path = resInfo.respath;
			local restype = getResSuffixById(resInfo.restype);
			-- print(v,resInfo,path,restype,actionRes)
			if armaturelist[actionRes] then
				armaturelist[actionRes] = armaturelist[actionRes] + 1;
			else
				armaturelist[actionRes] = 1;
			end
			for j,k in ipairs(resInfo.res) do
				local resname = path..k..restype;
				if reslist[resname] then
					reslist[resname] = reslist[resname] + 1;
				else
					reslist[resname] = 1;
				end
			end
		end
	end
	return reslist,armaturelist;
end


------------------------战场资源初始化内容-----------------------------------

--[[初始化战场资源(当前战斗数据释放资源 下场战斗加载资源)
	currentdata 当前战斗数据
	inning 局数
	nextfightdata 下场战斗数据
	inning 局数
]]
function ManagerBattleRes:InitBattleUseRes( currentdata , inning_0)
	--1.设置默认格式
	setTextureDefaultPixelFormat( cc.TEXTURE2_D_PIXEL_FORMAT_RGB_A4444 )
	--处理上次加载的资源
	self:handleLastTimeDynamicList(  );
	--加载资源
	self:setCurrentDynamicMark( "invibattle" );
	--解析当前战斗需要的资源
	Data_Battle_Msg:analysisInviInningsRes( currentdata , inning_0 , 1);
	--解析要释放的资源数据
	-- Data_Battle_Msg:analysisInviInningsRes( nextfightdata , inning_1 , 1);
	--添加公共资源(对比公共资源)

	--得到加载资源列表并保持资源
	local loadList , armaturelist = self:getLoadResListAndSaveRes( self.dynamicLoadResPool ,self.dynamicLoadArmaturePool);
	--检查并销毁需要销毁的资源
	self:checkAndDestroyRes(  );
	print("ManagerBattleRes:InitBattleUseRes 加载资源数:%s ,加载动画数:%s",table.nums(loadList),table.nums(armaturelist))
	--加载动态资源
	self:LoadDynamicResList( loadList ,function (  )
		-- 资源初始化完成
		print("资源加载完成");
		print(GLOBAL_TEXTURE_CACHE:getCachedTextureInfo());
		dispatchGlobaleEvent( "loadbattleres" ,"loadbattleres_finish");
	end  )
end

--[[得到加载资源列表并保持资源
	reslist 图片资源列表
	armaturelist 动画信息列表
]]
function ManagerBattleRes:getLoadResListAndSaveRes( reslist ,armaturelist)
	local loadResList = {};
	local count = 0;
	for k,v in pairs(reslist) do
		if self.BattleRes[k] then
			self.BattleRes[k] = self.BattleRes[k] + v;
		else
			self.BattleRes[k] = v;
			--需要加载
			count = count + 1;
			loadResList[count] = k;
		end
	end
	local loadarmatureList = {};
	count = 0;
	for k,v in pairs(armaturelist) do
		if self.BattleArmaturePool[k] then
			self.BattleArmaturePool[k] = self.BattleArmaturePool[k] + v;
		else
			self.BattleArmaturePool[k] = v;
			--需要加载
			count = count + 1;
			loadarmatureList[count] = k;
		end
	end
	print("getLoadResListAndSaveRes",table.nums(armaturelist))
	return loadResList,loadarmatureList;
end

--保存动态资源
function ManagerBattleRes:SaveDynamicRes(  )

	for k,v in pairs(self.dynamicLoadResPool) do
		self:AddBattleRes( k ,v );
	end
end

--检查并且销毁资源
function ManagerBattleRes:checkAndDestroyRes(  )
	for k,v in pairs(self.BattleRes) do
		if v <= 0 then
			release_textureAndplistByTexture( k );
			--重置为未加载
			self.BattleRes[k] = nil;
		end
	end
	for k,v in pairs(self.BattleArmaturePool) do
		if v <= 0 then
			GLOBAL_ARMATURE_MANAGER:removeArmatureFileInfo(k)
			self.BattleArmaturePool[k] = nil;
		end
	end
end

--消除动态资源
function ManagerBattleRes:removeDynamicRes(  )
	-- body
end

--去除动态保存的资源列表
function ManagerBattleRes:destroyResList( reslist ,armaturelist)
	-- local desList = {};
	for k,v in pairs(reslist) do
		if v < 0 then
			release_textureAndplistByTexture( k );
		end
	end
	for k,v in pairs(armaturelist) do
		if v < 0 then
			GLOBAL_ARMATURE_MANAGER:removeArmatureFileInfo(k)
		end
	end
end


--[[得到资源类型
	png
	plist
	ExportJson
]]
function ManagerBattleRes:getResType( resname )
	-- local pos = string.find(resname,"%.");
	-- string.sub(resname, pos)

	return ResConfig[resname].restype;
end

ManagerBattleRes.CommonResNum = 0;
ManagerBattleRes.CommonResLoad = true;


function ManagerBattleRes:InitBattleCommon( params )
	-- 初始化战斗常用资源

	--下标为 ui_image/battle/common

end

-------------------------------战场资源动态使用资源管理---------------------------------------

--[[纹理动态加载设计思路
	1.选择异步队列加载
	2.统一纹理管理
	3.加载为预加载下一步(战场以回合数据为准)
	4.保留部分固定资源(比如角色保留 idle move 状态资源)
	5.采用计数进行释放管理
]]

--[[ 纹理信息
	{};添加使用标示
]]

--战役动态加载纹理图
ManagerBattleRes.dynamicLoadResPool = {};

--动态播放动画池
ManagerBattleRes.dynamicLoadArmaturePool = {};

--战役动态释放纹理图
ManagerBattleRes.dynamicReleaseResPool = {};

--[[动态标示
	表示当前资源操作标示
]]
ManagerBattleRes.dynamicMark = "";

--加载标记
ManagerBattleRes.LoadMark = false;

--切换操作数
function ManagerBattleRes:setCurrentDynamicMark( mark )
	self.dynamicMark = mark;
	self.LoadMark = false;
end

--处理上次加载动态资源列表
function ManagerBattleRes:handleLastTimeDynamicList(  )
	--需要销毁的
	for k,v in pairs(self.dynamicLoadResPool) do
		-- if self.dynamicLoadResPool[k] < 0 then
		-- 	self.dynamicLoadResPool[k] = nil;
		-- else
		-- 	self.dynamicLoadResPool[k] = v * -1;
		-- end
		--去除上次资源
		self:AddBattleRes( k ,v * -1 );
		self.dynamicLoadResPool[k] = nil;
	end

	for k,v in pairs(self.dynamicLoadArmaturePool) do
		
		self:AddBattleArmatureRes( k ,v * -1 )
		self.dynamicLoadArmaturePool[k] = nil;
	end
end

--[[添加动态资源
	resname 资源名称
	armaturelist 动画文件
	operate 当前标示(1添加 -1 删除)
]]
function ManagerBattleRes:addDynamicRes( reslist , armaturelist, operation)
	local restype = type(reslist);
	local addlist = {};
	if restype == "table" then
		addlist = reslist;
	else
		addlist[1] = reslist;
	end
	for k,v in pairs(addlist) do
		if self.dynamicLoadResPool[k] then
			self.dynamicLoadResPool[k] = self.dynamicLoadResPool[k] + v * operation;
		else
			self.dynamicLoadResPool[k] = v * operation;
		end
	end
	restype = type(armaturelist);
	addlist = {};
	if restype == "table" then
		addlist = armaturelist;
	else
		addlist[1] = armaturelist;
	end
	for k,v in pairs(addlist) do
		if self.dynamicLoadArmaturePool[k] then
			self.dynamicLoadArmaturePool[k] = self.dynamicLoadArmaturePool[k] + v * operation;
		else
			self.dynamicLoadArmaturePool[k] = v * operation;
		end
	end
end

--添加动态资源
function ManagerBattleRes:LoadAllDynamicRes( callfun )
	print("ManagerBattleRes:LoadAllDynamicRes")
	local reslist = {};
	local count = 0;
	for k,v in pairs(self.dynamicLoadResPool) do
		if v > 0 then
			count = count + 1;
			reslist[count] = k;
		end
	end
	if count == 0 then
		callfun();
		return;
	end
	--加载资源
	ResLoad:setCallback( callfun )
	ResLoad:setLoadList( reslist , self.dynamicMark );
	ResLoad:AsyncLoadResByQueue();
end

--添加动态资源
function ManagerBattleRes:LoadDynamicResList( reslist ,callfun )
	print("ManagerBattleRes:LoadDynamicResList")
	local count = table.nums(reslist)
	if count == 0 then
		callfun();
		return;
	end
	--加载资源
	ResLoad:setCallback( callfun )
	ResLoad:setLoadList( reslist , self.dynamicMark );
	ResLoad:AsyncLoadResByQueue();
end

--销毁所有动态加载资源
function ManagerBattleRes:clearAllDynamicRes( operate )
	local deleateList = {};
	local count = 1;
	for k,v in pairs(self.dynamicLoadResPool) do
		if v == operate then
			--清除资源
			deleateList[count] = k;
			count = count + 1;
		end
	end
	--释放
	release_res( deleateList );
end



