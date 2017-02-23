--
-- Author: Wu Hengmin
-- Date: 2015-07-09 11:28:24
--

local model_marketManager = class("model_marketManager")
--[[发送全局事件名预览
eventModleName: model_marketManager
eventName: 
	openXiangou --打开装备界面
]]
function model_marketManager:ctor()
	-- body
	self.shijiData = {}


	-- 记录双倍充值
	self.shuangbei = {}
	for i=1,#saleConfig do
		self.shuangbei[i] = 0
	end

	self.ronglianShop = {}


	self.qiyu = {}
	self.fuchou = {}
end

return model_marketManager
