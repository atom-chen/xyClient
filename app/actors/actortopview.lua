--
-- Author: LiYang
-- Date: 2015-07-07 10:58:40
-- 角色top 显示对象(比如 血条 buf)

local actortopview = class("actortopview", cc.load("mvc").ViewBase)

function actortopview:ctor( actorModel )
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
    self.bufList = cc.Node:create();
    self.bufList:setPosition(cc.p(0,180));
    self.effectLayer_1:addChild(self.bufList);
end

--设置角色显示数据
function actortopview:createHPShow( tempid ,camp )
    --创建血条
    self.hpview = cc.CSLoader:createNode("ui_instance/battlefield/role_hp.csb")
    self.hpview:setPosition(cc.p(0 ,160));
    self.effectLayer_0:addChild(self.hpview);
    --
    self.hp = self.hpview:getChildByName("hp");
    
end

--添加效果对象
function actortopview:createBufShow( effect ,lenth)
	--创建buf显示
    if effect then
        self.bufList:addChild(effect);
    end
    if lenth then
       self.bufList:setPositionX(-lenth/2);
    end
end

--创建名称
function actortopview:createName(  )
	-- body
end

--创建技能名称
function actortopview:createSkillName( name )
	self.skillprompt = cc.CSLoader:createNode("ui_instance/battlefield/skillprompt.csb")
    self.skillprompt:setPosition(cc.p(0 ,160));
    self.effectLayer_3:addChild(self.skillprompt);
    self.skillname = self.skillprompt:getChildByName("actionnode"):getChildByName("skillname");
	self.skillprompt:setVisible(true);
    self.skillname:setString(name);
    
	--执行动作
    local action = cc.CSLoader:createTimeline("ui_instance/battlefield/skillprompt.csb")
    self.skillprompt:runAction(action)
    action:gotoFrameAndPlay(0,false);
    
    local function onFrameEvent(frame)
        if nil == frame then
            return
        end
        local str = frame:getEvent()
        if str == "Finish" then
        	self.skillprompt:removeFromParent();
        	self.skillprompt = nil;
        end
    end
    action:setFrameEventCallFunc(onFrameEvent)
end


function actortopview:setHpValuse( values )
	self.hp:setPercent(values);
end

return actortopview;
