--
-- Author: li yang
-- Date: 2015-07-03 16:05:01
-- 游戏更新设置

-- require("lfs")

--设备更新资源目录
EQUIPMENT_UPDTE_PATH = cc.FileUtils:getInstance():getWritablePath().."updatefile/";
-- 设备sd卡路径
EQUIPMENT_SD_RES_PATH = "";
-- 图片资源更新目录
EQUIPMENT_RES_PATH = "res/";
-- 脚本更新目录
EQUIPMENT_SCRIPTS_PATH = "";

--设备资源路径设置逻辑
function SetEquipmentLogic( equipment)
	
    printInfo("GameUpDate %s","设置设备的资源路径"..equipment)
    print(printInfo)
	if equipment == "android" then
		-- local  javaClassName = getAndroidPackageName().."ManageFile"
  --       local javaMethodName = "InitializeFilePath"
  --       local javaParams = {
  --           "/xydata/",
  --           function ( pathName )
  --               -- 设备sd卡路径
  --               EQUIPMENT_SD_RES_PATH = pathName;
  --           end
  --       }
  --       local javaMethodSig = "(Ljava/lang/String;I)V"
  --       luaj.callStaticMethod(javaClassName, javaMethodName, javaParams, javaMethodSig);
  --       if EQUIPMENT_SD_RES_PATH == "SDError" then
  --           printInfo("SD卡目录错误 %s",EQUIPMENT_SD_RES_PATH);
  --           self.EQUIPMENT_SD_RES_PATH = cc.FileUtils:getInstance():getWritablePath().."xydata/";
  --       end
    elseif equipment == "ios" then
        --todo
    else
    	EQUIPMENT_SD_RES_PATH = cc.FileUtils:getInstance():getWritablePath().."xydata/";
	end
    printInfo("设备可写路径 %s",cc.FileUtils:getInstance():getWritablePath());
    printInfo("设备sd卡路径 %s",EQUIPMENT_SD_RES_PATH);
    -- require "lfs"
    --创建文件夹
    if not cc.FileUtils:getInstance():isFileExist(EQUIPMENT_SD_RES_PATH) then
        print("==========")
        -- lfs.mkdir(EQUIPMENT_SD_RES_PATH)
        cc.FileUtils:getInstance():createDirectory(EQUIPMENT_SD_RES_PATH)
    end
    -- self:mkdir(self.EQUIPMENT_SD_RES_PATH);
    --可写目录
    local WritePath = cc.FileUtils:getInstance():getWritablePath();
    --设置更新资源搜索路径
    EQUIPMENT_UPDTE_PATH = WritePath.."updatefile/";
    cc.FileUtils:getInstance():addSearchPath(EQUIPMENT_UPDTE_PATH);
    --创建更新目录
    if not cc.FileUtils:getInstance():isFileExist(EQUIPMENT_UPDTE_PATH) then
        -- lfs.mkdir(EQUIPMENT_UPDTE_PATH)
        cc.FileUtils:getInstance():createDirectory(EQUIPMENT_UPDTE_PATH)
    end
    -- self:mkdir(self.EQUIPMENT_UPDTE_PATH); --创建文件夹
    printInfo("SetEquipmentLogic %s", EQUIPMENT_UPDTE_PATH)

	-- 设置图片资源搜索路径
    EQUIPMENT_RES_PATH = EQUIPMENT_UPDTE_PATH.."update_res/";
    --更新资源根目录
    RES_UPDATE_ROOT_DIR = "update_res/";
    --创建文件夹
    if not cc.FileUtils:getInstance():isFileExist(EQUIPMENT_RES_PATH) then
        -- lfs.mkdir(EQUIPMENT_RES_PATH)
        cc.FileUtils:getInstance():createDirectory(EQUIPMENT_RES_PATH)
    end
    cc.FileUtils:getInstance():addSearchPath(EQUIPMENT_RES_PATH,true);

    --- 设置脚本搜索路径
    EQUIPMENT_SCRIPTS_PATH = EQUIPMENT_UPDTE_PATH.."update_scripts/";
    -- print("脚本搜索路径",package.path);
    --创建文件夹
    if not cc.FileUtils:getInstance():isFileExist(EQUIPMENT_SCRIPTS_PATH) then
        -- lfs.mkdir(EQUIPMENT_SCRIPTS_PATH)
        cc.FileUtils:getInstance():createDirectory(EQUIPMENT_SCRIPTS_PATH)
    end
    cc.FileUtils:getInstance():addSearchPath(EQUIPMENT_SCRIPTS_PATH,true);
    SCRIPE_UPDATE_ROOT_DIR = "update_scripts/";

    printInfo("更新日志->[ManageRes:76]","资源路径: %s"..EQUIPMENT_RES_PATH..","..EQUIPMENT_SCRIPTS_PATH)
    
    -- --设置临时文件夹地址
    -- self.TempFilePath = self.WritePath.."versioncheck/";
    -- --清除临时解压目录的文件
    -- self:rmdir(self.TempFilePath);
    -- --创建临时文件架
    -- self:mkdir(self.TempFilePath);
    -- --设置资源临时解压目录
    -- self.ResUnzipTmpDir = self.WritePath.."versioncheck/res/";

    --设置本机查找文件目录
    cc.FileUtils:getInstance():addSearchPath("res/")
    
    -- package.path = package.path .. ";" .. EQUIPMENT_UPDTE_PATH .."?.lua";
    -- print("package.path",package.path)
    
    -- print("[]]]]")
    -- local searchPathList = cc.FileUtils:getInstance():getSearchResolutionsOrder()
    -- for k,v in pairs(searchPathList) do
    --     print(k,v)
    -- end
    -- print("-------------------------------------------------")
    -- local earchPaths = cc.FileUtils:getInstance():getSearchPaths()
    -- for k,v in pairs(earchPaths) do
    --     print(k,v)
    -- end
    -- require("version")
    -- print(package.path)
end
SetEquipmentLogic(device.platform);