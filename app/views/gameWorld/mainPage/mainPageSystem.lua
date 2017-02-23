--
-- Author: lipeng
-- Date: 2015-06-27 14:23:51
-- 主页系统

local class_controler_ui_layer = import(".controler_UILayer.controler_mainPage_ui_layer")
local class_controler_uitop_layer = import(".controler_UITopLayer.controler_mainpage_uitop_layer")
local class_controler_mainpage_top_layer = import(".controler_TopLayer.controler_mainpage_top_layer")

import(".info.player_info_system")

local mainPageSystem = class("mainPageSystem")


mainPageSystem.instance = nil

function mainPageSystem:ctor()
    if mainPageSystem.instance ~= nil then
        printError("mainPageSystem 为单例对象")
        return
    end
	self:_initModels()
end

--进入系统
--parmas.scene
function mainPageSystem:enterSystem(parmas)
    ResLoad:setLoadList(
        {
            "ui_image/mainpage/anim/zhanyi/zy1/effect_zhanyi1.png",
            "ui_image/mainpage/anim/zhanyi/zy1/effect_zhanyi1_mengban.png",
            "ui_image/mainpage/anim/zhanyi/zy2/effect_zhanyi2.png",
            "ui_image/mainpage/anim/zhanyi/zy2/zhanyi2_mengban.png",
            "ui_image/mainpage/anim/zhanyi/zy3/effect_zhanyi3.png",
            "ui_image/mainpage/anim/zhanyi/zy3/effect_zhanyi3_mengban.png"
        }
    )
    ResLoad:LoadRes()
    
    self.scene = parmas.scene
    self._controlerMap.mainPageUILayer = class_controler_ui_layer.new(self:_createUILayer())
    self.scene:addChildToLayer(LAYER_ID_UI, self._controlerMap.mainPageUILayer:getView())
    self._controlerMap.mainPageUITopLayer = class_controler_uitop_layer.new(self:_createUITopLayer())
    self.scene:addChildToLayer(LAYER_ID_UITop, self._controlerMap.mainPageUITopLayer:getView())
    self._controlerMap.mainPageTopLayer = class_controler_mainpage_top_layer.new(self:_createTopLayer())
    self.scene:addChildToLayer(LAYER_ID_TOP, self._controlerMap.mainPageTopLayer:getView())

    --开启战场
    dispatchGlobaleEvent( "battlefield" ,"initialize");

    dumpTextureCacheInfo()
end


--离开系统
function mainPageSystem:leaveSystem(parmas)
    
end


function mainPageSystem:_initModels()
    self._controlerMap = {}
end

function LoadCsb( parame )
    return cc.CSLoader:createNode(parame);
end

function mainPageSystem:_createUILayer()
    return cc.CSLoader:createNode("ui_instance/mainPage/mainpage_ui_layer_.csb")
end

function mainPageSystem:_createUITopLayer()
    return cc.CSLoader:createNode("ui_instance/mainPage/uitop_layer/mainpage_uitop_layer.csb")
end

function mainPageSystem:_createTopLayer()
    return cc.CSLoader:createNode("ui_instance/mainPage/top_layer/mainpage_top_layer.csb")
end



function mainPageSystem.getInstance()
    if mainPageSystem.instance == nil then
        mainPageSystem.instance = mainPageSystem.new()
    end

    return mainPageSystem.instance
end


MainPageSystemInstance = mainPageSystem.getInstance()


return mainPageSystem
