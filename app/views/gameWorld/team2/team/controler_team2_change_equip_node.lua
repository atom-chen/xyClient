--
-- Author: lipeng
-- Date: 2015-08-28 18:37:11
--

local class_controler_pageView = require(FILE_PATH.PATH_VIEWS_BASE..".controler_pageView")

local PER_PAGE_ITEM_NUM = 3

local controler_team2_change_equip_node = class("controler_team2_change_equip_node")

function controler_team2_change_equip_node:ctor( team2_change_equip_node )
	self:_initModels()

	self._team2_change_equip_node = team2_change_equip_node

	self:_createControlerForUI()
	self:_registUIEvent()
end

function controler_team2_change_equip_node:getView()
	return self._team2_change_equip_node
end


function controler_team2_change_equip_node:addEventListener( callBack )
	self._controlerEventCallBack = callBack
end

function controler_team2_change_equip_node:setCurSelEquip( curSelEquipItem )
	self._curSelEquipItem = curSelEquipItem
	self:_updateView_equipPanle(
		self._team2_change_equip_node:getChildByName("curSelEquipInfo"),
		self._curSelEquipItem:getEquip()
	)

	self._equipList = {}

	local battleHeroManager = MAIN_PLAYER:getTeamManager():getCurSelTeam():getBattleHeroManager()
	local cloneEquipList = MAIN_PLAYER:getEquipManager():cloneEquipDataToList()

	for i,v in ipairs(cloneEquipList) do
		if v:getType() == self._curSelEquipItem:getEquipType() and 
			nil == battleHeroManager:getPosIdxWithEquip(v:getGUID()) then
			self._equipList[#self._equipList+1] = v
		end
	end

	table.sort( self._equipList, function ( a, b )
		return a:getZhanDouLi() > b:getZhanDouLi()
	end )

	local maxPageNum = 1
	if #self._equipList > 0 then
		if #self._equipList % PER_PAGE_ITEM_NUM == 0 then
			maxPageNum = math.floor(#self._equipList / PER_PAGE_ITEM_NUM)
		else
			maxPageNum = math.floor(#self._equipList / PER_PAGE_ITEM_NUM) + 1
		end
	end

	self._controlerMap.pageView:setMaxDataPageNum(maxPageNum)
	self._controlerMap.pageView:turnToPage(1)

	self:_updateView_pageNum()
end


function controler_team2_change_equip_node:_initModels()
	self._controlerMap = {}
	self._controlerEventCallBack = nil

	self._curSelEquipItem = nil
end


function controler_team2_change_equip_node:_createControlerForUI()
	self._controlerMap.pageView = class_controler_pageView.new(
		self._team2_change_equip_node:getChildByName("pageView") 
	)
	self._controlerMap.pageView:setMaxDataPageNum(1)
	self._controlerMap.pageView:setPageUpdateCallBack(handler(self, self._onPageUpdate))
end

function controler_team2_change_equip_node:_onPageUpdate( dataPageIdx, panle )
	self:_updateView_pageNum()

	for i=1, 3 do
		local equipInfoPanle = panle:getChildByName("equipInfo"..i)
		--数据在列表中的索引
		local dataInListIdx = (dataPageIdx-1)*3+i
		local equipData = self._equipList[dataInListIdx]
		if equipData ~= nil then
			--更换装备
			local btn_changeEquip = equipInfoPanle:getChildByName("btn_changeEquip")
		    local function btn_changeEquipTouchEvent(sender,eventType)
		        if eventType == ccui.TouchEventType.ended then
		        	teamSystem2Instance:sendNetMsg_curSelMemberTakeEquip(equipData:getGUID())
		        end
		    end
		    btn_changeEquip:addTouchEventListener(btn_changeEquipTouchEvent)

			equipInfoPanle:setVisible(true)
		else
			equipInfoPanle:setVisible(false)
		end
		self:_updateView_equipPanle(equipInfoPanle, equipData)
	end
end


function controler_team2_change_equip_node:_registUIEvent()
	local UIContainer = self._team2_change_equip_node

	--左翻页
	local btn_leftTurnPage = UIContainer:getChildByName("btn_leftTurnPage")
    local function btn_leftTurnPageTouchEvent(sender,eventType)
        if eventType == ccui.TouchEventType.ended then
            if self._controlerMap.pageView:getMaxDataPageNum() > 1 then
	    		self._controlerMap.pageView:leftTurnPage()
	    	end
        end
    end
    btn_leftTurnPage:addTouchEventListener(btn_leftTurnPageTouchEvent)

    --右翻页
    local btn_rightTurnPage = UIContainer:getChildByName("btn_rightTurnPage")
    local function btn_rightTurnPageTouchEvent(sender,eventType)
        if eventType == ccui.TouchEventType.ended then
            if self._controlerMap.pageView:getMaxDataPageNum() > 1 then
		        self._controlerMap.pageView:rightTurnPage()
	    	end
        end
    end
    btn_rightTurnPage:addTouchEventListener(btn_rightTurnPageTouchEvent)

    --关闭
    local btn_close = UIContainer:getChildByName("btn_close")
    local function btn_closeTouchEvent(sender,eventType)
        if eventType == ccui.TouchEventType.ended then
            self:_doEventCallBack(self, "btn_closeTouchEvent")
        end
    end
    btn_close:addTouchEventListener(btn_closeTouchEvent)

    --卸下当前选中装备
    local btn_unload = UIContainer:getChildByName("curSelEquipInfo"):
    						getChildByName("btn_unload")
    local function btn_unloadTouchEvent(sender,eventType)
        if eventType == ccui.TouchEventType.ended then
        	teamSystem2Instance:sendNetMsg_curSelMemberUnloadEquip(
            	self._curSelEquipItem:getEquip()
            )
        end
    end
    btn_unload:addTouchEventListener(btn_unloadTouchEvent)
end


function controler_team2_change_equip_node:_updateView_equipPanle( equipInfoPanle, equipData )
	if equipData ~= nil then
		--等级
		equipInfoPanle:getChildByName("als_lvValue"):
			setString(equipData:getLv())

		--icon
		local equip_icon_bottom = equipInfoPanle:getChildByName("equip_icon_bottom")
		local equip_icon = equipInfoPanle:getChildByName("equip_icon")
		EQUIP_ICON_HELPER:updateIcon(
			{
				bgImg = equip_icon_bottom,
				iconImg = equip_icon,
				heroTempleateID = equipData:getTeampleateID()
			}
		)
		equip_icon_bottom:setVisible(true)
		equip_icon:setVisible(true)

		--名字
		equipInfoPanle:getChildByName("text_equipName"):setString(equipData:getName())
		
		--装备类型
		equipInfoPanle:getChildByName("text_equipType"):setString(equipData:getTypeName())
		
		--评分基础值
		equipInfoPanle:getChildByName("text_pinFenBaseValue"):setString(equipData:getZhanDouLiMain())
		
		--评分附加值
		equipInfoPanle:getChildByName("text_pinFenAddtionValue"):setString(
			"("..
			equipData:getZhanDouLiOff()..
			")"
		)
		
		--主属性名
		equipInfoPanle:getChildByName("text_mainAttrName"):setString(equipData:getMainTypeName()..":")
		
		--主属性值
		equipInfoPanle:getChildByName("text_mainAttrValue"):setString(equipData:getMainAttr())

		--物攻
		equipInfoPanle:getChildByName("text_wgValue"):setString(equipData:getOffAttr_pAttack())
		--法攻
		equipInfoPanle:getChildByName("text_fgValue"):setString(equipData:getOffAttr_mAttack())
		--hp
		equipInfoPanle:getChildByName("text_hpValue"):setString(equipData:getOffAttr_hp())
		--物防
		equipInfoPanle:getChildByName("text_wfValue"):setString(equipData:getOffAttr_pDef())
		--法防
		equipInfoPanle:getChildByName("text_ffValue"):setString(equipData:getOffAttr_mDef())
		
		--更新其他属性(暴击、命中、闪避、爆伤、韧性等)
		local otherAttrMap = equipData:otherAttrToTypeStrKey()
		local otherAttrIdx = 1
		for k,v in pairs(otherAttrMap) do
			local view_name = equipInfoPanle:getChildByName("text_fj_name"..otherAttrIdx)
			local view_value = equipInfoPanle:getChildByName("text_fj_value"..otherAttrIdx)
			view_name:setString(k..":")
			view_value:setString(string.format("%0.2f%%", v*100))

			view_name:setVisible(true)
			view_value:setVisible(true)

			otherAttrIdx = otherAttrIdx + 1
		end

		for i=otherAttrIdx, 5 do
			equipInfoPanle:getChildByName("text_fj_name"..i):setVisible(false)
			equipInfoPanle:getChildByName("text_fj_value"..i):setVisible(false)
		end
	else
		--等级
		equipInfoPanle:getChildByName("als_lvValue"):
			setString(0)

		--icon
		equipInfoPanle:getChildByName("equip_icon_bottom"):setVisible(true)
		equipInfoPanle:getChildByName("equip_icon"):setVisible(false)
		
		--名字
		equipInfoPanle:getChildByName("text_equipName"):setString("--")
	
		--装备类型
		equipInfoPanle:getChildByName("text_equipType"):setString("--")
		
		--评分基础值
		equipInfoPanle:getChildByName("text_pinFenBaseValue"):setString(0)
		
		--评分附加值
		equipInfoPanle:getChildByName("text_pinFenAddtionValue"):
			setString("(0)")
		
		--主属性名
		equipInfoPanle:getChildByName("text_mainAttrName"):setString("--:")
		
		--主属性值
		equipInfoPanle:getChildByName("text_mainAttrValue"):setString(0)
	
		--物攻
		equipInfoPanle:getChildByName("text_wgValue"):setString(0)
		--法攻
		equipInfoPanle:getChildByName("text_fgValue"):setString(0)
		--hp
		equipInfoPanle:getChildByName("text_hpValue"):setString(0)
		--物防
		equipInfoPanle:getChildByName("text_wfValue"):setString(0)
		--法防
		equipInfoPanle:getChildByName("text_ffValue"):setString(0)
	
		--更新其他属性(暴击、命中、闪避、爆伤等)
		for i=1, 5 do
			equipInfoPanle:getChildByName("text_fj_name"..i):setVisible(false)
			equipInfoPanle:getChildByName("text_fj_value"..i):setVisible(false)
		end

	end
end



function controler_team2_change_equip_node:_updateView_pageNum()
	self._team2_change_equip_node:
		getChildByName("text_pageValue"):
		setString(
			string.format("%d/%d", 
				self._controlerMap.pageView:getCurInDataPageIdx(), 
				self._controlerMap.pageView:getMaxDataPageNum()
			)
		)
end


function controler_team2_change_equip_node:_doEventCallBack( sender, eventName )
	if self._controlerEventCallBack ~= nil then
		self._controlerEventCallBack(sender, eventName)
	end
end


return controler_team2_change_equip_node
