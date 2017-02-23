--
-- Author: lipeng
-- Date: 2015-08-05 16:07:10
-- 公会


local class_controler_no_guild_main_layer = import(".no_guild.controler_no_guild_main_layer")
local class_controler_owner_guild_main_layer = import(".owner_guild.controler_owner_guild_main_layer")
local class_controler_guild_battle_main_layer = import(".guild_battle.controler_guild_battle_main_layer")


local model_guildSystem = import(".guildSystemModel")

local guildSystem = class("guildSystem")


function guildSystem:ctor()
	self:_initModels()
	self:_registGlobalEventListeners()
end


function guildSystem:getModel()
	return self._model
end


function guildSystem:_initModels()
    self._controlerMap = {}
    self._model = model_guildSystem.new()
    self:_initDynamicResConfig()
end

function guildSystem:_initDynamicResConfig()

end


function guildSystem:_registGlobalEventListeners()
	self._globalEventListeners = {}
	local configs = {
		{modelName = "mainpage_popup_buttons2", eventName = "juntuan_touched", callBack=handler(self, self._onJuntuan_touched)},
		{modelName = "net", eventName = tostring(MSG_MS2C_GUILD_CREATE), callBack=handler(self, self._onNetEvent_MSG_MS2C_GUILD_CREATE)},
		{modelName = "net", eventName = tostring(MSG_MS2C_ROLE_UPDATA_GUILDID), callBack=handler(self, self._onNetEvent_MSG_MS2C_ROLE_UPDATA_GUILDID)},
	}
	self._globalEventListeners = createGlobalEventListenerWithConfig(configs)
end

function guildSystem:_createControler_guild()
	if self._controlerMap.guild == nil then
		local guildGUID = MAIN_PLAYER:getGuild():getGUID()
		
		if guildGUID ~= NULL_GUID then
			self._controlerMap.guild = class_controler_owner_guild_main_layer.new(self:_create_owner_guild_main_layer())
			self._controlerMap.guild:addEventListener(handler(self, self._onEvent_owner_guild_main_layer))

			printNetLog("[请求公会信息] 消息(MSG_C2MS_GUILD_GETINFO)")
			gameTcp:SendMessage(MSG_C2MS_GUILD_GETINFO)
		else
			self._controlerMap.guild = class_controler_no_guild_main_layer.new(self:_create_no_guild_main_layer())
			self._controlerMap.guild:addEventListener(handler(self, self._onEvent_no_guild_main_layer))
			printNetLog("[请求公会列表] 消息(MSG_C2MS_GET_GUILD_LIST)")
			gameTcp:SendMessage(MSG_C2MS_GET_GUILD_LIST)
		end
		
		self.scene:addChildToLayer(LAYER_ID_POPUP, self._controlerMap.guild:getView())

		GLOBAL_COMMON_ACTION:popupOut({node=self._controlerMap.guild:getView()})
	end
end

function guildSystem:_create_no_guild_main_layer()
    return cc.CSLoader:createNode("ui_instance/guild/no_guild/no_guild_main_layer.csb")
end

function guildSystem:_create_owner_guild_main_layer()
    return cc.CSLoader:createNode("ui_instance/guild/owner_guild/owner_guild_main_layer.csb")
end

function guildSystem:_create_guild_battle_main_layer()
    return cc.CSLoader:createNode("ui_instance/guild/guild_battle/guild_battle_main_layer.csb")
end

function guildSystem:_onJuntuan_touched()
	self.scene = APP:getCurScene()
	self:_createControler_guild()
end


function guildSystem:_onNetEvent_MSG_MS2C_GUILD_CREATE(event)
	local useData = event._usedata
	local msgData = useData.msgData
	if eGUILD_CreateSuccess == msgData.result then
		if self._controlerMap.guild ~= nil then
			self._controlerMap.guild:getView():removeFromParent()
			self._controlerMap.guild = nil
		end
		
		self:_createControler_guild()
	end
end

function guildSystem:_onNetEvent_MSG_MS2C_ROLE_UPDATA_GUILDID(event)
	local useData = event._usedata
	local msgData = useData.msgData

	if msgData.guid ~= NULL_GUID then
		if self._controlerMap.guild ~= nil then
			self._controlerMap.guild:getView():removeFromParent()
			self._controlerMap.guild = nil
		end
		
		self:_createControler_guild()
	else
		self:closeGuildUI()
		self:closeBattleUI()
	end
end


function guildSystem:_onEvent_no_guild_main_layer( sender, eventName, data )
	if eventName == "exit" then
		self:closeGuildUI()
	end
end


function guildSystem:_onEvent_owner_guild_main_layer( sender, eventName, data )
	if eventName == "btn_battleTouched" then
		if self._controlerMap.guildBattle == nil then
			
			if self._controlerMap.guild ~= nil then
				self._controlerMap.guild:getView():removeFromParent()
				self._controlerMap.guild = nil
				release_res(self._dynamicResConfigIDs)
			end

			self._controlerMap.guildBattle = class_controler_guild_battle_main_layer.new(self:_create_guild_battle_main_layer())
			self._controlerMap.guildBattle:addEventListener(handler(self, self._onEvent_guildBattle))
			self.scene:addChildToLayer(LAYER_ID_POPUP, self._controlerMap.guildBattle:getView())

			GLOBAL_COMMON_ACTION:popupOut({node=self._controlerMap.guildBattle:getView()})
		end

	elseif eventName == "exit" then
		self:closeGuildUI()
	end
end


function guildSystem:_onEvent_guildBattle( sender, eventName, data )
	if eventName == "exit" then
		self:closeBattleUI()
	end
end


--关闭公会UI
function guildSystem:closeGuildUI()
	local function popupBackActionCallBack()
		self._controlerMap.guild:getView():removeFromParent()
		self._controlerMap.guild = nil
		release_res(self._dynamicResConfigIDs)
	end
	GLOBAL_COMMON_ACTION:popupBack({node=self._controlerMap.guild:getView(), callback=popupBackActionCallBack})
end


--关闭战场UI
function guildSystem:closeBattleUI()
	if self._controlerMap.guildBattle ~= nil then
		local function popupBackActionCallBack()
			self._controlerMap.guildBattle:getView():removeFromParent()
			self._controlerMap.guildBattle = nil
			release_res(self._dynamicResConfigIDs)
		end
		GLOBAL_COMMON_ACTION:popupBack({node=self._controlerMap.guildBattle:getView(), callback=popupBackActionCallBack})
	end
	
end


function guildSystem.getInstance()
    if guildSystem.instance == nil then
        guildSystem.instance = guildSystem.new()
    end

    return guildSystem.instance
end


guildSystemInstance = guildSystem.getInstance()


return guildSystem
