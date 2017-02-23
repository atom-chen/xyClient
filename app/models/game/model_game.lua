--
-- Author: lipeng
-- Date: 2015-06-12 18:59:30
-- 游戏数据

local model_shopSystemClass = import(".model_shopSystem")
local model_chatSystemClass = import(".chatSystem.model_chatSystem")

local model_game = class("model_game")

model_game.instance = nil

function model_game:ctor()
	self._shopSystem = model_shopSystemClass.new()
	self._chatSystem = model_chatSystemClass.new()
end


function model_game.getInstance()
	if model_game.instance == nil then
		model_game.instance = model_game.new()
	end

	return model_game.instance
end


function model_game:getShopSystem()
	return  self._shopSystem
end

function model_game:getChatSystem()
	return self._chatSystem
end


GAME_MODEL = model_game.getInstance()


return model_game

