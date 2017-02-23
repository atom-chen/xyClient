--
-- Author: lipeng
-- Date: 2015-06-15 13:54:55
-- 组件: 应用程序场景管理

---------------------------
--场景ID定义
---------------------------
--应用程序入口场景
SCENE_ID_MAIN = "SCENE_MAIN"
--LOGO场景
SCENE_ID_LOGO = "SCENE_LOGO"
--游戏更新场景
SCENE_ID_UPDATE = "SCENE_UPDATE"
--登陆场景
SCENE_ID_LOGIN = "SCENE_LOGIN"
--选择英雄场景
SCENE_ID_SELECT_HERO = "SCENE_SELECT_HERO"
--游戏世界资源加载场景
SCENE_ID_GAMEWORLD_RES_LOADING = "SCENE_GAMEWORLD_RES_LOADING"
--游戏世界场景
SCENE_ID_GAMEWORLD = "SCENE_GAMEWORLD"
--战斗资源加载场景
SCENE_ID_BATTLE_RES_LOADING = "SCENE_BATTLE_RES_LOADING"
--战斗场景
SCENE_ID_BATTLE = "SCENE_BATTLE"

---------------------------
--场景事件名定义
---------------------------
--场景切换事件
EVENT_SCENE_TRANSITION_BEFORE = "EVENT_SCENE_TRANSITION_BEFORE"



local appSceneManager = class("component_appSceneManager")

local EXPORTED_METHODS = {
    "getCurScene",
    "toScene",
    "IsCanResumeConnect",
}

function appSceneManager:init_()
    self.target_ = nil
    --当前场景ID
	self.curSceneID = SCENE_ID_MAIN
    --当前场景
    self.curScene = nil
end

function appSceneManager:bind(target)
    self:init_()
    cc.setmethods(target, self, EXPORTED_METHODS)
    self.target_ = target
end

function appSceneManager:unbind(target)
    cc.unsetmethods(target, EXPORTED_METHODS)
    self:init_()
end

function appSceneManager:getCurScene()
    return self.curScene
end


function appSceneManager:toScene(sceneID)
	local event = cc.EventCustom:new(EVENT_SCENE_TRANSITION_BEFORE)
	local _outSceneID = self.curSceneID
	local _inSceneID = sceneID

    event._usedata = {
    	outSceneID = _outSceneID,
    	inSceneID = _inSceneID
    }
	GLOBAL_EVENT_DISPTACHER:dispatchEvent(event)

	if sceneID == SCENE_ID_LOGO then
		self:_toLogoScene(_outSceneID, _inSceneID)

	elseif sceneID == SCENE_ID_LOGIN then
		self:_toLoginScene(_outSceneID, _inSceneID)

    elseif sceneID == SCENE_ID_GAMEWORLD then
        self:_toGameWorldScene(_outSceneID, _inSceneID)
    elseif sceneID == SCENE_ID_UPDATE then
        self:_toGameUpdateScene(_outSceneID, _inSceneID)
    elseif sceneID == SCENE_ID_BATTLE then
        self:_toBattleScene(_outSceneID, _inSceneID)
    elseif sceneID == SCENE_ID_SELECT_HERO then
        self:_toInviHeroScene(_outSceneID, _inSceneID)
    elseif sceneID == SCENE_ID_GAMEWORLD_RES_LOADING then
        self:_toLoadresScene(_outSceneID, _inSceneID)
	end

    self.curSceneID = sceneID
end

function appSceneManager:getCurSceneID()
    return self.curSceneID
end

--判断是否能重连
function appSceneManager:IsCanResumeConnect()
    if self.curSceneID == SCENE_ID_GAMEWORLD or self.curSceneID == SCENE_ID_BATTLE then
        return true;
    end
    return false;
end


function appSceneManager:_toLogoScene( outSceneID, inSceneID )
	self.curScene = self.target_:enterScene("LogoScene", "FADE", 2)
end

function appSceneManager:_toLoginScene( outSceneID, inSceneID )
	self.curScene = self.target_:enterScene("LoginScene", "FADE", 2)
end

function appSceneManager:_toGameWorldScene( outSceneID, inSceneID )
    if not self.gameMainScene then
        self.curScene = self.target_:enterScene("GameWorldScene", "FADE", 2)
        self.curScene:retain()
        self.gameMainScene = self.curScene;
    else
        self.gameMainScene:showWithScene( "FADE", 2, nil);
        self.curScene = self.gameMainScene;
    end
end

function appSceneManager:_toGameUpdateScene( outSceneID, inSceneID )
    self.curScene = self.target_:enterScene("VersionCheckScene", "FADE", 2)
end

function appSceneManager:_toBattleScene( outSceneID, inSceneID )
    self.curScene = self.target_:enterScene("BattlefieldScene", "FADE", 2)
end

function appSceneManager:_toInviHeroScene( outSceneID, inSceneID )
    self.curScene = self.target_:enterScene("InitHeroScene", "FADE", 2)
end

function appSceneManager:_toLoadresScene( outSceneID, inSceneID )
    self.curScene = self.target_:enterScene("LoadScene", "FADE", 2)
end


return appSceneManager




