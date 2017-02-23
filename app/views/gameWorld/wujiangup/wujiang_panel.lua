--
-- Author: Wu Hengmin
-- Date: 2015-08-18 14:34:26
--

local wujiang_panel = class("wujiang_panel")

function wujiang_panel:ctor(node)
	-- body
	self._rootNode = node
	self:_registGlobalEventListeners()
	self:_registNodeEvent()
end

function wujiang_panel:_registGlobalEventListeners()
	-- body
	self._globalEventListeners = {}
	local configs = {
		{modelName = "wujiang_ctrl", eventName = "updatePanel", callBack=handler(self, self.update)},
		{modelName = "model_heroManager", eventName = "skill", callBack=handler(self, self.update)},
		{modelName = "model_heroManager", eventName = "zhiye", callBack=handler(self, self.update)},
		{modelName = "model_heroManager", eventName = "juexing", callBack=handler(self, self.update)},
		{modelName = "model_heroManager", eventName = "juexing", callBack=handler(self, self.playAni_Juexing)},
	}
	self._globalEventListeners = createGlobalEventListenerWithConfig(configs)
end

--移除全局事件监听器
function wujiang_panel:_removeAllGlobalEventListeners()
	for k,v in pairs(self._globalEventListeners) do
		GLOBAL_EVENT_DISPTACHER:removeEventListener(v)
	end
end

function wujiang_panel:_registNodeEvent()
    local function onNodeEvent(event)
        if "exit" == event then
        	self:_removeAllGlobalEventListeners()
        end
    end
    self._rootNode:registerScriptHandler(onNodeEvent)
end

function wujiang_panel:update(data)
	-- body
	if data._usedata and data._usedata.data then
		print("123")
		self.data = data._usedata.data
	end
	print(2)

	-- 名字
	local name = self._rootNode:getChildByName("Text_3_1")
	name:setString(heroConfig[self.data.id].name)

	-- 战力
	local zhanli = self._rootNode:getChildByName("Text_3_0_0")
	zhanli:setString(self.data:getZhanli())

	-- 头像
	local iconNode = self._rootNode:getChildByName("icon_node")
	local bg = iconNode:getChildByName("Image_31")
	local herodata = heroConfig[self.data.id]
	bg:loadTexture(ResIDConfig:getConfig_cardframe(herodata.star).frameImage, ccui.TextureResType.localType)
	local avatar = iconNode:getChildByName("Image_32")
	avatar:loadTexture(ResIDConfig:getConfig_role(herodata.bigID).bigiconImage, ccui.TextureResType.localType)


end

-- 播放觉醒动画
function wujiang_panel:playAni_Juexing()
	-- body
	-- 后部效果
	local effect1 = self._rootNode:getChildByName("icon_node"):getChildByName("ArmatureNode_2")
	effect1:setVisible(true)
	local function animationEvent(armatureBack,movementType,movementID)
        if movementType == ccs.MovementEventType.loopComplete then

        elseif movementType == ccs.MovementEventType.complete then
        	effect1:setVisible(false)
        elseif movementType == ccs.MovementEventType.start then

        end
    end
    effect1:getAnimation():setMovementEventCallFunc(animationEvent)
	effect1:getAnimation():play("Animation1", -1 , 0)

	-- 前部效果
	local effect2 = self._rootNode:getChildByName("icon_node"):getChildByName("ArmatureNode_1")
	effect2:setVisible(true)
	local function animationEvent(armatureBack,movementType,movementID)
        if movementType == ccs.MovementEventType.loopComplete then

        elseif movementType == ccs.MovementEventType.complete then
        	effect2:setVisible(false)
        elseif movementType == ccs.MovementEventType.start then

        end
    end
    effect2:getAnimation():setMovementEventCallFunc(animationEvent)
	effect2:getAnimation():play("Animation2", -1 , 0)
end

return wujiang_panel
