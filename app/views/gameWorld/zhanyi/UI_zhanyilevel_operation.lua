--
-- Author: liyang
-- Date: 2015-06-11 14:56:30
-- 战役关卡操作界面


local UI_zhanyilevel_operation = class("UI_zhanyilevel_operation", cc.load("mvc").ViewBase)

UI_zhanyilevel_operation.RESOURCE_FILENAME = "ui_instance/zhanyi/zhanyilevelinfo.csb"
function UI_zhanyilevel_operation:onCreate()
    --战役列表
    self.rootNode = self.resourceNode_:getChildByName("main_layout");

    --名称
    self.titlename = self.rootNode:getChildByName("titlename");

    --星级节点
    self.starnode = self.rootNode:getChildByName("starlevel");

    --体力值
    self.powerValuse = self.rootNode:getChildByName("powervaluse"):getChildByName("valuse");

    --攻打次数值
    self.timeValuse = self.rootNode:getChildByName("timevaluse"):getChildByName("valuse");

    self.sweepButton_1 = self.rootNode:getChildByName("sweep_1");

    self.sweepButton_2 = self.rootNode:getChildByName("sweep_2");

    self.challengeButton = self.rootNode:getChildByName("challenge");

    self.exitButton = self.rootNode:getChildByName("button_exit");

    -- self:refreshView();
    self:registerEvent();

    local size= cc.Director:getInstance():getVisibleSize()
    local rootNode = self:getResourceNode();
    rootNode:setContentSize(size);
    ccui.Helper:doLayout(rootNode);
    rootNode:setPosition(cc.p(display.cx - 640 ,display.cy - 360));

    local shadow_layout = rootNode:getChildByName("shadow_layout");
    shadow_layout:setContentSize(size);
    ccui.Helper:doLayout(shadow_layout);
end

--设置开场动画 和 
function UI_zhanyilevel_operation:openAnimationEffect(  )
    
end

--注册事件
function UI_zhanyilevel_operation:registerEvent(  )
    --退出事件
    local function exitClicked(sender)
        self:exit()
    end
    self.exitButton:addClickEventListener(exitClicked)
    --挑战事件
    local function challengeButtonClicked(sender)
        dispatchGlobaleEvent( "zhanyi_ctrl" ,"challenge" ,{sender = self})
    end
    self.challengeButton:addClickEventListener(challengeButtonClicked)
    --扫荡事件
     local function sweepButtonClicked_1(sender)
        dispatchGlobaleEvent( "loadbattleres" ,"wait_open" ,{sender = self})
    end
    self.sweepButton_1:addClickEventListener(sweepButtonClicked_1)
     local function sweepButtonClicked_2(sender)
        -- self:exit()
    end
    self.sweepButton_2:addClickEventListener(sweepButtonClicked_2)
end

--刷新显示
function UI_zhanyilevel_operation:refreshShowData( params )
    self.showData = params;
    --关卡名字
    self.titlename:setString(self.showData.Name);
    --关卡星级
    if self.showData.LevelStar and self.showData.LevelStar > 0 then
        for i=1,3 do
            if self.showData.LevelStar >= i then
                self.starnode:getChildByName("star"..i):loadTexture("ui_image/zhanyi/heroitem_star1.png")
            else
                self.starnode:getChildByName("star"..i):loadTexture("ui_image/zhanyi/heroitem_star2.png")
            end
        end
    else
        for i=1,3 do
            self.starnode:getChildByName("star"..i):loadTexture("ui_image/zhanyi/heroitem_star2.png")
        end
    end
    --更新消耗数量
    -- 消耗体力
    if self.showData.ConsumeVigor then
        self.powerValuse:setString(""..self.showData.ConsumeVigor)
        if MAIN_PLAYER:getBaseAttr():checkeAttrEnough( "体力" , self.showData.ConsumeVigor ) then
            self.powerValuse:setColor(cc.c3b(0, 0, 0));
        else
            self.powerValuse:setColor(cc.c3b(255, 0, 0));
        end
    end

    -- 剩余次数
    if not self.showData.CurrentLimitNum then
        self.showData.CurrentLimitNum = self.showData.LimitNum;
    else
        if self.showData.CurrentLimitNum < 0 then
            self.showData.CurrentLimitNum = 0;
        end
    end
    self.timeValuse:setString(""..self.showData.CurrentLimitNum);

    --判断扫荡显示

end

function UI_zhanyilevel_operation:exit()
    self:removeFromParent();
end

return UI_zhanyilevel_operation


