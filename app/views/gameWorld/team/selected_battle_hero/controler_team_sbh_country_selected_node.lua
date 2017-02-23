--
-- Author: lipeng
-- Date: 2015-07-17 09:52:20
-- 控制器: 上阵武将列表, 选择国家

local controler_team_sbh_country_selected_node = class("controler_team_sbh_country_selected_node")



function controler_team_sbh_country_selected_node:ctor(team_sbh_country_selected_node)
	self:_initModels()

	self._team_sbh_country_selected_node = team_sbh_country_selected_node

	self:_registUIEvent()
end

function controler_team_sbh_country_selected_node:addEventListener( callBack )
	self._controlerEventCallBack = callBack
end

function controler_team_sbh_country_selected_node:getSelectedCountryIDList()
	return self._selectedCountryIDList
end


function controler_team_sbh_country_selected_node:_initModels()
	self._controlerEventCallBack = nil
	--被选中国家ID列表
	self._selectedCountryIDList = {}
	self._countryViews = {}
	self._curSelCountryViews = nil
end

function controler_team_sbh_country_selected_node:_registUIEvent()
	local countryNode = self._team_sbh_country_selected_node

	local function selectedEvent(sender,eventType)
		-- if eventType == ccui.CheckBoxEventType.unselected then
		-- 	if #self._selectedCountryIDList <= 1 then
		-- 		sender:setSelected(true)
		-- 	end
		-- end
		if sender == self._curSelCountryViews then
			sender:setSelected(true)
			return
		else
			self._curSelCountryViews:setSelected(false)
			self._curSelCountryViews = sender
		end
		
		self:_updateSelectedCountryIDList()
    end

    for i=1, 5 do
    	self._countryViews[i] = countryNode:getChildByName("cbtn_country"..i)
    	self._countryViews[i].countryID = i
		self._countryViews[i]:addEventListener(selectedEvent)
    end

    self._countryViews[5]:setSelected(true)
    self._curSelCountryViews = self._countryViews[5]
    self:_updateSelectedCountryIDList()
end

function controler_team_sbh_country_selected_node:_updateSelectedCountryIDList()
	self._selectedCountryIDList = {}

	if self._countryViews[5]:isSelected() then
		self._selectedCountryIDList = {1, 2, 3, 4}
	else
		for i=1,4 do
			if self._countryViews[i]:isSelected() then
				self._selectedCountryIDList[#self._selectedCountryIDList + 1] = self._countryViews[i].countryID
				break
			end
		end
	end

	self:_doEventCallBack(self, "updateSelectedCountryIDList")
end


function controler_team_sbh_country_selected_node:_doEventCallBack( sender, eventName )
	if self._controlerEventCallBack ~= nil then
		self._controlerEventCallBack(sender, eventName)
	end
end


return controler_team_sbh_country_selected_node
