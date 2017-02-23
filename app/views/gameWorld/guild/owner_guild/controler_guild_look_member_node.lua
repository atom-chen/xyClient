--
-- Author: lipeng
-- Date: 2015-08-13 15:03:12
-- 控制器: 查看成员信息

local class_heroIcon = require(FILE_PATH.PATH_VIEWS_UI_TEMPLEATE..".hero_icon")

local controler_guild_look_member_node = class("controler_guild_look_member_node")



function controler_guild_look_member_node:ctor( guild_look_member_node )
	self:_initModels()

	self._guild_look_member_node = guild_look_member_node
	self._panle1 = self._guild_look_member_node:getChildByName("Panel_1")

	self._btn_memberLeave = self._panle1:getChildByName("btn_memberLeave")
	self._btn_jieSan = self._panle1:getChildByName("btn_jieSan")
	self._btn_playerLeave = self._panle1:getChildByName("btn_playerLeave")
	self._btn_fuTuanZhang = self._panle1:getChildByName("btn_fuTuanZhang")
	self._btn_fuTuanZhang_quXiao = self._panle1:getChildByName("btn_fuTuanZhang_quXiao")
	self._btn_zhuanRang = self._panle1:getChildByName("btn_zhuanRang")
	self._btn_friendBattle = self._panle1:getChildByName("btn_friendBattle")
	self._btn_addFriend = self._panle1:getChildByName("btn_addFriend")
	self._btn_sendMail = self._panle1:getChildByName("btn_sendMail")
	self._btn_lookFormation = self._panle1:getChildByName("btn_lookFormation")

	self:_createControlerForUI()
	self:_registUIEvent()
	self:_initBtnLayouts()
end

function controler_guild_look_member_node:updateViews()
	local member = self._member
	local UIContainer = self._panle1
	--英雄Icon
	self._controlerMap.heroIcon:setAvatarByHeroID(member.leaderTempleateID)

	--玩家名
	UIContainer:getChildByName("name"):setString(member.playerName)

	--玩家等级
	UIContainer:getChildByName("lv_value"):setString(member.playerLv)
	
	--玩家职位
	local postName = guildOfficialConfig[member.post].OffName
	UIContainer:getChildByName("text_post"):setString(postName)

	--总贡献
    UIContainer:getChildByName("zgx_value"):setString(member.dkp)
	
	--上线状态
    -- local surplusTime = clientTimeToServerTime(os.time()) - memberInfo.lastLoginTime
    -- local day , hour ,minute = TimeBySecond( surplusTime )
    -- local timeStr = ""
    -- if day > 0 then
    --     timeStr = day.."天"
    -- elseif hour > 0 then
    --     timeStr = hour.."小时"
    -- elseif minute > 0 then
    --     timeStr = minute.."分钟"
    -- else
    --     --最小上线时间间隔为1分钟
    --     timeStr = "1分钟"
    -- end

    -- itemOfRootNode.lastLoginTime:setString("登陆: "..timeStr.."前")
    if member.onlineState == 1 then
    	UIContainer:getChildByName("onlineState"):setColor(cc.c3b(0, 128, 0))
        UIContainer:getChildByName("onlineState"):setString("在线")
    else
    	UIContainer:getChildByName("onlineState"):setColor(cc.c3b(255, 0, 0))
        UIContainer:getChildByName("onlineState"):setString("离线")
    end

    local mainPlayerPost = MAIN_PLAYER:getGuild():getPost()
    local mainPlayerName = MAIN_PLAYER:getBaseAttr():getName()
    local buttonLayoutID = -1

	--如果自己是会长
	if mainPlayerPost == 1 then
		--查看的是自己
		if member.playerName == mainPlayerName then
			buttonLayoutID = 1

		--查看的是他人
		else
			--不是副团长
            if member.post ~= 2 then
                buttonLayoutID = 3
            else
                buttonLayoutID = 2
            end
		end

    --如果自己是副会长
    elseif mainPlayerPost == 2 then
        --查看的是自己
        if member.playerName == mainPlayerName then
            buttonLayoutID = 4

        --查看的是他人
        else
        	--不是团长
            if member.post ~= 1 then
                buttonLayoutID = 5
            else
                buttonLayoutID = 6
            end
        end

	--非会长
	else
		--查看的是自己
		if member.playerName == mainPlayerName then
			buttonLayoutID = 7

		--查看的是他人
		else
			buttonLayoutID = 8
		end
	end

	self:_updateButtonLayout(buttonLayoutID)
end

function controler_guild_look_member_node:getView()
	return self._guild_look_member_node
end

function controler_guild_look_member_node:addEventListener( callBack )
	self._controlerEventCallBack = callBack
end

function controler_guild_look_member_node:setMember(member)
	self._member = member
end


function controler_guild_look_member_node:_initModels()
	self._controlerEventCallBack = nil
	self._controlerMap = {}
	self._member = nil
end


--创建控制器: UI
function controler_guild_look_member_node:_createControlerForUI()
    self._controlerMap.heroIcon = UIManager:CreateAvatarPart(
		0, 
		{resourceNode = self._panle1:getChildByName("heroicon")}
	)
end


function controler_guild_look_member_node:_registUIEvent()
	
	--请离军团
	local function btn_memberLeaveTouched( sender,eventType )
		if eventType == ccui.TouchEventType.ended then
			--发送请离军团请求
			printNetLog("发送请离军团请求(MSG_C2MS_GUILD_MAKEMEMBER_QUITGUILD)")
			local sendData = {}
			sendData[1] = self._member.playerName
			sendData[2] = self._member.playerGUID
	        gameTcp:SendMessage(MSG_C2MS_GUILD_MAKEMEMBER_QUITGUILD, sendData)
        end
	end
	self._btn_memberLeave:addTouchEventListener(btn_memberLeaveTouched)

	--解散军团
	local function btn_jieSanTouched( sender,eventType )
		if eventType == ccui.TouchEventType.ended then
			--发送解散公会请求
			printNetLog("发送解散公会请求(MSG_C2MS_GUILD_DISSOLVE)")
        	gameTcp:SendMessage(MSG_C2MS_GUILD_DISSOLVE)
        end
	end
	self._btn_jieSan:addTouchEventListener(btn_jieSanTouched)


	--退出军团
	local function btn_playerLeaveTouched( sender,eventType )
		if eventType == ccui.TouchEventType.ended then
			--发送退出军团请求
	        printNetLog("发送退出军团请求: MSG_C2MS_GUILD_MEMBER_QUITGUILD")
	        gameTcp:SendMessage(MSG_C2MS_GUILD_MEMBER_QUITGUILD)
        end
	end
	self._btn_playerLeave:addTouchEventListener(btn_playerLeaveTouched)


	--设置为副团长
	local function btn_fuTuanZhangTouched( sender,eventType )
		if eventType == ccui.TouchEventType.ended then
			--发送设置副会长请求
			printNetLog("发送设置副会长请求(MSG_C2MS_SET_GUANZHI)")

	        gameTcp:SendMessage(MSG_C2MS_SET_GUANZHI ,{
	            self._member.playerGUID,
	            2
	        })
        end
	end
	self._btn_fuTuanZhang:addTouchEventListener(btn_fuTuanZhangTouched)

	--取消副团长
	local function btn_fuTuanZhang_quXiaoTouched( sender,eventType )
		if eventType == ccui.TouchEventType.ended then
			--发送取消副会长请求
			printNetLog("发送取消副会长请求(MSG_C2MS_SET_GUANZHI)")

			gameTcp:SendMessage(MSG_C2MS_SET_GUANZHI ,{
	            self._member.playerGUID,
	            4
	        })
        end
	end
	self._btn_fuTuanZhang_quXiao:addTouchEventListener(btn_fuTuanZhang_quXiaoTouched)

	--转让军团
	local function btn_zhuanRangTouched( sender,eventType )
		if eventType == ccui.TouchEventType.ended then
			--转让军团给副团长
			printNetLog("转让军团给副团长(MSG_C2MS_ZHUANRANG_GUILD)")
	        gameTcp:SendMessage(MSG_C2MS_ZHUANRANG_GUILD)
        end
	end
	self._btn_zhuanRang:addTouchEventListener(btn_zhuanRangTouched)

	--好友战斗
	local function btn_friendBattleTouched( sender,eventType )
		if eventType == ccui.TouchEventType.ended then
			
        end
	end
	self._btn_friendBattle:addTouchEventListener(btn_friendBattleTouched)

	--添加好友
	local function btn_addFriendTouched( sender,eventType )
		if eventType == ccui.TouchEventType.ended then
			gameTcp:SendMessage(
				MSG_C2MS_FRIEND_APPLY_NAME, 
				{self._member.playerName}
			)
        end
	end
	self._btn_addFriend:addTouchEventListener(btn_addFriendTouched)

	--发送邮件
	local function btn_sendMailTouched( sender,eventType )
		if eventType == ccui.TouchEventType.ended then
			
        end
	end
	self._btn_sendMail:addTouchEventListener(btn_sendMailTouched)

	--查看阵型
	local function btn_lookFormationTouched( sender,eventType )
		if eventType == ccui.TouchEventType.ended then
			
        end
	end
	self._btn_lookFormation:addTouchEventListener(btn_lookFormationTouched)


    --退出
	local button_exit = self._panle1:getChildByName("button_exit")
	local function button_exitTouched( sender,eventType )
		if eventType == ccui.TouchEventType.ended then
			self:_doEventCallBack(sender, "button_exitTouched")
        end
	end
	button_exit:addTouchEventListener(button_exitTouched)
end


--初始化button布局
function controler_guild_look_member_node:_initBtnLayouts()
	self._btnLayouts = {
		--自己是军团长, 查看的是自己
		[1] = {"军团转让", "解散军团"},
		--自己是军团长, 查看的是副团长
		[2] = {"请离军团", "加为好友", "发送邮件", "取消副团长"},
		--自己是军团长, 查看的是非副团长
		[3] = {"请离军团", "加为好友", "发送邮件", "设置副团长"},
		--自己是副团长, 查看的是自己
		[4] = {"退出军团"},
		--自己是副团长, 查看的是军团长
		[5] = {"加为好友", "发送邮件"},
		--自己是副团长, 查看的非军团长
		[6] = {"请离军团", "加为好友", "发送邮件"},
		--自己是成员, 查看的是自己
		[7] = {"退出军团"},
		--自己是成员, 查看的是其他成员
		[8] = {"加为好友", "发送邮件"},
	}
end

--通过button在布局中的名字, 获取button
function controler_guild_look_member_node:_getButtonWithLayoutName( name )
	local btn = nil
	local UIContainer = self._panle1

	if name == "请离军团" then
		btn = self._btn_memberLeave

	elseif name == "解散军团" then
		btn = self._btn_jieSan

	elseif name == "退出军团" then
		btn = self._btn_playerLeave

	elseif name == "设置副团长" then
		btn = self._btn_fuTuanZhang

	elseif name == "取消副团长" then
		btn = self._btn_fuTuanZhang_quXiao

	elseif name == "军团转让" then
		btn = self._btn_zhuanRang

	elseif name == "切磋" then
		btn = self._btn_friendBattle

	elseif name == "加为好友" then
		btn = self._btn_addFriend

	elseif name == "发送邮件" then
		btn = self._btn_sendMail

	elseif name == "查看阵容" then
		btn = self._btn_lookFormation
	end

	return btn
end

--根据布局ID更新button的布局
function controler_guild_look_member_node:_updateButtonLayout(layoutID)
	
	self._btn_memberLeave:setVisible(false)

	self._btn_jieSan:setVisible(false)

	self._btn_playerLeave:setVisible(false)

	self._btn_fuTuanZhang:setVisible(false)

	self._btn_fuTuanZhang_quXiao:setVisible(false)

	self._btn_zhuanRang:setVisible(false)

	self._btn_friendBattle:setVisible(false)

	self._btn_addFriend:setVisible(false)

	self._btn_sendMail:setVisible(false)

	self._btn_lookFormation:setVisible(false)


	local layout = self._btnLayouts[layoutID]

	for i,v in ipairs(layout) do
		print(i, v)
		local btn = self:_getButtonWithLayoutName(v)
		local posNode = self._panle1:getChildByName("btn"..i.."pos")
		btn:setPosition(posNode:getPosition())
		btn:setVisible(true)
	end
end


function controler_guild_look_member_node:_doEventCallBack( sender, eventName, data )
	if self._controlerEventCallBack ~= nil then
		self._controlerEventCallBack(sender, eventName, data)
	end
end

return controler_guild_look_member_node


