--
-- Author: lipeng
-- Date: 2015-06-30 17:23:38
-- 全局事件分发器扩展

--创建全局事件的名称
function createGlobaleEventName( moduleName, eventName )
 	return string.format("%s_%s", moduleName, eventName)
end


--本地广播全局事件
function dispatchGlobaleEvent( moduleName, eventName, data )
	local _actualEventName = createGlobaleEventName(moduleName, eventName)
	local _event = cc.EventCustom:new(_actualEventName)
    _event._usedata = data
    GLOBAL_EVENT_DISPTACHER:dispatchEvent(_event)
end


--监听本地全局事件
function createGlobalEventListener( modelName, eventName, callBack, fixedPriority )
	local _actualEventName = createGlobaleEventName(modelName, eventName)
	local eventListner = cc.EventListenerCustom:create(_actualEventName, callBack)
	GLOBAL_EVENT_DISPTACHER:addEventListenerWithFixedPriority(eventListner, fixedPriority)

	return eventListner
end


--通过表创建全局事件监听
--[[
注: listenerNameKey如果配置不填写, 默认通过createGlobaleEventName创建
	fixedPriority如果配置不填写, 默认为1
	config = {
		{modelName = "model_playerBaseAttr", eventName = "nameChange", callBack=handler(self, self.onNameChange), fixedPriority=1, listenerNameKey="mainPage_qianDao"} 
	}
]]
function createGlobalEventListenerWithConfig( config )
	local listenerMap = {}
	local _listenerNameKey = ""
	local _fixedPriority = 1
	for k,v in pairs(config) do
		_listenerNameKey = v.listenerNameKey or createGlobaleEventName(v.modelName, v.eventName)
		_fixedPriority = v.fixedPriority or 1
		listenerMap[_listenerNameKey] = createGlobalEventListener(v.modelName, v.eventName, v.callBack, _fixedPriority)
	end

	return listenerMap
end

