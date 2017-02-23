--
-- Author: lipeng
-- Date: 2015-06-15 13:54:55
-- 组件: 层管理

local class_layer_tounchControl = require("app.commonLib.view.layer.layer_tounchControl")
local class_layer_popUpManager = require("app.commonLib.view.layer.layer_popUpManager")

local layerManager = class("component_layerManager")

layerManager.ZORDER_BG_LAYER = 1
layerManager.ZORDER_UI_LAYER = 2
layerManager.ZORDER_UI_TOP_LAYER = 3
layerManager.ZORDER_POPUP_LAYER = 4
layerManager.ZORDER_TOP_LAYER = 5
layerManager.ZORDER_MASK_LAYER = 6
layerManager.ZORDER_NOTICE_LAYER = 7
layerManager.ZORDER_GLOBAL_TOUCH_CONTROL_LAYER = 100
layerManager.ZORDER_RESUME_CONNECT = 150

LAYER_ID_BG = "background"
LAYER_ID_UI = "UI"
LAYER_ID_UITop = "UITop"
LAYER_ID_POPUP = "popup"
LAYER_ID_TOP = "top"
LAYER_ID_MASK = "mask"
LAYER_ID_NOTICE = "notice"
LAYER_ID_GOLBAL_TOUCH_CONTROL = "golbal_touch_control"
LAYER_ID_RESUME_CONNECT = "resumeconnect"


local EXPORTED_METHODS = {
    "addChildToLayer"
}

function layerManager:init_(target)
    self.target_ = target
    self:_addLayers()
end

function layerManager:bind(target)
    self:init_(target)
    cc.setmethods(target, self, EXPORTED_METHODS)
    self.target_ = target
end

function layerManager:unbind(target)
    cc.unsetmethods(target, EXPORTED_METHODS)
    self:_removeLayers()
    self.target_ = nil
end


function layerManager:addChildToLayer( layerStrID, node, zorder )
    local layer = self:_getLayerWithStrID(layerStrID)
    if layer == nil then
        printError("layerStrID = "..layerStrID)
        return
    end

    local zorder_ = zorder or 0

    layer:addChild(node, zorder_)
end

function layerManager:getChildFromLayerWithName( layerStrID, nodeNameID )
    local layer = self:_getLayerWithStrID(layerStrID)
    if layer == nil then
        printError("layerStrID = "..layerStrID)
        return
    end

    return layer:getChildByName(nodeNameID)
end

--设置层次所在的 父级层
function layerManager:_addLayers()
    self.bgLayer_ = cc.Layer:create() --背景层
    self.uiLayer_ = cc.Layer:create() --基础UI层
    self.uiTopLayer_ = cc.Layer:create() --UI层的置顶层(始终保持在UI层之上)
    self.popupLayer_ = class_layer_popUpManager.new() --弹窗层
    self.topLayer_ = cc.Layer:create() --顶部UI层
    self.maskLayer_ = cc.Layer:create() --遮罩层
    self.noticeLayer_ = cc.Layer:create() --事件通知层
    self.globalTouchControlLayer_ = class_layer_tounchControl.new(self.target_) --全局touch控制层
    self.resumeconnectLayer_ = cc.Layer:create() --重连层

    self.target_:getResourceNode():addChild(self.bgLayer_, layerManager.ZORDER_BG_LAYER)
    self.target_:getResourceNode():addChild(self.uiLayer_, layerManager.ZORDER_UI_LAYER)
    self.target_:getResourceNode():addChild(self.uiTopLayer_, layerManager.ZORDER_UI_TOP_LAYER)
    self.target_:getResourceNode():addChild(self.popupLayer_, layerManager.ZORDER_POPUP_LAYER)
    self.target_:getResourceNode():addChild(self.topLayer_, layerManager.ZORDER_TOP_LAYER)
    self.target_:getResourceNode():addChild(self.maskLayer_, layerManager.ZORDER_MASK_LAYER)
    self.target_:getResourceNode():addChild(self.noticeLayer_, layerManager.ZORDER_NOTICE_LAYER)
    self.target_:getResourceNode():addChild(self.globalTouchControlLayer_, layerManager.ZORDER_GLOBAL_TOUCH_CONTROL_LAYER)
    self.target_:getResourceNode():addChild(self.resumeconnectLayer_, layerManager.ZORDER_RESUME_CONNECT)
end

--  取消层次所在的 父级层
function layerManager:_removeLayers()
    self.bgLayer_:removeFromParent()
    self.uiLayer_:removeFromParent()
    self.uiTopLayer_:removeFromParent()
    self.popupLayer_:removeFromParent()
    self.topLayer_:removeFromParent()
    self.maskLayer_:removeFromParent()
    self.noticeLayer_:removeFromParent()
    self.globalTouchControlLayer_:removeFromParent()
    self.resumeconnectLayer_:removeFromParent()
end

--通过layerID获取layer
function layerManager:_getLayerWithStrID( id )
    if id == LAYER_ID_BG then
        return self.bgLayer_

    elseif id == LAYER_ID_UI then
        return self.uiLayer_

    elseif id == LAYER_ID_UITop then
        return self.uiTopLayer_

    elseif id == LAYER_ID_TOP then
        return self.topLayer_

    elseif id == LAYER_ID_POPUP then
        return self.popupLayer_

    elseif id == LAYER_ID_MASK then
        return self.maskLayer_

    elseif id == LAYER_ID_NOTICE then
        return self.noticeLayer_

    elseif id == LAYER_ID_GOLBAL_TOUCH_CONTROL then
        return self.globalTouchControlLayer_
    elseif id == LAYER_ID_RESUME_CONNECT then
        return self.resumeconnectLayer_
    end

    return nil
end


return layerManager




