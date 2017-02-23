--
-- Author: lipeng
-- Date: 2015-09-06 20:15:32
-- 雇佣系统入口

local class_controler_guyong_tab_list = import(".controler_guyong_tab_list")
local class_controler_yongjun_list_main_node = import(".yongjun_list.controler_yongjun_list_main_node")
local class_controler_guyong_main_node = import(".guyong.controler_guyong_main_node")


local controler_guyong_system_main_layer = class("controler_guyong_system_main_layer")

function controler_guyong_system_main_layer:ctor(guyong_system_main_layer)
	self:_initModels()

	local visibleSize = cc.Director:getInstance():getVisibleSize()
	
	self._guyong_system_main_layer = guyong_system_main_layer
	self._guyong_system_main_layer:setContentSize(visibleSize)
    ccui.Helper:doLayout(self._guyong_system_main_layer)

    self:_createControlerForUI()
end


function controler_guyong_system_main_layer:getView()
    return self._guyong_system_main_layer
end

function controler_guyong_system_main_layer:_initModels()
    self._controlerMap = {}
end


function controler_guyong_system_main_layer:_createControlerForUI()
	local UIContainer = self._guyong_system_main_layer


	self._controlerMap.yongjunList = class_controler_yongjun_list_main_node.new(
        UIContainer:getChildByName("yongjun_list")
    )

    self._controlerMap.guyong = class_controler_guyong_main_node.new(
        UIContainer:getChildByName("guyong")
    )

	self._controlerMap.tabList = class_controler_guyong_tab_list.new(
        UIContainer:getChildByName("tabList")
    )
    self._controlerMap.tabList:addEventListener(handler(self, self._onEvent_tabList))
    self._controlerMap.tabList:setSelectedTab("雇佣")
end



function controler_guyong_system_main_layer:_onEvent_tabList( sender, eventName, data )
    if eventName == "selectedTabChange" then
        if self._curShowPanleControler ~= nil then
            self._curShowPanleControler:getView():setVisible(false)
        end


        if data.curSelTabName == "雇佣" then
            self._curShowPanleControler = self._controlerMap.guyong
            gameTcp:SendMessage(MSG_C2MS_HIRESYS_GET_INFO)
            printNetLog("发送消息 MSG_C2MS_HIRESYS_GET_INFO")

        elseif data.curSelTabName == "佣军列表" then
            self._curShowPanleControler = self._controlerMap.yongjunList
            local sendData = {}
            sendData[1] = self._curShowPanleControler:getCurPageIdx()
            gameTcp:SendMessage(MSG_C2MS_HIRESYS_HIRELING_INFO, sendData)
            printNetLog("发送消息 MSG_C2MS_HIRESYS_HIRELING_INFO")
        end
        
        self._curShowPanleControler:getView():setVisible(true)
    end
end

return controler_guyong_system_main_layer
