--
-- Author: lipeng
-- Date: 2015-06-11 15:45:49
-- 加载资源scene


local LoadScene = class("LoadScene", cc.load("mvc").ViewBase)

LoadScene.RESOURCE_FILENAME = "common_scene.csb"
function LoadScene:onCreate()
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
    
    self.eventLogic = require("app.views.loadres.event_loadres").new(self);

end


--开场动画效果
function LoadScene:openAnimationEffect(  )
    self:registerEvent( );
    dispatchGlobaleEvent( "models_loadres" ,"create");
end

function LoadScene:registerEvent( )
    self.eventLogic:register_event();
end



--释放逻辑
function LoadScene:releaselogic(  )
    --释放使用资源
    
end



return LoadScene

