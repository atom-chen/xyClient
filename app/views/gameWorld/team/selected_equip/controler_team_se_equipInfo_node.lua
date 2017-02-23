--
-- Author: lipeng
-- Date: 2015-07-20 10:37:44
-- 控制器: 装备信息

local team_se_equipInfo_node = class("team_se_equipInfo_node")

function team_se_equipInfo_node:ctor(team_se_equipInfo_node)
	self:_initModels()

	self._team_se_equipInfo_node = team_se_equipInfo_node
	self._scrollView = self._team_se_equipInfo_node:getChildByName("scrollView")
	self._attr_node = self._scrollView:getChildByName("attr_node")

	self:_registUIEvent()
end


function team_se_equipInfo_node:setEquip(equip)
	self._equip = equip
	self:_updateView()
end


function team_se_equipInfo_node:_initModels()
	self._controlerEventCallBack = nil
	self._equip = nil
end

function team_se_equipInfo_node:_registUIEvent()

end



function team_se_equipInfo_node:_updateView()
	local equip = self._equip
	self:_updateView_name(equip)
	self:_updateView_attr(equip)
	self:_updateView_dec(equip)
end

--更新装备名
function team_se_equipInfo_node:_updateView_name(equip)
	local nameView = self._scrollView:getChildByName("name")
	if equip ~= nil then
		nameView:setString(equip:getName())
	else
		nameView:setString("--")
	end
end

--更新属性
function team_se_equipInfo_node:_updateView_attr(equip)
	local attrNode = self._attr_node

	if equip ~= nil then
		attrNode:getChildByName("main_attr"):setString(equip:getMainTypeName()..":")
		attrNode:getChildByName("off_attr"):setString(equip:getOffAttrTypeName()..":")
		attrNode:getChildByName("main_attr"):getChildByName("count"):setString(equip:getMainAttr())
		attrNode:getChildByName("off_attr"):getChildByName("count"):setString(equip:getOffAttr())
		attrNode:getChildByName("off_attr"):getChildByName("max"):setString("/"..equip:getMaxOffAttr())
		attrNode:getChildByName("lv"):getChildByName("count"):setString(equip:getMainLevel())

	else
		attrNode:getChildByName("main_attr"):setString("--:")
		attrNode:getChildByName("off_attr"):setString("--:")
		attrNode:getChildByName("main_attr"):getChildByName("count"):setString(0)
		attrNode:getChildByName("off_attr"):getChildByName("count"):setString(0)
		attrNode:getChildByName("off_attr"):getChildByName("max"):setString("/0")
		attrNode:getChildByName("lv"):getChildByName("count"):setString(0)
	end
	
end

--更新装备描述
function team_se_equipInfo_node:_updateView_dec(equip)
	local descripView = self._scrollView:getChildByName("descrip")

	if hero ~= nil then
		descripView:setString(equip:getExplain())
	else
		descripView:setString("")
	end
end





return team_se_equipInfo_node

