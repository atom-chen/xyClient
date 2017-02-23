--
-- Author: LiYang
-- Date: 2015-07-07 10:58:40
-- 角色表现模板类

local actorview_template = class("actorview_template", cc.load("mvc").ViewBase)



function actorview_template:ctor(  )
	-- cc.bind(self, "stateMachine")
	-- self.actorModel = actorModel;
	--创建层级
	self.effectLayer_0 = cc.Node:create();
	self:addChild(self.effectLayer_0, 0);

	self.effectLayer_1 = cc.Node:create();
	self:addChild(self.effectLayer_1, 1);

	self.effectLayer_2 = cc.Node:create();
	self:addChild(self.effectLayer_2, 2);

	self.effectLayer_3 = cc.Node:create();
	self:addChild(self.effectLayer_3, 3);

	--效果对象
	-- self:setActorShowView();
	-- self.Map_x = self.actorModel.Map_x;
	-- self.Map_y = self.actorModel.Map_y;
	self.ListenerFun = {};

	self.colorEffectValuse = cc.c3b(255, 255, 255);
end

--添加显示对象
function actorview_template:addShowObject( object , layer )
	if layer == 0 then
		self.effectLayer_0:addChild(object)
	elseif layer == 1 then
		self.effectLayer_1:addChild(object)
	elseif layer == 2 then
		self.effectLayer_2:addChild(object)
	else
		self.effectLayer_3:addChild(object)
	end
end


--清空所有效果
function actorview_template:releaseAllObject(  )
	self.effectLayer_0:removeAllChildren();
	self.effectLayer_1:removeAllChildren();
	self.effectLayer_2:removeAllChildren();
	self.effectLayer_3:removeAllChildren();
end

--[[播放动画
	id 播放的ID
	speed 播放的速度
	isloop 是否循环播放
	finishcallback 完成回调
]]
function actorview_template:playAnimationByID( id ,speed ,isloop)
	if id == "idle" then
		self:playAnimation_Idle();
	elseif id == "entrance" then
		self:playAnimation_Entrance();
	elseif id == "skill_1" then
		self:playAnimation_Skill_1();
	elseif id == "skill_2" then
		self:playAnimation_Skill_2();
	elseif id == "die" then
		self:playAnimationDie();
	elseif id == "behit" then
		self:playAnimation_Behit();
	elseif id == "shanbi" then
		self:playAnimation_Shanbi();
	end
end

--执行move动作
function actorview_template:exexuteMoveAction( x , y ,time)
	self:playAnimationMoveEffect( x , y ,time)
end

--设置颜色值效果
function actorview_template:setColorEffect( color )
	print("actorview_template:setColorEffect",self.effectLayer_1:getChildrenCount());
	local nodelist = self.effectLayer_1:getChildren();
	for k,v in pairs(nodelist) do
		v:setCascadeColorEnabled(true);
		v:setColor(color);
	end
	--颜色效果值
	self.colorEffectValuse = color;
end

function actorview_template:setCurrentColorEffect( object )
	object:setCascadeColorEnabled(true);
	object:setColor(self.colorEffectValuse);
end

--设置角色是否镜像
function actorview_template:setActorFlippedX( isfix )
	if isfix then
		self.effectLayer_1:setScaleX(-1);
	else
		self.effectLayer_1:setScaleX(1);
	end
end


--[[设置角色动作监听
	id 动作类型
	callfun 回调函数
]]
function actorview_template:setAnimationListen( id ,callfun )
	self.ListenerFun[id] = callfun;
	print("setAnimationListen",self.ListenerFun[id],id)
end

function actorview_template:releaseActorArmatureRes( armature )
	
end

return actorview_template;
