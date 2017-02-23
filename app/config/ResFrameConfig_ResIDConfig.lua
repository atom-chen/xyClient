--
-- Author: lipeng
-- Date: 2015-07-09 19:36:54
-- 资源ID配置


ResIDConfig = {}

ResIDConfig.IDRange = {
	["role"] = {20000, 29999}, --角色ID范围
	["equip"] = {30000, 39999}, --装备ID范围
	["daoju"] = {40000, 49999}, --道具ID范围
	["skill"] = {50000, 59999}, --道具ID范围
}

--获取资源类型
function ResIDConfig:getResType( resID )
	for k,v in pairs(self.IDRange) do
		if resID >= v[1] and resID <= v[2] then
			return k
		end
	end

	return ""
end


--获取资源配置: 职业
function ResIDConfig:getConfig_profession( professionID )
	return ResIDConfig.configs[professionID+1000];
end

--获取资源配置: 国家
function ResIDConfig:getConfig_country( countryID )
	return ResIDConfig.configs[countryID+4000]
end

--获取资源配置: 国家
function ResIDConfig:getConfig_country1( countryID )
	return ResIDConfig.configs[countryID+4010]
end

--获取资源配置: 道具
function ResIDConfig:getConfig_daoju( daojuID )
	return ResIDConfig.configs[daojuID+40000]
end

--获取资源配置: 装备
function ResIDConfig:getConfig_equip( equipID )
	return ResIDConfig.configs[equipID+6000]
end
function ResIDConfig:getConfig_equipicon( resID )
	return ResIDConfig.configs[resID]
end

--获取资源配置: 角色
function ResIDConfig:getConfig_role( roleID )
	return ResIDConfig.configs[roleID]
end

--获取资源配置: 角色边框
function ResIDConfig:getConfig_cardframe( star )
	return ResIDConfig.configs[star+100]
end

--获取资源配置: buficon
function ResIDConfig:getConfig_bufframe( id )
	return ResIDConfig.configs[id]
end

--得到装备品级信息
function ResIDConfig:getEquipQualityInfo( quality )
	return ResIDConfig.configs[200 + quality];
end
--获取技能icon
function ResIDConfig:getConfig_skill( resID )
	return ResIDConfig.configs[resID]
end


ResIDConfig.configs = {
	--------------------------------角色边框图标-------------------------------
	[101] = {frameImage = "icon/heros_big/cardframe_white_big.png",frameImageBottom = "cardframe_white_bottom.png",zhiyeframe = "cardframe_white_zheye.png", frameImage2 = "cardframe_gray_big2.png", smallFrameImage = "icon/heros/cardframe_gray_small.png", smallFrameImageGuide = "icon/heros/cardframe_gray_small_guide.png", levelFrame = "icon/heros/cardframe_gray_small_lev.png", improveframe = "icon/heros/cardframe_gray_small_improve.png"},
	[102] = {frameImage = "icon/heros_big/cardframe_green_big.png",frameImageBottom = "cardframe_green_bottom.png",zhiyeframe = "cardframe_green_zheye.png", frameImage2 = "cardframe_green_big2.png", smallFrameImage = "icon/heros/cardframe_green_small.png", smallFrameImageGuide = "icon/heros/cardframe_green_small_guide.png", levelFrame = "icon/heros/cardframe_green_small_lev.png", improveframe = "icon/heros/cardframe_green_small_improve.png"},
	[103] = {frameImage = "icon/heros_big/cardframe_blue_big.png",frameImageBottom = "cardframe_blue_bottom.png",zhiyeframe = "cardframe_blue_zhiye.png", frameImage2 = "cardframe_blue_big2.png", smallFrameImage = "icon/heros/cardframe_blue_small.png", smallFrameImageGuide = "icon/heros/cardframe_blue_small_guide.png", levelFrame = "icon/heros/cardframe_blue_small_lev.png", improveframe = "icon/heros/cardframe_blue_small_improve.png"},
	[104] = {frameImage = "icon/heros_big/cardframe_purple_big.png",frameImageBottom = "cardframe_purple_bottom.png",zhiyeframe = "cardframe_purple_zheye.png", frameImage2 = "cardframe_purple_big2.png", smallFrameImage = "icon/heros/cardframe_purple_small.png", smallFrameImageGuide = "icon/heros/cardframe_purple_small_guide.png", levelFrame = "icon/heros/cardframe_purple_small_lev.png", improveframe = "icon/heros/cardframe_purple_small_improve.png"},
	[105] = {frameImage = "icon/heros_big/cardframe_orange_big.png",frameImageBottom = "cardframe_orange_bottom.png",zhiyeframe = "cardframe_orange_zheye.png", frameImage2 = "cardframe_orange_big2.png", smallFrameImage = "icon/heros/cardframe_orange_small.png", smallFrameImageGuide = "icon/heros/cardframe_orange_small_guide.png", levelFrame = "icon/heros/cardframe_orange_small_lev.png", improveframe = "icon/heros/cardframe_orange_small_improve.png"},
	[106] = {frameImage = "icon/heros_big/cardframe_orange_big.png",frameImageBottom = "cardframe_orange_bottom.png",zhiyeframe = "cardframe_orange_zheye.png", frameImage2 = "cardframe_orange_big2.png", smallFrameImage = "icon/heros/cardframe_red_small.png", smallFrameImageGuide = "icon/heros/cardframe_red_small_guide.png", levelFrame = "icon/heros/cardframe_orange_small_lev.png", improveframe = "icon/heros/cardframe_orange_small_improve.png"},
	
	--------------------------------装备品级信息-------------------------------
	[201] = {des = "白装" ,frameImage = "",color = cc.c3b(170, 170, 170)},
	[202] = {des = "绿装" ,frameImage = "",color = cc.c3b(12, 255, 74)},
	[203] = {des = "蓝装" ,frameImage = "",color = cc.c3b(12, 108, 255)},
	[204] = {des = "紫装" ,frameImage = "",color = cc.c3b(223, 12, 255)},
	[205] = {des = "橙装" ,frameImage = "",color = cc.c3b(255, 158, 12)},
	[206] = {des = "橙装" ,frameImage = "",color = cc.c3b(255, 12, 15)},

	--------------------------------职业边框图标-------------------------------
	[1001] = {frame = "professionframe_1.png", icon = "professionicon_1.png", bigIcon = "professionicon_1.png"},
	[1002] = {frame = "professionframe_2.png", icon = "professionicon_2.png", bigIcon = "professionicon_2.png"},
	[1003] = {frame = "professionframe_3.png", icon = "professionicon_3.png", bigIcon = "professionicon_3.png"},
	[1004] = {frame = "professionframe_4.png", icon = "professionicon_4.png", bigIcon = "professionicon_4.png"},
	[1005] = {frame = "professionframe_5.png", icon = "professionicon_5.png", bigIcon = "professionicon_5.png"},
	[1006] = {frame = "professionframe_6.png", icon = "professionicon_6.png", bigIcon = "professionicon_6.png"},

	--------------------------------一些其他图标ICon-------------------------------
	[2001] = {describe = "银两", icon = "award_icon_gold.png"},
	[2002] = {describe = "元宝", icon = "award_icon_yuanbao.png"},
	[2003] = {describe = "将魂", icon = "award_icon_jianghun.png"},
	[2004] = {describe = "神将令", icon = "award_icon_shenjiang.png"},
	[2005] = {describe = "经验", icon = "award_icon_exp.png"},
	[2006] = {describe = "士气值", icon = "award_icon_shiqi.png"},
	[2007] = {describe = "vip经验", icon = "award_icon_vipexp.png"},
	[2008] = {describe = "体力", icon = "award_icon_tili.png"},
	[2009] = {describe = "精力", icon = "award_icon_jingli.png"},
	[2010] = {describe = "万能碎片", icon = "award_icon_wanneng.png"},
	[2011] = {describe = "随机蓝色卡", icon = "award_icon_blue.png"},

	--------------------------------技能书icon-------------------------------
	[3001] = {icon = "image_jineng_pinzhi1.png"},
	[3002] = {icon = "image_jineng_pinzhi2.png"},
	[3003] = {icon = "image_jineng_pinzhi3.png"},
	[3004] = {icon = "image_jineng_pinzhi4.png"},


	--------------------------------势力icon-------------------------------
	[4001] = {icon = "icon_shili_wei.png"},
	[4002] = {icon = "icon_shili_shu.png"},
	[4003] = {icon = "icon_shili_wu.png"},
	[4004] = {icon = "icon_shili_qun.png"},

	[4011] = {icon = "icon_shili_wei1.png"},
	[4012] = {icon = "icon_shili_shu1.png"},
	[4013] = {icon = "icon_shili_wu1.png"},
	[4014] = {icon = "icon_shili_qun1.png"},

	--------------------------------buf icon-------------------------------
	[5001] = {describe = "+暴击",icon = "buf_icon_1.png"},
	[5002] = {describe = "+攻击",icon = "buf_icon_2.png"},
	[5003] = {describe = "+命中",icon = "buf_icon_3.png"},
	[5004] = {describe = "+闪避",icon = "buf_icon_4.png"},
	[5005] = {describe = "+生命",icon = "buf_icon_5.png"},
	[5006] = {describe = "+物防",icon = "buf_icon_6.png"},
	[5007] = {describe = "+法防",icon = "buf_icon_7.png"},
	[5008] = {describe = "+韧性",icon = "buf_icon_9.png"},
	[5009] = {describe = "+暴伤",icon = "buf_icon_8.png"},

	[5101] = {describe = "-暴击",icon = "bufdown_icon_1.png"},
	[5102] = {describe = "-攻击",icon = "bufdown_icon_2.png"},
	[5103] = {describe = "-命中",icon = "bufdown_icon_3.png"},
	[5104] = {describe = "-闪避",icon = "bufdown_icon_4.png"},
	[5105] = {describe = "-生命",icon = "bufdown_icon_5.png"},
	[5106] = {describe = "-物防",icon = "bufdown_icon_6.png"},
	[5107] = {describe = "-法防",icon = "bufdown_icon_7.png"},
	[5108] = {describe = "-韧性",icon = "bufdown_icon_9.png"},
	[5109] = {describe = "-暴伤",icon = "bufdown_icon_8.png"},

	-------------------------------装备大边框--------------------------------
	[6001] = {describe = "白色边框",frame = "equip_page_bg1.png"},
	[6002] = {describe = "绿色边框",frame = "equip_page_bg2.png"},
	[6003] = {describe = "蓝色边框",frame = "equip_page_bg3.png"},
	[6004] = {describe = "紫色边框",frame = "equip_page_bg4.png"},
	--------------------------------角色小图标-------------------------------
	-- 起始1000
	-- [10001] = {frameImage = "avatarframe_blue_plus.png",iconImage = "heroicon1.png",pos_x = 5 ,pos_y = 23},
	-- [10002] = {frameImage = "avatarframe_blue_plus.png",iconImage = "heroicon2.png",pos_x = 5 ,pos_y = 23},
	-- [10003] = {frameImage = "avatarframe_gold.png",iconImage = "heroicon3.png",pos_x = 5 ,pos_y = 23},
	-- [10004] = {frameImage = "avatarframe_gold_plus.png",iconImage = "heroicon4.png",pos_x = 5 ,pos_y = 23},
	-- [10005] = {frameImage = "avatarframe_purple_plus.png",iconImage = "heroicon5.png",pos_x = 5 ,pos_y = 23},

	--------------------------------角色大图标-------------------------------
	[20000]={describe = "测试人物",smelliconImage = "icon/heros/heroicon0_small.png",bigiconImage = "icon/heros_big/heroicon1_big.png",pos_x = 5 ,pos_y = 23 ,},	-- 起始20000
	[20001]={describe = "蔡文姬",smelliconImage = "icon/heros/heroicon1_small.png",bigiconImage = "icon/heros_big/heroicon1_big.png",pos_x = 5 ,pos_y = 23 ,},
	[20002]={describe = "陈宫",smelliconImage = "icon/heros/heroicon2_small.png",bigiconImage = "icon/heros_big/heroicon2_big.png",pos_x = -0 ,pos_y = 23 ,},
	[20003]={describe = "程昱",smelliconImage = "icon/heros/heroicon3_small.png",bigiconImage = "icon/heros_big/heroicon3_big.png",pos_x = 5 ,pos_y = 23 ,},
	[20004]={describe = "大乔",smelliconImage = "icon/heros/heroicon4_small.png",bigiconImage = "icon/heros_big/heroicon4_big.png",pos_x = 5 ,pos_y = 23 ,},
	[20005]={describe = "貂蝉",smelliconImage = "icon/heros/heroicon5_small.png",bigiconImage = "icon/heros_big/heroicon5_big.png",pos_x = 5 ,pos_y = 33 ,},
	[20006]={describe = "董卓",smelliconImage = "icon/heros/heroicon6_small.png",bigiconImage = "icon/heros_big/heroicon6_big.png",pos_x = 5 ,pos_y = 23 ,},
	[20007]={describe = "关银屏",smelliconImage = "icon/heros/heroicon7_small.png",bigiconImage = "icon/heros_big/heroicon7_big.png",pos_x = 5 ,pos_y = 23 ,},
	[20008]={describe = "关羽",smelliconImage = "icon/heros/heroicon8_small.png",bigiconImage = "icon/heros_big/heroicon8_big.png",pos_x = 5 ,pos_y = 23 ,},
	[20009]={describe = "郭嘉",smelliconImage = "icon/heros/heroicon9_small.png",bigiconImage = "icon/heros_big/heroicon9_big.png",pos_x = 5 ,pos_y = 23 ,},
	[20010]={describe = "黄月英",smelliconImage = "icon/heros/heroicon10_small.png",bigiconImage = "icon/heros_big/heroicon10_big.png",pos_x = 5 ,pos_y = 23 ,},
	[20011]={describe = "刘备",smelliconImage = "icon/heros/heroicon11_small.png",bigiconImage = "icon/heros_big/heroicon11_big.png",pos_x = 5 ,pos_y = 23 ,},
	[20012]={describe = "孙策",smelliconImage = "icon/heros/heroicon12_small.png",bigiconImage = "icon/heros_big/heroicon12_big.png",pos_x = 5 ,pos_y = 23 ,},
	[20013]={describe = "王异",smelliconImage = "icon/heros/heroicon13_small.png",bigiconImage = "icon/heros_big/heroicon13_big.png",pos_x = 5 ,pos_y = 23 ,},
	[20014]={describe = "文丑",smelliconImage = "icon/heros/heroicon14_small.png",bigiconImage = "icon/heros_big/heroicon14_big.png",pos_x = 5 ,pos_y = 23 ,},
	[20015]={describe = "枪兵",smelliconImage = "icon/heros/heroicon15_small.png",bigiconImage = "icon/heros_big/heroicon15_big.png",pos_x = 5 ,pos_y = 23 ,},
	[20016]={describe = "盾兵",smelliconImage = "icon/heros/heroicon16_small.png",bigiconImage = "icon/heros_big/heroicon16_big.png",pos_x = 5 ,pos_y = 23 ,},
	[20017]={describe = "弓兵",smelliconImage = "icon/heros/heroicon17_small.png",bigiconImage = "icon/heros_big/heroicon17_big.png",pos_x = 5 ,pos_y = 23 ,},
	[20018]={describe = "锤兵",smelliconImage = "icon/heros/heroicon18_small.png",bigiconImage = "icon/heros_big/heroicon18_big.png",pos_x = 5 ,pos_y = 23 ,},
	[20019]={describe = "小乔",smelliconImage = "icon/heros/heroicon19_small.png",bigiconImage = "icon/heros_big/heroicon19_big.png",pos_x = 5 ,pos_y = 23 ,},
	[20020]={describe = "辛宪英",smelliconImage = "icon/heros/heroicon20_small.png",bigiconImage = "icon/heros_big/heroicon20_big.png",pos_x = 5 ,pos_y = 23 ,},
	[20021]={describe = "徐庶",smelliconImage = "icon/heros/heroicon21_small.png",bigiconImage = "icon/heros_big/heroicon21_big.png",pos_x = 5 ,pos_y = 23 ,},
	[20022]={describe = "张角",smelliconImage = "icon/heros/heroicon22_small.png",bigiconImage = "icon/heros_big/heroicon22_big.png",pos_x = 5 ,pos_y = 23 ,},
	[20023]={describe = "甄姬",smelliconImage = "icon/heros/heroicon23_small.png",bigiconImage = "icon/heros_big/heroicon23_big.png",pos_x = 5 ,pos_y = 23 ,},
	[20024]={describe = "周瑜",smelliconImage = "icon/heros/heroicon24_small.png",bigiconImage = "icon/heros_big/heroicon24_big.png",pos_x = 5 ,pos_y = 23 ,},
	[20025]={describe = "祝融夫人",smelliconImage = "icon/heros/heroicon25_small.png",bigiconImage = "icon/heros_big/heroicon25_big.png",pos_x = 5 ,pos_y = 23 ,},
	[20026]={describe = "曹操",smelliconImage = "icon/heros/heroicon26_small.png",bigiconImage = "icon/heros_big/heroicon26_big.png",pos_x = 0 ,pos_y = 23 ,},
	[20027]={describe = "曹丕",smelliconImage = "icon/heros/heroicon27_small.png",bigiconImage = "icon/heros_big/heroicon27_big.png",pos_x = 5 ,pos_y = 23 ,},
	[20028]={describe = "曹仁",smelliconImage = "icon/heros/heroicon28_small.png",bigiconImage = "icon/heros_big/heroicon28_big.png",pos_x = 5 ,pos_y = 23 ,},
	[20029]={describe = "程普",smelliconImage = "icon/heros/heroicon29_small.png",bigiconImage = "icon/heros_big/heroicon29_big.png",pos_x = 5 ,pos_y = 23 ,},
	[20030]={describe = "程远志",smelliconImage = "icon/heros/heroicon30_small.png",bigiconImage = "icon/heros_big/heroicon30_big.png",pos_x = 5 ,pos_y = 23 ,},
	[20031]={describe = "邓艾",smelliconImage = "icon/heros/heroicon31_small.png",bigiconImage = "icon/heros_big/heroicon31_big.png",pos_x = 5 ,pos_y = 23 ,},
	[20032]={describe = "法正",smelliconImage = "icon/heros/heroicon32_small.png",bigiconImage = "icon/heros_big/heroicon32_big.png",pos_x = 5 ,pos_y = 23 ,},
	[20033]={describe = "甘夫人",smelliconImage = "icon/heros/heroicon33_small.png",bigiconImage = "icon/heros_big/heroicon33_big.png",pos_x = 5 ,pos_y = 23 ,},
	[20034]={describe = "甘宁",smelliconImage = "icon/heros/heroicon34_small.png",bigiconImage = "icon/heros_big/heroicon34_big.png",pos_x = 5 ,pos_y = 23 ,},
	[20035]={describe = "高顺",smelliconImage = "icon/heros/heroicon35_small.png",bigiconImage = "icon/heros_big/heroicon35_big.png",pos_x = 5 ,pos_y = 23 ,},
	[20036]={describe = "公孙瓒",smelliconImage = "icon/heros/heroicon36_small.png",bigiconImage = "icon/heros_big/heroicon36_big.png",pos_x = 5 ,pos_y = 23 ,},
	[20037]={describe = "管辂",smelliconImage = "icon/heros/heroicon37_small.png",bigiconImage = "icon/heros_big/heroicon37_big.png",pos_x = 5 ,pos_y = 10 ,},
	[20038]={describe = "丁奉",smelliconImage = "icon/heros/heroicon38_small.png",bigiconImage = "icon/heros_big/heroicon38_big.png",pos_x = 5 ,pos_y = 23 ,},
	[20039]={describe = "胡车儿",smelliconImage = "icon/heros/heroicon39_small.png",bigiconImage = "icon/heros_big/heroicon39_big.png",pos_x = 5 ,pos_y = 23 ,},
	[20040]={describe = "华佗",smelliconImage = "icon/heros/heroicon40_small.png",bigiconImage = "icon/heros_big/heroicon40_big.png",pos_x = 5 ,pos_y = 23 ,},
	[20041]={describe = "华雄",smelliconImage = "icon/heros/heroicon41_small.png",bigiconImage = "icon/heros_big/heroicon41_big.png",pos_x = 5 ,pos_y = 23 ,},
	[20042]={describe = "皇甫嵩",smelliconImage = "icon/heros/heroicon42_small.png",bigiconImage = "icon/heros_big/heroicon42_big.png",pos_x = 5 ,pos_y = 23 ,},
	[20043]={describe = "黄盖",smelliconImage = "icon/heros/heroicon43_small.png",bigiconImage = "icon/heros_big/heroicon43_big.png",pos_x = 5 ,pos_y = 23 ,},
	[20044]={describe = "黄忠",smelliconImage = "icon/heros/heroicon44_small.png",bigiconImage = "icon/heros_big/heroicon44_big.png",pos_x = 5 ,pos_y = 23 ,},
	[20045]={describe = "贾诩",smelliconImage = "icon/heros/heroicon45_small.png",bigiconImage = "icon/heros_big/heroicon45_big.png",pos_x = 5 ,pos_y = 23 ,},
	[20046]={describe = "沮授",smelliconImage = "icon/heros/heroicon46_small.png",bigiconImage = "icon/heros_big/heroicon46_big.png",pos_x = 5 ,pos_y = 23 ,},
	[20047]={describe = "乐进",smelliconImage = "icon/heros/heroicon47_small.png",bigiconImage = "icon/heros_big/heroicon47_big.png",pos_x = 5 ,pos_y = 23 ,},
	[20048]={describe = "李典",smelliconImage = "icon/heros/heroicon48_small.png",bigiconImage = "icon/heros_big/heroicon48_big.png",pos_x = 5 ,pos_y = 23 ,},
	[20049]={describe = "李傕",smelliconImage = "icon/heros/heroicon49_small.png",bigiconImage = "icon/heros_big/heroicon49_big.png",pos_x = 5 ,pos_y = 23 ,},
	[20050]={describe = "诸葛瞻",smelliconImage = "icon/heros/heroicon50_small.png",bigiconImage = "icon/heros_big/heroicon50_big.png",pos_x = 5 ,pos_y = 23 ,},
	[20051]={describe = "娄圭",smelliconImage = "icon/heros/heroicon51_small.png",bigiconImage = "icon/heros_big/heroicon51_big.png",pos_x = 5 ,pos_y = 23 ,},
	[20052]={describe = "鲁肃",smelliconImage = "icon/heros/heroicon52_small.png",bigiconImage = "icon/heros_big/heroicon52_big.png",pos_x = 5 ,pos_y = 23 ,},
	[20053]={describe = "吕布",smelliconImage = "icon/heros/heroicon53_small.png",bigiconImage = "icon/heros_big/heroicon53_big.png",pos_x = -2 ,pos_y = 105 ,},
	[20054]={describe = "吕玲绮",smelliconImage = "icon/heros/heroicon54_small.png",bigiconImage = "icon/heros_big/heroicon54_big.png",pos_x = 5 ,pos_y = 23 ,},
	[20055]={describe = "吕蒙",smelliconImage = "icon/heros/heroicon55_small.png",bigiconImage = "icon/heros_big/heroicon55_big.png",pos_x = 5 ,pos_y = 23 ,},
	[20056]={describe = "马超",smelliconImage = "icon/heros/heroicon56_small.png",bigiconImage = "icon/heros_big/heroicon56_big.png",pos_x = 5 ,pos_y = 23 ,},
	[20057]={describe = "马腾",smelliconImage = "icon/heros/heroicon57_small.png",bigiconImage = "icon/heros_big/heroicon57_big.png",pos_x = 5 ,pos_y = 23 ,},
	[20058]={describe = "张星彩",smelliconImage = "icon/heros/heroicon58_small.png",bigiconImage = "icon/heros_big/heroicon58_big.png",pos_x = 5 ,pos_y = 23 ,},
	[20059]={describe = "糜夫人",smelliconImage = "icon/heros/heroicon59_small.png",bigiconImage = "icon/heros_big/heroicon59_big.png",pos_x = 5 ,pos_y = 23 ,},
	[20060]={describe = "谋士幕僚",smelliconImage = "icon/heros/heroicon60_small.png",bigiconImage = "icon/heros_big/heroicon60_big.png",pos_x = 5 ,pos_y = 23 ,},
	[20061]={describe = "南华老仙",smelliconImage = "icon/heros/heroicon61_small.png",bigiconImage = "icon/heros_big/heroicon61_big.png",pos_x = 5 ,pos_y = 23 ,},
	[20062]={describe = "潘凤",smelliconImage = "icon/heros/heroicon62_small.png",bigiconImage = "icon/heros_big/heroicon62_big.png",pos_x = 5 ,pos_y = 23 ,},
	[20063]={describe = "沙摩柯",smelliconImage = "icon/heros/heroicon63_small.png",bigiconImage = "icon/heros_big/heroicon63_big.png",pos_x = 5 ,pos_y = 23 ,},
	[20064]={describe = "司马微",smelliconImage = "icon/heros/heroicon64_small.png",bigiconImage = "icon/heros_big/heroicon64_big.png",pos_x = 5 ,pos_y = 23 ,},
	[20065]={describe = "司马懿",smelliconImage = "icon/heros/heroicon65_small.png",bigiconImage = "icon/heros_big/heroicon65_big.png",pos_x = 2 ,pos_y = 85 ,},
	[20066]={describe = "孙权",smelliconImage = "icon/heros/heroicon66_small.png",bigiconImage = "icon/heros_big/heroicon66_big.png",pos_x = 5 ,pos_y = 23 ,},
	[20067]={describe = "孙尚香",smelliconImage = "icon/heros/heroicon67_small.png",bigiconImage = "icon/heros_big/heroicon67_big.png",pos_x = 5 ,pos_y = 23 ,},
	[20068]={describe = "刘禅",smelliconImage = "icon/heros/heroicon68_small.png",bigiconImage = "icon/heros_big/heroicon68_big.png",pos_x = 5 ,pos_y = 23 ,},
	[20069]={describe = "田丰",smelliconImage = "icon/heros/heroicon69_small.png",bigiconImage = "icon/heros_big/heroicon69_big.png",pos_x = 5 ,pos_y = 23 ,},
	[20070]={describe = "童渊",smelliconImage = "icon/heros/heroicon70_small.png",bigiconImage = "icon/heros_big/heroicon70_big.png",pos_x = 5 ,pos_y = 35 ,},
	[20071]={describe = "王越",smelliconImage = "icon/heros/heroicon71_small.png",bigiconImage = "icon/heros_big/heroicon71_big.png",pos_x = 5 ,pos_y = 35 ,},
	[20072]={describe = "王允",smelliconImage = "icon/heros/heroicon72_small.png",bigiconImage = "icon/heros_big/heroicon72_big.png",pos_x = 5 ,pos_y = 23 ,},
	[20073]={describe = "魏延",smelliconImage = "icon/heros/heroicon73_small.png",bigiconImage = "icon/heros_big/heroicon73_big.png",pos_x = 5 ,pos_y = 23 ,},
	[20074]={describe = "文聘",smelliconImage = "icon/heros/heroicon74_small.png",bigiconImage = "icon/heros_big/heroicon74_big.png",pos_x = 5 ,pos_y = 23 ,},
	[20075]={describe = "夏侯惇",smelliconImage = "icon/heros/heroicon75_small.png",bigiconImage = "icon/heros_big/heroicon75_big.png",pos_x = 0 ,pos_y = 23 ,},
	[20076]={describe = "夏侯渊",smelliconImage = "icon/heros/heroicon76_small.png",bigiconImage = "icon/heros_big/heroicon76_big.png",pos_x = 5 ,pos_y = 23 ,},
	[20077]={describe = "徐晃",smelliconImage = "icon/heros/heroicon77_small.png",bigiconImage = "icon/heros_big/heroicon77_big.png",pos_x = 5 ,pos_y = 88 ,},
	[20078]={describe = "许褚",smelliconImage = "icon/heros/heroicon78_small.png",bigiconImage = "icon/heros_big/heroicon78_big.png",pos_x = 5 ,pos_y = 23 ,},
	[20079]={describe = "荀攸",smelliconImage = "icon/heros/heroicon79_small.png",bigiconImage = "icon/heros_big/heroicon79_big.png",pos_x = 5 ,pos_y = 23 ,},
	[20080]={describe = "荀彧",smelliconImage = "icon/heros/heroicon80_small.png",bigiconImage = "icon/heros_big/heroicon80_big.png",pos_x = 5 ,pos_y = 23 ,},
	[20081]={describe = "严颜",smelliconImage = "icon/heros/heroicon81_small.png",bigiconImage = "icon/heros_big/heroicon81_big.png",pos_x = 5 ,pos_y = 23 ,},
	[20082]={describe = "颜良",smelliconImage = "icon/heros/heroicon82_small.png",bigiconImage = "icon/heros_big/heroicon82_big.png",pos_x = 5 ,pos_y = 23 ,},
	[20083]={describe = "于吉",smelliconImage = "icon/heros/heroicon83_small.png",bigiconImage = "icon/heros_big/heroicon83_big.png",pos_x = 5 ,pos_y = 23 ,},
	[20084]={describe = "于禁",smelliconImage = "icon/heros/heroicon84_small.png",bigiconImage = "icon/heros_big/heroicon84_big.png",pos_x = 5 ,pos_y = 23 ,},
	[20085]={describe = "袁绍",smelliconImage = "icon/heros/heroicon85_small.png",bigiconImage = "icon/heros_big/heroicon85_big.png",pos_x = 5 ,pos_y = 23 ,},
	[20086]={describe = "袁术",smelliconImage = "icon/heros/heroicon86_small.png",bigiconImage = "icon/heros_big/heroicon86_big.png",pos_x = 5 ,pos_y = 23 ,},
	[20087]={describe = "张宝",smelliconImage = "icon/heros/heroicon87_small.png",bigiconImage = "icon/heros_big/heroicon87_big.png",pos_x = 5 ,pos_y = 23 ,},
	[20088]={describe = "张春华",smelliconImage = "icon/heros/heroicon88_small.png",bigiconImage = "icon/heros_big/heroicon88_big.png",pos_x = 5 ,pos_y = 23 ,},
	[20089]={describe = "张飞",smelliconImage = "icon/heros/heroicon89_small.png",bigiconImage = "icon/heros_big/heroicon89_big.png",pos_x = 5 ,pos_y = 88 ,},
	[20090]={describe = "张梁",smelliconImage = "icon/heros/heroicon90_small.png",bigiconImage = "icon/heros_big/heroicon90_big.png",pos_x = 5 ,pos_y = 23 ,},
	[20091]={describe = "张辽",smelliconImage = "icon/heros/heroicon91_small.png",bigiconImage = "icon/heros_big/heroicon91_big.png",pos_x = 5 ,pos_y = 23 ,},
	[20092]={describe = "张曼成",smelliconImage = "icon/heros/heroicon92_small.png",bigiconImage = "icon/heros_big/heroicon92_big.png",pos_x = 5 ,pos_y = 23 ,},
	[20093]={describe = "张郃",smelliconImage = "icon/heros/heroicon93_small.png",bigiconImage = "icon/heros_big/heroicon93_big.png",pos_x = 5 ,pos_y = 23 ,},
	[20094]={describe = "张绣",smelliconImage = "icon/heros/heroicon94_small.png",bigiconImage = "icon/heros_big/heroicon94_big.png",pos_x = 5 ,pos_y = 23 ,},
	[20095]={describe = "张昭",smelliconImage = "icon/heros/heroicon95_small.png",bigiconImage = "icon/heros_big/heroicon95_big.png",pos_x = 5 ,pos_y = 23 ,},
	[20096]={describe = "赵云",smelliconImage = "icon/heros/heroicon96_small.png",bigiconImage = "icon/heros_big/heroicon96_big.png",pos_x = -8 ,pos_y = 90 ,},
	[20097]={describe = "钟繇",smelliconImage = "icon/heros/heroicon97_small.png",bigiconImage = "icon/heros_big/heroicon97_big.png",pos_x = 5 ,pos_y = 23 ,},
	[20098]={describe = "周仓",smelliconImage = "icon/heros/heroicon98_small.png",bigiconImage = "icon/heros_big/heroicon98_big.png",pos_x = 5 ,pos_y = 23 ,},
	[20099]={describe = "周泰",smelliconImage = "icon/heros/heroicon99_small.png",bigiconImage = "icon/heros_big/heroicon99_big.png",pos_x = 5 ,pos_y = 23 ,},
	[20100]={describe = "诸葛亮",smelliconImage = "icon/heros/heroicon100_small.png",bigiconImage = "icon/heros_big/heroicon100_big.png",pos_x = 1 ,pos_y = 80 ,},
	[20101]={describe = "左慈",smelliconImage = "icon/heros/heroicon101_small.png",bigiconImage = "icon/heros_big/heroicon101_big.png",pos_x = -15 ,pos_y = 23 ,},
	[20102]={describe = "太史慈",smelliconImage = "icon/heros/heroicon102_small.png",bigiconImage = "icon/heros_big/heroicon102_big.png",pos_x = 5 ,pos_y = 23 ,},
	[20103]={describe = "庞德",smelliconImage = "icon/heros/heroicon103_small.png",bigiconImage = "icon/heros_big/heroicon103_big.png",pos_x = -6 ,pos_y = 11 ,},
	[20104]={describe = "廖化",smelliconImage = "icon/heros/heroicon104_small.png",bigiconImage = "icon/heros_big/heroicon104_big.png",pos_x = 5 ,pos_y = 23 ,},
	[20105]={describe = "黄祖",smelliconImage = "icon/heros/heroicon105_small.png",bigiconImage = "icon/heros_big/heroicon105_big.png",pos_x = 5 ,pos_y = 23 ,},
	[20106]={describe = "刘繇",smelliconImage = "icon/heros/heroicon106_small.png",bigiconImage = "icon/heros_big/heroicon106_big.png",pos_x = 5 ,pos_y = 23 ,},
	[20107]={describe = "严白虎",smelliconImage = "icon/heros/heroicon107_small.png",bigiconImage = "icon/heros_big/heroicon107_big.png",pos_x = 5 ,pos_y = 23 ,},
	[20108]={describe = "王朗",smelliconImage = "icon/heros/heroicon108_small.png",bigiconImage = "icon/heros_big/heroicon108_big.png",pos_x = 5 ,pos_y = 23 ,},
	[20109]={describe = "陈泰",smelliconImage = "icon/heros/heroicon109_small.png",bigiconImage = "icon/heros_big/heroicon109_big.png",pos_x = 5 ,pos_y = 23 ,},
	[20110]={describe = "陈纪",smelliconImage = "icon/heros/heroicon110_small.png",bigiconImage = "icon/heros_big/heroicon110_big.png",pos_x = 5 ,pos_y = 23 ,},
	[20111]={describe = "钟会",smelliconImage = "icon/heros/heroicon111_small.png",bigiconImage = "icon/heros_big/heroicon111_big.png",pos_x = -15 ,pos_y = 22 ,},
	[20112]={describe = "杨奉",smelliconImage = "icon/heros/heroicon112_small.png",bigiconImage = "icon/heros_big/heroicon112_big.png",pos_x = 5 ,pos_y = 23 ,},
	[20113]={describe = "陆抗",smelliconImage = "icon/heros/heroicon113_small.png",bigiconImage = "icon/heros_big/heroicon113_big.png",pos_x = 5 ,pos_y = 23 ,},
	[20114]={describe = "姜维",smelliconImage = "icon/heros/heroicon114_small.png",bigiconImage = "icon/heros_big/heroicon114_big.png",pos_x = 5 ,pos_y = 23 ,},
	[20115]={describe = "诸葛瑾",smelliconImage = "icon/heros/heroicon115_small.png",bigiconImage = "icon/heros_big/heroicon115_big.png",pos_x = 5 ,pos_y = 23 ,},
	[20116]={describe = "陆逊",smelliconImage = "icon/heros/heroicon116_small.png",bigiconImage = "icon/heros_big/heroicon116_big.png",pos_x = 5 ,pos_y = 23 ,},
	[20117]={describe = "马谡",smelliconImage = "icon/heros/heroicon117_small.png",bigiconImage = "icon/heros_big/heroicon117_big.png",pos_x = 5 ,pos_y = 23 ,},
	[20118]={describe = "侯选",smelliconImage = "icon/heros/heroicon118_small.png",bigiconImage = "icon/heros_big/heroicon118_big.png",pos_x = 5 ,pos_y = 23 ,},
	[20119]={describe = "韩遂",smelliconImage = "icon/heros/heroicon119_small.png",bigiconImage = "icon/heros_big/heroicon119_big.png",pos_x = 5 ,pos_y = 23 ,},
	[20120]={describe = "郭汜",smelliconImage = "icon/heros/heroicon120_small.png",bigiconImage = "icon/heros_big/heroicon120_big.png",pos_x = 5 ,pos_y = 23 ,},
	[20121]={describe = "孟获",smelliconImage = "icon/heros/heroicon121_small.png",bigiconImage = "icon/heros_big/heroicon121_big.png",pos_x = 5 ,pos_y = 23 ,},
	[20122]={describe = "王双",smelliconImage = "icon/heros/heroicon122_small.png",bigiconImage = "icon/heros_big/heroicon122_big.png",pos_x = 5 ,pos_y = 23 ,},
	[20123]={describe = "医师幕僚",smelliconImage = "icon/heros/heroicon123_small.png",bigiconImage = "icon/heros_big/heroicon123_big.png",pos_x = 5 ,pos_y = 23 ,},
	[20124]={describe = "虎豹骑",smelliconImage = "icon/heros/heroicon124_small.png",bigiconImage = "icon/heros_big/heroicon124_big.png",pos_x = 5 ,pos_y = 23 ,},
	[20125]={describe = "蛮族勇士",smelliconImage = "icon/heros/heroicon125_small.png",bigiconImage = "icon/heros_big/heroicon125_big.png",pos_x = 5 ,pos_y = 23 ,},	
	[20126]={describe = "刺客",smelliconImage = "icon/heros/heroicon126_small.png",bigiconImage = "icon/heros_big/heroicon126_big.png",pos_x = 5 ,pos_y = 23 ,},	
	[20127]={describe = "歌女",smelliconImage = "icon/heros/heroicon127_small.png",bigiconImage = "icon/heros_big/heroicon127_big.png",pos_x = 5 ,pos_y = 23 ,},	
	[20128]={describe = "持剑侍婢",smelliconImage = "icon/heros/heroicon128_small.png",bigiconImage = "icon/heros_big/heroicon128_big.png",pos_x = 5 ,pos_y = 23 ,},	
	[20129]={describe = "恶狼",smelliconImage = "icon/heros/heroicon129_small.png",bigiconImage = "icon/heros_big/heroicon129_big.png",pos_x = 0 ,pos_y = 23 ,},	
	[20130]={describe = "狂熊",smelliconImage = "icon/heros/heroicon130_small.png",bigiconImage = "icon/heros_big/heroicon130_big.png",pos_x = 0 ,pos_y = 23 ,},
	[20131]={describe = "虎王",smelliconImage = "icon/heros/heroicon131_small.png",bigiconImage = "icon/heros_big/heroicon131_big.png",pos_x = 0 ,pos_y = 23 ,},
	[20132]={describe = "兵马俑1",smelliconImage = "icon/heros/heroicon132_small.png",bigiconImage = "icon/heros_big/heroicon132_big.png",pos_x = 5 ,pos_y = 23 ,},
	[20133]={describe = "兵马俑2",smelliconImage = "icon/heros/heroicon133_small.png",bigiconImage = "icon/heros_big/heroicon133_big.png",pos_x = 5 ,pos_y = 23 ,},
	[20134]={describe = "兵马俑5",smelliconImage = "icon/heros/heroicon134_small.png",bigiconImage = "icon/heros_big/heroicon134_big.png",pos_x = 5 ,pos_y = 23 ,},
	[20135]={describe = "劳工",smelliconImage = "icon/heros/heroicon135_small.png",bigiconImage = "icon/heros_big/heroicon135_big.png",pos_x = 5 ,pos_y = 23 ,},
	[20136]={describe = "劳工2",smelliconImage = "icon/heros/heroicon136_small.png",bigiconImage = "icon/heros_big/heroicon136_big.png",pos_x = 5 ,pos_y = 23 ,},
	[20137]={describe = "战车1",smelliconImage = "icon/heros/heroicon137_small.png",bigiconImage = "icon/heros_big/heroicon137_big.png",pos_x = 5 ,pos_y = 23 ,},
	[20138]={describe = "战车2",smelliconImage = "icon/heros/heroicon138_small.png",bigiconImage = "icon/heros_big/heroicon138_big.png",pos_x = 5 ,pos_y = 23 ,},
	[20139]={describe = "嫪毐",smelliconImage = "icon/heros/heroicon139_small.png",bigiconImage = "icon/heros_big/heroicon139_big.png",pos_x = 5 ,pos_y = 84 ,},
	[20140]={describe = "蒙恬",smelliconImage = "icon/heros/heroicon140_small.png",bigiconImage = "icon/heros_big/heroicon140_big.png",pos_x = 5 ,pos_y = 23 ,},
	[20141]={describe = "蒙骜",smelliconImage = "icon/heros/heroicon141_small.png",bigiconImage = "icon/heros_big/heroicon141_big.png",pos_x = 5 ,pos_y = 23 ,},
	[20142]={describe = "白起",smelliconImage = "icon/heros/heroicon142_small.png",bigiconImage = "icon/heros_big/heroicon142_big.png",pos_x = 5 ,pos_y = 84 ,},
	[20143]={describe = "秦始皇",smelliconImage = "icon/heros/heroicon143_small.png",bigiconImage = "icon/heros_big/heroicon143_big.png",pos_x = 5 ,pos_y = 23 ,},
	[20144]={describe = "盗墓贼",smelliconImage = "icon/heros/heroicon144_small.png",bigiconImage = "icon/heros_big/heroicon144_big.png",pos_x = 5 ,pos_y = 23 ,},
	[20145]={describe = "盗墓贼首领",smelliconImage = "icon/heros/heroicon145_small.png",bigiconImage = "icon/heros_big/heroicon145_big.png",pos_x = -6 ,pos_y = 84 ,},
	[20146]={describe = "大刀",smelliconImage = "icon/heros/heroicon146_small.png",bigiconImage = "icon/heros_big/heroicon146_big.png",pos_x = 14 ,pos_y = 87 ,},
	[20147]={describe = "斗笠",smelliconImage = "icon/heros/heroicon147_small.png",bigiconImage = "icon/heros_big/heroicon147_big.png",pos_x = 1 ,pos_y = 91 ,},
	[20148]={describe = "孙坚",smelliconImage = "icon/heros/heroicon148_small.png",bigiconImage = "icon/heros_big/heroicon148_big.png",pos_x = -4 ,pos_y = 80 ,},
	[20149]={describe = "诸葛恪",smelliconImage = "icon/heros/heroicon149_small.png",bigiconImage = "icon/heros_big/heroicon149_big.png",pos_x = 5 ,pos_y = 23 ,},
	[20150]={describe = "典韦",smelliconImage = "icon/heros/heroicon150_small.png",bigiconImage = "icon/heros_big/heroicon150_big.png",pos_x = 5 ,pos_y = 23 ,},
	[20151]={describe = "孙皓",smelliconImage = "icon/heros/heroicon151_small.png",bigiconImage = "icon/heros_big/heroicon151_big.png",pos_x = 5 ,pos_y = 23 ,},
	[20152]={describe = "长枪偏将2",smelliconImage = "icon/heros/heroicon152_small.png",bigiconImage = "icon/heros_big/heroicon152_big.png",pos_x = 5 ,pos_y = 23 ,},
	[20153]={describe = "朴刀偏将2",smelliconImage = "icon/heros/heroicon153_small.png",bigiconImage = "icon/heros_big/heroicon153_big.png",pos_x = 5 ,pos_y = 23 ,},
	[20154]={describe = "弓箭偏将2",smelliconImage = "icon/heros/heroicon154_small.png",bigiconImage = "icon/heros_big/heroicon154_big.png",pos_x = 5 ,pos_y = 23 ,},
	[20155]={describe = "巨锤偏将2",smelliconImage = "icon/heros/heroicon155_small.png",bigiconImage = "icon/heros_big/heroicon155_big.png",pos_x = 5 ,pos_y = 23 ,},
	[20156]={describe = "谋士幕僚2",smelliconImage = "icon/heros/heroicon156_small.png",bigiconImage = "icon/heros_big/heroicon156_big.png",pos_x = 5 ,pos_y = 23 ,},
	[20157]={describe = "医师2",smelliconImage = "icon/heros/heroicon157_small.png",bigiconImage = "icon/heros_big/heroicon157_big.png",pos_x = 5 ,pos_y = 23 ,},
	[20158]={describe = "铁骑偏将2",smelliconImage = "icon/heros/heroicon158_small.png",bigiconImage = "icon/heros_big/heroicon158_big.png",pos_x = 5 ,pos_y = 23 ,},
	[20159]={describe = "蛮族勇士2",smelliconImage = "icon/heros/heroicon159_small.png",bigiconImage = "icon/heros_big/heroicon159_big.png",pos_x = 5 ,pos_y = 23 ,},
	[20160]={describe = "刺客2",smelliconImage = "icon/heros/heroicon160_small.png",bigiconImage = "icon/heros_big/heroicon160_big.png",pos_x = 5 ,pos_y = 23 ,},
	[20161]={describe = "歌女2",smelliconImage = "icon/heros/heroicon161_small.png",bigiconImage = "icon/heros_big/heroicon161_big.png",pos_x = 5 ,pos_y = 23 ,},
	[20162]={describe = "持剑侍婢2",smelliconImage = "icon/heros/heroicon162_small.png",bigiconImage = "icon/heros_big/heroicon162_big.png",pos_x = 5 ,pos_y = 23 ,},
	[20163]={describe = "野猪",smelliconImage = "icon/heros/heroicon163_small.png",bigiconImage = "icon/heros_big/heroicon163_big.png",pos_x = 5 ,pos_y = 23 ,},
	[20164]={describe = "毒蛇",smelliconImage = "icon/heros/heroicon164_small.png",bigiconImage = "icon/heros_big/heroicon164_big.png",pos_x = 5 ,pos_y = 23 ,},
	[20165]={describe = "巨鹰",smelliconImage = "icon/heros/heroicon165_small.png",bigiconImage = "icon/heros_big/heroicon165_big.png",pos_x = 5 ,pos_y = 23 ,},
	[20166]={describe = "灰狼",smelliconImage = "icon/heros/heroicon166_small.png",bigiconImage = "icon/heros_big/heroicon166_big.png",pos_x = -5 ,pos_y = 23 ,},
	[20167]={describe = "白狼",smelliconImage = "icon/heros/heroicon167_small.png",bigiconImage = "icon/heros_big/heroicon167_big.png",pos_x = 5 ,pos_y = 23 ,},
	[20168]={describe = "黑豹",smelliconImage = "icon/heros/heroicon168_small.png",bigiconImage = "icon/heros_big/heroicon168_big.png",pos_x = 5 ,pos_y = 23 ,},
	[20169]={describe = "蝎子",smelliconImage = "icon/heros/heroicon169_small.png",bigiconImage = "icon/heros_big/heroicon169_big.png",pos_x = 5 ,pos_y = 23 ,},
	[20170]={describe = "山贼1",smelliconImage = "icon/heros/heroicon170_small.png",bigiconImage = "icon/heros_big/heroicon170_big.png",pos_x = 5 ,pos_y = 23 ,},
	[20171]={describe = "山贼2",smelliconImage = "icon/heros/heroicon171_small.png",bigiconImage = "icon/heros_big/heroicon171_big.png",pos_x = 5 ,pos_y = 23 ,},
	[20172]={describe = "山贼3",smelliconImage = "icon/heros/heroicon172_small.png",bigiconImage = "icon/heros_big/heroicon172_big.png",pos_x = 5 ,pos_y = 87 ,},
	[20173]={describe = "山贼老大",smelliconImage = "icon/heros/heroicon173_small.png",bigiconImage = "icon/heros_big/heroicon173_big.png",pos_x = 5 ,pos_y = 87 ,},
	[20174]={describe = "宝箱",smelliconImage = "icon/heros/heroicon174_small.png",bigiconImage = "icon/heros_big/heroicon174_big.png",pos_x = 5 ,pos_y = 23 ,},
	[20175]={describe = "高级宝箱",smelliconImage = "icon/heros/heroicon175_small.png",bigiconImage = "icon/heros_big/heroicon175_big.png",pos_x = 5 ,pos_y = 23 ,},
	[20176]={describe = "猎人",smelliconImage = "icon/heros/heroicon176_small.png",bigiconImage = "icon/heros_big/heroicon176_big.png",pos_x = 5 ,pos_y = 87 ,},
	[20177]={describe = "弩车",smelliconImage = "icon/heros/heroicon177_small.png",bigiconImage = "icon/heros_big/heroicon177_big.png",pos_x = 5 ,pos_y = 23 ,},
	[20178]={describe = "庞统",smelliconImage = "icon/heros/heroicon178_small.png",bigiconImage = "icon/heros_big/heroicon178_big.png",pos_x = 5 ,pos_y = 23 ,},
	[20179]={describe = "黄巾头头",smelliconImage = "icon/heros/heroicon179_small.png",bigiconImage = "icon/heros_big/heroicon179_big.png",pos_x = 5 ,pos_y = 23 ,},
	[20180]={describe = "黄巾小兵1",smelliconImage = "icon/heros/heroicon180_small.png",bigiconImage = "icon/heros_big/heroicon180_big.png",pos_x = 5 ,pos_y = 23 ,},
	[20181]={describe = "黄巾小兵2",smelliconImage = "icon/heros/heroicon181_small.png",bigiconImage = "icon/heros_big/heroicon181_big.png",pos_x = 5 ,pos_y = 88 ,},
	[20182]={describe = "黄巾车",smelliconImage = "icon/heros/heroicon182_small.png",bigiconImage = "icon/heros_big/heroicon182_big.png",pos_x = 5 ,pos_y = 23 ,},
	[20183]={describe = "马良",smelliconImage = "icon/heros/heroicon183_small.png",bigiconImage = "icon/heros_big/heroicon183_big.png",pos_x = 5 ,pos_y = 23 ,},
	[20184]={describe = "布老虎",smelliconImage = "icon/heros/heroicon184_small.png",bigiconImage = "icon/heros_big/heroicon184_big.png",pos_x = 5 ,pos_y = 23 ,},
	[20185]={describe = "黄盖2",smelliconImage = "icon/heros/heroicon184_small.png",bigiconImage = "icon/heros_big/heroicon184_big.png",pos_x = 5 ,pos_y = 23 ,},
	[20186]={describe = "张宝2",smelliconImage = "icon/heros/heroicon184_small.png",bigiconImage = "icon/heros_big/heroicon184_big.png",pos_x = 5 ,pos_y = 23 ,},
	[20187]={describe = "严颜2",smelliconImage = "icon/heros/heroicon184_small.png",bigiconImage = "icon/heros_big/heroicon184_big.png",pos_x = 5 ,pos_y = 23 ,},
	[20188]={describe = "张绣2",smelliconImage = "icon/heros/heroicon184_small.png",bigiconImage = "icon/heros_big/heroicon184_big.png",pos_x = 5 ,pos_y = 23 ,},
	[20189]={describe = "祝融2",smelliconImage = "icon/heros/heroicon184_small.png",bigiconImage = "icon/heros_big/heroicon184_big.png",pos_x = 5 ,pos_y = 23 ,},
	[20190]={describe = "黄祖2",smelliconImage = "icon/heros/heroicon184_small.png",bigiconImage = "icon/heros_big/heroicon184_big.png",pos_x = 5 ,pos_y = 23 ,},
	[20191]={describe = "于禁2",smelliconImage = "icon/heros/heroicon184_small.png",bigiconImage = "icon/heros_big/heroicon184_big.png",pos_x = 5 ,pos_y = 23 ,},
	----------------------------------------装备资源--------------------------------------------------
	[30001] = {describe = "短柄剑",icon = "icon/equip/equip_10001.png"},
	[30002] = {describe = "短缨盔",icon = "icon/equip/equip_10002.png"},
	[30003] = {describe = "短尾胸甲",icon = "icon/equip/equip_10003.png"},
	[30004] = {describe = "短尾靴",icon = "icon/equip/equip_10004.png"},
	[30005] = {describe = "精钢长剑",icon = "icon/equip/equip_10005.png"},
	[30006] = {describe = "精钢头盔",icon = "icon/equip/equip_10006.png"},
	[30007] = {describe = "精钢护甲",icon = "icon/equip/equip_10007.png"},
	[30008] = {describe = "精钢战靴",icon = "icon/equip/equip_10008.png"},
	[30009] = {describe = "寒银追风枪",icon = "icon/equip/equip_10009.png"},
	[30010] = {describe = "寒银缨盔",icon = "icon/equip/equip_10010.png"},
	[30011] = {describe = "寒银碎鳞甲",icon = "icon/equip/equip_10011.png"},
	[30012] = {describe = "寒银锻靴",icon = "icon/equip/equip_10012.png"},
	[30013] = {describe = "索命巨弩",icon = "icon/equip/equip_10013.png"},
	[30014] = {describe = "索命坚盔",icon = "icon/equip/equip_10014.png"},
	[30015] = {describe = "索命铁甲",icon = "icon/equip/equip_10015.png"},
	[30016] = {describe = "索命银靴",icon = "icon/equip/equip_10016.png"},
	[30017] = {describe = "裂骨重剑",icon = "icon/equip/equip_10017.png"},
	[30018] = {describe = "裂骨重盔",icon = "icon/equip/equip_10018.png"},
	[30019] = {describe = "裂骨重甲",icon = "icon/equip/equip_10019.png"},
	[30020] = {describe = "裂骨铁靴",icon = "icon/equip/equip_10020.png"},






	----------------------------------------道具资源--------------------------------------------------
	[40000] = {describe = "技能书1",icon = "icon/goods/icon_daoju_jinengshu1.png"},
	[40001] = {describe = "技能书2",icon = "icon/goods/icon_daoju_jinengshu2.png"},
	[40002] = {describe = "技能书3",icon = "icon/goods/icon_daoju_jinengshu3.png"},
	[40003] = {describe = "神将令",icon = "icon/goods/icon_daoju_shenjiangling.png"},
	[40004] = {describe = "强攻号角",icon = "icon/goods/icon_daoju_shijieboss.png"},
	[40005] = {describe = "求贤令",icon = "icon/goods/icon_daoju_qiuxianling.png"},
	[40006] = {describe = "扫荡符",icon = "icon/goods/icon_daoju_sandang.png"},
	[40007] = {describe = "小型体力丹",icon = "icon/goods/icon_daoju_tilidan_xiao.png"},
	[40008] = {describe = "中型体力丹",icon = "icon/goods/icon_daoju_tilidan_zhong.png"},
	[40009] = {describe = "大型体力丹",icon = "icon/goods/icon_daoju_tilidan_da.png"},
	[40010] = {describe = "巨型体力丹",icon = "icon/goods/icon_daoju_tilidan_ju.png"},
	[40011] = {describe = "小型精力丹",icon = "icon/goods/icon_daoju_jinglidan_xiao.png"},
	[40012] = {describe = "中型精力丹",icon = "icon/goods/icon_daoju_jinglidan_zhong.png"},
	[40013] = {describe = "大型精力丹",icon = "icon/goods/icon_daoju_jinglidan_da.png"},
	[40014] = {describe = "巨型精力丹",icon = "icon/goods/icon_daoju_jinglidan_ju.png"},
	[40015] = {describe = "招募令-魏",icon = "icon/goods/icon_daoju_zhaomuling_wei.png"},
	[40016] = {describe = "招募令-蜀",icon = "icon/goods/icon_daoju_zhaomuling_shu.png"},
	[40017] = {describe = "招募令-吴",icon = "icon/goods/icon_daoju_zhaomuling_wu.png"},
	[40018] = {describe = "招募令-群",icon = "icon/goods/icon_daoju_zhaomuling_qun.png"},
	[40019] = {describe = "朱雀宝箱",icon = "icon/goods/icon_daoju_baoxiang_zhuque.png"},
	[40020] = {describe = "玄武宝箱",icon = "icon/goods/icon_daoju_baoxiang_xuanwu.png"},
	[40021] = {describe = "青龙宝箱",icon = "icon/goods/icon_daoju_baoxiang_qinglong.png"},
	[40022] = {describe = "白虎宝箱",icon = "icon/goods/icon_daoju_baoxiang_baihu.png"},
	[40023] = {describe = "五星招募令",icon = "icon/goods/icon_daoju_zhaomuling_5.png"},-- **
	[40024] = {describe = "洗练符",icon = "icon/goods/icon_daoju_xilianfu.png"},
	[40025] = {describe = "虎王经验匣",icon = "icon/goods/icon_daoju_huwang.png"},
	[40026] = {describe = "小量将魂匣",icon = "icon/goods/icon_daoju_jianghun_xiao.png"},
	[40027] = {describe = "中量将魂匣",icon = "icon/goods/icon_daoju_jianghun_zhong.png"},
	[40028] = {describe = "大量将魂匣",icon = "icon/goods/icon_daoju_jianghun_da.png"},
	[40029] = {describe = "饿狼经验匣",icon = "icon/goods/icon_daoju_elang.png"},
	[40030] = {describe = "狂熊经验匣",icon = "icon/goods/icon_daoju_xiong.png"},
	[40031] = {describe = "秦币",icon = "icon/goods/icon_daoju_qingbi.png"},
	[40032] = {describe = "玉璧",icon = "icon/goods/icon_daoju_yubi.png"},
	[40033] = {describe = "青铜鼎",icon = "icon/goods/icon_daoju_qingtongding.png"},
	[40034] = {describe = "铜镜",icon = "icon/goods/icon_daoju_tongjing.png"},
	[40035] = {describe = "招募令-副将",icon = "icon/goods/icon_daoju_zhaomuling_4.png"},
	[40036] = {describe = "VIP宝箱",icon = "icon/goods/icon_daoju_xingyun.png"},
	[40037] = {describe = "真·朱雀宝箱",icon = "icon/goods/icon_daoju_zhenbaoxiang_zhuque.png"},
	[40038] = {describe = "真·玄武宝箱",icon = "icon/goods/icon_daoju_zhenbaoxiang_xuanwu.png"},
	[40039] = {describe = "真·青龙宝箱",icon = "icon/goods/icon_daoju_zhenbaoxiang_qinglong.png"},
	[40040] = {describe = "真·白虎宝箱",icon = "icon/goods/icon_daoju_zhenbaoxiang_baihu.png"},
	[40041] = {describe = "楚币",icon = "icon/goods/icon_daoju_cubi.png"},
	[40042] = {describe = "藏宝图",icon = "icon/goods/icon_daoju_cangbaotu.png"},
	[40043] = {describe = "好友宝箱",icon = "icon/goods/icon_daoju_haoyoulibao.png"},
	[40044] = {describe = "天同石",icon = "icon/goods/icon_daoju_shitou_tiantong.png"},
	[40045] = {describe = "天梁石",icon = "icon/goods/icon_daoju_shitou_tianliang.png"},
	[40046] = {describe = "太阴石",icon = "icon/goods/icon_daoju_shitou_taiyin.png"},
	[40047] = {describe = "天机石",icon = "icon/goods/icon_daoju_shitou_tianji.png"},
	[40048] = {describe = "巨门石",icon = "icon/goods/icon_daoju_shitou_jumen.png"},
	[40049] = {describe = "太阳石",icon = "icon/goods/icon_daoju_shitou_taiyang.png"},
	[40050] = {describe = "天相石",icon = "icon/goods/icon_daoju_shitou_tianxiang.png"},
	[40051] = {describe = "武曲石",icon = "icon/goods/icon_daoju_shitou_wuqu.png"},
	[40052] = {describe = "天府石",icon = "icon/goods/icon_daoju_shitou_tianfu.png"},
	[40053] = {describe = "紫微石",icon = "icon/goods/icon_daoju_shitou_ziwei.png"},
	[40054] = {describe = "贪狼石",icon = "icon/goods/icon_daoju_shitou_tanlang.png"},
	[40055] = {describe = "廉贞石",icon = "icon/goods/icon_daoju_shitou_lianzhen.png"},
	[40056] = {describe = "破军石",icon = "icon/goods/icon_daoju_shitou_pojun.png"},
	[40057] = {describe = "七杀石",icon = "icon/goods/icon_daoju_shitou_qisha.png"},
	[40058] = {describe = "招募令-4星魏",icon = "icon/goods/icon_daoju_zhaomuling_wei.png"},
	[40059] = {describe = "招募令-4星蜀",icon = "icon/goods/icon_daoju_zhaomuling_shu.png"},
	[40060] = {describe = "招募令-4星吴",icon = "icon/goods/icon_daoju_zhaomuling_wu.png"},
	[40061] = {describe = "招募令-4星群",icon = "icon/goods/icon_daoju_zhaomuling_qun.png"},
	[40062] = {describe = "征集令",icon = "icon/goods/icon_daoju_zhenjiling.png"},
	[40063] = {describe = "礼包",icon = "icon/goods/icon_daoju_dalibao.png"},
	[40064] = {describe = "物资",icon = "icon/goods/icon_daoju_wuzi.png"},
	[40065] = {describe = "铁矿石",icon = "icon/goods/icon_daoju_tiekuangshi.png"},
	[40066] = {describe = "紫色名将",icon = "icon/goods/icon_daoju_zhaomuling_4_ming.png"},
	[40067] = {describe = "金粽",icon = "icon/goods/icon_daoju_duanwu_jinzong.png"},
	[40068] = {describe = "龙舟",icon = "icon/goods/icon_daoju_duanwu_longzhou.png"},
	[40069] = {describe = "麻绳",icon = "icon/goods/icon_daoju_duanwu_masheng.png"},
	[40070] = {describe = "糯米",icon = "icon/goods/icon_daoju_duanwu_nuomi.png"},
	[40071] = {describe = "粽叶",icon = "icon/goods/icon_daoju_duanwu_zongye.png"},
	[40072] = {describe = "粽子",icon = "icon/goods/icon_daoju_duanwu_zongzi.png"},
	

	[40101] = {describe = "VIP经验奖励",icon = "icon/goods/award_icon_vipexp.png"},
	[40102] = {describe = "购买精力",icon = "icon/goods/award_icon_jingli.png"},
	[40103] = {describe = "购买体力",icon = "icon/goods/award_icon_tili.png"},
	[40104] = {describe = "好友上限",icon = "icon/goods/stone_item_5.png"},
	[40105] = {describe = "将魂奖励",icon = "icon/goods/award_icon_jianghun.png"},
	[40106] = {describe = "经验奖励",icon = "icon/goods/award_icon_exp.png"},
	[40107] = {describe = "卡牌背包",icon = "icon/goods/stone_item_3.png"},
	[40108] = {describe = "卡牌仓库",icon = "icon/goods/stone_item_7.png"},
	[40109] = {describe = "士气奖励",icon = "icon/goods/award_icon_shiqi.png"},
	[40110] = {describe = "3星随机卡牌",icon = "icon/goods/award_icon_blue.png"},
	[40111] = {describe = "4星随机卡牌",icon = "icon/goods/icon_daoju_suijikapai.png"},
	[40112] = {describe = "万能碎片",icon = "icon/goods/award_icon_wanneng.png"},
	[40113] = {describe = "银两",icon = "icon/goods/award_icon_gold.png"},
	[40114] = {describe = "邮件道具",icon = "icon/goods/mail_icon.png"},
	[40115] = {describe = "元宝",icon = "icon/goods/award_icon_yuanbao.png"},
	[40116] = {describe = "装备背包",icon = "icon/goods/stone_item_4.png"},
	[40117] = {describe = "月卡",icon = "icon/goods/stone_item_9.png"},
	[40118] = {describe = "月卡",icon = "icon/goods/stone_item_10.png"},
	[40119] = {describe = "功勋",icon = "icon/goods/award_icon_gongxun.png"},
	[40120] = {describe = "棒棒糖",icon = "icon/goods/icon_daoju_bbt.png"},
	[40121] = {describe = "糖葫芦",icon = "icon/goods/icon_daoju_thl.png"},
	[40122] = {describe = "冰棍",icon = "icon/goods/icon_daoju_bg.png"},
	[40123] = {describe = "经验池",icon = "icon/goods/icon_daoju_bg.png"},
	[40124] = {describe = "空白",icon = "icon/goods/blank.png"},
	[40125] = {describe = "熔炼值",icon = "icon/goods/blank.png"},


	[50001] = {describe = "曹操",icon = "icon/skills/caocao.png"},
	[50002] = {describe = "曹仁",icon = "icon/skills/caoren.png"},
	[50003] = {describe = "程立",icon = "icon/skills/chengli.png"},
	[50004] = {describe = "陈宫",icon = "icon/skills/chengong.png"},
	[50005] = {describe = "程普",icon = "icon/skills/chengpu.png"},
	[50006] = {describe = "程志远",icon = "icon/skills/chengzhiyuan.png"},
	[50007] = {describe = "典韦",icon = "icon/skills/dianwei.png"},
	[50008] = {describe = "貂蝉1",icon = "icon/skills/diaochan_1.png"},
	[50009] = {describe = "貂蝉2",icon = "icon/skills/diaochan_2.png"},
	[50010] = {describe = "董卓",icon = "icon/skills/dongzhuo.png"},
	[50011] = {describe = "甘宁",icon = "icon/skills/ganning.png"},
	[50012] = {describe = "高顺",icon = "icon/skills/gaoshun.png"},
	[50013] = {describe = "公孙瓒",icon = "icon/skills/gongsunzan.png"},
	[50014] = {describe = "关羽1",icon = "icon/skills/guanyu_1.png"},
	[50015] = {describe = "关羽2",icon = "icon/skills/guanyu_2.png"},
	[50016] = {describe = "关羽3",icon = "icon/skills/guanyu_3.png"},
	[50017] = {describe = "郭嘉1",icon = "icon/skills/guojia_1.png"},
	[50018] = {describe = "郭嘉2",icon = "icon/skills/guojia_2.png"},
	[50019] = {describe = "韩遂",icon = "icon/skills/hensui.png"},
	[50020] = {describe = "黄盖",icon = "icon/skills/huanggai.png"},
	[50021] = {describe = "黄埔嵩1",icon = "icon/skills/huangpugao_1.png"},
	[50022] = {describe = "黄埔嵩2",icon = "icon/skills/huangpugao_2.png"},
	[50023] = {describe = "黄月英1",icon = "icon/skills/huangyueying_1.png"},
	[50024] = {describe = "黄月英2",icon = "icon/skills/huangyueying_2.png"},
	[50025] = {describe = "黄忠1",icon = "icon/skills/huangzhong_1.png"},
	[50026] = {describe = "黄忠2",icon = "icon/skills/huangzhong_2.png"},
	[50027] = {describe = "黄祖",icon = "icon/skills/huangzu.png"},
	[50028] = {describe = "华佗1",icon = "icon/skills/huatuo_1.png"},
	[50029] = {describe = "华佗2",icon = "icon/skills/huatuo_2.png"},
	[50030] = {describe = "华雄",icon = "icon/skills/huaxiong.png"},
	[50031] = {describe = "贾诩",icon = "icon/skills/jiaxu.png"},
	[50032] = {describe = "乐进1",icon = "icon/skills/lejin_1.png"},
	[50033] = {describe = "乐进2",icon = "icon/skills/lejin_2.png"},
	[50034] = {describe = "李翠",icon = "icon/skills/lichui.png"},
	[50035] = {describe = "李典",icon = "icon/skills/lidian.png"},
	[50036] = {describe = "凌统",icon = "icon/skills/lingtong.png"},
	[50037] = {describe = "李儒1",icon = "icon/skills/liru_1.png"},
	[50038] = {describe = "李儒2",icon = "icon/skills/liru_2.png"},
	[50039] = {describe = "刘备1",icon = "icon/skills/liubei_1.png"},
	[50040] = {describe = "刘备2",icon = "icon/skills/liubei_2.png"},
	[50041] = {describe = "陆逊1",icon = "icon/skills/luxun_1.png"},
	[50042] = {describe = "吕布1",icon = "icon/skills/lvbu_1.png"},
	[50043] = {describe = "吕布2",icon = "icon/skills/lvbu_2.png"},
	[50044] = {describe = "吕蒙",icon = "icon/skills/lvmeng.png"},
	[50045] = {describe = "马超",icon = "icon/skills/machao.png"},
	[50046] = {describe = "马良1",icon = "icon/skills/maliang_1.png"},
	[50047] = {describe = "马良2",icon = "icon/skills/maliang_2.png"},
	[50048] = {describe = "马腾",icon = "icon/skills/mateng.png"},
	[50049] = {describe = "孟获",icon = "icon/skills/menghuo.png"},
	[50050] = {describe = "鲁肃",icon = "icon/skills/nusu.png"},
	[50051] = {describe = "庞德",icon = "icon/skills/pangde.png"},
	[50052] = {describe = "庞统1",icon = "icon/skills/pangtong_1.png"},
	[50053] = {describe = "庞统2",icon = "icon/skills/pangtong_2.png"},
	[50054] = {describe = "司马懿1",icon = "icon/skills/simayi_1.png"},
	[50055] = {describe = "司马懿2",icon = "icon/skills/simayi_2.png"},
	[50056] = {describe = "孙策1",icon = "icon/skills/sunce_1.png"},
	[50057] = {describe = "孙坚1",icon = "icon/skills/sunjian_1.png"},
	[50058] = {describe = "孙坚2",icon = "icon/skills/sunjian_2.png"},
	[50059] = {describe = "孙权",icon = "icon/skills/sunquan.png"},
	[50060] = {describe = "太史慈1",icon = "icon/skills/taisichi_1.png"},
	[50061] = {describe = "太史慈2",icon = "icon/skills/taisichi_2.png"},
	[50062] = {describe = "田丰",icon = "icon/skills/tianfeng.png"},
	[50063] = {describe = "王朗1",icon = "icon/skills/wanglang_1.png"},
	[50064] = {describe = "王朗2",icon = "icon/skills/wanglang_2.png"},
	[50065] = {describe = "王允",icon = "icon/skills/wangyun.png"},
	[50066] = {describe = "魏延",icon = "icon/skills/weiyan.png"},
	[50067] = {describe = "夏侯惇",icon = "icon/skills/xiahoudun.png"},
	[50068] = {describe = "夏侯渊1",icon = "icon/skills/xiahouyuan_1.png"},
	[50069] = {describe = "夏侯渊2",icon = "icon/skills/xiahouyuan_2.png"},
	[50070] = {describe = "小乔1",icon = "icon/skills/xiaoqiao_1.png"},
	[50071] = {describe = "小乔2",icon = "icon/skills/xiaoqiao_2.png"},
	[50072] = {describe = "徐晃",icon = "icon/skills/xuhuang.png"},
	[50073] = {describe = "荀彧1",icon = "icon/skills/xunyu_1.png"},
	[50074] = {describe = "荀彧2",icon = "icon/skills/xunyu_2.png"},
	[50075] = {describe = "徐庶",icon = "icon/skills/xusu.png"},
	[50076] = {describe = "许猪1",icon = "icon/skills/xuzhu_1.png"},
	[50077] = {describe = "许猪2",icon = "icon/skills/xuzhu_2.png"},
	[50078] = {describe = "颜良",icon = "icon/skills/yanliang.png"},
	[50079] = {describe = "严颜1",icon = "icon/skills/yanyan_1.png"},
	[50080] = {describe = "严颜2",icon = "icon/skills/yanyan_2.png"},
	[50081] = {describe = "袁绍",icon = "icon/skills/yuanshao.png"},
	[50082] = {describe = "袁术",icon = "icon/skills/yuanshu_1.png"},
	[50083] = {describe = "袁术",icon = "icon/skills/yuanshu_2.png"},
	[50084] = {describe = "于禁",icon = "icon/skills/yujin.png"},
	[50085] = {describe = "张宝1",icon = "icon/skills/zhangbao_1.png"},
	[50086] = {describe = "张宝2",icon = "icon/skills/zhangbao_2.png"},
	[50087] = {describe = "张飞",icon = "icon/skills/zhangfei.png"},
	[50088] = {describe = "张颌",icon = "icon/skills/zhanghe.png"},
	[50089] = {describe = "张角1",icon = "icon/skills/zhangjiao_1.png"},
	[50090] = {describe = "张角2",icon = "icon/skills/zhangjiao_2.png"},
	[50091] = {describe = "张角3",icon = "icon/skills/zhangjiao_3.png"},
	[50092] = {describe = "张良",icon = "icon/skills/zhangliang.png"},
	[50093] = {describe = "张辽",icon = "icon/skills/zhangliao.png"},
	[50094] = {describe = "张曼成",icon = "icon/skills/zhangmancheng.png"},
	[50095] = {describe = "张秀",icon = "icon/skills/zhangxiu.png"},
	[50096] = {describe = "张昭1",icon = "icon/skills/zhangzhao_1.png"},
	[50097] = {describe = "张昭2",icon = "icon/skills/zhangzhao_2.png"},
	[50098] = {describe = "赵云",icon = "icon/skills/zhaoyun.png"},
	[50099] = {describe = "周泰",icon = "icon/skills/zhoutai.png"},
	[50100] = {describe = "周瑜1",icon = "icon/skills/zhouyu_1.png"},
	[50101] = {describe = "周瑜2",icon = "icon/skills/zhouyu_2.png"},
	[50102] = {describe = "周瑜3",icon = "icon/skills/zhouyu_3.png"},
	[50103] = {describe = "周瑜4",icon = "icon/skills/zhouyu_4.png"},
	[50104] = {describe = "诸葛亮1",icon = "icon/skills/zhugeliang_1.png"},
	[50105] = {describe = "诸葛亮2",icon = "icon/skills/zhugeliang_2.png"},

}

