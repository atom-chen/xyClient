--
-- Author: LiYang
-- Date: 2015-07-07 10:58:40
-- 计时效果

local TimeEffect = class("TimeEffect", cc.Node)

function TimeEffect:ctor(  )
    self.tiemNode = cc.CSLoader:createNode("ui_instance/battlefield/timeeffect.csb");
    self:addChild(self.tiemNode);

    self.node_Valuse = self.tiemNode:getChildByName("valuse");
end

--[[
    timer
]]
function TimeEffect:setData( timer )
    self.timeValuse = timer;
    self.node_Valuse:setString(self.timeValuse);
    self:executeEffect(  );
end

function TimeEffect:executeEffect(  )
	--执行动作
    local action = cc.CSLoader:createTimeline("ui_instance/battlefield/timeeffect.csb")
    self.tiemNode:runAction(action)
    action:play("animation0",true);

    local function onFrameEvent(frame)
        
        if nil == frame then
            return;
        end
        local str = frame:getEvent()
        if str == "Finish" and self.timeValuse ~= -100 then
            if self.timeValuse < 1 then
                print("==========")
                if self.FinishCallback then
                    self.FinishCallback();
                end
                self.timeValuse = -100;
                -- self:removeFromParent();
                self:safetyDestroy(  );
                print("==============",self.FinishCallback)
            else
                self.timeValuse = self.timeValuse - 1;
                self.node_Valuse:setString(self.timeValuse);
            end
        end
    end
    action:setFrameEventCallFunc(onFrameEvent)
end

--设置完成回调函数
function TimeEffect:setFinishCallback( callfun )
    self.FinishCallback = callfun;
end

--安全销毁
function TimeEffect:safetyDestroy(  )
    self:setVisible(false);
    local delay_1 = cc.DelayTime:create(1);
    local callfun = cc.CallFunc:create(function (  )
        self:removeFromParent();
    end)
    self:runAction(cc.Sequence:create(delay_1,callfun));
end


return TimeEffect;
