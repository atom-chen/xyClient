--
-- Author: LiYang
-- Date: 2015-06-25 18:38:35
--
import(".ui_templeate.skill_icon")
import(".ui_templeate.hero_icon_large")
import(".prompt.promptevent_logic_ResumeConnect").new();

UIManager = {}

--[[创建加载界面
	params = {
		mark = "",界面类型标示 次为必填项 在全局关闭事件中 需要次参数
		content = "",描述文字
		eventlogic = "",--绑定逻辑
		eventlist = "",注册事件列表
		islistenclick = ,--是否监听按键事件
		timer = ,--计时器
		fininshCallBack = nil;--完成回调函数
	}
]]
function UIManager:CreatePrompt_Wait( params )
	local view = require("app.views.prompt.UI_Prompt_Wait").new();
	view:setPosition(cc.p(display.cx,display.cy))
	view:setData(params);
	APP:getCurScene():addChildToLayer(LAYER_ID_NOTICE, view)
	-- display.getRunningScene().rootview:addChildToLayer(LAYER_ID_NOTICE, view)
	return view;
end

--[[创建加载界面
	params = {
        mark = "",界面类型标示 次为必填项 在全局关闭事件中 需要次参数
        content = "",描述文字
        event_click = "",点击逻辑事件监听
        event_timer = nil,计数器监听
        timer = ,--计时器
        fininshCallBack = nil;--完成回调函数
    }
]]
function UIManager:CreatePrompt_Wait_0( params )
	local view = require("app.views.prompt.UI_Prompt_Wait_0").new();
	view:setPosition(cc.p(display.cx,display.cy))
	view:setData(params);
	APP:getCurScene():addChildToLayer(LAYER_ID_RESUME_CONNECT, view)
	return view;
end

--[[创建通用提示条
	params = {
        mark = "",界面类型标示
        title = "",标题
        content = "",描述文字
        eventlogic = "",--绑定逻辑
        eventlist = "",注册事件列表
        listenButton = function ( result )
			-- 1 表示选择1按钮 2表示选择按钮
		end
    }

]]

function UIManager:CreatePrompt_Operate( params )
	local view = require("app.views.prompt.UI_Prompt_Operate").new();
	view:setPosition(cc.p(display.cx,display.cy))
	view:setData(params);
	APP:getCurScene():addChildToLayer(LAYER_ID_NOTICE, view)
	-- display.getRunningScene().rootview:addChildToLayer(LAYER_ID_NOTICE, view)
	return view;
end

--[[创建通用提示条
	params = {
        mark = "",界面类型标示
        title = "",标题
        content = "",描述文字
        listenButton = function ( result )
			-- 1 表示选择1按钮 2表示选择按钮
		end
    }

]]

function UIManager:CreatePrompt_Operate_1( params )
	local view = require("app.views.prompt.UI_Prompt_Operate_1.lua").new();
	view:setPosition(cc.p(display.cx,display.cy))
	view:setData(params);
	APP:getCurScene():addChildToLayer(LAYER_ID_NOTICE, view)
	-- display.getRunningScene().rootview:addChildToLayer(LAYER_ID_NOTICE, view)
	return view;
end


--创建网络消息错误描述对话框
function UIManager:CreatePrompt_NetMsgErrorDescribe(errorDescribeKey)
	self:CreateSamplePrompt(getErrorDescribe( errorDescribeKey ))
end


--创建简单的对话框
function UIManager:CreateSamplePrompt(str)
	UIManager:CreatePrompt_Operate( {
        title = "提示",
        content = str
	} )
end


--[[创建通用操作提示框
	params = {
		content = "",描述文字
	}
]]
function UIManager:CreatePrompt_Bar( params )
	local view = require("app.views.prompt.UI_Prompt_Bar").new();
	view:setPosition(cc.p(display.cx,display.cy))
	view:setData(params);
	APP:getCurScene():addChildToLayer(LAYER_ID_NOTICE, view)
	-- display.getRunningScene().rootview:addChildToLayer(LAYER_ID_NOTICE, view)
	return view;
end

--[[创建重连界面
	params = {
		mark = "",界面类型标示
		content = "",描述文字
		event = "",--注册逻辑事件
		islistenclick = ,--是否监听按键事件
		timer = ,--计时器
		fininshCallBack = nil;--完成回调函数
	}
]]
function UIManager:CreatePrompt_ResumeConnect(  )
	local view = require("app.views.prompt.UI_Prompt_Wait").new();
	view:setPosition(cc.p(display.cx,display.cy))
	view:setData({
		mark = "ResumeConnect",
		content = "请稍等正在拼命连接服务器",
		eventlogic = "app.views.prompt.promptevent_logic_ResumeConnect",--注册逻辑事件
		islistenclick = true,--是否监听按键事件
		});
	APP:getCurScene():addChildToLayer(LAYER_ID_NOTICE, view)
	-- display.getRunningScene().rootview:addChildToLayer(LAYER_ID_NOTICE, view)
	return view;
end

--[[创建战斗切换等待界面
	params = {
		mark = "",界面类型标示
		content = "",描述文字
		event = "",--注册逻辑事件
		islistenclick = ,--是否监听按键事件
		timer = ,--计时器
		fininshCallBack = nil;--完成回调函数
	}
]]
function UIManager:CreatePrompt_BattleConnect(  )
	local view = require("app.views.prompt.UI_Prompt_BattleRes_Load").new();
	view:setPosition(cc.p(-640,-360))
	view:setData({
		mark = "loadbattleres",
		content = "请稍等战场切换正在拼命加载资源...",
		-- eventlogic = "app.views.prompt.PromptEvent_logic_loadbattleres",--注册逻辑事件
		});
	-- APP:getCurScene():addChildToLayer(LAYER_ID_NOTICE, view)
	return view;
end

--创建资源加载界面
function UIManager:CreatePrompt_BattleResLoad(  )
	local view = require("app.views.prompt.UI_Prompt_BattleRes_Load").new();
	view:setPosition(cc.p(-640,-360))
	view:setData({
		mark = "loadbattleres",
		content = "请稍等战场切换正在拼命加载资源...",
		-- eventlogic = "app.views.prompt.PromptEvent_logic_loadbattleres",--注册逻辑事件
		});
	-- APP:getCurScene():addChildToLayer(LAYER_ID_NOTICE, view)
	return view;
end

--创建卡牌icon
--params.resourceNode 已经创建好的资源节点
UIManager.avatarModel = cc.CSLoader:createNode("ui_templeate/icon/hero_icon.csb")
UIManager.avatarModel:retain()
function UIManager:CreateAvatarPart( id, params )
	local view = require("app.views.ui_templeate.hero_icon.lua").new(params);
	view:setAvatarByHeroID(id);
	return view;
end

--创建卡牌icon大头像
--params.resourceNode 已经创建好的资源节点
UIManager.avatarLargeModel = cc.CSLoader:createNode("ui_templeate/icon/hero_icon_large.csb")
UIManager.avatarLargeModel:retain()
function UIManager:CreateAvatarLargePart( id, params )
	local view = require("app.views.ui_templeate.hero_icon_large.lua").new(params);
	view:setAvatarByHeroID(id);
	return view;
end

--创建装备
--params.resourceNode 已经创建好的资源节点
UIManager.equipModel = cc.CSLoader:createNode("ui_templeate/icon/equip_icon.csb")
UIManager.equipModel:retain()
function UIManager:CreateEquipAvatarPart( id, params )
	local view = require("app.views.ui_templeate.equip_icon.lua").new(params);
	view:setAvatarByID(id);
	return view;
end

--创建道具
--params.resourceNode 已经创建好的资源节点
UIManager.goodsModel = cc.CSLoader:createNode("ui_templeate/icon/goods_icon.csb")
UIManager.goodsModel:retain()
function UIManager:createGoodsAvatarPart( id, params )
	local view = require("app.views.ui_templeate.goods_icon.lua").new(params);
	view:setAvatarByID(id);
	return view;
end

--[[ 创建掉落部件图标
	parttype 类型
	id 模板id
]]
function UIManager:CreateDropOutFrame( parttype , id )
	local partview = nil;
	if parttype == eDT_Card or parttype == "卡片" then
		--卡片
		partview = UIManager:CreateAvatarPart( id );
		print("整卡")
	elseif parttype == "大卡片" then
		--大卡片
		partview = UIManager:CreateAvatarLargePart( id );
	elseif parttype == eDT_CardPiece or parttype == "碎片" then
		--碎片
		if id == 0 then -- 0为万能碎片, 现在没有了

		else
			partview = UIManager:CreateAvatarPart( id )
			print("碎片")
			partview:isFragment(true)
		end
	elseif parttype == eDT_Equip or parttype == "装备" then
		--装备
		-- partview = UIManager:CreateEquipIconPart( id );
		partview = UIManager:CreateEquipAvatarPart( id );
	elseif parttype == eDT_EquipPiece or parttype == "装备碎片" then
		--装备
		-- partview = UIManager:CreateEquipPiecePart( id );
		partview = UIManager:CreateEquipAvatarPart( id );
		partview:setIsFragment(true);
	elseif parttype == eDT_Item or parttype == "道具" then
		--道具
		partview = UIManager:createGoodsAvatarPart( id );
	elseif parttype == eDT_Gold or parttype == "银两" then
		--银两
		partview = UIManager:createGoodsAvatarPart(11013)
	elseif parttype == eDT_YuanBao or parttype == "元宝" then
		--元宝
		partview = UIManager:createGoodsAvatarPart(11015)
	elseif parttype == eDT_PlayerExp or parttype == "经验" then
		--经验
		partview = UIManager:createGoodsAvatarPart(11006)
		
	elseif parttype == eDT_VipExp or parttype == "vip经验" then
		--VIP经验
		partview = UIManager:createGoodsAvatarPart(11001)
	elseif parttype == eDT_Stamina or parttype == "体力" then
		--体力
		partview = UIManager:createGoodsAvatarPart(11003)
	elseif parttype == eDT_Vigour or parttype == "精力" then
		--精力
		partview = UIManager:createGoodsAvatarPart(11002)
	elseif parttype == eDT_JiangHun or parttype == "将魂" then
		--将魂
		partview = UIManager:createGoodsAvatarPart(11005)
	elseif parttype == eDT_Shiqi or parttype == "士气" then
		--士气
		partview = UIManager:createGoodsAvatarPart(11009)
	elseif parttype == eDT_GongXun or parttype == "功勋" then
		--功勋
		partview = UIManager:createGoodsAvatarPart(11019)
	elseif parttype == eDT_HeroExp or parttype == "经验池" then
		--经验池
		partview = UIManager:createGoodsAvatarPart(11023)
	elseif parttype == eDT_PeerageExp or parttype == "爵位经验" then
		--爵位经验
		partview = UIManager:createGoodsAvatarPart(11023)
	elseif parttype == "空白" then
		--空白
		partview = UIManager:createGoodsAvatarPart(11024)

	elseif parttype == eDT_SmeltValue or parttype == "熔炼值" then
		--熔炼值
		partview = UIManager:createGoodsAvatarPart(11025)
	else
		--todo
		print("未知类型"..parttype)
		return nil
	end
	return partview;
end

-- 得到掉落的名字
function UIManager:createDropName(parttype, id)
	if parttype == eDT_Card then
		return heroConfig[id].name
	elseif parttype == eDT_CardPiece then
		return heroConfig[id].name.."碎片"
	elseif parttype == eDT_Equip then
		return EquipConfig[id].name
	elseif parttype == eDT_EquipPiece then
		return EquipConfig[id].name.."碎片"
	elseif parttype == eDT_Item then
		return ItemsConfig[id].name
	elseif parttype == eDT_Gold then
		return "银两"
	elseif parttype == eDT_YuanBao then
		return "元宝"
	elseif parttype == eDT_PlayerExp then
		return "经验"
	elseif parttype == eDT_VipExp then
		return "VIP经验"
	elseif parttype == eDT_Stamina then
		return "体力"
	elseif parttype == eDT_Vigour then
		return "精力"
	elseif parttype == eDT_JiangHun then
		return "将魂"
	elseif parttype == eDT_Shiqi then
		return "士气"
	elseif parttype == eDT_GongXun then
		return "功勋"
	elseif parttype == eDT_HeroExp then
		return "经验"
	elseif parttype == eDT_PeerageExp then
		return "爵位经验"
	elseif parttype == eDT_SmeltValue then
		return "熔炼值"
	end
	print("未知类型"..parttype)
	return ""
end

--[[ 创建掉落部件信息界面
	parttype 类型
	id 模板id
]]
function UIManager:CreateDropOutFrame_News( parttype , id )
	local partview = nil;
	if parttype == eDT_Card or parttype == "卡片" or parttype == eDT_CardPiece or parttype == "碎片" then
		--卡片
		local hero = require("app.data.hero").new()
		hero.curLv = 1
		hero.templeateID = id
		hero.fixProperty = heroConfig[id]
		hero.baseHP = hero.fixProperty.base_hp
		hero.baseAtt = hero.fixProperty.base_atk
		partview = UIManager:CreateHeroNews(display.getRunningScene(), hero)
	elseif parttype == eDT_Equip or parttype == "装备" or parttype == eDT_EquipPiece or parttype == "装备碎片" then
		--装备
		local equipment = require("app.data.equipment").new()
		equipment.level = 0
		equipment.id = id
		equipment = user.player.equManager:createEquip(equipment)
		equipment.guid = G_NULL["GUID"]
		partview = UIManager:createEquipmentInfo(display.getRunningScene() , equipment, 1);
	elseif parttype == eDT_Item or parttype == "道具" then
		--道具
		partview = import("app.ui.UI_DaojuPage.lua"):new()
		partview:setData(id)
		display.getRunningScene():addChild(partview,UI_ORDERCONST_TOP_DIALOG);
		partview:setPosition(ccp(display.cx, display.cy));
		partview:ColoseSourceJumpToButton();
	elseif parttype == eDT_Gold or parttype == "银两" then
		--银两
		
	elseif parttype == eDT_YuanBao or parttype == "元宝" then
		--元宝
		
	elseif parttype == eDT_PlayerExp or parttype == "经验" then
		--经验
		
		
	elseif parttype == eDT_VipExp or parttype == "vip经验" then
		--VIP经验
		
	elseif parttype == eDT_Stamina or parttype == "体力" then
		--体力
		
	elseif parttype == eDT_Vigour or parttype == "精力" then
		--精力
		
	elseif parttype == eDT_JiangHun or parttype == "将魂" then
		--将魂
		
	elseif parttype == eDT_Shiqi or parttype == "士气" then
		--士气
		
	else
		
	end
	return partview;
end

-- 获得物品提示
function UIManager:createGoodsGet(data)
	-- body
	local view = import("app.views.gameWorld.goods.goods_get.goods_get"):new()
	view:update(data)
	view:setPosition(cc.p(display.cx,display.cy))
	APP:getCurScene():addChildToLayer(LAYER_ID_NOTICE, view)
end

-- 创建阵型icon控制器
function UIManager:createFormationIconControler()
	return require("app.views.ui_templeate.formation_icon").new()
end


-- 邮件内容展示
function UIManager:createMailDialog(data)
	-- body
	local view = import("app.views.gameWorld.mail.mail_dialog"):new()
	view:update(data)
	APP:getCurScene():addChildToLayer(LAYER_ID_NOTICE, view)
end

-- 点击好友提示
function UIManager:createFriendsDialog(data)
	-- body
	local view = import("app.views.gameWorld.friends2.friends_dialog"):new()
	view:update(data)
	view:setPosition(cc.p(display.cx,display.cy))
	APP:getCurScene():addChildToLayer(LAYER_ID_NOTICE, view)
end
function UIManager:createFriendsInviteDialog(data)
	-- body
	local view = import("app.views.gameWorld.friends.friends_invite_dialog"):new()
	view:update(data)
	view:setPosition(cc.p(display.cx,display.cy))
	APP:getCurScene():addChildToLayer(LAYER_ID_NOTICE, view)
end

-- 发送邮件
function UIManager:createFriendsMailDialog(data)
	-- body
	local view = import("app.views.gameWorld.friends2.friends_send_mail"):new()
	view:update(data)
	view:setPosition(cc.p(display.cx,display.cy))
	APP:getCurScene():addChildToLayer(LAYER_ID_NOTICE, view)
end

-- 世界boss信息
function UIManager:createBossDialog(k)
	-- body
	local view = import("app.views.gameWorld.trial.trial_boss_dialog"):new()
	view:update(k)
	view:setPosition(cc.p(display.cx,display.cy))
	APP:getCurScene():addChildToLayer(LAYER_ID_NOTICE, view)
end

-- 招募信息
function UIManager:createZhaomuDialog(params)
	-- body
	local view = import("app.views.gameWorld.heros.heros_zhaomu_dialog").new(params)
	view:getResourceNode():setPosition(cc.p(display.cx,display.cy))
	APP:getCurScene():addChildToLayer(LAYER_ID_NOTICE, view:getResourceNode())
end

-- 装备信息
function UIManager:createEquipDialog(data, duiwu)
	-- body
	local view = import("app.views.gameWorld.backpack.backpack_equip_dialog"):new()
	view:update(data)
	view:duiwu(duiwu)
	view:setPosition(cc.p(display.cx,display.cy))
	APP:getCurScene():addChildToLayer(LAYER_ID_NOTICE, view)

	return view
end


-- 道具信息
function UIManager:createGoodsDialog(data)
	-- body
	local view = import("app.views.gameWorld.backpack.backpack_goods_dialog"):new()
	view:update(data)
	view:setPosition(cc.p(display.cx,display.cy))
	APP:getCurScene():addChildToLayer(LAYER_ID_NOTICE, view)
end

-- 道具出售数量
function UIManager:createGoodsSaleDialog(data)
	-- body
	local view = import("app.views.gameWorld.backpack.backpack_goods_sale_dialog"):new()
	view:update(data)
	view:setPosition(cc.p(display.cx,display.cy))
	APP:getCurScene():addChildToLayer(LAYER_ID_NOTICE, view)
end

-- 武将筛选
function UIManager:createWujiangScreenDialog()
	-- body
	local view = import("app.views.gameWorld.wujiang.wujiang_screen"):new()
	view:setPosition(cc.p(display.cx,display.cy))
	APP:getCurScene():addChildToLayer(LAYER_ID_NOTICE, view)
end

-- Choose武将筛选
function UIManager:createChooseScreenDialog()
	-- body
	local view = import("app.views.gameWorld.choose.hero_screen"):new()
	view:setPosition(cc.p(display.cx,display.cy))
	APP:getCurScene():addChildToLayer(LAYER_ID_NOTICE, view)
end

-- 图鉴查看
function UIManager:createAtlasDialog(data)
	-- body
	local view = import("app.views.gameWorld.wujiang.atlas_dialog"):new()
	view:update(data)
	view:setPosition(cc.p(display.cx,display.cy))
	APP:getCurScene():addChildToLayer(LAYER_ID_NOTICE, view)
end



-- 装备筛选
function UIManager:createEquipScreenDialog()
	-- body
	local view = import("app.views.gameWorld.backpack.equip_screen"):new()
	view:setPosition(cc.p(display.cx,display.cy))
	APP:getCurScene():addChildToLayer(LAYER_ID_NOTICE, view)
end

-- 查看好友阵型
function UIManager:createFriendTeamDialog(data)
	-- body
	local view = import("app.views.gameWorld.friends2.team.teamUI"):new()
	view:update(data)
	view:setPosition(cc.p(display.cx,display.cy))
	APP:getCurScene():addChildToLayer(LAYER_ID_NOTICE, view)
end


-- 奇遇储存数据
function UIManager:QiyuSave(data)
	-- body
	UIManager.qiyu = data
end

-- 奇遇储存显示
function UIManager:QiyuDisplay()
	-- body
	if UIManager.qiyu == nil then
		return
	end
	local view = import("app.views.gameWorld.goods.goods_get.goods_get"):new()
	view:update(UIManager.qiyu)
	view:setPosition(cc.p(display.cx,display.cy))
	APP:getCurScene():addChildToLayer(LAYER_ID_NOTICE, view)
end

