--
-- Author: Wu Hengmin
-- Date: 2015-08-07 11:05:07
--
local goods_get = class("goods_get", cc.load("mvc").ViewBase)

goods_get.RESOURCE_FILENAME = "ui_instance/trial/trial_boss_dialog.csb"

function goods_get:onCreate()
	-- body
	self:_registButtonEvent()

	GLOBAL_COMMON_ACTION:popupOut({
			node = self.resourceNode_:getChildByName("main_layout"),
			shadowNode = self.resourceNode_:getChildByName("shadow_layout"),
		})
end

function goods_get:update(k)
	-- body
	self.k = k

end

function goods_get:_registButtonEvent()
    -- body
    local button = self.resourceNode_:getChildByName("main_layout"):getChildByName("button_exit")
    local function exitClicked(sender)
        self:close()
    end
    button:addClickEventListener(exitClicked)


    local start = self.resourceNode_:getChildByName("main_layout"):getChildByName("Button_5")
    local function startClicked(sender)
        print("进攻")
        gameTcp:SendMessage(MSG_C2MS_CAMPAIGN_BOSS_BEGIN, {self.k, 1})
    end
    start:addClickEventListener(startClicked)
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

