--
-- Author: Li Yang
-- Date: 2014-03-21 11:56:12
-- 技能管理类

SkillManager = {};

-- 技能池
SkillManager.SkillPool = {};

local _skill_common = require("app.skill.skillLogic_common")
local _skillLogic_buf = require("app.skill.skillLogic_buf")
local _BuffExecuteQueueManager = require("app.skill.BuffExecuteQueueManager")
-- local _skillLogic_Special_1 = require("app.skill.skillLogic_Special_1")
-- local _skillLogic_Special_2 = require("app.skill.skillLogic_Special_2")

--[[ 设置技能数据
	params = {
		config = nil;-- 施法参数
		callback = nil; --完成回调
	}
]]
function SkillManager:CreateSkill( params )
	local  skill = nil;
	local SkillCongfig = GetSkill( params.config.skillID );
	print("技能参数SkillManager:CreateSkill:",SkillCongfig,params.config,params.config.skillID)
	if SkillCongfig then --skillID
		skill = _skill_common.new();
		skill:setData(params);
	end
	return skill;
end

--[[ 设置buf技能数据
	params = {
		config = nil;-- 施法参数
		callback = nil; --完成回调
	}
]]
function SkillManager:CreateSkillBuf( params )
	 local  skill = _skillLogic_buf.new();
	 skill:setData(params);
	 return skill;
end

--[[ c创建buf执行队列
]]
function SkillManager:CreateSkillBufExecuteQueue(  )
	local executeQueue = _BuffExecuteQueueManager.new();
	-- 加入效果显示
	dispatchGlobaleEvent( "battleshowlayer" ,"event_addlogicbject" ,executeQueue);
	return executeQueue;
end


-- 增加技能
SkillManager.addSkill = function ( skill )
	local pos = 1;
	for k,v in pairs(SkillManager.SkillPool) do
		if not v then
			SkillManager.SkillPool[k] = skill;
			return ;
		end
		pos = pos + 1;
	end
	SkillManager.SkillPool[pos] = skill;
end

-- 技能运行逻辑
SkillManager.SkillLogic = function ( ... )
	for k,v in pairs(table_name) do
		if v then
			-- 执行技能逻辑
			v:SkillLogic(  );
		end
	end
end