--
-- Author: Wu Hengmin
-- Date: 2015-08-10 10:55:58
--

local heros_zhaomu_dialog = class("heros_zhaomu_dialog")

heros_zhaomu_dialog.RESOURCE_FILENAME_0 = "ui_instance/heros/heros_zhaomu_dialog_0.csb"
-- heros_zhaomu_dialog.RESOURCE_FILENAME_1 = "ui_instance/heros/heros_zhaomu_dialog_1.csb"

function heros_zhaomu_dialog:ctor(data)
	-- body
	self.data = data
	-- if #data == 5 then
		self.resourceNode_ = cc.CSLoader:createNode(self.RESOURCE_FILENAME_0)
	-- else
	-- 	self.resourceNode_ = cc.CSLoader:createNode(self.RESOURCE_FILENAME_1)
	-- end
	self:_registButtonEvent()
	self:_registGlobalEventListeners()
	self:update()
	self:click(0)
end

function heros_zhaomu_dialog:_registGlobalEventListeners()
	-- body
	self._globalEventListeners = {}
	local configs = {
		{modelName = "netMsg", eventName = tostring(MSG_MS2C_CHOOSE_DRAW_HERO), callBack=handler(self, self.close)},
	}

	self._globalEventListeners = createGlobalEventListenerWithConfig(configs)
end

function heros_zhaomu_dialog:getResourceNode()
	-- body
	return self.resourceNode_
end

function heros_zhaomu_dialog:_registButtonEvent()
    -- body
    local button_ok = self.resourceNode_:getChildByName("main_layout"):getChildByName("button_double")
    local function okClicked(sender)
    	if self.choose ~= 0 then
	    	gameTcp:SendMessage(MSG_C2MS_DRAW_SELECT, {self.choose, 0})
	    else

	    end
        self:close()
    end
    button_ok:addClickEventListener(okClicked)

 --    local button_double = self.resourceNode_:getChildByName("main_layout"):getChildByName("button_double")
 --    local function doubleClicked(sender)
 --    	if self.choose ~= 0 then
	--     	gameTcp:SendMessage(MSG_C2MS_CHOOSE_DRAW_HERO, {self.choose, 1})
	--     else

	--     end
 --        self:close()
 --    end
 --    if button_double then
	--     button_double:addClickEventListener(doubleClicked)
	-- end

	for i=1,#self.data do
		local wujiang = self.resourceNode_:getChildByName("main_layout"):getChildByName("wujiang_node_"..(i-1))
	    local function click(sender)
	        self:click(i)
	    end
	    wujiang:addClickEventListener(click)
	end

end

function heros_zhaomu_dialog:click(dex)
	-- body
	self.choose = dex
	for i=1,#self.data do
		local wujiang = self.resourceNode_:getChildByName("main_layout"):getChildByName("wujiang_node_"..(i-1))
	    if dex == i then
	    	wujiang:getChildByName("choose"):setVisible(true)
	    else
	    	wujiang:getChildByName("choose"):setVisible(false)
	    end
	end
end

function heros_zhaomu_dialog:update()
	-- body
	-- self.data
	for i=1,5 do
		local name = self.resourceNode_:getChildByName("main_layout"):getChildByName("wujiang_node_"..(i-1)):getChildByName("Text_1")

		name:setString(UIManager:createDropName(self.data[i].type_, self.data[i].id))
		local wujiang = self.resourceNode_:getChildByName("main_layout"):getChildByName("wujiang_node_"..(i-1)):getChildByName("wujiang")
		print(ResIDConfig:getConfig_cardframe(heroConfig[self.data[i].id].star).frameImage)
		wujiang:getChildByName("bg"):loadTexture(ResIDConfig:getConfig_cardframe(heroConfig[self.data[i].id].star).frameImage, ccui.TextureResType.localType)
		wujiang:getChildByName("icon"):loadTexture(ResIDConfig:getConfig_role(heroConfig[self.data[i].id].bigID).bigiconImage, ccui.TextureResType.localType)
	end
end

function heros_zhaomu_dialog:close()
	-- body
    GLOBAL_COMMON_ACTION:popupBack({
            node = self.resourceNode_:getChildByName("main_layout"),
            shadowNode = self.resourceNode_:getChildByName("shadow_layout"),
            callback = function ()
                -- body
                self:getResourceNode():removeFromParent(true)
            end
        })
end

return heros_zhaomu_dialog
