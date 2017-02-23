--
-- Author: liyang
-- Date: 2015-06-11 14:56:30
-- 战役item


local UI_zhanyi_item = class("UI_zhanyi_item", cc.load("mvc").ViewBase)

UI_zhanyi_item.RESOURCE_FILENAME = "ui_instance/zhanyi/zhanyiitem.csb"
function UI_zhanyi_item:onCreate()

    --星级列表
    self.starLevel = self.resourceNode_:getChildByName("starlevel");
    --城市图
    self.cityImage = self.resourceNode_:getChildByName("city");

    --关卡名称
    self.cityname = self.resourceNode_:getChildByName("Text_1");

    --关卡奖励标示
    self.awardImage = self.resourceNode_:getChildByName("awardimage");

    self:registerEvent();
end

--设置开场动画 和 
function UI_zhanyi_item:openAnimationEffect(  )

end

--注册事件
function UI_zhanyi_item:registerEvent(  )
    
    local function touchEvent(sender,eventType)
        print("local function touchEvent(sender,eventType)",sender,eventType)
        if eventType == ccui.TouchEventType.began then
            sender.MarkIsMove = false;
            sender.Record_pos = sender:convertToWorldSpace(cc.p(0,0));
            sender:setScale(sender:getScale() - 0.1);
        elseif eventType == ccui.TouchEventType.moved then
            if not sender.MarkIsMove then
                local pos = sender:convertToWorldSpace(cc.p(0,0))
                if cc.pGetLength(cc.p(pos.x - sender.Record_pos.x,pos.y - sender.Record_pos.y)) > 10 then
                    sender.MarkIsMove = true;
                end
            end
        elseif eventType == ccui.TouchEventType.ended then
            if not sender.MarkIsMove then
                --执行选择服务器逻辑
                dispatchGlobaleEvent( "zhanyi_ctrl" ,"choose_zhanyi" ,{sender = self})
            end
            sender:setScale(sender:getScale() + 0.1);
        elseif eventType == ccui.TouchEventType.canceled then
            -- self._displayValueLabel:setString("Touch Cancelled")
            -- print("Touch Cancelled")
            sender:setScale(sender:getScale() + 0.1);
        end
    end
    self.cityImage:setTouchEnabled(true);
    self.cityImage:setSwallowTouches(false)
    self.cityImage:addTouchEventListener(touchEvent);
end

--[[更新显示数据
    param
]]
function UI_zhanyi_item:UpdateShowData( params )
    self.showData = params;
    --关卡名字
    self.cityname:setString(self.showData.name);
    
    --关卡星级
    if self.showData.BattleStar and self.showData.BattleStar > 0 then
        self:setCityColor( true );
        for i=1,3 do
            if self.showData.BattleStar >= i then
                self.starLevel:getChildByName("star"..i):loadTexture("ui_image/zhanyi/heroitem_star1.png")
            else
                self.starLevel:getChildByName("star"..i):loadTexture("ui_image/zhanyi/heroitem_star2.png")
            end
        end
    else
        self:setCityColor( false );
        for i=1,3 do
            self.starLevel:getChildByName("star"..i):loadTexture("ui_image/zhanyi/heroitem_star2.png")
        end
    end
    --判断是否显示挑战标示

    --判断是否有未领取奖励 
   
    local isshowaward = false;
    if (not self.showData.IsPerfectPrize) and self.showData.IsCanGetPerfectAward  then
        isshowaward = true;
    end
    if (not self.showData.IsPassPrize) and self.showData.IsCanGetPassAward  then
        isshowaward = true;
    end
    if isshowaward then
        self.awardImage:setVisible(true);
    else
        self.awardImage:setVisible(false);
    end
end

--设置城堡颜色显示
function UI_zhanyi_item:setCityColor( isshow )
    if isshow then
        self.cityImage:setColor(cc.c3b(255, 255, 255));
    else
        self.cityImage:setColor(cc.c3b(78, 88, 77));
    end
end




return UI_zhanyi_item


