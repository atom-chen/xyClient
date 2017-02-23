--
-- Author: LiYang
-- Date: 2015-07-23 16:25:08
-- 创建技能名称

local controller_skillName = class("controller_skillName",cc.Node)

function controller_skillName:ctor()
	
end

--[[设置数据
	parame = {
		target ,--目标
		name ,--技能名称
		res ,--技能名称资源
	}
]]
function controller_skillName:setData( parame )
	self.target = parame.target;
	self.target:setSkillPromptShow( parame.name );

	--计时操作
	local delay_1 = cc.DelayTime:create(0.5);
	local callfun_1 = cc.CallFunc:create(function (  )
	 	if self.FinishCallback then
	 		self.FinishCallback();
	 	end
	 	self:removeFromParent();
    end)
    self:runAction(cc.Sequence:create(delay_1,callfun_1));
end

--设置完成回调函数
function controller_skillName:setFinishCallback( callfun )
	self.FinishCallback = callfun;
end

return controller_skillName;
