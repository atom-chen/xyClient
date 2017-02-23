--
-- Author: LiYang
-- Date: 2015-07-18 09:56:04
-- buf控制器

local bufControl = class("bufControl",cc.Node)

function bufControl:ctor()

	self.registerConfig = {
		--初始化数据
		-- {"battle","actor_entrance_finish",1},
	}
	self:register_event();

	self.aim = nil;--提示技能的对象
	self.runTime = 1;--运行的时间
	self.numericeBufEffect = {};
end

--注册事件
function bufControl:register_event(  )
	local defaultCallbacks = {
		battle_actor_entrance_finish = handler(self, self.event_heroEntranceFinish),
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

--[[设置效果数据
	params = {
		aim = nil,--buff作用目标
		skillID = nil,--buffID
	}
]]
function bufControl:setBufData( params )
	self.aim =  params.aim;
	self.BuffType =  params.skillID;
	self.bufConfig = GetBuff(params.skillID);
	self:CreateBufEffect(  );
end

--是否显示数值buf
function bufControl:IsValuseBuff(  )
	if not self.bufConfig.CastingBufIcon then
		return false;
	end
	local count = #self.bufConfig.CastingBufIcon;
	if count < 1 then
		return false;
	end
	return true;
end



--[[创建buf效果
	1.部分效果
	2.数值buf
	3.叠加层数
	4.颜色值改变
]]
function bufControl:CreateBufEffect(  )
	--解析逻辑
	self.LogicType , self.ColorValuse , self.ishowOverlay = bufManager:analysisBufShowData( self.BuffType );

	--创建逻效果
	if self.LogicType ~= 0 then
		self.logicEffect = bufManager:CreateBufEffect( {
			aim = self.aim,--目标
			effecttype = self.LogicType,--效果类型
			} );
	end

	--判读是否有颜色值改变
	if self.ColorValuse then
		
	end
	--判断是否显示叠加值

	--判断是否显示数值buf
	if self:IsValuseBuff(  ) then
		for i,v in ipairs(self.bufConfig.CastingBufIcon) do
			self.numericeBufEffect[i] =  bufManager:CreateNumericeBufEffect( {
				aim = self.aim, --目标
				icon = v,--效果类型
				} );
		end
	end
	
end

--buf叠加处理
function bufControl:BuffOverlayEffect(  )
	--更新叠加效果 
	if self.OverlayShow and self.bufConfig.max_overlap > 1 and self.bufConfig.OverlapName then -- self.bufConfig and
		--计算叠加层数
		self.OverlayCount = self.OverlayCount + 1;
		if self.OverlayCount > self.bufConfig.max_overlap then
			self.OverlayCount = self.bufConfig.max_overlap;
		end
		self.OverlayShow:setData( self.OverlayCount );
		-- self.OverlayShow:setString(self.bufConfig.OverlapName.." x"..self.OverlayCount);
	end
	-- if self.BuffType == self.CONST_VALUSEBUFF_1520 or self.BuffType == self.CONST_VALUSEBUFF_1517 or self.BuffType == self.CONST_VALUSEBUFF_1501 then
	-- 	self.OverlayShow:setString("<"..self.OverlayCount);
	-- end
end

--退出效果
function bufControl:ExitEffect(  )
	if self.FinishCallBack then
		self.FinishCallBack();
	end
	--取消数值buff提示
	if #self.numericeBufEffect > 0 then
		for i,v in ipairs(self.numericeBufEffect) do
			self.aim:removeNumericeBufEffect(v);
			v:removeFromParent();
		end
	end
	--取消角色颜色改变
	-- if self.ColorPos > 0 then
	-- 	self.aim:RemoveRoleImageColor( self.ColorPos );
	-- end
	-- if self.bufConfig.max_overlap > 1 and self.bufConfig.OverlapName then
	-- 	self.aim:setUseBufOverlayPosMark( self.OverlayPos ,0 );
	-- end

	-- if self.LogicType > 0 then
	-- 	self.aim:ArmatureStateDisplay( self.LogicType , false );
	-- end
	self:remove_event();
	self:removeFromParentAndCleanup(true);

end

--设置完成回调函数
function bufControl:setFinishCallback( callfun )
	self.FinishCallback = callfun;
end

--注册关闭事件
function bufControl:remove_event(  )
	--清除事件监听
	for k,v in pairs(self.eventlisen) do
		GLOBAL_EVENT_DISPTACHER:removeEventListener(v);
	end
end


return bufControl;
