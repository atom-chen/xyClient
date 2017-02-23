--
-- Author: Wu Hengmin
-- Date: 2015-08-22 16:01:13
--


local heroscreen = class("heroscreen", cc.load("mvc").ViewBase)

heroscreen.RESOURCE_FILENAME = "ui_instance/choose/hero_screen.csb"

function heroscreen:onCreate()
	-- body

	GLOBAL_COMMON_ACTION:popupOut({
			node = self.resourceNode_:getChildByName("main_layout"),
			shadowNode = self.resourceNode_:getChildByName("shadow_layout"),
		})

	-- 退出按钮
	local exit = self.resourceNode_:getChildByName("main_layout"):getChildByName("Button_10")
	local function exitClicked(sender)
		self:close()
	end
	exit:addClickEventListener(exitClicked)

	-- 魏
	local wei = self.resourceNode_:getChildByName("main_layout"):getChildByName("Button_1")
	local function weiClicked(sender)
		dispatchGlobaleEvent("chooseup_ctrl", "updateChoose", {screen = 1})
		self:close()
	end
	wei:addClickEventListener(weiClicked)

	-- 蜀
	local shu = self.resourceNode_:getChildByName("main_layout"):getChildByName("Button_1_2")
	local function shuClicked(sender)
		dispatchGlobaleEvent("chooseup_ctrl", "updateChoose", {screen = 2})
		self:close()
	end
	shu:addClickEventListener(shuClicked)

	-- 吴
	local wu = self.resourceNode_:getChildByName("main_layout"):getChildByName("Button_1_0")
	local function wuClicked(sender)
		dispatchGlobaleEvent("chooseup_ctrl", "updateChoose", {screen = 3})
		self:close()
	end
	wu:addClickEventListener(wuClicked)

	-- 群
	local qun = self.resourceNode_:getChildByName("main_layout"):getChildByName("Button_1_1")
	local function qunClicked(sender)
		dispatchGlobaleEvent("chooseup_ctrl", "updateChoose", {screen = 4})
		self:close()
	end
	qun:addClickEventListener(qunClicked)

	-- 副将
	local fu = self.resourceNode_:getChildByName("main_layout"):getChildByName("Button_1_3")
	local function fuClicked(sender)
		dispatchGlobaleEvent("chooseup_ctrl", "updateChoose", {screen = 5})
		self:close()
	end
	fu:addClickEventListener(fuClicked)

	-- 名将
	local ming = self.resourceNode_:getChildByName("main_layout"):getChildByName("Button_1_3_0")
	local function mingClicked(sender)
		dispatchGlobaleEvent("chooseup_ctrl", "updateChoose", {screen = 6})
		self:close()
	end
	ming:addClickEventListener(mingClicked)

	-- 神将
	local shen = self.resourceNode_:getChildByName("main_layout"):getChildByName("Button_1_3_1")
	local function shenClicked(sender)
		dispatchGlobaleEvent("chooseup_ctrl", "updateChoose", {screen = 7})
		self:close()
	end
	shen:addClickEventListener(shenClicked)

	-- 全部
	local quan = self.resourceNode_:getChildByName("main_layout"):getChildByName("Button_1_3_1_0")
	local function quanClicked(sender)
		dispatchGlobaleEvent("chooseup_ctrl", "updateChoose", {screen = 0})
		self:close()
	end
	quan:addClickEventListener(quanClicked)


	self.resourceNode_:getChildByName("main_layout"):getChildByName("Text_5"):setString("魏x"..#MAIN_PLAYER.heroManager:getHerosWei())
	self.resourceNode_:getChildByName("main_layout"):getChildByName("Text_5_0"):setString("蜀x"..#MAIN_PLAYER.heroManager:getHerosShu())
	self.resourceNode_:getChildByName("main_layout"):getChildByName("Text_5_1"):setString("吴x"..#MAIN_PLAYER.heroManager:getHerosWu())
	self.resourceNode_:getChildByName("main_layout"):getChildByName("Text_5_2"):setString("群x"..#MAIN_PLAYER.heroManager:getHerosQun())
	self.resourceNode_:getChildByName("main_layout"):getChildByName("Text_5_3"):setString("蓝色x"..#MAIN_PLAYER.heroManager:getHerosFu())
	self.resourceNode_:getChildByName("main_layout"):getChildByName("Text_5_3_0"):setString("紫色x"..#MAIN_PLAYER.heroManager:getHerosMing())
	self.resourceNode_:getChildByName("main_layout"):getChildByName("Text_5_3_0_0"):setString("橙色x"..#MAIN_PLAYER.heroManager:getHerosShen())
	

end

function heroscreen:close()
	-- body
    GLOBAL_COMMON_ACTION:popupBack({
            node = self.resourceNode_:getChildByName("main_layout"),
            shadowNode = self.resourceNode_:getChildByName("shadow_layout"),
            callback = function ()
                -- body
                self:removeFromParent(true)
            end
        })
end

return heroscreen
