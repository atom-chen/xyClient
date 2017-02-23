--
-- Author: Liyang
-- Date: 2015-06-26 17:28:09
-- 角色基类

local actor_control = class("actor_control")

-- 状态值
function actor_control:ctor(target)
	--绑定状态机
	cc.bind(self, "stateMachine")
	--绑定事件
	cc.bind(self, "event")

	self:setupState({
		events = {
			--初始化后, 进入准备状态
            {name = "event_initialize", from = "none", to = "state_idle" },
            --展示初始化
            {name = "event_initializeshow", from = "none", to = "state_idle" },
            --切换到空闲状态
            {name = "event_idle", from = "*", to = "state_idle" },
            --入场
            {name = "event_entrance", from = "*", to = "state_entrance" },
            --入场
            {name = "event_entranceover", from = "state_entrance", to = "state_idle" },
            -- 移动事件
            {name = "event_move", from = "state_idle", to = "state_idle" },
            --被击
            {name = "event_behit", from = "state_idle", to = "state_idle" },
            --闪避
            {name = "event_shanbi", from = "state_idle", to = "state_idle" },
            -- 移动事件结束
            -- {name = "event_moveover", from = "state_move", to = "state_idle" },
            -- 释放技能1
            {name = "event_cast_1", from = {"state_idle","state_move"}, to = "state_cast_1" },
            {name = "event_castover_1", from = "state_cast_1", to = "state_idle" },
            -- 释放技能2
            {name = "event_cast_2", from = {"state_idle","state_move"}, to = "state_cast_2" },
            --技能2施法结束
            {name = "event_castover_2", from = "state_cast_2", to = "state_idle" },
            -- 进入眩晕状态
            
            -- 进入混乱状态
            --隐藏
            {name = "event_hide", from = "*", to = "state_hide" },
            --退出隐藏
            {name = "event_exitHide", from = "*", to = "state_idle" },
            --死亡事件
            {name = "event_die", from = "state_idle", to = "state_die" },
            --复活事件
            {name = "event_relive", from = "state_die", to = "state_idle" },
		},
		callbacks = {
		    --初始化展示
			onevent_initializeshow = handler(self, self.onEvent_initializeshow),
			onevent_initialize = handler(self, self.onEvent_initialize),
			onevent_idle = handler(self, self.onEvent_idle),
			onevent_hide = handler(self, self.onEvent_hide),
			onevent_exitHide = handler(self, self.onEvent_exitHide),
			onevent_move = handler(self, self.onEvent_move),
			onevent_behit = handler(self, self.onEvent_behit),
			onevent_shanbi = handler(self, self.onEvent_shanbi),
			onevent_entrance = handler(self, self.onEvent_entrance),
			onevent_entranceover = handler(self, self.onEvent_entranceover),
			onevent_cast_1 = handler(self, self.onEvent_cast_1),
			onevent_castover_1 = handler(self, self.onEvent_castover_1),
			onevent_cast_2 = handler(self, self.onEvent_cast_2),
			onevent_castover_2 = handler(self, self.onEvent_castover_2),
			onevent_die = handler(self, self.onEvent_die),
			onevent_relive = handler(self, self.onEvent_relive),
		}
	});

	self.target_ = target;

	--广播一个动画完成 和 帧事件
	self.registerConfig = {
		-- {"login","event_start",1},
		-- {"login","event_createloginview",1},
		-- {"login","event_loginAccount",1},
		-- {"login","event_createregister",1},
		-- {"login","event_registeraccount",1},
		-- {"login","event_registercancel",1},
		-- {"login","event_chooseserver",1},--选择服务器
	}

	--角色属性值
	self.attribute_camp = 1; --阵营
	self.attribute_bossmark = 0; --是否是boss
	self.attribute_isdrop = 1;
	self.attribute_droptype = 1;
	self.attribute_sumhp = 1;--角色总血量
	self.attribute_currenthp = 1;--当前血量
	self.attribute_templateid = 1;--模板id
	self.attribute_formationid = 1;--阵型ID
	self.attribute_frompos = 1;--阵型位置
	self.attribute_IsZero = 1;

	--地图坐标
	self.Map_x = 0;
	self.Map_y = 0;
	--buf列表
	self.buffList = {};
	self.numericalPos = {};

	--buff叠加显示记录
    self.OverlayPos = {0,0,0,0,0,0,0,0};
    self.OverlayDisplayPos = 1;
end


--注册事件
function actor_control:register_event(  )
	local defaultCallbacks = {
        -- actor_control_start = handler(self, self.event_login),
        -- actor_control_createloginview = handler(self, self.event_CreateloginView),
        -- actor_control_loginAccount = handler(self, self.event_loginAccount),
        -- actor_control_createregister = handler(self, self.event_createRegister),
        -- actor_control_registeraccount = handler(self, self.event_registerAccount),
        -- actor_control_registercancel = handler(self, self.event_registerCancel),
        -- actor_control_chooseserver = handler(self, self.event_chooseserver),
    }
    self.eventlisen = {};
	for i,v in ipairs(self.registerConfig) do
		local eventname = createGlobaleEventName( v[1], v[2] )
		print("注册事件",eventname);
		if defaultCallbacks[eventname] then
			createGlobalEventListener( v[1], v[2], defaultCallbacks[eventname], v[3] )
		end
	end
end

function actor_control:addExecuteEvent( eventname )
	if not eventname then
		return;
	end
	for i,v in ipairs(eventname) do
		table.insert(self.registerConfig, 1, eventname)
	end
end

-------------------------------状态机函数----------------------------------

function actor_control:onEvent_initializeshow( event )
	local x = event.args[1].x or 0;
	local y = event.args[1].y or 0;
	local addnode = event.args[1].parentnode;
	--创建角色显示
	self.showObject = ManagerActor:CreateActorView( self.attribute_templateid );

	self.showObject:setActorData( self );
	addnode:addChild(self.showObject, self.Map_x + self.Map_y);
	self:onEvent_idle(  );
end

--[[ 初始化游戏
	event = {
		name ,	
		args = {

			finishCallfun = nil,--完成回调函数
		}
	}	
]]
function actor_control:onEvent_initialize( event )
	--创建角色显示
	self.showObject = ManagerActor:CreateActorView( self.attribute_templateid );
	self.showObject:setActorData( self );
	--得到坐标位置
	local x ,y= Data_Battle.mapData:getMapToWorldTransform( self.Map_x ,self.Map_y );
	-- print("onEvent_initialize",x,y)
	-- print()
	self.showObject:setPosition(cc.p(x, y));
	-- self.showObject:retain();
	self.showObject.mark = 1;
	--添加到显示界面
	dispatchGlobaleEvent( "battleshowlayer" ,"event_addshowobject" ,{self.showObject,1 ,self.Map_x + self.Map_y})

	--创建光环
	self.buttonview = ManagerActor:CreateActorButtonView( self )
	self.buttonview:createGuangHuangEffect( 4 );
	self.showObject:addShowObject( self.buttonview , 1 );
	self.buttonview:setVisible(false);

	--创建血条显示
	self.topview = ManagerActor:CreateActorTopView(self);
	self.topview:createHPShow();
	-- self.topview:retain();
	self.topview:setPosition(cc.p(x, y));
	self.topview.mark = 1;
	self.topview:setVisible(false);
	--添加到显示界面
	dispatchGlobaleEvent( "battleshowlayer" ,"event_addshowobject" ,{self.topview,3,self.Map_x + self.Map_y});
end

--重新进入初始化状态
function actor_control:onEvent_idle( event )
	--进入休闲状态
	-- self:dispatchEvent({name = "EVENT_IDLE",data = event.args});

	self.showObject:playAnimationByID("idle");
end

--隐藏状态
function actor_control:onEvent_hide( event )
	self.showObject:setVisible(false);
end

--退出隐藏状态
function actor_control:onEvent_exitHide( event )
	self.showObject:setVisible(true);
end

--进入入场
function actor_control:onEvent_entrance( event )
	self.showObject:playAnimationByID("entrance");
end

--入场结束
function actor_control:onEvent_entranceover( event )
	self.showObject:playAnimationByID("idle");
	self.buttonview:setVisible(true);
	-- self:setColorEffect( cc.c3b(255, 0, 0) );
end

--移动状态
--[[
	args {
		播放速度
		是否循环
	}
]]
function actor_control:onEvent_move(event)
	local move_x = event.args[1].x;
	local move_y = event.args[1].y;
	local listenercallfun = event.args[1].Callback
	print("actor_control:onEvent_move:",move_x ,move_y ,listenercallfun)
	self.showObject:setAnimationListen( "move" ,listenercallfun );
	self.showObject:exexuteMoveAction( move_x , move_y );
	--更新坐标
	self.Map_x ,self.Map_y = Data_Battle.mapData:getWorldToMapTransform( move_x ,move_y );
end

function actor_control:onEvent_behit( event )
	self.showObject:playAnimationByID( "behit")
end

function actor_control:onEvent_shanbi( event )
	self.showObject:playAnimationByID( "shanbi")
end

--技能施法1
function actor_control:onEvent_cast_1( event )
	local listenercallfun = event.args[1].Callback
	self.showObject:setAnimationListen( "skill_1" ,listenercallfun );
	self.showObject:playAnimationByID("skill_1");
	
end

function actor_control:onEvent_castover_1( event )
	self.showObject:playAnimation_SkillOver_1();
end

--技能施法1
function actor_control:onEvent_cast_2( event )
	local listenercallfun = event.args[1].Callback
	self.showObject:setAnimationListen( "skill_2" ,listenercallfun );
	self.showObject:playAnimationByID("skill_2");
	
end

function actor_control:onEvent_castover_2( event )
	self.showObject:playAnimation_SkillOver_2();
end

--死亡
function actor_control:onEvent_die( event )
	--清空状态
	-- self.bufList = {};
	-- self.target_:releaseAllEffect();
	-- --播放死亡动画
	-- self.target_:playAnimationByID( "die" ,nil ,-1);
	-- AudioManager.playSkillEffectSound("sound_die");--播放死亡音效
	self.showObject:playAnimationByID("die");
	self:setHpShow( false );
end




----------------------------------逻辑函数-------------------------------------

--监听动画事件
function actor_control:ListenAnimationEvent( movementID )
	--动画完成
	if self.AnimationCompleteCallFun then
		self.AnimationCompleteCallFun(movementID);
	end
end

--监听帧动画事件
function actor_control:ListenAnimationFrameEvent( evt )
	if self.AnimationFrameCallFun then
		self.AnimationFrameCallFun(evt);
	end
end

--设置动画完成监听
function actor_control:setListenAnimationComplete( callbcak )
	--设置动画完成监听
	self.AnimationCompleteCallFun = callbcak;
end

function actor_control:setListenAnimationFrameEvent( callback )
	self.AnimationFrameCallFun = callback;
end

--[[ 初始化数据
	herodata  英雄数据
	params = {
		herodata = nil,--英雄数据
		mark = "456",-- 角色GUID
		camp = 1,-- 阵营
		bossmark = 0,是否是boss
		frompos = 1, ,位置
		map_x = 21,
		map_y = 21,
	}
]]
function actor_control:InviData( params )
	-- body
	self.ActorData = params.herodata;
	self.attribute_Mark = params.mark or 1;
	self.attribute_camp = params.camp or 1; --阵营
	self.attribute_bossmark = params.bossmark or 0; --是否是boss
	self.attribute_sumhp = params.sumhp or 0;--角色总血量
	self.attribute_currenthp = params.currenthp or 0;--当前血量
	self.attribute_templateid = params.templateid;--模板id
	self.attribute_formationid = params.formationid or 1;--阵型ID
	self.attribute_frompos = params.frompos or 1;--阵型位置
	self.Map_x = params.map_x or 21;
	self.Map_y = params.map_y or 21;
    -- self:doEvent("initialize") -- 启动状态机
end

function actor_control:getId()
	return self.attribute_Mark;
end

function actor_control:getCamp()
	return self.attribute_camp;
end

function actor_control:setSumHp( values )
	self.attribute_sumhp = values;
	self.hpScale = 100 / self.attribute_sumhp;
end

--更新函数
function actor_control:updata_hp( valuse )
	self.attribute_currenthp = valuse;
	self.topview:setHpValuse( self.hpScale * valuse );
end

--[[当前血量改变
    hpvaluse 改变值
    isdead 主要是为了修正值
]]
function actor_control:UpDataCurrentHp( hpvaluse ,isdead)
    local hp = self.attribute_currenthp + hpvaluse;
    if (not isdead) and hp < 0 then
        hp = 1;
    end
    self:updata_hp(hp);
end

function actor_control:setHpShow( isshow )
	if isshow then
		self.topview:setVisible(true);
	else
		self.topview:setVisible(false);
	end
end

function actor_control:setSkillPromptShow( name )
	if name then
		self.topview:createSkillName( name );
	end
end

--添加数值buf效果
function actor_control:addNumericeBufEffect( effect )
	local pos = 0;
	for i,v in pairs(self.numericalPos) do
		if v then
			pos = pos + 1 ;
		end
	end
	if pos < 5 then
		self.numericalPos[effect] = effect;
		effect.pos = pos + 1;
		local x = 30 + (pos - 1) * 30;
		local sunLen = pos * 30;
		effect:setPosition(cc.p(x , 0))
		self.topview:createBufShow( effect ,sunLen);
	end
end

--去除数值效果
function actor_control:removeNumericeBufEffect( effect )
	if not self.numericalPos[effect] then
		return;
	end
	local removepos = self.numericalPos[effect].pos;
	self.numericalPos[effect] = nil;
	local x,y = 0,180;

	for k,v in pairs(self.numericalPos) do
		if v.pos > removepos then
			v.pos = v.pos - 1;
		end
		x = 30 + (v.pos - 1) * 30;
		effect:setPosition(cc.p(x , 0));
	end
	local count = table.nums(self.numericalPos);
	self.topview:createBufShow( nil ,count*30);
end

--[[添加颜色效果
]]
function actor_control:setColorEffect( color )
	print("actor_control:setColorEffect",self.showObject);
	if self.showObject then
		self.showObject:setColorEffect( color );
	end
end

--判断角色是否拥有buff
function actor_control:IsHaveBuff( buffid )
    for i,v in pairs(self.buffList) do
        if v and v.BuffType == buffid then
            printInfo("添加相同buf：%s", buffid);
            return v;
        end
    end
    return false;
end

--添加buff
function actor_control:AddBuff( node )
    for i,v in pairs(self.buffList) do
        if v and v.BuffType == node.BuffType then
        	printInfo("添加相同buf：%s", node.BuffType);
            return false;
        end
    end
    self.buffList[node] = node;
    self.showObject:addShowObject( node , 3 );
    printInfo("添加buff:%s",tostring(self),node.BuffType);
    return true;
end

--移除buf
function actor_control:RemoveBuff( buffType )
	print("actor_control:RemoveBuff",buffType)
    for i,v in pairs(self.buffList) do
    	print(i,v,v.BuffType,"==",buffType)
        if v and v.BuffType == buffType then
            printInfo("移除buff:%s",buffType);
            v:ExitEffect(  );
            self.buffList[i] = nil;
            return;
        end
    end
end

--清除所有buf
function actor_control:ClearBuff(  )
    for i,v in pairs(self.buffList) do
        if v then
            v:ExitEffect(  );
            self.buffList[i] = nil;
        end
    end
end

--是否死亡
function actor_control:isDead(  )
	if self:getState() == "state_die" then
        return true;
    end
	return false;
end

--死亡检测
function actor_control:DeadCheck(  )
	--判断角色是否已经死亡
    if self:getState() == "state_die" then
        return true;
    end
    if self.attribute_currenthp <= 0 then
        self:doEvent("event_die")
        return true;
    end
    return false;
end

--设置角色的zorder
function actor_control:setActorLocalZOrder( zorder )
	-- self.showObject:setLocalZOrder(zorder);
	self.showObject:getParent():reorderChild(self.showObject,zorder);
end

function actor_control:resetActorLocalZOrder(  )
	self.showObject:getParent():reorderChild(self.showObject,self.Map_x + self.Map_y);
end

--设置角色位置
function actor_control:setActorPos( x , y )
	self.showObject:setPosition(cc.p(x ,y));
end

--得到角色位置
function actor_control:getActorPos(  )
	return self.showObject:getPosition();
end

function actor_control:ActorMoveEffect( move_x ,move_y ,time ,callfun)
	self.showObject:setAnimationListen( "move" ,callfun );
	self.showObject:exexuteMoveAction( move_x , move_y ,time);
	--更新坐标
	self.Map_x ,self.Map_y = Data_Battle.mapData:getWorldToMapTransform( move_x ,move_y );
end


--注册关闭事件
function actor_control:remove_event(  )
	--清除事件监听
	for k,v in pairs(self.eventlisen) do
		GLOBAL_EVENT_DISPTACHER:removeEventListener(v);
	end
end

return actor_control;
