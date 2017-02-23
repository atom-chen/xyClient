--
-- Author: LiYang
-- Date: 2015-07-23 16:25:08
-- 回合前buf 执行

local controller_BoutBufExecute = class("controller_BoutBufExecute")

function controller_BoutBufExecute:ctor()
	
end

--[[设置数据
	inningindex 局数
	boutindex 回合数
	callfun 完成回调
]]
function controller_BoutBufExecute:setData( inningindex ,boutindex ,callfun )
	self:setFinishCallback( callfun );
	self.boutData = Data_Battle_Msg:getBoutData( inningindex ,boutindex );
	print("controller_BoutBufExecute:setData",inningindex ,boutindex,self.boutData)
	if not self.boutData then
		printError("controller_BoutBufExecute: 回合数据为nil");
		return ;
	end
	--执行被动技能
	self.executeBufData = self.boutData.BeforeBoutData;
	self.executeCount = 0;--table.nums(self.executeBufData);--执行数量
	print("self.executeCount",self.executeCount)--执行buf数量
  --   for k,v in pairs(self.executeBufData) do
  --       --执行buf逻辑
  --       --执行角色buf数据
		-- local bufQueueManage = SkillManager:CreateSkillBufExecuteQueue(  );
		-- for index,bufData in ipairs(v.buffData) do
		-- 	if bufData then
		-- 		--添加执行buf
		-- 		bufQueueManage:addExecuteBuffData( bufData );
		-- 	end
		-- end
		-- bufQueueManage:setFinishCallBack(function (  )

		-- 	self.executeCount = self.executeCount - 1;
		-- 	if self.executeCount < 1 then
		-- 		if self.FinishCallback then
		-- 			self.FinishCallback();
		-- 		end
		-- 	end
		-- end);
		-- bufQueueManage:ExecuteBuff( );--执行buf
  --   end
    if self.executeCount < 1 then
    	if self.FinishCallback then
			self.FinishCallback();
		end
    end
end

--设置完成回调函数
function controller_BoutBufExecute:setFinishCallback( callfun )
	self.FinishCallback = callfun;
end

return controller_BoutBufExecute;
