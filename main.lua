
cc.FileUtils:getInstance():setPopupNotify(false)
cc.FileUtils:getInstance():addSearchPath("src/")
-- cc.FileUtils:getInstance():addSearchPath("res/")
print("==============================>")
require "config"
require "cocos.init"

require("app.update.GameUpdateConfig")

require("app.update.ManageResUpdate")



local function main()
    require("app.MyApp"):create():run()
end

local status, msg = xpcall(main, __G__TRACKBACK__)
if not status then
    print(msg)
end
