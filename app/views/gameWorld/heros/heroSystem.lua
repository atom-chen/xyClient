--
-- Author: Wu Hengmin
-- Date: 2015-07-02 10:59:57
-- 武将

--[[发送全局事件名预览
eventModleName: heros_ctrl -- 任务界面内部控制
eventName: 
	refreshlist -- 刷新内容
	clickSubTitleList -- 点击了导航栏
	clickSubTitleButtom -- 响应导航按钮
]]

--[[监听全局事件名预览
eventModleName: mainpage_popup_buttons2
eventName:
	wujiang_touched -- 点击武将按钮
]]
local heroSystem = class("heroSystem")

local class_hero = import(".UI_Hero")

function heroSystem:ctor()
	-- body
	self:_registGlobalEventListeners()
end

function heroSystem:_registGlobalEventListeners()
	-- body
	self._globalEventListeners = {}
	local configs = {
		{modelName = "mainpage_popup_buttons2", eventName = "wujiang_touched", callBack=handler(self, self.open)},
		{modelName = "controler_team_heroinfo_node", eventName = "btn_wuJiang_shengjiTouchEvent", callBack=handler(self, self._onEvent_btn_wuJiang_shengjiTouchEvent)}
	}
	self._globalEventListeners = createGlobalEventListenerWithConfig(configs)
end

function heroSystem:open(params)
	-- body
	local target = nil
	local guid = nil
	if type(params) == "table" then
		target = params.target
		guid = params.guid
	end
	local scene = MainPageSystemInstance.scene
	print("--------------111--------------")
	print(os.clock())
	local hero = class_hero:new()
	print("--------------222--------------")
	print(os.clock())
	hero:switchDisplay(target or "武将列表", guid)
	print("---------------333-------------")
	print(os.clock())
	scene:addChildToLayer(LAYER_ID_POPUP, hero)
	print("---------------444-------------")
	print(os.clock())

	GLOBAL_COMMON_ACTION:popupOut({
			node = hero.resourceNode_:getChildByName("main_layout"),
			shadowNode = hero.resourceNode_:getChildByName("shadow_layout"),
			callback = function ()
				-- body
				-- hero:switchDisplay(target or "武将列表", guid)
			end
		})

end


function heroSystem:_onEvent_btn_wuJiang_shengjiTouchEvent( event )
	local eventUseData = event._usedata
	self:open({
		target = "武将升级",
		guid = eventUseData.heroGUID
	})
end


function heroSystem.getInstance()
    if heroSystem.instance == nil then
        heroSystem.instance = heroSystem.new()
    end

    return heroSystem.instance
end


heroSystemInstance = heroSystem.getInstance()


return heroSystem
