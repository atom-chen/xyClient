--
-- Author: li yang
-- Date: 2014-04-16 10:13:27
-- 错误描述

--得到错误描述
function getErrorDescribe( key )
	return ErrorDescribe[key] or "未知的描述信息"..key;
end


ErrorDescribe = {
	
	--------------------------登陆错误--------------------------------------
	[eLET_LoginNoError] = "登陆成功",
	[eLET_DbBusy] = "数据库繁忙",
	[eLET_ErroreMailOrPassword] = "账号格式错误",
	[eLET_ErrorPassWordLenth] = "密码长度错误",
	[eLET_IsRejective] = "账号被封停",
	[eLET_NoAccount] = "账号或密码错误",--没有此账号
	[eLET_RepeatAccount] = "账号重复",
	[eLET_NumNotEnough] = "数量不足",
	[eLET_ServerBusy] = "服务器繁忙",
	[eLET_NoAccountPwdError] = "账号密码正确",
	[eLET_ServerNoOpen] = "服务器未开放",
	[eLET_NotServer] = "没有此服务器",
	[eLET_ReLogin] = "重登陆",
	[eLET_VersionErr] = "版本错误",
	[eLET_LoginOutTime] = "登陆超时重新登陆",
	[eLET_ServerIsFull] = "服务人满为患",

	--------------------------基本角色信息--------------------------------------
	[eRI_Success] = "操作成功",
	[eRI_ErrorRoleID] = "非法角色ID",
	[eRI_IllegalName] = "名字含有非法关键字",
	[eRI_ReName] = "名字已被他人使用",

	--------------------------英雄升级错误--------------------------------------

	--! 升级成功
	[eHUE_Success] = "升级成功",
	--! 查找英雄失败
	[eHUE_FindHeroFalse] = "查找英雄失败",
	--!	英雄等级不足进化条件
	[eHUE_NotEnoughLv] = "英雄等级不足",
	--! 技能强度达到最大
	[eHUE_MaxSkillLv] = "技能强度达到最大",
	--! 银两不足
	[eHUE_NotEnoughGold] = "银两不足",
	--! 技能升级道具数量不足
	[eHUE_NotEnoughSkillItem] = "技能升级道具数量不足",
	-- 英雄满级无法升级
	[eHUE_LevelMax] = "武将满级无法升级",
	-- 英雄无法降阶
	[eHUE_CantReduced] = "无法重置",


	[eHUE_LevelMax] = "英雄满级无法升级",
	[eHUE_NotEnoughExp] = "升级经验不足",
	[eHUE_NotEnoughGold] = "银两不足",
	[eHUE_NotEnougthPiece] = "碎片不足",
	[eHUE_NotEnougthSoul] = "将魂不足",
	[eHUE_NotEnougthItem] = "道具不足",
	[eHUE_CantWake] = "不可觉醒",

	-------------------------好友操作信息--------------------

	-- 成功
	[eFI_Success] = "成功",
	-- 自己好友数量已满
	[eFI_SelfFull] = "自己好友数量已满",
	-- 对方好友数量已满
	[eFI_TargetFull] = "对方好友数量已满",
	-- 对方不在线
	[eFI_TargetNoLine] = "对方不在线",
	-- 没有对方申请
	[eFI_NoApply] = "没有对方申请",
	-- 已经是好友了
	[eFI_HasBeen] = "已经是好友了",
	-- 不是好友
	[eFI_NotFriend] = "不是好友",
	-- 赠送次数耗尽
	[eFI_SendEnd] = "赠送次数耗尽",
	-- 已经送过
	[eFI_IsSent] = "已经送过",
	-- 对方没有赠送
	[eFI_NoSent] = "对方没有赠送",
	-- 接受次数耗尽
	[eFI_GetEnd] = "接受次数耗尽",
	-- 已经接受过
	[eFI_IsGot] = "已经接受过",

	-------------------------邮件操作信息--------------------
	-- 成功
	[eMail_Success] = "成功",
	-- 自己好友数量已满
	[eMail_None] = "没有此邮件",
	-- 对方好友数量已满
	[eMail_NoAttach] = "没有这个附件",
	[eMail_HasAttach] = "此邮件有附件，请先收取",

	----------------------抽卡信息-------------------------------
	[eDC_Success] = "成功",
	[eDC_NotEnougthGold] = "银两不足",
	[eDC_NotEnougthYuanBao] = "元宝不足",
	[eDC_NotEnougthSpace] = "武将营空间不足",
	[eDC_NotEnougthFreeTimes] = "今日次数耗尽",

	----------------------充值信息-------------------------------
	[eBYB_Success] = "充值成功",

	----------------------符石购买项目---------------------------
	[eBGS_Success] = "购买成功",
	[eBGS_NotEnougthYuanBao] = "金钱不足",
	[eBGS_FullMAX] = "购买项目已满",

	----------------------碎片系统信息---------------------------
	[ePH_Success] = "成功",
	[ePH_PieceNotEnougth] = "碎片不足",
	[ePH_HadHero] = "已拥有该英雄",
	[ePH_CantMerge] = "不可合成",
	[ePH_HeroTypeErr] = "英雄类型错误",
	[ePH_NoSplitTarget] = "没找到分解对象",
	[ePH_CantSplit] = "不可分解",
	[ePH_SplitTargetLock] = "分解对象处于保护状态",

	-------------------------军团操作信息--------------------
	[eGUILD_CreateSuccess] = "成功",
	[eGUILD_NoenoughGold] = "金钱不足",
	[eGUILD_NoenoughYuanBao] = "元宝不足",
	[eGUILD_CreateFalse] = "创建失败",
	[eGUILD_FindFalse] = "查找失败",
	[eGUILD_ErrorName] = "没有找到军团",
	[eGUILD_FullMember] = "军团成员已满",
	[eGUILD_Applied] = "已申请过该军团",
	[eGUILD_NoAccess] = "权限不足",
	[eGUILD_NoGuild] = "没有加入军团",
	[eGUILD_InsertFalse] = "加入军团失败",
	[eGUILD_PlayerDisConnect] = "玩家不在线",
	[eGUILD_CancelFalse] = "拒绝失败",
	[eGUILD_QuitFalse] = "退出失败",
	[eGUILD_DissError] = "解散失败",
	[eGUILD_HadGuild] = "已有军团无法创建",
	[eGUILD_CantJoin] = "已有军团无法邀请加入",
	[eGUILD_QuxiaoFalse] = "取消申请失败",
	[eGUILD_Yuanbaobuzu] = "元宝不足",

	[eGUILD_CantJingpai] = "已经出价,无法竞拍",
	[eGUILD_GetItemInfoShibai] = "获取物品信息失败",
	[eGUILD_GetItemListShibai] = "获取物品列表失败",
	[eGUILD_BuHuoNumberMax] = "今日补货次数已达上限",
	[eGUILD_BuHuoQuanXianBuZu] = "补货权限不足",
	[eGUILD_GongXunbuzu] = "竞买功勋值不足",
	[eGUILD_NoEnoughGongxun] = "出价不能低于底价",
	[eGUILD_NoItemRushRound] = "没有此商品,请重新刷新列表",
	[eGUILD_NoEnoughRenQi] = "军团资源不足",
	[eGUILD_MaxKeji] = "科技等级已达上限",
	[eGUILD_NoenoughLevel] = "等级不足",
	[eGUILD_InField] = "没有退出战场",
	[eGUILD_TaskIsEnd] = "今日任务已完成",
	[eGUILD_NoEnoughRes] = "资源数量不足以完成任务",
	[eGUILD_SetXuanyan_TaiDuan] = "宣言长度错误",
	[eGUILD_SetGonggao_TaiDuan] = "公告长度错误",
	[eGUILD_Guanzhi_Full] = "该职位人数已满",
	[eGUILD_RenMing_Succed] = "职位设置成功",
	[eGUILD_RenMing_False] = "职位设置失败",
	[eGUILD_No_FuTuan] = "没有副团长,无法转让",
	[eGUILD_ShanRang_Succed] = "转让成功",
	[eGUILD_ShanRang_False] = "转让失败",
	[eGUILD_FindMember_False] = "找不到军团成员",
	[eGUILD_Guanzhi_Error] = "错误的官职",
	[eGUILD_SendMail_Succed] = "军团邮件发送成功",
	[eGUILD_SendMail_False] = "军团邮件发送失败",

	
	----------------------抽卡信息-------------------------------
	[eDC_Success] = "成功",
	[eDC_NotEnougthGold] = "银两不足",
	[eDC_NotEnougthYuanBao] = "元宝不足",
	[eDC_NotEnougthSpace] = "武将营空间不足",

	----------------------充值信息-------------------------------
	[eBYB_Success] = "充值成功",

	----------------------符石购买项目---------------------------
	[eBGS_Success] = "购买成功",
	[eBGS_NotEnougthYuanBao] = "元宝不足",
	[eBGS_FullMAX] = "购买项目已满",

	
	-------------------------装备操作信息--------------------
	[eEquip_teamIdError] = "团队编号错误",
	[eEquip_teamPosError] = "团队位置错误",
	[eEquip_NoEquipsInfo] = "没有此装备信息",
	[eEquip_EquipsPosError] = "装备位置不对",
	[eEquip_TeamError] = "团队错误",
	[eEquip_DressFail] = "穿戴失败",
	[eEquip_DischargeFail] = "卸下失败",
	[eEquip_Full] = "装备已满",
	[eEquip_NoEnoughLv] = "等级不足,无法穿戴",
	[eEquip_LevelChaoGuoPlayer] = "超过玩家等级",
	[eEquip_NoGlod] = "银两不足",
	[eDC_NotEnougthEquipSpace] = "装备空间不足",
	[eEquip_NoEnoughYB] = "重置所需元宝不足",
	[eEquip_LevelChaoGuoPlayer] = "等级超过玩家等级",

	[eEquip_Succed] = "成功",
	[eEquip_Wearing] = "已穿戴装备无法出售",
	[eEquip_NoItem] = "材料不足",
	[eEquip_CantSmelt] = "不可洗炼",
	[eEquip_LockIdxErr] = "锁定错误的索引",
	[eEquip_SmeltNumLittle] = "洗炼属性条数少于2",

	[eEquip_StrengthenMax] = "强化等级已满",
	[eEquip_CantUnite] = "碎片不足",
	[eEquip_NoEnoughPiece] = "碎片不足",

	[eEquip_CantUpgrade] = "不能进阶",

	
	
	-------------------------活动--------------------

	[eC_NotFind] = "没有找到活动组",
	[eC_NotOpen] = "活动组没有开放",
	[eC_NotFindSub] = "没有找到活动",
	[eC_CantPlay] = "次数耗尽",
	[eC_CantBuy] = "购买次数耗尽",
	[eC_TeamError] = "战斗队伍错误",
	[eC_YuanBaoNotEnough] = "元宝不足",
	[eC_MsgTypeError] = "消息类型错误",
	[eC_SupportIdxError] = "没有此项助威",
	[eC_Supported] = "已助威",
	[eC_GoldNotEnough] = "银两不足",
	[eC_NeedNotClearCD] = "无需清除战斗CD",
	[eC_ItemNotEnough] = "道具不足",
	[eC_NotEnd] = "战斗未结束",
	[eC_IsEnd] = "攻打已结束",
	[eC_AtkCD] = "攻击CD未到",
	[eC_VigourNotEnough] = "精力不足",


	-------------------------道具--------------------
	[eIE_NoType] = "没有此类道具",
	[eIE_CantUse] = "道具不可使用",
	[eIE_CantSell] = "道具不可出售",
	[eIE_NotEnough] = "数量不足",
	[eIE_TooMuch] = "使用数量过多",
	[eIE_InRaceTime] = "战场活动时间不能使用",


	-------------------------竞技场--------------------
	[ePVP_Succed] = "成功",
	[ePVP_TargetErr] = "错误的挑战目标",
	[ePVP_CantPlay] = "挑战次数不足",
	[ePVP_BuyLimit] = "已达到购买限制（请提高VIP等级）",
	[ePVP_NoEnoughtYB] = "元宝不足",
	[ePVP_NoGoods] = "找不到指定商品",
	[ePVP_NoEnoughtSJL] = "神将令不足",
	[ePVP_TeamErr] = "队伍信息错误",



	------------------------任务相关------------------------
	[eMISSION_Success] = "成功完成任务",
	[eMISSION_False] = "完成任务失败",
	[eMISSION_ErrorID] = "错误的任务ID",
	[eMISSION_DayMissionEnd] = "日常任务已完成",

	------------------------迷宫相关------------------------
	[eMAZE_Rejoin] = "重复进入（已在迷宫中）",
	[eMAZE_VigourNotenough] = "精力不足",
	[eMAZE_Cooling] = "行动冷却中",

	------------------------兑换相关------------------------
	[eEXG_Success] = "兑换成功",
	[eEXG_NotEnougthNum] = "数量不足",
	[eEXG_False] = "购买失败",
	[eEXG_NotEnougthHeroExp] = "购买所需将魂不足",
	[eEXG_NotEnougthFreeRushNum] = "免费刷新次数不足",
	[eEXG_NotEnougthPacket] = "武将营空间不足",
	[eEXG_NotEnougthYuanBao] = "刷新元宝不足",

	----------------------副本相关-------------------------
	[eIE_TeamError] = "队伍错误",
	[eIE_LevelError] = "关卡错误",
	[eIE_CantGetPass] = "不能领取奖励",
	[eIE_NotEnougthNum] = "攻打次数不足",
	[eIE_NoEnoughtYB] = "元宝不足",
	[eIE_NoEnoughtItem] = "道具不足",

	----------------------签到相关-------------------------
	[eRI_QiandaoSucced] = "签到成功",
	[eRI_QiandaoFalse] = "不能签到",
	[eRI_BuQianSucced] = "补签成功",
	[eRI_BuQIan_NoYuanBao] = "补签元宝不足",
	[eRI_BuQianFalse] = "不能补签",
	[eRI_OutTime] = "超过活动时间",
	[eRI_NotInTime]	= "活动未开始",

	----------------------月卡相关-------------------------
	[eRI_YueKa_Lingqu_Succed] = "领取月卡成功",
	[eRI_No_Enough_LingquNum] = "领取次数不足",

	----------------------兑换相关-------------------------
	[eRI_Duihuan_Lingqu_Succed] = "兑换礼包成功",
	[eRI_Duihuan_Lingqu_False] = "兑换礼包失败",

	----------------------限时购买-------------------------
	[eXGS_BuySecced] = "成功",
	[eXGS_OutTime] = "购买时间未到",
	[eXGS_NoEnoughNumber] = "购买商品数量不足",
	[eXGS_ErrorID] = "购买商品ID错误",
	[eXGS_ErrorItemList] = "商品列表错误",
	[eXGS_OnlyBuyone] = "无法重复购买",
	[eXGS_YuanBaoBuzu] = "购买元宝不足",
	[eXGS_RushRl_NoYuanbao] = "刷新熔炼商店元宝不足",
	[eXGS_BuyItem_Succed] = "购买商品成功",
	[eXGS_FindItem_error] = "查找商品失败",
	[eXGS_Buy_No_SmeltValue] = "购买熔炼值不足",
	[eXGS_RushRl_Succed] = "刷新熔炼商店成功",


	---------------------- 雇佣系统----------------------
	[eHS_BuySecced] = "雇佣成功",
	[eHS_CantFind] = "找不到目标",
	[eHS_NotEnougthGold] = "银两不足",
	[eHS_Frozen] = "冻结状态",

	----------------------每日领取-------------------------
	[eRI_Meiri_Buji_Succed] = "领取每日补给成功",
	[eRI_Had_Lingqu] = "已经领取过了,请下次领取",
	[eRI_Lingqu_Time_Out] = "领取时间未到",


	----------------------奇遇-------------------------
	[eQY_GetSecced] = "领取成功",
	[eQY_CantFind] = "找不到目标",
	[eQY_NotEnoughtGold] = "银两不足",
	[eQY_NotEnoughtYuanBao] = "元宝不足",
	[eQY_DeleteQy] = "删除",
	[eQY_FullQiyu] = "奇遇已满,无法探索",
	[eQY_NoYuanBao] = "元宝不足,不能探索",
	[eQY_TanSuo_Succed] = "探索奇遇成功",
	[eQY_FuChou_Succed] = "复仇成功",
	[eQY_DeleteFc] = "删除复仇",


}
