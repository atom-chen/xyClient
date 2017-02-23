
local MainScene = class("MainScene", cc.load("mvc").ViewBase)

function MainScene:onCreate()
    
    local function onNodeEvent(tag)
        if tag == "enterTransitionFinish" then
            -- local effect = EffectManager:CreateArmature( {
            --         name = "herores/zhangjiao/f_zj_e.ExportJson",--效果名称
            --         x = display.cx,
            --         y = display.cy,
            --         zorder = 100;
            --         isfinishdestroy = false,--是否完成销毁
            --     } );
            -- effect:playAnimationByID( "entrance" ,nil ,-1);
            -- self:addChild(effect);
            APP:toScene(SCENE_ID_UPDATE)
            --APP:toScene(SCENE_ID_GAMEWORLD)
            --SCENE_ID_LOGIN
            --SCENE_ID_UPDATE
            --SCENE_ID_BATTLE
            --SCENE_ID_SELECT_HERO
            -- self:test();
            
            -- print(EffectManager:analysisEventType( "create_10001" ))

            --资源加载测试
            -- local loadlist = {
            --     "herores/zhangjiao/zj_font_s_1_0.png",
            --     "herores/zhangjiao/zj_font_e.png",
            --     "map/game_back_7.png",
            -- };
            -- ResLoad:setLoadList( loadlist , "test" );
            -- ResLoad:AsyncLoadRes(  );
            -- ResLoad:setCallback( function (  )
            --     print("加载完毕")
            --     print(GLOBAL_TEXTURE_CACHE:getCachedTextureInfo());
            -- end )
            -- print(math.deg(math.atan(0.5)))
            -- local view = require("app.views.battlefield.ui.UI_BattleOnhook_Bottom").new();
            -- self:addChild(view)
        end
    end

    self:registerScriptHandler(onNodeEvent)


end

function MainScene:tt( a ,b,c )
    return a + b + c;
end

function MainScene:test(  )
	--下载测试
    ManageResUpdate:InviData();
    ManageResUpdate:getCurrentVersion();
	ManageResUpdate:getServerUpDateCofig();
end

return MainScene
