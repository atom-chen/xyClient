--
-- Author: lipeng
-- Date: 2015-08-28 18:37:11
-- 

local class_controler_pageView = require(FILE_PATH.PATH_VIEWS_BASE..".controler_pageView")

local PER_PAGE_ITEM_NUM = 3

local controler_team2_change_hero_node = class("controler_team2_change_hero_node")

function controler_team2_change_hero_node:ctor( team2_change_hero_node, curSelIdx )
	self:_initModels()

	self._curSelIdx = curSelIdx
	self._team2_change_hero_node = team2_change_hero_node

	self:_createControlerForUI()
	self:_registUIEvent()
	self:_registNodeEvent()
	self:_registGlobalEventListeners()
end

function controler_team2_change_hero_node:getView()
	return self._team2_change_hero_node
end


function controler_team2_change_hero_node:addEventListener( callBack )
	self._controlerEventCallBack = callBack
end

function controler_team2_change_hero_node:setCurSelHero( curSelHero )
	self._curSelHero = curSelHero
	self:_updateView_heroInfoPanle(
		self._team2_change_hero_node:getChildByName("curSelHeroInfo"),
		self._curSelHero
	)

	self:_sortHeroList()

	local maxPageNum = 1
	if #self._heroList > 0 then
		if #self._heroList % PER_PAGE_ITEM_NUM == 0 then
			maxPageNum = math.floor(#self._heroList / PER_PAGE_ITEM_NUM)
		else
			maxPageNum = math.floor(#self._heroList / PER_PAGE_ITEM_NUM) + 1
		end
	end

	self._controlerMap.pageView:setMaxDataPageNum(maxPageNum)
	self._controlerMap.pageView:turnToPage(1)

	self:_updateView_pageNum()
end


function controler_team2_change_hero_node:_initModels()
	self._controlerMap = {}
	self._controlerEventCallBack = nil

	self._curSelHero = nil
	self._heroList = MAIN_PLAYER:getHeroManager():cloneHerosDataToList()
end


function controler_team2_change_hero_node:_createControlerForUI()
	self._controlerMap.pageView = class_controler_pageView.new(
		self._team2_change_hero_node:getChildByName("pageView") 
	)

	self._controlerMap.pageView:setMaxDataPageNum(1)
	self._controlerMap.pageView:setPageUpdateCallBack(handler(self, self._onPageUpdate))
end

function controler_team2_change_hero_node:_onPageUpdate( dataPageIdx, panle )
	self:_updateView_pageNum()

	for i=1, 3 do
		local heroInfoPanle = panle:getChildByName("heroInfo"..i)
		--数据在列表中的索引
		local dataInListIdx = (dataPageIdx-1)*3+i
		local heroData = self._heroList[dataInListIdx]
		if heroData ~= nil then
			--更换武将
			local btn_changeHero = heroInfoPanle:getChildByName("btn_changeHero")
		    local function btn_changeHeroTouchEvent(sender,eventType)
		        if eventType == ccui.TouchEventType.ended then
		        	local newHeroGUID = heroData:getGUID()
		        	teamSystem2Instance:sendNetMsg_changeMember(self._curSelIdx, newHeroGUID)
		        end
		    end
		    btn_changeHero:addTouchEventListener(btn_changeHeroTouchEvent)

			heroInfoPanle:setVisible(true)
		else
			heroInfoPanle:setVisible(false)
		end
		self:_updateView_heroInfoPanle(heroInfoPanle, heroData)
	end
end

--注册节点事件
function controler_team2_change_hero_node:_registNodeEvent()
    local function onNodeEvent(event)
        if "exit" == event then
            self:_removeAllGlobalEventListeners()
        end
    end
    self._team2_change_hero_node:registerScriptHandler(onNodeEvent)
end

function controler_team2_change_hero_node:_removeAllGlobalEventListeners()
    for k,v in pairs(self._globalEventListeners) do
        GLOBAL_EVENT_DISPTACHER:removeEventListener(v)
    end
end

function controler_team2_change_hero_node:_registUIEvent()
	local UIContainer = self._team2_change_hero_node

	--左翻页
	local btn_leftTurnPage = UIContainer:getChildByName("btn_leftTurnPage")
    local function btn_leftTurnPageTouchEvent(sender,eventType)
        if eventType == ccui.TouchEventType.ended then
            if self._controlerMap.pageView:getMaxDataPageNum() > 1 then
	    		self._controlerMap.pageView:leftTurnPage()
	    	end
        end
    end
    btn_leftTurnPage:addTouchEventListener(btn_leftTurnPageTouchEvent)

    --右翻页
    local btn_rightTurnPage = UIContainer:getChildByName("btn_rightTurnPage")
    local function btn_rightTurnPageTouchEvent(sender,eventType)
        if eventType == ccui.TouchEventType.ended then
            if self._controlerMap.pageView:getMaxDataPageNum() > 1 then
		        self._controlerMap.pageView:rightTurnPage()
	    	end
        end
    end
    btn_rightTurnPage:addTouchEventListener(btn_rightTurnPageTouchEvent)

    --关闭
    local btn_close = UIContainer:getChildByName("btn_close")
    local function btn_closeTouchEvent(sender,eventType)
        if eventType == ccui.TouchEventType.ended then
            self:_doEventCallBack(self, "btn_closeTouchEvent")
        end
    end
    btn_close:addTouchEventListener(btn_closeTouchEvent)


    --卸下当前选中成员
    local btn_unload = UIContainer:getChildByName("curSelHeroInfo"):
    						getChildByName("btn_unload")
    local function btn_unloadTouchEvent(sender,eventType)
        if eventType == ccui.TouchEventType.ended then
        	teamSystem2Instance:sendNetMsg_changeMember(
            	self._curSelIdx, NULL_GUID
            )
        end
    end
    btn_unload:addTouchEventListener(btn_unloadTouchEvent)

    --筛选
    local btn_saixuan = UIContainer:getChildByName("btn_saixuan")
    local function btn_saixuanTouchEvent(sender,eventType)
        if eventType == ccui.TouchEventType.ended then
        	UIManager:createWujiangScreenDialog()
        end
    end
    btn_saixuan:addTouchEventListener(btn_saixuanTouchEvent)
end


function controler_team2_change_hero_node:_registGlobalEventListeners()
	self._globalEventListeners = {}
	local configs = {
		{modelName = "wujiang_ctrl", eventName = "updateScreen", callBack=handler(self, self._onEvent_updateScreen)},
	}
	self._globalEventListeners = createGlobalEventListenerWithConfig(configs)
end


function controler_team2_change_hero_node:_updateView_heroInfoPanle( heroInfoPanle, heroData )
	if heroData ~= nil then
		--名字
		heroInfoPanle:getChildByName("name"):setString(heroData:getName())
		
		--icon
		local main_layout = heroInfoPanle:getChildByName("main_layout")
		HERO_ICON_LARGE_HELPER:updateIcon(
			{
				bgImg = main_layout:getChildByName("bg"),
				iconImg = main_layout:getChildByName("icon"),
				heroTempleateID = heroData:getTempleateID()
			}
		)

		--战斗力
		heroInfoPanle:getChildByName("text_powerValue"):
			setString(heroData:getPower(MAIN_PLAYER:getBaseAttr():getLv()))
		
	else
		--名字
		heroInfoPanle:getChildByName("name"):setString("--")
		
		--icon
		local main_layout = heroInfoPanle:getChildByName("main_layout")
		HERO_ICON_LARGE_HELPER:updateIcon(
			{
				bgImg = main_layout:getChildByName("bg"),
				iconImg = main_layout:getChildByName("icon"),
				heroTempleateID = -1
			}
		)

		--战斗力
		heroInfoPanle:getChildByName("text_powerValue"):
			setString(0)
	end
end



function controler_team2_change_hero_node:_updateView_pageNum()
	self._team2_change_hero_node:
		getChildByName("text_pageValue"):
		setString(
			string.format("%d/%d", 
				self._controlerMap.pageView:getCurInDataPageIdx(), 
				self._controlerMap.pageView:getMaxDataPageNum()
			)
		)
end



function controler_team2_change_hero_node:_sortHeroList()
	local battleHeroManager = MAIN_PLAYER:getTeamManager():getCurSelTeam():getBattleHeroManager()
	local curSelHeroGUID = NULL_GUID
	if self._curSelHero ~= nil then
		curSelHeroGUID = self._curSelHero:getGUID()
	end
	
	table.sort( self._heroList, SortRule.defaultSortrule )

	local battleHeroList = {}

	for i = #self._heroList, 1, -1 do
		local v = self._heroList[i]
		--如果为当前选中英雄
	    if v:getGUID() == curSelHeroGUID or
	    	battleHeroManager:isLeader(v:getGUID()) then
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


function controler_team2_change_hero_node:_onEvent_updateScreen(event)
	--筛选方式
	local filterType = event._usedata.screen

	if filterType == 1 then -- 魏
		self._heroList = MAIN_PLAYER.heroManager:getHerosWei()
	elseif filterType == 2 then -- 蜀
		self._heroList = MAIN_PLAYER.heroManager:getHerosShu()
	elseif filterType == 3 then -- 吴
		self._heroList = MAIN_PLAYER.heroManager:getHerosWu()
	elseif filterType == 4 then -- 群
		self._heroList = MAIN_PLAYER.heroManager:getHerosQun()
	elseif filterType == 5 then -- 副
		self._heroList = MAIN_PLAYER.heroManager:getHerosFu()
	elseif filterType == 6 then -- 名
		self._heroList = MAIN_PLAYER.heroManager:getHerosMing()
	elseif filterType == 7 then -- 神
		self._heroList = MAIN_PLAYER.heroManager:getHerosShen()
	elseif filterType == 0 then -- 全
		self._heroList = MAIN_PLAYER.heroManager:getHerosQuan()
	end

	self:_sortHeroList()

	local maxPageNum = 1
	if #self._heroList > 0 then
		if #self._heroList % PER_PAGE_ITEM_NUM == 0 then
			maxPageNum = math.floor(#self._heroList / PER_PAGE_ITEM_NUM)
		else
			maxPageNum = math.floor(#self._heroList / PER_PAGE_ITEM_NUM) + 1
		end
	end

	self._controlerMap.pageView:setMaxDataPageNum(maxPageNum)
	self._controlerMap.pageView:turnToPage(1)

	self:_updateView_pageNum()
end


function controler_team2_change_hero_node:_doEventCallBack( sender, eventName )
	if self._controlerEventCallBack ~= nil then
		self._controlerEventCallBack(sender, eventName)
	end
end


return controler_team2_change_hero_node
