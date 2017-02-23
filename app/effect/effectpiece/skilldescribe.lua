--
-- Author: LiYang
-- Date: 2015-07-07 10:58:40
-- 技能描述

local skilldescribe = class("skilldescribe", cc.Node)

function skilldescribe:ctor(  )
    self.tiemNode = cc.CSLoader:createNode("ui_instance/battlefield/skilldescribe.csb");
    self:addChild(self.tiemNode);

    self.node_Valuse = self.tiemNode:getChildByName("valuse");
end

--[[
    timer
]]
function skilldescribe:setData( str )
    -- self.timeValuse = timer;
    self.node_Valuse:setString(str);
    local delay_1 = cc.DelayTime:create(1);
    local callfun = cc.CallFunc:create(function (  )
        if self.FinishCallback then
            self.FinishCallback();
        end
        self:removeFromParent();
    end)
    self:runAction(cc.Sequence:create(delay_1,callfun));
end


--设置完成回调函数
function skilldescribe:setFinishCallback( callfun )
    self.FinishCallback = callfun;
end


return skilldescribe;
