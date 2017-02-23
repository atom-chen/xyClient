--
-- Author: Li Yang
-- Date: 2014-03-18 17:43:26
-- 前端一些资源帧数据配置文件

import(".ResFrameConfig_ResIDConfig")

--得到资源后缀名
function getResSuffixById( restype )
	if restype == "jpg" then
		return ".jpg";
	end
	return ".png";
end

--[[资源配置文件主要用于销毁使用
	动画名称
		restype 资源类型(list , png ,ExportJson ,jpg)
		respath 路径
		res 资源
		animation_name 动画名称
]]
ResConfig = {

	["ui_image/logineffect_0/logineffect_0.ExportJson"] = {
		restype = "ExportJson",
		respath = "ui_image/logineffect_0/",
		res = {"logineffect_00","logineffect_01","logineffect_02","logineffect_03","logineffect_04",
		"logineffect_05","logineffect_06","logineffect_07","logineffect_07","logineffect_08",},
	},

	["ui_image/ui_effect/effect_login_title.ExportJson"] = {
		restype = "ExportJson",
		respath = "ui_image/ui_effect/",
		res = {"effect_login_title",},
	},

	["ui_image/ui_effect/logineffect_button.ExportJson"] = {
		restype = "ExportJson",
		respath = "ui_image/ui_effect/",
		res = {"effect_login_button",},
	},

	["animation/zhanyi/zhanyimark.ExportJson"] = {
		restype = "ExportJson",
		respath = "animation/zhanyi/",
		res = {"zhanyimark0",},
		animation_name = "zhanyimark",
	},
	----------------------战斗结果效果--------------------
	["animation/zhandou/battleresult_1.ExportJson"] = {
		restype = "ExportJson",
		respath = "animation/zhandou/",
		res = {"battleresult_10",},
		animation_name = "battleresult_1",
	},

	["animation/zhandou/battleresult_0.ExportJson"] = {
		restype = "ExportJson",
		respath = "animation/zhandou/",
		res = {"battleresult_00",},
		animation_name = "battleresult_0",
	},

	----------------------角色动画-------------------------
	["herores/lvbu/role_lvbu_back.ExportJson"] = {
		restype = "ExportJson",
		respath = "herores/lvbu/",
		res = {"role_lvbu_back0",},
		animation_name = "role_lvbu_back",
	},

	["herores/lvbu/role_lvbu_front.ExportJson"] = {
		restype = "ExportJson",
		respath = "herores/lvbu/",
		res = {"role_lvbu_front0",},
		animation_name = "role_lvbu_front",
	},

	--张角
	["herores/zhangjiao/f_zj_e.ExportJson"] = {
		restype = "ExportJson",
		respath = "herores/zhangjiao/",
		res = {"zj_font_e",},
		animation_name = "f_zj_e",
	},

	["herores/zhangjiao/f_zj_i.ExportJson"] = {
		restype = "ExportJson",
		respath = "herores/zhangjiao/",
		res = {"zj_font_idle",},
		animation_name = "f_zj_i",
	},

	["herores/zhangjiao/f_zj_s_0.ExportJson"] = {
		restype = "ExportJson",
		respath = "herores/zhangjiao/",
		res = {"zj_f_s_1_0","zj_f_s_1_1","zj_f_s_1_2","zj_f_s_1_4",},
		animation_name = "f_zj_s_0",
	},

	["herores/zhangjiao/f_zj_s_1.ExportJson"] = {
		restype = "ExportJson",
		respath = "herores/zhangjiao/",
		res = {"zj_f_s_2_0","zj_f_s_1_2","zj_f_s_1_4",},
		animation_name = "f_zj_s_1",
	},

	["herores/zhangjiao/zj_1001.ExportJson"] = {
		restype = "ExportJson",
		respath = "herores/zhangjiao/",
		res = {"zj_1001",},
		animation_name = "zj_1001",
	},

	--关羽
	["herores/guanyu/f_gy_e.ExportJson"] = {
		restype = "ExportJson",
		respath = "herores/guanyu/",
		res = {"f_gy_e",},
		animation_name = "f_gy_e",
	},

	["herores/guanyu/f_gy_i.ExportJson"] = {
		restype = "ExportJson",
		respath = "herores/guanyu/",
		res = {"f_gy_i",},
		animation_name = "f_gy_i",
	},

	["herores/guanyu/f_gy_s_1_0.ExportJson"] = {
		restype = "ExportJson",
		respath = "herores/guanyu/",
		res = {"gy_f_s_1_0","gy_f_s_1_1","gy_f_s_1_2",},
		animation_name = "f_gy_s_1_0",
	},

	["herores/guanyu/f_gy_s_2_0.ExportJson"] = {
		restype = "ExportJson",
		respath = "herores/guanyu/",
		res = {"gy_f_s_2_0","gy_f_s_2_1","gy_f_s_2_2","gy_f_s_2_3",},
		animation_name = "f_gy_s_2_0",
	},

	["herores/guanyu/b_gy_e.ExportJson"] = {
		restype = "ExportJson",
		respath = "herores/guanyu/",
		res = {"b_gy_e",},
		animation_name = "b_gy_e",
	},

	["herores/guanyu/b_gy_i.ExportJson"] = {
		restype = "ExportJson",
		respath = "herores/guanyu/",
		res = {"b_gy_i",},
		animation_name = "b_gy_i",
	},

	["herores/guanyu/b_gy_s_1_0.ExportJson"] = {
		restype = "ExportJson",
		respath = "herores/guanyu/",
		res = {"b_gy_s_1_0","b_gy_s_1_1","b_gy_s_1_2",},
		animation_name = "b_gy_s_1_0",
	},

	["herores/guanyu/b_gy_s_2_0.ExportJson"] = {
		restype = "ExportJson",
		respath = "herores/guanyu/",
		res = {"b_gy_2_0","b_gy_2_1","b_gy_2_2","gy_f_s_2_3",},
		animation_name = "b_gy_s_2_0",
	},

	--周瑜
	["herores/zhouyu/f_zy_e.ExportJson"] = {
		restype = "ExportJson",
		respath = "herores/zhouyu/",
		res = {"f_zy_e","f_zy_e_1","f_zy_e_2","f_zy_e_3",},
		animation_name = "f_zy_e",
	},

	["herores/zhouyu/f_zy_e_1.ExportJson"] = {
		restype = "ExportJson",
		respath = "herores/zhouyu/",
		res = {"f_zy_e_4",},
		animation_name = "f_zy_e_1",
	},

	["herores/zhouyu/f_zy_i.ExportJson"] = {
		restype = "ExportJson",
		respath = "herores/zhouyu/",
		res = {"f_zy_i",},
		animation_name = "f_zy_i",
	},

	["herores/zhouyu/f_zy_s_1_0.ExportJson"] = {
		restype = "ExportJson",
		respath = "herores/zhouyu/",
		res = {"f_zy_s_1_0_0","f_zy_s_1_0_1","f_zy_s_1_0_2","f_zy_s_1_0_3","f_zy_s_1_0_4",},
		animation_name = "f_zy_s_1_0",
	},

	["herores/zhouyu/f_zy_s_2_0.ExportJson"] = {
		restype = "ExportJson",
		respath = "herores/zhouyu/",
		res = {"f_zy_s_2_0_0","f_zy_s_2_0_1","f_zy_s_2_0_2","f_zy_s_2_0_3",},
		animation_name = "f_zy_s_2_0",
	},

	["herores/zhouyu/f_zy_s_1_1.ExportJson"] = {
		restype = "ExportJson",
		respath = "herores/zhouyu/",
		res = {"f_zy_s_1_1_0","f_zy_s_1_1_1","f_zy_s_1_1_2",},
		animation_name = "f_zy_s_1_1",
	},

	--吕布
	["herores/lvbu/f_lv_e.ExportJson"] = {
		restype = "ExportJson",
		respath = "herores/lvbu/",
		res = {"f_lv_e","f_lv_e_1","f_lv_e_2","f_lv_e_3",},
		animation_name = "f_lv_e",
	},

	["herores/lvbu/f_lv_i.ExportJson"] = {
		restype = "ExportJson",
		respath = "herores/lvbu/",
		res = {"f_lv_i",},
		animation_name = "f_lv_i",
	},

	["herores/lvbu/f_lv_s_1_0.ExportJson"] = {
		restype = "ExportJson",
		respath = "herores/lvbu/",
		res = {"f_lv_s_1_0_0","f_lv_s_1_0_1","f_lv_s_1_0_2","f_lv_s_1_0_3","f_lv_s_1_0_4","f_lv_s_1_0_5","f_lv_s_1_0_6","f_lv_s_1_0_8",},
		animation_name = "f_lv_s_1_0",
	},

	["herores/lvbu/lv_10005.ExportJson"] = {
		restype = "ExportJson",
		respath = "herores/lvbu/",
		res = {"f_lv_s_1_0_9",},
		animation_name = "lv_10005",
	},

	--夏侯渊
	["herores/xiahouyuan/f_xhy_e.ExportJson"] = {
		restype = "ExportJson",
		respath = "herores/xiahouyuan/",
		res = {"f_xhy_e_0","f_xhy_e_2",},
		animation_name = "f_xhy_e",
	},

	["herores/xiahouyuan/f_xhy_e_1.ExportJson"] = {
		restype = "ExportJson",
		respath = "herores/xiahouyuan/",
		res = {"f_xhy_e_1",},
		animation_name = "f_xhy_e_1",
	},

	["herores/xiahouyuan/f_xhy_i.ExportJson"] = {
		restype = "ExportJson",
		respath = "herores/xiahouyuan/",
		res = {"f_xhy_i",},
		animation_name = "f_xhy_i",
	},

	["herores/xiahouyuan/f_xhy_s_1_0.ExportJson"] = {
		restype = "ExportJson",
		respath = "herores/xiahouyuan/",
		res = {"f_xhy_s_1_0_0","f_xhy_s_1_0_1",},
		animation_name = "f_xhy_s_1_0",
	},

	["herores/xiahouyuan/f_xhy_s_2_0.ExportJson"] = {
		restype = "ExportJson",
		respath = "herores/xiahouyuan/",
		res = {"f_xhy_s_2_0_0","f_xhy_s_2_0_1","f_xhy_e_1","f_xhy_e_2",},
		animation_name = "f_xhy_s_2_0",
	},

	["herores/xiahouyuan/f_xhy_s_1_1.ExportJson"] = {
		restype = "ExportJson",
		respath = "herores/xiahouyuan/",
		res = {"f_xhy_s_1_1_0",},
		animation_name = "f_xhy_s_1_1",
	},

	["herores/xiahouyuan/f_xhy_s_1_2.ExportJson"] = {
		restype = "ExportJson",
		respath = "herores/xiahouyuan/",
		res = {"f_xhy_s_1_2_0",},
		animation_name = "f_xhy_s_1_2",
	},

	["herores/xiahouyuan/f_xhy_s_2_1.ExportJson"] = {
		restype = "ExportJson",
		respath = "herores/xiahouyuan/",
		res = {"f_xhy_s_2_10",},
		animation_name = "f_xhy_s_2_1",
	},

	--太史慈
	["herores/taishici/f_tsc_e.ExportJson"] = {
		restype = "ExportJson",
		respath = "herores/taishici/",
		res = {"f_tsc_e_0","f_tsc_e_2",},
		animation_name = "f_tsc_e",
	},

	["herores/taishici/f_tsc_e_1.ExportJson"] = {
		restype = "ExportJson",
		respath = "herores/taishici/",
		res = {"f_tsc_e_1",},
		animation_name = "f_tsc_e_1",
	},

	["herores/taishici/f_tsc_i.ExportJson"] = {
		restype = "ExportJson",
		respath = "herores/taishici/",
		res = {"f_tsc_i",},
		animation_name = "f_tsc_i",
	},

	["herores/taishici/f_tsc_s_1_0.ExportJson"] = {
		restype = "ExportJson",
		respath = "herores/taishici/",
		res = {"f_tsc_s_1_0_0","f_tsc_s_1_0_1",},
		animation_name = "f_tsc_s_1_0",
	},

	["herores/taishici/f_tsc_s_2_0.ExportJson"] = {
		restype = "ExportJson",
		respath = "herores/taishici/",
		res = {"f_tsc_s_2_0_0","f_tsc_s_2_0_1","f_tsc_s_1_2_0","f_tsc_s_2_1_0","f_tsc_s_2_1_1",},
		animation_name = "f_tsc_s_2_0",
	},

	

	["herores/taishici/f_tsc_s_1_1.ExportJson"] = {
		restype = "ExportJson",
		respath = "herores/taishici/",
		res = {"f_tsc_s_1_1_0",},
		animation_name = "f_tsc_s_1_1",
	},

	["herores/taishici/f_tsc_s_1_2.ExportJson"] = {
		restype = "ExportJson",
		respath = "herores/taishici/",
		res = {"f_tsc_s_1_2_0",},
		animation_name = "f_tsc_s_1_2",
	},

	--徐庶
	["herores/xushu/f_xs_e.ExportJson"] = {
		restype = "ExportJson",
		respath = "herores/xushu/",
		res = {"f_xs_e","f_xs_e_2","f_xs_e_3","f_xs_e0","f_xs_e1"},
		animation_name = "f_xs_e",
	},

	["herores/xushu/f_xs_e_1.ExportJson"] = {
		restype = "ExportJson",
		respath = "herores/xushu/",
		res = {"f_xs_e_1",},
		animation_name = "f_xs_e_1",
	},

	["herores/xushu/f_xs_i.ExportJson"] = {
		restype = "ExportJson",
		respath = "herores/xushu/",
		res = {"f_xs_i",},
		animation_name = "f_xs_i",
	},

	["herores/xushu/f_xs_s_1_0.ExportJson"] = {
		restype = "ExportJson",
		respath = "herores/xushu/",
		res = {"f_xs_s_1_0_0","f_xs_s_1_0_1","f_xs_s_1_0_2",},
		animation_name = "f_xs_s_1_0",
	},

	["herores/xushu/f_xs_s_1_1.ExportJson"] = {
		restype = "ExportJson",
		respath = "herores/xushu/",
		res = {"f_xs_s_1_1",},
		animation_name = "f_xs_s_1_1",
	},

	["herores/xushu/xs_1001.ExportJson"] = {
		restype = "ExportJson",
		respath = "herores/xushu/",
		res = {"xs_1001",},
		animation_name = "xs_1001",
	},

	--大桥
	["herores/daqiao/f_dq_e.ExportJson"] = {
		restype = "ExportJson",
		respath = "herores/daqiao/",
		res = {"f_dq_e","f_dq_e_1","f_dq_e_4"},
		animation_name = "f_dq_e",
	},

	["herores/daqiao/f_dq_e_1.ExportJson"] = {
		restype = "ExportJson",
		respath = "herores/daqiao/",
		res = {"f_dq_e_2","f_dq_e_3",},
		animation_name = "f_dq_e_1",
	},

	["herores/daqiao/f_dq_i.ExportJson"] = {
		restype = "ExportJson",
		respath = "herores/daqiao/",
		res = {"f_dq_i",},
		animation_name = "f_dq_i",
	},

	["herores/daqiao/f_dq_s_1_0.ExportJson"] = {
		restype = "ExportJson",
		respath = "herores/daqiao/",
		res = {"f_dq_s_1_0_0","f_dq_s_1_0_1","f_dq_s_1_0_2","f_dq_s_1_0_3"},
		animation_name = "f_dq_s_1_0",
	},

	["herores/daqiao/f_dq_s_1_1.ExportJson"] = {
		restype = "ExportJson",
		respath = "herores/daqiao/",
		res = {"f_dq_s_1_1_2",},
		animation_name = "f_dq_s_1_1",
	},

	["herores/daqiao/f_dq_s_1_2.ExportJson"] = {
		restype = "ExportJson",
		respath = "herores/daqiao/",
		res = {"f_dq_s_1_1_0","f_dq_s_1_1_1"},
		animation_name = "f_dq_s_1_2",
	},

	["herores/daqiao/f_dq_s_2.ExportJson"] = {
		restype = "ExportJson",
		respath = "herores/daqiao/",
		res = {"f_dq_s_2_0_0","f_dq_s_2_0_1","f_dq_s_2_0_2",},
		animation_name = "f_dq_s_2",
	},

	--法正
	["herores/fazheng/f_fz_e.ExportJson"] = {
		restype = "ExportJson",
		respath = "herores/fazheng/",
		res = {"f_fz_e_0","f_fz_e_1","f_fz_e_2"},
		animation_name = "f_fz_e",
	},

	["herores/fazheng/f_fz_i.ExportJson"] = {
		restype = "ExportJson",
		respath = "herores/fazheng/",
		res = {"f_fz_i",},
		animation_name = "f_fz_i",
	},

	["herores/fazheng/f_fz_s_1.ExportJson"] = {
		restype = "ExportJson",
		respath = "herores/fazheng/",
		res = {"f_fz_s_1_0_0","f_fz_s_1_0_1","f_fz_s_1_0_2","f_fz_s_1_0_3","f_fz_s_1_0_4","f_fz_s_1_0_5"},
		animation_name = "f_fz_s_1",
	},

	["herores/fazheng/f_fz_s_2_0.ExportJson"] = {
		restype = "ExportJson",
		respath = "herores/fazheng/",
		res = {"f_fz_s_2_0_0","f_fz_s_2_0_1","f_fz_s_2_0_2",},
		animation_name = "f_fz_s_2_0",
	},

	["herores/fazheng/f_fz_s_2_1.ExportJson"] = {
		restype = "ExportJson",
		respath = "herores/fazheng/",
		res = {"f_fz_s_2_1_0","f_fz_s_2_1_1","f_fz_s_2_1_2"},
		animation_name = "f_fz_s_2_1",
	},

	--黄月英
	["herores/huangyueying/f_hyy_e.ExportJson"] = {
		restype = "ExportJson",
		respath = "herores/huangyueying/",
		res = {"hyy_font_e","hyy_font_e_2"},
		animation_name = "f_hyy_e",
	},

	["herores/huangyueying/f_hyy_e_1.ExportJson"] = {
		restype = "ExportJson",
		respath = "herores/huangyueying/",
		res = {"hyy_font_e_1",},
		animation_name = "f_hyy_e_1",
	},

	["herores/huangyueying/f_hyy_i.ExportJson"] = {
		restype = "ExportJson",
		respath = "herores/huangyueying/",
		res = {"hyy_font_idle",},
		animation_name = "f_hyy_i",
	},


	["herores/huangyueying/f_hyy_s_1_1.ExportJson"] = {
		restype = "ExportJson",
		respath = "herores/huangyueying/",
		res = {"f_hyy_s_1_1_0","f_hyy_s_1_1_1","f_hyy_s_1_1_2","f_hyy_s_1_1_3",},
		animation_name = "f_hyy_s_1_1",
	},

	["herores/huangyueying/f_hyy_s_2_0.ExportJson"] = {
		restype = "ExportJson",
		respath = "herores/huangyueying/",
		res = {"f_hyy_s_2_0_0","f_hyy_s_2_0_1","f_hyy_s_2_0_2","f_hyy_s_2_0_5","f_hyy_s_2_0_6",},
		animation_name = "f_hyy_s_2_0",
	},

	["herores/huangyueying/f_hyy_s_2_1.ExportJson"] = {
		restype = "ExportJson",
		respath = "herores/huangyueying/",
		res = {"f_hyy_s_2_1"},
		animation_name = "f_hyy_s_2_1",
	},

	--张郃
	["herores/zhanghe/f_zh_e.ExportJson"] = {
		restype = "ExportJson",
		respath = "herores/zhanghe/",
		res = {"f_zh_e_0","f_zh_e_3"},
		animation_name = "f_zh_e",
	},

	["herores/zhanghe/f_zh_e_1.ExportJson"] = {
		restype = "ExportJson",
		respath = "herores/zhanghe/",
		res = {"f_zh_e_1","f_zh_e_2",},
		animation_name = "f_zh_e_1",
	},

	["herores/zhanghe/f_zh_i.ExportJson"] = {
		restype = "ExportJson",
		respath = "herores/zhanghe/",
		res = {"f_zh_i",},
		animation_name = "f_zh_i",
	},


	["herores/zhanghe/f_zh_s_1.ExportJson"] = {
		restype = "ExportJson",
		respath = "herores/zhanghe/",
		res = {"f_zh_s_1_0_0","f_zh_s_1_0_1","f_zh_s_1_0_2","f_zh_s_1_0_3","f_zh_s_1_0_4"},
		animation_name = "f_zh_s_1",
	},

	--黄盖
	["herores/huanggai/f_hg_e_0.ExportJson"] = {
		restype = "ExportJson",
		respath = "herores/huanggai/",
		res = {"f_hg_e_0","f_hg_e_2"},
		animation_name = "f_hg_e_0",
	},

	["herores/huanggai/f_hg_e_1.ExportJson"] = {
		restype = "ExportJson",
		respath = "herores/huanggai/",
		res = {"f_hg_e_1"},
		animation_name = "f_hg_e_1",
	},

	["herores/huanggai/f_hg_i.ExportJson"] = {
		restype = "ExportJson",
		respath = "herores/huanggai/",
		res = {"f_hg_i",},
		animation_name = "f_hg_i",
	},


	["herores/huanggai/f_hg_s_1_0.ExportJson"] = {
		restype = "ExportJson",
		respath = "herores/huanggai/",
		res = {"f_hg_s_1_0","f_hg_s_1_1"},
		animation_name = "f_hg_s_1_0",
	},

	["herores/huanggai/f_hg_s_1_1.ExportJson"] = {
		restype = "ExportJson",
		respath = "herores/huanggai/",
		res = {"f_hg_s_1_1_0","f_hg_s_1_1_1","f_hg_s_1_1_2"},
		animation_name = "f_hg_s_1_1",
	},

	--黄盖2
	["herores/huanggai/f_hg2_e_0.ExportJson"] = {
		restype = "ExportJson",
		respath = "herores/huanggai/",
		res = {"f_hg2_e_0","f_hg_e_2"},
		animation_name = "f_hg2_e_0",
	},

	["herores/huanggai/f_hg2_i.ExportJson"] = {
		restype = "ExportJson",
		respath = "herores/huanggai/",
		res = {"f_hg2_i",},
		animation_name = "f_hg2_i",
	},


	["herores/huanggai/f_hg2_s_1_0.ExportJson"] = {
		restype = "ExportJson",
		respath = "herores/huanggai/",
		res = {"f_hg2_s_1_0","f_hg_s_1_1"},
		animation_name = "f_hg2_s_1_0",
	},

	--甄姬
	["herores/zhenji/f_zhenji_e.ExportJson"] = {
		restype = "ExportJson",
		respath = "herores/zhenji/",
		res = {"f_zhenji_e_0","f_zhenji_e_1"},
		animation_name = "f_zhenji_e",
	},

	["herores/zhenji/f_zhenji_i.ExportJson"] = {
		restype = "ExportJson",
		respath = "herores/zhenji/",
		res = {"f_zhenji_i"},
		animation_name = "f_zhenji_i",
	},

	["herores/zhenji/f_zhenji_s_1.ExportJson"] = {
		restype = "ExportJson",
		respath = "herores/zhenji/",
		res = {"f_zhenji_s_1_0_0","f_zhenji_s_1_0_1",},
		animation_name = "f_zhenji_s_1",
	},


	["herores/zhenji/f_zhenji_s_2.ExportJson"] = {
		restype = "ExportJson",
		respath = "herores/zhenji/",
		res = {"f_zhenji_s_2_0_0","f_zhenji_s_2_0_1"},
		animation_name = "f_zhenji_s_2",
	},

	["herores/zhenji/zhenji_1001.ExportJson"] = {
		restype = "ExportJson",
		respath = "herores/zhenji/",
		res = {"zhenji_1001"},
		animation_name = "zhenji_1001",
	},

	--祝融
	["herores/zhurong/f_zr_e_1.ExportJson"] = {
		restype = "ExportJson",
		respath = "herores/zhurong/",
		res = {"f_zr_e_0","f_zr_e_1"},
		animation_name = "f_zr_e_1",
	},

	["herores/zhurong/f_zr_e_2.ExportJson"] = {
		restype = "ExportJson",
		respath = "herores/zhurong/",
		res = {"f_zr_e_2"},
		animation_name = "f_zr_e_2",
	},

	["herores/zhurong/f_zr_i.ExportJson"] = {
		restype = "ExportJson",
		respath = "herores/zhurong/",
		res = {"f_zr_i",},
		animation_name = "f_zr_i",
	},


	["herores/zhurong/f_zr_s_2_0.ExportJson"] = {
		restype = "ExportJson",
		respath = "herores/zhurong/",
		res = {"f_zr_s_2_0"},
		animation_name = "f_zr_s_2_0",
	},

	["herores/zhurong/f_zr_s_1_1.ExportJson"] = {
		restype = "ExportJson",
		respath = "herores/zhurong/",
		res = {"f_zr_s_1_1","f_zr_s_1_2"},
		animation_name = "f_zr_s_1_1",
	},

	--祝融2
	["herores/zhurong/f_zr2_e_1.ExportJson"] = {
		restype = "ExportJson",
		respath = "herores/zhurong/",
		res = {"f_zr2_e_0","f_zr_e_1"},
		animation_name = "f_zr2_e_1",
	},

	["herores/zhurong/f_zr2_i.ExportJson"] = {
		restype = "ExportJson",
		respath = "herores/zhurong/",
		res = {"f_zr2_i",},
		animation_name = "f_zr2_i",
	},


	["herores/zhurong/f_zr2_s_2_0.ExportJson"] = {
		restype = "ExportJson",
		respath = "herores/zhurong/",
		res = {"f_zr2_s_2_0"},
		animation_name = "f_zr2_s_2_0",
	},

	--吕蒙
	["herores/lvmeng/f_lm_e.ExportJson"] = {
		restype = "ExportJson",
		respath = "herores/lvmeng/",
		res = {"f_lm_e_0","f_lm_e_0","f_lm_e0"},
		animation_name = "f_lm_e",
	},

	["herores/lvmeng/f_lm_e_1.ExportJson"] = {
		restype = "ExportJson",
		respath = "herores/lvmeng/",
		res = {"f_lm_e_2"},
		animation_name = "f_lm_e_1",
	},

	["herores/lvmeng/f_lm_i.ExportJson"] = {
		restype = "ExportJson",
		respath = "herores/lvmeng/",
		res = {"f_lm_i",},
		animation_name = "f_lm_i",
	},


	["herores/lvmeng/f_lm_s_1_0.ExportJson"] = {
		restype = "ExportJson",
		respath = "herores/lvmeng/",
		res = {"f_lm_s_1_0_0","f_lm_s_1_0_1","f_lm_s_1_0_3","f_lm_s_1_0_5"},
		animation_name = "f_lm_s_1_0",
	},

	["herores/lvmeng/f_lm_s_1_1.ExportJson"] = {
		restype = "ExportJson",
		respath = "herores/lvmeng/",
		res = {"f_lm_s_1_1"},
		animation_name = "f_lm_s_1_1",
	},

	["herores/lvmeng/f_lm_s_2_0.ExportJson"] = {
		restype = "ExportJson",
		respath = "herores/lvmeng/",
		res = {"f_lm_s_2_0_0","f_lm_s_2_0_2","f_lm_s_2_1_0"},
		animation_name = "f_lm_s_2_0",
	},

	["herores/lvmeng/f_lm_s_2_1.ExportJson"] = {
		restype = "ExportJson",
		respath = "herores/lvmeng/",
		res = {"f_lm_s_1_0_5","f_lm_s_2_0_1"},
		animation_name = "f_lm_s_2_1",
	},

	--文丑
	["herores/wenchou/f_wc_e_0.ExportJson"] = {
		restype = "ExportJson",
		respath = "herores/wenchou/",
		res = {"f_wc_e_0"},
		animation_name = "f_wc_e_0",
	},

	["herores/wenchou/f_wc_e_1.ExportJson"] = {
		restype = "ExportJson",
		respath = "herores/wenchou/",
		res = {"f_wc_e_1"},
		animation_name = "f_wc_e_1",
	},

	["herores/wenchou/f_wc_i.ExportJson"] = {
		restype = "ExportJson",
		respath = "herores/wenchou/",
		res = {"f_wc_i",},
		animation_name = "f_wc_i",
	},


	["herores/wenchou/f_wc_s_1_0.ExportJson"] = {
		restype = "ExportJson",
		respath = "herores/wenchou/",
		res = {"f_wc_s_1_0_0","f_wc_s_1_0_1",},
		animation_name = "f_wc_s_1_0",
	},

	["herores/wenchou/f_wc_s_2_0.ExportJson"] = {
		restype = "ExportJson",
		respath = "herores/wenchou/",
		res = {"f_wc_s_2_0_0","f_wc_s_2_0_1","f_wc_s_2_1_0"},
		animation_name = "f_wc_s_2_0",
	},

	--张昭
	["herores/zhangzhao/f_zz_e.ExportJson"] = {
		restype = "ExportJson",
		respath = "herores/zhangzhao/",
		res = {"f_zz_e_0","f_zz_e_1"},
		animation_name = "f_zz_e",
	},

	["herores/zhangzhao/f_zz_i.ExportJson"] = {
		restype = "ExportJson",
		respath = "herores/zhangzhao/",
		res = {"f_zz_i",},
		animation_name = "f_zz_i",
	},


	["herores/zhangzhao/f_zz_s_1_0.ExportJson"] = {
		restype = "ExportJson",
		respath = "herores/zhangzhao/",
		res = {"f_zz_s_1_0_0","f_zz_s_1_0_1",},
		animation_name = "f_zz_s_1_0",
	},

	["herores/zhangzhao/f_zz_s_1_1.ExportJson"] = {
		restype = "ExportJson",
		respath = "herores/zhangzhao/",
		res = {"f_zz_s_1_1_0",},
		animation_name = "f_zz_s_1_1",
	},

	["herores/zhangzhao/f_zz_s_2.ExportJson"] = {
		restype = "ExportJson",
		respath = "herores/zhangzhao/",
		res = {"f_zz_s_2_0_0","f_zz_s_2_0_1","f_zz_s_2_0_2"},
		animation_name = "f_zz_s_2",
	},

	--田丰
	["herores/tianfeng/f_tf_e_0.ExportJson"] = {
		restype = "ExportJson",
		respath = "herores/tianfeng/",
		res = {"f_tf_e_0"},
		animation_name = "f_tf_e_0",
	},

	["herores/tianfeng/f_tf_i.ExportJson"] = {
		restype = "ExportJson",
		respath = "herores/tianfeng/",
		res = {"f_tf_i",},
		animation_name = "f_tf_i",
	},


	["herores/tianfeng/f_tf_s_1.ExportJson"] = {
		restype = "ExportJson",
		respath = "herores/tianfeng/",
		res = {"f_tf_s_1_0",},
		animation_name = "f_tf_s_1",
	},

	--孙尚香
	["herores/sunshangxiang/f_ssx_e.ExportJson"] = {
		restype = "ExportJson",
		respath = "herores/sunshangxiang/",
		res = {"f_ssx_e_0","f_ssx_e_1"},
		animation_name = "f_ssx_e",
	},

	["herores/sunshangxiang/f_ssx_i.ExportJson"] = {
		restype = "ExportJson",
		respath = "herores/sunshangxiang/",
		res = {"f_ssx_i",},
		animation_name = "f_ssx_i",
	},


	["herores/sunshangxiang/f_ssx_s_1_0.ExportJson"] = {
		restype = "ExportJson",
		respath = "herores/sunshangxiang/",
		res = {"f_ssx_s_1_0",},
		animation_name = "f_ssx_s_1_0",
	},

	["herores/sunshangxiang/f_ssx_s_1_1.ExportJson"] = {
		restype = "ExportJson",
		respath = "herores/sunshangxiang/",
		res = {"f_ssx_s_1_1_0","f_ssx_s_1_1_1"},
		animation_name = "f_ssx_s_1_1",
	},

	["herores/sunshangxiang/f_ssx_s_2_0.ExportJson"] = {
		restype = "ExportJson",
		respath = "herores/sunshangxiang/",
		res = {"f_ssx_s_2_0_0","f_ssx_s_2_0_1"},
		animation_name = "f_ssx_s_2_0",
	},

	["herores/sunshangxiang/f_ssx_s_2_1.ExportJson"] = {
		restype = "ExportJson",
		respath = "herores/sunshangxiang/",
		res = {"f_ssx_s_2_1_0","f_ssx_s_2_1_1"},
		animation_name = "f_ssx_s_2_1",
	},

	--于禁
	["herores/yujin/f_yj_e.ExportJson"] = {
		restype = "ExportJson",
		respath = "herores/yujin/",
		res = {"f_yj_e_0","f_yj_e_1"},
		animation_name = "f_yj_e",
	},

	["herores/yujin/f_yj_e_2.ExportJson"] = {
		restype = "ExportJson",
		respath = "herores/yujin/",
		res = {"f_yj_e_2",},
		animation_name = "f_yj_e_2",
	},

	["herores/yujin/f_yj_i.ExportJson"] = {
		restype = "ExportJson",
		respath = "herores/yujin/",
		res = {"f_yj_i",},
		animation_name = "f_yj_i",
	},


	["herores/yujin/f_yj_s_1.ExportJson"] = {
		restype = "ExportJson",
		respath = "herores/yujin/",
		res = {"f_yj_s_1_0_0","f_yj_s_1_0_1",},
		animation_name = "f_yj_s_1",
	},

	["herores/yujin/f_yj_s_2.ExportJson"] = {
		restype = "ExportJson",
		respath = "herores/yujin/",
		res = {"f_yj_s_2_0_0","f_yj_s_2_0_1"},
		animation_name = "f_yj_s_2",
	},

	--于禁2
	["herores/yujin/f_yj2_e.ExportJson"] = {
		restype = "ExportJson",
		respath = "herores/yujin/",
		res = {"f_yj2_e_0","f_yj_e_1"},
		animation_name = "f_yj2_e",
	},

	["herores/yujin/f_yj2_i.ExportJson"] = {
		restype = "ExportJson",
		respath = "herores/yujin/",
		res = {"f_yj2_i",},
		animation_name = "f_yj2_i",
	},


	["herores/yujin/f_yj2_s_1.ExportJson"] = {
		restype = "ExportJson",
		respath = "herores/yujin/",
		res = {"f_yj2_s_1_0_0","f_yj_s_1_0_1",},
		animation_name = "f_yj2_s_1",
	},

	["herores/yujin/f_yj2_s_2.ExportJson"] = {
		restype = "ExportJson",
		respath = "herores/yujin/",
		res = {"f_yj2_s_2_0_0","f_yj_s_2_0_1"},
		animation_name = "f_yj2_s_2",
	},

	--黄祖
	["herores/huangzu/f_hz_e.ExportJson"] = {
		restype = "ExportJson",
		respath = "herores/huangzu/",
		res = {"f_hz_e"},
		animation_name = "f_hz_e",
	},


	["herores/huangzu/f_hz_i.ExportJson"] = {
		restype = "ExportJson",
		respath = "herores/huangzu/",
		res = {"f_hz_i",},
		animation_name = "f_hz_i",
	},


	["herores/huangzu/f_hz_s_1_0.ExportJson"] = {
		restype = "ExportJson",
		respath = "herores/huangzu/",
		res = {"f_hz_s_1_0_0","f_hz_s_1_0_1",},
		animation_name = "f_hz_s_1_0",
	},

	["herores/huangzu/f_hz_s_2_0.ExportJson"] = {
		restype = "ExportJson",
		respath = "herores/huangzu/",
		res = {"f_hz_s_2_0_0","f_hz_s_2_0_1","f_hz_s_2_1_0"},
		animation_name = "f_hz_s_2_0",
	},

	--黄祖2
	["herores/huangzu/f_hz2_e.ExportJson"] = {
		restype = "ExportJson",
		respath = "herores/huangzu/",
		res = {"f_hz2_e"},
		animation_name = "f_hz2_e",
	},


	["herores/huangzu/f_hz2_i.ExportJson"] = {
		restype = "ExportJson",
		respath = "herores/huangzu/",
		res = {"f_hz2_i",},
		animation_name = "f_hz2_i",
	},


	["herores/huangzu/f_hz2_s_1_0.ExportJson"] = {
		restype = "ExportJson",
		respath = "herores/huangzu/",
		res = {"f_hz2_s_1_0_0","f_hz_s_1_0_1",},
		animation_name = "f_hz2_s_1_0",
	},

	["herores/huangzu/f_hz2_s_2_0.ExportJson"] = {
		restype = "ExportJson",
		respath = "herores/huangzu/",
		res = {"f_hz2_s_2_0_0","f_hz_s_2_0_1","f_hz_s_2_1_0"},
		animation_name = "f_hz2_s_2_0",
	},

	--陆逊
	["herores/luxun/f_lx_e.ExportJson"] = {
		restype = "ExportJson",
		respath = "herores/luxun/",
		res = {"f_lx_e_0","f_lx_e_1"},
		animation_name = "f_lx_e",
	},


	["herores/luxun/f_lx_i.ExportJson"] = {
		restype = "ExportJson",
		respath = "herores/luxun/",
		res = {"f_lx_i",},
		animation_name = "f_lx_i",
	},


	["herores/luxun/f_lx_s_1.ExportJson"] = {
		restype = "ExportJson",
		respath = "herores/luxun/",
		res = {"f_lx_s_1_0_0","f_lx_s_1_0_1","f_lx_s_1_0_2",},
		animation_name = "f_lx_s_1",
	},

	["herores/luxun/f_lx_s_2.ExportJson"] = {
		restype = "ExportJson",
		respath = "herores/luxun/",
		res = {"f_lx_s_2_0_0","f_lx_s_2_0_1"},
		animation_name = "f_lx_s_2",
	},

	--张绣
	["herores/zhangxiu/f_zx_e.ExportJson"] = {
		restype = "ExportJson",
		respath = "herores/zhangxiu/",
		res = {"f_zx_e_0","f_zx_e_1"},
		animation_name = "f_zx_e",
	},


	["herores/zhangxiu/f_zx_i.ExportJson"] = {
		restype = "ExportJson",
		respath = "herores/zhangxiu/",
		res = {"f_zx_i",},
		animation_name = "f_zx_i",
	},


	["herores/zhangxiu/f_zx_s_1_0.ExportJson"] = {
		restype = "ExportJson",
		respath = "herores/zhangxiu/",
		res = {"f_zx_s_1_0_0","f_zx_s_1_0_1",},
		animation_name = "f_zx_s_1_0",
	},

	["herores/zhangxiu/f_zx_s_1_1.ExportJson"] = {
		restype = "ExportJson",
		respath = "herores/zhangxiu/",
		res = {"f_zx_s_1_1",},
		animation_name = "f_zx_s_1_1",
	},

	--张绣2
	["herores/zhangxiu/f_zx2_e.ExportJson"] = {
		restype = "ExportJson",
		respath = "herores/zhangxiu/",
		res = {"f_zx2_e_0","f_zx_e_1"},
		animation_name = "f_zx2_e",
	},


	["herores/zhangxiu/f_zx2_i.ExportJson"] = {
		restype = "ExportJson",
		respath = "herores/zhangxiu/",
		res = {"f_zx2_i",},
		animation_name = "f_zx2_i",
	},


	["herores/zhangxiu/f_zx2_s_1_0.ExportJson"] = {
		restype = "ExportJson",
		respath = "herores/zhangxiu/",
		res = {"f_zx2_s_1_0_0","f_zx_s_1_0_1",},
		animation_name = "f_zx2_s_1_0",
	},


	--许褚
	["herores/xuchu/f_xc_e.ExportJson"] = {
		restype = "ExportJson",
		respath = "herores/xuchu/",
		res = {"f_xc_e_0","f_xc_e_2"},
		animation_name = "f_xc_e",
	},

	["herores/xuchu/f_xc_e_1.ExportJson"] = {
		restype = "ExportJson",
		respath = "herores/xuchu/",
		res = {"f_xc_e_1"},
		animation_name = "f_xc_e_1",
	},

	["herores/xuchu/f_xc_i.ExportJson"] = {
		restype = "ExportJson",
		respath = "herores/xuchu/",
		res = {"f_xc_i",},
		animation_name = "f_xc_i",
	},

	["herores/xuchu/f_xc_s_1_0.ExportJson"] = {
		restype = "ExportJson",
		respath = "herores/xuchu/",
		res = {"f_xc_s_1_0_0","f_xc_s_1_0_2",},
		animation_name = "f_xc_s_1_0",
	},

	["herores/xuchu/f_xc_s_1_1.ExportJson"] = {
		restype = "ExportJson",
		respath = "herores/xuchu/",
		res = {"f_xc_s_1_1_0",},
		animation_name = "f_xc_s_1_1",
	},

	["herores/xuchu/f_xc_s_1_2.ExportJson"] = {
		restype = "ExportJson",
		respath = "herores/xuchu/",
		res = {"f_xc_s_1_0_1",},
		animation_name = "f_xc_s_1_2",
	},

	["herores/xuchu/f_xc_s_2.ExportJson"] = {
		restype = "ExportJson",
		respath = "herores/xuchu/",
		res = {"f_xc_s_2_0_0","f_xc_s_2_0_1","f_xc_s_2_0_2",},
		animation_name = "f_xc_s_2",
	},

	--张宝
	["herores/zhangbao/f_zb_e.ExportJson"] = {
		restype = "ExportJson",
		respath = "herores/zhangbao/",
		res = {"f_zb_e_0","f_zb_e_1"},
		animation_name = "f_zb_e",
	},


	["herores/zhangbao/f_zb_i.ExportJson"] = {
		restype = "ExportJson",
		respath = "herores/zhangbao/",
		res = {"f_zb_i",},
		animation_name = "f_zb_i",
	},


	["herores/zhangbao/f_zb_s_1.ExportJson"] = {
		restype = "ExportJson",
		respath = "herores/zhangbao/",
		res = {"f_zb_s_1_0_0","f_zb_s_1_0_1",},
		animation_name = "f_zb_s_1",
	},

	["herores/zhangbao/f_zb_s_2_0.ExportJson"] = {
		restype = "ExportJson",
		respath = "herores/zhangbao/",
		res = {"f_zb_s_2_0_0","f_zb_s_2_0_1"},
		animation_name = "f_zb_s_2_0",
	},

	--张宝2
	["herores/zhangbao/f_zb2_e.ExportJson"] = {
		restype = "ExportJson",
		respath = "herores/zhangbao/",
		res = {"f_zb2_e_0","f_zb_e_1"},
		animation_name = "f_zb2_e",
	},


	["herores/zhangbao/f_zb2_i.ExportJson"] = {
		restype = "ExportJson",
		respath = "herores/zhangbao/",
		res = {"f_zb2_i",},
		animation_name = "f_zb2_i",
	},


	["herores/zhangbao/f_zb2_s_1.ExportJson"] = {
		restype = "ExportJson",
		respath = "herores/zhangbao/",
		res = {"f_zb2_s_1_0_0","f_zb_s_1_0_1",},
		animation_name = "f_zb2_s_1",
	},

	["herores/zhangbao/f_zb2_s_2_0.ExportJson"] = {
		restype = "ExportJson",
		respath = "herores/zhangbao/",
		res = {"f_zb2_s_2_0_0","f_zb_s_2_0_1"},
		animation_name = "f_zb2_s_2_0",
	},

	--黄忠
	["herores/huangzhong/f_huangzhong_e_0.ExportJson"] = {
		restype = "ExportJson",
		respath = "herores/huangzhong/",
		res = {"f_huangzhong_e_0","f_huangzhong_e_2"},
		animation_name = "f_huangzhong_e_0",
	},

	["herores/huangzhong/f_huangzhong_e_1.ExportJson"] = {
		restype = "ExportJson",
		respath = "herores/huangzhong/",
		res = {"f_huangzhong_e_1"},
		animation_name = "f_huangzhong_e_1",
	},

	["herores/huangzhong/f_huangzhong_i.ExportJson"] = {
		restype = "ExportJson",
		respath = "herores/huangzhong/",
		res = {"f_huangzhong_i",},
		animation_name = "f_huangzhong_i",
	},

	["herores/huangzhong/f_huangzhong_s_1_0.ExportJson"] = {
		restype = "ExportJson",
		respath = "herores/huangzhong/",
		res = {"f_huangzhong_s_1_0_0","f_huangzhong_s_1_0_1","f_huangzhong_s_1_0_2",},
		animation_name = "f_huangzhong_s_1_0",
	},

	["herores/huangzhong/f_huangzhong_s_1_1.ExportJson"] = {
		restype = "ExportJson",
		respath = "herores/huangzhong/",
		res = {"f_huangzhong_s_1_1_0",},
		animation_name = "f_huangzhong_s_1_1",
	},

	["herores/huangzhong/f_huangzhong_s_1_2.ExportJson"] = {
		restype = "ExportJson",
		respath = "herores/huangzhong/",
		res = {"f_huangzhong_s_1_0_3",},
		animation_name = "f_huangzhong_s_1_2",
	},

	["herores/huangzhong/f_huangzhong_s_2_0.ExportJson"] = {
		restype = "ExportJson",
		respath = "herores/huangzhong/",
		res = {"f_huangzhong_s_2_0_0","f_huangzhong_s_2_0_1","f_huangzhong_s_2_0_2"},
		animation_name = "f_huangzhong_s_2_0",
	},

	["herores/huangzhong/f_huangzhong_s_2_1.ExportJson"] = {
		restype = "ExportJson",
		respath = "herores/huangzhong/",
		res = {"f_huangzhong_s_2_1_0",},
		animation_name = "f_huangzhong_s_2_1",
	},

	--严颜
	["herores/yanyan/f_yy_e.ExportJson"] = {
		restype = "ExportJson",
		respath = "herores/yanyan/",
		res = {"f_yy_e_1","f_yy_e_2","f_yy_e_3"},
		animation_name = "f_yy_e",
	},


	["herores/yanyan/f_yy_i.ExportJson"] = {
		restype = "ExportJson",
		respath = "herores/yanyan/",
		res = {"f_yy_i",},
		animation_name = "f_yy_i",
	},


	["herores/yanyan/f_yy_s_1_0.ExportJson"] = {
		restype = "ExportJson",
		respath = "herores/yanyan/",
		res = {"f_yy_s_1_0_0","f_yy_s_1_0_1","f_yy_s_1_0_2",},
		animation_name = "f_yy_s_1_0",
	},

	["herores/yanyan/f_yy_s_2.ExportJson"] = {
		restype = "ExportJson",
		respath = "herores/yanyan/",
		res = {"f_yy_s_2_0_0","f_yy_s_2_0_1","f_yy_s_2_0_2"},
		animation_name = "f_yy_s_2",
	},

	--严颜2
	["herores/yanyan/f_yy2_e.ExportJson"] = {
		restype = "ExportJson",
		respath = "herores/yanyan/",
		res = {"f_yy2_e_1","f_yy2_e_2","f_yy_e_3"},
		animation_name = "f_yy2_e",
	},


	["herores/yanyan/f_yy2_i.ExportJson"] = {
		restype = "ExportJson",
		respath = "herores/yanyan/",
		res = {"f_yy2_i",},
		animation_name = "f_yy2_i",
	},


	["herores/yanyan/f_yy2_s_1_0.ExportJson"] = {
		restype = "ExportJson",
		respath = "herores/yanyan/",
		res = {"f_yy2_s_1_0_0","f_yy_s_1_0_1","f_yy_s_1_0_2",},
		animation_name = "f_yy2_s_1_0",
	},

	["herores/yanyan/f_yy2_s_2.ExportJson"] = {
		restype = "ExportJson",
		respath = "herores/yanyan/",
		res = {"f_yy2_s_2_0_0","f_yy_s_2_0_1","f_yy_s_2_0_2"},
		animation_name = "f_yy2_s_2",
	},

	------------------公用效果-----------------
	["herores/common/wuli_entrance_0.ExportJson"] = {
		restype = "ExportJson",
		respath = "herores/common/",
		res = {"wuli_entrance_0",},
		animation_name = "wuli_entrance_0",
	},
	["herores/common/wuli_entrance_1.ExportJson"] = {
		restype = "ExportJson",
		respath = "herores/common/",
		res = {"wuli_entrance_1",},
		animation_name = "wuli_entrance_1",
	},

	["herores/common/guanghuan_white.ExportJson"] = {
		restype = "ExportJson",
		respath = "herores/common/",
		res = {"gh_white",},
		animation_name = "guanghuan_white",
	},

	["herores/common/guanghuan_blue.ExportJson"] = {
		restype = "ExportJson",
		respath = "herores/common/",
		res = {"gh_blue",},
		animation_name = "guanghuan_blue",
	},

	["herores/common/guanghuan_purple.ExportJson"] = {
		restype = "ExportJson",
		respath = "herores/common/",
		res = {"gh_purple",},
		animation_name = "guanghuan_purple",
	},

	["herores/common/guanghuan_orange.ExportJson"] = {
		restype = "ExportJson",
		respath = "herores/common/",
		res = {"gh_orange",},
		animation_name = "guanghuan_orange",
	},

	--战斗公共资源
	["ui_image/battle/common"] = {
		restype = "plist",
		respath = "ui_image/battle",
		res = {"battle_0",},
	},



	---------------技能效果---------------
	["animation/skilleffect/zj_se_0.ExportJson"] = {
		restype = "ExportJson",
		respath = "animation/skilleffect/",
		res = {"f_zb_s_2_1_0","f_zb_s_2_1_1",},
		animation_name = "zj_se_0",
	},

	["animation/skilleffect/zb_se_0.ExportJson"] = {
		restype = "ExportJson",
		respath = "animation/skilleffect/",
		res = {"zj_se_0",},
		animation_name = "zb_se_0",
	},

	["animation/skilleffect/f_lx_s_2_1.ExportJson"] = {
		restype = "ExportJson",
		respath = "animation/skilleffect/",
		res = {"f_lx_s_2_1",},
		animation_name = "f_lx_s_2_1",
	},

	-------------打击效果---------------
	["animation/skilleffect/bloweffect_1.ExportJson"] = {
		restype = "ExportJson",
		respath = "animation/skilleffect/",
		res = {"f_zr_s_1_1",},
		animation_name = "bloweffect_1",
	},

	["animation/skilleffect/f_hz_s_1_1.ExportJson"] = {
		restype = "ExportJson",
		respath = "animation/skilleffect/",
		res = {"f_hz_s_1_1",},
		animation_name = "f_hz_s_1_1",
	},

	--------------buf效果资源---------------------
	["animation/skilleffect/bufeffect_1.ExportJson"] = {
		restype = "ExportJson",
		respath = "animation/skilleffect",
		res = {"buf_1_0",},
		animation_name = "bufeffect_1",
	},
}


---------------技能资源信息--------------

--[[技能效果资源
	action ,动作列表
]]
EffectResConfig = {
	[20000] = {describe = "张角技能1",action = "skill_2" ,other = {"10000"}, },
	[20001] = {describe = "张角技能2",action = "skill_1" ,other = {"10006"}, },

	[20002] = {describe = "关羽技能1",action = "skill_1" ,other = {}, },
	[20003] = {describe = "关羽技能2",action = "skill_2" ,other = {}, },

	[20004] = {describe = "周瑜技能1",action = "skill_1" ,other = {"10004"}, },
	[20005] = {describe = "周瑜技能2",action = "skill_2" ,other = {}, },

	[20006] = {describe = "吕布技能1",action = "skill_1" ,other = {"10005"}, },

	[20007] = {describe = "夏侯渊技能1",action = "skill_1" ,other = {}, },
	[20008] = {describe = "夏侯渊技能2",action = "skill_2" ,other = {}, },

	[20009] = {describe = "太史慈技能1",action = "skill_1" ,other = {}, },
	[20010] = {describe = "太史慈技能2",action = "skill_2" ,other = {}, },

	[20011] = {describe = "徐庶技能1",action = "skill_1" ,other = {}, },

	[20012] = {describe = "大乔技能1",action = "skill_1" ,other = {"10007"}, },
	[20013] = {describe = "大乔技能2",action = "skill_2" ,other = {}, },

	[20014] = {describe = "法正1",action = "skill_1" ,other = {}, },
	[20015] = {describe = "法正2",action = "skill_2" ,other = {}, },

	[20016] = {describe = "黄月英1",action = "skill_1" ,other = {}, },
	[20017] = {describe = "黄月英2",action = "skill_2" ,other = {}, },

	[20018] = {describe = "张郃",action = "skill_1" ,other = {}, },

	[20019] = {describe = "黄盖",action = "skill_1" ,other = {}, },

	[20020] = {describe = "甄姬1",action = "skill_1" ,other = {}, },
	[20021] = {describe = "甄姬2",action = "skill_2" ,other = {}, },

	[20022] = {describe = "祝融1",action = "skill_1" ,other = {}, },

	[20023] = {describe = "吕蒙1",action = "skill_1" ,other = {}, },
	[20024] = {describe = "吕蒙2",action = "skill_2" ,other = {}, },

	[20025] = {describe = "文丑1",action = "skill_1" ,other = {}, },
	[20026] = {describe = "文丑2",action = "skill_2" ,other = {}, },

	[20027] = {describe = "张昭1",action = "skill_1" ,other = {}, },
	[20028] = {describe = "张昭2",action = "skill_2" ,other = {}, },

	[20029] = {describe = "田丰1",action = "skill_1" ,other = {}, },

	[20030] = {describe = "孙尚香1",action = "skill_1" ,other = {}, },
	[20031] = {describe = "孙尚香2",action = "skill_2" ,other = {}, },

	[20032] = {describe = "于禁1",action = "skill_1" ,other = {}, },
	[20033] = {describe = "于禁2",action = "skill_2" ,other = {}, },

	[20034] = {describe = "黄祖1",action = "skill_1" ,other = {}, },
	[20035] = {describe = "黄祖2",action = "skill_2" ,other = {}, },

	[20036] = {describe = "张绣1",action = "skill_1" ,other = {}, },

	[20037] = {describe = "许褚1",action = "skill_1" ,other = {}, },
	[20038] = {describe = "许褚2",action = "skill_2" ,other = {}, },

	[20039] = {describe = "张宝1",action = "skill_1" ,other = {}, },
	[20040] = {describe = "张宝2",action = "skill_2" ,other = {}, },

	[20041] = {describe = "黄忠1",action = "skill_1" ,other = {}, },
	[20042] = {describe = "黄忠2",action = "skill_2" ,other = {}, },

	[20043] = {describe = "严颜1",action = "skill_1" ,other = {}, },
	[20044] = {describe = "严颜2",action = "skill_2" ,other = {}, },

	[20045] = {describe = "严颜2_1",action = "skill_1" ,other = {}, },
	[20046] = {describe = "严颜2_2",action = "skill_2" ,other = {}, },

	[20047] = {describe = "陆逊1",action = "skill_1" ,other = {}, },
	[20048] = {describe = "陆逊2",action = "skill_2" ,other = {}, },

	[20049] = {describe = "黄盖2_1",action = "skill_1" ,other = {}, },

	[20050] = {describe = "张宝2_1",action = "skill_1" ,other = {}, },
	[20051] = {describe = "张宝2_2",action = "skill_2" ,other = {}, },

	[20052] = {describe = "黄祖2_1",action = "skill_1" ,other = {}, },
	[20053] = {describe = "黄祖2_2",action = "skill_2" ,other = {}, },

	[20054] = {describe = "祝融2_1",action = "skill_1" ,other = {}, },

	[20055] = {describe = "张绣2_1",action = "skill_1" ,other = {}, },

	[20056] = {describe = "于禁2_1",action = "skill_1" ,other = {}, },
	[20057] = {describe = "于禁2_2",action = "skill_2" ,other = {}, },
}


--游戏颜色值
GLOBAL_COLOUR_VALUSE = {
	--服务器状态颜色 1 正常  2繁忙 3 维护 4 新区
	["server_state_1"] = cc.c4b(145, 246,252,255),
	["server_state_2"] = cc.c4b(230, 209, 9,255),
	["server_state_3"] = cc.c4b(255, 0, 0,255),
	["server_state_4"] = cc.c4b(15, 178, 25,255),
}

function getFrameShowData( index )
	return ResFrameIcon[index];
end




--[[角色图标
	frameImage 图片框
	iconImage icon 图片
	pos_x 图片相对于图框的位置
	pos_y
]]
ResFrameIcon = {
	--[[
		describe 角色描述
		attackfigure 攻击方形象
		defendfigure 防守方形象
	]]
	[20000]={
		describe = "默认人物",
		headicon = "heroicon0_small.png",
		actionlist = {
			entrance = "zj_f_entrance", -- 入场
			idle = "zj_f_idle", --空闲
			shanbi = "zj_f_shanbi", --空闲
			behit = "zj_f_beiji",--被击
			skill_1 = "zj_f_skill_1",--技能1
			skill_2 = "zj_f_skill_2",--技能2
			die = "zj_f_die",--死亡
		},
		-- attackfigure = {
		-- 	entrance = "zj_b_entrance", -- 入场
		-- 	idle = "zj_b_idle", --空闲
		-- 	behit = "zj_b_beiji",--被击
		-- 	shanbi = "zj_b_shanbi",--闪避
		-- 	skill_1 = "zj_b_skill_1",--技能1
		-- 	skill_2 = "zj_b_skill_2",--技能2
		-- 	die = "zj_b_die",--死亡
		-- },
	},
	[20022]={
		describe = "张角人物",
		headicon = "heroicon0_small.png",
		actionlist = {
			entrance = "zj_f_entrance", -- 入场
			idle = "zj_f_idle", --空闲
			shanbi = "zj_f_shanbi", --空闲
			behit = "zj_f_beiji",--被击
			skill_1 = "zj_f_skill_1",--技能1
			skill_2 = "zj_f_skill_2",--技能2
			die = "zj_f_die",--死亡
		},
		-- attackfigure = {
		-- 	entrance = "zj_b_entrance", -- 入场
		-- 	idle = "zj_b_idle", --空闲
		-- 	behit = "zj_b_beiji",--被击
		-- 	shanbi = "zj_b_shanbi",--闪避
		-- 	skill_1 = "zj_b_skill_1",--技能1
		-- 	skill_2 = "zj_b_skill_2",--技能2
		-- 	die = "zj_b_die",--死亡
		-- },
	},
	[20008]={
		describe = "关羽人物",
		headicon = "heroicon0_small.png",
		actionlist = {
			entrance = "gy_f_entrance", -- 入场
			idle = "gy_f_idle", --空闲
			behit = "gy_f_beiji",--被击
			shanbi = "gy_f_shanbi",--闪避
			skill_1 = "gy_f_skill_1",--技能1
			skill_2 = "gy_f_skill_2",--技能2
			die = "gy_f_die",--死亡
		},
	},
	[20024]={
		describe = "周瑜",
		headicon = "heroicon0_small.png",
		actionlist = {
			entrance = "zy_f_entrance", -- 入场
			idle = "zy_f_idle", --空闲
			behit = "zy_f_beiji",--被击
			shanbi = "zy_f_shanbi",--闪避
			skill_1 = "zy_f_skill_1",--技能1
			skill_2 = "zy_f_skill_2",--技能2
			die = "zy_f_die",--死亡
		},
	},
	[20053]={
		describe = "吕布",
		headicon = "heroicon0_small.png",
		actionlist = {
			entrance = "lb_f_entrance", -- 入场
			idle = "lb_f_idle", --空闲
			behit = "lb_f_beiji",--被击
			shanbi = "lb_f_shanbi",--闪避
			skill_1 = "lb_f_skill_1",--技能1
			skill_2 = "lb_f_skill_2",--技能2
			die = "lb_f_die",--死亡
		},
	},

	[20076]={
		describe = "夏侯渊",
		headicon = "heroicon0_small.png",
		actionlist = {
			entrance = "xhy_f_entrance", -- 入场
			idle = "xhy_f_idle", --空闲
			behit = "xhy_f_beiji",--被击
			shanbi = "xhy_f_shanbi",--闪避
			skill_1 = "xhy_f_skill_1",--技能1
			skill_2 = "xhy_f_skill_2",--技能2
			die = "xhy_f_die",--死亡
		},
	},

	[20102]={
		describe = "太史慈",
		headicon = "heroicon0_small.png",
		actionlist = {
			entrance = "tsc_f_entrance", -- 入场
			idle = "tsc_f_idle", --空闲
			behit = "tsc_f_beiji",--被击
			shanbi = "tsc_f_shanbi",--闪避
			skill_1 = "tsc_f_skill_1",--技能1
			skill_2 = "tsc_f_skill_2",--技能2
			die = "tsc_f_die",--死亡
		},
	},

	[20021]={
		describe = "徐庶",
		headicon = "heroicon0_small.png",
		actionlist = {
			entrance = "xs_f_entrance", -- 入场
			idle = "xs_f_idle", --空闲
			behit = "xs_f_beiji",--被击
			shanbi = "xs_f_shanbi",--闪避
			skill_1 = "xs_f_skill_1",--技能1
			skill_2 = "xs_f_skill_2",--技能2
			die = "xs_f_die",--死亡
		},
	},

	[20004]={
		describe = "大乔",
		headicon = "heroicon0_small.png",
		actionlist = {
			entrance = "dq_f_entrance", -- 入场
			idle = "dq_f_idle", --空闲
			behit = "dq_f_beiji",--被击
			shanbi = "dq_f_shanbi",--闪避
			skill_1 = "dq_f_skill_1",--技能1
			skill_2 = "dq_f_skill_2",--技能2
			die = "dq_f_die",--死亡
		},
	},

	[20032]={
		describe = "法正",
		headicon = "heroicon0_small.png",
		actionlist = {
			entrance = "fz_f_entrance", -- 入场
			idle = "fz_f_idle", --空闲
			behit = "fz_f_beiji",--被击
			shanbi = "fz_f_shanbi",--闪避
			skill_1 = "fz_f_skill_1",--技能1
			skill_2 = "fz_f_skill_2",--技能2
			die = "fz_f_die",--死亡
		},
	},

	[20010]={
		describe = "黄月英",
		headicon = "heroicon0_small.png",
		actionlist = {
			entrance = "hyy_f_entrance", -- 入场
			idle = "hyy_f_idle", --空闲
			behit = "hyy_f_beiji",--被击
			shanbi = "hyy_f_shanbi",--闪避
			skill_1 = "hyy_f_skill_1",--技能1
			skill_2 = "hyy_f_skill_2",--技能2
			die = "hyy_f_die",--死亡
		},
	},

	[20093]={
		describe = "张郃",
		headicon = "heroicon0_small.png",
		actionlist = {
			entrance = "zh_f_entrance", -- 入场
			idle = "zh_f_idle", --空闲
			behit = "zh_f_beiji",--被击
			shanbi = "zh_f_shanbi",--闪避
			skill_1 = "zh_f_skill_1",--技能1
			skill_2 = "zh_f_skill_2",--技能2
			die = "zh_f_die",--死亡
		},
	},

	[20043]={
		describe = "黄盖",
		headicon = "heroicon0_small.png",
		actionlist = {
			entrance = "hg_f_entrance", -- 入场
			idle = "hg_f_idle", --空闲
			behit = "hg_f_beiji",--被击
			shanbi = "hg_f_shanbi",--闪避
			skill_1 = "hg_f_skill_1",--技能1
			skill_2 = "hg_f_skill_2",--技能2
			die = "hg_f_die",--死亡
		},
	},

	[20185]={
		describe = "黄盖2",
		headicon = "heroicon0_small.png",
		actionlist = {
			entrance = "hg2_f_entrance", -- 入场
			idle = "hg2_f_idle", --空闲
			behit = "hg2_f_beiji",--被击
			shanbi = "hg2_f_shanbi",--闪避
			skill_1 = "hg2_f_skill_1",--技能1
			skill_2 = "hg2_f_skill_2",--技能2
			die = "hg2_f_die",--死亡
		},
	},

	[20023]={
		describe = "甄姬",
		headicon = "heroicon0_small.png",
		actionlist = {
			entrance = "zhenji_f_entrance", -- 入场
			idle = "zhenji_f_idle", --空闲
			behit = "zhenji_f_beiji",--被击
			shanbi = "zhenji_f_shanbi",--闪避
			skill_1 = "zhenji_f_skill_1",--技能1
			skill_2 = "zhenji_f_skill_2",--技能2
			die = "zhenji_f_die",--死亡
		},
	},

	[20025]={
		describe = "祝融",
		headicon = "heroicon0_small.png",
		actionlist = {
			entrance = "zr_f_entrance", -- 入场
			idle = "zr_f_idle", --空闲
			behit = "zr_f_beiji",--被击
			shanbi = "zr_f_shanbi",--闪避
			skill_1 = "zr_f_skill_1",--技能1
			skill_2 = "zr_f_skill_2",--技能2
			die = "zr_f_die",--死亡
		},
	},

	[20189]={
		describe = "祝融2",
		headicon = "heroicon0_small.png",
		actionlist = {
			entrance = "zr2_f_entrance", -- 入场
			idle = "zr2_f_idle", --空闲
			behit = "zr2_f_beiji",--被击
			shanbi = "zr2_f_shanbi",--闪避
			skill_1 = "zr2_f_skill_1",--技能1
			skill_2 = "zr2_f_skill_2",--技能2
			die = "zr2_f_die",--死亡
		},
	},

	[20055]={
		describe = "吕蒙",
		headicon = "heroicon0_small.png",
		actionlist = {
			entrance = "lm_f_entrance", -- 入场
			idle = "lm_f_idle", --空闲
			behit = "lm_f_beiji",--被击
			shanbi = "lm_f_shanbi",--闪避
			skill_1 = "lm_f_skill_1",--技能1
			skill_2 = "lm_f_skill_2",--技能2
			die = "lm_f_die",--死亡
		},
	},

	[20014]={
		describe = "文丑",
		headicon = "heroicon0_small.png",
		actionlist = {
			entrance = "wc_f_entrance", -- 入场
			idle = "wc_f_idle", --空闲
			behit = "wc_f_beiji",--被击
			shanbi = "wc_f_shanbi",--闪避
			skill_1 = "wc_f_skill_1",--技能1
			skill_2 = "wc_f_skill_2",--技能2
			die = "wc_f_die",--死亡
		},
	},

	[20095]={
		describe = "张昭",
		headicon = "heroicon0_small.png",
		actionlist = {
			entrance = "zz_f_entrance", -- 入场
			idle = "zz_f_idle", --空闲
			behit = "zz_f_beiji",--被击
			shanbi = "zz_f_shanbi",--闪避
			skill_1 = "zz_f_skill_1",--技能1
			skill_2 = "zz_f_skill_2",--技能2
			die = "zz_f_die",--死亡
		},
	},

	[20069]={
		describe = "田丰",
		headicon = "heroicon0_small.png",
		actionlist = {
			entrance = "tf_f_entrance", -- 入场
			idle = "tf_f_idle", --空闲
			behit = "tf_f_beiji",--被击
			shanbi = "tf_f_shanbi",--闪避
			skill_1 = "tf_f_skill_1",--技能1
			skill_2 = "tf_f_skill_2",--技能2
			die = "tf_f_die",--死亡
		},
	},

	[20067]={
		describe = "孙尚香",
		headicon = "heroicon0_small.png",
		actionlist = {
			entrance = "ssx_f_entrance", -- 入场
			idle = "ssx_f_idle", --空闲
			behit = "ssx_f_beiji",--被击
			shanbi = "ssx_f_shanbi",--闪避
			skill_1 = "ssx_f_skill_1",--技能1
			skill_2 = "ssx_f_skill_2",--技能2
			die = "ssx_f_die",--死亡
		},
	},

	[20084]={
		describe = "于禁",
		headicon = "heroicon0_small.png",
		actionlist = {
			entrance = "yj_f_entrance", -- 入场
			idle = "yj_f_idle", --空闲
			behit = "yj_f_beiji",--被击
			shanbi = "yj_f_shanbi",--闪避
			skill_1 = "yj_f_skill_1",--技能1
			skill_2 = "yj_f_skill_2",--技能2
			die = "yj_f_die",--死亡
		},
	},

	[20191]={
		describe = "于禁2",
		headicon = "heroicon0_small.png",
		actionlist = {
			entrance = "yj2_f_entrance", -- 入场
			idle = "yj2_f_idle", --空闲
			behit = "yj2_f_beiji",--被击
			shanbi = "yj2_f_shanbi",--闪避
			skill_1 = "yj2_f_skill_1",--技能1
			skill_2 = "yj2_f_skill_2",--技能2
			die = "yj2_f_die",--死亡
		},
	},

	[20105]={
		describe = "黄祖",
		headicon = "heroicon0_small.png",
		actionlist = {
			entrance = "huangzu_f_entrance", -- 入场
			idle = "huangzu_f_idle", --空闲
			behit = "huangzu_f_beiji",--被击
			shanbi = "huangzu_f_shanbi",--闪避
			skill_1 = "huangzu_f_skill_1",--技能1
			skill_2 = "huangzu_f_skill_2",--技能2
			die = "huangzu_f_die",--死亡
		},
	},

	[20190]={
		describe = "黄祖2",
		headicon = "heroicon0_small.png",
		actionlist = {
			entrance = "huangzu2_f_entrance", -- 入场
			idle = "huangzu2_f_idle", --空闲
			behit = "huangzu2_f_beiji",--被击
			shanbi = "huangzu2_f_shanbi",--闪避
			skill_1 = "huangzu2_f_skill_1",--技能1
			skill_2 = "huangzu2_f_skill_2",--技能2
			die = "huangzu2_f_die",--死亡
		},
	},

	[20116]={
		describe = "陆逊",
		headicon = "heroicon0_small.png",
		actionlist = {
			entrance = "lx_f_entrance", -- 入场
			idle = "lx_f_idle", --空闲
			behit = "lx_f_beiji",--被击
			shanbi = "lx_f_shanbi",--闪避
			skill_1 = "lx_f_skill_1",--技能1
			skill_2 = "lx_f_skill_2",--技能2
			die = "lx_f_die",--死亡
		},
	},

	[20094]={
		describe = "张绣",
		headicon = "heroicon0_small.png",
		actionlist = {
			entrance = "zx_f_entrance", -- 入场
			idle = "zx_f_idle", --空闲
			behit = "zx_f_beiji",--被击
			shanbi = "zx_f_shanbi",--闪避
			skill_1 = "zx_f_skill_1",--技能1
			skill_2 = "zx_f_skill_2",--技能2
			die = "zx_f_die",--死亡
		},
	},

	[20188]={
		describe = "张绣2",
		headicon = "heroicon0_small.png",
		actionlist = {
			entrance = "zx2_f_entrance", -- 入场
			idle = "zx2_f_idle", --空闲
			behit = "zx2_f_beiji",--被击
			shanbi = "zx2_f_shanbi",--闪避
			skill_1 = "zx2_f_skill_1",--技能1
			skill_2 = "zx2_f_skill_2",--技能2
			die = "zx2_f_die",--死亡
		},
	},

	[20078]={
		describe = "许褚",
		headicon = "heroicon0_small.png",
		actionlist = {
			entrance = "xc_f_entrance", -- 入场
			idle = "xc_f_idle", --空闲
			behit = "xc_f_beiji",--被击
			shanbi = "xc_f_shanbi",--闪避
			skill_1 = "xc_f_skill_1",--技能1
			skill_2 = "xc_f_skill_2",--技能2
			die = "xc_f_die",--死亡
		},
	},

	[20087]={
		describe = "张宝",
		headicon = "heroicon0_small.png",
		actionlist = {
			entrance = "zb_f_entrance", -- 入场
			idle = "zb_f_idle", --空闲
			behit = "zb_f_beiji",--被击
			shanbi = "zb_f_shanbi",--闪避
			skill_1 = "zb_f_skill_1",--技能1
			skill_2 = "zb_f_skill_2",--技能2
			die = "zb_f_die",--死亡
		},
	},

	[20186]={
		describe = "张宝2",
		headicon = "heroicon0_small.png",
		actionlist = {
			entrance = "zb2_f_entrance", -- 入场
			idle = "zb2_f_idle", --空闲
			behit = "zb2_f_beiji",--被击
			shanbi = "zb2_f_shanbi",--闪避
			skill_1 = "zb2_f_skill_1",--技能1
			skill_2 = "zb2_f_skill_2",--技能2
			die = "zb2_f_die",--死亡
		},
	},

	[20044]={
		describe = "黄忠",
		headicon = "heroicon0_small.png",
		actionlist = {
			entrance = "huangzhong_f_entrance", -- 入场
			idle = "huangzhong_f_idle", --空闲
			behit = "huangzhong_f_beiji",--被击
			shanbi = "huangzhong_f_shanbi",--闪避
			skill_1 = "huangzhong_f_skill_1",--技能1
			skill_2 = "huangzhong_f_skill_2",--技能2
			die = "huangzhong_f_die",--死亡
		},
	},

	[20081]={
		describe = "严颜",
		headicon = "heroicon0_small.png",
		actionlist = {
			entrance = "yy_f_entrance", -- 入场
			idle = "yy_f_idle", --空闲
			behit = "yy_f_beiji",--被击
			shanbi = "yy_f_shanbi",--闪避
			skill_1 = "yy_f_skill_1",--技能1
			skill_2 = "yy_f_skill_2",--技能2
			die = "yy_f_die",--死亡
		},
	},
	-----------------
	[20187]={
		describe = "严颜2",
		headicon = "heroicon0_small.png",
		actionlist = {
			entrance = "yy2_f_entrance", -- 入场
			idle = "yy2_f_idle", --空闲
			behit = "yy2_f_beiji",--被击
			shanbi = "yy2_f_shanbi",--闪避
			skill_1 = "yy2_f_skill_1",--技能1
			skill_2 = "yy2_f_skill_2",--技能2
			die = "yy2_f_die",--死亡
		},
	},
}

--[[
	角色动作信息
]]
-- RoleArmatureInfo = {
-- 	["lvbu"] = {
-- 		entrance = "", -- 入场
-- 		idle = "", --空闲
-- 		skill_1 = "",--技能1
-- 		skill_2 = "",--技能2
-- 	}
-- }

--地图信息
MapConfig = {
	["battle_1"] = "map/bbg_fine_ship.jpg",
}

--音效配置
SoundConfig = {
	[10002] = { des = "张角技能1_1",sound = ""},
}