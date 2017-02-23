--
-- Author: lipeng
-- Date: 2015-07-08 14:46:30
-- 控制器: 装备

local class_controler_team_equip_item_node = import(".controler_team_equip_item_node")
local controler_team_equip_node = class("controler_team_equip_node")


function controler_team_equip_node:ctor(team_equip_node)
	self:_initModels()

	local visibleSize = cc.Director:getInstance():getVisibleSize()
	--根层
	self._team_equip_node = team_equip_node
    self._team_equip_node:setContentSize(visibleSize)
    ccui.Helper:doLayout(self._team_equip_node)

    self._scrollViewContainer = self._team_equip_node:getChildByName("scrollView")

    self:_createControlerForUI()
    self:_registUIEvent()
end

--获取当前选中装备
function controler_team_equip_node:getCurSelectedEquip()
	return self._controlerMap.equips[self._curSelectedIdx]
end


function controler_team_equip_node:setTeamBattlePos( pos )
	self._teamBattlePos = pos
	self:_updateView()
end


function controler_team_equip_node:_initModels()
	self._controlerMap = {}
    self._teamBattlePos = nil
    self._curSelectedIdx = 1
end


--创建控制器: UI
function controler_team_equip_node:_createControlerForUI()
	local scrollViewContainer = self._scrollViewContainer

    --装备
    self._controlerMap.equips = {}
    for i=1, EquipTypeNum do
	    self._controlerMap.equips[i] = class_controler_team_equip_item_node.new(
	    	scrollViewContainer:getChildByName("node_equip"..i), i
	    )
	    self._controlerMap.equips[i]:addEventListener(handler(self, self._equipEventListener))
	end
	self:getCurSelectedEquip():setSelected(true)
end

function controler_team_equip_node:_registUIEvent()
	local btn_unloadAll = self._scrollViewContainer:getChildByName("btn_unloadAll")

    local function btn_unloadAllTouchEvent(sender,eventType)
        if eventType == ccui.TouchEventType.ended then
            TeamSystemInstance:sendNetMsg_curSelMemberUnloadAllEquip()
        end
    end
    btn_unloadAll:addTouchEventListener(btn_unloadAllTouchEvent)
    

    local btn_equip_qianghua = self._scrollViewContainer:getChildByName("btn_equip_qianghua")

    local function btn_equip_qianghuaTouchEvent(sender,eventType)
        if eventType == ccui.TouchEventType.ended then
        	local equip = self:getCurSelectedEquip():getEquip()
        	if equip ~= nil then
	            equipSystemInstance:open({
	            	target = "装备强化",
	            	guid = equip:getGUID()
	            })

	        else
	        	equipSystemInstance:open({
	            	target = "装备强化",
	            	guid = nil
	            })
        	end
        	
        end
    end
    btn_equip_qianghua:addTouchEventListener(btn_equip_qianghuaTouchEvent)


    local btn_autoEquip = self._scrollViewContainer:getChildByName("btn_autoEquip")

    local function btn_autoEquipTouchEvent(sender,eventType)
        if eventType == ccui.TouchEventType.ended then
        	TeamSystemInstance:sendNetMsg_curSelMemberAutoEquip()
        end
    end
    btn_autoEquip:addTouchEventListener(btn_autoEquipTouchEvent)
end


function controler_team_equip_node:_updateView()
	local teamBattlePos = self._teamBattlePos
	local scrollViewContainer = self._scrollViewContainer
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


function controler_team_equip_node:_equipEventListener( sender, eventName )
	if "equipBtnTouchEnded" == eventName then
		self:_onEquipBtnTouchEnded(sender)
	end
end


function controler_team_equip_node:_onEquipBtnTouchEnded( sender )
	--如果装备已经被选中
	if sender:getSelected() then
		--进入选择装备界面
		dispatchGlobaleEvent("controler_team_equip_node", "clickPos", {equipType=sender:getEquipType()})
	else
		--设置上次选中的按钮为: 未选中
		self:getCurSelectedEquip():setSelected(false)
		--更新当前选中位置
		self._curSelectedIdx = sender:getIdx()
		sender:setSelected(true)
	end
end



return controler_team_equip_node






