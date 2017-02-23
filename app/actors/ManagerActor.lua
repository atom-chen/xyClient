--
-- Author: LiYang
-- Date: 2015-07-08 11:41:46
-- 角色管理类常用接口

ManagerActor = {};

--加载模板
local classtemplate_armature = import(".template_actorarmature")

local actorModel = import(".actor_controlbase")

local actortopview = import(".actortopview")

local actorbottomview = import(".actorbottomview")

--[[创建效果模板
	parame = {
		name = "",--效果名称
		x ,
		y ,
	}
]]
function ManagerActor:CreateActorArmatureTemple( parame )
	local view = classtemplate_armature.new();
	view:setArmatureData( parame );
	return view;
end


--[[ 创建角色
	params = {
		herodata = nil,--英雄数据
		mark = "456",-- 角色GUID
		camp = 1,-- 阵营
		bossmark = 0,是否是boss
		frompos = 1, ,位置
		map_x = 21,
		map_y = 21,
	}
]]
function ManagerActor:CreateActor( params)
	-- 创建
	local actorView = actorModel.new(params);
	actorView:InviData( params );
	return actorView;
end

--[[
	创建角色view
		templeID
]]
function ManagerActor:CreateActorView( templeID )
	print("ManagerActor:CreateActorView",templeID,self.ActorViewInfo[templeID])
	-- local objectname = "app.actors.actorsview"..self.ActorViewInfo[templeID];
	local view = require("app.actors.actorsview.actor_common").new();
	return view;
end

function ManagerActor:CreateActorTopView( object )
	local topview = actortopview.new(object);
	return topview;
end

function ManagerActor:CreateActorButtonView( object )
	local buttonview = actorbottomview.new(object);
	return buttonview;
end

--角色显示配置
ManagerActor.ActorViewInfo = {
	[20000] = "actor_zhangjiao",
	[20001] = "actor_guanyu",
	[20002] = "actor_zhouyu",
	[20003] = "actor_lvbu",
	[20004] = "actor_xiahouyuan",
	[20005] = "actor_taishici",
	[20006] = "actor_common",--徐庶
	[20007] = "actor_common",--大桥
	[20008] = "actor_common",--法正
	[20009] = "actor_common",--黄月英
	[20010] = "actor_common",--张郃
}