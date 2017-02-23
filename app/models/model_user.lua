--
-- Author: lipeng
-- Date: 2015-06-12 18:59:23
-- 用户数据

local model_playerClass = import(".player.model_player")


local model_user = class("model_user")

model_user.instance = nil


function model_user:ctor()
	self.player = model_playerClass.new()
end


function model_user.getInstance()
	if model_user.instance == nil then
		model_user.instance = model_user.new()
	end

	return model_user.instance
end


USER = model_user.getInstance()
MAIN_PLAYER = USER.player

return model_user
