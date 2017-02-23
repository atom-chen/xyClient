--
-- Author: lipeng
-- Date: 2015-08-06 11:18:05
-- 


local onCommand = TEST_CMD_SERVER_MSG

onCommand["MSG_MS2C_UPDATE_GUILD_LIST"] = function ( parmas )
	printLog("测试命令日志", "[更新公会列表回复] 消息(MSG_MS2C_UPDATE_GUILD_LIST)数据： ")
	local msgData = {}
    msgData.guildNum = 16
    msgData.guildList = {}

    printLog("测试命令日志", "公会数量: "..msgData.guildNum)

    local guildData = nil
    for i=1, msgData.guildNum do
        msgData.guildList[i] = {}
        guildData = msgData.guildList[i]
        guildData.guid = tostring(i)
        guildData.name = "军团"..i
        guildData.declaration = "军团描述"..i
        guildData.faZhanDu = i*100
        guildData.memberCurNum = i
        guildData.memberMaxNum = i*10
        guildData.isApply = false -- 是否已经申请过
        guildData.managerName = "军团长"..i--会长名

        printLog("测试命令日志", "公会ID: "..guildData.guid..
        	"公会名: "..guildData.name..
        	"宣言内容: "..guildData.declaration..
        	"发展度: "..guildData.faZhanDu..
        	"成员数量: "..guildData.memberCurNum..
        	"成员数量上限: "..guildData.memberMaxNum..
        	"是否已经申请过: "..tostring(guildData.isApply)..
        	"军团长: "..guildData.managerName
        )
    end

    dispatchGlobaleEvent("net", tostring(MSG_MS2C_UPDATE_GUILD_LIST), {msgData = msgData})
end



onCommand["MSG_MS2C_GUILD_CREATE"] = function ( parmas )
    local msgData = {}

    msgData.result = eGUILD_CreateSuccess

    printLog("测试命令日志",
            "[创建公会回复] 消息(MSG_MS2C_GUILD_CREATE)："..msgData.result
    )
    
    if eGUILD_CreateSuccess == msgData.result then
        msgData.guildGUID = "123"
        MAIN_PLAYER:getGuild():setGUID(msgData.guildGUID)

        msgData.post = 1
        MAIN_PLAYER:getGuild():setPost(msgData.post)

        --发送获取公会信息请求
        --printLog("测试命令日志"," 发送获取公会信息请求: ")
        --gameTcp:SendMessage(MSG_C2MS_GUILD_GETINFO)

        printLog("测试命令日志", "GUID: "..msgData.guildGUID..", 官职: "..
                msgData.post)
    else
        -- 创建错误提示
        UIManager:CreatePrompt_Operate( {
            title = "提示",
            content = getErrorDescribe( msgData.result ),
        } )
    end
    
    dispatchGlobaleEvent("net", tostring(MSG_MS2C_GUILD_CREATE), {msgData = msgData})
end




onCommand["MSG_MS2C_GUILD_GETINFO"] = function ( parmas )
    local msgData = {}
    msgData.result = eGUILD_FindSucced

    printLog("测试命令日志",
        "[获取公会信息回复] 消息(MSG_MS2C_GUILD_GETINFO), 结果: %d", 
        msgData.result
    )

    if msgData.result == eGUILD_FindSucced then
        msgData.curPopularity = 999 -- 公会当前资源
        msgData.name = "测试公会" -- 公会名称
        msgData.declaration = "公会宣言测试" -- 公会宣言
        msgData.announcement = "公会公告测试" -- 公会公告
        msgData.lv = 1 -- 发展度
        msgData.curMemberNum = 10 -- 当前成员数量
        msgData.maxMemberNum = 20 -- 最大成员数量
        msgData.systemMsgNum = 10 -- 事件内容的条数

        msgData.systemMsgList = {}

        printLog("测试命令日志", "系统消息数量:"..msgData.systemMsgNum)
        for i=1, msgData.systemMsgNum do
            msgData.systemMsgList[i] = "事件内容"..i --事件内容
            printLog("测试命令日志", msgData.systemMsgList[i])
        end

        local guildData = MAIN_PLAYER:getGuild()
        guildData:setLv(msgData.lv)
        guildData:setCurPopularValue(msgData.curPopularity)
        guildData:setName(msgData.name)
        guildData:setDeclarationContent(msgData.declaration)
        guildData:setAnnouncementContent(msgData.announcement)
        guildData:setMemberCurNum(msgData.curMemberNum)
        guildData:setSystemMsgList(msgData.systemMsgList)

        printLog("测试命令日志",
            "公会等级 "..msgData.lv..
            ", 当前资源"..msgData.curPopularity..
            ", 公会名"..msgData.name..
            ", 公会宣言"..msgData.declaration..
            ", 公会公告"..msgData.announcement..
            ", 发展度"..msgData.lv..
            ", 当前成员数量"..msgData.curMemberNum)
    else
        -- 创建错误提示
        UIManager:CreatePrompt_Operate( {
            title = "提示",
            content = getErrorDescribe( msgData.result ),
        } )
    end

    dispatchGlobaleEvent("net", tostring(MSG_MS2C_GUILD_GETINFO), {msgData=msgData})
end


