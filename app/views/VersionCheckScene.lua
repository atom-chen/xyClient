--
-- Author: lipeng
-- Date: 2015-06-11 15:45:49
-- 版本检查场景


local VersionCheckScene = class("VersionCheckScene", cc.load("mvc").ViewBase)

-- local _classloginaccount = require("app.views.loginview.UI_LoginAccount");

VersionCheckScene.RESOURCE_FILENAME = "common_scene.csb"
function VersionCheckScene:onCreate()
    cc.bind(self, "layerManager")
    
    local function onNodeEvent(event)
            if "enter" == event then
                print("onNodeEvent:","enter");
            elseif "exit" == event then
                print("onNodeEvent:","exit");
            elseif "enterTransitionFinish" == event then
            	print("enterTransitionFinish:","enterTransitionFinish");
                self:openAnimationEffect(  );
            end
        end
    self.resourceNode_:registerScriptHandler(onNodeEvent)

    self.eventLogic = require("app.views.versioncheck.event_logic_update").new(self);

end


--开场动画效果
function VersionCheckScene:openAnimationEffect(  )
    self:registerEvent( );
    --执行检查逻辑
    dispatchGlobaleEvent( "models_update" ,"check_version" ,nil)
end

function VersionCheckScene:registerEvent( )
    self.eventLogic:register_event();
end



--释放逻辑
function VersionCheckScene:releaselogic(  )
    --释放使用资源
    
end



return VersionCheckScene

