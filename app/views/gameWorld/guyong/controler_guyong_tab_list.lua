--
-- Author: lipeng
-- Date: 2015-09-06 20:33:05
--

local controler_guyong_tab_list = class("controler_guyong_tab_list")

function controler_guyong_tab_list:ctor( guyong_tab_list )
	self:_initModels()

	self._guyong_tab_list = guyong_tab_list

	self:_registUIEvent()
end

function controler_guyong_tab_list:addEventListener( callBack )
	self._controlerEventCallBack = callBack
end



function controler_guyong_tab_list:setSelectedTab( tabName )
	local lastSelectedIdx = -1

	local tab = self:_getTabWithTabName(tabName)
	--将上次选中的tab设置为没有选中
	if self._curSelTab ~= nil then
		lastSelectedIdx = self._curSelTab:getTag()
		self._curSelTab:setSelected(false)
	end

	--将当前选中tab设置为选中
	self._curSelTab = tab
	self._curSelTab:setSelected(true)

	if lastSelectedIdx ~= self._curSelTab:getTag() then
		self:_doEventCallBack(self, "selectedTabChange", {curSelTabName = tabName})
	end
	
end



function controler_guyong_tab_list:_initModels()
	self._controlerEventCallBack = nil

	self._tabNameToIdxConfig = {
		["雇佣"] = 1,
		["佣军列表"] = 2
	}

	self._curSelTab = nil
end



function controler_guyong_tab_list:_registUIEvent()
	local function tabSelectedEvent( sender, eventType )
		if eventType == ccui.CheckBoxEventType.selected then
			if self._curSelTab:getTag() ~= sender:getTag() then
        		self._curSelTab:setSelected(false)
        		self._curSelTab = sender
        		local curSelTabName = self:_idxToTabName(self._curSelTab:getTag())
        		self:_doEventCallBack(self, "selectedTabChange", {curSelTabName = curSelTabName})
        	end

        elseif eventType == ccui.CheckBoxEventType.unselected then
        	if self._curSelTab:getTag() == sender:getTag() then
        		sender:setSelected(true)
        	end
        	
        end
	end

	for i=1, 2 do
		self:_getTabWithIdx(i):addEventListener(tabSelectedEvent)
	end
	
end



function controler_guyong_tab_list:_getTabWithIdx( idx )
	return self._guyong_tab_list:getChildByName("tab"..idx)
end

function controler_guyong_tab_list:_getTabWithTabName( tabName )
	local idx = self:_tabNameToIdx(tabName)
	return self:_getTabWithIdx(idx)
end


function controler_guyong_tab_list:_tabNameToIdx( tabName )
	return self._tabNameToIdxConfig[tabName]
end


function controler_guyong_tab_list:_idxToTabName( idx )
	for k,v in pairs(self._tabNameToIdxConfig) do
		if v == idx then
			return k
		end
	end
end


function controler_guyong_tab_list:_doEventCallBack( sender, eventName, data )
	if self._controlerEventCallBack ~= nil then
		self._controlerEventCallBack(sender, eventName, data)
	end
end


return controler_guyong_tab_list
