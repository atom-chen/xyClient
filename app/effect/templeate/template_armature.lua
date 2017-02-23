--
-- Author: LiYang
-- Date: 2015-07-18 10:37:53
-- 模板动画效果

local template_armature = class("template_armature",cc.Node)

function template_armature:ctor()
	self.CallBack = nil;
end

--[[ 创建动画
	parame = {
		name = "",--效果名称
		x ,
		y ,
		zorder = 0,
		isfinishdestroy
	}
]]
function template_armature:setArmatureData( parame )
	self.armatureName = parame.name;
	self.x = parame.x;
	self.y = parame.y;
	self.world_x = 0;
	self.world_y = 0;
	self.zorder = parame.zorder;
	self.IsFinishDestory = parame.isfinishdestroy;
	local armatureinfo = ResConfig[parame.name]
    print("template_armature:setArmatureData",parame.name)
	--加载动画
	ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(parame.name)

    self.armatureView = ccs.Armature:create(armatureinfo.animation_name)
    -- armature:getAnimation():play("idle")
    self:addChild(self.armatureView)

    
	--注册播放监听
	local function animationEvent(armatureBack,movementType,movementID)
        if movementType == ccs.MovementEventType.loopComplete then

        elseif movementType == ccs.MovementEventType.complete then
        	if self.CallBack then
	        	self.CallBack("AnimationEvent",self.armatureName,movementType ,self,movementID);
	        end
        	if self.IsFinishDestory then
        		self:removeFromParent();
        	end
        elseif movementType == ccs.MovementEventType.start then

        end
        -- print("animationEvent",self.CallBack,armatureBack,movementType,movementID)
       
        
    end
    self.armatureView:getAnimation():setMovementEventCallFunc(animationEvent)

    local function onFrameEvent( bone,evt,originFrameIndex,currentFrameIndex)
    	local eventtype , eventinfo= EffectManager:analysisEventType( evt );
    	if eventtype == "create" then
    		--继续创建
    		--坐标转换
    		print( eventinfo ,self.zorder)
            local locationInNode = self:convertToWorldSpace(cc.p(0,0)) --self:getPosition()
            local show_x,show_y = Data_Battle.mapData:getWorldToNodeLayerSpace( locationInNode.x,locationInNode.y )
            print(show_x,show_y)
    		EffectManager:CreateDecorateArmature( {
    			index = eventinfo,
    			x = show_x,
    			y = show_y,
    			zorder = self.zorder,
    		} )
    	else
    		if self.CallBack then
	    		self.CallBack("FrameEvent",self.armatureName,evt,self);
	    	end
    	end
    	
    end
    self.armatureView:getAnimation():setFrameEventCallFunc(onFrameEvent)

    self.armatureView:setVisible(true);
    --得到坐标位置
	-- local x ,y= Data_Battle.mapData:getMapToWorldTransform( self.Map_x ,self.Map_y );
	self:setPosition(cc.p(self.x ,self.y));
	self:setLocalZOrder(self.zorder);
end

--[[播放效果
	id
	speed 时间
	isloop 是否循环
]]
function template_armature:playAnimationByID( id ,speed ,isloop)
	if self.armatureView then
		self.armatureView:setVisible(true);
		self.armatureView:getAnimation():play(id , -1 ,isloop or 1);
		self.armatureView:getAnimation():setSpeedScale(speed or 1);
	end
end

function template_armature:playAnimationsByID( id ,speed ,isloop)
    if self.armatureView then
        self.armatureView:setVisible(true);
        self.armatureView:getAnimation():playWithNames(id , -1 ,isloop or 1);
        self.armatureView:getAnimation():setSpeedScale(speed or 1);
    end
end

function template_armature:getBoneObject( bonename )
    return self.armatureView:getBone(bonename);
end

--设置回调函数
function template_armature:setCallback( callfun )
	self.CallBack = callfun;
end

return template_armature;
