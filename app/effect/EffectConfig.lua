--
-- Author: LiYang
-- Date: 2015-07-20 16:54:51
-- 效果配置文件


function getEffectConfigById( id )
	return EffectConfig[id];
end

--[[
	des 描述
	armature 效果
	layer 层级
	zorder 
	isfinishdestroy 完成是否销毁
	x 相对位置
	y
]]
EffectConfig = {
	---------------------------------------------------角色动作效果--------------------------------------------------------------
	["zj_f_entrance"] = { des = "张角入场" ,armature = "herores/zhangjiao/f_zj_e.ExportJson", armaturename = "entrance",res = {"herores/zhangjiao/f_zj_e.ExportJson","herores/zhangjiao/zj_1001.ExportJson"}},
	["zj_f_idle"] = { des = "张角" ,armature = "herores/zhangjiao/f_zj_i.ExportJson", armaturename = "idle",res = {"herores/zhangjiao/f_zj_i.ExportJson"}},
	["zj_f_beiji"] = { des = "张角被击" ,armature = "herores/zhangjiao/f_zj_i.ExportJson", armaturename = "beiji",res = {"herores/zhangjiao/f_zj_i.ExportJson"}},
	["zj_f_shanbi"] = { des = "张角闪避" ,armature = "herores/zhangjiao/f_zj_i.ExportJson", armaturename = "shanbi",res = {"herores/zhangjiao/f_zj_i.ExportJson"}},
	["zj_f_die"] = { des = "张角死亡" ,armature = "herores/zhangjiao/f_zj_i.ExportJson", armaturename = "die",res = {"herores/zhangjiao/f_zj_i.ExportJson"}},
	["zj_f_skill_1"] = { des = "张角技能1" ,armature = "herores/zhangjiao/f_zj_s_0.ExportJson", armaturename = "skill_1",res = {"herores/zhangjiao/f_zj_s_0.ExportJson"}},
	["zj_f_skill_2"] = { des = "张角技能2" ,armature = "herores/zhangjiao/f_zj_s_1.ExportJson", armaturename = "skill_2",res = {"herores/zhangjiao/f_zj_s_1.ExportJson"}},

	["gy_f_entrance"] = { des = "关羽" ,armature = "herores/guanyu/f_gy_e.ExportJson", armaturename = "entrance",res = {"herores/guanyu/f_gy_e.ExportJson","herores/common/wuli_entrance_0.ExportJson"}},
	["gy_f_idle"] = { des = "关羽" ,armature = "herores/guanyu/f_gy_i.ExportJson", armaturename = "idle",res = {"herores/guanyu/f_gy_i.ExportJson"}},
	["gy_f_beiji"] = { des = "关羽被击" ,armature = "herores/guanyu/f_gy_i.ExportJson", armaturename = "beiji",res = {"herores/guanyu/f_gy_i.ExportJson"}},
	["gy_f_shanbi"] = { des = "关羽闪避" ,armature = "herores/guanyu/f_gy_i.ExportJson", armaturename = "shanbi",res = {"herores/guanyu/f_gy_i.ExportJson"}},
	["gy_f_die"] = { des = "关羽死亡" ,armature = "herores/guanyu/f_gy_i.ExportJson", armaturename = "die",res = {"herores/guanyu/f_gy_i.ExportJson"}},
	["gy_f_skill_1"] = { des = "关羽技能1" ,armature = "herores/guanyu/f_gy_s_1_0.ExportJson", armaturename = "skill_1",res = {"herores/guanyu/f_gy_s_1_0.ExportJson"}},
	["gy_f_skill_2"] = { des = "关羽技能2" ,armature = "herores/guanyu/f_gy_s_2_0.ExportJson", armaturename = "skill_2",res = {"herores/guanyu/f_gy_s_2_0.ExportJson"}},
	
	["zy_f_entrance"] = { des = "周瑜" ,armature = "herores/zhouyu/f_zy_e.ExportJson", armaturename = "entrance",res = {"herores/zhouyu/f_zy_e.ExportJson","herores/zhouyu/f_zy_e_1.ExportJson"}},
	["zy_f_idle"] = { des = "周瑜" ,armature = "herores/zhouyu/f_zy_i.ExportJson", armaturename = "idle",res = {"herores/zhouyu/f_zy_i.ExportJson"}},
	["zy_f_beiji"] = { des = "周瑜被击" ,armature = "herores/zhouyu/f_zy_i.ExportJson", armaturename = "beiji",res = {"herores/zhouyu/f_zy_i.ExportJson"}},
	["zy_f_shanbi"] = { des = "周瑜闪避" ,armature = "herores/zhouyu/f_zy_i.ExportJson", armaturename = "shanbi",res = {"herores/zhouyu/f_zy_i.ExportJson"}},
	["zy_f_die"] = { des = "周瑜死亡" ,armature = "herores/zhouyu/f_zy_i.ExportJson", armaturename = "die",res = {"herores/zhouyu/f_zy_i.ExportJson"}},
	["zy_f_skill_1"] = { des = "周瑜技能1" ,armature = "herores/zhouyu/f_zy_s_1_0.ExportJson", armaturename = "skill_1",res = {"herores/zhouyu/f_zy_s_1_0.ExportJson","herores/zhouyu/f_zy_s_1_1.ExportJson"}},
	["zy_f_skill_2"] = { des = "周瑜技能2" ,armature = "herores/zhouyu/f_zy_s_2_0.ExportJson", armaturename = "skill_2",res = {"herores/zhouyu/f_zy_s_2_0.ExportJson"}},
	
	["lb_f_entrance"] = { des = "吕布" ,armature = "herores/lvbu/f_lv_e.ExportJson", armaturename = "entrance",res = {"herores/lvbu/f_lv_e.ExportJson"}},
	["lb_f_idle"] = { des = "吕布" ,armature = "herores/lvbu/f_lv_i.ExportJson", armaturename = "idle",res = {"herores/lvbu/f_lv_i.ExportJson"}},
	["lb_f_beiji"] = { des = "吕布被击" ,armature = "herores/lvbu/f_lv_i.ExportJson", armaturename = "beiji",res = {"herores/lvbu/f_lv_i.ExportJson"}},
	["lb_f_shanbi"] = { des = "吕布闪避" ,armature = "herores/lvbu/f_lv_i.ExportJson", armaturename = "shanbi",res = {"herores/lvbu/f_lv_i.ExportJson"}},
	["lb_f_die"] = { des = "吕布死亡" ,armature = "herores/lvbu/f_lv_i.ExportJson", armaturename = "die",res = {"herores/lvbu/f_lv_i.ExportJson"}},
	["lb_f_skill_1"] = { des = "吕布技能1" ,armature = "herores/lvbu/f_lv_s_1_0.ExportJson", armaturename = "skill_1",res = {"herores/lvbu/f_lv_s_1_0.ExportJson","herores/lvbu/lv_10005.ExportJson"}},

	["xhy_f_entrance"] = { des = "夏侯渊" ,armature = "herores/xiahouyuan/f_xhy_e.ExportJson", armaturename = "entrance",res = {"herores/xiahouyuan/f_xhy_e.ExportJson","herores/xiahouyuan/f_xhy_e_1.ExportJson"}},
	["xhy_f_idle"] = { des = "夏侯渊" ,armature = "herores/xiahouyuan/f_xhy_i.ExportJson", armaturename = "idle",res = {"herores/xiahouyuan/f_xhy_i.ExportJson"}},
	["xhy_f_beiji"] = { des = "夏侯渊被击" ,armature = "herores/xiahouyuan/f_xhy_i.ExportJson", armaturename = "beiji",res = {"herores/xiahouyuan/f_xhy_i.ExportJson"}},
	["xhy_f_shanbi"] = { des = "夏侯渊闪避" ,armature = "herores/xiahouyuan/f_xhy_i.ExportJson", armaturename = "shanbi",res = {"herores/xiahouyuan/f_xhy_i.ExportJson"}},
	["xhy_f_die"] = { des = "夏侯渊死亡" ,armature = "herores/xiahouyuan/f_xhy_i.ExportJson", armaturename = "die",res = {"herores/xiahouyuan/f_xhy_i.ExportJson"}},
	["xhy_f_skill_1"] = { des = "夏侯渊技能1" ,armature = "herores/xiahouyuan/f_xhy_s_1_0.ExportJson", armaturename = "skill_1",res = {"herores/xiahouyuan/f_xhy_s_1_0.ExportJson","herores/xiahouyuan/f_xhy_s_1_1.ExportJson","herores/xiahouyuan/f_xhy_s_1_2.ExportJson"}},
	["xhy_f_skill_2"] = { des = "夏侯渊技能2" ,armature = "herores/xiahouyuan/f_xhy_s_2_0.ExportJson", armaturename = "skill_2",res = {"herores/xiahouyuan/f_xhy_s_2_0.ExportJson","herores/xiahouyuan/f_xhy_s_1_1.ExportJson","herores/xiahouyuan/f_xhy_s_1_2.ExportJson"}},
	
	["tsc_f_entrance"] = { des = "太史慈" ,armature = "herores/taishici/f_tsc_e.ExportJson", armaturename = "entrance",res = {"herores/taishici/f_tsc_e.ExportJson","herores/taishici/f_tsc_e_1.ExportJson"}},
	["tsc_f_idle"] = { des = "太史慈" ,armature = "herores/taishici/f_tsc_i.ExportJson", armaturename = "idle",res = {"herores/taishici/f_tsc_i.ExportJson"}},
	["tsc_f_beiji"] = { des = "太史慈被击" ,armature = "herores/taishici/f_tsc_i.ExportJson", armaturename = "beiji",res = {"herores/taishici/f_tsc_i.ExportJson"}},
	["tsc_f_shanbi"] = { des = "太史慈闪避" ,armature = "herores/taishici/f_tsc_i.ExportJson", armaturename = "shanbi",res = {"herores/taishici/f_tsc_i.ExportJson"}},
	["tsc_f_die"] = { des = "太史慈死亡" ,armature = "herores/taishici/f_tsc_i.ExportJson", armaturename = "die",res = {"herores/taishici/f_tsc_i.ExportJson"}},
	["tsc_f_skill_1"] = { des = "太史慈技能1" ,armature = "herores/taishici/f_tsc_s_1_0.ExportJson", armaturename = "skill_1",res = {"herores/taishici/f_tsc_s_1_0.ExportJson","herores/taishici/f_tsc_s_1_1.ExportJson","herores/taishici/f_tsc_s_1_2.ExportJson"}},
	["tsc_f_skill_2"] = { des = "太史慈技能2" ,armature = "herores/taishici/f_tsc_s_2_0.ExportJson", armaturename = "skill_2",res = {"herores/taishici/f_tsc_s_2_0.ExportJson"}},

	["xs_f_entrance"] = { des = "徐庶" ,armature = "herores/xushu/f_xs_e.ExportJson", armaturename = "entrance",res = {"herores/xushu/f_xs_e.ExportJson","herores/xushu/f_xs_e_1.ExportJson"}},
	["xs_f_idle"] = { des = "徐庶" ,armature = "herores/xushu/f_xs_i.ExportJson", armaturename = "idle",res = {"herores/xushu/f_xs_i.ExportJson"}},
	["xs_f_beiji"] = { des = "徐庶被击" ,armature = "herores/xushu/f_xs_i.ExportJson", armaturename = "beiji",res = {"herores/xushu/f_xs_i.ExportJson"}},
	["xs_f_shanbi"] = { des = "徐庶闪避" ,armature = "herores/xushu/f_xs_i.ExportJson", armaturename = "shanbi",res = {"herores/xushu/f_xs_i.ExportJson"}},
	["xs_f_die"] = { des = "徐庶死亡" ,armature = "herores/xushu/f_xs_i.ExportJson", armaturename = "die",res = {"herores/xushu/f_xs_i.ExportJson"}},
	["xs_f_skill_1"] = { des = "徐庶技能1" ,armature = "herores/xushu/f_xs_s_1_0.ExportJson", armaturename = "skill_1",res = {"herores/xushu/f_xs_s_1_0.ExportJson","herores/xushu/f_xs_s_1_1.ExportJson","herores/xushu/xs_1001.ExportJson"}},

	["dq_f_entrance"] = { des = "大桥" ,armature = "herores/daqiao/f_dq_e.ExportJson", armaturename = "entrance",res = {"herores/daqiao/f_dq_e.ExportJson","herores/daqiao/f_dq_e_1.ExportJson"}},
	["dq_f_idle"] = { des = "大桥" ,armature = "herores/daqiao/f_dq_i.ExportJson", armaturename = "idle",res = {"herores/daqiao/f_dq_i.ExportJson"}},
	["dq_f_beiji"] = { des = "大桥被击" ,armature = "herores/daqiao/f_dq_i.ExportJson", armaturename = "beiji",res = {"herores/daqiao/f_dq_i.ExportJson"}},
	["dq_f_shanbi"] = { des = "大桥闪避" ,armature = "herores/daqiao/f_dq_i.ExportJson", armaturename = "shanbi",res = {"herores/daqiao/f_dq_i.ExportJson"}},
	["dq_f_die"] = { des = "大桥死亡" ,armature = "herores/daqiao/f_dq_i.ExportJson", armaturename = "die",res = {"herores/daqiao/f_dq_i.ExportJson"}},
	["dq_f_skill_1"] = { des = "大桥技能1" ,armature = "herores/daqiao/f_dq_s_1_0.ExportJson", armaturename = "skill_1",res = {"herores/daqiao/f_dq_s_1_0.ExportJson","herores/daqiao/f_dq_s_1_1.ExportJson"}},
	["dq_f_skill_2"] = { des = "大桥技能2" ,armature = "herores/daqiao/f_dq_s_2.ExportJson", armaturename = "skill_2",res = {"herores/daqiao/f_dq_s_2.ExportJson"}},

	["fz_f_entrance"] = { des = "法正" ,armature = "herores/fazheng/f_fz_e.ExportJson", armaturename = "entrance",res = {"herores/fazheng/f_fz_e.ExportJson"}},
	["fz_f_idle"] = { des = "法正" ,armature = "herores/fazheng/f_fz_i.ExportJson", armaturename = "idle",res = {"herores/fazheng/f_fz_i.ExportJson"}},
	["fz_f_beiji"] = { des = "法正被击" ,armature = "herores/fazheng/f_fz_i.ExportJson", armaturename = "beiji",res = {"herores/fazheng/f_fz_i.ExportJson"}},
	["fz_f_shanbi"] = { des = "法正闪避" ,armature = "herores/fazheng/f_fz_i.ExportJson", armaturename = "shanbi",res = {"herores/fazheng/f_fz_i.ExportJson"}},
	["fz_f_die"] = { des = "法正死亡" ,armature = "herores/fazheng/f_fz_i.ExportJson", armaturename = "die",res = {"herores/fazheng/f_fz_i.ExportJson"}},
	["fz_f_skill_1"] = { des = "法正技能1" ,armature = "herores/fazheng/f_fz_s_1.ExportJson", armaturename = "skill_1",res = {"herores/fazheng/f_fz_s_1.ExportJson"}},
	["fz_f_skill_2"] = { des = "法正技能2" ,armature = "herores/fazheng/f_fz_s_2_0.ExportJson", armaturename = "skill_2",res = {"herores/fazheng/f_fz_s_2_0.ExportJson","herores/fazheng/f_fz_s_2_1.ExportJson"}},

	["hyy_f_entrance"] = { des = "黄月英" ,armature = "herores/huangyueying/f_hyy_e.ExportJson", armaturename = "entrance",res = {"herores/huangyueying/f_hyy_e.ExportJson","herores/huangyueying/f_hyy_e_1.ExportJson"}},
	["hyy_f_idle"] = { des = "黄月英" ,armature = "herores/huangyueying/f_hyy_i.ExportJson", armaturename = "idle",res = {"herores/huangyueying/f_hyy_i.ExportJson"}},
	["hyy_f_beiji"] = { des = "黄月英被击" ,armature = "herores/huangyueying/f_hyy_i.ExportJson", armaturename = "beiji",res = {"herores/huangyueying/f_hyy_i.ExportJson"}},
	["hyy_f_shanbi"] = { des = "黄月英闪避" ,armature = "herores/huangyueying/f_hyy_i.ExportJson", armaturename = "shanbi",res = {"herores/huangyueying/f_hyy_i.ExportJson"}},
	["hyy_f_die"] = { des = "黄月英死亡" ,armature = "herores/huangyueying/f_hyy_i.ExportJson", armaturename = "die",res = {"herores/huangyueying/f_hyy_i.ExportJson"}},
	["hyy_f_skill_1"] = { des = "黄月英技能1" ,armature = "herores/huangyueying/f_hyy_s_2_0.ExportJson", armaturename = "skill_2",res = {"herores/huangyueying/f_hyy_s_2_0.ExportJson","herores/huangyueying/f_hyy_s_1_1.ExportJson"}},
	["hyy_f_skill_2"] = { des = "黄月英技能2" ,armature = "herores/huangyueying/f_hyy_s_2_0.ExportJson", armaturename = "skill_2",res = {"herores/huangyueying/f_hyy_s_2_0.ExportJson","herores/huangyueying/f_hyy_s_2_1.ExportJson"}},

	["zh_f_entrance"] = { des = "张郃" ,armature = "herores/zhanghe/f_zh_e.ExportJson", armaturename = "entrance",res = {"herores/zhanghe/f_zh_e.ExportJson","herores/zhanghe/f_zh_e_1.ExportJson"}},
	["zh_f_idle"] = { des = "张郃" ,armature = "herores/zhanghe/f_zh_i.ExportJson", armaturename = "idle",res = {"herores/zhanghe/f_zh_i.ExportJson"}},
	["zh_f_beiji"] = { des = "张郃被击" ,armature = "herores/zhanghe/f_zh_i.ExportJson", armaturename = "beiji",res = {"herores/zhanghe/f_zh_i.ExportJson"}},
	["zh_f_shanbi"] = { des = "张郃闪避" ,armature = "herores/zhanghe/f_zh_i.ExportJson", armaturename = "shanbi",res = {"herores/zhanghe/f_zh_i.ExportJson"}},
	["zh_f_die"] = { des = "张郃死亡" ,armature = "herores/zhanghe/f_zh_i.ExportJson", armaturename = "die",res = {"herores/zhanghe/f_zh_i.ExportJson"}},
	["zh_f_skill_1"] = { des = "张郃技能1" ,armature = "herores/zhanghe/f_zh_s_1.ExportJson", armaturename = "skill_1",res = {"herores/zhanghe/f_zh_s_1.ExportJson"}},

	["hg_f_entrance"] = { des = "黄盖" ,armature = "herores/huanggai/f_hg_e_0.ExportJson", armaturename = "entrance",res = {"herores/huanggai/f_hg_e_0.ExportJson","herores/huanggai/f_hg_e_1.ExportJson"}},
	["hg_f_idle"] = { des = "黄盖" ,armature = "herores/huanggai/f_hg_i.ExportJson", armaturename = "idle",res = {"herores/huanggai/f_hg_i.ExportJson"}},
	["hg_f_beiji"] = { des = "黄盖被击" ,armature = "herores/huanggai/f_hg_i.ExportJson", armaturename = "beiji",res = {"herores/huanggai/f_hg_i.ExportJson"}},
	["hg_f_shanbi"] = { des = "黄盖闪避" ,armature = "herores/huanggai/f_hg_i.ExportJson", armaturename = "shanbi",res = {"herores/huanggai/f_hg_i.ExportJson"}},
	["hg_f_die"] = { des = "黄盖死亡" ,armature = "herores/huanggai/f_hg_i.ExportJson", armaturename = "die",res = {"herores/huanggai/f_hg_i.ExportJson"}},
	["hg_f_skill_1"] = { des = "黄盖技能1" ,armature = "herores/huanggai/f_hg_s_1_0.ExportJson", armaturename = "skill_1",res = {"herores/huanggai/f_hg_s_1_0.ExportJson","herores/huanggai/f_hg_s_1_1.ExportJson"}},

	["hg2_f_entrance"] = { des = "黄盖2" ,armature = "herores/huanggai/f_hg2_e_0.ExportJson", armaturename = "entrance",res = {"herores/huanggai/f_hg2_e_0.ExportJson","herores/huanggai/f_hg_e_1.ExportJson"}},
	["hg2_f_idle"] = { des = "黄盖2" ,armature = "herores/huanggai/f_hg2_i.ExportJson", armaturename = "idle",res = {"herores/huanggai/f_hg2_i.ExportJson"}},
	["hg2_f_beiji"] = { des = "黄盖2被击" ,armature = "herores/huanggai/f_hg2_i.ExportJson", armaturename = "beiji",res = {"herores/huanggai/f_hg2_i.ExportJson"}},
	["hg2_f_shanbi"] = { des = "黄盖2闪避" ,armature = "herores/huanggai/f_hg2_i.ExportJson", armaturename = "shanbi",res = {"herores/huanggai/f_hg2_i.ExportJson"}},
	["hg2_f_die"] = { des = "黄盖2死亡" ,armature = "herores/huanggai/f_hg2_i.ExportJson", armaturename = "die",res = {"herores/huanggai/f_hg2_i.ExportJson"}},
	["hg2_f_skill_1"] = { des = "黄盖2技能1" ,armature = "herores/huanggai/f_hg2_s_1_0.ExportJson", armaturename = "skill_1",res = {"herores/huanggai/f_hg2_s_1_0.ExportJson","herores/huanggai/f_hg_s_1_1.ExportJson"}},

	["zhenji_f_entrance"] = { des = "甄姬" ,armature = "herores/zhenji/f_zhenji_e.ExportJson", armaturename = "entrance",res = {"herores/zhenji/f_zhenji_e.ExportJson"}},
	["zhenji_f_idle"] = { des = "甄姬" ,armature = "herores/zhenji/f_zhenji_i.ExportJson", armaturename = "idle",res = {"herores/zhenji/f_zhenji_i.ExportJson"}},
	["zhenji_f_beiji"] = { des = "甄姬被击" ,armature = "herores/zhenji/f_zhenji_i.ExportJson", armaturename = "beiji",res = {"herores/zhenji/f_zhenji_i.ExportJson"}},
	["zhenji_f_shanbi"] = { des = "甄姬闪避" ,armature = "herores/zhenji/f_zhenji_i.ExportJson", armaturename = "shanbi",res = {"herores/zhenji/f_zhenji_i.ExportJson"}},
	["zhenji_f_die"] = { des = "甄姬死亡" ,armature = "herores/zhenji/f_zhenji_i.ExportJson", armaturename = "die",res = {"herores/zhenji/f_zhenji_i.ExportJson"}},
	["zhenji_f_skill_1"] = { des = "甄姬技能1" ,armature = "herores/zhenji/f_zhenji_s_1.ExportJson", armaturename = "skill_1",res = {"herores/zhenji/f_zhenji_s_1.ExportJson","herores/zhenji/zhenji_1001.ExportJson"}},
	["zhenji_f_skill_2"] = { des = "甄姬技能2" ,armature = "herores/zhenji/f_zhenji_s_2.ExportJson", armaturename = "skill_2",res = {"herores/zhenji/f_zhenji_s_2.ExportJson","herores/zhenji/zhenji_1001.ExportJson"}},

	["zr_f_entrance"] = { des = "祝融" ,armature = "herores/zhurong/f_zr_e_1.ExportJson", armaturename = "entrance",res = {"herores/zhurong/f_zr_e_1.ExportJson","herores/zhurong/f_zr_e_2.ExportJson"}},
	["zr_f_idle"] = { des = "祝融" ,armature = "herores/zhurong/f_zr_i.ExportJson", armaturename = "idle",res = {"herores/zhurong/f_zr_i.ExportJson"}},
	["zr_f_beiji"] = { des = "祝融被击" ,armature = "herores/zhurong/f_zr_i.ExportJson", armaturename = "beiji",res = {"herores/zhurong/f_zr_i.ExportJson"}},
	["zr_f_shanbi"] = { des = "祝融闪避" ,armature = "herores/zhurong/f_zr_i.ExportJson", armaturename = "shanbi",res = {"herores/zhurong/f_zr_i.ExportJson"}},
	["zr_f_die"] = { des = "祝融死亡" ,armature = "herores/zhurong/f_zr_i.ExportJson", armaturename = "die",res = {"herores/zhurong/f_zr_i.ExportJson"}},
	["zr_f_skill_1"] = { des = "祝融技能1" ,armature = "herores/zhurong/f_zr_s_2_0.ExportJson", armaturename = "skill_2",res = {"herores/zhurong/f_zr_s_2_0.ExportJson","herores/zhurong/f_zr_s_1_1.ExportJson"}},

	["zr2_f_entrance"] = { des = "祝融2" ,armature = "herores/zhurong/f_zr2_e_1.ExportJson", armaturename = "entrance",res = {"herores/zhurong/f_zr2_e_1.ExportJson","herores/zhurong/f_zr_e_2.ExportJson"}},
	["zr2_f_idle"] = { des = "祝融2" ,armature = "herores/zhurong/f_zr2_i.ExportJson", armaturename = "idle",res = {"herores/zhurong/f_zr2_i.ExportJson"}},
	["zr2_f_beiji"] = { des = "祝融2被击" ,armature = "herores/zhurong/f_zr2_i.ExportJson", armaturename = "beiji",res = {"herores/zhurong/f_zr2_i.ExportJson"}},
	["zr2_f_shanbi"] = { des = "祝融2闪避" ,armature = "herores/zhurong/f_zr2_i.ExportJson", armaturename = "shanbi",res = {"herores/zhurong/f_zr2_i.ExportJson"}},
	["zr2_f_die"] = { des = "祝融2死亡" ,armature = "herores/zhurong/f_zr2_i.ExportJson", armaturename = "die",res = {"herores/zhurong/f_zr2_i.ExportJson"}},
	["zr2_f_skill_1"] = { des = "祝融2技能1" ,armature = "herores/zhurong/f_zr2_s_2_0.ExportJson", armaturename = "skill_2",res = {"herores/zhurong/f_zr2_s_2_0.ExportJson","herores/zhurong/f_zr_s_1_1.ExportJson"}},


	["lm_f_entrance"] = { des = "吕蒙" ,armature = "herores/lvmeng/f_lm_e.ExportJson", armaturename = "entrance",res = {"herores/lvmeng/f_lm_e.ExportJson","herores/lvmeng/f_lm_e_1.ExportJson"}},
	["lm_f_idle"] = { des = "吕蒙" ,armature = "herores/lvmeng/f_lm_i.ExportJson", armaturename = "idle",res = {"herores/lvmeng/f_lm_i.ExportJson"}},
	["lm_f_beiji"] = { des = "吕蒙被击" ,armature = "herores/lvmeng/f_lm_i.ExportJson", armaturename = "beiji",res = {"herores/lvmeng/f_lm_i.ExportJson"}},
	["lm_f_shanbi"] = { des = "吕蒙闪避" ,armature = "herores/lvmeng/f_lm_i.ExportJson", armaturename = "shanbi",res = {"herores/lvmeng/f_lm_i.ExportJson"}},
	["lm_f_die"] = { des = "吕蒙死亡" ,armature = "herores/lvmeng/f_lm_i.ExportJson", armaturename = "die",res = {"herores/lvmeng/f_lm_i.ExportJson"}},
	["lm_f_skill_1"] = { des = "吕蒙技能1" ,armature = "herores/lvmeng/f_lm_s_1_0.ExportJson", armaturename = "skill_1",res = {"herores/lvmeng/f_lm_s_1_0.ExportJson","herores/lvmeng/f_lm_s_1_1.ExportJson"}},
	["lm_f_skill_2"] = { des = "吕蒙技能2" ,armature = "herores/lvmeng/f_lm_s_2_0.ExportJson", armaturename = "skill_2",res = {"herores/lvmeng/f_lm_s_2_0.ExportJson","herores/lvmeng/f_lm_s_2_1.ExportJson"}},
	
	["wc_f_entrance"] = { des = "文丑" ,armature = "herores/wenchou/f_wc_e_0.ExportJson", armaturename = "entrance",res = {"herores/wenchou/f_wc_e_0.ExportJson","herores/wenchou/f_wc_e_1.ExportJson"}},
	["wc_f_idle"] = { des = "文丑" ,armature = "herores/wenchou/f_wc_i.ExportJson", armaturename = "idle",res = {"herores/wenchou/f_wc_i.ExportJson"}},
	["wc_f_beiji"] = { des = "文丑被击" ,armature = "herores/wenchou/f_wc_i.ExportJson", armaturename = "beiji",res = {"herores/wenchou/f_wc_i.ExportJson"}},
	["wc_f_shanbi"] = { des = "文丑闪避" ,armature = "herores/wenchou/f_wc_i.ExportJson", armaturename = "shanbi",res = {"herores/wenchou/f_wc_i.ExportJson"}},
	["wc_f_die"] = { des = "文丑死亡" ,armature = "herores/wenchou/f_wc_i.ExportJson", armaturename = "die",res = {"herores/wenchou/f_wc_i.ExportJson"}},
	["wc_f_skill_1"] = { des = "文丑技能1" ,armature = "herores/wenchou/f_wc_s_1_0.ExportJson", armaturename = "skill_1",res = {"herores/wenchou/f_wc_s_1_0.ExportJson"}},
	["wc_f_skill_2"] = { des = "文丑技能2" ,armature = "herores/wenchou/f_wc_s_2_0.ExportJson", armaturename = "skill_2",res = {"herores/wenchou/f_wc_s_2_0.ExportJson"}},

	["zz_f_entrance"] = { des = "张昭" ,armature = "herores/zhangzhao/f_zz_e.ExportJson", armaturename = "entrance",res = {"herores/zhangzhao/f_zz_e.ExportJson"}},
	["zz_f_idle"] = { des = "张昭" ,armature = "herores/zhangzhao/f_zz_i.ExportJson", armaturename = "idle",res = {"herores/zhangzhao/f_zz_i.ExportJson"}},
	["zz_f_beiji"] = { des = "张昭被击" ,armature = "herores/zhangzhao/f_zz_i.ExportJson", armaturename = "beiji",res = {"herores/zhangzhao/f_zz_i.ExportJson"}},
	["zz_f_shanbi"] = { des = "张昭闪避" ,armature = "herores/zhangzhao/f_zz_i.ExportJson", armaturename = "shanbi",res = {"herores/zhangzhao/f_zz_i.ExportJson"}},
	["zz_f_die"] = { des = "张昭死亡" ,armature = "herores/zhangzhao/f_zz_i.ExportJson", armaturename = "die",res = {"herores/zhangzhao/f_zz_i.ExportJson"}},
	["zz_f_skill_1"] = { des = "张昭技能1" ,armature = "herores/zhangzhao/f_zz_s_1_0.ExportJson", armaturename = "skill_1",res = {"herores/zhangzhao/f_zz_s_1_0.ExportJson","herores/zhangzhao/f_zz_s_1_1.ExportJson"}},
	["zz_f_skill_2"] = { des = "张昭技能2" ,armature = "herores/zhangzhao/f_zz_s_2.ExportJson", armaturename = "skill_2",res = {"herores/zhangzhao/f_zz_s_2.ExportJson"}},

	["tf_f_entrance"] = { des = "田丰" ,armature = "herores/tianfeng/f_tf_e_0.ExportJson", armaturename = "entrance",res = {"herores/tianfeng/f_tf_e_0.ExportJson","herores/zhangjiao/zj_1001.ExportJson"}},
	["tf_f_idle"] = { des = "田丰" ,armature = "herores/tianfeng/f_tf_i.ExportJson", armaturename = "idle",res = {"herores/tianfeng/f_tf_i.ExportJson"}},
	["tf_f_beiji"] = { des = "田丰被击" ,armature = "herores/tianfeng/f_tf_i.ExportJson", armaturename = "beiji",res = {"herores/tianfeng/f_tf_i.ExportJson"}},
	["tf_f_shanbi"] = { des = "田丰闪避" ,armature = "herores/tianfeng/f_tf_i.ExportJson", armaturename = "shanbi",res = {"herores/tianfeng/f_tf_i.ExportJson"}},
	["tf_f_die"] = { des = "田丰死亡" ,armature = "herores/tianfeng/f_tf_i.ExportJson", armaturename = "die",res = {"herores/tianfeng/f_tf_i.ExportJson"}},
	["tf_f_skill_1"] = { des = "田丰技能1" ,armature = "herores/tianfeng/f_tf_s_1.ExportJson", armaturename = "skill_1",res = {"herores/tianfeng/f_tf_s_1.ExportJson"}},

	["ssx_f_entrance"] = { des = "孙尚香" ,armature = "herores/sunshangxiang/f_ssx_e.ExportJson", armaturename = "entrance",res = {"herores/sunshangxiang/f_ssx_e.ExportJson","herores/huanggai/f_hg_e_1.ExportJson"}},
	["ssx_f_idle"] = { des = "孙尚香" ,armature = "herores/sunshangxiang/f_ssx_i.ExportJson", armaturename = "idle",res = {"herores/sunshangxiang/f_ssx_i.ExportJson"}},
	["ssx_f_beiji"] = { des = "孙尚香被击" ,armature = "herores/sunshangxiang/f_ssx_i.ExportJson", armaturename = "beiji",res = {"herores/sunshangxiang/f_ssx_i.ExportJson"}},
	["ssx_f_shanbi"] = { des = "孙尚香闪避" ,armature = "herores/sunshangxiang/f_ssx_i.ExportJson", armaturename = "shanbi",res = {"herores/sunshangxiang/f_ssx_i.ExportJson"}},
	["ssx_f_die"] = { des = "孙尚香死亡" ,armature = "herores/sunshangxiang/f_ssx_i.ExportJson", armaturename = "die",res = {"herores/sunshangxiang/f_ssx_i.ExportJson"}},
	["ssx_f_skill_1"] = { des = "孙尚香技能1" ,armature = "herores/sunshangxiang/f_ssx_s_1_0.ExportJson", armaturename = "skill_1",res = {"herores/sunshangxiang/f_ssx_s_1_0.ExportJson","herores/sunshangxiang/f_ssx_s_1_1.ExportJson"}},
	["ssx_f_skill_2"] = { des = "孙尚香技能2" ,armature = "herores/sunshangxiang/f_ssx_s_2_0.ExportJson", armaturename = "skill_2",res = {"herores/sunshangxiang/f_ssx_s_2_0.ExportJson","herores/sunshangxiang/f_ssx_s_2_1.ExportJson"}},

	["yj_f_entrance"] = { des = "于禁" ,armature = "herores/yujin/f_yj_e.ExportJson", armaturename = "entrance",res = {"herores/yujin/f_yj_e.ExportJson","herores/yujin/f_yj_e_2.ExportJson"}},
	["yj_f_idle"] = { des = "于禁" ,armature = "herores/yujin/f_yj_i.ExportJson", armaturename = "idle",res = {"herores/yujin/f_yj_i.ExportJson"}},
	["yj_f_beiji"] = { des = "于禁被击" ,armature = "herores/yujin/f_yj_i.ExportJson", armaturename = "beiji",res = {"herores/yujin/f_yj_i.ExportJson"}},
	["yj_f_shanbi"] = { des = "于禁闪避" ,armature = "herores/yujin/f_yj_i.ExportJson", armaturename = "shanbi",res = {"herores/yujin/f_yj_i.ExportJson"}},
	["yj_f_die"] = { des = "于禁死亡" ,armature = "herores/yujin/f_yj_i.ExportJson", armaturename = "die",res = {"herores/yujin/f_yj_i.ExportJson"}},
	["yj_f_skill_1"] = { des = "于禁技能1" ,armature = "herores/yujin/f_yj_s_1.ExportJson", armaturename = "skill_1",res = {"herores/yujin/f_yj_s_1.ExportJson"}},
	["yj_f_skill_2"] = { des = "于禁技能2" ,armature = "herores/yujin/f_yj_s_2.ExportJson", armaturename = "skill_2",res = {"herores/yujin/f_yj_s_2.ExportJson"}},

	["yj2_f_entrance"] = { des = "于禁2" ,armature = "herores/yujin/f_yj2_e.ExportJson", armaturename = "entrance",res = {"herores/yujin/f_yj2_e.ExportJson","herores/yujin/f_yj_e_2.ExportJson"}},
	["yj2_f_idle"] = { des = "于禁2" ,armature = "herores/yujin/f_yj2_i.ExportJson", armaturename = "idle",res = {"herores/yujin/f_yj2_i.ExportJson"}},
	["yj2_f_beiji"] = { des = "于禁2被击" ,armature = "herores/yujin/f_yj2_i.ExportJson", armaturename = "beiji",res = {"herores/yujin/f_yj2_i.ExportJson"}},
	["yj2_f_shanbi"] = { des = "于禁2闪避" ,armature = "herores/yujin/f_yj2_i.ExportJson", armaturename = "shanbi",res = {"herores/yujin/f_yj2_i.ExportJson"}},
	["yj2_f_die"] = { des = "于禁2死亡" ,armature = "herores/yujin/f_yj2_i.ExportJson", armaturename = "die",res = {"herores/yujin/f_yj2_i.ExportJson"}},
	["yj2_f_skill_1"] = { des = "于禁2技能1" ,armature = "herores/yujin/f_yj2_s_1.ExportJson", armaturename = "skill_1",res = {"herores/yujin/f_yj2_s_1.ExportJson"}},
	["yj2_f_skill_2"] = { des = "于禁2技能2" ,armature = "herores/yujin/f_yj2_s_2.ExportJson", armaturename = "skill_2",res = {"herores/yujin/f_yj2_s_2.ExportJson"}},

	["huangzu_f_entrance"] = { des = "黄祖" ,armature = "herores/huangzu/f_hz_e.ExportJson", armaturename = "entrance",res = {"herores/huangzu/f_hz_e.ExportJson","herores/huanggai/f_hg_e_1.ExportJson"}},
	["huangzu_f_idle"] = { des = "黄祖" ,armature = "herores/huangzu/f_hz_i.ExportJson", armaturename = "idle",res = {"herores/huangzu/f_hz_i.ExportJson"}},
	["huangzu_f_beiji"] = { des = "黄祖被击" ,armature = "herores/huangzu/f_hz_i.ExportJson", armaturename = "beiji",res = {"herores/huangzu/f_hz_i.ExportJson"}},
	["huangzu_f_shanbi"] = { des = "黄祖闪避" ,armature = "herores/huangzu/f_hz_i.ExportJson", armaturename = "shanbi",res = {"herores/huangzu/f_hz_i.ExportJson"}},
	["huangzu_f_die"] = { des = "黄祖死亡" ,armature = "herores/huangzu/f_hz_i.ExportJson", armaturename = "die",res = {"herores/huangzu/f_hz_i.ExportJson"}},
	["huangzu_f_skill_1"] = { des = "黄祖技能1" ,armature = "herores/huangzu/f_hz_s_1_0.ExportJson", armaturename = "skill_1",res = {"herores/huangzu/f_hz_s_1_0.ExportJson","animation/skilleffect/f_hz_s_1_1.ExportJson"}},
	["huangzu_f_skill_2"] = { des = "黄祖技能2" ,armature = "herores/huangzu/f_hz_s_2_0.ExportJson", armaturename = "skill_2",res = {"herores/huangzu/f_hz_s_2_0.ExportJson"}},

	["huangzu2_f_entrance"] = { des = "黄祖2" ,armature = "herores/huangzu/f_hz2_e.ExportJson", armaturename = "entrance",res = {"herores/huangzu/f_hz2_e.ExportJson","herores/huanggai/f_hg_e_1.ExportJson"}},
	["huangzu2_f_idle"] = { des = "黄祖2" ,armature = "herores/huangzu/f_hz2_i.ExportJson", armaturename = "idle",res = {"herores/huangzu/f_hz2_i.ExportJson"}},
	["huangzu2_f_beiji"] = { des = "黄祖2被击" ,armature = "herores/huangzu/f_hz2_i.ExportJson", armaturename = "beiji",res = {"herores/huangzu/f_hz2_i.ExportJson"}},
	["huangzu2_f_shanbi"] = { des = "黄祖2闪避" ,armature = "herores/huangzu/f_hz2_i.ExportJson", armaturename = "shanbi",res = {"herores/huangzu/f_hz2_i.ExportJson"}},
	["huangzu2_f_die"] = { des = "黄祖2死亡" ,armature = "herores/huangzu/f_hz2_i.ExportJson", armaturename = "die",res = {"herores/huangzu/f_hz2_i.ExportJson"}},
	["huangzu2_f_skill_1"] = { des = "黄祖2技能1" ,armature = "herores/huangzu/f_hz2_s_1_0.ExportJson", armaturename = "skill_1",res = {"herores/huangzu/f_hz2_s_1_0.ExportJson","animation/skilleffect/f_hz_s_1_1.ExportJson"}},
	["huangzu2_f_skill_2"] = { des = "黄祖2技能2" ,armature = "herores/huangzu/f_hz2_s_2_0.ExportJson", armaturename = "skill_2",res = {"herores/huangzu/f_hz2_s_2_0.ExportJson"}},

	["lx_f_entrance"] = { des = "陆逊" ,armature = "herores/luxun/f_lx_e.ExportJson", armaturename = "entrance",res = {"herores/luxun/f_lx_e.ExportJson",}},
	["lx_f_idle"] = { des = "陆逊" ,armature = "herores/luxun/f_lx_i.ExportJson", armaturename = "idle",res = {"herores/luxun/f_lx_i.ExportJson"}},
	["lx_f_beiji"] = { des = "陆逊被击" ,armature = "herores/luxun/f_lx_i.ExportJson", armaturename = "beiji",res = {"herores/luxun/f_lx_i.ExportJson"}},
	["lx_f_shanbi"] = { des = "陆逊闪避" ,armature = "herores/luxun/f_lx_i.ExportJson", armaturename = "shanbi",res = {"herores/luxun/f_lx_i.ExportJson"}},
	["lx_f_die"] = { des = "陆逊死亡" ,armature = "herores/luxun/f_lx_i.ExportJson", armaturename = "die",res = {"herores/luxun/f_lx_i.ExportJson"}},
	["lx_f_skill_1"] = { des = "陆逊技能1" ,armature = "herores/luxun/f_lx_s_1.ExportJson", armaturename = "skill_1",res = {"herores/luxun/f_lx_s_1.ExportJson","animation/skilleffect/f_lx_s_2_1.ExportJson"}},
	["lx_f_skill_2"] = { des = "陆逊技能2" ,armature = "herores/luxun/f_lx_s_2.ExportJson", armaturename = "skill_2",res = {"herores/luxun/f_lx_s_2.ExportJson","animation/skilleffect/f_lx_s_2_1.ExportJson"}},

	["zx_f_entrance"] = { des = "张绣" ,armature = "herores/zhangxiu/f_zx_e.ExportJson", armaturename = "entrance",res = {"herores/zhangxiu/f_zx_e.ExportJson",}},
	["zx_f_idle"] = { des = "张绣" ,armature = "herores/zhangxiu/f_zx_i.ExportJson", armaturename = "idle",res = {"herores/zhangxiu/f_zx_i.ExportJson"}},
	["zx_f_beiji"] = { des = "张绣被击" ,armature = "herores/zhangxiu/f_zx_i.ExportJson", armaturename = "beiji",res = {"herores/zhangxiu/f_zx_i.ExportJson"}},
	["zx_f_shanbi"] = { des = "张绣闪避" ,armature = "herores/zhangxiu/f_zx_i.ExportJson", armaturename = "shanbi",res = {"herores/zhangxiu/f_zx_i.ExportJson"}},
	["zx_f_die"] = { des = "张绣死亡" ,armature = "herores/zhangxiu/f_zx_i.ExportJson", armaturename = "die",res = {"herores/zhangxiu/f_zx_i.ExportJson"}},
	["zx_f_skill_1"] = { des = "张绣技能1" ,armature = "herores/zhangxiu/f_zx_s_1_0.ExportJson", armaturename = "skill_1",res = {"herores/zhangxiu/f_zx_s_1_0.ExportJson","herores/zhangxiu/f_zx_s_1_1.ExportJson",}},
	
	["zx2_f_entrance"] = { des = "张绣2" ,armature = "herores/zhangxiu/f_zx2_e.ExportJson", armaturename = "entrance",res = {"herores/zhangxiu/f_zx2_e.ExportJson",}},
	["zx2_f_idle"] = { des = "张绣2" ,armature = "herores/zhangxiu/f_zx2_i.ExportJson", armaturename = "idle",res = {"herores/zhangxiu/f_zx2_i.ExportJson"}},
	["zx2_f_beiji"] = { des = "张绣2被击" ,armature = "herores/zhangxiu/f_zx2_i.ExportJson", armaturename = "beiji",res = {"herores/zhangxiu/f_zx2_i.ExportJson"}},
	["zx2_f_shanbi"] = { des = "张绣2闪避" ,armature = "herores/zhangxiu/f_zx2_i.ExportJson", armaturename = "shanbi",res = {"herores/zhangxiu/f_zx2_i.ExportJson"}},
	["zx2_f_die"] = { des = "张绣2死亡" ,armature = "herores/zhangxiu/f_zx2_i.ExportJson", armaturename = "die",res = {"herores/zhangxiu/f_zx2_i.ExportJson"}},
	["zx2_f_skill_1"] = { des = "张绣2技能1" ,armature = "herores/zhangxiu/f_zx2_s_1_0.ExportJson", armaturename = "skill_1",res = {"herores/zhangxiu/f_zx2_s_1_0.ExportJson","herores/zhangxiu/f_zx_s_1_1.ExportJson",}},
	
	["xc_f_entrance"] = { des = "许褚" ,armature = "herores/xuchu/f_xc_e.ExportJson", armaturename = "entrance",res = {"herores/xuchu/f_xc_e.ExportJson","herores/xuchu/f_xc_e_1.ExportJson",}},
	["xc_f_idle"] = { des = "许褚" ,armature = "herores/xuchu/f_xc_i.ExportJson", armaturename = "idle",res = {"herores/xuchu/f_xc_i.ExportJson"}},
	["xc_f_beiji"] = { des = "许褚被击" ,armature = "herores/xuchu/f_xc_i.ExportJson", armaturename = "beiji",res = {"herores/xuchu/f_xc_i.ExportJson"}},
	["xc_f_shanbi"] = { des = "许褚闪避" ,armature = "herores/xuchu/f_xc_i.ExportJson", armaturename = "shanbi",res = {"herores/xuchu/f_xc_i.ExportJson"}},
	["xc_f_die"] = { des = "许褚死亡" ,armature = "herores/xuchu/f_xc_i.ExportJson", armaturename = "die",res = {"herores/xuchu/f_xc_i.ExportJson"}},
	["xc_f_skill_1"] = { des = "许褚技能1" ,armature = "herores/xuchu/f_xc_s_1_0.ExportJson", armaturename = "skill_1",res = {"herores/xuchu/f_xc_s_1_0.ExportJson","herores/xuchu/f_xc_s_1_1.ExportJson","herores/xuchu/f_xc_s_1_2.ExportJson",}},
	["xc_f_skill_2"] = { des = "许褚技能2" ,armature = "herores/xuchu/f_xc_s_2.ExportJson", armaturename = "skill_2",res = {"herores/xuchu/f_xc_s_2.ExportJson"}},

	["zb_f_entrance"] = { des = "张宝" ,armature = "herores/zhangbao/f_zb_e.ExportJson", armaturename = "entrance",res = {"herores/zhangbao/f_zb_e.ExportJson",}},
	["zb_f_idle"] = { des = "张宝" ,armature = "herores/zhangbao/f_zb_i.ExportJson", armaturename = "idle",res = {"herores/zhangbao/f_zb_i.ExportJson"}},
	["zb_f_beiji"] = { des = "张宝被击" ,armature = "herores/zhangbao/f_zb_i.ExportJson", armaturename = "beiji",res = {"herores/zhangbao/f_zb_i.ExportJson"}},
	["zb_f_shanbi"] = { des = "张宝闪避" ,armature = "herores/zhangbao/f_zb_i.ExportJson", armaturename = "shanbi",res = {"herores/zhangbao/f_zb_i.ExportJson"}},
	["zb_f_die"] = { des = "张宝死亡" ,armature = "herores/zhangbao/f_zb_i.ExportJson", armaturename = "die",res = {"herores/zhangbao/f_zb_i.ExportJson"}},
	["zb_f_skill_1"] = { des = "张宝技能1" ,armature = "herores/zhangbao/f_zb_s_1.ExportJson", armaturename = "skill_1",res = {"herores/zhangbao/f_zb_s_1.ExportJson","animation/skilleffect/zb_se_0.ExportJson",}},
	["zb_f_skill_2"] = { des = "张宝技能2" ,armature = "herores/zhangbao/f_zb_s_2_0.ExportJson", armaturename = "skill_2",res = {"herores/zhangbao/f_zb_s_2_0.ExportJson","animation/skilleffect/zb_se_0.ExportJson"}},

	["zb2_f_entrance"] = { des = "张宝2" ,armature = "herores/zhangbao/f_zb2_e.ExportJson", armaturename = "entrance",res = {"herores/zhangbao/f_zb2_e.ExportJson",}},
	["zb2_f_idle"] = { des = "张宝2" ,armature = "herores/zhangbao/f_zb2_i.ExportJson", armaturename = "idle",res = {"herores/zhangbao/f_zb2_i.ExportJson"}},
	["zb2_f_beiji"] = { des = "张宝2被击" ,armature = "herores/zhangbao/f_zb2_i.ExportJson", armaturename = "beiji",res = {"herores/zhangbao/f_zb2_i.ExportJson"}},
	["zb2_f_shanbi"] = { des = "张宝2闪避" ,armature = "herores/zhangbao/f_zb2_i.ExportJson", armaturename = "shanbi",res = {"herores/zhangbao/f_zb2_i.ExportJson"}},
	["zb2_f_die"] = { des = "张宝2死亡" ,armature = "herores/zhangbao/f_zb2_i.ExportJson", armaturename = "die",res = {"herores/zhangbao/f_zb2_i.ExportJson"}},
	["zb2_f_skill_1"] = { des = "张宝2技能1" ,armature = "herores/zhangbao/f_zb2_s_1.ExportJson", armaturename = "skill_1",res = {"herores/zhangbao/f_zb2_s_1.ExportJson","animation/skilleffect/zb_se_0.ExportJson",}},
	["zb2_f_skill_2"] = { des = "张宝2技能2" ,armature = "herores/zhangbao/f_zb2_s_2_0.ExportJson", armaturename = "skill_2",res = {"herores/zhangbao/f_zb2_s_2_0.ExportJson","animation/skilleffect/zb_se_0.ExportJson"}},

	["huangzhong_f_entrance"] = { des = "黄忠" ,armature = "herores/huangzhong/f_huangzhong_e_0.ExportJson", armaturename = "entrance",res = {"herores/huangzhong/f_huangzhong_e_0.ExportJson","herores/huangzhong/f_huangzhong_e_1.ExportJson"}},
	["huangzhong_f_idle"] = { des = "黄忠" ,armature = "herores/huangzhong/f_huangzhong_i.ExportJson", armaturename = "idle",res = {"herores/huangzhong/f_huangzhong_i.ExportJson"}},
	["huangzhong_f_beiji"] = { des = "黄忠被击" ,armature = "herores/huangzhong/f_huangzhong_i.ExportJson", armaturename = "beiji",res = {"herores/huangzhong/f_huangzhong_i.ExportJson"}},
	["huangzhong_f_shanbi"] = { des = "黄忠闪避" ,armature = "herores/huangzhong/f_huangzhong_i.ExportJson", armaturename = "shanbi",res = {"herores/huangzhong/f_huangzhong_i.ExportJson"}},
	["huangzhong_f_die"] = { des = "黄忠死亡" ,armature = "herores/huangzhong/f_huangzhong_i.ExportJson", armaturename = "die",res = {"herores/huangzhong/f_huangzhong_i.ExportJson"}},
	["huangzhong_f_skill_1"] = { des = "黄忠技能1" ,armature = "herores/huangzhong/f_huangzhong_s_1_0.ExportJson", armaturename = "skill_1",res = {"herores/huangzhong/f_huangzhong_s_1_0.ExportJson","herores/huangzhong/f_huangzhong_s_1_1.ExportJson","herores/huangzhong/f_huangzhong_s_1_2.ExportJson",}},
	["huangzhong_f_skill_2"] = { des = "黄忠技能2" ,armature = "herores/huangzhong/f_huangzhong_s_2_0.ExportJson", armaturename = "skill_2",res = {"herores/huangzhong/f_huangzhong_s_2_0.ExportJson","herores/huangzhong/f_huangzhong_s_2_1.ExportJson"}},

	["yy_f_entrance"] = { des = "严颜" ,armature = "herores/yanyan/f_yy_e.ExportJson", armaturename = "entrance",res = {"herores/yanyan/f_yy_e.ExportJson"}},
	["yy_f_idle"] = { des = "严颜" ,armature = "herores/yanyan/f_yy_i.ExportJson", armaturename = "idle",res = {"herores/yanyan/f_yy_i.ExportJson"}},
	["yy_f_beiji"] = { des = "严颜被击" ,armature = "herores/yanyan/f_yy_i.ExportJson", armaturename = "beiji",res = {"herores/yanyan/f_yy_i.ExportJson"}},
	["yy_f_shanbi"] = { des = "严颜闪避" ,armature = "herores/yanyan/f_yy_i.ExportJson", armaturename = "shanbi",res = {"herores/yanyan/f_yy_i.ExportJson"}},
	["yy_f_die"] = { des = "严颜死亡" ,armature = "herores/yanyan/f_yy_i.ExportJson", armaturename = "die",res = {"herores/yanyan/f_yy_i.ExportJson"}},
	["yy_f_skill_1"] = { des = "严颜技能1" ,armature = "herores/yanyan/f_yy_s_1_0.ExportJson", armaturename = "skill_1",res = {"herores/yanyan/f_yy_s_1_0.ExportJson",}},
	["yy_f_skill_2"] = { des = "严颜技能2" ,armature = "herores/yanyan/f_yy_s_2.ExportJson", armaturename = "skill_2",res = {"herores/yanyan/f_yy_s_2.ExportJson",}},

	["yy2_f_entrance"] = { des = "严颜2" ,armature = "herores/yanyan/f_yy2_e.ExportJson", armaturename = "entrance",res = {"herores/yanyan/f_yy2_e.ExportJson"}},
	["yy2_f_idle"] = { des = "严颜2" ,armature = "herores/yanyan/f_yy2_i.ExportJson", armaturename = "idle",res = {"herores/yanyan/f_yy2_i.ExportJson"}},
	["yy2_f_beiji"] = { des = "严颜2被击" ,armature = "herores/yanyan/f_yy2_i.ExportJson", armaturename = "beiji",res = {"herores/yanyan/f_yy2_i.ExportJson"}},
	["yy2_f_shanbi"] = { des = "严颜2闪避" ,armature = "herores/yanyan/f_yy2_i.ExportJson", armaturename = "shanbi",res = {"herores/yanyan/f_yy2_i.ExportJson"}},
	["yy2_f_die"] = { des = "严颜2死亡" ,armature = "herores/yanyan/f_yy2_i.ExportJson", armaturename = "die",res = {"herores/yanyan/f_yy2_i.ExportJson"}},
	["yy2_f_skill_1"] = { des = "严颜2技能1" ,armature = "herores/yanyan/f_yy2_s_1_0.ExportJson", armaturename = "skill_1",res = {"herores/yanyan/f_yy2_s_1_0.ExportJson",}},
	["yy2_f_skill_2"] = { des = "严颜2技能2" ,armature = "herores/yanyan/f_yy2_s_2.ExportJson", armaturename = "skill_2",res = {"herores/yanyan/f_yy2_s_2.ExportJson",}},

	---------------------------------------------------一些装饰效果--------------------------------------------------------------
	["10000"] = { des = "张角单击闪电" ,armature = "animation/skilleffect/zb_se_0.ExportJson", armaturename = "one",layer = 0 , zorder = 0,isfinishdestroy = true, x = 0, y = 0},
	["10001"] = { des = "张角入场 10001" ,armature = "herores/zhangjiao/zj_1001.ExportJson", armaturename = "Animation1",layer = 0 , zorder = 0,isfinishdestroy = true, x = 0, y = 0},
	["10002"] = { des = "物理入场地面 10002" ,armature = "herores/common/wuli_entrance_0.ExportJson", armaturename = "Animation1",layer = 0 , zorder = 0,isfinishdestroy = true, x = 0, y = 0},
	["10003"] = { des = "物理入场火焰 10003" ,armature = "herores/common/wuli_entrance_1.ExportJson", armaturename = "Animation1",layer = 1 , zorder = 0,isfinishdestroy = true, x = 0, y = 0},
	["10004"] = { des = "周瑜1技能火柱 10004" ,armature = "herores/zhouyu/f_zy_s_1_1.ExportJson", armaturename = "Animation1",layer = 1 , zorder = 0,isfinishdestroy = true, x = 0, y = 0},
	["10005"] = { des = "吕布1技能被击 10005" ,armature = "herores/lvbu/lv_10005.ExportJson", armaturename = "Animation1",layer = 1 , zorder = 0,isfinishdestroy = true, x = 0, y = 0},
	["10006"] = { des = "张角闪电群伤" ,armature = "animation/skilleffect/zj_se_0.ExportJson", armaturename = "Animation1",layer = 0 , zorder = 0,isfinishdestroy = true, x = 0, y = 0},
	["10007"] = { des = "大乔技能1底部光环" ,armature = "herores/daqiao/f_dq_s_1_2.ExportJson", armaturename = "Animation1",layer = 1 , zorder = -10,isfinishdestroy = true, x = 0, y = 0},
	["10028"] = { des = "大乔入场地面 10028" ,armature = "herores/daqiao/f_dq_e_1.ExportJson", armaturename = "Animation1",layer = 0 , zorder = 0,isfinishdestroy = true, x = 0, y = 0},
	["10030"] = { des = "黄月英入场地面 10030" ,armature = "herores/huangyueying/f_hyy_e_1.ExportJson", armaturename = "Animation1",layer = 0 , zorder = 0,isfinishdestroy = true, x = 0, y = 0},
	["10031"] = { des = "太史慈入场地面 10031" ,armature = "herores/taishici/f_tsc_e_1.ExportJson", armaturename = "Animation1",layer = 0 , zorder = 0,isfinishdestroy = true, x = 0, y = 0},
	["10032"] = { des = "夏侯渊入场地面 10032" ,armature = "herores/xiahouyuan/f_xhy_e_1.ExportJson", armaturename = "Animation1",layer = 0 , zorder = 0,isfinishdestroy = true, x = 0, y = 0},
	["10034"] = { des = "徐庶入场地面 10034" ,armature = "herores/xushu/f_xs_e_1.ExportJson", armaturename = "Animation1",layer = 0 , zorder = 0,isfinishdestroy = true, x = 0, y = 0},
	["10035"] = { des = "张颌入场地面 10035" ,armature = "herores/zhanghe/f_zh_e_1.ExportJson", armaturename = "Animation1",layer = 0 , zorder = 0,isfinishdestroy = true, x = 0, y = 0},
	["10036"] = { des = "周瑜入场地面 10036" ,armature = "herores/zhouyu/f_zy_e_1.ExportJson", armaturename = "Animation1",layer = 0 , zorder = 0,isfinishdestroy = true, x = 0, y = 0},
	["10038"] = { des = "祝融入场地面 10038" ,armature = "herores/zhurong/f_zr_e_2.ExportJson", armaturename = "Animation1",layer = 0 , zorder = 0,isfinishdestroy = true, x = 0, y = 0},
	["10041"] = { des = "黄盖入场地面 10041" ,armature = "herores/huanggai/f_hg_e_1.ExportJson", armaturename = "Animation1",layer = 0 , zorder = 0,isfinishdestroy = true, x = 0, y = 0},
	["10043"] = { des = "吕蒙入场地面 10043" ,armature = "herores/lvmeng/f_lm_e_1.ExportJson", armaturename = "Animation1",layer = 0 , zorder = 0,isfinishdestroy = true, x = 0, y = 0},
	["10044"] = { des = "吕蒙1技能地面 10044" ,armature = "herores/lvmeng/f_lm_s_1_1.ExportJson", armaturename = "Animation1",layer = 0 , zorder = 0,isfinishdestroy = true, x = 0, y = 0},
	["10046"] = { des = "文丑入场地面 10046" ,armature = "herores/wenchou/f_wc_e_1.ExportJson", armaturename = "Animation1",layer = 0 , zorder = 0,isfinishdestroy = true, x = 0, y = 0},
	["10051"] = { des = "黄祖1技能被击 10051" ,armature = "animation/skilleffect/f_hz_s_1_1.ExportJson", armaturename = "Animation1",layer = 1 , zorder = 0,isfinishdestroy = true, x = 0, y = 0},
	["10053"] = { des = "于禁入场地面 10053" ,armature = "herores/yujin/f_yj_e_2.ExportJson", armaturename = "Animation1",layer = 0 , zorder = 0,isfinishdestroy = true, x = 0, y = 0},
	["10058"] = { des = "许褚入场地面 10058" ,armature = "herores/xuchu/f_xc_e_1.ExportJson", armaturename = "Animation1",layer = 0 , zorder = 0,isfinishdestroy = true, x = 0, y = 0},
	
	---------------------------------------------------打击效果-------------------------------------------------------------
	["30001"] = { des = "打击效果1" ,armature = "animation/skilleffect/bloweffect_1.ExportJson", armaturename = "Animation1",layer = 0 , zorder = 0,isfinishdestroy = true, x = 0, y = 0},
	----------------------------------------------------buf效果-------------------------------------------------------
	["20001"] = { des = "吕蒙战意提升" ,armature = "animation/skilleffect/bufeffect_1.ExportJson", armaturename = "Animation1",layer = 0 , zorder = 0,isfinishdestroy = false, x = 0, y = 0},
	
	["guanghuang_1"] = { des = "光环 白" ,armature = "herores/common/guanghuan_white.ExportJson", armaturename = "Animation1",layer = 1 , zorder = 0,isfinishdestroy = false, x = 0, y = 0},
	["guanghuang_2"] = { des = "光环 蓝" ,armature = "herores/common/guanghuan_blue.ExportJson", armaturename = "Animation1",layer = 1 , zorder = 0,isfinishdestroy = false, x = 0, y = 0},
	["guanghuang_3"] = { des = "光环 紫" ,armature = "herores/common/guanghuan_purple.ExportJson", armaturename = "Animation1",layer = 1 , zorder = 0,isfinishdestroy = false, x = 0, y = 0},
	["guanghuang_4"] = { des = "光环 橙" ,armature = "herores/common/guanghuan_orange.ExportJson", armaturename = "Animation1",layer = 1 , zorder = 0,isfinishdestroy = false, x = 0, y = 0},

	--------------一些buf效果------------
	["b_1001"] = { des = "眩晕" ,armature = "herores/xiahouyuan/f_tsc_s_1_2.ExportJson", armaturename = "Animation1",layer = 1 , zorder = 0,isfinishdestroy = true, x = 0, y = 0},
}
