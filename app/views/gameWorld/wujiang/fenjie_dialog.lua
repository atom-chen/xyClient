--
-- Author: Wu Hengmin
-- Date: 2015-08-26 15:34:43
--


local fenjie_dialog = class("fenjie_dialog", cc.load("mvc").ViewBase)

fenjie_dialog.RESOURCE_FILENAME = "ui_instance/wujiang/fenjie_dialog.csb"

function fenjie_dialog:onCreate()
	-- body

	GLOBAL_COMMON_ACTION:popupOut({
			node = self.resourceNode_:getChildByName("main_layout"),
			shadowNode = self.resourceNode_:getChildByName("shadow_layout"),
		})

	-- 退出按钮
	local exit = self.resourceNode_:getChildByName("main_layout"):getChildByName("Button_2")
	local function exitClicked(sender)
		self:close()
	end
	exit:addClickEventListener(exitClicked)

	-- 分解按钮
	local fenjie = self.resourceNode_:getChildByName("main_layout"):getChildByName("Button_1")
	local function fenjieClicked(sender)
		-- 分解
	end
	fenjie:addClickEventListener(fenjieClicked)
	

end


function fenjie_dialog:update(data)
	-- body
	self.data = data
	local name = self.resourceNode_:getChildByName("main_layout"):getChildByName("Text_1_0_0")
	name:setString(heroConfig[data.id].name)

	local num = self.resourceNode_:getChildByName("main_layout"):getChildByName("Text_1_0_1_0")
	num:setString(data.count)


end

function fenjie_dialog:close()
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

return fenjie_dialog
