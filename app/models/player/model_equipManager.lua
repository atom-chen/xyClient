--
-- Author: Wu Hengmin
-- Date: 2015-07-09 15:42:27
--

local model_equipManager = class("model_equipManager")

--[[监听全局事件名预览
eventModleName: netMsg
eventName: 
	tostring(MSG_MS2C_EQUIPS_PIECT_UNITE_RE)           -- 装备合成回复
	tostring(MSG_MS2C_EQUIPS_SMELT)                    -- 熔炼装备更新
	tostring(MSG_MS2C_EQUIPS_STRENGTHEN)               -- 强化装备更新
]]
--[[发送全局事件名预览
eventModleName: model_equipManager
eventName: 
	openequip --打开装备界面
	refreshfenjie -- 更新分解界面
	addEquip -- 添加了装备
	removeEquip -- 删除了装备
	equipactive -- 装备激活
	equipshengji -- 装备升级
	equiphecheng -- 合成
]]
local equipmentClass = import(".equipment")

function model_equipManager:ctor()
	-- body
	self.data = {}
	self.fragment = {}
	self.log = {}

	self:_registGlobalEventListeners()

end

function model_equipManager:addLog(params)
	-- body
	table.insert(self.log, params)
end

--注册全局事件监听器
function model_equipManager:_registGlobalEventListeners()
	self._globalEventListeners = {}
	local configs = {
		{modelName = "netMsg", eventName = tostring(MSG_MS2C_EQUIPS_PIECT_UNITE_RE), callBack=handler(self, self._onMSG_MS2C_EQUIPS_PIECT_UNITE_RE)},
		{modelName = "netMsg", eventName = tostring(MSG_MS2C_EQUIPS_SMELT), callBack=handler(self, self._onMSG_MS2C_EQUIPS_SMELT)},
		{modelName = "netMsg", eventName = tostring(MSG_MS2C_EQUIPS_STRENGTHEN), callBack=handler(self, self._onMSG_MS2C_EQUIPS_STRENGTHEN)},
	}
	self._globalEventListeners = createGlobalEventListenerWithConfig(configs)
end

function model_equipManager:addEqu(params)
	-- body
	local equipment = equipmentClass:new()
	equipment.mainlevel = params.mainlevel
	equipment.id = params.id
	equipment.guid = params.guid
	equipment.count_stone_upgrade = params.count_stone_upgrade
	equipment.count_stone_improve = params.count_stone_improve
	equipment.off_attr_1 = params.off_attr_1
	equipment.off_attr_2 = params.off_attr_2
	equipment.off_attr_3 = params.off_attr_3
	equipment.off_attr_4 = params.off_attr_4
	equipment.off_attr_5 = params.off_attr_5
	equipment.other_attr = params.other_attr

	if EquipConfig[params.id] then
		-- self:createEquip(equipment)
		
		table.insert(self.data, equipment)
	else
		print("装备数据ID错误:"..params.id)
	end
end

-- 洗炼更新
function model_equipManager:xlEqu(params)
	-- body
	local equipment = self:getEquipByGuid(params.guid)
	equipment.off_attr_1 = params.off_attr_1
	equipment.off_attr_2 = params.off_attr_2
	equipment.off_attr_3 = params.off_attr_3
	equipment.off_attr_4 = params.off_attr_4
	equipment.off_attr_5 = params.off_attr_5
end

function model_equipManager:updateEqu(params)
	-- body
	local equipment = self:getEquipByGuid(params.guid)
	equipment.mainlevel = params.mainlevel
	equipment.id = params.id
	equipment.guid = params.guid
	equipment.count_stone_upgrade = params.count_stone_upgrade
	equipment.count_stone_improve = params.count_stone_improve
	equipment.off_attr_1 = params.off_attr_1
	equipment.off_attr_2 = params.off_attr_2
	equipment.off_attr_3 = params.off_attr_3
	equipment.off_attr_4 = params.off_attr_4
	equipment.off_attr_5 = params.off_attr_5
	equipment.other_attr = params.other_attr
end

function model_equipManager:updateOffAttr(params)
	-- body
	local equipment = self:getEquipByGuid(params.guid)
	equipment.off_attr_1 = params.off_attr_1
	equipment.off_attr_2 = params.off_attr_2
	equipment.off_attr_3 = params.off_attr_3
	equipment.off_attr_4 = params.off_attr_4
	equipment.off_attr_5 = params.off_attr_5
end

function model_equipManager:removeEqu(guid)
	-- body
	for i=1,#self.data do
		if self.data[i].guid == guid then
			table.remove(self.data, i)
			break
		end
	end
end

function model_equipManager:getEquipByGuid(guid)
	-- body
	for i=1,#self.data do
		if self.data[i].guid == guid then
			return self.data[i]
		end
	end
end

function model_equipManager:addFragment(params)
	-- body
	if EquipConfig[params.id] and params.id ~= 40804 then
		for i=1,#self.fragment do
			if self.fragment[i].id == params.id then
				self.fragment[i].count = self.fragment[i].count + params.count
				return
			end
		end
		table.insert(self.fragment, {id = params.id, count = params.count})
	else
		print("碎片ID有误")
	end
end

function model_equipManager:removeFragment(params)
	-- body
	for i=1,#self.fragment do
		if self.fragment[i].id == params.id then
			self.fragment[i].count = self.fragment[i].count - params.count
			return
		end
	end
end

function model_equipManager:updateFragment(params)
	-- body
	for i=1,#self.fragment do
		if self.fragment[i].id == params.id then
			self.fragment[i].count = self.fragment[i].count
			return
		end
	end
end

-- 提升主属性等级
function model_equipManager:upgradeMainLevel(guid, upgrade)
	-- body
	local equip = self:getEquipByGuid(guid)
	equip.mainlevel = equip.mainlevel + upgrade
end

-- 更新返还银两
function model_equipManager:updateYinliang(guid, yinliang)
	local equip = self:getEquipByGuid(guid)
	equip.yinliang = equip.yinliang + yinliang
end

-- 更新返还道具
function model_equipManager:updateDaoju(guid, item)
	local equip = self:getEquipByGuid(guid)
	equip.item = equip.item + item
end

-- 提升副属性等级
function model_equipManager:upgradeOffLevel(guid, upgrade)
	-- body
	local equip = self:getEquipByGuid(guid)
	equip.offlevel = equip.offlevel + upgrade
end

-- 得到主属性类型
function model_equipManager:getMainTypeByGuid(guid)
	-- body
	return self:getMainType(self:getEquipByGuid(guid).id)
end
-- 得到主属性类型
function model_equipManager:getMainType(id)
	-- body
	return AttrType[EquipConfig[id].main_attr_type]
end

-- 得到副属性类型
function model_equipManager:getOffTypeByGuid(guid)
	-- body
	return self:getOffType(self:getEquipByGuid(guid).id)
end
-- 得到副属性类型
function model_equipManager:getOffType(id)
	-- body
	return AttrType[EquipConfig[id].extra_attr_type]
end


-- 得到主属性值
function model_equipManager:getMainAttr(guid)
	local equip = self:getEquipByGuid(guid)

	return equip:getMainAttr()
end
-- 得到升级一次后的主属性值
function model_equipManager:getMainAttrWithNextLevel(guid)
	local equip = self:getEquipByGuid(guid)
	return math.floor(EquipConfig[equip.id].main_attr + EquipConfig[equip.id].intensify_effect * (equip.mainlevel+1))
end

-- 得到副属性值
function model_equipManager:getOffAttr(guid)
	local equip = self:getEquipByGuid(guid)
	return equip:getOffAttr()
end
-- 得到升级一次后的副属性值
function model_equipManager:getOffAttrWithNextLevel(guid)
	local equip = self:getEquipByGuid(guid)
	return math.floor(EquipConfig[equip.id].extra_attr_attr * (equip.offlevel+1))
end

-- 得到副属性最大值
function model_equipManager:getMaxOffAttr(id)
	-- body
	return EquipConfig_getMaxOffAttr(self.id)
end

-- 拷贝装备数据到列表
function model_equipManager:cloneEquipDataToList()
	return clone(self.data)
end

function model_equipManager:_onMSG_MS2C_EQUIPS_PIECT_UNITE_RE(params)
	-- body
	local id = params._usedata.id
	local count = params._usedata.count
	self:removeFragment({id = id, count = count})

	dispatchGlobaleEvent("model_equipManager", "equiphecheng")
end

function model_equipManager:getXilianTarg()
	-- body
	local function sort(a, b)
		-- body
		if EquipConfig[a.id].Quality ~= EquipConfig[b.id].Quality then
			return EquipConfig[a.id].Quality < EquipConfig[b.id].Quality
		elseif EquipConfig[a.id].mainlevel ~= EquipConfig[b.id].mainlevel then
			return EquipConfig[a.id].mainlevel < EquipConfig[b.id].mainlevel
		else
			return a.id < b.id
		end
	end
	local tmp = {}
	for k,v in pairs(self.data) do
		if EquipConfig[v.id].smelt_value ~= 0 and
			not MAIN_PLAYER:getTeamManager():isTakeEquip(v.guid) then
			table.insert(tmp, v)
		end
	end
	table.sort(tmp, sort)

	-- 还需去除
	local data = {}
	for i=1,8 do
		if tmp[i] then
			data[i] = tmp[i]
		end
	end
	return data
end

function model_equipManager:getXilianTargWithGuid(params)
	local data = {}
	for i=1,#params do
		table.insert(data, self:getEquipByGuid(params[i]))
	end
	return data
end

-- 熔炼后更新
function model_equipManager:_onMSG_MS2C_EQUIPS_SMELT(params)
	-- body
	local data = params._usedata.data
	dispatchGlobaleEvent("ronglian_ctrl", "update", {data = data})
end

-- 更新装备强化面板
function model_equipManager:_onMSG_MS2C_EQUIPS_STRENGTHEN()
	-- body
	dispatchGlobaleEvent("backpack_ctrl", "updatePanel", {sign = ""})
end


function model_equipManager:getWuqi()
	-- body
	local data = {}
	for i=1,#self.data do
		if EquipConfig[self.data[i].id]._type==0 then
			table.insert(data, self.data[i])
		end
	end
	return data
end

function model_equipManager:getToukui()
	-- body
	local data = {}
	for i=1,#self.data do
		if EquipConfig[self.data[i].id]._type==2 then
			table.insert(data, self.data[i])
		end
	end
	return data
end

function model_equipManager:getFangju()
	-- body
	local data = {}
	for i=1,#self.data do
		if EquipConfig[self.data[i].id]._type==3 then
			table.insert(data, self.data[i])
		end
	end
	return data
end

function model_equipManager:getXiezi()
	-- body
	local data = {}
	for i=1,#self.data do
		if EquipConfig[self.data[i].id]._type==4 then
			table.insert(data, self.data[i])
		end
	end
	return data
end

function model_equipManager:getBai()
	-- body
	local data = {}
	for i=1,#MAIN_PLAYER.equipManager.data do
		if EquipConfig[self.data[i].id].quality==1 then
			table.insert(data, self.data[i])
		end
	end
	return data
end

function model_equipManager:getLv()
	-- body
	local data = {}
	for i=1,#MAIN_PLAYER.equipManager.data do
		if EquipConfig[self.data[i].id].quality==2 then
			table.insert(data, self.data[i])
		end
	end
	return data
end

function model_equipManager:getLan()
	-- body
	local data = {}
	for i=1,#MAIN_PLAYER.equipManager.data do
		if EquipConfig[self.data[i].id].quality==3 then
			table.insert(data, self.data[i])
		end
	end
	return data
end

function model_equipManager:getZi()
	-- body
	local data = {}
	for i=1,#MAIN_PLAYER.equipManager.data do
		if EquipConfig[self.data[i].id].quality==4 then
			table.insert(data, self.data[i])
		end
	end
	return data
end

function model_equipManager:getCheng()
	-- body
	local data = {}
	for i=1,#MAIN_PLAYER.equipManager.data do
		if EquipConfig[self.data[i].id].quality==5 then
			table.insert(data, self.data[i])
		end
	end
	return data
end

function model_equipManager:getHong()
	-- body
	local data = {}
	for i=1,#MAIN_PLAYER.equipManager.data do
		if EquipConfig[self.data[i].id].quality==6 then
			table.insert(data, self.data[i])
		end
	end
	return data
end

function model_equipManager:getQuan()
	-- body
	local data = {}
	for i=1,#MAIN_PLAYER.equipManager.data do
		table.insert(data, self.data[i])
	end
	return data
end

return model_equipManager
