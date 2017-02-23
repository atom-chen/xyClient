--
-- Author: Wu Hengmin
-- Date: 2015-08-29 10:47:49
--


local equip_screen = class("equip_screen", cc.load("mvc").ViewBase)

equip_screen.RESOURCE_FILENAME = "ui_instance/backpack/equip_screen.csb"

function equip_screen:onCreate()
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

	-- 武器
	local wei = self.resourceNode_:getChildByName("main_layout"):getChildByName("Button_1")
	local function weiClicked(sender)
		dispatchGlobaleEvent("backpack_ctrl", "updateScreen", {screen = 1})
		self:close()
	end
	wei:addClickEventListener(weiClicked)

	-- 头盔
	local shu = self.resourceNode_:getChildByName("main_layout"):getChildByName("Button_1_2")
	local function shuClicked(sender)
		dispatchGlobaleEvent("backpack_ctrl", "updateScreen", {screen = 2})
		self:close()
	end
	shu:addClickEventListener(shuClicked)

	-- 防具
	local wu = self.resourceNode_:getChildByName("main_layout"):getChildByName("Button_1_0")
	local function wuClicked(sender)
		dispatchGlobaleEvent("backpack_ctrl", "updateScreen", {screen = 3})
		self:close()
	end
	wu:addClickEventListener(wuClicked)

	-- 鞋子
	local qun = self.resourceNode_:getChildByName("main_layout"):getChildByName("Button_1_1")
	local function qunClicked(sender)
		dispatchGlobaleEvent("backpack_ctrl", "updateScreen", {screen = 4})
		self:close()
	end
	qun:addClickEventListener(qunClicked)

	-- 白
	local fu = self.resourceNode_:getChildByName("main_layout"):getChildByName("Button_1_3_3")
	local function fuClicked(sender)
		dispatchGlobaleEvent("backpack_ctrl", "updateScreen", {screen = 5})
		self:close()
	end
	fu:addClickEventListener(fuClicked)

	-- 绿
	local ming = self.resourceNode_:getChildByName("main_layout"):getChildByName("Button_1_3")
	local function mingClicked(sender)
		dispatchGlobaleEvent("backpack_ctrl", "updateScreen", {screen = 6})
		self:close()
	end
	ming:addClickEventListener(mingClicked)

	-- 蓝
	local shen = self.resourceNode_:getChildByName("main_layout"):getChildByName("Button_1_3_0")
	local function shenClicked(sender)
		dispatchGlobaleEvent("backpack_ctrl", "updateScreen", {screen = 7})
		self:close()
	end
	shen:addClickEventListener(shenClicked)

	-- 紫
	local zi = self.resourceNode_:getChildByName("main_layout"):getChildByName("Button_1_3_1")
	local function ziClicked(sender)
		dispatchGlobaleEvent("backpack_ctrl", "updateScreen", {screen = 8})
		self:close()
	end
	zi:addClickEventListener(ziClicked)

	-- 橙
	local cheng = self.resourceNode_:getChildByName("main_layout"):getChildByName("Button_1_3_2")
	local function chengClicked(sender)
		dispatchGlobaleEvent("backpack_ctrl", "updateScreen", {screen = 9})
		self:close()
	end
	cheng:addClickEventListener(chengClicked)

	-- 红
	local hong = self.resourceNode_:getChildByName("main_layout"):getChildByName("Button_1_3_3_0")
	local function hongClicked(sender)
		dispatchGlobaleEvent("backpack_ctrl", "updateScreen", {screen = 10})
		self:close()
	end
	hong:addClickEventListener(hongClicked)

	-- 全
	local quan = self.resourceNode_:getChildByName("main_layout"):getChildByName("Button_1_3_1_0")
	local function quanClicked(sender)
		dispatchGlobaleEvent("backpack_ctrl", "updateScreen", {screen = 0})
		self:close()
	end
	quan:addClickEventListener(quanClicked)


	self.resourceNode_:getChildByName("main_layout"):getChildByName("Text_5"):setString("武器x"..#MAIN_PLAYER.equipManager:getWuqi())
	self.resourceNode_:getChildByName("main_layout"):getChildByName("Text_5_0"):setString("头盔x"..#MAIN_PLAYER.equipManager:getToukui())
	self.resourceNode_:getChildByName("main_layout"):getChildByName("Text_5_1"):setString("防具x"..#MAIN_PLAYER.equipManager:getFangju())
	self.resourceNode_:getChildByName("main_layout"):getChildByName("Text_5_2"):setString("鞋子x"..#MAIN_PLAYER.equipManager:getXiezi())
	self.resourceNode_:getChildByName("main_layout"):getChildByName("Text_5_3_1_0"):setString("白装x"..#MAIN_PLAYER.equipManager:getBai())
	self.resourceNode_:getChildByName("main_layout"):getChildByName("Text_5_3_1"):setString("绿装x"..#MAIN_PLAYER.equipManager:getLv())
	self.resourceNode_:getChildByName("main_layout"):getChildByName("Text_5_3"):setString("蓝装x"..#MAIN_PLAYER.equipManager:getLan())
	self.resourceNode_:getChildByName("main_layout"):getChildByName("Text_5_3_0"):setString("紫装x"..#MAIN_PLAYER.equipManager:getZi())
	self.resourceNode_:getChildByName("main_layout"):getChildByName("Text_5_3_0_0"):setString("橙装x"..#MAIN_PLAYER.equipManager:getCheng())
	self.resourceNode_:getChildByName("main_layout"):getChildByName("Text_5_3_1_0_0"):setString("神装x"..#MAIN_PLAYER.equipManager:getHong())

end

function equip_screen:close()
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

return equip_screen
