--
-- Author: LiYang
-- Date: 2015-07-07 14:43:56
-- 战场显示

local battleshowLayer = class("battleshowLayer", cc.load("mvc").ViewBase)

function battleshowLayer:ctor()
	--添加战场显示
    self.rootnode = cc.CSLoader:createNode("ui_instance/battlefield/battleshowLayer.csb")
    self:addChild(self.rootnode)

    self.BottomLayer = self.rootnode:getChildByName("bottomlayer");
    self.BottomLayer:setLocalZOrder(1);
    --焦点控制
    self.FocusControl = self.BottomLayer:getChildByName("focuscontrol");

    self.showList = self.FocusControl:getChildByName("showlist");

    self.TopLayer = self.rootnode:getChildByName("toplayer");
    self.TopLayer:setLocalZOrder(2);

    --地图层
    self.mapLayer = self.showList:getChildByName("map");

    self.map = require("app.views.battlefield.map.battlefieldmap_1").new();
	self.mapLayer:addChild(self.map);
	-- self.map:setPosition(cc.p(- self.map.width / 2 ,- self.map.height / 2));
	--设置map 数据
	Data_Battle.mapData.mapStartPos_x = 0;  --self.map.width / 2;
	Data_Battle.mapData.mapStartPos_y = self.map.height;  --self.map.height;
    Data_Battle.mapData.pixelwidth = self.map.width;
    Data_Battle.mapData.pixelheight = self.map.height;

    -- self.map:setVisible(false);

    --效果1成
    self.effectLayer_0 = self.showList:getChildByName("effect_0");
    self.effectLayer_0:setLocalZOrder(1)
    -- self.effectLayer_0:setPosition(cc.p(- self.map.width / 2 ,- self.map.height / 2));

    self.effectLayer_1 = self.showList:getChildByName("effect_1");
    self.effectLayer_1:setLocalZOrder(2)
    -- self.effectLayer_1:setPosition(cc.p(- self.map.width / 2 ,- self.map.height / 2));

    self.effectLayer_2 = self.showList:getChildByName("effect_2");
    self.effectLayer_2:setLocalZOrder(3)
    -- self.effectLayer_2:setPosition(cc.p(- self.map.width / 2 ,- self.map.height / 2));

    self.effectLayer_3 = self.showList:getChildByName("effect_3");
    self.effectLayer_3:setLocalZOrder(4)
    -- self.effectLayer_3:setPosition(cc.p(- self.map.width / 2 ,- self.map.height / 2));

    self.showList:setPosition(cc.p(- self.map.width / 2 ,- self.map.height / 2));

    --effect_screen
    self.effect_screen = self.TopLayer:getChildByName("effect_screen");
    self.effect_screen:setLocalZOrder(0);
    --ui层
    self.uiLayer = self.TopLayer:getChildByName("ui");
    self.uiLayer:setLocalZOrder(1);
    -- self.uiLayer:setTouchEnabled(true);
    -- self.uiLayer:setPosition(cc.p(- self.map.width / 2 ,- self.map.height / 2));
   
    self.shadow_layer = self.TopLayer:getChildByName("shadow_layer");
    self.shadow_layer:setLocalZOrder(2);
    -- self.shadow_layer:setPosition(cc.p(- self.map.width / 2 ,- self.map.height / 2));


    self:show(  );

    self.LogicNode = cc.Node:create();
    self:addChild(self.LogicNode);

    -- self.eventLogic = require("app.views.battlefield.battleShowLayerManager").new(self);
    -- self.eventLogic:register_event();
    battleShowManager.target_ = self;
end

--隐藏
function battleshowLayer:hide(  )
    local action = cc.CSLoader:createTimeline("ui_instance/battlefield/battleshowLayer.csb")
    self.rootnode:runAction(action)
    action:play("hide", false)
end

--显示
function battleshowLayer:show(  )
    local action = cc.CSLoader:createTimeline("ui_instance/battlefield/battleshowLayer.csb")
    self.rootnode:runAction(action)
    action:play("show", false)
end

function battleshowLayer:cut()
    local action = cc.CSLoader:createTimeline("ui_instance/battlefield/battleshowLayer.csb")
    self.rootnode:runAction(action)
    action:play("cut", false)
end

return battleshowLayer;
