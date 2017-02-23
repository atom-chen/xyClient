--
-- Author: Wu Hengmin
-- Date: 2015-07-14 16:58:50
--
local equipment = class("equipment")


function equipment:ctor()
	-- body
	self.id = 1
	self.guid = nil
	self.level = 0
	self.belong = false
	self.ben = false
	self.star = 0
	self.viceID = 0
	self.offID = 0

end

--获取模板ID
function equipment:getTeampleateID()
	return self.id
end

--获取GUID
function equipment:getGUID()
	return self.guid
end

--获取装备类型
function equipment:getType()
	return EquipConfig_getEquipmentType(self.id)
end

--获取装备类型名
function equipment:getTypeName()
	return EquipConfig_getEquipmentTypeName(self.id)
end

--获取附加属性: 物攻
function equipment:getOffAttr_pAttack()
	return self.off_attr_1
end

--获取附加属性: 法攻
function equipment:getOffAttr_mAttack()
	return self.off_attr_2
end

--获取附加属性: 生命
function equipment:getOffAttr_hp()
	return self.off_attr_3
end

--获取附加属性: 物防
function equipment:getOffAttr_pDef()
	return self.off_attr_4
end

--获取附加属性: 法防
function equipment:getOffAttr_mDef()
	return self.off_attr_5
end

--将其他属性列表的key转换为类型字符串key
function equipment:otherAttrToTypeStrKey()
	local typeStrKey_otherAttr = {}

	for k,v in pairs(self.other_attr) do
		local typeStr = AttrType[v.type_]
		typeStrKey_otherAttr[typeStr] = tonumber(v.attr)
	end

	return typeStrKey_otherAttr
end


--获取主属性类型名
function equipment:getMainTypeName()
	return AttrType[EquipConfig[self.id].main_attr_type]
end

-- 得到主属性
function equipment:getMainAttr()
	return math.floor(EquipConfig[self.id].main_attr_value*(1+self.mainlevel/10))
end

-- 得到没有附加属性主属性值
function equipment:getMainAttrWithoutOff()
	return math.ceil(equipmentConfig[self.id].mainAttr.value + equipmentConfig[self.id].mainAttr.fujia*self.level)
end

-- 得到没有附加属性以及不考虑装备等级的主属性值
function equipment:getMainAttrWithoutOffAndLevel()
	return math.ceil(equipmentConfig[self.id].mainAttr.value)
end

-- 得到等级提升属性值
function equipment:getLevelImprove()
	return math.ceil(equipmentConfig[self.id].mainAttr.fujia*self.level)
end

--获取副属性名
function equipment:getOffAttrTypeName()
	return AttrType[EquipConfig[self.id].extra_attr_type]
end


function equipment:getOffAttr()
	return math.floor(EquipConfig[self.id].extra_attr_attr * self.offlevel)
end

--获取装备名
function equipment:getName()
	return EquipConfig[self.id].name
end

--获取装备描述
function equipment:getExplain()
	return EquipConfig[self.id].explain
end

--获取装备主属性等级
function equipment:getMainLevel()
	return self.mainlevel
end

--获取装备等级
function equipment:getLv()
	return EquipConfig_getLv(self.id)
end

-- 得到副属性最大值
function equipment:getMaxOffAttr()
	return EquipConfig_getMaxOffAttr(self.id)
end


--获取总战斗力
function equipment:getZhanDouLi()
	return self:getZhanDouLiMain() + self:getZhanDouLiOff()
end

-- 获取基本战斗力
function equipment:getZhanDouLiMain()
	if "生命" == AttrType[EquipConfig[self.id].main_attr_type] then
		return math.floor(EquipConfig[self.id].main_attr_value*(1+self.mainlevel/10)/5)
	elseif "攻击" == AttrType[EquipConfig[self.id].main_attr_type] then
		return math.floor(EquipConfig[self.id].main_attr_value*(1+self.mainlevel/10))
	elseif "物攻" == AttrType[EquipConfig[self.id].main_attr_type] then
		return math.floor(EquipConfig[self.id].main_attr_value*(1+self.mainlevel/10))
	elseif "法攻" == AttrType[EquipConfig[self.id].main_attr_type] then
		return math.floor(EquipConfig[self.id].main_attr_value*(1+self.mainlevel/10))
	elseif "防御" == AttrType[EquipConfig[self.id].main_attr_type] then
		return math.floor(EquipConfig[self.id].main_attr_value*(1+self.mainlevel/10))
	elseif "物防" == AttrType[EquipConfig[self.id].main_attr_type] then
		return math.floor(EquipConfig[self.id].main_attr_value*(1+self.mainlevel/10))
	elseif "法防" == AttrType[EquipConfig[self.id].main_attr_type] then
		return math.floor(EquipConfig[self.id].main_attr_value*(1+self.mainlevel/10))
	end
	return 0
end

-- 获取副属性战斗力
function equipment:getZhanDouLiOff()
	local tmp = 0
	tmp = tmp + self.off_attr_1
	tmp = tmp + self.off_attr_2
	tmp = tmp + self.off_attr_3/5
	tmp = tmp + self.off_attr_4
	tmp = tmp + self.off_attr_5
	return math.floor(tmp)
end

return equipment
