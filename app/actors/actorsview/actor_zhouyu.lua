--
-- Author: LiYang
-- Date: 2015-07-20 11:09:43
-- 周瑜

local basetemplate = require("app.actors.actorview_template.lua")

local actor_zhouyu = class("actor_zhouyu" ,basetemplate)

function actor_zhouyu:ctor(  )
	actor_zhouyu.super.ctor(self)
end

--设置角色数据
function actor_zhouyu:setActorData( target )
	self.actorModel = target;
	self.Map_x = self.actorModel.Map_x;
	self.Map_y = self.actorModel.Map_y;
	self.ResConfig =  ManagerHeroRes:getHeroArmature( 20002 ,self.actorModel.attribute_camp );--getFrameShowData( self.actorModel.attribute_templateid )
	if self.actorModel.attribute_camp == Data_Battle.CONST_CAMP_ENEMY then
		self:setActorFlippedX( true );
	end
end


--播放等待动画
function actor_zhouyu:playAnimation_Idle(  )
	if self.idleview  then
		self.idleview:setVisible(true);
		return;
	end
	local animationInfo = getEffectConfigById( self.ResConfig.idle )
	self.idleview = EffectManager:CreateArmature( {
		name = animationInfo.armature,--效果名称
		x = 0,
		y = 0,
		zorder = self.Map_x + self.Map_y,
		isfinishdestroy = false,--是否完成销毁
	} );
	-- self.idleview.mark = tostring(k);
	--添加到显示界面
	self:addShowObject( self.idleview , 1 );
	self.idleview:playAnimationByID( animationInfo.armaturename ,nil ,-1);
	self.idleview:setCallback( handler(self, self.setListen_Idle) );
end

--播放被击动作
function actor_zhouyu:playAnimation_Behit(  )
	local animationInfo = getEffectConfigById( self.ResConfig.behit )
	self.idleview:playAnimationByID( animationInfo.armaturename ,nil ,0);
end

--播放闪避动作
function actor_zhouyu:playAnimation_Shanbi(  )
	local animationInfo = getEffectConfigById( self.ResConfig.shanbi )
	self.idleview:playAnimationByID( animationInfo.armaturename ,nil ,0);
end

--播放角色死亡
function actor_zhouyu:playAnimationDie()
	local animationInfo = getEffectConfigById( self.ResConfig.die )
	self.idleview:playAnimationByID( animationInfo.armaturename ,nil ,0);
end

--播放入场动画
function actor_zhouyu:playAnimation_Entrance(  )
	if self.idleview then
		self.idleview:setVisible(false);
	end
	local animationInfo = getEffectConfigById( self.ResConfig.entrance )
	self.entranceview = EffectManager:CreateArmature( {
		name = animationInfo.armature,--效果名称
		x = 0,
		y = 0,
		zorder = self.Map_x + self.Map_y,
		isfinishdestroy = false,--是否完成销毁
	} );
	-- self.idleview.mark = tostring(k);
	--添加到显示界面
	self:addShowObject( self.entranceview , 1 );
	self.entranceview:playAnimationByID( animationInfo.armaturename ,nil ,-1);
	-- self.entranceview:setVisible(false);
	self.entranceview:setCallback( handler(self, self.setListen_Entrance) );
	
end

--播放技能攻击动作
function actor_zhouyu:playAnimation_Skill_1(  )
	if self.idleview then
		self.idleview:setVisible(false);
	end

	local animationInfo = getEffectConfigById( self.ResConfig.skill_1 )
	self.skillview_1 = EffectManager:CreateArmature( {
		name = animationInfo.armature,--效果名称
		x = 0,
		y = 0,
		zorder = self.Map_x + self.Map_y,
		isfinishdestroy = false,--是否完成销毁
	} );
	-- self.idleview.mark = tostring(k);
	--添加到显示界面
	self:addShowObject( self.skillview_1 , 1 );
	self.skillview_1:playAnimationByID( animationInfo.armaturename ,nil ,-1);
	-- self.entranceview:setVisible(false);
	if self.ListenerFun["skill_1"] then
		self.skillview_1:setCallback( self.ListenerFun["skill_1"] );
	else
		self.skillview_1:setCallback( handler(self, self.setListen_Skill_1) );
	end
end

--技能播放结束
function actor_zhouyu:playAnimation_SkillOver_1(  )
	if self.skillview_1 then
		self.skillview_1:removeFromParent();
	end
	if self.idleview  then
		self.idleview:setVisible(true);
	end
end

function actor_zhouyu:playAnimation_Skill_2(  )
	if self.idleview then
		self.idleview:setVisible(false);
	end

	local animationInfo = getEffectConfigById( self.ResConfig.skill_2 )
	self.skillview_2 = EffectManager:CreateArmature( {
		name = animationInfo.armature,--效果名称
		x = 0,
		y = 0,
		zorder = self.Map_x + self.Map_y,
		isfinishdestroy = false,--是否完成销毁
	} );
	-- self.idleview.mark = tostring(k);
	--添加到显示界面
	self:addShowObject( self.skillview_2 , 1 );
	self.skillview_2:playAnimationByID( animationInfo.armaturename ,nil ,-1);
	-- self.entranceview:setVisible(false);
	if self.ListenerFun["skill_2"] then
		self.skillview_2:setCallback(self.ListenerFun["skill_2"]);
	else
		self.skillview_2:setCallback( handler(self, self.setListen_Skill_2) );
	end
end

--技能播放结束
function actor_zhouyu:playAnimation_SkillOver_2(  )
	if self.skillview_2 then
		self.skillview_2:removeFromParent();
	end
	if self.idleview  then
		self.idleview:setVisible(true);
	end
end

--播放移动效果
function actor_zhouyu:playAnimationMoveEffect( x , y )
	--移动位置
	local moveTo = cc.MoveTo:create(0.1 ,cc.p(x ,y));
	local callfun = cc.CallFunc:create(self.ListenerFun["move"] )
	self:runAction(cc.Sequence:create(moveTo , callfun));
end


--
function actor_zhouyu:setListen_Idle( listenerType,armatureName,movementType ,object,movementID)
	if listenerType == "AnimationEvent" then
		if movementType == ccs.MovementEventType.complete then
			if movementID == "die" then
				--隐藏角色
				self:setVisible(false);
			end
			local animationInfo = getEffectConfigById( self.ResConfig.idle )
			self.idleview:playAnimationByID( animationInfo.armaturename ,nil ,-1);
		end
	elseif listenerType == "FrameEvent" then
		--帧事件监听
	end
end

--入场动作监听
function actor_zhouyu:setListen_Entrance( listenerType,armatureName,movementType ,object,movementID)
	if listenerType == "AnimationEvent" then
		if movementType == ccs.MovementEventType.complete then
			if self.idleview then
				self.idleview:setVisible(true);
			end
			-- print("动作完成监听 == >" ,listenerType,armatureName,movementType ,object)
			--销毁动作资源
			self.entranceview:removeFromParent();
			-- release_res( self.ResConfig.entrance );
			--发送角色入场动作完成事件
			dispatchGlobaleEvent("battle", "actor_entrance_finish", {sender=self.actorModel})
		end
	elseif listenerType == "FrameEvent" then
		--帧事件监听
		if movementType == "" then
			--todo
		end
	end
end

function actor_zhouyu:setListen_Skill_1( listenerType,armatureName,movementType ,object ,movementID)
	if listenerType == "AnimationEvent" then
		if movementType == ccs.MovementEventType.complete then

		end
	elseif listenerType == "FrameEvent" then
		--帧事件监听
	end
end

function actor_zhouyu:setListen_Skill_2( listenerType,armatureName,movementType ,object ,movementID)
	if listenerType == "AnimationEvent" then
		if movementType == ccs.MovementEventType.complete then

		end
	elseif listenerType == "FrameEvent" then
		--帧事件监听
	end
end

return actor_zhouyu;