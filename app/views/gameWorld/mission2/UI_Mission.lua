--
-- Author: Wu Hengmin
-- Date: 2015-07-03 10:19:02
-- 任务界面

local UI_Mission = class("UI_Mission", cc.load("mvc").ViewBase)

local class_mission_view = import("app.views.gameWorld.mission2.mission_view.lua")

UI_Mission.RESOURCE_FILENAME = "ui_instance/mission2/mission_layer.csb"

UI_Mission.list = {
	{
		name = "日常",
		textures = {
			"ui_image/common/image/tab_0.png",
			"ui_image/common/image/tab_1.png",
			"ui_image/common/image/tab_0.png",
		},
	},
	{
		name = "任务",
		textures = {
			"ui_image/common/image/tab_0.png",
			"ui_image/common/image/tab_1.png",
			"ui_image/common/image/tab_0.png",
		},
	},
	{
		name = "成就",
		textures = {
			"ui_image/common/image/tab_0.png",
			"ui_image/common/image/tab_1.png",
			"ui_image/common/image/tab_0.png",
		},
	},
}

function UI_Mission:onCreate()
	-- body
	self:_registNodeEvent()
	self:_registGlobalEventListeners()


	self:_createControlerForUI()
	self:_initDynamicResConfig()

	self:_registButtonEvent()

	local size= cc.Director:getInstance():getVisibleSize()
    local rootNode = self:getResourceNode()
    rootNode:setContentSize(size)
    ccui.Helper:doLayout(rootNode)
    rootNode:setPosition(cc.p(display.cx - 640 ,display.cy - 360))

    local shadow_layout = rootNode:getChildByName("shadow_layout")
    shadow_layout:setContentSize(size)
    ccui.Helper:doLayout(shadow_layout)

	self:updateDisplay(1)
    
end

--注册节点事件
function UI_Mission:_registNodeEvent()
	local function onNodeEvent(event)
		if "exit" == event then
			self:_removeAllGlobalEventListeners()
		end
	end
	self.resourceNode_:registerScriptHandler(onNodeEvent)
end


function UI_Mission:_createControlerForUI()
	self._controlerMap = {}

	self.mission_view = class_mission_view.new(
			self.resourceNode_:getChildByName("main_layout"):getChildByName("guide"):getChildByName("ProjectNode_1")
		)


end

function UI_Mission:_registButtonEvent()
	-- body
	local button = self.resourceNode_:getChildByName("main_layout"):getChildByName("button_exit")
	local function exitClicked(sender)
		self:close(self._dynamicResConfigIDs)
	end
	button:addClickEventListener(exitClicked)


	local function onClicked(sender, eventType)
		-- body
		if eventType == ccui.TouchEventType.began then
	        globalTouchEvent(sender,eventType)
	    elseif eventType == ccui.TouchEventType.moved then
	        globalTouchEvent(sender,eventType)
	    elseif eventType == ccui.TouchEventType.ended then
	        if globalTouchEvent(sender,eventType) then
	            -- 改变按钮状态
	            self:updateButton(sender.index)
	            self:updateDisplay(sender.index)
	        end
	    elseif eventType == ccui.TouchEventType.canceled then

	    end
	end

	self.tabs = {}
	self.tabs[1] = self.resourceNode_:getChildByName("main_layout"):getChildByName("tab_1")
	self.tabs[1].index = 1
	self.tabs[1]:addTouchEventListener(onClicked)

	self.tabs[2] = self.resourceNode_:getChildByName("main_layout"):getChildByName("tab_2")
	self.tabs[2].index = 2
	self.tabs[2]:addTouchEventListener(onClicked)

	self:updateButton(1)
	
end

function UI_Mission:_registGlobalEventListeners()
	-- body
	self._globalEventListeners = {}
	local configs = {
		{modelName = "model_missionManager", eventName = "refreshlist", callBack=handler(self, self.updateDisplay)},
		{modelName = "model_missionManager", eventName = "recordID", callBack=handler(self, self.recordID)},
		{modelName = "netMsg", eventName = tostring(MSG_MS2C_COMPLETE_MISSION), callBack=handler(self, self.receivedMission)},
		
	}
	self._globalEventListeners = createGlobalEventListenerWithConfig(configs)
end

function UI_Mission:receivedMission(params)
    -- body
    print("receivedMission")
    local nextAdds = nil
    if params then
        nextAdds = params._usedata.nextAdds
        print("后续数量:"..#nextAdds)
    end

    if self.index == 1 then -- 日常任务
    	print("移除ID:"..self.forwardDex)
        for i=1,#MAIN_PLAYER.missionManager.dailys do
        	if MAIN_PLAYER.missionManager.dailys[i].rewardID == self.forwardDex then
        		table.remove(MAIN_PLAYER.missionManager.dailys, i)
        		break
        	end
        end
        -- 加入新的
        if nextAdds then
            for i=1,#nextAdds do
            	print("加入新任务")
                MAIN_PLAYER.missionManager:addDaily(nextAdds[i])
            end
        end
    elseif self.index == 2 then -- 普通任务
    	print("移除ID:"..self.forwardDex)
        for i=1,#MAIN_PLAYER.missionManager.missions do
        	if MAIN_PLAYER.missionManager.missions[i].rewardID == self.forwardDex then
        		table.remove(MAIN_PLAYER.missionManager.missions, i)
        		break
        	end
        end
        -- 加入新的
        if nextAdds then
            for i=1,#nextAdds do
            	print("加入新任务")
                MAIN_PLAYER.missionManager:addMission(nextAdds[i])
            end
        end
    end
    self:updateDisplay()
end

function UI_Mission:recordID(params)
	-- body
	self.forwardDex = params._usedata.recordID
	print("记录ID:"..params._usedata.recordID)
end

function UI_Mission:_removeAllGlobalEventListeners()
	for k,v in pairs(self._globalEventListeners) do
		GLOBAL_EVENT_DISPTACHER:removeEventListener(v)
	end
end


function UI_Mission:close(res)
	-- body
	GLOBAL_COMMON_ACTION:popupBack({
			node = self.resourceNode_:getChildByName("main_layout"),
			shadowNode = self.resourceNode_:getChildByName("shadow_layout"),
			callback = function ()
				-- body
				self:removeFromParent(true)
				release_res(res)
			end
		})
end


function UI_Mission:_initDynamicResConfig()
	ResConfig["ui_image/goods/goods"] = {
		restype = "plist",
		respath = "ui_image/goods/",
		res = {"goods"}
	}

	self._dynamicResConfigIDs = {
		"ui_image/goods/goods",
	}
end

function UI_Mission:updateButton(index)
	-- body
	for i=1,#self.tabs do
		if index == i then
			self.tabs[i]:loadTexture(self.list[i].textures[2], ccui.TextureResType.plistType)
		else
			self.tabs[i]:loadTexture(self.list[i].textures[1], ccui.TextureResType.plistType)
		end
	end
end

function UI_Mission:updateData()
	-- body

end

function UI_Mission:sort()
    -- body
    for i=1,#MAIN_PLAYER.missionManager.missions do
        if MAIN_PLAYER.missionManager.missions[i].isComplete then
            table.insert(MAIN_PLAYER.missionManager.missions, 1, MAIN_PLAYER.missionManager.missions[i])
            table.remove(MAIN_PLAYER.missionManager.missions, i+1)
        end
    end
    for i=1,#MAIN_PLAYER.missionManager.dailys do
        if MAIN_PLAYER.missionManager.dailys[i].isComplete then
            table.insert(MAIN_PLAYER.missionManager.dailys, 1, MAIN_PLAYER.missionManager.dailys[i])
            table.remove(MAIN_PLAYER.missionManager.dailys, i+1)
        end
    end
    for i=1,#MAIN_PLAYER.missionManager.achieves do
        if MAIN_PLAYER.missionManager.achieves[i].isComplete then
            table.insert(MAIN_PLAYER.missionManager.achieves, 1, MAIN_PLAYER.missionManager.achieves[i])
            table.remove(MAIN_PLAYER.missionManager.achieves, i+1)
        end
    end
end

function UI_Mission:updateDisplay(index)
	-- body
	if index and type(index) == "number" then
		self.index = index
	end
    self:sort()


	if self.index == 1 then -- 日常
		self.displayData = MAIN_PLAYER.missionManager.dailys
	elseif self.index == 2 then -- 任务
		self.displayData = MAIN_PLAYER.missionManager.missions
	elseif self.index == 3 then -- 成就
		self.displayData = MAIN_PLAYER.missionManager.achieves
	end


	self.mission_view:update(self.displayData)

end

return UI_Mission
