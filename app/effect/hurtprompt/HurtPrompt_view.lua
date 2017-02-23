--
-- Author: LiYang
-- Date: 2015-07-07 10:58:40
-- 伤害提示view

local HurtPrompt_view = class("HurtPrompt_view", cc.Node)

function HurtPrompt_view:ctor(  )
	--创建层级
	self.effectLayer_0 = cc.Node:create();
	self:addChild(self.effectLayer_0, 0);

	self.effectLayer_1 = cc.Node:create();
	self:addChild(self.effectLayer_1, 1);

	self.effectLayer_2 = cc.Node:create();
	self:addChild(self.effectLayer_2, 2);

end

--[[
	params = {
		hurtType = 1, --类型(比如2暴击，1普通伤害 ,3miss )
		aim = nil , -- 目标
		valuse = 10, -- 值
		offsettime = 0,-- 等待时间
	}
]]
function HurtPrompt_view:createHurtHPShow( params )
	self.offsettime = params.offsettime;
    self.HpValuse = params.valuse;
    self.hurtType = params.hurtType;
    --创建伤害提示
    self.hpPrompt = cc.CSLoader:createNode("ui_instance/battlefield/hurtprompt.csb")
    self.hpPrompt:setPosition(cc.p(0 ,80));
    self.effectLayer_0:addChild(self.hpPrompt);

    self.showNode = self.hpPrompt:getChildByName("shownode");
    --伤害值
    self.hurtvaluse = self.showNode:getChildByName("hurtvaluse");
    --伤害类型
    self.hurtTypeView = self.showNode:getChildByName("hurttype");

    --解析数据
    local showCount = ":";
    if self.HpValuse < 0 then
        showCount = ";";
    end
    print("伤害类型:",self.hurtType)
    --创建显示颜色
    if self.hurtType == 1 then
        --普通攻击
        if self.HpValuse <= 0 then
            self.HpNum = cc.Label:createWithCharMap("font/number_red.png",36,54,48)
            self.HpNum:setString(showCount..math.abs(self.HpValuse));
            params.aim:doEvent("event_behit");
        else
            self.HpNum = cc.Label:createWithCharMap("font/number_blue.png",36,54,48)
            self.HpNum:setString(showCount..math.abs(self.HpValuse));
        end
        self.hurtvaluse:addChild(self.HpNum);
        self.hurtTypeView:setVisible(false);
    elseif self.hurtType == 2 then
        --暴击
        if self.HpValuse <= 0 then
            self.HpNum = cc.Label:createWithCharMap("font/number_red.png",36,54,48)
            self.HpNum:setString(showCount..math.abs(self.HpValuse));
            params.aim:doEvent("event_behit");
        else
            self.HpNum = cc.Label:createWithCharMap("font/number_blue.png",36,54,48)
            self.HpNum:setString(showCount..math.abs(self.HpValuse));
            self.hurtTypeView:loadTexture("ui_image/battle/battle_ui/hurtprompt_4.png", ccui.TextureResType.plistType)
        end
        self.hurtvaluse:addChild(self.HpNum);
        --显示暴击字
        self.hurtTypeView:setVisible(true);
    elseif self.hurtType == 3 then
        --miss
        print("闪避")
        self.hurtTypeView:setVisible(true);
        self.hurtTypeView:loadTexture("ui_image/battle/battle_ui/hurtprompt_1.png", ccui.TextureResType.plistType)
        params.aim:doEvent("event_shanbi");
    else
        
    end

    local x , y = Data_Battle.mapData:getMapToWorldTransform( params.aim.Map_x ,params.aim.Map_y );
    self:setPosition(cc.p(x ,y));
    self.hpPrompt:setVisible(false);

    
    if self.offsettime and self.offsettime > 0 then
        local delay_1 = CCDelayTime:create(self.offsettime);
        local callfun = CCCallFunc:create(function (  )
            self:executeEffect(  );
        end)
        self:runAction(CCSequence:createWithTwoActions(delay_1, callfun));
    else
        self:executeEffect(  );
    end
end

function HurtPrompt_view:executeEffect(  )
	self.hpPrompt:setVisible(true);
	--执行动作
    local action = cc.CSLoader:createTimeline("ui_instance/battlefield/hurtprompt.csb")
    self.hpPrompt:runAction(action)
    action:gotoFrameAndPlay(0,false);

    local function onFrameEvent(frame)
        
        if nil == frame then
            return
        end

        local str = frame:getEvent()
        if str == "Finish" then
        	self:removeFromParent();
        end
    end
    action:setFrameEventCallFunc(onFrameEvent)

    --其他
    -- if conditions then
    --     --todo
    -- end
end


return HurtPrompt_view;
