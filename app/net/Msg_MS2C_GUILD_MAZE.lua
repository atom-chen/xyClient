--
-- Author: lipeng
-- Date: 2015-05-11 09:18:24
-- 军团迷宫消息

-- 发送迷宫数据
-- *	int		迷宫ID
-- *	int		层ID
-- *	int		探索度
-- *	int		PK值
-- *	int		掉落数量
-- *	{
-- *		int		掉落类型
-- *		int		掉落ID
-- *		int		掉落等级
-- *		int		掉落数量
-- *	}
Msg_Logic[MSG_MS2C_GUILD_MAZE_INFO] = function ( tcp , msg  )
	
end



-- 错误代码
Msg_Logic[MSG_MS2C_GUILD_MAZE_ERROR] = function ( tcp , msg  )
	
end


-- 更新地图ID
Msg_Logic[MSG_MS2C_GUILD_MAZE_UPDATE_IN] = function ( tcp , msg  )
	
end


-- 更新地图层ID
Msg_Logic[MSG_MS2C_GUILD_MAZE_UPDATE_FLOOR] = function ( tcp , msg  )
	
end

-- 更新探索度
Msg_Logic[MSG_MS2C_GUILD_MAZE_UPDATE_DEPTH] = function ( tcp , msg  )
	
end


--常规事件
Msg_Logic[MSG_MS2C_GUILD_MAZE_EVENT_NORMAL] = function ( tcp , msg  )
	
end


-- 遇到怪物
Msg_Logic[MSG_MS2C_GUILD_MAZE_EVENT_MONSTER] = function ( tcp , msg  )
    
end


-- 与小怪（精英）战斗结果
Msg_Logic[MSG_MS2C_GUILD_MAZE_BATTLE_RESULT_MONSTER] = function ( tcp , msg  )
	
end


-- 遇到BOSS（通知玩家选择参战队伍）
Msg_Logic[MSG_MS2C_GUILD_MAZE_EVENT_BOSS] = function ( tcp , msg  )
	
end



-- 与boss战斗结果
Msg_Logic[MSG_MS2C_GUILD_MAZE_BATTLE_RESULT_BOSS] = function ( tcp , msg  )
	
end




-- 遭遇玩家
-- *	string		玩家ID
-- *	string		玩家名字
-- *	int			玩家等级
-- *	int			玩家PK值
Msg_Logic[MSG_MS2C_GUILD_MAZE_MEETING] = function ( tcp , msg  )
	
end



-- 打劫结果
Msg_Logic[MSG_MS2C_GUILD_MAZE_ROBBED_RESULT] = function ( tcp , msg  )
	
end



-- 被打劫通知
-- *	string		打劫者名称
-- *	int			被劫物资数量
-- *	{
-- *		int		物资类型
-- *		int		物资ID
-- *		int		物资等级
-- *		int		物资数量
-- *	}
Msg_Logic[MSG_MS2C_GUILD_MAZE_BE_ROBBED] = function ( tcp , msg  )
	
end


-- 探索度事件通知
Msg_Logic[MSG_MS2C_GUILD_MAZE_DEPTH_EVENT] = function ( tcp , msg  )
	
end




-- 宝箱事件通知
Msg_Logic[MSG_MS2C_GUILD_MAZE_BOX_EVENT] = function ( tcp , msg  )
	
end



-- 挑战事件通知
Msg_Logic[MSG_MS2C_GUILD_MAZE_CHALLENGE_EVENT] = function ( tcp , msg  )
	
end




-- 挑战事件战斗结果
Msg_Logic[MSG_MS2C_GUILD_MAZE_BATTLE_RESULT_CHALLENGE] = function ( tcp , msg  )
	
end



-- 置换事件通知
Msg_Logic[MSG_MS2C_GUILD_MAZE_SWAP_EVENT] = function ( tcp , msg  )
	
end



-- 置换事件结果
Msg_Logic[MSG_MS2C_GUILD_MAZE_SWAP_EVENT_RESULT] = function ( tcp , msg  )
	
end



-- 选择事件通知
Msg_Logic[MSG_MS2C_GUILD_MAZE_SELECT_EVENT] = function ( tcp , msg  )
	
end



-- 选择事件结果
Msg_Logic[MSG_MS2C_GUILD_MAZE_SELECT_EVENT_RESULT] = function ( tcp , msg  )
	
end



--军团战——军团排名更新
Msg_Logic[MSG_MS2C_GUILD_MAZE_RACE_RANK_UPDATE] = function ( tcp , msg )
    
end


--军团战：个人贡献更新
Msg_Logic[MSG_MS2C_GUILD_MAZE_RACE_PLYAER_INFO_UPDATE] = function ( tcp , msg )
    
end


--军团战：军团排行榜（已排序）
Msg_Logic[MSG_MS2C_GUILD_MAZE_RACE_RANK] = function ( tcp , msg )
    
end



--军团战：军团成员贡献表（客户端自己排序）
Msg_Logic[MSG_MS2C_GUILD_MAZE_RACE_MEMBER_LIST] = function ( tcp , msg )
    
end

