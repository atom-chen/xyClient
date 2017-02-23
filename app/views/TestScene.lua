--
-- Author: lipeng
-- Date: 2015-06-11 14:56:30
-- Logo场景


local TestScene = class("TestScene", cc.load("mvc").ViewBase)

TestScene.RESOURCE_FILENAME = "common_scene.csb"

function TestScene:onCreate()
    local size= cc.Director:getInstance():getVisibleSize()
    local rootNode = self:getResourceNode()
    rootNode:setContentSize(size)
    ccui.Helper:doLayout(rootNode)
    rootNode:setPosition(cc.p(display.cx - 640 ,display.cy - 360))

    local h = import("app.views.gameWorld.heros.UI_Hero.lua"):new()
    rootNode:addChild(h)
    
end


return TestScene


