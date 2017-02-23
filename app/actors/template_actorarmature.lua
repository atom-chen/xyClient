--
-- Author: LiYang
-- Date: 2015-07-18 10:37:53
-- 模板角色动画效果

local template_actorarmature = class("template_actorarmature",cc.Node)

function template_actorarmature:ctor()
	self.map_x = 0;
	self.map_y = 0;
	self.CallBack = nil;
end

--[[ 创建动画
	parame = {
		name = "",--效果名称
		x ,
		y ,
	}
]]
function template_actorarmature:setArmatureData( parame )
	self.armatureName = parame.name;
	self.x = parame.x or 0;
	self.y = parame.y or 0;
	local armatureinfo = ResConfig[parame.name]
	--加载动画
	ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(parame.name)

    self.armatureView = ccs.Armature:create(armatureinfo.animation_name)
    -- armature:getAnimation():play("idle")
    self:addChild(self.armatureView)
    print(parame.name,self.x,self.y)

	--注册播放监听
	local function animationEvent(armatureBack,movementType,movementID)
        -- local id = movementID
        -- if movementType == ccs.MovementEventType.loopComplete then
        --     -- print("ccs.MovementEventType.loopComplete");
        -- elseif movementType == ccs.MovementEventType.complete then
        --     print("ccs.MovementEventType.complete");
        --     -- self.actorModel:ListenAnimationEvent(movementID)
           
        -- elseif movementType == ccs.MovementEventType.start then
        --     print("ccs.MovementEventType.start");
        -- end
        -- print("animationEvent",self.CallBack,armatureBack,movementType,movementID)
        if self.CallBack then
        	self.CallBack("AnimationEvent",self.armatureName,movementType ,self);
        end
        
    end
    self.armatureView:getAnimation():setMovementEventCallFunc(animationEvent)

    local function onFrameEvent( bone,evt,originFrameIndex,currentFrameIndex ,self)
    	if self.CallBack then
    		 self.CallBack("FrameEvent",self.armatureName,evt);
    	end
       
    end
    self.armatureView:getAnimation():setFrameEventCallFunc(onFrameEvent)

    self.armatureView:setVisible(true);
    --得到坐标位置
	-- local x ,y= Data_Battle.mapData:getMapToWorldTransform( self.Map_x ,self.Map_y );
	self:setPosition(cc.p(self.x ,self.y));
end

--[[播放效果
	id
	speed 时间
	isloop 是否循环
]]
function template_actorarmature:playAnimationByID( id ,speed ,isloop)
	if self.armatureView then
		self.armatureView:setVisible(true);
		self.armatureView:getAnimation():play(id , -1 ,isloop or 1);
		self.armatureView:getAnimation():setSpeedScale(speed or 1);
	end
end

--设置回调函数
function template_actorarmature:setCallback( callfun )
	self.CallBack = callfun;
end

return template_actorarmature;
