--
-- Author: Wu Hengmin
-- Date: 2014-06-18 11:28:40
--

-- 道具列表
Msg_Logic[MSG_MS2C_ITEMS_DATA] = function ( tcp , msg  )
	MAIN_PLAYER.goodsManager.data = {}
	local count = msg:ReadIntData()
	printLog("网络日志","收到道具列表消息,数量:"..count)
	for i=1,count do
		local id = msg:ReadIntData()
		local num = msg:ReadIntData()
		printLog("网络日志","道具信息: ID="..id.." 数量="..num)
		MAIN_PLAYER.goodsManager:add(id, num)
	end
end

-- 添加道具
Msg_Logic[MSG_MS2C_ITEMS_ADD] = function ( tcp , msg  )
	printLog("网络日志","收到添加道具消息")
	local id = msg:ReadIntData()
	local num = msg:ReadIntData()
	printLog("网络日志","道具信息: ID="..id.." 数量="..num)
	MAIN_PLAYER.goodsManager:add(id, num)

	-- 刷新道具
	-- dispatchGlobaleEvent("model_goodsManager", "refreshgoods", {})
end


-- 删除道具
Msg_Logic[MSG_MS2C_ITEMS_DEL] = function ( tcp , msg  )
	printLog("网络日志","收到删除道具消息")
	local id = msg:ReadIntData()
	local num = msg:ReadIntData()
	printLog("网络日志","道具信息: ID="..id.." 数量="..num)
	MAIN_PLAYER.goodsManager:remove(id, num)

	-- 刷新道具
	dispatchGlobaleEvent("model_goodsManager", "refreshgoods", {})
end

-- 道具错误提示
Msg_Logic[MSG_MS2C_ITEMS_ERROR] = function ( tcp , msg  )

end

-- 物品获得通知
Msg_Logic[MSG_MS2C_GET_NOTICE] = function ( tcp , msg  )
	printLog("网络日志","物品获得通知")
	-- 数量
	local count = msg:ReadIntData()
	printLog("网络日志","获得物品数量"..count)
	-- 类型 ID 等级 数量
	local params = {}
	for i=1,count do
		local data = {}
		data.type_ = msg:ReadIntData()
		data.ID = msg:ReadIntData()
		data.lv = msg:ReadIntData()
		data.num = msg:ReadIntData()

		if data.type_ == eDT_CardPiece or 
			data.type_ == eDT_Item or 
			data.type_ == eDT_Gold or 
			data.type_ == eDT_YuanBao or 
			data.type_ == eDT_Card and (data.ID == 30501 or data.ID == 40501 or data.ID == 50501 ) or 
			data.type_ == eDT_Equip or 
			data.type_ == eDT_EquipPiece or 
			data.type_ == eDT_JiangHun then
			local current = false
			for i=1,#params do
				if data.type_ == params[i].type_ and data.ID == params[i].ID then
					params[i].num = params[i].num + data.num
					current = true
				end
			end
			if not current then
				table.insert(params, data)
			end
		else
			table.insert(params, data)
		end
		
		printLog("网络日志","获得物品type:"..data.type_.." ID:"..data.ID.." num:"..data.num)
	end

	if count> 0 then
		dispatchGlobaleEvent("netMsg", tostring(MSG_MS2C_GET_NOTICE), {data = params})
	end
end
