--
-- Author: lipeng
-- Date: 2015-08-21 17:53:09
-- 控制器: 军团战中的玩家信息

local controler_guild_battle_player_info_node = class("controler_guild_battle_player_info_node")
local backOneCountTime = 2*60*60 --恢复一次需要时间


function controler_guild_battle_player_info_node:ctor(guild_battle_player_info_node)
	self:_initModels()

	self._guild_battle_player_info_node = guild_battle_player_info_node

	self._panel_1 = self._guild_battle_player_info_node:getChildByName("Panel_1")
	self._backTimeValue = self._panel_1:getChildByName("text_backTimeValue")
	self._lb_backTime = self._panel_1:getChildByName("lb_backTime")

	self:_backCountTimerStart()
end


function controler_guild_battle_player_info_node:_initModels()
	self._lastTime = 0
	self._remainTime = 60
end


--响应进入战场消息
function controler_guild_battle_player_info_node:_onNetMsg_EnterBattle( event )
	local UIContainer = self._panel_1
	UIContainer:getChildByName("text_attacCountValue"):setString("1/5")


	
end


--恢复时间计时器开启
function controler_guild_battle_player_info_node:_backCountTimerStart()
	local function backCountTimer(dt)
		if os.time() - self._lastTime >= 1 then
			self._lastTime = os.time()

			self._remainTime = self._remainTime - 1
			local time = TIME_HELPER:secondToTime(self._remainTime)
			self._backTimeValue:setString(
				string.format("%02d:%02d:%02d", 
					time.hour,
					time.min,
					time.sec
				)
			)

			local per = (self._remainTime / backOneCountTime) * 100

			self._lb_backTime:setPercent(per)

			if self._remainTime <= 0 then
				self._remainTime = backOneCountTime
			end
		end
        
    end

    
	self._guild_battle_player_info_node:scheduleUpdateWithPriorityLua(backCountTimer, 0)
end


return controler_guild_battle_player_info_node
