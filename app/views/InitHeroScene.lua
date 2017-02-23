--
-- Author: lipeng
-- Date: 2015-06-11 15:45:49
-- 初始化英雄scene


local InitHeroScene = class("InitHeroScene", cc.load("mvc").ViewBase)

InitHeroScene.RESOURCE_FILENAME = "common_scene.csb"
function InitHeroScene:onCreate()
    cc.bind(self, "layerManager")
    
    local function onNodeEvent(event)
            if "enter" == event then
                print("onNodeEvent:","enter");
            elseif "exit" == event then
                print("onNodeEvent:","exit");
            elseif "enterTransitionFinish" == event then
                self:openAnimationEffect(  );
            end
        end
    self.resourceNode_:registerScriptHandler(onNodeEvent)

    self.eventLogic = require("app.views.inithero.event_inithero").new(self);

end


--开场动画效果
function InitHeroScene:openAnimationEffect(  )
    self:registerEvent( );
    dispatchGlobaleEvent( "models_inithero" ,"create");
end

function InitHeroScene:registerEvent( )
    self.eventLogic:register_event();
end



--释放逻辑
function InitHeroScene:releaselogic(  )
    --释放使用资源
    
end



return InitHeroScene

