--
-- Author: lipeng
-- Date: 2015-07-17 11:55:12
--

local onCommand = TEST_CMD_SERVER_MSG

onCommand["MSG_MS2C_EQUIPS_GETLIST"] = function ( parmas )
	local count = 10
	MAIN_PLAYER.equipManager.data = {}
	
	printLog("网络日志","收到装备列表消息,数量:"..count)
	for i=1,count do
		local guid = tostring(i)
		local id = 10101
		local mainlevel = 1
		local offlevel = 2
		local yinliang = 500
		local item = 20
		printLog("网络日志","装备信息:guid="..guid.." ID="..id.." 主属性等级="..mainlevel.." 副属性等级:"..offlevel..
			" 返还银两:"..yinliang.." 返还道具数量"..item)
		MAIN_PLAYER.equipManager:addEqu({
				mainlevel = mainlevel,
				offlevel = offlevel,
				id = id,
				guid = guid,
				yinliang = yinliang,
				item = item,
			});
	end

	-- count = 5
	-- printLog("网络日志","收到装备碎片列表消息,数量:"..count)
	-- MAIN_PLAYER.equipManager.equipmentfragments = {}
	-- for i=1,count do
	-- 	local ID = 10101
	-- 	local COUNT = 99
	-- 	printLog("网络日志","碎片信息:ID="..ID.." 数量="..COUNT)
	-- 	MAIN_PLAYER.equipManager:addFragment({
	-- 		id = ID,
	-- 		count = COUNT,
	-- 		})
	-- end

	dispatchGlobaleEvent("model_equipManager", "openequip", {})
end


