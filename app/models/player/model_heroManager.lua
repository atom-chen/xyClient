--
-- Author: lipeng
-- Date: 2015-06-1 2 19:06:55
-- 英雄管理

local model_heroManager = class("model_heroManager")
--[[发送全局事件名预览
eventModleName: model_heroManager
eventName: 
	refreshfragment --刷新碎片列表
	shengji -- 升级后更新显示
	juexing -- 觉醒后更新显示
	zhiye -- 职业强度提升后更新显示
	skill -- 技能提升后更新显示
	chongsheng -- 重生后更新显示
	suipian -- 碎片数量更新显示
	suihua -- 武将碎化更新显示
	hecheng -- 武将合成更新显示
]]

--[[监听全局事件名预览
eventModleName: netMsg
eventName:
	tostring(MSG_MS2C_SEND_HERO_LEVELUP) -- 武将升级
	tostring(MSG_MS2C_SEND_HERO_EVOLUTION) -- 武将觉醒
	tostring(MSG_MS2C_HERO_OCCU_UPGRADE) -- 武将职业强化
	tostring(MSG_MS2C_HERO_UPGRADE_SKILL_RE) -- 武将技能强化
	tostring(MSG_MS2C_HERO_REDUCED) -- 武将重生
	tostring(MSG_MS2C_PIECE_UPDATE) -- 武将碎片数量更新
	tostring(MSG_MS2C_PIECE_HERO_SPLIT_RE) -- 武将碎化
	tostring(MSG_MS2C_DEL_HERO) -- 删除武将
	tostring(MSG_MS2C_PIECE_HERO_MERGE_RE) -- 武将合成
	tostring(MSG_MS2C_PIECE_TO_SOUL_RE) -- 碎片分解
]]

local class_hero = import(".hero.lua")

function model_heroManager:ctor()
	self.heros = {}
	self.fragments = {}
	self:createAtlasData()
	self.universalfrag = 0

	self:_registGlobalEventListeners()
end


--[[
	添加武将
	params.id 武将id
	params.GUID 
	params.LV 武将等级
	params.skillLv 技能等级
	params.occupatpower  职业强度
	params.EXP
	params.baseHP
	params.addtionHP
	params.baseAtt
	params.addtionAtt
	params.isLocked
]]
function model_heroManager:add(params)
	-- body
	if heroConfig[params.id] then
		local  hero = class_hero.new();
		hero.id = params.id;
		hero.guid = params.GUID;
		hero.curLv = params.LV;
		hero.skillLv = params.skillLv
		hero.occupatpower = params.occupatpower

		if params.EXP then
			hero.Exp = params.EXP;
		end
		if params.baseHP then
			hero.baseHP = params.baseHP;
		end
		if params.addtionHP then
			hero.addtionHP = params.addtionHP;
		end
		if params.baseAtt then
			hero.baseAtt = params.baseAtt;
		end
		if params.addtionAtt then
			hero.addtionAtt = params.addtionAtt;
		end
		if params.isLocked then
			hero.isLocked = params.isLocked;
		else
			hero.isLocked = 0
		end
		hero.fixProperty = heroConfig[hero.id]

		self.heros[params.GUID] = hero;

	else
		print("**************英雄数据错误*************"..params.id)
	end
end

--[[ 添加英雄
	params.ID 英雄模板ID
	params.Lv 等级
	params.EXP 
	params.GUID 
]]
function model_heroManager:CreateHero( params )
	local  hero = class_hero.new();
	hero.id = params.id;
	hero.guid = params.GUID or 1;
	hero.curLv = params.LV or 1;
	hero.time = params.time or 1;

	if params.EXP then
		hero.Exp = params.EXP;
	end
	if params.baseHP then
		hero.baseHP = params.baseHP;
	end
	if params.addtionHP then
		hero.addtionHP = params.addtionHP;
	end
	if params.baseAtt then
		hero.baseAtt = params.baseAtt;
	end
	if params.addtionAtt then
		hero.addtionAtt = params.addtionAtt;
	end
	if params.isLocked then
		hero.isLocked = params.isLocked;
	else
		hero.isLocked = 0
	end
	hero.fixProperty = heroConfig[hero.templeateID]

	return hero;

end

function model_heroManager:addFragment(params)
	for i=1,#self.fragments do
		if self.fragments[i].id == params.id then
			self.fragments[i].count = self.fragments[i].count + params.count
			return
		end
	end
	table.insert(self.fragments, params)
end

function model_heroManager:updateFragment(params)
	for i=1,#self.fragments do
		if self.fragments[i].id == params.id then
			self.fragments[i].count = params.count
			if self.fragments[i].count == 0 then
				table.remove(self.fragments, i)
			end
			return
		end
	end
	table.insert(self.fragments, params)
end

function model_heroManager:remove()
	-- body
end

function model_heroManager:getHero(guid)
	return self.heros[guid]
end

function model_heroManager:getHeroBase(guid)
	return heroConfig[self:getTempleteID(guid)]
end

function model_heroManager:getTempleteID(guid)
	return self.heros[guid].id
end

function model_heroManager:isHave(id)
	-- body
	for k,v in pairs(self.heros) do
		if v.id%1000 == id%1000 then
			return true
		end
	end
	return false
end


-- 生成图鉴中需要的数据
function model_heroManager:createAtlasData()
	-- body
	local function countrySort(a, b)
		-- body
		if a.star ~= b.star then
			return a.star > b.star
		end
	end

	self.country = {}
	self.country[1] = {}
	self.country[2] = {}
	self.country[3] = {}
	self.country[4] = {}
	-- 1.魏国武将
	for i,v in pairs(heroConfig) do
		if i%1000 < 400 and math.floor(i%10000/1000) == 0 and v.country == 1 then
			v.id = i
			local isInsered = false
			for i=1,#self.country[1] do
				if self.country[1][i].id%1000 == v.id%1000 then
					if v.id > self.country[1][i].id then
						table.remove(self.country[1], i)
						break
					else
						isInsered = true
					end
				end
			end
			if not isInsered then
				table.insert(self.country[1], v)
			end
		end
	end
	table.sort(self.country[1], countrySort)
	-- 2.蜀国武将
	for i,v in pairs(heroConfig) do
		if i%1000 < 400 and math.floor(i%10000/1000) == 0 and v.country == 2 then
			v.id = i
			local isInsered = false
			for i=1,#self.country[2] do
				if self.country[2][i].id%1000 == v.id%1000 then
					if v.id > self.country[2][i].id then
						table.remove(self.country[2], i)
						break
					else
						isInsered = true
					end
				end
			end
			if not isInsered then
				table.insert(self.country[2], v)
			end
		end
	end
	table.sort(self.country[2], countrySort)
	-- 3.吴国武将
	for i,v in pairs(heroConfig) do
		if i%1000 < 400 and math.floor(i%10000/1000) == 0 and v.country == 3 then
			v.id = i
			local isInsered = false
			for i=1,#self.country[3] do
				if self.country[3][i].id%1000 == v.id%1000 then
					if v.id > self.country[3][i].id then
						table.remove(self.country[3], i)
						break
					else
						isInsered = true
					end
				end
			end
			if not isInsered then
				table.insert(self.country[3], v)
			end
		end
	end
	table.sort(self.country[3], countrySort)
	-- 4.群雄武将
	for i,v in pairs(heroConfig) do
		if i%1000 < 400 and math.floor(i%10000/1000) == 0 and v.country == 4 then
			v.id = i
			local isInsered = false
			for i=1,#self.country[4] do
				if self.country[4][i].id%1000 == v.id%1000 then
					if v.id > self.country[4][i].id then
						table.remove(self.country[4], i)
						break
					else
						isInsered = true
					end
				end
			end
			if not isInsered then
				table.insert(self.country[4], v)
			end
		end
	end
	table.sort(self.country[4], countrySort)

end

--拷贝英雄数据并转换为列表
function model_heroManager:cloneHerosDataToList()
	local idx = 1
	local heroList = {}
	for k,v in pairs(self.heros) do
		heroList[idx] = v
		printInfo(idx)
		idx = idx + 1
	end

	return heroList
end

local function mysort(a, b)
	-- body
	if heroConfig[a.id].star ~= heroConfig[b.id].star then
		return heroConfig[a.id].star > heroConfig[b.id].star
	elseif a.curLv and a.curLv ~= b.curLv then
		return a.curLv > b.curLv
	else
		return a.id > b.id
	end
end

-------------------------------------------
-- 得到武将中的魏国武将
function model_heroManager:getHerosWei()
	-- body
	local data = {}
	for k,v in pairs(self.heros) do
		if heroConfig[v.id].country == 1 then
			table.insert(data, v)
		end
	end
	table.sort(data, mysort)
	return data
end

-- 得到武将中的蜀国武将
function model_heroManager:getHerosShu()
	-- body
	local data = {}
	for k,v in pairs(self.heros) do
		if heroConfig[v.id].country == 2 then
			table.insert(data, v)
		end
	end
	table.sort(data, mysort)
	return data
end

-- 得到武将中的吴国武将
function model_heroManager:getHerosWu()
	-- body
	local data = {}
	for k,v in pairs(self.heros) do
		if heroConfig[v.id].country == 3 then
			table.insert(data, v)
		end
	end
	table.sort(data, mysort)
	return data
end

-- 得到武将中的群雄武将
function model_heroManager:getHerosQun()
	-- body
	local data = {}
	for k,v in pairs(self.heros) do
		if heroConfig[v.id].country == 4 then
			table.insert(data, v)
		end
	end
	table.sort(data, mysort)
	return data
end

-- 得到武将中的副将
function model_heroManager:getHerosFu()
	-- body
	local data = {}
	for k,v in pairs(self.heros) do
		if heroConfig[v.id].star == 3 then
			table.insert(data, v)
		end
	end
	table.sort(data, mysort)
	return data
end

-- 得到武将中的名将
function model_heroManager:getHerosMing()
	-- body
	local data = {}
	for k,v in pairs(self.heros) do
		if heroConfig[v.id].star == 4 then
			table.insert(data, v)
		end
	end
	table.sort(data, mysort)
	return data
end

-- 得到武将中的神将
function model_heroManager:getHerosShen()
	-- body
	local data = {}
	for k,v in pairs(self.heros) do
		if heroConfig[v.id].star == 5 then
			table.insert(data, v)
		end
	end
	table.sort(data, mysort)
	return data
end

-- 得到全部武将
function model_heroManager:getHerosQuan()
	-- body
	local data = {}
	for k,v in pairs(self.heros) do
		table.insert(data, v)
	end
	table.sort(data, mysort)
	return data
end

-------------------------------------------------

-- 得到碎片中的魏国武将
function model_heroManager:getFragmentsWei()
	-- body
	local data = {}
	for k,v in pairs(self.fragments) do
		if heroConfig[v.id].country == 1 then
			table.insert(data, v)
		end
	end
	table.sort(data, mysort)
	return data
end

-- 得到碎片中的蜀国武将
function model_heroManager:getFragmentsShu()
	-- body
	local data = {}
	for k,v in pairs(self.fragments) do
		if heroConfig[v.id].country == 2 then
			table.insert(data, v)
		end
	end
	table.sort(data, mysort)
	return data
end

-- 得到碎片中的吴国武将
function model_heroManager:getFragmentsWu()
	-- body
	local data = {}
	for k,v in pairs(self.fragments) do
		if heroConfig[v.id].country == 3 then
			table.insert(data, v)
		end
	end
	table.sort(data, mysort)
	return data
end

-- 得到碎片中的群雄武将
function model_heroManager:getFragmentsQun()
	-- body
	local data = {}
	for k,v in pairs(self.fragments) do
		if heroConfig[v.id].country == 4 then
			table.insert(data, v)
		end
	end
	table.sort(data, mysort)
	return data
end

-- 得到碎片中的副将
function model_heroManager:getFragmentsFu()
	-- body
	local data = {}
	for k,v in pairs(self.fragments) do
		if v.id < 101000 and heroConfig[v.id].star == 3 then
			table.insert(data, v)
		end
	end
	table.sort(data, mysort)
	return data
end

-- 得到碎片中的名将
function model_heroManager:getFragmentsMing()
	-- body
	local data = {}
	for k,v in pairs(self.fragments) do
		if v.id < 101000 and heroConfig[v.id].star == 4 then
			table.insert(data, v)
		end
	end
	table.sort(data, mysort)
	return data
end

-- 得到碎片中的神将
function model_heroManager:getFragmentsShen()
	-- body
	local data = {}
	for k,v in pairs(self.fragments) do
		if v.id < 101000 and heroConfig[v.id].star == 5 then
			table.insert(data, v)
		end
	end
	table.sort(data, mysort)
	return data
end

-- 得到全部碎片
function model_heroManager:getFragmentsQuan()
	-- body
	local data = {}
	for k,v in pairs(self.fragments) do
		table.insert(data, v)
	end
	table.sort(data, mysort)
	return data
end

-------------------------------------



-- 得到图鉴中的魏国武将
function model_heroManager:getAtlasWei()
	-- body
	return self.country[1]
end

-- 得到图鉴中的蜀国武将
function model_heroManager:getAtlasShu()
	-- body
	return self.country[2]
end

-- 得到图鉴中的吴国武将
function model_heroManager:getAtlasWu()
	-- body
	return self.country[3]
end

-- 得到图鉴中的群雄武将
function model_heroManager:getAtlasQun()
	-- body
	return self.country[4]
end

-- 得到图鉴中的副将
function model_heroManager:getAtlasFu()
	-- body
	local data = {}
	for k,v in pairs(heroConfig) do
		if v.id < 101000 and heroConfig[v.id].star == 3 then
			table.insert(data, v)
		end
	end
	table.sort(data, mysort)
	return data
end

-- 得到图鉴中的名将
function model_heroManager:getAtlasMing()
	-- body
	local data = {}
	for k,v in pairs(heroConfig) do
		if v.id < 101000 and heroConfig[v.id].star == 4 then
			table.insert(data, v)
		end
	end
	table.sort(data, mysort)
	return data
end

-- 得到图鉴中的神将
function model_heroManager:getAtlasShen()
	-- body
	local data = {}
	for k,v in pairs(heroConfig) do
		if v.id < 101000 and heroConfig[v.id].star == 5 then
			table.insert(data, v)
		end
	end
	table.sort(data, mysort)
	return data
end

-- 得到全部图鉴
function model_heroManager:getAtlasQuan()
	-- body
	local data = {}
	for k,v in pairs(heroConfig) do
		table.insert(data, v)
	end
	table.sort(data, mysort)
	return data
end

function model_heroManager:sort(a, b)
	-- body
	if heroConfig[a.id].star ~= heroConfig[b.id].star then
		return heroConfig[a.id].star > heroConfig[b.id].star
	elseif a.curLv and a.curLv ~= b.curLv then
		return a.curLv > b.curLv
	else
		return a.id > b.id
	end

end

function model_heroManager:_registGlobalEventListeners()
	-- body
	self._globalEventListeners = {}
	local configs = {
		{modelName = "netMsg", eventName = tostring(MSG_MS2C_SEND_HERO_LEVELUP), callBack=handler(self, self._onMSG_MS2C_SEND_HERO_LEVELUP)},
		{modelName = "netMsg", eventName = tostring(MSG_MS2C_SEND_HERO_EVOLUTION), callBack=handler(self, self._onMSG_MS2C_SEND_HERO_EVOLUTION)},
		{modelName = "netMsg", eventName = tostring(MSG_MS2C_PIECE_UPDATE), callBack=handler(self, self._onMSG_MS2C_PIECE_UPDATE)},
		{modelName = "netMsg", eventName = tostring(MSG_MS2C_HERO_UPGRADE_SKILL_RE), callBack=handler(self, self._onMSG_MS2C_HERO_UPGRADE_SKILL_RE)},
		{modelName = "netMsg", eventName = tostring(MSG_MS2C_HERO_OCCU_UPGRADE), callBack=handler(self, self._onMSG_MS2C_HERO_OCCU_UPGRADE)},
		{modelName = "netMsg", eventName = tostring(MSG_MS2C_HERO_REDUCED), callBack=handler(self, self._onMSG_MS2C_HERO_REDUCED)},
		{modelName = "netMsg", eventName = tostring(MSG_MS2C_PIECE_HERO_SPLIT_RE), callBack=handler(self, self._onMSG_MS2C_PIECE_HERO_SPLIT_RE)},
		{modelName = "netMsg", eventName = tostring(MSG_MS2C_DEL_HERO), callBack=handler(self, self._onMSG_MS2C_DEL_HERO)},
		{modelName = "netMsg", eventName = tostring(MSG_MS2C_PIECE_HERO_MERGE_RE), callBack=handler(self, self._onMSG_MS2C_PIECE_HERO_MERGE_RE)},
		{modelName = "netMsg", eventName = tostring(MSG_MS2C_PIECE_TO_SOUL_RE), callBack=handler(self, self._onMSG_MS2C_PIECE_TO_SOUL_RE)},
		
	}

	self._globalEventListeners = createGlobalEventListenerWithConfig(configs)
end

function model_heroManager:_onMSG_MS2C_SEND_HERO_LEVELUP(params)
	-- body
	local guid = params._usedata.guid
	local curLv = params._usedata.curLv
	local exp = params._usedata.exp
	local hero = self:getHero(guid)
	hero:setLv(curLv)
	hero:setExp(exp)
	dispatchGlobaleEvent("model_heroManager", "shengji")
end

function model_heroManager:_onMSG_MS2C_SEND_HERO_EVOLUTION(params)
	-- body
	local guid = params._usedata.guid
	local id = params._usedata.templeateID
	local hero = self:getHero(guid)
	hero.id = id
	dispatchGlobaleEvent("model_heroManager", "juexing")
end

function model_heroManager:_onMSG_MS2C_HERO_OCCU_UPGRADE(params)
	-- body
	local guid = params._usedata.guid
	local power = params._usedata.power
	local hero = self:getHero(guid)
	hero:setOccupatpower(power)
	dispatchGlobaleEvent("model_heroManager", "zhiye", {})
end

function model_heroManager:_onMSG_MS2C_HERO_UPGRADE_SKILL_RE(params)
	-- body
	local guid = params._usedata.guid
	local hero = self:getHero(guid)
	hero:setSkillLv(hero:getSkillLv()+1)
	print("_onMSG_MS2C_HERO_UPGRADE_SKILL_RE")
	dispatchGlobaleEvent("model_heroManager", "skill")
end

function model_heroManager:_onMSG_MS2C_HERO_REDUCED(params)
	-- body
	local guid = params._usedata.guid
	local id = params._usedata.id
	local lv = params._usedata.lv
	local hero = self:getHero(guid)
	hero.id = id
	hero.curLv = lv
	dispatchGlobaleEvent("model_heroManager", "chongsheng")
end

function model_heroManager:_onMSG_MS2C_PIECE_UPDATE(params)
	-- body
	local id = params._usedata.ID
	local count = params._usedata.COUNT
	self:updateFragment({id=id, count=count})
	dispatchGlobaleEvent("model_heroManager", "suipian")
end

function model_heroManager:_onMSG_MS2C_PIECE_HERO_SPLIT_RE()
	-- body
	dispatchGlobaleEvent("model_heroManager", "suihua")
end

function model_heroManager:_onMSG_MS2C_DEL_HERO(params)
	-- body
	local guid = params._usedata.guid
	self.heros[guid] = nil
end

function model_heroManager:_onMSG_MS2C_PIECE_HERO_MERGE_RE()
	-- body
	dispatchGlobaleEvent("model_heroManager", "hecheng")
end

function model_heroManager:_onMSG_MS2C_PIECE_TO_SOUL_RE()
	-- body
	dispatchGlobaleEvent("model_heroManager", "fenjie")
end

function model_heroManager:getXilianTarg()
	-- body
	local tmpdata = {}
	local tmp = 1
	for k,v in pairs(self.heros) do
		tmpdata[tmp] = v
		tmp = tmp + 1
	end
	local function sort(a, b)
		-- body
		if heroConfig[a.id].star ~= heroConfig[b.id].star then
			return heroConfig[a.id].star < heroConfig[b.id].star
		elseif heroConfig[a.id].curLv ~= heroConfig[b.id].curLv then
			return heroConfig[a.id].curLv < heroConfig[b.id].curLv
		else
			return a.id < b.id
		end
	end
	table.sort(tmpdata, sort)

	-- 还需去除
	local data = {}
	for i=1,8 do
		if tmpdata[i] then
			data[i] = tmpdata[i]
		end
	end
	return data
end

function model_heroManager:getXilianTargWithGuid(params)
	local data = {}
	for i=1,#params do
		table.insert(data, self:getHero(params[i]))
	end
	return data
end

function model_heroManager:getRandHero()
	-- body
	for k,v in pairs(self.heros) do
		return v
	end
end



return model_heroManager
