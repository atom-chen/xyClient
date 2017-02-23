--
-- Author: Li yang
-- Date: 2015-03-2 09:32:09
-- 施法聚焦效果

local Effect_CastFocus = class("Effect_CastFocus", cc.Node)

Effect_CastFocus.FinishCallBack = nil;

------- 参数 --------
Effect_CastFocus.startPoint_x = 0;
Effect_CastFocus.startPoint_y = 0;

Effect_CastFocus.endPoint_x = 0;
Effect_CastFocus.endPoint_y = 0;

Effect_CastFocus.speed = 30;-- 速度
Effect_CastFocus.angle = 0 ;--两点间角度
Effect_CastFocus.runTime = 1;--运行时间


function Effect_CastFocus:ctor()
	
end



--[[设置效果数据
	params = {
		dataType = 0,
		target = nil, -- 作用的目标(此目标必须是 actorview 类型)
		attackAim = nil,--- 攻击目标
		camp = 1, --阵营
		callback = nil, -- 结束回调函数
	}
]]
function Effect_CastFocus:setData( params )
	self.DataType = 0;
	self.IsShowTemplate = params.isshowTemplate or 0;
	self.Release = params.target;--施法者
	self.Aim = params.attackAim;--目标
	self.ReleaseCamp = params.camp;--施法者阵营
	-- self.AimCamp = params.aimCamp;--目标阵营
	-- self.ScaleValuse = self.Release.ScaleValuse;--施法者大小

	self.CONST_SCALE = 1.3;
	--设置施法者zorder
	self.Release:setActorLocalZOrder(ManagerBattle.CONST_COMBAT_ORDER);

	local releasepos =  self.Release.showObject:convertToWorldSpace(cc.p(0,0)); --施法者位置
	self.startPoint_x = releasepos.x - display.cx;
	self.startPoint_y = releasepos.y - display.cy;
	-- Data_Battle.mapData:getNodeLayerToWordSpace( self.Release:getActorPos());
	-- self.endPoint_x ,self.endPoint_y = self.Aim:getPosition(); --目标位置

	print("Effect_CastFocus:setData",self.startPoint_x ,self.startPoint_y);

	self.speed = params.speed or EffectManager.EFFECT_CONST_FLY_SPEED;

	--两点距离 得到速度 和角度
	-- local ccpsubValuse = ccp(self.endPoint_x - self.startPoint_x,
	--  self.endPoint_y - self.startPoint_y);
	-- local dist = ccpLength(ccpsubValuse) -- ccpSub(v1, v2)
	-- self.runTime = dist / self.speed;-- 时间
	-- self.angle = 90 - ccpToAngle(ccpsubValuse)*180/math.pi;--两点间角度

	--数据解析
	self.Card_W = 50;
	self.Card_H = 50;

	self:getActionLogic(  );
	-- 创建攻击效果
	self:EffectAction(  );
end

--[[设置效果数据
	params = {
		dataType = 1;-- 0 setData 1 setData_1
		camp = 1, --阵营
		cast_x = 0,
		cast_y = 0,
		rect_w = 1,
		rect_h = 1,
		isshowTemplate = 0,
		callback = nil, -- 结束回调函数
	}
]]
function Effect_CastFocus:setData_1( params )
	self.DataType = 1;
	self.IsShowTemplate = params.isshowTemplate or 0;
	self.Release = nil;--施法者
	self.Aim = nil;--目标
	self.ReleaseCamp = params.camp;--施法者阵营

	self.CONST_SCALE = 1.3;

	-- self.Release:setZOrder(ManagerBattle.CONST_COMBAT_ORDER);

	self.startPoint_x = params.cast_x - display.cx;
	self.startPoint_y = params.cast_y - display.cy; --施法者位置


	--数据解析
	self.Card_W = 50;
	self.Card_H = 50;

	self:getActionLogic(  );
	-- 创建攻击效果
	self:EffectAction(  );
end

--[[设置效果数据
	添加黑色模板
]]
function Effect_CastFocus:setData_2(  )
	local colorlayer = cc.LayerColor:create(cc.c4b(0, 0, 0, 188), display.width, display.height)
	self:addChild(colorlayer)
end

function Effect_CastFocus:getActionLogic(  )
	--左边距离
	local left_distance = math.abs(-display.width / 2 - self.startPoint_x);
	--右边距离
	local right_distance = math.abs(display.width / 2 - self.startPoint_x);
	--下边距
	local bottom_distance = math.abs( -display.height / 2 - self.startPoint_y);
	--上边距
	local top_distance = math.abs( display.height / 2 - self.startPoint_y);

	-----放大后的距离
	--左边距离
	local change_left_distance = left_distance * self.CONST_SCALE;
	--右边距离
	local change_right_distance = right_distance * self.CONST_SCALE;
	--下边距
	local change_bottom_distance = bottom_distance * self.CONST_SCALE;
	--上边距
	local change_top_distance = top_distance * self.CONST_SCALE;

	print(left_distance,right_distance,bottom_distance,top_distance)

	--------得到焦点位置--------
	self.Fouce_x = self.startPoint_x;
	self.Fouce_y = self.startPoint_y;

	--------根据阵营得到参照标示点---------
	if self.ReleaseCamp ==  Data_Battle.CONST_CAMP_PLAYER then
		self.Mark_x = -display.width / 2 / 2;
		self.Mark_y = 0;
	else
		self.Mark_x = display.width / 2 / 2;
		self.Mark_y = 0;
	end
	-- self.Mark_x = 0;
	-- self.Mark_y = 0;

	-------根据参照标示点得到移动的方向----------
	--[[
		方向分为
		direction_x
		direction_y
	]]
	self.direction_x = -1;
	if self.startPoint_x <= self.Mark_x then
		self.direction_x = 1;
	end
	self.direction_y = -1;
	if self.startPoint_y <= self.Mark_y then
		self.direction_y = 1;
	end
	print(self.Mark_x ,self.Mark_y,self.direction_y)

	--移动的到的位置
	self.Move_x = 0;
	self.Move_y = 0;
	local canzhao_distance = math.abs(self.startPoint_x);
	if self.direction_x == 1 then
		if canzhao_distance < change_left_distance - left_distance then
			self.Move_x = canzhao_distance;
		else
			self.Move_x = change_left_distance - left_distance;
		end
	else
		if canzhao_distance < change_right_distance - right_distance then
			self.Move_x = canzhao_distance * self.direction_x;
		else
			self.Move_x = (change_right_distance - right_distance) * self.direction_x;
		end
	end

	canzhao_distance = math.abs(self.startPoint_y - self.Mark_y)
	if self.direction_y == 1 then
		if canzhao_distance < change_bottom_distance - bottom_distance then
			self.Move_y = canzhao_distance;
		else
			self.Move_y = change_bottom_distance - bottom_distance;
		end
	else
		if canzhao_distance < change_top_distance - top_distance then
			self.Move_y = canzhao_distance * self.direction_y;
		else
			self.Move_y = (change_top_distance - top_distance) * self.direction_y;
		end
	end
	print("更新焦点：",self.Fouce_x , self.Fouce_y,self.Move_x,self.Move_y ,CONFIG_SCREEN_WIDTH ,CONFIG_SCREEN_HEIGHT,self.startPoint_x ,self.startPoint_y)
	----更新焦点
	battleShowManager:UpdataAnchorPoint(  self.Fouce_x , self.Fouce_y )

end


function Effect_CastFocus:EffectAction()
	--[[效果说明
		一个打击动画
	]]
	--移动动作
	local a_scale = cc.ScaleTo:create(0.3 * EffectManager.EFFECT_TRIMMING_VALUSE, self.CONST_SCALE);
	local a_move = cc.MoveBy:create(0.3 * EffectManager.EFFECT_TRIMMING_VALUSE, cc.p(self.Move_x, self.Move_y));
	local a_callfunc = cc.CallFunc:create(function (  )
		-- print("缩放结束")
		if self.FinishCallBack then
			self.FinishCallBack();
		end
		-- self:removeFromParentAndCleanup(true);
	end)
	local a_spawn = cc.Spawn:create(a_scale, a_move);

	local runaction = cc.Sequence:create(a_spawn, a_callfunc);

	-- local runaction = CCSequence:createWithTwoActions(a_spawn, a_callfunc);
	-- Uniquify_Battle:FocusActionLogic( runaction );
	dispatchGlobaleEvent( "battlefield" ,"focus" ,{runaction});

	--添加一个黑色模板
	if self.IsShowTemplate == 1 then
		local colorlayer = cc.LayerColor:create(cc.c4b(0, 0, 0, 188), display.width, display.height * 2 )
		self:addChild(colorlayer)
	end
	
end

--还原动作
function Effect_CastFocus:restoreAction(  )
	--移动动作
	local a_scale = cc.ScaleTo:create(0.1, 1);
	local a_move = cc.MoveBy:create(0.1, cc.p(-self.Move_x, -self.Move_y));
	local a_callfunc = cc.CallFunc:create(function (  )
		-- print("缩放还原结束")
		battleShowManager:UpdataAnchorPoint(  0, 0 )
		if self.Release then
			self.Release:resetActorLocalZOrder(  );
		end
		self:removeFromParent();
	end)
	local a_spawn = cc.Spawn:create(a_scale, a_move);

	local runaction = cc.Sequence:create(a_spawn, a_callfunc);
	dispatchGlobaleEvent( "battlefield" ,"focus" ,{runaction});
end

function Effect_CastFocus:isShowTemplate( params )
	self:setVisible(params);
end

-- 设置完成回调函数
function Effect_CastFocus:setFinishCallBack(callbackfunction)
	self.FinishCallBack = callbackfunction;
end

return Effect_CastFocus;
