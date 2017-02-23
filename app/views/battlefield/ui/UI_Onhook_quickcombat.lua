--
-- Author: liyang
-- Date: 2015-08-13 14:56:30
-- 快速战斗
local classRichTextListView = require(FILE_PATH.PATH_VIEWS_BASE..".RichTextListView")

local UI_Onhook_quickcombat = class("UI_Onhook_quickcombat", cc.load("mvc").ViewBase)

UI_Onhook_quickcombat.RESOURCE_FILENAME = "ui_instance/battlefield/onhook_quickcombat.csb";
function UI_Onhook_quickcombat:onCreate()
    self.shadowNode = self.resourceNode_:getChildByName("shadow_layout");
    self.rootNode = self.resourceNode_:getChildByName("main_layout");
    self.infoList = self.rootNode:getChildByName("infolist");
    --提示描述
    -- self.info_describe = infoList:getChildByName("describe");
    -- --vip等级
    -- self.vipgrade = infoList:getChildByName("vipgrade");
    -- --次数
    -- self.info_count = infoList:getChildByName("count");
    self:registerEvent();
end

--设置开场动画 和 
function UI_Onhook_quickcombat:openAnimationEffect(  )

end

--注册事件
function UI_Onhook_quickcombat:registerEvent(  )
    local button_exit = self.rootNode:getChildByName("exit")
    local function exitClicked(sender)
        print("退出 ")
        self:removeFromParent();
    end
    button_exit:addClickEventListener(exitClicked);

    local infoList = self.rootNode:getChildByName("infolist");
    local button_cancel = infoList:getChildByName("cancel")
    local function cancelClicked(sender)
        print("取消 ")
        self:removeFromParent();
    end
    button_cancel:addClickEventListener(cancelClicked);

    local button_ok = infoList:getChildByName("ok")
    local function okClicked(sender)
        print("确定 ")
        dispatchGlobaleEvent( "onhook" ,"msg_quickcombat",{self.xiaohaoType});
        self:removeFromParent();
    end
    button_ok:addClickEventListener(okClicked);

end

--[[更新显示数据
    param
]]
function UI_Onhook_quickcombat:UpdateShowData( resultType )
   -- self.info_describe:setString("战斗次数: "..Data_Battle_Onhook.combatefficiency.."次/小时")
   -- self.vipgrade:setString("VIP"..MAIN_PLAYER.VIPManager.VipGrade);
   -- self.info_count:setString(Data_Battle_Onhook.quickcombat.."次")
   --判断是否有免费次数
    self.xiaohaoType = resultType;
    self.InfoText = ccui.RichText:create()
    self.InfoText:ignoreContentAdaptWithSize(false)
    self.InfoText:setContentSize(cc.size(450, 70))


    if self.xiaohaoType == 0 then
        --消耗次数
        local xiaohao_yuanbao = 20 * (Data_Battle_Onhook.QuickFightTime + 1);
        local current_yuanbao = MAIN_PLAYER.baseAttr:getYuanBao();
        local current_VIPGrade = MAIN_PLAYER.VIPManager.VipGrade;
        local shenyuTime = Data_Battle_Onhook:getQuickFightNum(  );

        -- self._neiZhengListView = classRichTextListView.new(
        --     {
        --         width = 450, 
        --         height = 70,
        --         backgroundColorType = ccui.LayoutBackGroundColorType.none
        --     }
        -- )
        -- self._neiZhengListView:setPosition(cc.p(237, 212))
        -- self.infoList:addChild(self._neiZhengListView)
        -- self._neiZhengListView:clear()
        -- local desstr = "[d=2][/]  是否花费"..xiaohao_yuanbao.."元宝快速战斗2小时?当前拥有元宝数:"..current_yuanbao.."个\n  VIP";
        -- -- self._neiZhengListView:pushString(desstr) 
        -- -- self._neiZhengListView:pushString("[d=2][/]".."快速战斗".."\n")
        -- self._neiZhengListView:pushString("[d=1][/]元宝快速战斗2小时[color=255|255|0]元宝快速战斗2小时\n元宝快速战斗2小时[/]元宝快速战斗2小时\n元宝快速战斗2小时")
        -- self._neiZhengListView:pushString("[d=1][/]\naaaaaa[color=255|255|0]bb\nbb[/]ffff\nffff\n")
        -- self._neiZhengListView:refreshView();


        local re1 = ccui.RichElementText:create(1, cc.c3b(255, 255, 255), 255, " 是否花费", "font/simhei", 30)
        local re2 = ccui.RichElementText:create(2, cc.c3b(255, 0,   0), 255, xiaohao_yuanbao.."元宝", "font/simhei", 30)
        local re3 = ccui.RichElementText:create(3, cc.c3b(255, 255, 255), 255, "快速战斗", "font/simhei", 30)
        local re4 = ccui.RichElementText:create(4, cc.c3b(255, 0,   0), 255, "2小时", "font/simhei", 30)
        local re5 = ccui.RichElementText:create(5, cc.c3b(255, 255, 255), 255, "?当前拥有元宝数:", "font/simhei", 30)
        local re6 = ccui.RichElementText:create(6, cc.c3b(255, 0,   0), 255, current_yuanbao.."个", "font/simhei", 30)
        
        self.InfoText:pushBackElement(re1)
        self.InfoText:pushBackElement(re2)
        self.InfoText:pushBackElement(re3)
        self.InfoText:pushBackElement(re4)
        self.InfoText:pushBackElement(re5)
        self.InfoText:pushBackElement(re6)
        -- self.InfoText:pushBackElement(re7)
        -- self.InfoText:pushBackElement(re8)
        -- self.InfoText:pushBackElement(re9)
        self.InfoText:setPosition(cc.p(237, 212))
        self.InfoText:setLocalZOrder(10)
        self.infoList:addChild(self.InfoText);

        local vipInfo = ccui.RichText:create()
        vipInfo:ignoreContentAdaptWithSize(false)
        vipInfo:setContentSize(cc.size(400, 34))
        local re1 = ccui.RichElementText:create(1, cc.c3b(255, 0, 0), 255, "VIP"..current_VIPGrade, "font/simhei", 30)
        local re2 = ccui.RichElementText:create(2, cc.c3b(255,  255,   255), 255, "今日剩余战斗次数", "font/simhei", 30)
        local re3 = ccui.RichElementText:create(3, cc.c3b(255, 0, 0), 255, shenyuTime.."次", "font/simhei", 30)

        vipInfo:pushBackElement(re1)
        vipInfo:pushBackElement(re2)
        vipInfo:pushBackElement(re3)

        vipInfo:setPosition(cc.p(237, 140))
        vipInfo:setLocalZOrder(10)
        self.infoList:addChild(vipInfo);
    else
        local daojuCount = MAIN_PLAYER.goodsManager:getCount(10008);
        local re1 = ccui.RichElementText:create(1, cc.c3b(255, 255, 255), 255, "    是否消耗1个道具", "font/simhei", 30)
        local re2 = ccui.RichElementText:create(2, cc.c3b(255, 0,   0), 255, "快速战斗令", "font/simhei", 30)
        local re3 = ccui.RichElementText:create(3, cc.c3b(255, 255, 255), 255, "进行快速战斗", "font/simhei", 30)
        local re4 = ccui.RichElementText:create(4, cc.c3b(255, 0,   0), 255, "30分钟", "font/simhei", 30)
        local re5 = ccui.RichElementText:create(5, cc.c3b(255, 255, 255), 255, "?当前拥有令牌数:", "font/simhei", 30)
        local re6 = ccui.RichElementText:create(6, cc.c3b(255, 0,   0), 255, daojuCount.."个", "font/simhei", 30)
        self.InfoText:pushBackElement(re1)
        self.InfoText:pushBackElement(re2)
        self.InfoText:pushBackElement(re3)
        self.InfoText:pushBackElement(re4)
        self.InfoText:pushBackElement(re5)
        self.InfoText:pushBackElement(re6)
        self.InfoText:setPosition(cc.p(237, 200))
        self.InfoText:setLocalZOrder(10)
        self.infoList:addChild(self.InfoText);
    end
end


return UI_Onhook_quickcombat


