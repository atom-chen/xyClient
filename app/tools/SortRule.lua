--
-- Author: Wu Hengmin
-- Date: 2014-07-21 10:00:14
-- 排序规则

SortRule = {} --满足table.sort中sortFuction
MySort = {} --对SortRule进行2次封装, 以满足通过特定数据来进行排序的需求, 从参数的传递可以看出区别

-- 默认的排序
SortRule.defaultSortrule = function (a, b)
	-- body
	if a.fixProperty.star ~= b.fixProperty.star then
		return a.fixProperty.star > b.fixProperty.star
	elseif a.fixProperty.zuida_star ~= b.fixProperty.zuida_star then
		return a.fixProperty.zuida_star > b.fixProperty.zuida_star -- 最大星数多的靠前 
	-- elseif a.templeateID ~= b.templeateID then
	-- 	return a.templeateID > b.templeateID -- 模版ID大的靠前
	elseif a.curLv ~= b.curLv then
		return a.curLv > b.curLv -- 等级大的靠前
	else
		return a.fixProperty.name > b.fixProperty.name -- 先得到的靠前
	end
end

-- 碎片的默认排序
SortRule.defaultFragmentSortrule = function (a, b)
	if heroConfig[a.id].star ~= heroConfig[b.id].star then
		return heroConfig[a.id].star > heroConfig[b.id].star
	elseif heroConfig[a.id].zuida_star ~= heroConfig[b.id].zuida_star then		
		return heroConfig[a.id].zuida_star > heroConfig[b.id].zuida_star -- 最大星数多的靠前 
	elseif a.count ~= b.count then
		return a.count > b.count
	else
		return a.id > b.id -- 模版ID大的靠前
	end
end


-- 出售的排序
SortRule.saleSortrule = function (a, b)
	-- body
	if a.templeateID ~= b.templeateID then
		return a.templeateID < b.templeateID -- 模版ID小的靠前
	elseif a.curLv ~= b.curLv then
		return a.curLv < b.curLv -- 等级小的靠前
	else
		return a.time < b.time -- 先得到的靠前
	end
end

-- 时间排序
SortRule.timeSortrule = function (a, b)
	-- body
	return a.time < b.time -- 先得到的靠前
end

-- 装备的排序
SortRule.equipSortrule = function (a, b)
	-- body
	if equipmentConfig[a.id].Quality ~= equipmentConfig[b.id].Quality then
		return equipmentConfig[a.id].Quality > equipmentConfig[b.id].Quality -- 品质高的靠前 
	elseif equipmentConfig[a.id].chuandai_LV ~= equipmentConfig[b.id].chuandai_LV then
		return equipmentConfig[a.id].chuandai_LV > equipmentConfig[b.id].chuandai_LV -- 按穿戴等级分
	elseif a.id ~= b.id then
		return a.id < b.id
	elseif a.star ~= b.star then
		return a.star > b.star
	elseif a.level ~= b.level then
		return a.level > b.level
	elseif a.viceID ~= b.viceID then
		return a.viceID > b.viceID
	else
		return a.offID > b.offID
	end
end


-- 进化选择默认材料排序
SortRule.evoMaterialSortrule = function (a, b)
	if a.curLv ~= b.curLv then
		return a.curLv < b.curLv -- 等级小的靠前
	end
end


--排序: 在队伍上阵位置的成员优先
MySort.teamPro = function (heroList, team)
	table.sort( heroList, SortRule.defaultSortrule )
	local battleHeroManager = team:getBattleHeroManager()

	local temp = 0
	for i=1,#heroList do
		if battleHeroManager:hasHero(heroList[i].guid) then
			table.insert(heroList, 1+temp, heroList[i])
			table.remove(heroList, i+1)
			temp = temp + 1
		end
	end
end


--所有队伍成员优先
MySort.AllTeamPro = function (heroList, teamManager)
	table.sort( heroList, SortRule.defaultSortrule )

	local temp = 0
	for i=1,#heroList do
		if teamManager:isInTeam(heroList[i].guid) then
			table.insert(heroList, 1+temp, heroList[i])
			table.remove(heroList, i+1)
			temp = temp + 1
		end
	end
end






