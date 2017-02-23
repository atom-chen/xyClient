--
-- Author: lipeng
-- Date: 2013-12-20 09:10:47
-- Dec: 英雄

local hero = class("hero")


--将英雄的主属性值转换为整数
function HeroMainAttrToInt( attrValue )
	return math.floor(attrValue)
end

--将英雄的副属性值转换为整数
function HeroFuAttrToInt( attrValue )
	return math.floor(attrValue * 10000)
end

function hero:ctor()
	self.id = -1 -- 模板ID
	self.curLv = 1 -- 英雄当前等级
	self.skillLv = 1
	self.occupatpower = 0 -- 职业强度
	self.Exp = 0 --英雄经验
	self.guid = "" -- 英雄guid
	self.time = 0 -- 获取时间戳
	self.fixProperty = {} -- 固定属性
	self.isLocked = 0 -- 锁定状态
	self.ownerPlayer = MAIN_PLAYER -- 所属玩家
end

-- 得到当前可以升级的最高技能等级
function hero:getMaxSkillLv()
	-- body
	return math.floor(self.id/1000%100)
end

function hero:getGUID()
	return self.guid
end

--设置模板ID
function hero:setTempleateID(id)
	self.id = id
	self.fixProperty = GetHeroTemplate(self.id)
end

--获取模板ID
function hero:getTempleateID()
	return self.id
end

--模板ID是否有效
function hero:isValidTempleateID()
	return HeroTeampleate_isValideID(self.id)
end

function hero:getName()
	return self.fixProperty.name
end

--设置英雄等级
function hero:setLv( lv )
	self.curLv = lv
end

--设置英雄EXP
function hero:setExp( exp )
	self.Exp = exp
end

function hero:setOccupatpower( occupatpower )
	-- body
	self.occupatpower = occupatpower
end

function hero:getOccupatpower( occupatpower )
	-- body
	return self.occupatpower
end

--是否为最高等级
function hero:isMaxLv()
	return self.curLv >= self.fixProperty.lvLimit
end

function hero:getSkillLv()
	-- body
	return self.skillLv
end

function hero:setSkillLv(skillLv)
	-- body
	self.skillLv = skillLv
end

--获取技能列表
function hero:getSkillSet()
	return heroConfig[self.id].skill_set
end

-- 得到职业强度属性
function hero:getOccupatpower()
	-- body
	return OccuCfg[heroConfig[self.id].profession].upgrade[self.occupatpower]
end

-- 得到下一级职业强度属性
function hero:getOccupatpowerWithNextOccupatpower()
	-- body
	return OccuCfg[heroConfig[self.id].profession].upgrade[self.occupatpower+1]
end

--获取hp总值
function hero:getHPTotal()
	local playerAttr = self.ownerPlayer:getBaseAttr()
	--注: 不能加装备及天命, 因为同一英雄在不同队伍时, 装备和天命激活有所不同, 其他属性同
	-- 新加入职业强度加成
	if self.occupatpower > 0 then
		return heroConfig_computeHP(self.id, playerAttr:getLv())+math.floor(self:getOccupatpower().hp)
	else
		return heroConfig_computeHP(self.id, playerAttr:getLv())
	end
end
-- 得到下一级职业强度下的hp总值
function hero:getHPTotalWithNextOccupatpower()
	local playerAttr = self.ownerPlayer:getBaseAttr()
	if self.occupatpower < #OccuCfg[heroConfig[self.id].profession].upgrade then
		return heroConfig_computeHP(self.id, playerAttr:getLv())+math.floor(self:getOccupatpowerWithNextOccupatpower().hp)
	else
		return heroConfig_computeHP(self.id, playerAttr:getLv())+math.floor(self:getOccupatpower().hp)
	end
end

--获取基础生命值
function hero:getBaseHP()
	local playerAttr = self.ownerPlayer:getBaseAttr()
	return heroConfig_computeHP(self.id, playerAttr:getLv())
end


--获取进化后总HP
function hero:getEvoFinshHPTotal()
	local playerAttr = self.ownerPlayer:getBaseAttr()
	return heroConfig_computeHP(self.fixProperty.wake_des_id, playerAttr:getLv())
end

--获取攻击力总值
function hero:getAttackTotal()
	local playerAttr = self.ownerPlayer:getBaseAttr()
	--注: 不能加装备及天命, 因为同一英雄在不同队伍时, 装备和天命激活有所不同, 其他属性同
	-- 新加入职业强度加成
	if self.occupatpower > 0 then
		return heroConfig_computeAttack(self.id, playerAttr:getLv())+math.floor(self:getOccupatpower().atk)
	else
		return heroConfig_computeAttack(self.id, playerAttr:getLv())
	end
end
-- 得到下一级职业强度下的攻击力总值
function hero:getAttackTotalWithNextOccupatpower()
	local playerAttr = self.ownerPlayer:getBaseAttr()
	if self.occupatpower < #OccuCfg[heroConfig[self.id].profession].upgrade then
		return heroConfig_computeAttack(self.id, playerAttr:getLv())+math.floor(self:getOccupatpowerWithNextOccupatpower().atk)
	else
		return heroConfig_computeAttack(self.id, playerAttr:getLv())+math.floor(self:getOccupatpower().atk)
	end
end

--获取基础攻击力
function hero:getBaseAttack()
	local playerAttr = self.ownerPlayer:getBaseAttr()
	return heroConfig_computeAttack(self.id, playerAttr:getLv())
end


--获取进化后总攻击力
function hero:getEvoFinshAttackTotal()
	local playerAttr = self.ownerPlayer:getBaseAttr()
	return heroConfig_computeAttack(self.fixProperty.wake_des_id, playerAttr:getLv())
end


--获取物防总值
function hero:getWuFangTotal()
	local playerAttr = self.ownerPlayer:getBaseAttr()
	--注: 不能加装备及天命, 因为同一英雄在不同队伍时, 装备和天命激活有所不同, 其他属性同
	if self.occupatpower > 0 then
		return heroConfig_computePDef(self.id, playerAttr:getLv())+math.floor(self:getOccupatpower().pdef)
	else
		return heroConfig_computePDef(self.id, playerAttr:getLv())
	end
end
-- 得到下一级职业强度下的物防总值
function hero:getWuFangTotalWithNextOccupatpower()
	local playerAttr = self.ownerPlayer:getBaseAttr()
	if self.occupatpower < #OccuCfg[heroConfig[self.id].profession].upgrade then
		return heroConfig_computePDef(self.id, playerAttr:getLv())+math.floor(self:getOccupatpowerWithNextOccupatpower().pdef)
	else
		return heroConfig_computePDef(self.id, playerAttr:getLv())+math.floor(self:getOccupatpower().pdef)
	end
end

--获取基础物防
function hero:getBaseWuFang()
	local playerAttr = self.ownerPlayer:getBaseAttr()
	return heroConfig_computePDef(self.id, playerAttr:getLv())
end

--获取进化后总物防
function hero:getEvoFinshWuFangTotal()
	local playerAttr = self.ownerPlayer:getBaseAttr()
	return heroConfig_computePDef(self.fixProperty.wake_des_id, playerAttr:getLv())
end

--获取魔防总值
function hero:getMoFangTotal()
	local playerAttr = self.ownerPlayer:getBaseAttr()
	--注: 不能加装备及天命, 因为同一英雄在不同队伍时, 装备和天命激活有所不同, 其他属性同
	if self.occupatpower > 0 then
		return heroConfig_computeMDef(self.id, playerAttr:getLv())+math.floor(self:getOccupatpower().pdef)
	else
		return heroConfig_computeMDef(self.id, playerAttr:getLv())
	end
end
-- 得到下一级职业强度下的物防总值
function hero:getMoFangTotalWithNextOccupatpower()
	local playerAttr = self.ownerPlayer:getBaseAttr()
	if self.occupatpower < #OccuCfg[heroConfig[self.id].profession].upgrade then
		return heroConfig_computeMDef(self.id, playerAttr:getLv())+math.floor(self:getOccupatpowerWithNextOccupatpower().pdef)
	else
		return heroConfig_computeMDef(self.id, playerAttr:getLv())+math.floor(self:getOccupatpower().pdef)
	end
end

--获取基础魔防
function hero:getBaseMoFang()
	local playerAttr = self.ownerPlayer:getBaseAttr()
	return heroConfig_computeMDef(self.id, playerAttr:getLv())
end


--获取进化后总魔防
function hero:getEvoFinshMoFangTotal()
	local playerAttr = self.ownerPlayer:getBaseAttr()
	return heroConfig_computeMDef(self.fixProperty.wake_des_id, playerAttr:getLv())
end


--获取暴击
function hero:getBaoJi()
	return heroConfig_computeBaoJi(self.id)*100
end


--获取命中
function hero:getMingZhong()
	return heroConfig_computeMingZhong(self.id)*100
end


--韧性
function hero:getRenXing()
	return heroConfig_computeRenXing(self.id)
end


--闪避
function hero:getShanBi()
	return heroConfig_computeShanBi(self.id)*100
end


--爆伤
function hero:getBaoShang()
	return heroConfig_computeBaoShang(self.id)*100
end

-- 分解或者降阶可返还经验
function hero:getReturnEXP()
	-- body
	local returnExp = 0
	if self.id == 40501 or 
		self.id == 50501 then
		returnExp = self.fixProperty.tigong_EXP
	else
		returnExp = cardLvDownExpConfig_zongExp(self.curLv) + self.Exp
	end
	return returnExp
end


function hero:decodeServerMsg( recvMsg )
	--[[事例
	self.id = recvMsg:ReadInt()
	...
	]]
end

--需要领导力
function hero:needLeadership()
	return self.fixProperty.Energy -- + 装备需要领导力等等
end


--计算通过指定经验可从当前等级升至多少级
function hero:computeExpToLv( exp )
	local destLv = self.curLv

	--如果可以升级
	if self.curLv < self.fixProperty.lvLimit then
		--目标经验值
		local destExp = self.Exp + exp

		destLv = cardLvUpNeedExpConfig_computeToLv(self.curLv, destExp)
		if destLv >= self.fixProperty.lvLimit then
			destLv = self.fixProperty.lvLimit
		end
	end

	return destLv
end


--计算继承经验所需要消耗的银两(即: 当前英雄作为材料被吞噬时所消耗的银两)
function hero:computeInheritExpConsumeGold()
	return EAT_CARD_GOLD
end


--获取1到下一级总共需要多少经验值(不包括当前经验)
function hero:getLvUpNeedExp()
	if self.curLv < self.fixProperty.lvLimit then
		return cardLvUpNeedExpConfig_LvUpNeedExp(self.curLv)
	end

	return 0
end



--计算当前经验与升级所需经验百分比
function hero:computeCurExpWithLvUpNeedExpPer()
	local curExpWithLvUpNeedExpPer = 0
	--获取升至下级所需的总经验
	local LvUpNeedExp = self:getLvUpNeedExp()
	print("LvUpNeedExp "..LvUpNeedExp)

	--当满级时, 升级所需经验为0
	if LvUpNeedExp ~= 0 then
		curExpWithLvUpNeedExpPer = self.Exp / LvUpNeedExp
		print("curExpWithLvUpNeedExpPer "..curExpWithLvUpNeedExpPer)
		if curExpWithLvUpNeedExpPer > 1 then
			curExpWithLvUpNeedExpPer = 1
		end
	end
	
	return curExpWithLvUpNeedExpPer
end


--计算英雄从当前等级到最高等级还差多少经验
function hero:curToMaxLvNeedExp()
	print("curToMaxLvNeedExp()")
	print(self.Exp)
	return cardLvUpNeedExpConfig_computeFromToDestLvNeedExp(self.curLv, self.fixProperty.lvLimit) - self.Exp
end


--获取武将类型
function hero:getWuJiangType()
	return self.id % 1000
end

--获取武将类型名字
function hero_getWuJiangTypeName( wuJiangType )
	local id = 0
	for i=1,6 do
		id = i*10000 + wuJiangType
		if heroConfig[id] ~= nil then
			local name = string.split(heroConfig_name(id), "+")
			return name[1]
		end
	end

	return ""
end


--获取武将品质
function hero:getPinZhi()
	return 10
end


--获取武将当前等级
function hero:getCurLv()
	return self.curLv
end

--获取所属国家的ID
function hero:getCountryID()
	return heroConfig[self.id].country
end


--获取攻击类型
function hero:getStrAtkType()
	return heroConfig_toStrAtkType(
		heroConfig[self.id].profession
	)
end


--获取职业类型
function hero:getProfessionType()
	print(self.id)
	return heroConfig[self.id].profession
end

--获取战斗力
function hero:getPower(playerLv)
	local id = self.id

	local occuAttrs = OccuCfg_getOccuAttrs(
		self:getProfessionType(), 
		self:getOccupatpower()
	)

	if occuAttrs == nil then
		occuAttrs = {}
		occuAttrs.hp = 0
		occuAttrs.atk = 0
		occuAttrs.pdef = 0
		occuAttrs.mdef = 0
	end

	local hp = heroConfig_computeHP(id, playerLv) + occuAttrs.hp
	local attack = heroConfig_computeAttack(id, playerLv) + occuAttrs.atk
	local pDef = heroConfig_computePDef(id, playerLv) + occuAttrs.pdef
	local mDef = heroConfig_computeMDef(id, playerLv) + occuAttrs.mdef
	local bj = heroConfig_computeBaoJi(id)
	local bs = heroConfig_computeBaoShang(id)
	local rx = heroConfig_computeRenXing(id)
	local mz = heroConfig_computeMingZhong(id)
	local miss = heroConfig_computeShanBi(id)
	local skillLv = self.skillLv

	return math.floor(
		(hp/5 + attack + pDef + mDef) * 
			( (mz-0.95) + (bj-0.05) + (bs-0.5)/2 + miss + 1 + skillLv*0.05 )
	)
end

function hero:getZhanli()
	-- body
	return math.floor(
		self:getHPTotal()/5+self:getAttackTotal()+self:getWuFangTotal()+self:getMoFangTotal()

		)

end

function hero:isInTeam()
	-- body
	MAIN_PLAYER:getTeamManager():isInTeam(self.guid)
end


return hero