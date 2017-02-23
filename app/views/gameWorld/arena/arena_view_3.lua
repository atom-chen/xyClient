--
-- Author: Wu Hengmin
-- Date: 2015-07-30 19:31:53
--


local arena_view_3 = class("arena_view_3", cc.load("mvc").ViewBase)

arena_view_3.RESOURCE_FILENAME = "ui_instance/arena/arena_view_3.csb"

function arena_view_3:onCreate()
	-- body
	local node = {}
	for i=1,#MAIN_PLAYER.JJCManager.targetplayer do
		node[i] = self.resourceNode_:getChildByName("main_node"):getChildByName("node_"..i)
		node[i]:setCascadeOpacityEnabled(true)
		node[i].button = node[i]:getChildByName("button")
		local function clickEvent(sender, eventType)
			-- body
			print("点击查看")
			-- gameTcp:SendMessage(MSG_C2MS_PVP_BEGIN, {
			-- 	MAIN_PLAYER.JJCManager.targetplayer[i].rank,
			-- 	1
			-- 	})

		end
		node[i].button:addClickEventListener(clickEvent)
	end

	-- 上一页
	local button_page_p = self.resourceNode_:getChildByName("main_node"):getChildByName("button_page_p")
	local function pclickEvent(sender, eventType)
		-- body
		print("点击上一页")
		if self.page - 1 > 0 then
			gameTcp:SendMessage(MSG_C2MS_PVP_GET_RANK_INFO, {self.page - 1})
			self.page = self.page - 1
		end
		

	end
	button_page_p:addClickEventListener(pclickEvent)

	-- 下一页
	local button_page_n = self.resourceNode_:getChildByName("main_node"):getChildByName("button_page_next")
	local function pclickEvent(sender, eventType)
		-- body
		print("点击下一页")
		if self.page + 1 < 5000/PER_PAGE_NUM then
			gameTcp:SendMessage(MSG_C2MS_PVP_GET_RANK_INFO, {self.page + 1})
			self.page = self.page + 1
		end
	end
	button_page_n:addClickEventListener(pclickEvent)

	local page = self.resourceNode_:getChildByName("main_node"):getChildByName("page")
	self.page = 1
	page:setString(self.page.."/"..5000/PER_PAGE_NUM)
	
	

end

function arena_view_3:updateDisplay()
	-- body
	local node = {}
	for i=1,#MAIN_PLAYER.JJCManager.rankplayer do
		node[i] = self.resourceNode_:getChildByName("main_node"):getChildByName("node_"..i)
		node[i]:getChildByName("name"):setString(MAIN_PLAYER.JJCManager.rankplayer[i].data.owner_name)
		node[i]:getChildByName("rank"):setString(MAIN_PLAYER.JJCManager.rankplayer[i].rank)
		node[i]:getChildByName("zhanli"):setString(MAIN_PLAYER.JJCManager.rankplayer[i].fc)
	end


	local page = self.resourceNode_:getChildByName("main_node"):getChildByName("page")
	
	page:setString(self.page.."/"..5000/PER_PAGE_NUM)

	self.resourceNode_:setVisible(true)
end

function arena_view_3:disable()
	-- body
	self.resourceNode_:setVisible(false)
end


return arena_view_3