--
-- Author: LiYang
-- Date: 2015-07-07 10:58:40
-- 角色底部效果(光环)

local actorbottomview = class("actorbottomview", cc.load("mvc").ViewBase)

function actorbottomview:ctor( actorModel )
	-- cc.bind(self, "stateMachine")
	self.actorModel = actorModel;
	--创建层级
	self.effectLayer_0 = cc.Node:create();
	self:addChild(self.effectLayer_0, 0);

	self.effectLayer_1 = cc.Node:create();
	self:addChild(self.effectLayer_1, 1);

	self.effectLayer_2 = cc.Node:create();
	self:addChild(self.effectLayer_2, 2);

	self.effectLayer_3 = cc.Node:create();
	self:addChild(self.effectLayer_3, 3);

	--效果对象
	-- self:setActorShowView();
end


--添加效果对象
function actorbottomview:createGuangHuangEffect( index )
	--创建buf显示
    local animationInfo = getEffectConfigById( "guanghuang_"..index );
    self.guanghuang = EffectManager:CreateArmature( {
        name = animationInfo.armature,--效果名称
        x = 0,
        y = 0,
        zorder = 0,
        isfinishdestroy = false,--是否完成销毁
    } );
    -- self.idleview.mark = tostring(k);
    --添加到显示界面
    self.effectLayer_0:addChild( self.guanghuang);
    self.guanghuang:playAnimationByID( animationInfo.armaturename ,nil ,-1);
end


return actorbottomview;
