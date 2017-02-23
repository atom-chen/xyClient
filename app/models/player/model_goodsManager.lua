--
-- Author: Wu Hengmin
-- Date: 2015-07-06 11:42:31
-- 道具管理

local model_goodsManager = class("model_goosManager")
--[[发送全局事件名预览
eventModleName: model_goodsManager
eventName: 
	refreshgoods -- 刷新道具列表
]]

--[[监听全局事件名预览
eventModleName: netMsg
eventName:
	tostring(MSG_MS2C_GET_NOTICE) -- 获得物品通知
]]

function model_goodsManager:ctor()
	-- body
	self.data = {}
	self:_registGlobalEventListeners()
end

--注册全局事件监听器
function model_goodsManager:_registGlobalEventListeners()
	self._globalEventListeners = {}
	local configs = {
		{modelName = "netMsg", eventName = tostring(MSG_MS2C_GET_NOTICE), callBack=handler(self, self._onMSG_MS2C_GET_NOTICE)},
	}
	self._globalEventListeners = createGlobalEventListenerWithConfig(configs)
end

function model_goodsManager:add(id, count)
	-- body
	for i=1,#self.data do
		if self.data[i].id == id then
			self.data[i].count = self.data[i].count + count
			return
		end
	end
	local goods = {}
	goods.id = id
	goods.count = count
	table.insert(self.data, goods)
end

function model_goodsManager:remove(id, count)
	-- body
	for i=1,#self.data do
		if self.data[i].id == id then
			self.data[i].count = self.data[i].count - count
			if self.data[i].count == 0 then
				table.remove(self.data, i)
			elseif self.data[i].count < 0 then
				print("道具删除出错")
			end
			return
		end
	end
end

function model_goodsManager:getCount(id)
	-- body
	for i=1,#self.data do
		if self.data[i].id == id then
			return self.data[i].count
		end
	end
	return 0
end

function model_goodsManager:_onMSG_MS2C_GET_NOTICE(params)
	-- body
	local data = params._usedata.data
	UIManager:createGoodsGet(data)
end

return model_goodsManager
