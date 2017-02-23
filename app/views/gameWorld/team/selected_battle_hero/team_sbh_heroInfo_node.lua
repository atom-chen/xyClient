--
-- Author: lipeng
-- Date: 2015-07-20 10:37:44
-- 控制器: 武将信息

local team_sbh_heroInfo_node = class("team_sbh_heroInfo_node")

function team_sbh_heroInfo_node:ctor(team_sbh_heroInfo_node)
	self:_initModels()

	self._team_sbh_heroInfo_node = team_sbh_heroInfo_node
	self._scrollView = self._team_sbh_heroInfo_node:getChildByName("scrollView")
	self._attr_layout = self._scrollView:getChildByName("attr_layout")

	self:_registUIEvent()
end


function team_sbh_heroInfo_node:setHero(hero)
	self._hero = hero
	self:_updateView()
end


function team_sbh_heroInfo_node:_initModels()
	self._controlerEventCallBack = nil
	self._hero = nil
end

function team_sbh_heroInfo_node:_registUIEvent()
    local cbtn_shengping = self._scrollView:getChildByName("attr_layout"):getChildByName("cbtn_shengping")
	local function cbtn_shengping_touchEvent(sender, eventType)
		if eventType == ccui.CheckBoxEventType.selected then
			self._attr_layout:getChildByName("attr_node"):setVisible(false)
			self._attr_layout:getChildByName("descrip_node"):setVisible(true)
		else
			self._attr_layout:getChildByName("attr_node"):setVisible(true)
			self._attr_layout:getChildByName("descrip_node"):setVisible(false)
		end
    end
    cbtn_shengping:addEventListener(cbtn_shengping_touchEvent)
end



function team_sbh_heroInfo_node:_updateView()
	local hero = self._hero
	self:_updateView_name(hero)
	self:_updateView_attr(hero)
	self:_updateView_shengping(hero)
	self:_updateView_skillOrder(hero)
	self:_updateView_skillDec(hero)
end

--更新武将名
function team_sbh_heroInfo_node:_updateView_name(hero)
	if hero ~= nil then
		self._scrollView:getChildByName("name"):setString(hero:getName())
	else
		self._scrollView:getChildByName("name"):setString("--")
	end
end

--更新属性
function team_sbh_heroInfo_node:_updateView_attr(hero)
	local attrNode = self._attr_layout:getChildByName("attr_node")
	if hero ~= nil then
		attrNode:getChildByName("lv"):getChildByName("count"):setString(hero.curLv)
		attrNode:getChildByName("att"):getChildByName("count"):setString(hero:getBaseAttack())
		attrNode:getChildByName("wufang"):getChildByName("count"):setString(hero:getBaseWuFang())
		attrNode:getChildByName("baoji"):getChildByName("count"):setString((hero:getBaoJi()*100).."%")
		attrNode:getChildByName("mingzhong"):getChildByName("count"):setString((hero:getMingZhong()*100).."%")
		attrNode:getChildByName("skill"):getChildByName("count"):setString(hero.skillLv)
		attrNode:getChildByName("hp"):getChildByName("count"):setString(hero:getBaseHP())
		attrNode:getChildByName("fafang"):getChildByName("count"):setString(hero:getBaseMoFang())
		attrNode:getChildByName("baoshang"):getChildByName("count"):setString((hero:getBaoShang()*100).."%")
		attrNode:getChildByName("shanbi"):getChildByName("count"):setString((hero:getShanBi()*100).."%")

	else
		attrNode:getChildByName("lv"):getChildByName("count"):setString(0)
		attrNode:getChildByName("att"):getChildByName("count"):setString(0)
		attrNode:getChildByName("wufang"):getChildByName("count"):setString(0)
		attrNode:getChildByName("baoji"):getChildByName("count"):setString("0%")
		attrNode:getChildByName("mingzhong"):getChildByName("count"):setString("0%")
		attrNode:getChildByName("skill"):getChildByName("count"):setString(0)
		attrNode:getChildByName("hp"):getChildByName("count"):setString(0)
		attrNode:getChildByName("fafang"):getChildByName("count"):setString(0)
		attrNode:getChildByName("baoshang"):getChildByName("count"):setString("0%")
		attrNode:getChildByName("shanbi"):getChildByName("count"):setString("0%")
	end
	
end

--更新生平
function team_sbh_heroInfo_node:_updateView_shengping(hero)
	local descrip = self._attr_layout:getChildByName("descrip_node")
	if hero ~= nil then
		-- descrip:getChildByName("text"):setString(text)
	else
		descrip:getChildByName("text"):setString("")
	end
end


--更新技能释放顺序
function team_sbh_heroInfo_node:_updateView_skillOrder(hero)
	local skillcast = self._scrollView:getChildByName("skillcast")
	if hero ~= nil then
		local skillicon1 = skillcast:getChildByName("skill_icon_1")
		-- skillicon1:loadTexture("", ccui.TextureResType.plistType)
		local skillicon2 = skillcast:getChildByName("skill_icon_2")
		-- skillicon2:loadTexture("", ccui.TextureResType.plistType)
		local skillicon3 = skillcast:getChildByName("skill_icon_3")
		-- skillicon3:loadTexture("", ccui.TextureResType.plistType)
	else
		
	end
end

--更新武将技能说明
function team_sbh_heroInfo_node:_updateView_skillDec(hero)
	local skillinfo = self._scrollView:getChildByName("skillcast")
	if hero ~= nil then
		local skill1 = skillinfo:getChildByName("skill_1")
		-- skill1:getChildByName("icon"):loadTexture("", ccui.TextureResType.plistType)
		-- skill1:getChildByName("name"):setString()
		-- skill1:getChildByName("descrip"):setString()
		local skill2 = skillinfo:getChildByName("skill_2")
		-- skill2:getChildByName("icon"):loadTexture("", ccui.TextureResType.plistType)
		-- skill2:getChildByName("name"):setString()
		-- skill2:getChildByName("descrip"):setString()
		local skill3 = skillinfo:getChildByName("skill_3")
		-- skill3:getChildByName("icon"):loadTexture("", ccui.TextureResType.plistType)
		-- skill3:getChildByName("name"):setString()
		-- skill3:getChildByName("descrip"):setString()
	else
		
	end
end



return team_sbh_heroInfo_node

