--
-- Author: lipeng
-- Date: 2015-06-11 15:45:49
-- 游戏场景


import(".gameWorld.init")



local GameWorldScene = class("GameWorldScene", cc.load("mvc").ViewBase)

GameWorldScene.RESOURCE_FILENAME = "common_scene.csb"

function GameWorldScene:onCreate()
    cc.bind(self, "layerManager")
	

    local function onNodeEvent(event)
        if "enter" == event then
            
        elseif "exit" == event then

        elseif "enterTransitionFinish" == event then
            GLOBAL_TOUCH_CONTROL:TounchContrlScheduler(-100,GLOBAL_TOUCH_CONTROL.CONTROL_TYPE_FOREVER)
            --进入首页系统
            MainPageSystemInstance:enterSystem({scene=self})
        end
    end
    self:registerScriptHandler(onNodeEvent)
end


return GameWorldScene

