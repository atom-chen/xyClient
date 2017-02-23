--
-- Author: lipeng
-- Date: 2015-09-06 19:59:38
-- 雇佣系统

local class_controler_guyong_system_main_layer = import(".controler_guyong_system_main_layer")


local guyongSystem = class("guyongSystem")


function guyongSystem:ctor()
	self:_initModels()
	self:_registGlobalEventListeners()
end

--已雇佣了多久
--@gyTime 雇佣起始时间(单位:秒)
--@return (单位:秒)
function guyongSystem:YGYSec(gyTime)
	return TIME_HELPER:clientTimeToServerTime(os.time()) - gyTime
end

--被雇佣人是否处于保护状态
--@protectTime 保护起始时间(单位:秒)
--@return bool
function guyongSystem:isProtectStateForBGY(protectTime)
	return protectTime < TIME_HELPER:clientTimeToServerTime(os.time())
end

--被雇佣人保护剩余时间
--@protectTime 保护起始时间(单位:秒)
--@return (单位秒)
function guyongSystem:BGY_protectRemainTime(protectTime)
	local sec = TIME_HELPER:clientTimeToServerTime(os.time()) - protectTime
	if sec < 0 then
		sec = 0
	end
	return sec
end


--计算被雇佣人已经降价了多久
--@reducePriceTime 降价的起始时间
--@return (单位秒)
function guyongSystem:compute_BGY_yjjSec(reducePriceTime)
	return TIME_HELPER:clientTimeToServerTime(os.time()) - reducePriceTime
end

--计算被雇佣人距离下次降价还剩多久
--@reducePriceTime 降价的起始时间
--@return (单位秒)
function guyongSystem:compute_BGY_nextReducePriceRemainSec(reducePriceTime)
	return math.fmod(reducePriceTime, HIRE_REDUCE_SEC)
end

--计算被雇佣人的当前价格
--@initPrice 初始价格
--@reducePriceTime 降价的起始时间
--@return number
function guyongSystem:compute_BGY_CurPrice( initPrice, reducePriceTime )
	--已经经历了多久的降价时间
	local yjjSec = self:compute_BGY_yjjSec(reducePriceTime)
	
	--降价次数
	local jjCount =	math.floor(yjjSec/HIRE_REDUCE_SEC)

	--当前身价
	local curPrice = initPrice
	for i=1, jjCount do
		curPrice = curPrice * (1-HIRE_CHANGE_SCALE)
		if curPrice <= HIRE_BASE_PRICE then
			curPrice = HIRE_BASE_PRICE
			break
		end
	end

	return curPrice
end


--关闭雇佣视图
function guyongSystem:closeGuYongView()
	local function popupBackActionCallBack()
		if self._controlerMap.guyong ~= nil then
			self._controlerMap.guyong:getView():removeFromParent()
			self._controlerMap = {}
			release_res(self._dynamicResConfigIDs)
		end
		
	end
	GLOBAL_COMMON_ACTION:popupBack({node=self._controlerMap.guyong:getView(), callback=popupBackActionCallBack})
end


function guyongSystem:_initModels()
	self._controlerMap = {}
    self:_initDynamicResConfig()
end


function guyongSystem:_initDynamicResConfig()
	ResConfig["ui_image/guyong/widget"] = {
		restype = "plist",
		respath = "ui_image/guyong/widget/",
		res = {"guyong_plist"}
	}

	self._dynamicResConfigIDs = {
		"ui_image/guyong/widget",
	}
end


function guyongSystem:_registGlobalEventListeners()
	-- body
	self._globalEventListeners = {}
	local configs = {
		{modelName = "mainpage_popup_buttons2", eventName = "guyong_touched", callBack=handler(self, self._onGuyong_touched)},
	}
	self._globalEventListeners = createGlobalEventListenerWithConfig(configs)
end

function guyongSystem:_createUILayer()
    return cc.CSLoader:createNode("ui_instance/guyong/guyong_system_main_layer.csb")
end


function guyongSystem:_onGuyong_touched()
	self.scene = APP:getCurScene()
	if self._controlerMap.guyong == nil then
		self._controlerMap.guyong = class_controler_guyong_system_main_layer.new(self:_createUILayer())
		self.scene:addChildToLayer(LAYER_ID_POPUP, self._controlerMap.guyong:getView())
		
		GLOBAL_COMMON_ACTION:popupOut({node=self._controlerMap.guyong:getView()})
	end

end



function guyongSystem.getInstance()
    if guyongSystem.instance == nil then
        guyongSystem.instance = guyongSystem.new()
    end

    return guyongSystem.instance
end


guyongSystemInstance = guyongSystem.getInstance()


return guyongSystem
