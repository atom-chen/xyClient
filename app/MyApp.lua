
local MyApp = class("MyApp", cc.load("mvc").AppBase)
CallAndroidPrint("MyApp:onCreate 0")
require("app.commonLib.init")
require("app.tools.init")
require("app.public.init")
require("app.net.init")
require("app.components.init")
require("app.commands.init")
require("app.config.init")
require("app.models.init")
require("app.views.UI_Manager")
require("app.manager.init")
require("app.skill.init")
require("app.effect.EffectManager")
require("app.views.battlefield.ManagerBattle")
CallAndroidPrint("MyApp:onCreate 000")

function MyApp:onCreate()
	CallAndroidPrint("MyApp:onCreate 1")
    APP = self
    math.randomseed(os.time())
    cc.bind(self, "appSceneManager")
end


return MyApp
