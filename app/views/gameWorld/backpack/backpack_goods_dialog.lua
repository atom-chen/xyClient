--
-- Author: Wu Hengmin
-- Date: 2015-08-12 10:08:51
--


local backpack_goods_dialog = class("backpack_goods_dialog", cc.load("mvc").ViewBase)

backpack_goods_dialog.RESOURCE_FILENAME = "ui_instance/backpack/backpack_goods_dialog.csb"

function backpack_goods_dialog:onCreate()
	-- body

	GLOBAL_COMMON_ACTION:popupOut({
			node = self.resourceNode_:getChildByName("main_layout"),
			shadowNode = self.resourceNode_:getChildByName("shadow_layout"),
		})

	-- 退出按钮
	local exit = self.resourceNode_:getChildByName("main_layout"):getChildByName("Button_16")
	local function exitClicked(sender)
		self:close()
	end
	exit:addClickEventListener(exitClicked)

	-- 出售按钮
	local sale = self.resourceNode_:getChildByName("main_layout"):getChildByName("Panel_16"):getChildByName("Button_13")
	local function saleClicked(sender)
		UIManager:createGoodsSaleDialog(self.data)
		self:close()
	end
	sale:addClickEventListener(saleClicked)

	-- 使用按钮
	local use = self.resourceNode_:getChildByName("main_layout"):getChildByName("Panel_16"):getChildByName("Button_13_0")
	local function useClicked(sender)
		gameTcp:SendMessage(MSG_C2MS_ITEMS_USE, {self.data.id, 1})
		self:close()
	end
	use:addClickEventListener(useClicked)

end

function backpack_goods_dialog:update(data)
	-- body
	-- icon
	self.data = data
	local iconNode = self.resourceNode_:getChildByName("main_layout"):getChildByName("Panel_16"):getChildByName("Panel_17")
	local icon = UIManager:CreateDropOutFrame(
		"道具",
		data.id
	):getResourceNode()
	if icon then
		icon:setSwallowTouches(false)
		icon:setCascadeOpacityEnabled(true)
		icon:setPosition(43, 43)
		iconNode:addChild(icon)
	end

	-- 名字
	local name = self.resourceNode_:getChildByName("main_layout"):getChildByName("Panel_16"):getChildByName("Text_48")
	name:setString(ItemsConfig[data.id].name)

	-- 描述
	local descrip = self.resourceNode_:getChildByName("main_layout"):getChildByName("Panel_16"):getChildByName("Text_50")
	descrip:setString(ItemsConfig[data.id].info)


	-- 是否显示使用按钮
	if ItemsConfig[data.id].use_fun then
		self.resourceNode_:getChildByName("main_layout"):getChildByName("Panel_16"):getChildByName("Button_13_0"):setVisible(true)
	else
		self.resourceNode_:getChildByName("main_layout"):getChildByName("Panel_16"):getChildByName("Button_13_0"):setVisible(false)
	end

	-- 是否显示出售按钮
	if ItemsConfig[data.id].price > 0 then
		self.resourceNode_:getChildByName("main_layout"):getChildByName("Panel_16"):getChildByName("Button_13"):setVisible(true)
	else
		self.resourceNode_:getChildByName("main_layout"):getChildByName("Panel_16"):getChildByName("Button_13"):setVisible(false)
	end

end

function backpack_goods_dialog:close()
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

return backpack_goods_dialog
