--
-- Author: lipeng
-- Date: 2015-07-17 09:51:51
-- 控制器: 选择上阵英雄列表


local class_controler_team_sbh_list_item_node = import(".controler_team_sbh_list_item_node")
local controler_team_sbh_list_node = class("controler_team_sbh_list_node")


function controler_team_sbh_list_node:ctor(controler_team_sbh_list_node)
	self:_initModels()

	self._controler_team_sbh_list_node = controler_team_sbh_list_node
	self._heroListView = self._controler_team_sbh_list_node:getChildByName("herolist")

	self:_createControlerForUI()
	self:_registNodeEvent()
	self:_registUIEvent()
end

function controler_team_sbh_list_node:getView()
	return self._controler_team_sbh_list_node
end

function controler_team_sbh_list_node:addEventListener( callBack )
	self._controlerEventCallBack = callBack
end

--获取当前选中英雄
function controler_team_sbh_list_node:getCurSelectedHero()
	if self._heroListView:getChildrenCount() > 0 then
		return self._heroListView:getItem(self._curSelIdx).luaUserData:getHero()
	end
end


--countryIDList  国家ID列表, 如: countryIDList = {1, 2, 3}, 则列表显示魏, 蜀, 吴
function controler_team_sbh_list_node:updateListWithCountryIDList( countryIDList )
	self._heroListView:removeAllChildren()

	local heroCountryID = -1

	for i, hero in ipairs(self._heroList) do
		heroCountryID = hero:getCountryID()
		for _, countryID in ipairs(countryIDList) do
			if heroCountryID == countryID then
				self._heroListView:addChild(self._controlerMap.heroItems[i]:getView())
			end
		end
	end

	self._heroListView:refreshView()
	self._heroListView:jumpToTop()
	self._curSelIdx = 0
end


function controler_team_sbh_list_node:_initModels()
    self._controlerMap = {}
    self._controlerEventCallBack = nil
    self._heroList = MAIN_PLAYER:getHeroManager():cloneHerosDataToList()
    self:_sortHeroList()
    self._curSelIdx = 0
end

function controler_team_sbh_list_node:_createControlerForUI()
	self._controlerMap.heroItems = {}

	for i,v in ipairs(self._heroList) do
		self._controlerMap.heroItems[i] = class_controler_team_sbh_list_item_node.new()
		self._controlerMap.heroItems[i]:update(v)
		self._controlerMap.heroItems[i]:getView().luaUserData = self._controlerMap.heroItems[i]
		self._controlerMap.heroItems[i]:getView():retain()
	end

	self._heroListView:refreshView()
	self._heroListView:jumpToTop()
end

function controler_team_sbh_list_node:_registNodeEvent()
	local function onNodeEvent(tag)
        if tag == "exit" then
            for i,v in ipairs(self._heroList) do
				self._controlerMap.heroItems[i]:getView():release()
			end
        end
    end

    self._controler_team_sbh_list_node:registerScriptHandler(onNodeEvent)
end


function controler_team_sbh_list_node:_registUIEvent()
	local function listViewEvent(sender, eventType)
        if eventType == ccui.ListViewEventType.ONSELECTEDITEM_END then
        	self._curSelIdx = sender:getCurSelectedIndex()
        	self:_doEventCallBack(self, "onSelItemEnd")
        end
    end

    self._heroListView:addEventListener(listViewEvent)
end


function controler_team_sbh_list_node:_doEventCallBack( sender, eventName )
	if self._controlerEventCallBack ~= nil then
		self._controlerEventCallBack(sender, eventName)
	end
end


function controler_team_sbh_list_node:_sortHeroList()
	local battleHeroManager = MAIN_PLAYER:getTeamManager():getCurSelTeam():getBattleHeroManager()
	local curPos = TeamSelectedBattleHeroSystemInstance:getCurSelPos()
	local curSelHeroGUID = battleHeroManager:getPos(curPos):getHeroGUID()

	table.sort( self._heroList, SortRule.defaultSortrule )

	local battleHeroList = {}

	for i = #self._heroList, 1, -1 do
		local v = self._heroList[i]
		--如果为当前选中英雄
	    if v:getGUID() == curSelHeroGUID or
	    	battleHeroManager:isLeader() then
	    	--则移除
	        table.remove(self._heroList, i)
	    else
	    	--如果为上阵英雄
			if battleHeroManager:hasHero(v:getGUID()) then
				--则记录下来
				battleHeroList[#battleHeroList+1] = v
				table.remove(self._heroList, i)
			end
	    end
	end

	--将上阵英雄放置列表末尾
	for i,v in ipairs(battleHeroList) do
		self._heroList[#self._heroList+1] = v
	end
end

return controler_team_sbh_list_node



