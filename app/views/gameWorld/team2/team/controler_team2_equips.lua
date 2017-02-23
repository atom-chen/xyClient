--
-- Author: lipeng
-- Date: 2015-08-27 14:41:46
-- 控制器: 装备组


local class_controler_team2_equip_item_node = import(".controler_team2_equip_item_node")
local controler_team2_equips = class("controler_team2_equips")


function controler_team2_equips:ctor(equipsContainer)
	self:_initModels()

	--根层
	self._equipsContainer = equipsContainer

    self:_createControlerForUI()
    self:_registUIEvent()
end

function controler_team2_equips:addEventListener( callBack )
	self._controlerEventCallBack = callBack
end

--获取当前选中装备
function controler_team2_equips:getCurSelectedEquip()
	return self._controlerMap.equips[self._curSelectedIdx]
end


function controler_team2_equips:setTeamBattlePos( pos )
	self._teamBattlePos = pos
	self:_updateView()
end


function controler_team2_equips:_initModels()
	self._controlerMap = {}
	self._controlerEventCallBack = nil

    self._teamBattlePos = nil
    self._curSelectedIdx = 1
end


--创建控制器: UI
function controler_team2_equips:_createControlerForUI()
	local scrollViewContainer = self._equipsContainer

    --装备
    self._controlerMap.equips = {}
    for i=1, EquipTypeNum do
	    self._controlerMap.equips[i] = class_controler_team2_equip_item_node.new(
	    	scrollViewContainer:getChildByName("equip"..i), i
	    )
	    self._controlerMap.equips[i]:addEventListener(handler(self, self._equipEventListener))
	end
	self:getCurSelectedEquip():setSelected(true)
end

function controler_team2_equips:_registUIEvent()

end


function controler_team2_equips:_updateView()
	local teamBattlePos = self._teamBattlePos
	local scrollViewContainer = self._equipsContainer
	local controlerEquips = self._controlerMap.equips
	local equipManager = MAIN_PLAYER:getEquipManager()

	for i=1, EquipTypeNum do
		local equipGUID = teamBattlePos:getEquipGUID(i)
		if equipGUID ~= NULL_GUID then
			local equip = equipManager:getEquipByGuid(equipGUID)
			controlerEquips[i]:setEquip(equip)
		else
			controlerEquips[i]:setEquip(nil)
		end
	end
end


function controler_team2_equips:_equipEventListener( sender, eventName )
	if "equipBtnTouchEnded" == eventName then
		self:_onEquipBtnTouchEnded(sender)
	end
end


function controler_team2_equips:_onEquipBtnTouchEnded( sender )
	--如果装备已经被选中
	if sender:getSelected() then
		self:_doEventCallBack(self, "equipClick")
	else
		--设置上次选中的按钮为: 未选中
		self:getCurSelectedEquip():setSelected(false)
		--更新当前选中位置
		self._curSelectedIdx = sender:getIdx()
		sender:setSelected(true)
	end
end


function controler_team2_equips:_doEventCallBack( sender, eventName )
	if self._controlerEventCallBack ~= nil then
		self._controlerEventCallBack(sender, eventName)
	end
end



return controler_team2_equips








