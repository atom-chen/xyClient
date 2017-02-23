--
-- Author: Wu Hengmin
-- Date: 2015-08-18 11:06:24
--

local wujiangup_listview = class("wujiangup_listview")


local class_wujiang_item = import("app.views.gameWorld.wujiangup.wujiangup_listitem.lua")

function wujiangup_listview:ctor(node)
	-- body

	local visibleSize = cc.Director:getInstance():getVisibleSize()
	
	self._rootNode = node
	-- self._rootNode:setContentSize(visibleSize)
    -- ccui.Helper:doLayout(self._rootNode)

    self:init()
    self:_registUIEvent()

	self:_registNodeEvent()
	self:_registGlobalEventListeners()

    self.wujiangitemModel = cc.CSLoader:createNode("ui_instance/wujiangup/wujiang_item.csb")
    self.wujiangitemModel:retain()

    self.items = {}
end

function wujiangup_listview:init()
	-- body
	self._rootNode:setCascadeOpacityEnabled(true)
end

function wujiangup_listview:_registGlobalEventListeners()
	-- body
	self._globalEventListeners = {}
	local configs = {
		{modelName = "wujiang_ctrl", eventName = "updateScreen", callBack=handler(self, self.updateScreen)},
		{modelName = "wujiangup_ctrl", eventName = "updateChoose", callBack=handler(self, self.updateChoose)},
		{modelName = "model_heroManager", eventName = "juexing", callBack=handler(self, self.updateList)},
		{modelName = "model_heroManager", eventName = "skill", callBack=handler(self, self.updateList)},
		{modelName = "model_heroManager", eventName = "zhiye", callBack=handler(self, self.updateList)},


	}
	self._globalEventListeners = createGlobalEventListenerWithConfig(configs)
end

function wujiangup_listview:_registNodeEvent()
	local function onNodeEvent(event)
		if "exit" == event then
			self:_removeAllGlobalEventListeners()
		end
	end
	self._rootNode:registerScriptHandler(onNodeEvent)
end

function wujiangup_listview:_removeAllGlobalEventListeners()
	for k,v in pairs(self._globalEventListeners) do
		GLOBAL_EVENT_DISPTACHER:removeEventListener(v)
	end
end

function wujiangup_listview:getResourceNode()
	-- body
	return self._rootNode
end


function wujiangup_listview:_registUIEvent()
	-- body

end

function wujiangup_listview:updateData()
	-- body
	self.displayData = MAIN_PLAYER.heroManager:getHerosQuan()

	for i=1,#self.displayData do
		print("MaxPlayerTeamNum="..MaxPlayerTeamNum)
		if self.displayData[i]:isInTeam() then
			table.insert(self.displayData, self.displayData[i])
			table.remove(self.displayData, i+1)
		end
	end

end

function wujiangup_listview:updateScreen(params)
	-- body
	self.screen = params._usedata.screen

	if self.screen == 1 then -- 魏
		self.displayData = MAIN_PLAYER.heroManager:getHerosWei()
	elseif self.screen == 2 then -- 蜀
		self.displayData = MAIN_PLAYER.heroManager:getHerosShu()
	elseif self.screen == 3 then -- 吴
		self.displayData = MAIN_PLAYER.heroManager:getHerosWu()
	elseif self.screen == 4 then -- 群
		self.displayData = MAIN_PLAYER.heroManager:getHerosQun()
	elseif self.screen == 5 then -- 副
		self.displayData = MAIN_PLAYER.heroManager:getHerosFu()
	elseif self.screen == 6 then -- 名
		self.displayData = MAIN_PLAYER.heroManager:getHerosMing()
	elseif self.screen == 7 then -- 神
		self.displayData = MAIN_PLAYER.heroManager:getHerosShen()
	elseif self.screen == 0 then -- 全
		self.displayData = MAIN_PLAYER.heroManager:getHerosQuan()
	end
	for i=1,#self.displayData do
		if self.displayData[i]:isInTeam() then
			table.insert(self.displayData, self.displayData[i])
			table.remove(self.displayData, i+1)
		end
	end
	self:update(false)
end

function wujiangup_listview:update(isupdatedata)
	-- body
	if isupdatedata then
		self:updateData()
	end
	local stary = 110*(#self.displayData-1)

	self._rootNode:getChildByName("ScrollView_1"):removeAllChildren()
	for i=1,#self.displayData do
		self.items[i] = class_wujiang_item.new(
				self.wujiangitemModel:getChildByName("main_layout"):clone()
			)
		self.items[i]:getResourceNode():setPosition(20, stary - (i-1)*110)
		self.items[i]:update(self.displayData[i])
		self._rootNode:getChildByName("ScrollView_1"):addChild(self.items[i]:getResourceNode())
	end
	local size = cc.size(0, 110*#self.displayData)
    self._rootNode:getChildByName("ScrollView_1"):setInnerContainerSize(size)
	
end

function wujiangup_listview:updateList()
	-- body
	print("暂时更新列表")
	self:updateData()
	for i=1,#self.displayData do
		self.items[i]:update(self.displayData[i])
	end
end

function wujiangup_listview:updateChoose(params)
	-- body
	local guid = ""
	if type(params) == "string" then
		guid = params
	else
		guid = params._usedata.data.guid
	end

	for i=1,#self.displayData do
		if self.displayData[i].guid == guid then
			self.items[i]:isChoose(true)
		else
			self.items[i]:isChoose(false)
		end

	end
end

function wujiangup_listview:getFirst()
	-- body
	return self.displayData[1]
end


return wujiangup_listview
