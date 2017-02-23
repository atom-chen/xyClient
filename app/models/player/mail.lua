--
-- Author: Wu Hengmin
-- Date: 2015-07-24 10:14:46
--
local mail = class("mail");

--邮件guid
mail.guid = "";

--邮件类型 1 系统邮件 2 玩家信息
mail.Type = 1;

--邮件标题
mail.Title = "";

--邮件内容
mail.Content = "";

--附件类型
mail.adjunctType = 0;

-- 物品ID
mail.adjunctID = 0;

-- 物品图标
mail.goodsIcon = "";

--物品数量
mail.adjunctNum = 0;


--邮件删除时间
mail.Sendtime = 60;

--邮件读取标记
mail.Read_Time = 0;

-- 发件人GUID
mail.SendGUID = "";

-- 发件人Name
mail.SendName = "";

function mail:ctor()
	
end

return  mail;
