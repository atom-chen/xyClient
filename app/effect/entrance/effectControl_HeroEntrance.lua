--
-- Author: LiYang
-- Date: 2015-07-18 09:56:04
-- 战场英雄入场效果

local effectControl_HeroEntrance = class("effectControl_HeroEntrance",cc.Node)

function effectControl_HeroEntrance:ctor()

	self.registerConfig = {
		--初始化数据
		{"battle","actor_entrance_finish",1},
		{"battlefield","exit",1},--监听战斗结束
	}
	self:register_event();
	self:EntranceLogic();
	print("effectControl_HeroEntrance",tostring(self))
end

--注册事件
function effectControl_HeroEntrance:register_event(  )
	local defaultCallbacks = {
		battle_actor_entrance_finish = handler(self, self.event_heroEntranceFinish),
		battlefield_exit = handler(self, self.event_battleover),
    }
    self.eventlisen = {};
	for i,v in ipairs(self.registerConfig) do
		local eventname = createGlobaleEventName( v[1], v[2] )
		if defaultCallbacks[eventname] then
			print("注册事件:",eventname)
			self.eventlisen[eventname] = createGlobalEventListener( v[1], v[2], defaultCallbacks[eventname], v[3] )
		end
	end
end

--入场逻辑
function effectControl_HeroEntrance:EntranceLogic(  )
	-- 
	self.count = table.nums(control_Combat.actorPool);
	print("effectControl_HeroEntrance:EntranceLogic",self.count)

	for k,v in pairs(control_Combat.actorPool) do
       	v:doEvent("event_entrance");
    end

    -- EffectManager.CreateArmatureTemple( parame )
end

function effectControl_HeroEntrance:FinishLogic(  )
	for k,v in pairs(control_Combat.actorPool) do
		v:doEvent("event_entranceover");
	end
	--销毁所有资源

end

function effectControl_HeroEntrance:setListenAnimation( listenerType,armatureName,movementType ,object)
	if listenerType == "AnimationEvent" then
		if movementType == ccs.MovementEventType.complete then
			object:removeFromParent();
			print(self.count )
			self.count = self.count - 1;
			if self.count < 1 and self.FinishCallback then
				self:FinishLogic();
				self.FinishCallback();
				self:removeFromParent();
			end
		end
	elseif listenerType == "FrameEvent" then
		--帧事件监听
	end
end

function effectControl_HeroEntrance:event_heroEntranceFinish( event )
	local object = event._usedata.sender;
	--进入等待状态
	object:doEvent("event_entranceover");
	print(tostring(self),self.count ,self.testCount)
	self.count = self.count - 1;
	if self.count < 1 and self.FinishCallback then
		-- self:FinishLogic();
		self.FinishCallback();
		self:remove_event(  );
		self:removeFromParent();
		-- self:release();
	end
end

function effectControl_HeroEntrance:event_battleover( event )
	self:remove_event(  );
	self:removeFromParent();
end

--设置完成回调函数
function effectControl_HeroEntrance:setFinishCallback( callfun )
	self.FinishCallback = callfun;
end

--注册关闭事件
function effectControl_HeroEntrance:remove_event(  )
	--清除事件监听
	for k,v in pairs(self.eventlisen) do
		GLOBAL_EVENT_DISPTACHER:removeEventListener(v);
	end
end


return effectControl_HeroEntrance;
