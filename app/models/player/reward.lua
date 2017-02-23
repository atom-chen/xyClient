--
-- Author: Wu Hengmin
-- Date: 2015-07-13 14:26:33
--

local reward = class("reward")

function reward:ctor()
	-- body
	self.rewardID = 1
	self.schedule = 0 -- 当前进度
	self.isComplete = false -- 是否完成
	self.fixProperty = {} -- 固定属性
end


return reward