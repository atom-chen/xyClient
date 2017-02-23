--
-- Author: liyang
-- Date: 2015-08-13 14:56:30
-- 挂机离线战斗信息

local classRichTextListView = require(FILE_PATH.PATH_VIEWS_BASE..".RichTextListView")

local UI_Onhook_offline = class("UI_Onhook_offline", cc.load("mvc").ViewBase)

UI_Onhook_offline.RESOURCE_FILENAME = "ui_instance/battlefield/onhook_offline.csb"
function UI_Onhook_offline:onCreate()
    self.shadowNode = self.resourceNode_:getChildByName("shadow_layout");

    self.rootNode = self.resourceNode_:getChildByName("main_layout");

    self.infoList = self.rootNode:getChildByName("infolist");
    --名称
    self.viewname = self.rootNode:getChildByName("title");

    -- --升级时间
    -- self.info_upgradetime = infoList:getChildByName("upgradetime");

    -- --平均用时
    -- self.info_time = infoList:getChildByName("time");

    -- --活动禁用
    -- self.info_exp = infoList:getChildByName("exp");

    -- --获得金币
    -- self.info_gold = infoList:getChildByName("gold");


    self:registerEvent();
end

--设置开场动画 和 
function UI_Onhook_offline:openAnimationEffect(  )

end

--注册事件
function UI_Onhook_offline:registerEvent(  )
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
function UI_Onhook_offline:UpdateShowData( viewtype ,data)
    if viewtype == 0 then
        self.viewname:setString("离线战斗信息")
    else
        self.viewname:setString("快速战斗信息")
    end
    self.showData = data;

    self.InfoView = classRichTextListView.new(
        {
            width = 450, 
            height = 360,
            backgroundColorType = ccui.LayoutBackGroundColorType.none
        }
    )
    -- ResIDConfig:getEquipQualityInfo( quality )
    self.InfoView:setPosition(cc.p(10, 20))
    self.infoList:addChild(self.InfoView)
    self.InfoView:clear()
    self.InfoView:pushString("[d=4][/]战斗信息:\n")
    local time = TIME_HELPER:secondToTime( self.showData.offlinetime )
    timestr = string.format("%02d小时%02d分%02d秒", 
                    time.hour,
                    time.min,
                    time.sec
                )
    self.InfoView:pushString("[d=4][/]战斗时间:[color=0|128|0]"..timestr.."[/] 战斗次数:[color=0|128|0]"..self.showData.runtime.."次\n[/]")
    local sumexp = 0;
    local sumgole = 0;
    --显示经验
     for i,v in ipairs(self.showData.dropGoods) do
        if v.droptype == eDT_PlayerExp then
            sumexp = sumexp + v.count;
        elseif v.droptype == eDT_Gold then
            sumgole = sumgole + v.count;
        end
    end
    self.InfoView:pushString("[d=4][/]获得经验:[color=0|128|0]"..sumexp.."[/] 获得金币:[color=0|128|0]"..sumgole.."\n[/]")
    --显示装备
    local count = {0,0,0,0,0};
    local count1 = {0,0,0,0,0};--丢弃数量
    local des = {"白色装备","绿色装备","蓝色装备","紫色装备","橙色装备"};
    for i,v in ipairs(self.showData.dropGoods) do
        if v.droptype == eDT_Equip then
            local info = EquipConfig[v.dropid];
            if info then
                count[info.quality] = count[info.quality] + v.count;
                count1[info.quality] = count1[info.quality] + (v.count - v.addcount);
            end
        end
    end
    for i=5,1,-1 do
        if count[i] > 0 then
            local color = ResIDConfig:getEquipQualityInfo( i ).color;

            local colordes = "[color="..color.r.."|"..color.g.."|"..color.b.."]";
            local desstr = des[i];
            if count1[i] > 0 then
                self.InfoView:pushString("[d=4][/]掉落:"..colordes..desstr.." x "..count[i].."个(丢弃"..count1[i].."个)\n[/]")
            else
                self.InfoView:pushString("[d=4][/]掉落:"..colordes..desstr.." x "..count[i].."个\n[/]");
            end
            
        end
    end
    --显示掉落道具
    local goods = {};
    for i,v in ipairs(self.showData.dropGoods) do
        if v.droptype == eDT_Item then
            local info = ItemsConfig[v.dropid];
            if info then
                if goods[v.dropid] then
                    goods[v.dropid].count = goods[v.dropid].count + v.count;
                else
                    goods[v.dropid] = v;
                end
            end
        end
    end

    for k,v in pairs(goods) do
        local info = ItemsConfig[v.dropid];
        local showname = info.name;
        local color = ResIDConfig:getEquipQualityInfo( info.quality ).color;
        local colordes = "[color="..color.r.."|"..color.g.."|"..color.b.."]";
        self.InfoView:pushString("[d=4][/]掉落:"..colordes..showname.." x "..v.count.."个\n[/]")
    end
    self.InfoView:refreshView();
end



return UI_Onhook_offline


