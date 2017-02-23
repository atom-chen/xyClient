--
-- Author: Wu Hengmin
-- Date: 2015-07-29 19:35:29
--

local arena_view_1 = class("arena_view_1", cc.load("mvc").ViewBase)

arena_view_1.RESOURCE_FILENAME = "ui_instance/arena/arena_view_1.csb"

function arena_view_1:onCreate()
	-- body
	local node = {}
	for i=1,#MAIN_PLAYER.JJCManager.targetplayer do
		node[i] = self.resourceNode_:getChildByName("main_node"):getChildByName("node_"..i)
		node[i]:setCascadeOpacityEnabled(true)
		node[i].button = node[i]:getChildByName("button")
		local function clickEvent(sender, eventType)
			-- body
			print("点击挑战")
			gameTcp:SendMessage(MSG_C2MS_PVP_BEGIN, {
				MAIN_PLAYER.JJCManager.targetplayer[i].rank,
				1
				})

		end
		node[i].button:addClickEventListener(clickEvent)
	end

end

function arena_view_1:updateDisplay()
	-- body
	local node = {}
	for i=1,#MAIN_PLAYER.JJCManager.targetplayer do
		node[i] = self.resourceNode_:getChildByName("main_node"):getChildByName("node_"..i)
		node[i]:getChildByName("name"):setString(MAIN_PLAYER.JJCManager.targetplayer[i].data.owner_name)
		node[i]:getChildByName("rank"):setString(MAIN_PLAYER.JJCManager.targetplayer[i].rank)
		node[i]:getChildByName("zhanli"):setString(MAIN_PLAYER.JJCManager.targetplayer[i].fc)
	end

	self.resourceNode_:setVisible(true)
end

function arena_view_1:disable()
	-- body
	self.resourceNode_:setVisible(false)
end

return arena_view_1
