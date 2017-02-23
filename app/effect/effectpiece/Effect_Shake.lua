--
-- Author: Li Yang
-- Date: 2014-05-26 10:20:50
-- 抖动效果

local effect_shake = class("effect_shake", cc.Node)

function effect_shake:ctor()
	-- self.rootNode = UIHelper:createUIWithLayout(self.UILayout, self);
	self.Left_pos = 0;--左边偏移
	self.Right_pos = 0; --右边偏移
	self.Top_pos = 0; --上边偏移
	self.Bottom_pos = 0; -- 下边偏移
	self.RunTime = 0; --效果运行时间
	self.view = nil;--作用效果的view
	self.FinishCallBack = nil;--完成的回调函数
	self.Offset = 0; --偏移量
	self.StartTime = 0; --动作开始时间
end

--[[ 设置掉落数据
	params = {
		view = nil, --
		offset = 3,--偏移量
		runtime = 2,
		finishCallBack = nil,
	}
]]
function effect_shake:setData( params )
	
	self.view = params.view;--作用效果的view
	self.FinishCallBack = params.finishCallBack;--完成的回调函数
	self.Offset = params.offset; --偏移量
	-- print("是否死亡-->",self.view.actorModel:isDead());
	self.record_x = self.view:getPositionX();
	self.record_y = self.view:getPositionY();
	self.Left_pos = self.record_x - self.Offset;--左边偏移
	self.Right_pos = self.record_x + self.Offset; --右边偏移
	self.Top_pos = self.record_y + self.Offset; --上边偏移
	self.Bottom_pos = self.record_y - self.Offset; -- 下边偏移
	-- 执行效果
	-- self:EffectAction();
	math.randomseed(os.time())
	if self.RunTime > 0 then
		if self.RunTime > params.runtime then
			
		else
			self.RunTime = params.runtime;
		end
	else
		self.RunTime = params.runtime; --效果运行时间
		self:scheduleUpdateWithPriorityLua(handler(self, self.update),0)
	end
end

function effect_shake:setShackeTime( time )
	if self.RunTime > 0 then
		if self.RunTime > time then
			
		else
			self.RunTime = time;
		end
	else
		self.RunTime = time; --效果运行时间
		self:scheduleUpdateWithPriorityLua(handler(self, self.update),0)
	end
end


--[[
	随机位置
]]
function effect_shake:fgRangeRand(min ,max)
	
    local rnd = math.random(min ,max) 
    return rnd;
end

function effect_shake:update( time )
	-- print("update:",time)
	local LenthValuse = self:fgRangeRand( 0, self.Offset );
	local angleValuse = self:fgRangeRand(0 ,360);
	local randx = LenthValuse * math.cos(math.rad(angleValuse));  
    local randy = LenthValuse * math.sin(math.rad(angleValuse));
    -- print(randx,randy,time)
	self.view:setPosition(cc.pAdd(cc.p(self.record_x, self.record_y), cc.p(randx, randy)));
	self.RunTime = self.RunTime - time;
	if self.RunTime < 0 then
		print("update:","=========================")
		self:unscheduleUpdate();
		if self.FinishCallBack then
		 	self.FinishCallBack( )
		end
		self.view:setPosition(cc.p(self.record_x, self.record_y));
		-- self:removeFromParentAndCleanup(true);
	end
end

function effect_shake:ClearEffect(  )
	self:unscheduleUpdate();
	ShakeEffectPool[self] = nil;
end

function effect_shake:EffectAction()
	-- 效果说明
	--[[
		抖动效果 
	]]
	local moveleft = cc.MoveTo:create(0.02 * EffectManager.EFFECT_TRIMMING_VALUSE,ccp(self.Left_pos, self.record_y) );
	local moveright = cc.MoveTo:create(0.02 * EffectManager.EFFECT_TRIMMING_VALUSE,ccp(self.Right_pos, self.record_y) );
	local movetop = cc.MoveTo:create(0.02 * EffectManager.EFFECT_TRIMMING_VALUSE,ccp(self.record_x, self.Top_pos) );
	local movebottom = cc.MoveTo:create(0.02 * EffectManager.EFFECT_TRIMMING_VALUSE,ccp(self.record_x, self.Bottom_pos) );


	local SequenceAction = cc.Sequence:create(moveleft, moveright ,movetop ,movebottom);
	local RepeatAction = cc.Repeat:create(SequenceAction, 10000);
	self.ShakeAction = RepeatAction;
	self.view:runAction(RepeatAction);

	self.StartTime = os.time();

	local delay_1 = cc.DelayTime:create(self.RunTime);
	local CallBack = cc.CallFunc:create(function (  )
		if self.FinishCallBack then
		 	self.FinishCallBack( )
		end
		self.view:stopAction(self.ShakeAction);
		self.view:setPosition(ccp(self.record_x, self.record_y));
		self:removeFromParentAndCleanup(true);
	end)
	self:runAction(cc.Sequence:create(delay_1, CallBack));

end

-- 设置完成回调函数
function effect_shake:setFinishCallBack(callbackfunction)
	self.FinishCallBack = callbackfunction;
end

return effect_shake;
