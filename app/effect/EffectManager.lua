--
-- Author: LiYang
-- Date: 2015-07-18 09:48:22
-- 效果管理类

--[[ 效果设计模板原则
	1.生命周期完全自己控制
	2.要有完成回调
	3.要有资源配置文件对资源进行管理
	4.涉及有层级管理的效果,应该独立一个效果配置文件来连接效果(现行办法在效果编辑器用帧事件来控制连接)
	5.效果分类 {
		原则 根据主次关系
		1.逻辑控制效果即(主效果)
		2.装饰效果(装饰效果一般情况只创建一个动画)
	}
]]

--[[ 效果模板设计原则
	1. 事件类型
		blow 打击事件(用于技能效果)
	 	hurt 伤害事件
	 	finish 完成事件
	 	create 创建事件(主要是为了来创建装饰效果)
	2."template_armature" 为效果入口模板
	3.
]]

--[[效果模板
	1.被动buf模板 无动作(skilleffect_dq_2)
]]

--加载模板
import(".EffectConfig")
import(".bufeffect.bufManager")
local classtemplate_armature = import(".templeate.template_armature")

EffectManager = {};

-- 创建效果方法
EffectManager.CreateEffect = {};

--效果常量参数
---------------------------效果常量值即体验微调值-----------------------------
-- 飞行速度(一些飞行的默认速度)
EffectManager.EFFECT_CONST_FLY_SPEED = 1400;
EffectManager.EFFECT_CONST_INTERVAL_MIN_TIME = 0.1;
-- 反伤效果
EffectManager.ThornsConfig_Zoom_Time = 0.2;--反伤放大时间
EffectManager.ThornsConfig_Animation_Time = 1;--反伤动画运行时间

--动作微调值
EffectManager.EFFECT_TRIMMING_VALUSE = 1;

--震动调整值 角色震动调整值
EffectManager.SHAKE_ADJUST_0 = 10;
EffectManager.SHAKE_TIME_0 = 0.3;
--震动调整值 全屏震动
EffectManager.SHAKE_ADJUST_1 = 10;
EffectManager.SHAKE_TIME_1 = 0.3;

--技能施法位置
EffectManager.SkillCastPos = {
	--阵营范围
	["campscope"] = {
		attackcamp = { x = 320 ,y = 420},
		defendcamp = { x = 960 ,y = 420},
	},
}

--[[得到施法效果位置
]]
function EffectManager:getEffectCasetPos( index ,camp )
	local posData = self.SkillCastPos[index];
	if camp == Data_Battle.CONST_CAMP_PLAYER then
		return posData.attackcamp;
	else
		return posData.defendcamp;
	end
end

--[[得到效果横排施法位置
	index 横排数
	camp 阵营
	return 对应横排中心位置(地图位置)
]]
function  EffectManager:getEffectHorizontalCasetPos( index ,camp )
	local campInfo = BattlefieldFormationPosInfo.defendCamp;
	if camp == Data_Battle.CONST_CAMP_PLAYER then
		campInfo = BattlefieldFormationPosInfo.attckCamp;
	end
	local pos = 1;
	if index == 1 then
		pos = 4;
	elseif index == 2 then
		pos = 5;
	elseif index == 3 then
		pos = 6;
	end
	return campInfo[pos];
end


--解析事件类型
function EffectManager:analysisEventType( event )
	-- print(event)
	local index = string.find(event,"_",1);
	if not index then
		return "",event;
	end
	local eventType = string.sub(event,1,index - 1);
	local info = string.sub(event,index + 1,-1);
	return eventType ,info;
end

--[[创建效果模板
	parame = {
		name = "",--效果名称
		x ,
		y ,
		zorder
		isfinishdestroy = false,--是否完成销毁
	}
]]
function EffectManager:CreateArmature( parame )
	local view = classtemplate_armature.new();
	view:setArmatureData( parame );
	return view;
end

--[[创建装饰动画
	index = "",--效果名称
	x ,
	y ,
	zorder
	isfinishdestroy = false,--是否完成销毁
]]
function EffectManager:CreateDecorateArmature( parame)
	print("CreateDecorateArmature",parame.index);
	local resdata = EffectConfig[parame.index];
	local view = classtemplate_armature.new();
	view:setArmatureData( {
		name = resdata.armature,--效果名称
		x = parame.x + resdata.x,
		y = parame.y + resdata.y,
		zorder = parame.zorder + resdata.zorder;
		isfinishdestroy = resdata.isfinishdestroy,--是否完成销毁
		} );
	view:playAnimationByID( resdata.armaturename ,nil ,-1);
	-- view:setPosition(cc.p(display.cx,display.cy))
	-- cc.Director:getInstance():getRunningScene():addChild(view);

	--添加到显示界面
	dispatchGlobaleEvent( "battleshowlayer" ,"event_addshowobject" ,{view,resdata.layer,nil});
end

--[[创建伤害提示
	params = {
		hurtType = 1, --类型(比如2暴击，1普通伤害 ,3miss )
		aim = nil , -- 目标
		valuse = 10, -- 值
		offsettime = 0,-- 等待时间
	}
]]
EffectManager.CreateHPHurtPrompt = function ( params )
	local view = require("app.effect.hurtprompt.HurtPrompt_view").new();
	view:createHurtHPShow( params );
	--添加到显示界面
	dispatchGlobaleEvent( "battleshowlayer" ,"event_addshowobject" ,{view,3,params.aim.Map_x + params.aim.Map_y});

	return view;
end

--[[创建英雄入场效果

]]
EffectManager.CreateHeroEntranceEffect = function (callback)
	local effect = require("app.effect.entrance.effectControl_HeroEntrance").new();
	-- effect:setData(params);
	effect:setFinishCallback(callback)
	print("CreateHeroEntranceEffect",tostring(effect))
	battleShowManager:addLogicbject(effect);
	-- dispatchGlobaleEvent( "battleshowlayer" ,"event_addlogicbject" ,effect);
	-- effect:EntranceLogic();
	return effect;
end

--[[创建技能提示
	params = {
		target ,--目标
		name ,--技能名称
		res ,--技能名称资源
	}
]]
EffectManager.CreateBattleSkillPrompt = function ( params ,callfun)
	local effect = require("app.actors.controller.controller_skillName").new();
	effect:setData(params);
	effect:setFinishCallback(callfun);
	dispatchGlobaleEvent( "battleshowlayer" ,"event_addlogicbject" ,effect);
	return effect;
end

--[[创建技能效果
	parame = {
		name --技能名称
		release --释放者
		releaseCamp --释放者阵营
		aimCamp --目标阵营
		aimData -- 目标
		hurtData --目标伤害数据
	}
]]
EffectManager.CreateSkillDescribe = function ( params )
	local effect = require("app.effect.skill_effect.skilleffect_describe.lua").new();
	effect:setData(params);
	return effect;
end

--[[创建技能效果
	parame = {
		name --技能名称
		release --释放者
		releaseCamp --释放者阵营
		aimCamp --目标阵营
		aimData -- 目标
		hurtData --目标伤害数据
	}
]]
EffectManager.CreateEffect[20000] = function ( params )
	local effect = require("app.effect.skill_effect.skilleffect_zj_1.lua").new();
	effect:setData(params);
	return effect;
end

--[[创建技能效果
	parame = {
		name --技能名称
		release --释放者
		releaseCamp --释放者阵营
		aimCamp --目标阵营
		aimData -- 目标
		hurtData --目标伤害数据
	}
]]
EffectManager.CreateEffect[20001] = function ( params )
	local effect = require("app.effect.skill_effect.skilleffect_zj_2.lua").new();
	effect:setData(params);
	return effect;
end

--关羽技能1
EffectManager.CreateEffect[20002] = function ( params )
	local effect = require("app.effect.skill_effect.skilleffect_gy_1.lua").new();
	effect:setData(params);
	return effect;
end

--关羽技能2
EffectManager.CreateEffect[20003] = function ( params )
	local effect = require("app.effect.skill_effect.skilleffect_gy_2.lua").new();
	effect:setData(params);
	return effect;
end


EffectManager.CreateEffect[20004] = function ( params )
	local effect = require("app.effect.skill_effect.skilleffect_zy_1.lua").new();
	effect:setData(params);
	return effect;
end

--周瑜技能2
EffectManager.CreateEffect[20005] = function ( params )
	local effect = require("app.effect.skill_effect.skilleffect_zy_2.lua").new();
	effect:setData(params);
	return effect;
end

--吕布技能1
EffectManager.CreateEffect[20006] = function ( params )
	local effect = require("app.effect.skill_effect.skilleffect_lb_1.lua").new();
	effect:setData(params);
	return effect;
end

--夏侯渊
EffectManager.CreateEffect[20007] = function ( params )
	local effect = require("app.effect.skill_effect.skilleffect_xhy_1.lua").new();
	effect:setData(params);
	return effect;
end

--夏侯渊
EffectManager.CreateEffect[20008] = function ( params )
	local effect = require("app.effect.skill_effect.skilleffect_xhy_2.lua").new();
	effect:setData(params);
	return effect;
end

--太史慈
EffectManager.CreateEffect[20009] = function ( params )
	local effect = require("app.effect.skill_effect.skilleffect_tsc_1.lua").new();
	effect:setData(params);
	return effect;
end

--太史慈
EffectManager.CreateEffect[20010] = function ( params )
	local effect = require("app.effect.skill_effect.skilleffect_tsc_2.lua").new();
	effect:setData(params);
	return effect;
end

--徐庶
EffectManager.CreateEffect[20011] = function ( params )
	local effect = require("app.effect.skill_effect.skilleffect_xs_1.lua").new();
	effect:setData(params);
	return effect;
end

--大乔
EffectManager.CreateEffect[20012] = function ( params )
	local effect = require("app.effect.skill_effect.skilleffect_dq_1.lua").new();
	effect:setData(params);
	return effect;
end

--大乔2(被动buf模板)
EffectManager.CreateEffect[20013] = function ( params )
	local effect = require("app.effect.skill_effect.skilleffect_dq_2.lua").new();
	effect:setData(params);
	return effect;
end

--法正1
EffectManager.CreateEffect[20014] = function ( params )
	local effect = require("app.effect.skill_effect.skilleffect_fz_1.lua").new();
	effect:setData(params);
	return effect;
end

--法正2
EffectManager.CreateEffect[20015] = function ( params )
	local effect = require("app.effect.skill_effect.skilleffect_fz_2.lua").new();
	effect:setData(params);
	return effect;
end

--黄月英1
EffectManager.CreateEffect[20016] = function ( params )
	local effect = require("app.effect.skill_effect.skilleffect_hyy_1.lua").new();
	effect:setData(params);
	return effect;
end

--黄月英2
EffectManager.CreateEffect[20017] = function ( params )
	local effect = require("app.effect.skill_effect.skilleffect_hyy_2.lua").new();
	effect:setData(params);
	return effect;
end

--张郃
EffectManager.CreateEffect[20018] = function ( params )
	local effect = require("app.effect.skill_effect.skilleffect_zh_1.lua").new();
	effect:setData(params);
	return effect;
end

--黄盖
EffectManager.CreateEffect[20019] = function ( params )
	local effect = require("app.effect.skill_effect.skilleffect_hg_1.lua").new();
	effect:setData(params);
	return effect;
end

--甄姬1
EffectManager.CreateEffect[20020] = function ( params )
	local effect = require("app.effect.skill_effect.skilleffect_zhenji_1.lua").new();
	effect:setData(params);
	return effect;
end

--甄姬2
EffectManager.CreateEffect[20021] = function ( params )
	local effect = require("app.effect.skill_effect.skilleffect_zhenji_2.lua").new();
	effect:setData(params);
	return effect;
end

--祝融技能 1 2
EffectManager.CreateEffect[20022] = function ( params )
	local effect = require("app.effect.skill_effect.skilleffect_zr_1.lua").new();
	effect:setData(params);
	return effect;
end

--吕蒙技能1
EffectManager.CreateEffect[20023] = function ( params )
	local effect = require("app.effect.skill_effect.skilleffect_lm_1.lua").new();
	effect:setData(params);
	return effect;
end

--吕蒙技能2
EffectManager.CreateEffect[20024] = function ( params )
	local effect = require("app.effect.skill_effect.skilleffect_lm_2.lua").new();
	effect:setData(params);
	return effect;
end

--文丑技能1
EffectManager.CreateEffect[20025] = function ( params )
	local effect = require("app.effect.skill_effect.skilleffect_wc_1.lua").new();
	effect:setData(params);
	return effect;
end

--文丑技能2
EffectManager.CreateEffect[20026] = function ( params )
	local effect = require("app.effect.skill_effect.skilleffect_wc_2.lua").new();
	effect:setData(params);
	return effect;
end

--张昭技能1
EffectManager.CreateEffect[20027] = function ( params )
	local effect = require("app.effect.skill_effect.skilleffect_zz_1.lua").new();
	effect:setData(params);
	return effect;
end

EffectManager.CreateEffect[20028] = function ( params )
	local effect = require("app.effect.skill_effect.skilleffect_zz_2.lua").new();
	effect:setData(params);
	return effect;
end

--田丰技能1
EffectManager.CreateEffect[20029] = function ( params )
	local effect = require("app.effect.skill_effect.skilleffect_tf_1.lua").new();
	effect:setData(params);
	return effect;
end

--孙尚香技能1
EffectManager.CreateEffect[20030] = function ( params )
	local effect = require("app.effect.skill_effect.skilleffect_ssx_1.lua").new();
	effect:setData(params);
	return effect;
end

--孙尚香技能2
EffectManager.CreateEffect[20031] = function ( params )
	local effect = require("app.effect.skill_effect.skilleffect_ssx_2.lua").new();
	effect:setData(params);
	return effect;
end

--于禁技能1
EffectManager.CreateEffect[20032] = function ( params )
	local effect = require("app.effect.skill_effect.skilleffect_yj_1.lua").new();
	effect:setData(params);
	return effect;
end

--于禁技能2
EffectManager.CreateEffect[20033] = function ( params )
	local effect = require("app.effect.skill_effect.skilleffect_yj_2.lua").new();
	effect:setData(params);
	return effect;
end

--黄祖技能1
EffectManager.CreateEffect[20034] = function ( params )
	local effect = require("app.effect.skill_effect.skilleffect_hz_1.lua").new();
	effect:setData(params);
	return effect;
end

--黄祖技能2
EffectManager.CreateEffect[20035] = function ( params )
	local effect = require("app.effect.skill_effect.skilleffect_hz_2.lua").new();
	effect:setData(params);
	return effect;
end

--张绣技能1
EffectManager.CreateEffect[20036] = function ( params )
	local effect = require("app.effect.skill_effect.skilleffect_zx_1.lua").new();
	effect:setData(params);
	return effect;
end

--许猪技能1
EffectManager.CreateEffect[20037] = function ( params )
	local effect = require("app.effect.skill_effect.skilleffect_xc_1.lua").new();
	effect:setData(params);
	return effect;
end

--许猪技能2
EffectManager.CreateEffect[20038] = function ( params )
	local effect = require("app.effect.skill_effect.skilleffect_xc_2.lua").new();
	effect:setData(params);
	return effect;
end

--张宝技能1
EffectManager.CreateEffect[20039] = function ( params )
	local effect = require("app.effect.skill_effect.skilleffect_zb_1.lua").new();
	effect:setData(params);
	return effect;
end

--张宝技能2
EffectManager.CreateEffect[20040] = function ( params )
	local effect = require("app.effect.skill_effect.skilleffect_zb_2.lua").new();
	effect:setData(params);
	return effect;
end

--黄忠技能1
EffectManager.CreateEffect[20041] = function ( params )
	local effect = require("app.effect.skill_effect.skilleffect_huangzhong_1.lua").new();
	effect:setData(params);
	return effect;
end

--黄忠技能2
EffectManager.CreateEffect[20042] = function ( params )
	local effect = require("app.effect.skill_effect.skilleffect_huangzhong_2.lua").new();
	effect:setData(params);
	return effect;
end

--严颜技能1
EffectManager.CreateEffect[20043] = function ( params )
	local effect = require("app.effect.skill_effect.skilleffect_yy_1.lua").new();
	effect:setData(params);
	return effect;
end

--严颜技能2
EffectManager.CreateEffect[20044] = function ( params )
	local effect = require("app.effect.skill_effect.skilleffect_yy_2.lua").new();
	effect:setData(params);
	return effect;
end

--严颜2技能1
EffectManager.CreateEffect[20045] = function ( params )
	local effect = require("app.effect.skill_effect.skilleffect_yy2_1.lua").new();
	effect:setData(params);
	return effect;
end

--严颜2技能2
EffectManager.CreateEffect[20046] = function ( params )
	local effect = require("app.effect.skill_effect.skilleffect_yy2_2.lua").new();
	effect:setData(params);
	return effect;
end

--陆逊技能1
EffectManager.CreateEffect[20047] = function ( params )
	local effect = require("app.effect.skill_effect.skilleffect_lx_1.lua").new();
	effect:setData(params);
	return effect;
end

--陆逊技能2
EffectManager.CreateEffect[20048] = function ( params )
	local effect = require("app.effect.skill_effect.skilleffect_lx_2.lua").new();
	effect:setData(params);
	return effect;
end

--黄盖2技能1
EffectManager.CreateEffect[20049] = function ( params )
	local effect = require("app.effect.skill_effect.skilleffect_hg2_1.lua").new();
	effect:setData(params);
	return effect;
end

--张宝2技能1
EffectManager.CreateEffect[20050] = function ( params )
	local effect = require("app.effect.skill_effect.skilleffect_zb_1.lua").new();
	effect:setData(params);
	return effect;
end

--张宝2技能2
EffectManager.CreateEffect[20051] = function ( params )
	local effect = require("app.effect.skill_effect.skilleffect_zb_2.lua").new();
	effect:setData(params);
	return effect;
end

--黄祖2技能1
EffectManager.CreateEffect[20052] = function ( params )
	local effect = require("app.effect.skill_effect.skilleffect_hz2_1.lua").new();
	effect:setData(params);
	return effect;
end

--黄祖2技能2
EffectManager.CreateEffect[20053] = function ( params )
	local effect = require("app.effect.skill_effect.skilleffect_hz2_2.lua").new();
	effect:setData(params);
	return effect;
end

--祝融2技能 1 2
EffectManager.CreateEffect[20054] = function ( params )
	local effect = require("app.effect.skill_effect.skilleffect_zr2_1.lua").new();
	effect:setData(params);
	return effect;
end

--张绣2技能1
EffectManager.CreateEffect[20055] = function ( params )
	local effect = require("app.effect.skill_effect.skilleffect_zx2_1.lua").new();
	effect:setData(params);
	return effect;
end

--于禁2技能1
EffectManager.CreateEffect[20056] = function ( params )
	local effect = require("app.effect.skill_effect.skilleffect_yj2_1.lua").new();
	effect:setData(params);
	return effect;
end

--于禁2技能2
EffectManager.CreateEffect[20057] = function ( params )
	local effect = require("app.effect.skill_effect.skilleffect_yj2_2.lua").new();
	effect:setData(params);
	return effect;
end

-----------------------------------一些效果片-------------------------------------------

--[[创建计时效果
	params 计时值
]]
function EffectManager.CreatePiece_Timer( params )
	local effect = require("app.effect.effectpiece.TimeEffect.lua").new();
	effect:setData(params);
	return effect;
end

--[[ 震动效果
	params = {
		view = nil, --
		offset = 3,--偏移量
		runtime = 2,
		finishCallBack = nil,
	}
]]
EffectManager.CreateShakeEffect = function ( params )
	local effect = require("app.effect.effectpiece.Effect_shake.lua").new();
	--添加到显示界面
	dispatchGlobaleEvent( "battleshowlayer" ,"event_addlogicbject" ,effect);
	effect:setData(params);
	return effect;
end

--[[震动
 	time 时间
]]
function EffectManager:CreatePiece_Shake_1( time )
	local effect = require("app.effect.effectpiece.Effect_shake_1.lua").new();
	--添加到显示界面
	dispatchGlobaleEvent( "battleshowlayer" ,"event_addshowobject" ,{effect,5,nil});
	effect:setData(time);
	return effect;
end

--[[ 战斗场景聚焦效果
	params = {
		dataType = 0,
		target = nil, -- 作用的目标(此目标必须是 actorview 类型)
		attackAim = nil,--- 攻击目标
		camp = 1, --阵营
		isshowTemplate = 0,
		callback = nil, -- 结束回调函数
	}
	params = {
		dataType = 1;-- 0 setData 1 setData_1
		camp = 1, --阵营
		cast_x = 0,
		cast_y = 0,
		rect_w = 1,
		rect_h = 1,
		isshowTemplate = 0,
		callback = nil, -- 结束回调函数
	}
]]
EffectManager.CreateCastFocusEffect = function ( params ,callback)
	local effect = require("app.effect.effectpiece.Effect_CastFocus").new();
	-- Uniquify_Battle.BattleView:addChild(effect,BattleManager.CONST_COMBAT_ORDER - 1);
	-- dispatchGlobaleEvent( "battleshowlayer" ,"event_addlogicbject" ,effect);
	dispatchGlobaleEvent( "battleshowlayer" ,"event_addshowobject" ,{effect,1 ,80})
	if params.dataType and params.dataType == 1 then
		effect:setData_1(params);
	else
		effect:setData(params);
	end
	effect:setFinishCallBack(callback)
	return effect;
end

--添加黑色模板
EffectManager.CreateCastFouseEffect_Black = function (  )
	local effect = require("app.effect.effectpiece.Effect_CastFocus").new();
	dispatchGlobaleEvent( "battleshowlayer" ,"event_addshowobject" ,{effect,1 ,80})
	effect:setData_2();
	return effect;
end