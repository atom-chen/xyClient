--
-- Author: LiYang
-- Date: 2015-07-08 11:41:46
-- 战场一些常用接口


--[[监听全局事件名预览
eventModleName: battle
eventName:
	actor_entrance_finish --角色入场完成finish
]]

ManagerBattle = {};

require("app.actors.ManagerActor")
--加载战斗显示控制器
import(".battleShowLayerManager")
--加载战场控制器
import(".control_combat")

import(".control_zhandouui");

--挂机
import(".controller.control_OnhookSystem");

--挑战boss
import(".controller.control_BossSystem");

--测试战场
import(".controller.control_testSystem");
--奇遇战场
import(".controller.control_QiyuSystem");

--战场控制器
import(".control_battlefield");

--战场切换控制器
import(".controller.controller_battlefieldCut").new();



-- local actorView = require("app.views.battlefield.roleview.actor_control.lua");

local control_loadbattleres = require("app.views.battlefield.control_loadbattleres.lua");

ManagerBattle.CONST_COMBAT_ORDER = 200;

-- --[[ 创建角色
-- 	params = {
-- 		herodata = nil,--英雄数据
-- 		mark = "456",-- 角色GUID
-- 		camp = 1,-- 阵营
-- 		bossmark = 0,是否是boss
-- 		frompos = 1, ,位置
-- 		map_x = 21,
-- 		map_y = 21,
-- 	}
-- ]]
-- function ManagerBattle:createActor( params)
-- 	-- local actor = actorModel.new(params);
-- 	-- actor:InitData( herodata );
-- 	-- print("创建角色数据：",actor:getCamp(),params.templateid);
-- 	-- 创建显示
-- 	local actorView = actorView.new(params);
-- 	actorView:InviData( params );
-- 	return actorView;
-- end

--创建加载战场资源
function ManagerBattle:createLoadBattleRes( data )
	local loadlogic = control_loadbattleres.new();
	loadlogic:setData(data);
end

--[[创建战前准备
]]
function ManagerBattle:CreatePrewarExecuteLogic( data ,callfun)
	local logic = require("app.views.battlefield.controller.controller_PrewarBufExecute").new();
	logic:setData( data ,callfun);
	return logic;
end

--[[创建回合前buf执行
	inningindex 局数
	boutindex 回合数
	callfun 完成回调
]]
function ManagerBattle:CreateBoutBufExecuteLogic( inningindex ,boutindex ,callfun )
	local logic = require("app.views.battlefield.controller.controller_BoutBufExecute").new();
	logic:setData( inningindex ,boutindex ,callfun);
	return logic;
end

--创建挂机战场逻辑
function ManagerBattle:CreateBattlefield_logic(  )
	
end

--[[创建离线战斗结果
]]
function ManagerBattle:CreateOffLineBattleResult(  )

	if table.nums(Data_Battle.offLineData) == 0 then
		return;
	end
	local view = require("app.views.battlefield.ui.UI_Onhook_offline").new();
	view:UpdateShowData(0,Data_Battle.offLineData);
	view:setPosition(cc.p(display.cx - 640 ,display.cy - 360));
	APP:getCurScene():addChildToLayer(LAYER_ID_NOTICE, view)
end

--[[创建快速战斗结果消息
]]
function ManagerBattle:CreateQuickFightResult( data )
	local view = require("app.views.battlefield.ui.UI_Onhook_offline").new();
	view:UpdateShowData(1,data);
	view:setPosition(cc.p(display.cx - 640 ,display.cy - 360));
	APP:getCurScene():addChildToLayer(LAYER_ID_NOTICE, view)
end
