--
-- Author: Li yang
-- Date: 2014-12-22 09:32:09
-- 震动效果1


local Effect_shake_1 = class("Effect_shake_1", function ( )
	return display.newNode();
end)

Effect_shake_1.FinishCallBack = nil;


------- 参数 --------
-- Effect_skill_Prompt.runTime = 1;--运行时间


function Effect_shake_1:ctor()
	self.rootNode = cc.Node:create();
	self:addChild(self.rootNode);
	
end

--[[设置效果数据
	time 显示的时间
]]
function Effect_shake_1:setData( time )
	self.showTime = time;
	self:CreateEffect(  );
end

-- 创建效果
function Effect_shake_1:CreateEffect(  )
	--左
	self.left_Emitter = CCParticleSystemQuad:create("particle/effect_shake.plist");
	self.left_Emitter:setBlendAdditive(true);
	self.left_Emitter:setPositionType(kCCPositionTypeGrouped);
	self.left_Emitter:setDuration(self.showTime);
	self.left_Emitter:setAutoRemoveOnFinish(true);--设置完成后自动销毁
	self.left_Emitter:setPosition(cc.p(-display.width / 2,0));--设置发射位置
	self.rootNode:addChild(self.left_Emitter);--将粒子效果放入效果成
	--右
	self.right_Emitter = CCParticleSystemQuad:create("particle/effect_shake.plist");
	self.right_Emitter:setBlendAdditive(true);
	self.right_Emitter:setPositionType(kCCPositionTypeGrouped);
	self.right_Emitter:setDuration(self.showTime);
	self.right_Emitter:setAutoRemoveOnFinish(true);--设置完成后自动销毁
	self.right_Emitter:setPosition(cc.p(display.width / 2,0));--设置发射位置
	self.right_Emitter:setRotation(180);
	self.rootNode:addChild(self.right_Emitter);--将粒子效果放入效果成
	--上
	self.top_Emitter = CCParticleSystemQuad:create("particle/effect_shake.plist");
	self.top_Emitter:setBlendAdditive(true);
	self.top_Emitter:setPositionType(kCCPositionTypeGrouped);
	self.top_Emitter:setDuration(self.showTime);
	self.top_Emitter:setAutoRemoveOnFinish(true);--设置完成后自动销毁
	self.top_Emitter:setPosition(cc.p(0,display.height / 2));--设置发射位置
	self.top_Emitter:setRotation(90);
	self.rootNode:addChild(self.top_Emitter);--将粒子效果放入效果成

	local delay_1 = cc.DelayTime:create(self.showTime);
	local callfun_1 = cc.CallFunc:create(function (  )
		self:removeFromParent();
	end)
	self:runAction(cc.Sequence:create(delay_1,callfun_1));
end

-- 设置完成回调函数
function Effect_shake_1:setFinishCallBack(callbackfunction)
	self.FinishCallBack = callbackfunction;
end

return Effect_shake_1;
