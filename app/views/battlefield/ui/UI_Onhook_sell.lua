--
-- Author: liyang
-- Date: 2015-08-13 14:56:30
-- 自动出售


local UI_Onhook_sell = class("UI_Onhook_sell", cc.load("mvc").ViewBase)

UI_Onhook_sell.RESOURCE_FILENAME = "ui_instance/battlefield/onhook_sell.csb";
function UI_Onhook_sell:onCreate()
    self.shadowNode = self.resourceNode_:getChildByName("shadow_layout");
    self.rootNode = self.resourceNode_:getChildByName("main_layout");
    
    self:registerEvent();
end

--设置开场动画 和 
function UI_Onhook_sell:openAnimationEffect(  )

end

--注册事件
function UI_Onhook_sell:registerEvent(  )
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
        self:removeFromParent();
    end
    button_ok:addClickEventListener(okClicked);
   
    for i=1,4 do
        local function selectedStateEvent(sender,eventType)
            local index = sender.mark;
            if eventType == ccui.CheckBoxEventType.selected then
                Data_Battle_Onhook.sellType[index] = true;
            elseif eventType == ccui.CheckBoxEventType.unselected then
                Data_Battle_Onhook.sellType[index] = false;
            end
        end
       
        local checkbox = infoList:getChildByName("check_"..i):getChildByName("checkbox");
        checkbox.mark = i;
        checkbox:addEventListener(selectedStateEvent)
    end
end

--[[更新显示数据
    param
]]
function UI_Onhook_sell:UpdateShowData(  )
    local infoList = self.rootNode:getChildByName("infolist");
    for i,v in ipairs(Data_Battle_Onhook.sellType) do
        if v then
            local checkbox = infoList:getChildByName("check_"..i):getChildByName("checkbox");
            
            checkbox:setSelected(true);
        end
    end
end



return UI_Onhook_sell


