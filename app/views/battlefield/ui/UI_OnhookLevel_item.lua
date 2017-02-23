--
-- Author: liyang
-- Date: 2015-06-11 14:56:30
-- 挂机关卡item


local UI_OnhookLevel_item = class("UI_OnhookLevel_item", cc.load("mvc").ViewBase)

UI_OnhookLevel_item.RESOURCE_FILENAME = "ui_instance/battlefield/levelitem.csb"
function UI_OnhookLevel_item:onCreate()
    self.rootNode = self.resourceNode_:getChildByName("mian_layout");
    --关卡名称
    self.levelname = self.rootNode:getChildByName("levelname");
    --挂机按钮
    self.buttonOnhook = self.rootNode:getChildByName("onhook");
    --挂机描述
    self.Onhookprompt = self.rootNode:getChildByName("onhookprompt");
    --关卡奖励
    self.dropoutnode = self.rootNode:getChildByName("dropoutnode");
    self.width = self.rootNode:getContentSize().width;
    self.height = self.rootNode:getContentSize().height;
    self:registerEvent();
end

--设置开场动画 和 
function UI_OnhookLevel_item:openAnimationEffect(  )

end

--注册事件
function UI_OnhookLevel_item:registerEvent(  )
    --挂机
    local function onhookClicked(sender)
        print("关卡选择 ")
        --更新挂机目标
        printInfo("网络日志 更新挂机目标 MSG_C2MS_WAR_HOOK_BEGIN key = %s", Data_Battle_Onhook.LevelData.Key);
        gameTcp:SendMessage(MSG_C2MS_WAR_HOOK_BEGIN,{
            self.showData.Key,
            MAIN_PLAYER.teamManager:getCurSelTeamIdx(),
            })
        -- dispatchGlobaleEvent( "onhook" ,"data_cut" ,{self});
    end
    self.buttonOnhook:addClickEventListener(onhookClicked)

    --挑战
    local button_challenge = self.rootNode:getChildByName("challenge")
    local function challengeClicked(sender)
        print("关卡Boss挑战 ")
        -- dispatchGlobaleEvent( "onhook" ,"challenge_boss",{self.showData.Key});
        local logictype = Data_Battle_Onhook:checkIsCanBossChallenge(  );
        if logictype == 0 then
            UIManager:CreatePrompt_Bar( {
                content = "挑战次数用尽"
                } )
        elseif logictype == 1 then
            control_Battlefield:addRequestData({
                battletype = Data_Battle.CONST_BATTLE_TYPE_BOSS,
                levelkey = self.showData.Key,--关卡key值
                isexecute = true,--是否马上执行
            });
        elseif logictype == 2 then
            --启动提示框
            local itemInfo = GetItemCfg(eSTID_BossPlay);
            local desstr = "是否消耗道具["..itemInfo.name.."]挑战本关卡BOSS,当前拥有数量:"..Data_Battle_Onhook:getBossChallengeGoodsNum(  );
            UIManager:CreatePrompt_Operate_1( {
                    mark = "challengeboss",--界面类型标示
                    title = "挑战boss",--标题
                    content = desstr,--描述文字
                    eventlogic = "",--绑定逻辑
                    eventlist = "",--注册事件列表
                    listenButton = function ( result )
                        -- 1 表示选择1按钮 2表示选择按钮
                        if result == 1 then
                            control_Battlefield:addRequestData({
                                battletype = Data_Battle.CONST_BATTLE_TYPE_BOSS,
                                levelkey = self.showData.Key,--关卡key值
                                isexecute = true,--是否马上执行
                            });
                        end
                    end
                } )
        else
           
        end
    end
    button_challenge:addClickEventListener(challengeClicked)
end

--[[更新显示数据
    param
]]
function UI_OnhookLevel_item:UpdateShowData( params )
    self.showData = params;
    --关卡名字
    self.levelname:setString((self.showData.Key).."."..self.showData.name);
    if self.showData.boss_combat and self.showData.boss_combat.Rewards[1] then
        self.dropoutnode:setVisible(true);
        local droptype = self.showData.boss_combat.Rewards[1].obj_type;
        local dropid = self.showData.boss_combat.Rewards[1].obj_id;
        --显示掉落
        self.dropView = UIManager:CreateDropOutFrame( droptype,dropid)
        self.dropView:getResourceNode():setScale(80 / self.dropView.width)
        self.dropoutnode:addChild(self.dropView:getResourceNode())
        self.dropView:getResourceNode():setPositionX(60);
        print(droptype, dropid)
        local name = UIManager:createDropName(droptype, dropid)
        local namenode = self.dropoutnode:getChildByName("name");
        namenode:setString(name);
    else
        self.dropoutnode:setVisible(false);
    end

    --判断是否显示奖励箱
    if Data_Battle_Onhook:isShowAwardBox( self.showData.Key ) then
        if self.awardsprite then
            self.awardsprite:removeFromParent();
        end
        self.awardsprite = ccui.Button:create("ui_image/battle/battle_ui/awardbox_get.png","","",ccui.TextureResType.plistType);
        self.rootNode:addChild(self.awardsprite,10);
        self.awardsprite:setPosition(cc.p(115,50));
        --暂时关闭掉落显示
        self.dropoutnode:setVisible(false);
        --添加点击事件
        local function touchEvent(touch, event)
            --发送领奖消息
            dispatchGlobaleEvent( "onhook" ,"getaward" ,{self.showData.Key});
        end
        self.awardsprite:setTouchEnabled(true)
        self.awardsprite:setPressedActionEnabled(true)
        self.awardsprite:addClickEventListener(touchEvent)
    end
    
    --判断是否是挂机关卡
    if Data_Battle_Onhook:isOnhookLevel( self.showData.Key ) then
        self.buttonOnhook:setVisible(false);
        self.Onhookprompt:setVisible(true);
    else
        self.buttonOnhook:setVisible(true);
        self.Onhookprompt:setVisible(false);
    end
end

function UI_OnhookLevel_item:refresh(  )
    --关卡名字
    self.levelname:setString(self.showData.name);
    --判断是否有掉落显示
    if self.showData.boss_combat and self.showData.boss_combat.Rewards[1] then
        self.dropoutnode:setVisible(true);
    else
        self.dropoutnode:setVisible(false);
    end
    
    --判断是否显示奖励箱
    if Data_Battle_Onhook:isShowAwardBox( self.showData.Key ) then
        if self.awardsprite then
            self.awardsprite:removeFromParent();
        end
        self.awardsprite = ccui.Button:create("ui_image/battle/battle_ui/awardbox_get.png","","",ccui.TextureResType.plistType);
        self.rootNode:addChild(self.awardsprite,10);
        self.awardsprite:setPosition(cc.p(115,50));
        --暂时关闭掉落显示
        self.dropoutnode:setVisible(false);
        --添加点击事件
        local function touchEvent(touch, event)
            --发送领奖消息
            dispatchGlobaleEvent( "onhook" ,"getaward" ,{self.showData.Key});
        end
        self.awardsprite:setTouchEnabled(true)
        self.awardsprite:setPressedActionEnabled(true)
        self.awardsprite:addClickEventListener(touchEvent)
    else
        if self.awardsprite then
            self.awardsprite:removeFromParent();
            self.awardsprite = nil;
        end
    end

    --判断是否是挂机关卡
    if Data_Battle_Onhook:isOnhookLevel( self.showData.Key ) then
        self.buttonOnhook:setVisible(false);
        self.Onhookprompt:setVisible(true);
    else
        self.buttonOnhook:setVisible(true);
        self.Onhookprompt:setVisible(false);
    end
end


return UI_OnhookLevel_item


