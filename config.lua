
-- 0 - disable debug info, 1 - less debug info, 2 - verbose debug info
DEBUG = 2

-- use framework, will disable all deprecated API, false - use legacy API
CC_USE_FRAMEWORK = true

-- show FPS on screen
CC_SHOW_FPS = true

-- disable create unexpected global variable
CC_DISABLE_GLOBAL = false

--是否显示纹理内存占用信息
SHOW_TEXTURE_CACHE_INFO = false

CC_DESIGN_RESOLUTION = {
    width = 1280,
    height = 720,
    autoscale = "FIXED_WIDTH",
    -- callback = function(framesize)
    --     local ratio = framesize.width / framesize.height
    --     if ratio <= 1.34 then
    --         -- iPad 768*1024(1536*2048) is 4:3 screen
    --         return {autoscale = "FIXED_WIDTH"}
    --     end
    -- end
}

function CallAndroidPrint( str )
    if (not device) or device.platform ~= "android" then
        return;
    end
    local args = {str};
    -- local jstr = "Ljava/lang/String;"
    local javaMethodSig = "(Ljava/lang/String;)V"
    local luaj = require("cocos.cocos2d.luaj")
    local className = "org/cocos2dx/lua/AppActivity"
    local ok,ret  = luaj.callStaticMethod(className,"PrintAndroidLog",args,javaMethodSig)
end

-- for module display
-- CC_DESIGN_RESOLUTION = {
--     width = 1280,
--     height = 720,
--     autoscale = "NO_BORDER",
--     callback = function(framesize)
--         -- local scale = framesize.width / framesize.height
--         -- contentPixelScale = 1;--像素比例
--         -- if scale > CONFIG_SCALE  then
--         --     CONFIG_FILL_TYPE = 1;
--         --     contentPixelScale =CONFIG_SCREEN_HEIGHT / framesize.height;
--         --     CONFIG_SCREEN_WIDTH = contentPixelScale * framesize.width;
--         --     CONFIG_SCREEN_HEIGHT = 720;
--         -- elseif scale < CONFIG_SCALE then
--         --     contentPixelScale = CONFIG_MAKE_WIDTH / framesize.width;
--         --     CONFIG_SCREEN_WIDTH = 1280;
--         --     CONFIG_SCREEN_HEIGHT = contentPixelScale * framesize.height;
--         --     CONFIG_FILL_TYPE = 2;
--         -- end


--         -- -- CONFIG_VARIABLE_H = CONFIG_MAKE_HEIGHT - 960 ; --CONFIG_SCREEN_HEIGHT
--         -- -- CONFIG_VARIABLE_scale = CONFIG_MAKE_HEIGHT / 960;
--         -- -- CONFIG_SCREEN_RESOLUTION_TYPE = kResolutionShowAll
--         -- print("CONFIG_SCREEN_HEIGHT:",CONFIG_SCREEN_HEIGHT)
--         -- print("CONFIG_SCREEN_WIDTH:",CONFIG_SCREEN_WIDTH)
--         -- print("CONFIG_SCREEN:",CONFIG_FILL_TYPE,framesize.width,framesize.height)
--         local currentshow_w = framesize.height / 720 * 1280;
--         -- if currentshow_w < 1280 then
--         --     print("================")
--         --     return {width = 1280 ,height = 720,autoscale = "NO_BORDER"};
--         -- end
--         -- return {width = 1280 ,height = 720,autoscale = "NO_BORDER"};
--     end
-- }
