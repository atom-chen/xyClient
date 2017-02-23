--
-- Author: LiYang
-- Date: 2015-07-22 14:49:32
-- 技能描述

local skilleffect_describe = class("skilleffect_describe")

function skilleffect_describe:ctor()
	-- body
end

--[[设置技能数据
	parame = {
		name --技能名称
		release --释放者
		releaseCamp --释放者阵营
		aimCamp --目标阵营
		aimData -- 目标
		hurtData --目标伤害数据
	}
]]
function skilleffect_describe:setData( parame )
	self.Release = parame.release;
	self.ReleaseCamp = parame.releaseCamp;
	self.AimCamp = parame.aimCamp;
	self.AimData = parame.aimData;
	self.HurtData = parame.hurtData;
	self.skillName = parame.name;
	self:analysisData(  );
	
end

--解析数据
function skilleffect_describe:analysisData(  )
	local describe = "阵营:"..self.ReleaseCamp.."位置："..self.Release.attribute_frompos..",释放技能："..self.skillName;
	for i,v in ipairs(self.HurtData) do
		--解析目标
		local Camp = Data_Battle_Msg:ConvertCampData( v.aimcamp );
		local hurtAim = control_Combat:getActorByPos( v.aimpos , Camp);
		if hurtAim and (not hurtAim:isDead()) then
			if v.hurtvaluse ~= 0 then
				local des = "\n目标阵营："..Camp..",位置："..v.aimpos..",造成伤害:"..v.hurtvaluse;
				describe = describe..des;
				HurtPromptManager:AddPromptObject( {
					hurtType = 1, --类型(比如暴击，普通伤害 ,miss)
					aim = hurtAim, -- 目标
					valuse = v.hurtvaluse, -- 值
				} );
				--设置剩余血量
				if v.Hp == -1 then
					hurtAim:UpDataCurrentHp( v.hurtvaluse ,v.isDead);
				else
					hurtAim:updata_hp(v.Hp);
				end
			end
		end
	end
	--创建表现
	local effect = require("app.effect.effectpiece.skilldescribe.lua").new();
	effect:setData( describe );
	effect:setFinishCallback( function (  )
		print("=============",self.FinishCallback)
		if self.FinishCallback then
			self.FinishCallback();
		end
	end )
	--添加到显示界面
	dispatchGlobaleEvent( "battleshowlayer" ,"event_addshowobject" ,{effect,2,nil});
end


--设置完成回调函数
function skilleffect_describe:setFinishCallback( callfun )
	self.FinishCallback = callfun;
end


return skilleffect_describe;
