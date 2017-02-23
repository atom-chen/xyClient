--
-- Author: liyang
-- Date: 2015-06-11 14:56:30
-- 选择英雄item


local UI_hero_item = class("UI_hero_item", cc.load("mvc").ViewBase)

UI_hero_item.RESOURCE_FILENAME = "ui_instance/login/choose_item.csb"
function UI_hero_item:onCreate()
    self.rootNode = self.resourceNode_:getChildByName("mian_layout");
    --关卡名称
    self.heroname = self.rootNode:getChildByName("heroname");
    --物攻
    self.attribute_act = self.rootNode:getChildByName("attribute_act");
    --法攻
    self.attribute_act_f = self.rootNode:getChildByName("attribute_act_f");
    --物攻
    self.attribute_hp = self.rootNode:getChildByName("attribute_hp");
    --物防
    self.attribute_defense_w = self.rootNode:getChildByName("attribute_defense_w");
    --法防
    self.attribute_defense_f = self.rootNode:getChildByName("attribute_defense_f");

    self.roleView = self.rootNode:getChildByName("roleimage");

    self.backImage = self.rootNode:getChildByName("back");

    self.tounchControl = self.resourceNode_:getChildByName("tounchcontrol");

    self.width = self.rootNode:getContentSize().width;
    self.height = self.rootNode:getContentSize().height;
    self:registerEvent();
end

--设置开场动画 和 
function UI_hero_item:openAnimationEffect(  )

end

--注册事件
function UI_hero_item:registerEvent(  )
    self.tounchControl:setSwallowTouches(false)
    local function Clicked(sender)
        --确定事件
        print("item 点击事件")
        dispatchGlobaleEvent( "models_inithero" ,"choosehero",{self});
    end
    self.tounchControl:addClickEventListener(Clicked);

    --查看按钮
    local b_see = self.rootNode:getChildByName("button_see");
    local function seeClicked(sender)
        --查看事件
        print("点击查看按钮")
        UIManager:createAtlasDialog(self.heroData)
    end
    b_see:addClickEventListener(seeClicked);
end

function UI_hero_item:setData( herotemple )
    self.HeroTemple = herotemple;
    self.heroData = GetHeroTemplate(self.HeroTemple);
    local heroview = UIManager:CreateAvatarLargePart( self.HeroTemple ,nil)
    self.roleView:addChild(heroview:getResourceNode());
    --信息
    self.heroname:setString(self.heroData.name);
    --职业

    self.attribute_act:setString(heroConfig_toStrAtkType(self.heroData.profession)..":"..heroConfig_computeAttack( self.HeroTemple, 1 ));
    self.attribute_hp:setString("生命:"..heroConfig_computeHP( self.HeroTemple, 1 ));
    self.attribute_defense_w:setString("物防:"..heroConfig_computePDef( self.HeroTemple, 1 ));
    self.attribute_defense_f:setString("法防:"..heroConfig_computeMDef( self.HeroTemple, 1 ));
end

--设置是否显示状态
function UI_hero_item:setChooseDisplay( ischoose )
    if ischoose then
        self.backImage:setSpriteFrame("ui_image/inithero/chooseback_1.png")
    else
        self.backImage:setSpriteFrame("ui_image/inithero/chooseback_0.png")
    end
end

return UI_hero_item


