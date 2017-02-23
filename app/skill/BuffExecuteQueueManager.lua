--
-- Author: Li yang
-- Date: 2014-08-20 09:32:09
-- buff效果执行管理
--[[
	主要用于单个角色先后执行多个buf效果
]]


local BuffExecuteQueueManager = class("BuffExecuteQueueManager", cc.Node)

BuffExecuteQueueManager.FinishCallBack = nil;



function BuffExecuteQueueManager:ctor()
	self.buffEffectData = {};
	self.buffCount = 0;
	self.CurrentPos = 1;
	self.ExecuteMark = false;

    
end

--[[添加执行buf数据
	
]]
function BuffExecuteQueueManager:addExecuteBuffData( params )
	self.buffCount = self.buffCount + 1;
	self.buffEffectData[self.buffCount] = params;
end

function BuffExecuteQueueManager:ExecuteBuff( )
	self.ExecuteMark = true;
	--注册监听函数
    -- self:scheduleUpdateWithPriorityLua(handler(self, self.UpData),0)
    local delay_1 = cc.DelayTime:create(0.1);
    local callfun = cc.CallFunc:create(handler(self, self.UpData))
    local seqaction = cc.Sequence:create(delay_1,callfun);
    self:runAction(cc.RepeatForever:create(seqaction));
end

function BuffExecuteQueueManager:ExecuteBuffLogic(  )

	if not self.ExecuteMark then
		return;
	end
	local currentData = self.buffEffectData[self.CurrentPos];
	if not currentData then
		self:stopAllActions();
		--执行完毕
		if self.FinishCallBack then
			self.FinishCallBack();
		end
		self.ExecuteMark = false;
		-- 去除所有
		self:removeFromParent();
		print("BuffExecuteQueueManager 执行结束")
		return;
	end
	self.ExecuteMark = false;
	--创建buff效果
	local skill = SkillManager:CreateSkillBuf( {
		config = currentData,
		callback = function ( ... )
			print("BuffExecuteQueueManager 执行完成一个buf:",currentData.bufID)
			self.CurrentPos = self.CurrentPos + 1;
			self.ExecuteMark = true;
		end
	} )
	
end

-- 更新函数
function BuffExecuteQueueManager:UpData(dt)
	self:ExecuteBuffLogic(  );
    
end


-- 设置完成回调函数
function BuffExecuteQueueManager:setFinishCallBack(callbackfunction)
	self.FinishCallBack = callbackfunction;
end

return BuffExecuteQueueManager;
