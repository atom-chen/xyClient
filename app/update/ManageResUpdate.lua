--
-- Author: li yang
-- Date: 2013-12-13 17:01:47
-- 设备资源管理类(管理资源更新)

-- require("app.newres");--ResList
require("app.update.version")
-- require("lfs")

--[[
    --1.读取最新版本配置
]]

ManageResUpdate = {};

--版本更新文件
ManageResUpdate.UPDATA_VERSION_FILE = "version.lua";

ManageResUpdate.UPDATA_GSLIST_FILE = "gameUpdateInfo.lua";

--设备资源路径
-- ManageResUpdate.EQUIPMENT_RES_PATH = "res/";

--当前apk包版本信息
ManageResUpdate.GAME_NOW_APK_VERSION = 1.1;

--当前apk版本名称
ManageResUpdate.GAME_NOW_APK_NAME = "1.1";

--游戏当前版本号
ManageResUpdate.GAME_NOW_VERSION = 10006;

--游戏当前版本名称
ManageResUpdate.GAME_NOW_VERSION_NAME = "1.1";

-- 检测设备空间结果
ManageResUpdate.RESOUT_SPACE = 1;

-- 检测结果处理方式
ManageResUpdate.RESULT_HANDLE_TYPE = 1;



--下载大小监测
ManageResUpdate.DOWANLOAD_SIZE = 0;

--下载状态监测
ManageResUpdate.DOWANLOAD_STATE = 0;

--取得服务器列表信息
ManageResUpdate.DOWANLOAD_STATE_0 = 1;

--得到最新版本文件
ManageResUpdate.DOWANLOAD_STATE_1 = 2;

-- 得到版本资源信息
ManageResUpdate.DOWANLOAD_STATE_2 = 3;

--版本更新处理
ManageResUpdate.DOWANLOAD_STATE_3 = 4;

-- --更新出错
-- ManageResUpdate.DOWANLOAD_STATE_4 = 4;

-- --更新完成
-- ManageResUpdate.DOWANLOAD_STATE_FINISH = 5;

--更新状态
ManageResUpdate.STATE_UPDATE = 0;

--更新资源
ManageResUpdate.STATE_UPDATE_RES = 1;

--更新APK
ManageResUpdate.STATE_UPDATE_APK = 2;

ManageResUpdate.UpDataError = false;

ManageResUpdate.ErrorDescribe = "none";

--服务器标示 0:内网 1:外网 2:360 3:uc 4:当乐 5 
ManageResUpdate.ServerSign = 0;

--更新重启app(0 不重启 1 更新完成重启 2 中断重启)
ManageResUpdate.UpDataRestartApp = 0;

--[[
    urltype 类型 1 更新日志文件 2 更新版本文件
]]
function ManageResUpdate:getWebServerUrl( urltype )
    print("ManageResUpdate:getWebServerUrl 0",urltype)
    local url = "";
    if urltype == 1 then
        if self.ServerSign == 1 then
            url = "http://121.43.156.129/test/newres.lua";
        elseif self.ServerSign == 2 then
            url = "http://121.43.156.129/360/newres.lua";
        elseif self.ServerSign == 3 then
            url = "http://121.43.156.129/uc/newres.lua";
        elseif self.ServerSign == 4 then
            url = "http://121.43.156.129/dl/newres.lua";
        elseif self.ServerSign == 0 then 
            url = "http://10.10.1.203/test/newres.lua"; --url = "http://192.168.1.201/newres.lua";
        end
    elseif urltype == 2 then
        if self.ServerSign == 1 then
            url = "http://121.43.156.129/test/versionInfo.lua";
        elseif self.ServerSign == 2 then
            url = "http://121.43.156.129/360/versionInfo.lua";
        elseif self.ServerSign == 3 then
            url = "http://121.43.156.129/uc/versionInfo.lua";
        elseif self.ServerSign == 4 then
            url = "http://121.43.156.129/dl/versionInfo.lua";
        elseif self.ServerSign == 0 then
            url = "http://10.10.1.203/test/versionInfo.lua";--url = "http://192.168.1.201/newres.lua";
        end
    end
    print("ManageResUpdate:getWebServerUrl 1",urltype,url)
    return url;
end


function ManageResUpdate:InviUpDataTool(  )
    print("ManageResUpdate:InviUpDataTool:",self.UpDateTool)
    if not self.UpDateTool then
        
        --注册监听事件
        local function onError(errorCode)
            print("更新错误码:",errorCode);
            -- if errorCode == cc.ASSETSMANAGER_NO_NEW_VERSION then
            --     progressLable:setString("no new version")
            -- elseif errorCode == cc.ASSETSMANAGER_NETWORK then
            --     progressLable:setString("network error")
            -- end
        end

        local function onProgress( percent )
            -- local progress = string.format("downloading %d%%",percent)
            -- progressLable:setString(progress)
            print("更新百分百：",percent)
        end

        local function onSuccess()
            print("更新成功:",onSuccess)
            -- progressLable:setString("downloading ok")
             
        end

        local function onState( state )
            print("更新State:",state)
            -- progressLable:setString("downloading ok")
            -- if state == 1 then
            --     self:_copyFile(self.UPDATA_GSLIST_FILE);
            -- end
        end
        self.UpDateTool = cc.AssetsManagerM:new();
        self.UpDateTool:retain();
        self.UpDateTool:setDelegate(handler(self, self.ErrorUpDateLofic),cc.ASSETSMANAGER_PROTOCOL_ERROR );
        self.UpDateTool:setDelegate(handler(self, self.ProgressUpDateLogic), cc.ASSETSMANAGER_PROTOCOL_PROGRESS)
        self.UpDateTool:setDelegate(handler(self, self.SuccessUpDateLogic), cc.ASSETSMANAGER_PROTOCOL_SUCCESS )
        self.UpDateTool:setDelegate(onState, cc.ASSETSMANAGER_PROTOCOL_STATE )
        self.UpDateTool:setConnectionTimeout(3)
    end
    
end

--[[初始化数据
]]
function ManageResUpdate:InviData(  )
    --初始化更新工具
    self:InviUpDataTool(  );

    self.WritePath = cc.FileUtils:getInstance():getWritablePath();
    --设置临时文件夹地址
    self.TempFilePath = self.WritePath.."versioncheck/";
    --清除临时解压目录的文件
    self:rmdir(self.TempFilePath);
    --创建临时文件架
    local tt = self:mkdir(self.TempFilePath);
    print("ManageResUpdate:InviData",tt)
    --设置资源临时解压目录
    self.ResUnzipTmpDir = self.WritePath.."versioncheck/res/";
end


function replay_require( params )
    package.loaded[params] = nil;
    require(params);
end
---------------------游戏更新公告---------------------

function ManageResUpdate:LoadNotice(  )
    --初始化
    self:afreshTool();
     --创建临时文件架
    local tt = self:mkdir(self.TempFilePath);
    print("ManageResUpdate:InviData",tt)
    
    function LoadNoticeSuccess(  )
        logPrint("ManageResUpdate", "更新服务器列表成功")
        self:_copyFile(self.UPDATA_GSLIST_FILE);
        replay_require( self.UPDATA_GSLIST_FILE );
        -- local zouzhe = import("app.ui.UI_LoginZouzhe2.lua"):new()
        -- zouzhe:setPosition(ccp(display.cx, display.cy))
        -- display.getRunningScene():addChild(zouzhe, UI_ORDERCONST_TOP_DIALOG)
        self:clean();
    end
    function LoadNoticeFail(  )
        logPrint("ManageResUpdate", "更新服务器列表失败")
        self:clean();
    end
    if not self.UpDateTool then
        self.UpDateTool = Updater:new();
        --注册监听事件
        -- self.UpDateTool:registerScriptHandler( self.DownloadhandlerLogic );
        self.UpDateTool:registerScriptHandler( function ( event, value  )
            -- updater.state = event
            local stateValue = 1;
            if event == "success" then
                stateValue = value:getCString()
                print("公告下载成功",stateValue)
                LoadNoticeSuccess();
            elseif event == "error" then
                stateValue = value:getCString()
                print("资源更新失败:",stateValue);
                LoadNoticeFail();
            elseif event == "progress" then
                
            elseif event == "state" then
                stateValue = value:getCString()
            end
            -- print("回调函数",event,stateValue)
        end );

    end
    print("getServerUpDateCofig ",self.TempFilePath..self.UPDATA_GSLIST_FILE);
    -- local url = 1;
    self.UpDateTool:update(self:getWebServerUrl(1),self.TempFilePath..self.UPDATA_GSLIST_FILE)
end

--[[加载脚本
]]
function ManageResUpdate:LoadingScripte(  )
    --加载游戏更新信息
    print(self:exists(EQUIPMENT_UPDTE_PATH..self.UPDATA_GSLIST_FILE))
    if self:exists(EQUIPMENT_UPDTE_PATH..self.UPDATA_GSLIST_FILE) then
        require(self.UPDATA_GSLIST_FILE);
    end
    replay_require("app.models.init")
    -- replay_require("app.ui.UILayoutManager")
    --加载数据
    Data_Login:InviData();
    print("重读脚本")
    
end

-- --清理公共资源
-- function ManageResUpdate:RemoveCommonRes(  )
--     --清理
--     if not RELOAD_RES then
--         return;
--     end
--     --重新加载资源文件
--     for i,v in ipairs(RELOAD_RES) do
--         display.removeSpriteFramesWithFile(v.plist, v.image);
--     end
-- end

--更新公共资源
function ManageResUpdate:LoadingCommonRes(  )
    print("LoadingCommonRes")
    if not RELOAD_RES then
        return;
    end
    --重新加载资源文件
    for i,v in ipairs(RELOAD_RES) do
        display.removeSpriteFramesWithFile(v.plist, v.image);
    end

    for i,v in ipairs(RELOAD_RES) do
       display.addSpriteFramesWithFile(v.plist, v.image);
    end
    print("LoadingCommonRes 1");
end

--处理逻辑
function ManageResUpdate.DownloadhandlerLogic( event, value )
    -- updater.state = event
    local stateValue = 1;
    if event == "success" then
        stateValue = value:getCString()
        print("资源下载成功",stateValue)
        -- 调用成功后的处理函数
        if ManageResUpdate.SuccessUpDateLogic then
            ManageResUpdate:SuccessUpDateLogic();
        end
    elseif event == "error" then
        stateValue = value:getCString()
        print("资源更新失败:",stateValue);
        ManageResUpdate:ErrorUpDateLofic( stateValue );
    elseif event == "progress" then
        stateValue = tostring(value:getValue())
        ManageResUpdate:ProgressUpDateLogic( stateValue );
        
    elseif event == "state" then
        stateValue = value:getCString()
    end
    -- print("回调函数",event,stateValue)
end

--更新成功逻辑
function ManageResUpdate:SuccessUpDateLogic(  )
    if self.DOWANLOAD_STATE == self.DOWANLOAD_STATE_1 then

    elseif self.DOWANLOAD_STATE == self.DOWANLOAD_STATE_2 then
        --更新下载新
    elseif self.DOWANLOAD_STATE == self.DOWANLOAD_STATE_0 then
        --得到最新服务器列表信息
        printInfo("ManageResUpdate %s", "更新服务器列表成功")
        self:_copyFile(self.UPDATA_GSLIST_FILE);
        -- self:afreshTool(  );
        -- self:InviUpDataTool(  )
        ManageResUpdate:executeUpDataLogic(  );
    elseif self.DOWANLOAD_STATE == self.DOWANLOAD_STATE_3 then
        -- 进度登陆界面
        if self.STATE_UPDATE == self.STATE_UPDATE_RES then
            -- 成功之后更新资源列表，合并新资源
            self.RESULT_HANDLE_TYPE = 1;
            if self.ResListInfo.Replay_require then
                --重读更新逻辑脚本ManageResUpdate
                self:clean();
                replay_require( "app.update.ManageResUpdate" ); 
                --初始化版本检查
                ManageResUpdate:InviData(  );
                --得到当前版本信息
                -- ManageResUpdate:getCurrentVersion( )
                -- ManageResUpdate:executeUpDataLogic(  );
                -- return;
            elseif self.ResListInfo.restartApp and self.ResListInfo.restartApp == 2 then
                --强制重启应用
                --[[
                    1.判断更新包是否有需要强制重启的包
                    2.判断更新包重启类型(1.更新打断重启。2.更新完成重启)
                ]]
                dispatchGlobaleEvent( "models_update" ,"restart_game")
                return;
            else
                if self.ResListInfo.restartApp then
                    if self.ResListInfo.restartApp > self.UpDataRestartApp then
                        self.UpDataRestartApp = self.ResListInfo.restartApp;
                    end
                end
                --重新得到当前版本
                -- self:getCurrentVersion( );
                -- --重新执行更新逻辑
                -- self:ExecuteUpDateVersionLogic(  );
                -- --重新得到资源列表
                -- self:getResListInfo(  );

            end
            print("更新处理方式:",ManageResUpdate.RESULT_HANDLE_TYPE)
            self:executeDownLogic();
        elseif self.STATE_UPDATE == self.STATE_UPDATE_APK then
            -- 安装apk包
            print("安装apk");
            self:InstallApk( device.platform );
            self:clean();
        end
        -- 读取初始资源
    end
end


--更新错误逻辑
function ManageResUpdate:ErrorUpDateLofic( valuse )
    print("ManageResUpdate error:",self.DOWANLOAD_STATE,valuse)
    self.ErrorDescribe = valuse;
    if self.DOWANLOAD_STATE == self.DOWANLOAD_STATE_1 then
        self.DOWANLOAD_STATE = -1;
    elseif self.DOWANLOAD_STATE == self.DOWANLOAD_STATE_0 then
        self.DOWANLOAD_STATE = -1;
        --判断本地是否有服务器信息文件
        if not self:exists(EQUIPMENT_UPDTE_PATH..self.UPDATA_GSLIST_FILE) then
            self.UpDataError = true;
        end
        print("ManageResUpdate", "更新失败");
    elseif self.DOWANLOAD_STATE == self.DOWANLOAD_STATE_2 then
        self.DOWANLOAD_STATE = -1;
    elseif self.DOWANLOAD_STATE == self.DOWANLOAD_STATE_3 then
        -- self:clean();
    end
    self:clean();
    --发送更新失败事件
    dispatchGlobaleEvent( "models_update" ,"handler_check_result" ,{0,self.DOWANLOAD_STATE,self.STATE_UPDATE})
end

--更进度逻辑
function ManageResUpdate:ProgressUpDateLogic( stateValue )
    if self.DOWANLOAD_STATE == self.DOWANLOAD_STATE_1 then

    elseif self.DOWANLOAD_STATE == self.DOWANLOAD_STATE_1 then
        
    elseif self.DOWANLOAD_STATE == self.DOWANLOAD_STATE_3 then
        local showShow = "";
        if self.STATE_UPDATE == self.STATE_UPDATE_RES then
            --更新下载进度
            showShow = "更新包"..ManageResUpdate.UpDateVersion_order
        elseif self.STATE_UPDATE == self.STATE_UPDATE_APK then
           
            showShow = "下载安装包"
        end
        dispatchGlobaleEvent( "downprogress" ,"update_progress" ,{showShow,stateValue})
        -- print(stateValue,self.DOWANLOAD_STATE );
    end
   
end

--执行更新逻辑
function ManageResUpdate:executeUpDataLogic(  )
    --得到最新版本信息
    ManageResUpdate:getNewVersionInfo( "" );
    --得到最新服务器
    -- ManageResUpdate:getServerUpDateCofig(  );
    print("得到最新版本文件:",self.RESULT_HANDLE_TYPE)
end


--得到服务器更新文件
function ManageResUpdate:getServerUpDateCofig(  )
    self.DOWANLOAD_STATE = self.DOWANLOAD_STATE_0;
    print("getServerUpDateCofig ",self.TempFilePath..self.UPDATA_GSLIST_FILE);
    self.UpDateTool:update(self:getWebServerUrl(1),self.TempFilePath..self.UPDATA_GSLIST_FILE)
end

--得到当前版本
function ManageResUpdate:getCurrentVersion( )
    --得到处理版本信息

    --得到当前版本信息 
    if self:exists(EQUIPMENT_UPDTE_PATH..self.UPDATA_VERSION_FILE) then
        print("读取版本信息",EQUIPMENT_UPDTE_PATH..self.UPDATA_VERSION_FILE)
        -- package.loaded[modelname]
        package.loaded[self.UPDATA_VERSION_FILE] = nil;
        require(self.UPDATA_VERSION_FILE);
    else
        GAME_CURRENT_VERSION_INFO_NAME = "0.3.2";--为当前安装版本 GAME_VERSION_INFO_NAME
        GAME_CURRENT_APK_VERSION_INFO = GAME_VERSION_INFO_NAME;--为当前的安装版本信息    
    end
    printInfo("ManageResUpdate 初始化版本信息 %s", GAME_CURRENT_VERSION_INFO_NAME);
end

--执行版本更新逻辑
function ManageResUpdate:ExecuteUpDateVersionLogic(  )
    print( GAME_CURRENT_VERSION_INFO_NAME ,GAME_VERSION_INFO_NAME ,GAME_CURRENT_APK_VERSION_INFO)
    if self.NewVersionInfo then
        self.UpDateVersion_order ,self.UpDateVersion_Url = self.NewVersionInfo:versionCheckLogic(GAME_CURRENT_VERSION_INFO_NAME,GAME_VERSION_INFO_NAME,GAME_CURRENT_APK_VERSION_INFO);
        print("最新版本号,更新的版本,更新的地址",self.NewVersionInfo.version,self.UpDateVersion_order,self.UpDateVersion_Url)
    end
end

--[[得到现在最新的版本信息
]]
function ManageResUpdate:getNewVersionInfo( url )
    --http://286299.ichengyun.net/client_res/versionInfo.lua
    printInfo("ManageResUpdate check Version %s",self.DOWANLOAD_STATE)
    --更新服务器列表出错superelement
    if self.DOWANLOAD_STATE == -1 then
        return;
    end
    self.DOWANLOAD_STATE = self.DOWANLOAD_STATE_1
    local versionInfo = self.UpDateTool:getUpdateInfo(self:getWebServerUrl(2));
    printInfo("ManageResUpdate Version info %s",versionInfo)
    --读取外部 -- or string.find(versionInfo,"")
    if versionInfo == "" then
        printInfo("ManageResUpdate check Version %s", "读取版本信息错误")
        return;
    end
    --执行版本检查逻辑
    self.NewVersionInfo = assert(loadstring(versionInfo))();
    -- self:ExecuteUpDateVersionLogic();
    -- --得到资源列表信息
    -- ManageResUpdate:getResListInfo( "" )
    --检查版本
    self:checkVersion();
end

--检查版本
function ManageResUpdate:checkVersion(  )
    self:ExecuteUpDateVersionLogic();
    --执行检查处理结果
    local handletype = self:HandleType();
    local fileSize = 0;
    if self.NewVersionInfo and self.NewVersionInfo.getUpdateFileSize then
        fileSize = self.NewVersionInfo:getUpdateFileSize( GAME_CURRENT_VERSION_INFO_NAME );
    end
    -- print("ManageResUpdate:checkVersion",handletype)
    dispatchGlobaleEvent( "models_update" ,"handler_check_result" ,{handletype,self.DOWANLOAD_STATE,self.STATE_UPDATE, fileSize})
end

--[[得到资源列表信息
]]
function ManageResUpdate:getResListInfo( url )
    --更新版本资源错误 或 更新的版本为当前版本
    if self.DOWANLOAD_STATE == -1 then
        return false;
    end
    if self.UpDateVersion_order == "" or self.UpDateVersion_order == GAME_CURRENT_VERSION_INFO_NAME then
         --得到处理方式
        -- ManageResUpdate:HandleType(  );
        return false;
    end
    printInfo("ManageResUpdate down Version file: %s",self.DOWANLOAD_STATE_2)
    self.DOWANLOAD_STATE = self.DOWANLOAD_STATE_2
    --更新资源地址 self.UpDateVersion_Url
    local resInfo = self.UpDateTool:getUpdateInfo(self.UpDateVersion_Url);
    --读取外部
    printInfo("ManageResUpdate down Version fileList info: %s", resInfo)
    if resInfo == "" then
        printInfo("ManageResUpdate down Version file: %s", "读取资源列表信息错误")
        --得到处理方式
        -- ManageResUpdate:HandleType(  );
        return false;
    end
    self.ResListInfo = assert(loadstring(resInfo),"error")();
    printInfo("ManageResUpdate down Version fileList number: %s",self.ResListInfo.version);
    --执行处理逻辑
    if  self.ResListInfo.executeLogic then
        self.ResListInfo.executeLogic();--版本处理逻辑
    end
    
    --更新包下载地址
    -- self.ResListInfo.res_download_url = "http://nb.baidupcs.com/file/a99053a3222a7a69fc2da0feb8030e8d?bkt=p2-nb-903&fid=3491461525-250528-23439489601798&time=1414375880&sign=FDTAXERB-DCb740ccc5511e5e8fedcff06b081203-gpP20n5UjcipGJ2j32EHTgmtuHU%3D&to=nbb&fm=Nin,B,T,&newver=1&newfm=1&flow_ver=3&expires=8h&rt=pr&r=646512860&mlogid=1450302111&vuk=3491461525&vbdid=1137265122&ifn=updatefile.zip&fn=updatefile.zip";
    --"http://download.5211game.com/11/gamepatch/war3/gp_0207.zip";
    printInfo("ManageResUpdate down Version zipFile Path: %s %s",self.UpDateVersion_order,self.ResListInfo.res_download_url)
    --得到处理方式
    -- ManageResUpdate:HandleType(  );
    return true;
end

--执行下载逻辑
function ManageResUpdate:executeDownLogic()
    if self.DOWANLOAD_STATE == -1 then
        return false;
    end
    --重新得到当前版本
    self:getCurrentVersion( );
    --重新执行更新逻辑
    self:ExecuteUpDateVersionLogic(  );
    --更新处理方式
    self:HandleType();
    print("更新处理方式:",ManageResUpdate.RESULT_HANDLE_TYPE)
    if ManageResUpdate.RESULT_HANDLE_TYPE == 2 then
        --下载更新包
        --得到res版本信息
        local downlist = self:getResListInfo(  );
        if downlist then
            self:DownloadResFileZip( "" );
        end
    elseif ManageResUpdate.RESULT_HANDLE_TYPE == 3 then
        --下载apk
        self:DownloadApk( "" )
    else
        --更新完成
        print("ManageResUpdate into login")
        self:clean();
        if self.UpDataRestartApp > 0 then
            --重启界面
            dispatchGlobaleEvent( "models_update" ,"restart_game")
            return;
        end
        --加载配置文件
        ManageResUpdate:LoadingScripte(  );
        --更新公共资源
        ManageResUpdate:LoadingCommonRes(  );
        dispatchGlobaleEvent( "models_update" ,"succee")
    end
     self.DOWANLOAD_STATE = self.DOWANLOAD_STATE_3;
end

CONST_DOWN_NAME = "updatefile_";
--[[下载资源zip文件
]]
function ManageResUpdate:DownloadResFileZip( url )

    local savename = string.gsub(self.ResListInfo.version ,"%p","_");
    
    savename = CONST_DOWN_NAME..savename..".zip"
    print("DownloadResFileZip:",self.ResListInfo.res_download_url);
    print("DownloadResFileZip:",self.TempFilePath..savename);
    print("DownloadResFileZip:",EQUIPMENT_UPDTE_PATH);
    -- printInfo("ManageResUpdate DownloadResFileZip %s %s ",savename)
    self.UpDateTool:update(self.ResListInfo.res_download_url, self.TempFilePath..savename, EQUIPMENT_UPDTE_PATH,false); 
end

CONST_DOWN_APK_NAME = "sghgz.apk";
function ManageResUpdate:DownloadApk( url )
    print("下载apk:",EQUIPMENT_SD_RES_PATH..CONST_DOWN_APK_NAME);
    --http://286299.ichengyun.net/client_res/sghgz_1.apk
    self.UpDateTool:update(self.NewVersionInfo.install_apk_url, EQUIPMENT_SD_RES_PATH..CONST_DOWN_APK_NAME);
end

--下一个要更新的版本位置
ManageResUpdate.Next_Version_pos = 0;

--得到处理方式
function ManageResUpdate:HandleType(  )
    
    print("进入检查更新处理方式")
    function checkVersion(  )
        -- 得到处理方式
        --[[处理方式
             1 已经是最新版本
             2 下载资源
             3 更新apk包
             4 windows 更新apk 包处理
             5 资源数据有问题重新下载资源包
             6 游戏更新中
        ]]
        -- 处理方式 1 已经是最新版本 2 下载资源 3 设备空间不够 4 资源数据有问题重新下载资源包
        local HandleType = 1;
        --判断是否维护
        if self.NewVersionInfo.isMaintenance then
            if (not ClientType) or ClientType == 0 then
                self.RESULT_HANDLE_TYPE = 6;
                return 6;
            end
        end
        --判断apk安装版本是否正确
        -- local NowsMainVersion = string.sub(self.NewVersionInfo.version , 1 ,2);
        -- NowsMainVersion = NowsMainVersion.."0.0.0";
        -- print("apk_version",NowsMainVersion)
        if GAME_VERSION_INFO_NAME < self.NewVersionInfo.version then
            self.RESULT_HANDLE_TYPE = 3;--下载最新的apk包
            self.STATE_UPDATE = 2;
            if device.platform == "windows" then
                self.RESULT_HANDLE_TYPE = 4; --windows 更新包处理
            end
            return self.RESULT_HANDLE_TYPE;
        end
        --当前大版本大于最新版本 不更新小版本
        if GAME_VERSION_INFO_NAME > self.NewVersionInfo.version then
            self.RESULT_HANDLE_TYPE = 1;
            return 1;
        end
        if self.UpDateVersion_order == GAME_CURRENT_VERSION_INFO_NAME then
            self.RESULT_HANDLE_TYPE = 1;--当前为最新版本
            return 1;
        end
        
        --版本不对
        if GAME_CURRENT_VERSION_INFO_NAME < self.UpDateVersion_order then
            self.RESULT_HANDLE_TYPE = 2; --下载新的资源
            self.STATE_UPDATE = 1;
            return 2;
        end
    end
    handerType = checkVersion();
    return handerType;
end

--[[检查文件是否存在
]]
function ManageResUpdate:exists(path)
    return cc.FileUtils:getInstance():isFileExist(path)
end

--[[创建文件夹
]]
function ManageResUpdate:mkdir(path)
    if not self:exists(path) then
        return cc.FileUtils:getInstance():createDirectory(path)
    end
    return true
end

function ManageResUpdate:afreshTool(  )
    if self.UpDateTool then
        self.UpDateTool:unregisterScriptHandler()
        self.UpDateTool:delete()
        self.UpDateTool = nil
    end
end

function ManageResUpdate:clean()
    print("ManageResUpdate:clean")
    --释放下载工具
    if self.UpDateTool then
         self.UpDateTool:release();
    end
    self.UpDateTool = nil;
    --清空文件夹
    local cc = self:rmdir(self.TempFilePath);
    print("ManageResUpdate:clean",cc)
end

function ManageResUpdate:checkPathMode( path )
    if self:exists(path) then
        return "file";
    end
    if cc.FileUtils:getInstance():isDirectoryExist(path) then
        return "directory";
    end
    return nil;
end

--[[ 去掉临时目录
]]
function ManageResUpdate:rmdir(path)
    printInfo("ManageResUpdate %s", "ManageResUpdate.rmdir "..path)
    if not self:checkPathMode( path ) then
        return false;
    end
   
    return cc.FileUtils:getInstance():removeDirectory(path);
end

--[[读文件
]]
function ManageResUpdate:readFile(path)
    return cc.FileUtils:getInstance():getStringFromFile(path)
end

--[[写文件
    path 写文件路径
    content 内容
    mode 模式
]]
function ManageResUpdate:writeFile(path, content, mode)
    mode = mode or "w+b"
    local file = io.open(path, mode)
    if file then
        if file:write(content) == nil then return false end
        io.close(file)
        return true
    else
        return false
    end
end

--[[ 从临时资源文件下 复制一个新文件到更新目录
    filepath 复制保存文件的路径参数
]]
function ManageResUpdate:_copyFile(filepath)
    -- Create nonexistent directory in update res.
    local i,j = 1,1
    --判断是否有目录
    while true do
        j = string.find(filepath, "/", i)
        if j == nil then 
            break 
        end
        local dir = string.sub(filepath, 1,j)
        -- Save created directory flag to a table because
        -- the io operation is too slow.
        if not self._dirList[dir] then
            self._dirList[dir] = true
            local fullUDir = EQUIPMENT_UPDTE_PATH..dir;
            print("创建目录:",fullUDir)
            self:mkdir(fullUDir) --创建目录
        end
        i = j+1
    end
    local fullFileInURes = EQUIPMENT_UPDTE_PATH..filepath -- 资源位置
    local fullFileInUTmp = self.TempFilePath..filepath --资源临时位置
    print(string.format('copy %s to %s', fullFileInUTmp, fullFileInURes))
    local zipFileContent = self:readFile(fullFileInUTmp)
    if zipFileContent then
        self:writeFile(fullFileInURes, zipFileContent)
        return fullFileInURes
    end
    return nil
end

--[[ 复制一个新文件
    resInZip 文件的路径参数
]]
function ManageResUpdate:_copyNewFile(resInZip)
    -- Create nonexistent directory in update res.
    local i,j = 1,1
    --判断是否有目录
    while true do
        j = string.find(resInZip, "/", i)
        if j == nil then 
            break 
        end
        local dir = string.sub(resInZip, 1,j)
        -- Save created directory flag to a table because
        -- the io operation is too slow.
        if not self._dirList[dir] then
            self._dirList[dir] = true
            local fullUDir = EQUIPMENT_RES_PATH..dir;
            print("创建目录:",fullUDir)
            self:mkdir(fullUDir) --创建目录
        end
        i = j+1
    end
    local fullFileInURes = EQUIPMENT_RES_PATH..resInZip -- 资源位置
    local fullFileInUTmp = self.ResUnzipTmpDir..resInZip --资源临时位置
    print(string.format('copy %s to %s', fullFileInUTmp, fullFileInURes))
    local zipFileContent = self:readFile(fullFileInUTmp)
    if zipFileContent then
        self:writeFile(fullFileInURes, zipFileContent)
        return fullFileInURes
    end
    return nil
end

--[[拷贝一个文件列表
]]
function ManageResUpdate:_copyNewFilesBatch(resType, resInfoInZip)
    local resList = resInfoInZip[resType]
    if not resList then 
        print("resList nil")
        return 
    end
    -- local finalRes = finalResInfo[resType]
    for __,v in ipairs(resList) do
        local fullFileInURes = self:_copyNewFile(v)
        if fullFileInURes then
            -- Update key and file in the finalResInfo
            -- Ignores the update package because it has been in memory.
            -- if v ~= "res/lib/update.zip" then
            --     finalRes[v] = fullFileInURes
            -- end
        else
            print(string.format("updater ERROR, copy file %s.", v))
        end
    end
end

--更新拷贝资源
function ManageResUpdate:updateFinalResInfo()
    -- assert(localResInfo and remoteResInfo,
    --     "Perform updater.checkUpdate() first!")
    -- if not finalResInfo then
    --     finalResInfo = updater.clone(localResInfo)
    -- end
    --do return end

    -- local resInfoTxt = updater.readFile(zresinfo)
    -- local zipResInfo = assert(loadstring(resInfoTxt))()
    -- if zipResInfo["version"] then
    --     finalResInfo.version = zipResInfo["version"]
    -- end
    -- Save a dir list maked.
    print("资源更新界面")
    self._dirList = {}
    self:_copyNewFilesBatch("resConfig", self.ResListInfo) --拷贝资源列表
    -- updater._copyNewFilesBatch("oth", zipResInfo)
    -- Clean dir list.
    self._dirList = nil
    self:rmdir(self.ResUnzipTmpDir)
    -- local dumpTable = updater.vardump(finalResInfo, "local data", true)
    -- dumpTable[#dumpTable+1] = "return data"
    -- if updater.writeFile(uresinfo, table.concat(dumpTable, "\n")) then
    --     return true
    -- end
    -- print(string.format("updater ERROR, write file %s.", uresinfo))
    return false
end



--安装apk 包
function ManageResUpdate:InstallApk( equipment )
    -- 更下下载资源
    if equipment == "android" then
        local  javaClassName = getAndroidPackageName().."Sghzg"
        local javaMethodName = "SendOperateMessage"
        local javaParams = {
            -- function ( pathName )
            --     -- body
             --     EQUIPMENT_RES_PATH = pathName;
                                
            -- end
            1,
        }
        local javaMethodSig = "(I)V"
        luaj.callStaticMethod(javaClassName, javaMethodName, javaParams, javaMethodSig);
    elseif equipment == "ios" then
            --todo
    else

    end
end
