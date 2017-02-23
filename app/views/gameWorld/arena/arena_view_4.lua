--
-- Author: Wu Hengmin
-- Date: 2015-07-30 20:24:56
--

local arena_view_4 = class("arena_view_4", cc.load("mvc").ViewBase)

arena_view_4.RESOURCE_FILENAME = "ui_instance/arena/arena_view_4.csb"

function arena_view_4:onCreate()
	-- body

end

function arena_view_4:updateDisplay()
	-- body
	-- PeerageCfg
	local title = self.resourceNode_:getChildByName("main_node"):getChildByName("title")
	title:setString(PeerageCfg[MAIN_PLAYER.baseAttr._Title].name)

	local exp = self.resourceNode_:getChildByName("main_node"):getChildByName("exp")
	if MAIN_PLAYER.baseAttr._Title < #PeerageCfg then
		exp:setString(MAIN_PLAYER.baseAttr._TitleExp.."/"..PeerageCfg[MAIN_PLAYER.baseAttr._Title + 1].exp)
	else
		exp:setString(MAIN_PLAYER.baseAttr._TitleExp.."/0")
	end

	local atk = self.resourceNode_:getChildByName("main_node"):getChildByName("atk")
	atk:setString(PeerageCfg[MAIN_PLAYER.baseAttr._Title].atk)

	local hp = self.resourceNode_:getChildByName("main_node"):getChildByName("hp")
	hp:setString(PeerageCfg[MAIN_PLAYER.baseAttr._Title].hp)

	local wf = self.resourceNode_:getChildByName("main_node"):getChildByName("wf")
	wf:setString(PeerageCfg[MAIN_PLAYER.baseAttr._Title].pdef)

	local ff = self.resourceNode_:getChildByName("main_node"):getChildByName("ff")
	ff:setString(PeerageCfg[MAIN_PLAYER.baseAttr._Title].mdef)

	local descrip = self.resourceNode_:getChildByName("main_node"):getChildByName("descrip")
	descrip:setString(PeerageCfg[MAIN_PLAYER.baseAttr._Title].name)

	self.resourceNode_:setVisible(true)
end

function arena_view_4:disable()
	-- body
	self.resourceNode_:setVisible(false)
end

return arena_view_4
