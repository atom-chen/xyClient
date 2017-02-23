--
-- Author: LiYang
-- Date: 2015-08-04 14:46:46
-- buf管理

bufManager = {};

-- 2201	眩晕
bufManager.CONST_BUFF_DIZZINESS 	=  2201;--眩晕

bufManager.CONST_BUFF_paralysis 	= 2202;-- 麻痹

bufManager.CONST_BUFF_landification = 2203;-- 石化

bufManager.CONST_BUFF_invincible 	=  1302;--无敌

bufManager.CONST_BUFF_cholera 		= 2401; -- 霍乱

bufManager.CONST_BUFF_firing 		= 2104; -- 灼烧(2104,2105)

bufManager.CONST_BUFF_intoxication 	= 2106; -- 中毒

bufManager.CONST_BUFF_tear 			= 2102; -- 撕裂(流血)

bufManager.CONST_BUFF_Bullseye 		= 1719;--瞄准靶心

bufManager.CONST_BUFF_KunBang 		= 2607;--捆绑

bufManager.CONST_BUFF_HuiFu 		= 1702;--恢复

--再战(复活buff)
bufManager.CONST_BUFF_resurgence 	= 1721

--------------数值buff
bufManager.CONST_VALUSEBUFF_1501 	= 1501;
bufManager.CONST_VALUSEBUFF_1532 	= 1539;
bufManager.CONST_VALUSEBUFF_1520 	= 1520;--暴击叠加
bufManager.CONST_VALUSEBUFF_1517 	= 1517;--1517 攻击 暴击叠加
bufManager.CONST_VALUSEBUFF_1501 	= 1501;--1501 攻击叠加

------------数值buf减益状态
bufManager.CONST_VALUSEBUFF_2601 	= 2601;--减少攻击
bufManager.CONST_VALUSEBUFF_2609 	= 2609;



----------------等待完成的-----------------
--人遁(隐身buff)
bufManager.CONST_BUFF_HID = 1721

--是否是数值buf
function bufManager:IsValuseBuff( params )
	if params >= self.CONST_VALUSEBUFF_1501 and params <= self.CONST_VALUSEBUFF_1532 then
		return true;
	end
	if params >= self.CONST_VALUSEBUFF_2601 and params <= self.CONST_VALUSEBUFF_2609 then
		return true;
	end
end

--[[创建buf效果
	params = {
		aim = nil, --目标
		effecttype = 0,--效果类型
	}
]]
function bufManager:CreateBufEffect( params )
	local effecttype = params.effecttype;
	print(effecttype)
	if effecttype == 0 or (not getEffectConfigById(effecttype)) then
		return nil;
	end
	local effectinfo = getEffectConfigById(effecttype);
	local effect =  EffectManager:CreateArmature( {
			name = effectinfo.armature,--效果名称
			x = 0 ,
			y = 0 ,
			zorder = 0,
			isfinishdestroy = false,--是否完成销毁
		} );
	params.aim.showObject:addShowObject( effect , 2 )
	effect:playAnimationByID( effectinfo.armaturename ,nil ,-1);
	--角色暂停
	return effect;
end

--[[创建数值buf特效效果
	params = {
		aim = nil, --目标
		icon = 0,--效果类型
	}
]]
function bufManager:CreateNumericeBufEffect( params )
	local effect = require("app.effect.bufeffect.numericeBufEffect").new();
	effect:SetBufData( params.icon );
	params.aim:addNumericeBufEffect( effect );
	return effect;
end

--解析buf显示数据
function bufManager:analysisBufShowData( buffID )

	local Colorvaluse = nil; --颜色值
	local LogicType = 0; --逻辑类型
	local ishowOverlay = false;--是否显示叠加

	if buffID == self.CONST_BUFF_DIZZINESS or buffID == 2202 then --"眩晕"
		LogicType = 1;
	elseif buffID == self.CONST_BUFF_cholera then --"霍乱"
		LogicType = 3;
	elseif buffID == self.CONST_BUFF_invincible then --"无敌"
		LogicType = 5;
	elseif buffID == self.CONST_BUFF_KunBang then --"困锁"
		LogicType = 6;
	elseif buffID == self.CONST_BUFF_tear or buffID == 2101 then -- 撕裂
		LogicType = 2;
	elseif buffID == self.CONST_BUFF_Bullseye then --瞄准
		LogicType = 4;
	elseif buffID == self.CONST_BUFF_HuiFu then --回复
		LogicType = 12;
	elseif buffID == self.CONST_BUFF_firing or buffID == 2105 or buffID == 2103 then -- 灼烧
		--修改角色中毒状态
		Colorvaluse = cc.c3b(255, 147, 91);
		LogicType = 11;
		ishowOverlay = true;
	elseif buffID == self.CONST_BUFF_intoxication or buffID == 2107 then -- 中毒
		--判断是否有叠加效果
		LogicType = 10;
		--修改角色中毒状态
		Colorvaluse = cc.c3b(171, 152, 200);
		ishowOverlay = true;
	elseif buffID == self.CONST_VALUSEBUFF_1517 then
		LogicType = "20001";
		Colorvaluse = cc.c3b(255, 147, 91);
	elseif buffID == self.CONST_VALUSEBUFF_1520 or buffID == self.CONST_VALUSEBUFF_1501 then
		--暴击增加4%叠加
		Colorvaluse = cc.c3b(255, 147, 91);
		ishowOverlay = true;
	end

	return LogicType,Colorvaluse,ishowOverlay;
end

--[[ 创建buf
	params = {
		aim = nil,--buff作用目标
		skillID = nil,--buffID
	}
]]
function bufManager:CreateBuf( params )
	local effect =  params.aim:IsHaveBuff( params.skillID );

	--先设置buff数据
	--没有buf创建新的buf显示
	if not effect then
		local effect = require("app.effect.bufeffect.bufControl").new();
		effect:setBufData(params);
		--判断是否能加载
		local isadd = params.aim:AddBuff( effect );
	else
		--有了buf做buf叠加显示出来
		effect:BuffOverlayEffect();
	end

	return effect;
end


