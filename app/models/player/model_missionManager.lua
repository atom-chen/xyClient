--
-- Author: Wu Hengmin
-- Date: 2015-07-07 19:39:35
--


--[[发送全局事件名预览
eventModleName: model_missionManager
eventName: 
	open_mission -- 打开任务界面
]]

local model_missionManager = class("model_missionManager")
local rewardClass = import(".reward.lua")

function model_missionManager:ctor()
	self.missions = {}
	self.dailys = {}
	self.achieves = {}
end

function model_missionManager:addMission(params)
	-- body
	local mission = rewardClass:new()
	mission.rewardID = params.ID
	printLog("新加入任务,ID:"..params.ID)
	printLog("新加入任务名称:"..Mission_BaseInfoSetup[params.ID].Caption)
	mission.fixProperty = Mission_BaseInfoSetup[mission.rewardID]
	mission.schedule = params.schedule
	if mission.fixProperty.CType1 == 2 then
		-- 竞技场排名
		if mission.schedule < 1 then
			mission.schedule = 5000
		end
		if mission.schedule > mission.fixProperty.CPara1 then
			mission.isComplete = false
			print("未完成任务")
		else
			mission.isComplete = true
			print("完成任务")
		end
	else
		if mission.schedule >= mission.fixProperty.CPara1 then
			mission.isComplete = true
		else
			mission.isComplete = false
		end
	end
	-- self.missions[mission.rewardID] = mission
	table.insert(self.missions, mission)
	return mission
end

function model_missionManager:addDaily(params)
	-- body
	local daily = rewardClass:new()
	daily.rewardID = params.ID
	print("新加入日常任务,ID:"..params.ID)
	daily.fixProperty = Mission_BaseInfoSetup[daily.rewardID]
	daily.schedule = params.schedule
	if daily.schedule >= daily.fixProperty.CPara1 then
		daily.isComplete = true
	else
		daily.isComplete = false
	end
	-- self.dailys[daily.rewardID] = daily
	table.insert(self.dailys, daily)
	return daily
end

function model_missionManager:addAchieve(params)
	-- body
	local achieve = rewardClass:new()
	achieve.rewardID = params.ID
	print("新加入成就,ID:"..params.ID)
	achieve.fixProperty = Mission_BaseInfoSetup[achieve.rewardID]
	achieve.schedule = params.schedule
	if achieve.fixProperty.CType1 == 4 then
		if achieve.schedule < 1 then
			achieve.schedule = 5001
		end
		
		if achieve.schedule > achieve.fixProperty.CPara1 then
			achieve.isComplete = false
		else
			achieve.isComplete = true
		end
	elseif achieve.fixProperty.CType1 == 37 then
		if achieve.schedule >= achieve.fixProperty.CPara2 then
			achieve.isComplete = true
		else
			achieve.isComplete = false
		end
	else
		if achieve.schedule >= achieve.fixProperty.CPara1 then
			achieve.isComplete = true
		else
			achieve.isComplete = false
		end
	end

	table.insert(self.achieves, achieve)
	return achieve
end

return model_missionManager
