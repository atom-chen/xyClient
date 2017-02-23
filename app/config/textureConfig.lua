--
-- Author: LiYang
-- Date: 2015-07-21 16:45:48
-- 次配置为有需要才添加 默认为 cc.TEXTURE2_D_PIXEL_FORMAT_BGR_A8888
-- cc.Texture2D:setDefaultAlphaPixelFormat(cc.TEXTURE2D_PIXEL_FORMAT_RGBA8888)

-- cc.TEXTURE2_D_PIXEL_FORMAT_RGB_A8888
-- cc.TEXTURE2_D_PIXEL_FORMAT_RGB_A4444
-- cc.TEXTURE2_D_PIXEL_FORMAT_RG_B565

GOLBAL_DEFAULT_PIXELFORMAT = cc.TEXTURE2_D_PIXEL_FORMAT_RGB_A8888;

function setTextureDefaultPixelFormat( format )
	GOLBAL_DEFAULT_PIXELFORMAT = format;
end

function getTexturePixelFormat( index )
	local format = textureConfig[index];

	if not format then
		format = GOLBAL_DEFAULT_PIXELFORMAT;
	else
		format = textureConfig[index].PixelFormat
	end
	return format;
end

textureConfig = {
	-----------------------------------------------
	["herores/zhangjiao/zj_font_e.png"] = {PixelFormat = cc.TEXTURE2_D_PIXEL_FORMAT_RGB_A8888},
	["herores/zhangjiao/zj_font_idle.png"] = {PixelFormat = cc.TEXTURE2_D_PIXEL_FORMAT_RGB_A8888},
	["herores/zhangjiao/zj_1001.png"] = {PixelFormat = cc.TEXTURE2_D_PIXEL_FORMAT_RGB_A8888},
	["herores/guanyu/f_gy_i.png"] = {PixelFormat = cc.TEXTURE2_D_PIXEL_FORMAT_RGB_A8888},
	["herores/zhouyu/f_zy_i.png"] = {PixelFormat = cc.TEXTURE2_D_PIXEL_FORMAT_RGB_A8888},
	["herores/zhouyu/f_zy_s_2_0_3.png"] = {PixelFormat = cc.TEXTURE2_D_PIXEL_FORMAT_RGB_A8888},
	["herores/zhouyu/f_zy_s_1_0_1.png"] = {PixelFormat = cc.TEXTURE2_D_PIXEL_FORMAT_RGB_A8888},
	["herores/lvbu/f_lv_i.png"] = {PixelFormat = cc.TEXTURE2_D_PIXEL_FORMAT_RGB_A8888},
	["herores/xiahouyuan/f_xhy_i.png"] = {PixelFormat = cc.TEXTURE2_D_PIXEL_FORMAT_RGB_A8888},
	["herores/xiahouyuan/f_xhy_s_2_1_0.png"] = {PixelFormat = cc.TEXTURE2_D_PIXEL_FORMAT_RGB_A8888},
	["herores/taishici/f_tsc_i.png"] = {PixelFormat = cc.TEXTURE2_D_PIXEL_FORMAT_RGB_A8888},
	["herores/taishici/f_tsc_s_2_1_0.png"] = {PixelFormat = cc.TEXTURE2_D_PIXEL_FORMAT_RGB_A8888},
	["herores/taishici/f_tsc_s_2_1_1.png"] = {PixelFormat = cc.TEXTURE2_D_PIXEL_FORMAT_RGB_A8888},
	["map/game_back_7.png"] = {PixelFormat = cc.TEXTURE2_D_PIXEL_FORMAT_RG_B565},
	["herores/daqiao/f_dq_i.png"] = {PixelFormat = cc.TEXTURE2_D_PIXEL_FORMAT_RGB_A8888},
	["herores/fazheng/f_fz_i.png"] = {PixelFormat = cc.TEXTURE2_D_PIXEL_FORMAT_RGB_A8888},
	["herores/fazheng/f_fz_s_1_0_1.png"] = {PixelFormat = cc.TEXTURE2_D_PIXEL_FORMAT_RGB_A8888},
	["herores/fazheng/f_fz_s_1_0_2.png"] = {PixelFormat = cc.TEXTURE2_D_PIXEL_FORMAT_RGB_A8888},
	["herores/fazheng/f_fz_s_1_0_3.png"] = {PixelFormat = cc.TEXTURE2_D_PIXEL_FORMAT_RGB_A8888},
	["herores/fazheng/f_fz_s_1_0_4.png"] = {PixelFormat = cc.TEXTURE2_D_PIXEL_FORMAT_RGB_A8888},
	["herores/fazheng/f_fz_s_1_0_5.png"] = {PixelFormat = cc.TEXTURE2_D_PIXEL_FORMAT_RGB_A8888},
	["herores/fazheng/f_fz_s_2_0_1.png"] = {PixelFormat = cc.TEXTURE2_D_PIXEL_FORMAT_RGB_A8888},
	["herores/fazheng/f_fz_s_2_0_2.png"] = {PixelFormat = cc.TEXTURE2_D_PIXEL_FORMAT_RGB_A8888},
	["herores/huangyueying/f_hyy_i.png"] = {PixelFormat = cc.TEXTURE2_D_PIXEL_FORMAT_RGB_A8888},
	["herores/huangyueying/f_hyy_s_2_0_1.png"] = {PixelFormat = cc.TEXTURE2_D_PIXEL_FORMAT_RGB_A8888},
	["herores/huangyueying/f_hyy_s_2_0_2.png"] = {PixelFormat = cc.TEXTURE2_D_PIXEL_FORMAT_RGB_A8888},
	["herores/huangyueying/f_hyy_s_2_0_3.png"] = {PixelFormat = cc.TEXTURE2_D_PIXEL_FORMAT_RGB_A8888},
	["herores/huangyueying/f_hyy_s_2_0_4.png"] = {PixelFormat = cc.TEXTURE2_D_PIXEL_FORMAT_RGB_A8888},
	["herores/huangyueying/f_hyy_s_2_0_5.png"] = {PixelFormat = cc.TEXTURE2_D_PIXEL_FORMAT_RGB_A8888},
	["herores/huangyueying/f_hyy_s_2_0_6.png"] = {PixelFormat = cc.TEXTURE2_D_PIXEL_FORMAT_RGB_A8888},
	["herores/zhanghe/f_zh_i.png"] = {PixelFormat = cc.TEXTURE2_D_PIXEL_FORMAT_RGB_A8888},
	["herores/zhanghe/f_zh_e_3.png"] = {PixelFormat = cc.TEXTURE2_D_PIXEL_FORMAT_RGB_A8888},
	["herores/zhenji/f_zj_i.png"] = {PixelFormat = cc.TEXTURE2_D_PIXEL_FORMAT_RGB_A8888},
	["herores/zhenji/f_zj_e_1.png"] = {PixelFormat = cc.TEXTURE2_D_PIXEL_FORMAT_RGB_A8888},
	["herores/zhurong/f_zr_i.png"] = {PixelFormat = cc.TEXTURE2_D_PIXEL_FORMAT_RGB_A8888},
	["herores/huanggai/f_hg_i.png"] = {PixelFormat = cc.TEXTURE2_D_PIXEL_FORMAT_RGB_A8888},
	["herores/lvmeng/f_lm_i.png"] = {PixelFormat = cc.TEXTURE2_D_PIXEL_FORMAT_RGB_A8888},
	["herores/lvmeng/f_lm_e_2.png"] = {PixelFormat = cc.TEXTURE2_D_PIXEL_FORMAT_RGB_A8888},
	["herores/wenchou/f_wc_i.png"] = {PixelFormat = cc.TEXTURE2_D_PIXEL_FORMAT_RGB_A8888},
	["herores/zhangzhao/f_zz_i.png"] = {PixelFormat = cc.TEXTURE2_D_PIXEL_FORMAT_RGB_A8888},
	["herores/zhangzhao/f_zz_e_1.png"] = {PixelFormat = cc.TEXTURE2_D_PIXEL_FORMAT_RGB_A8888},
	["herores/huangzhong/f_hz_i.png"] = {PixelFormat = cc.TEXTURE2_D_PIXEL_FORMAT_RGB_A8888},
	["herores/luxun/f_lx_i.png"] = {PixelFormat = cc.TEXTURE2_D_PIXEL_FORMAT_RGB_A8888},
	["herores/sunshangxiang/f_ssx_i.png"] = {PixelFormat = cc.TEXTURE2_D_PIXEL_FORMAT_RGB_A8888},
	["herores/xuchu/f_xc_i.png"] = {PixelFormat = cc.TEXTURE2_D_PIXEL_FORMAT_RGB_A8888},
	["herores/yanyan/f_yy_i.png"] = {PixelFormat = cc.TEXTURE2_D_PIXEL_FORMAT_RGB_A8888},
	["herores/zhangbao/f_zb_i.png"] = {PixelFormat = cc.TEXTURE2_D_PIXEL_FORMAT_RGB_A8888},
	["herores/zhangxiu/f_zx_i.png"] = {PixelFormat = cc.TEXTURE2_D_PIXEL_FORMAT_RGB_A8888},
	["herores/tianfeng/f_tf_i.png"] = {PixelFormat = cc.TEXTURE2_D_PIXEL_FORMAT_RGB_A8888},
	["herores/yujin/f_yj_i.png"] = {PixelFormat = cc.TEXTURE2_D_PIXEL_FORMAT_RGB_A8888},
	["herores/huangzhong/f_hz_s_2_0_1.png"] = {PixelFormat = cc.TEXTURE2_D_PIXEL_FORMAT_RGB_A8888},
	["herores/huangzhong/f_hz_s_2_0_2.png"] = {PixelFormat = cc.TEXTURE2_D_PIXEL_FORMAT_RGB_A8888},
	["herores/gongsunzan/f_gsz_i.png"] = {PixelFormat = cc.TEXTURE2_D_PIXEL_FORMAT_RGB_A8888},
	["herores/gongsunzan2/f_gsz2_i.png"] = {PixelFormat = cc.TEXTURE2_D_PIXEL_FORMAT_RGB_A8888},
	["herores/huangzu2/f_hz2_i.png"] = {PixelFormat = cc.TEXTURE2_D_PIXEL_FORMAT_RGB_A8888},
	["herores/yanyan2/f_yy2_i.png"] = {PixelFormat = cc.TEXTURE2_D_PIXEL_FORMAT_RGB_A8888},
	["herores/yujin2/f_yj2_i.png"] = {PixelFormat = cc.TEXTURE2_D_PIXEL_FORMAT_RGB_A8888},
	["herores/zhangbao2/f_zb2_i.png"] = {PixelFormat = cc.TEXTURE2_D_PIXEL_FORMAT_RGB_A8888},
	["herores/zhangxiu2/f_zx2_i.png"] = {PixelFormat = cc.TEXTURE2_D_PIXEL_FORMAT_RGB_A8888},
	["animation/battle/lose_4.png"] = {PixelFormat = cc.TEXTURE2_D_PIXEL_FORMAT_RGB_A8888},
	["animation/battle/win_3.png"] = {PixelFormat = cc.TEXTURE2_D_PIXEL_FORMAT_RGB_A8888},

	["ui_image/mainpage/anim/zhanyi/zy1/effect_zhanyi1.png"] = {PixelFormat = cc.TEXTURE2_D_PIXEL_FORMAT_RGB_A4444},
	["ui_image/mainpage/anim/zhanyi/zy1/effect_zhanyi1_mengban.png"] = {PixelFormat = cc.TEXTURE2_D_PIXEL_FORMAT_A8},
	["ui_image/mainpage/anim/zhanyi/zy2/effect_zhanyi2.png"] = {PixelFormat = cc.TEXTURE2_D_PIXEL_FORMAT_RG_B565},
	["ui_image/mainpage/anim/zhanyi/zy2/zhanyi2_mengban.png"] = {PixelFormat = cc.TEXTURE2_D_PIXEL_FORMAT_A8},
	["ui_image/mainpage/anim/zhanyi/zy3/effect_zhanyi3.png"] = {PixelFormat = cc.TEXTURE2_D_PIXEL_FORMAT_RGB_A4444},
	["ui_image/mainpage/anim/zhanyi/zy3/effect_zhanyi3_mengban.png"] = {PixelFormat = cc.TEXTURE2_D_PIXEL_FORMAT_A8},
}

