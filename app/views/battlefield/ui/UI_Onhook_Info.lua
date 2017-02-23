--
-- Author: liyang
-- Date: 2015-08-13 14:56:30
-- 挂机信息


local UI_Onhook_Info = class("UI_Onhook_Info", cc.load("mvc").ViewBase)

UI_Onhook_Info.RESOURCE_FILENAME = "ui_instance/battlefield/onhook_info.csb"
function UI_Onhook_Info:onCreate()
    self.shadowNode = self.resourceNode_:getChildByName("shadow_layout");

    self.rootNode = self.resourceNode_:getChildByName("main_layout");

    local infoList = self.rootNode:getChildByName("infolist");
    --战斗次数
    self.info_fficiency = infoList:getChildByName("fficiency");

    --升级时间
    self.info_upgradetime = infoList:getChildByName("upgradetime");

    --平均用时
    self.info_time = infoList:getChildByName("time");

    --活动禁用
    self.info_exp = infoList:getChildByName("exp");

    --获得金币
    self.info_gold = infoList:getChildByName("gold");


    self:registerEvent();
end

--设置开场动画 和 
function UI_Onhook_Info:openAnimationEffect(  )

end

--注册事件
function UI_Onhook_Info:registerEvent(  )
    local button_exit = self.rootNode:getChildByName("exit")
    local function exitClicked(sender)
        print("退出 ")
        self:removeFromParent();
    end
    button_exit:addClickEventListener(exitClicked);

end

--[[更新显示数据
    param
]]
function UI_Onhook_Info:UpdateShowData(  )
   self.info_fficiency:setString("战斗次数: "..Data_Battle_Onhook.combatefficiency.."次/小时")
   local upgradeExp = MAIN_PLAYER:getBaseAttr():getToNextLvNeedExp();
   local time = math.ceil(upgradeExp / Data_Battle_Onhook.exp * 3600);
   local des = TIME_HELPER:getTimeDesByMax( time );
   self.info_upgradetime:setString("预计升级: "..des)
   self.info_time:setString("平均用时: "..Data_Battle_Onhook.combatetime.."秒/次")
   self.info_exp:setString("经验获得: "..Data_Battle_Onhook.exp.."/小时")
   self.info_gold:setString("金币获得: "..Data_Battle_Onhook.gold.."/小时")
end



return UI_Onhook_Info


