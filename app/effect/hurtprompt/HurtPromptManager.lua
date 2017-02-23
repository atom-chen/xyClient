--
-- Author: Li Yang
-- Date: 2014-08-11 11:56:12
-- 伤害提示管理类

local hurtPromptManager = class("hurtPromptManager",cc.Node);

HurtPromptManager = nil;

--伤害管理类
function hurtPromptManager:ctor()
	--创建池
	self.ObjectPool = {};


	--创建间隔时间
	self.CONSET_CONFIG_INTERVAL_TIME = 0.1;

	self.interval_Time = 0;

	self.record_Time = 0;

	--注册监听函数
	local function update(dt)
		self:CreateLogic( dt );
    end
    self:scheduleUpdateWithPriorityLua(update,0)
    -- self:unscheduleUpdate()

    HurtPromptManager = self;
end


--添加提示对象
function hurtPromptManager:AddPromptObject( params )
	print("添加伤害提示:",params.hurtType,params.valuse);
	if params.hurtType == 1 and params.valuse == 0 then
		return;
	end
	--添加提示界面
	
	local id = params.aim:getId();
	if self.ObjectPool[id] == nil then
		self.ObjectPool[id] = {};
		self.ObjectPool[id].createMark = 1;
		self.ObjectPool[id].count = 1;
		-- self.ObjectPool[id].intervalTime = 0;
		self.ObjectPool[id].promptData = {};
	end
	local index = self.ObjectPool[id].count;
	self.ObjectPool[id].count = self.ObjectPool[id].count + 1;
	self.ObjectPool[id].promptData[index] = params;

end

--创建逻辑
function hurtPromptManager:CreateLogic( dt )
	
	self.interval_Time = self.interval_Time + dt;
	if self.interval_Time < self.CONSET_CONFIG_INTERVAL_TIME then
		return;
	end
	-- print("创建间隔时间:",self.interval_Time);
	self.interval_Time = 0;
	for k,v in pairs(self.ObjectPool) do
		if v then
			local mark = v.createMark;
			local data = v.promptData[mark];
			--创建提示
			if data then
				EffectManager.CreateHPHurtPrompt(data);
				v.promptData[mark] = nil;
				v.createMark = v.createMark + 1;
			end
			
		end
	end
end

return hurtPromptManager;