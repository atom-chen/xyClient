--
-- Author: liyang
-- Date: 2015-06-11 14:56:30
-- 战斗底部UI


local UI_BattleOnhook_Bottom = class("UI_BattleOnhook_Bottom", cc.load("mvc").ViewBase)

UI_BattleOnhook_Bottom.RESOURCE_FILENAME = "ui_instance/battlefield/battle_ui_bottom.csb"

local class_levelitem = import(".UI_OnhookLevel_item")

function UI_BattleOnhook_Bottom:onCreate()
    
    --战役列表
    self.rootNode = self.resourceNode_:getChildByName("main_layout");

    --关卡节点 
    self.LevelListNode = self.rootNode:getChildByName("levellistnode");

    --boss挑战信息显示
    self.Info_challenge = self.LevelListNode:getChildByName("main_layout"):getChildByName("bossinfo"):getChildByName("bossvaluse");

    --更新时间
    -- self.Info_challengeChangeTime = self.LevelListNode:getChildByName("main_layout"):getChildByName("revertinfo"):getChildByName("valuse");

    --关卡列表
    self.LevelList = self.LevelListNode:getChildByName("main_layout"):getChildByName("level_list");

    --滑动框
    self.levelslider = self.LevelListNode:getChildByName("level_slider");
    self.levelslider:setPercent(10);

    --item 模板
    self.levelItem = self.LevelList:getChildByName("levelitem");

    self.innerWidth = self.LevelList:getContentSize().width;
    self.innerHeight = self.LevelList:getContentSize().height;

    self.itemunit_w = self.levelItem:getContentSize().width;
    self.itemunit_h = self.levelItem:getContentSize().height;

    self.current_x = 0;
    self.current_y = 0;

    self.interval = 10;

    self.unitPercent = 1;

    self.Info_win = self.rootNode:getChildByName("info"):getChildByName("text");
    
    self.levelItem:removeFromParent();
    -- self:refreshView();
    self:registerEvent();
end

--设置开场动画 和 
function UI_BattleOnhook_Bottom:openAnimationEffect(  )
    
end

--注册事件
function UI_BattleOnhook_Bottom:registerEvent(  )
    --战斗关闭
    local battleOnhookClose = self.rootNode:getChildByName("close")
    local function exitClicked(sender)
        print("退出挂机")
        dispatchGlobaleEvent( "onhook" ,"closeonhook");
    end
    battleOnhookClose:addClickEventListener(exitClicked)

    --战斗信息
    local battleOnhook_info = self.rootNode:getChildByName("info")
    local function infoClicked(sender)
        print("挂机信息点击")
        dispatchGlobaleEvent( "onhook" ,"create_info");
    end
    battleOnhook_info:addClickEventListener(infoClicked)

    --快速战斗
    local battleOnhook_quickcombat = self.rootNode:getChildByName("quickcombat")
    local function quickcombatClicked(sender)
        print("挂机 快速战斗")
        dispatchGlobaleEvent( "onhook" ,"create_quickcombat");
    end
    battleOnhook_quickcombat:addClickEventListener(quickcombatClicked)

    --装备出售
    -- local battleOnhook_sell = self.rootNode:getChildByName("sell")
    -- local function sellClicked(sender)
    --     print("挂机 快速战斗")
    --     dispatchGlobaleEvent( "onhook" ,"create_sell");
    -- end
    -- battleOnhook_sell:addClickEventListener(sellClicked)

    --关卡信息
    local battleOnhook_level = self.rootNode:getChildByName("level")
    local function levelClicked(sender)
        print("挂机 关卡信息");
        dispatchGlobaleEvent( "onhook" ,"ui_operation_level");
    end
    battleOnhook_level:addClickEventListener(levelClicked)

    --注册滑动框
    local function sliderEvent(sender,eventType)
        if eventType == ccui.SliderEventType.percentChanged then
            local slider = sender
            local percent = slider:getPercent() * self.unitPercent;
            self.LevelList:jumpToPercentHorizontal(percent);
            -- self._displayValueLabel:setString(percent)
        end
    end
    self.levelslider:addEventListener(sliderEvent)
    -- local delay_1 = cc.DelayTime:create(1);
    -- local callfun = cc.CallFunc:create(function (  )
    --     self:setRevertTime( Data_Battle_Onhook:getRevertTimeDes(  ) );
    --     self:setBossChallenge( Data_Battle_Onhook:getCurEnergy() )
    -- end)
    -- local action = cc.Sequence:create(delay_1,callfun);
    -- self.Info_challengeChangeTime:runAction(cc.RepeatForever:create(action));
    --注册界面更新
    -- createGlobalEventListener( "zhanyilevel_ctrl", "refresh", handler(self, self.refreshView), 1 )
end

--添加关卡列表
function UI_BattleOnhook_Bottom:addLevelItem( data )

    local levelitem = class_levelitem.new();
    if data then
        levelitem:UpdateShowData( data );
    end
    levelitem:setPosition(cc.p(self.current_x,self.current_y));
    self.LevelList:addChild(levelitem);
    
    self.current_x = self.current_x + self.itemunit_w + self.interval;
    return levelitem;
end

--重置关卡列表显示信息
function UI_BattleOnhook_Bottom:resetLevelListShowInfo( onhookitem )
    self.Container_w = self.current_x - self.interval;
     if self.Container_w < self.innerWidth then
        self.Container_w = self.innerWidth;
    end
    self.LevelList:setInnerContainerSize(cc.size(self.Container_w, self.innerHeight));
    -- self.LevelList:jumpToLeft();

    self.levelSlider_w = 1240;

    self.unitPercent = self.Container_w / self.levelSlider_w;

    self:jumpToOnhookLevel( onhookitem );
end

--设置关卡显示的百分比
function UI_BattleOnhook_Bottom:setShowLevelPercent( percent )
    self.levelslider:setPercent(percent);
    self.LevelList:jumpToPercentHorizontal(percent);
end

--跳转到挂机关卡
function UI_BattleOnhook_Bottom:jumpToOnhookLevel( item )
    local x = item:getPositionX();
    local percent = x / self.Container_w;
    self:setShowLevelPercent( percent );
end

--设置胜率
function UI_BattleOnhook_Bottom:setWinFficiency( valuse )
    self.Info_win:setString("胜率"..valuse.."%");
end

--设置boss挑战次数
function UI_BattleOnhook_Bottom:setBossChallenge( valuse )
    self.Info_challenge:setString(valuse);
end

--设置恢复时间
function UI_BattleOnhook_Bottom:setRevertTime( valuse )
   
    -- self.Info_challengeChangeTime:setString(valuse)
end

--隐藏关卡列表
function UI_BattleOnhook_Bottom:Effect_HideLevelList(  )
    local action = createActionWithCSB( self.RESOURCE_FILENAME );
    self.rootNode:runAction(action);
    action:play( "levelhide" ,false);
end

--显示关卡列表
function UI_BattleOnhook_Bottom:Effect_ShowLevelList(  )
    local action = createActionWithCSB( self.RESOURCE_FILENAME );
    self.rootNode:runAction(action);
    action:play( "levelshow" ,false);
end

function UI_BattleOnhook_Bottom:exit()
    self:removeFromParent();
end

return UI_BattleOnhook_Bottom


