--
-- Author: lipeng
-- Date: 2015-09-08 11:38:11
-- 拥军列表

--listView每页item数量
--(即每次到达listView底部时, 最多创建的item数量)
local LIST_VIEW_PER_PAGE_ITEM_NUM = 10


local class_controler_pageView = require(FILE_PATH.PATH_VIEWS_BASE..".controler_pageView")


local controler_yongjun_hero_list = class("controler_yongjun_hero_list")

function controler_yongjun_hero_list:ctor( yongjun_hero_list )
	self:_initModels()

	self._yongjun_hero_list = yongjun_hero_list

	self:_registNodeEvent()
	self:_registGlobalEventListeners()

	self:_createControlerForUI()
end

function controler_yongjun_hero_list:getCurPageIdx()
	return self._controlerMap.pageView:getCurInDataPageIdx()
end

function controler_yongjun_hero_list:_initModels()
	self._controlerMap = {}
	self._listInfo = {}
	--页视图面板, 列表的状态
	self._listState = "初始"
end



--注册节点事件
function controler_yongjun_hero_list:_registNodeEvent()
    local function onNodeEvent(event)
        if "exit" == event then
            self:_removeAllGlobalEventListeners()
        end
    end
    self._yongjun_hero_list:registerScriptHandler(onNodeEvent)
end

function controler_yongjun_hero_list:_removeAllGlobalEventListeners()
    for k,v in pairs(self._globalEventListeners) do
        GLOBAL_EVENT_DISPTACHER:removeEventListener(v)
    end
end

function controler_yongjun_hero_list:_registGlobalEventListeners()
	-- body
	self._globalEventListeners = {}
	local configs = {
		{modelName = "net", eventName = tostring(MSG_MS2C_HIRESYS_HIRELING_INFO), callBack=handler(self, self._onNetEvent_MSG_MS2C_HIRESYS_HIRELING_INFO)},
	}
	self._globalEventListeners = createGlobalEventListenerWithConfig(configs)
end



function controler_yongjun_hero_list:_createControlerForUI()
	self._controlerMap.pageView = class_controler_pageView.new(
		self._yongjun_hero_list:getChildByName("PageView_1") 
	)
	self._controlerMap.pageView:setScrollPageCallBack(handler(self, self._onScrollPage))

	local listItemTempleate = self._yongjun_hero_list:getChildByName("ListView_itemTempleate")

	--雇佣
	local btn_gy = listItemTempleate:getChildByName("btn_gy")
	local function btn_gyTouched( sender,eventType )
		if eventType == ccui.TouchEventType.ended then
			local info = self._listInfo[sender:getTag()]
			if info.playerID == MAIN_PLAYER:getBaseAttr():getGUID() then
				UIManager:CreateSamplePrompt("不能雇佣自己")
				return
			end
			local sendData = {}
			sendData[1] = info.playerID
			gameTcp:SendMessage(MSG_C2MS_HIRESYS_HIRE, sendData)
			printNetLog("发送 雇佣一个雇员(MSG_C2MS_HIRESYS_HIRE) 消息")
        end
	end
	btn_gy:addTouchEventListener(btn_gyTouched)

	self._controlerMap.pageView:setMaxDataPageNum(1)
	self._controlerMap.pageView:setPageUpdateCallBack(handler(self, self._onPageUpdate))
end


function controler_yongjun_hero_list:_onScrollPage()
	local sendData = {}
    sendData[1] = self:getCurPageIdx()
	gameTcp:SendMessage(MSG_C2MS_HIRESYS_HIRELING_INFO, sendData)
end


function controler_yongjun_hero_list:_onPageUpdate( dataPageIdx, panle )
	local listView = panle:getChildByName("ListView")

	listView:removeAllChildren()
	listView:refreshView()
	listView:setSwallowTouches(false)

	if self._listState ~= "可更新" or dataPageIdx ~= self:getCurPageIdx() then
		print("_onPageUpdate")
		return
	end

	local listItemTempleate = self._yongjun_hero_list:getChildByName("ListView_itemTempleate")

	listView:setItemModel(
		listItemTempleate:clone()
	)

	local addItemNum = LIST_VIEW_PER_PAGE_ITEM_NUM
	local curListItemNum = table.nums(listView:getItems())
	local dataTotal = #self._listInfo

	if curListItemNum >= dataTotal then
		return
	end

	if addItemNum + curListItemNum > dataTotal then
		addItemNum = dataTotal - curListItemNum
	end

	for i=1, addItemNum do
		listView:pushBackDefaultItem()

		local dataIdx = curListItemNum + i
		local data = self._listInfo[dataIdx]

		local newItem = listView:getItem(dataIdx-1)
		newItem:setSwallowTouches(false)
		newItem:setVisible(true)
		--[[
		设置item数据
		]]
		newItem:getChildByName("btn_gy"):setTag(i)
		--玩家名字
		newItem:getChildByName("pn_value"):setString(data.playerName)

		--英雄icon
		local heroiconLayout = newItem:getChildByName("heroicon_layout")
		HERO_ICON_HELPER:updateIcon(
			{
				bgImg = heroiconLayout:getChildByName("bg"),
				iconImg = heroiconLayout:getChildByName("icon"),
				guideImg = heroiconLayout:getChildByName("guide"),
				heroTempleateID = data.heroTempleateID
			}
		)

		--玩家等级
		newItem:getChildByName("als_lvValue"):setString(data.playerLv)
		
		--vip等级
		newItem:getChildByName("text_vipValue"):setString(data.vipLv)
		
		--战力值
		newItem:getChildByName("text_powerValue"):setString(data.power)
		
		--每秒获得经验值
		newItem:getChildByName("text_jyValue"):setString(math.floor(data.perSecGetExp))
		
		--每秒获得银两
		newItem:getChildByName("text_ylValue"):setString(math.floor(data.perSecGetGold))
	

		--当前身价
		local curPrice = guyongSystemInstance:compute_BGY_CurPrice(
			data.price, 
			data.reducePriceTime
		)
		newItem:getChildByName("text_sj_Value"):setString(math.floor(curPrice))
		
		--状态信息
		if data.coolTime == 0 then
			newItem:getChildByName("text_stateInfo"):setString("没被雇佣")
		else
			if guyongSystemInstance:isProtectStateForBGY(data.coolTime) then
		    	newItem._gyState = "保护"
		    	newItem._stateUpdateRemainTime = guyongSystemInstance:BGY_protectRemainTime(data.coolTime)
		    else
		    	newItem._gyState = "降价"
		    	newItem._stateUpdateRemainTime = guyongSystemInstance:compute_BGY_nextReducePriceRemainSec(data.reducePriceTime)
		    end
		    newItem._lastTime = 0
			local function timerFun(dt)
				if newItem._gyState == "最低价" then
					return
				end

				if os.time() - newItem._lastTime >= 1 then
					newItem._lastTime = os.time()

					newItem._stateUpdateRemainTime = newItem._stateUpdateRemainTime - 1

					local view_stateInfo = newItem:getChildByName("text_stateInfo")

					if newItem._gyState == "保护" then
						if newItem._stateUpdateRemainTime <= 0 then
							newItem._stateUpdateRemainTime = HIRE_REDUCE_SEC - 1
							newItem._gyState = "降价"
						end

					else
						if newItem._stateUpdateRemainTime <= 0 then
							newItem._stateUpdateRemainTime = HIRE_REDUCE_SEC - 1
						end
					end

					local remainSec = newItem._stateUpdateRemainTime
					
					local remainTime = TIME_HELPER:secondToTime(remainSec)

					if newItem._gyState == "保护" then
						view_stateInfo:setString(
							string.format(
								"保护倒计时:%02d:%02d:%02d",
								remainTime.hour, remainTime.min, remainTime.sec
							)
						)
					else
						view_stateInfo:setString(
							string.format(
								"降价倒计时:%02d:%02d:%02d",
								remainTime.hour, remainTime.min, remainTime.sec
							)
						)
					end

					--当前身价
					local curPrice = guyongSystemInstance:compute_BGY_CurPrice(
						data.price, 
						data.reducePriceTime
					)
					newItem:getChildByName("text_sj_Value"):setString(math.floor(curPrice))
					
					if curPrice <= HIRE_BASE_PRICE then
						view_stateInfo:setString("已为最低身价")
						newItem._gyState = "最低价"
					end
				end
		        
		    end
			newItem:scheduleUpdateWithPriorityLua(timerFun, 0)
		end
		
	end
end



function controler_yongjun_hero_list:_onNetEvent_MSG_MS2C_HIRESYS_HIRELING_INFO( event )
	local msgData = event._usedata
	if self:getCurPageIdx() == msgData.pageIdx then
		local maxPageNum = math.floor(msgData.infoTotalNum / msgData.infoNum)
		self._listInfo = clone(msgData.listInfo)
		self._listState = "等待更新"
		self._controlerMap.pageView:setMaxDataPageNum(maxPageNum)
		self._listState = "可更新"
		self._controlerMap.pageView:turnToPage(msgData.pageIdx)
	end

end


return controler_yongjun_hero_list

