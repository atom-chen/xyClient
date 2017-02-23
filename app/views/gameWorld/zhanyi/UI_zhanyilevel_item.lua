--
-- Author: liyang
-- Date: 2015-06-11 14:56:30
-- 战役关卡item


local UI_zhanyilevel_item = class("UI_zhanyilevel_item", cc.load("mvc").ViewBase)

UI_zhanyilevel_item.RESOURCE_FILENAME = "ui_instance/zhanyi/zhanyilevelitem.csb"
function UI_zhanyilevel_item:onCreate()

    --星级列表
    self.starLevel = self.resourceNode_:getChildByName("starlevel");
    --关卡名称
    self.cityname = self.resourceNode_:getChildByName("name");

    self.cityImage = self.resourceNode_:getChildByName("cityimage");

    self:registerEvent();
end

--设置开场动画 和 
function UI_zhanyilevel_item:openAnimationEffect(  )

end

--注册事件
function UI_zhanyilevel_item:registerEvent(  )
    
    local function touchEvent(sender,eventType)
        -- print("local function touchEvent(sender,eventType)")
        if eventType == ccui.TouchEventType.began then
            sender.MarkIsMove = false;
            sender.Record_pos = sender:convertToWorldSpace(cc.p(0,0));
            -- sender:setScale(sender:getScale() - 0.1);
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
                dispatchGlobaleEvent( "zhanyi_ctrl" ,"choose_zhanyilevel" ,{sender = self})
            end
            -- sender:setScale(sender:getScale() + 0.1);
        elseif eventType == ccui.TouchEventType.canceled then
            -- self._displayValueLabel:setString("Touch Cancelled")
            -- print("Touch Cancelled")
        end
    end
    self.cityImage:setTouchEnabled(true);
    self.cityImage:setSwallowTouches(false)
    self.cityImage:addTouchEventListener(touchEvent);
end

--[[更新显示数据
    param
]]
function UI_zhanyilevel_item:UpdateShowData( params )
    self.showData = params;
    --关卡名字
    self.cityname:setString(self.showData.Name);
    --关卡星级
    if self.showData.LevelStar and self.showData.LevelStar > 0 then
        self:setCityColor( true );
        for i=1,3 do
            if self.showData.LevelStar >= i then
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
   
end

--设置城堡颜色显示
function UI_zhanyilevel_item:setCityColor( isshow )
    if isshow then
        self.cityImage:setColor(cc.c3b(255, 255, 255));
    else
        self.cityImage:setColor(cc.c3b(78, 88, 77));
    end
end




return UI_zhanyilevel_item


