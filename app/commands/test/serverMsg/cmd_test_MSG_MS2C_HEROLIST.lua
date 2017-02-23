--
-- Author: lipeng
-- Date: 2015-07-17 11:55:12
--

local onCommand = TEST_CMD_SERVER_MSG

onCommand["MSG_MS2C_BACKPACK"] = function ( parmas )

	MAIN_PLAYER:getHeroManager().heros = {}
	local count = 20
	printLog("网络日志", "收到英雄列表消息,数量:"..count)
	for i = 1, count do
		local params = {}
		params.GUID = tostring(i)
		params.id = 100101 + i - 1
		params.time = 0
		params.isLocked = false
		params.EXP = 10
		params.LV = i
		params.skillLv = 1
		-- 职业强度
		params.skillLvAddSuccessOdds = 0
		
		-- 添加英雄
		MAIN_PLAYER:getHeroManager():add( params )
		printLog("测试日志:".."--------英雄数据，HeroGUID:"..params.GUID..",HeroID="..params.id
			..",HeroExp="..params.EXP..",HeroGrade="..params.LV..
			",params.skillLv="..params.skillLv..",params.skillLvAddSuccessOdds="..params.skillLvAddSuccessOdds)

	end
end


