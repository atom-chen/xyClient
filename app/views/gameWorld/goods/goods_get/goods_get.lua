--
-- Author: Wu Hengmin
-- Date: 2015-07-18 10:03:49
--
local goods_get = class("goods_get", cc.load("mvc").ViewBase)

goods_get.RESOURCE_FILENAME = "ui_instance/goods/goods_get/goods_get.csb"

function goods_get:onCreate()
	-- body
	self:_registButtonEvent()

	GLOBAL_COMMON_ACTION:popupOut({
			node = self.resourceNode_:getChildByName("main_layout"),
			shadowNode = self.resourceNode_:getChildByName("shadow_layout"),
		})
end

function goods_get:update(data)
	-- body
	local scrollview = self.resourceNode_:getChildByName("main_layout"):getChildByName("scrollview")

	x = 70
	y = 520
	for i=1,#data do
		-- if data[i].type_ ~= eDT_CardPiece then
			local icon = UIManager:CreateDropOutFrame(data[i].type_, data[i].ID)
			if icon then
				icon:getResourceNode():setCascadeOpacityEnabled(true)
				icon:setCount(data[i].num)
				icon:getResourceNode():setPosition(x, y)
				scrollview:addChild(icon:getResourceNode())
			else
				print("未成功生成icon")
			end
			if x == 430 then
				x = 70
				y = 500 - 120
			else
				x = x + 120
			end
		-- end
	end
end

function goods_get:_registButtonEvent()
    -- body
    local button = self.resourceNode_:getChildByName("main_layout"):getChildByName("button_exit")
    local function exitClicked(sender)
        self:close()
    end
    button:addClickEventListener(exitClicked)
end

function goods_get:close()
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

return goods_get
