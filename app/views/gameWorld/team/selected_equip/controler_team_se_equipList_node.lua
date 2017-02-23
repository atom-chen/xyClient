--
-- Author: lipeng
-- Date: 2015-07-17 09:51:51
-- 控制器: 选择装备列表


local class_controler_team_se_equipListItem = import(".controler_team_se_equipListItem")
local controler_team_se_equipList_node = class("controler_team_se_equipList_node")


function controler_team_se_equipList_node:ctor(team_se_equipList_node)
	self:_initModels()

	self._team_se_equipList_node = team_se_equipList_node
	self._equipListView = self._team_se_equipList_node:getChildByName("equipList")

	self:_createControlerForUI()
	self:_registNodeEvent()
	self:_registUIEvent()
end

function controler_team_se_equipList_node:getView()
	return self._team_se_equipList_node
end

function controler_team_se_equipList_node:addEventListener( callBack )
	self._controlerEventCallBack = callBack
end

--获取当前选中装备
function controler_team_se_equipList_node:getCurSelectedEquip()
	if self._equipListView:getChildrenCount() > 0 then
		return self._equipListView:getItem(self._curSelIdx).luaUserData:getEquip()
	end
end

function controler_team_se_equipList_node:_initModels()
    self._controlerMap = {}
    self._controlerEventCallBack = nil
    self._equipList = MAIN_PLAYER:getEquipManager():cloneEquipDataToList()
    self._curSelIdx = 0
end

function controler_team_se_equipList_node:_createControlerForUI()
	self._controlerMap.equipItems = {}

	for i,v in ipairs(self._equipList) do
		if v:getType() == TeamSelectedEquipSystemInstance:getCurSelEquipType() then
			self._controlerMap.equipItems[i] = class_controler_team_se_equipListItem.new()
			self._controlerMap.equipItems[i]:update(v)
			self._controlerMap.equipItems[i]:getView().luaUserData = self._controlerMap.equipItems[i]
			self._controlerMap.equipItems[i]:getView():retain()
			self._equipListView:addChild(self._controlerMap.equipItems[i]:getView())
		end
	end

	self._equipListView:refreshView()
	self._equipListView:jumpToTop()
end


function controler_team_se_equipList_node:_registNodeEvent()
	local function onNodeEvent(tag)
        if tag == "exit" then
            for i,v in ipairs(self._controlerMap.equipItems) do
				v:getView():release()
			end
			self:_removeAllGlobalEventListeners()
        end
    end

    self._team_se_equipList_node:registerScriptHandler(onNodeEvent)
end

function controler_team_se_equipList_node:_removeAllGlobalEventListeners()
    for k,v in pairs(self._globalEventListeners) do
        GLOBAL_EVENT_DISPTACHER:removeEventListener(v)
    end
end


function controler_team_se_equipList_node:_registUIEvent()
	local function listViewEvent(sender, eventType)
        if eventType == ccui.ListViewEventType.ONSELECTEDITEM_END then
        	self._curSelIdx = sender:getCurSelectedIndex()
        	self:_doEventCallBack(self, "onSelItemEnd")
        end
    end

    self._equipListView:addEventListener(listViewEvent)
end


function controler_team_se_equipList_node:_doEventCallBack( sender, eventName )
	if self._controlerEventCallBack ~= nil then
		self._controlerEventCallBack(sender, eventName)
	end
end

return controler_team_se_equipList_node



