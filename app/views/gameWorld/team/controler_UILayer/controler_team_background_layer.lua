--
-- Author: lipeng
-- Date: 2015-07-08 10:42:46
-- 控制器: 队伍背景



local controler_team_background_layer = class("controler_team_background_layer")


function controler_team_background_layer:ctor(team_background_layer)
	self:_initModels()

	local visibleSize = cc.Director:getInstance():getVisibleSize()
	--根层
	self._team_background_layer = team_background_layer
    self._team_background_layer:setContentSize(visibleSize)
    ccui.Helper:doLayout(self._team_background_layer)

    self._baseContainer = self._team_background_layer:getChildByName("BaseContainer")
    self._baseContainer:setContentSize(visibleSize)
    ccui.Helper:doLayout(self._baseContainer)

    self:_registUIEvent()
end


function controler_team_background_layer:_initModels()
    
end


function controler_team_background_layer:_registUIEvent()
    local btn_close = self._baseContainer:getChildByName("btn_close")

    local function closeTouchEventCallBack(sender,eventType)
        if eventType == ccui.TouchEventType.ended then
            dispatchGlobaleEvent("controler_team_background_layer", "closeTouched")
        end
    end

    btn_close:addTouchEventListener(closeTouchEventCallBack)
end



return controler_team_background_layer




