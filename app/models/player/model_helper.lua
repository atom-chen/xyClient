--
-- Author: Li Yang
-- Date: 2014-06-16 14:12:09
-- 助手数据

local model_helper = class("model_helper");


function model_helper:ctor()
	-------------------基础信息-------------------------
	-- 助手名称
	self.Name = "";
	--助手GUID
	self.GUID = "";
	-- 助手等级
	self.grade = 10;
	-- 团队实力
	self.strength = 1000;
	-- 头衔等级
	self.title = 1;
	--友情值
	self.friendshipValuse = 5;
	self.model_helperType = 1;--助阵者类型
	-------------------助手队长英雄信息----------------------------------
	-- 助手队长英雄
	self.captainhero = nil;

	
end

return model_helper;
