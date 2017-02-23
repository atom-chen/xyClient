--
-- Author: liyang
-- Date: 2015-06-11 15:45:49
-- 战场场景


local BattlefieldScene = class("BattlefieldScene", cc.load("mvc").ViewBase)

require("app.views.battlefield.control_combat.lua");

BattlefieldScene.RESOURCE_FILENAME = "common_scene.csb"

function BattlefieldScene:onCreate()
    cc.bind(self, "layerManager")
    local function onNodeEvent(event)
            if "enter" == event then

            elseif "exit" == event then

            elseif "enterTransitionFinish" == event then
                self:openAnimationEffect(  );
            end
        end
    self.resourceNode_:registerScriptHandler(onNodeEvent)

end


--开场动画效果
function BattlefieldScene:openAnimationEffect(  )
    --开始游戏按钮
    local screenSize = cc.Director:getInstance():getWinSize()
    print("screenSize:",screenSize.width,screenSize.height)
    --添加战场显示
    -- self.showLayer = require("app.views.battlefield.battleshowLayer").new();
    -- self:addChildToLayer(LAYER_ID_BG, self.showLayer)
    -- self.showLayer:setPosition(cc.p(display.cx,display.cy));
    --添加ui
    -- self.battleUI_b = cc.CSLoader:createNode("ui_instance/battlefield/battle_ui_bottom.csb")
    -- self:addChildToLayer(LAYER_ID_UI, self.battleUI_b)

    -- control_Combat:doEvent("event_initialize","testcjcj");

    -- local delay_1 = cc.DelayTime:create(1);
    -- local callfun = cc.CallFunc:create(function (  )
    --     control_Combat:doEvent("event_entrance");
    -- end)
    -- self:runAction(cc.Sequence:create(delay_1,callfun));
    --开启战场
    dispatchGlobaleEvent( "battlefield" ,"initialize");
    
end

function BattlefieldScene:registerEvent(  )
    
end

--释放逻辑
function BattlefieldScene:releaselogic(  )
    --释放使用资源
end



return BattlefieldScene

