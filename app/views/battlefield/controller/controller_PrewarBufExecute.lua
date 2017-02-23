--
-- Author: LiYang
-- Date: 2015-07-23 16:25:08
-- 战前buf 执行逻辑 即 每局 开始前被动技能执行

local controller_PrewarBufExecute = class("controller_PrewarBufExecute")

function controller_PrewarBufExecute:ctor()
	
end

--[[设置数据
	index 战斗的局数
	callfun
]]
function controller_PrewarBufExecute:setData( index ,callfun)
	
	self:setFinishCallback( callfun );
	--得到当前战斗数据
    self.CurrentInningData = Data_Battle_Msg:getCombatInningData( index );
    if not self.CurrentInningData then
    	printError("controller_PrewarBufExecute: 战斗局数据为nil")
    	return;
    end

    --更新角色血量
    --攻击方
    for k,v in pairs(self.CurrentInningData.AttackActor) do
        local actor = control_Combat:getActorByPos( v.pos ,Data_Battle.CONST_CAMP_PLAYER )
        actor:setHpShow( true );
        actor:setSumHp( v.maxHP );
        actor:updata_hp( v.actorHP );
    end
    --防守方
    for k,v in pairs(self.CurrentInningData.DefendActor) do
        local actor = control_Combat:getActorByPos( v.pos ,Data_Battle.CONST_CAMP_ENEMY )
        actor:setHpShow( true );
        actor:setSumHp( v.maxHP );
        actor:updata_hp( v.actorHP );
    end
	--执行被动技能
	self.executeBufData = self.CurrentInningData.PassivityBuf;
	self.executeCount = table.nums(self.executeBufData);--执行数量

    for k,v in pairs(self.executeBufData) do
        --执行被动buf逻辑
        if v and v.bufID > 0 then
			--添加buf
			--解析目标
			local Camp = Data_Battle_Msg:ConvertCampData( v.aimcamp );
			local hurtdata = control_Combat:getActorByPos( v.aimpos , Camp);
            print(Camp ,v.releasepos,hurtdata)
			bufManager:CreateBuf({
				aim = hurtdata,--buff作用目标
				skillID = v.bufID,--buffID
			});
		end
    end

	if self.FinishCallback then
		self.FinishCallback();
	end
end

--设置完成回调函数
function controller_PrewarBufExecute:setFinishCallback( callfun )
	self.FinishCallback = callfun;
end

return controller_PrewarBufExecute;
